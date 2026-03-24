/*
SQL inlämningsuppgift "En liten bokhandel".
Joakim Emilsson - YH24
*/

-- Tar bort databasen om den redan finns så att filen går att köra om från början
DROP DATABASE IF EXISTS inlamning2;

-- Skapa databasen
CREATE DATABASE inlamning2
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Välj att arbeta i databasen inlamning2
USE inlamning2;

-- Tabell: Kunder
-- Här sparas information om kunder
CREATE TABLE Kunder (
    KundID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Telefon VARCHAR(20) UNIQUE,
    Adress VARCHAR(100) NOT NULL,
    Registreringsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Skapar ett index på Email i tabellen Kunder
CREATE INDEX idx_kunder_email ON Kunder(Email);

-- Tabell: Bocker
-- Här sparas butikens böcker
CREATE TABLE Bocker (
    BokID INT AUTO_INCREMENT PRIMARY KEY,
    Titel VARCHAR(255) NOT NULL,
    ISBN BIGINT UNIQUE NOT NULL,
    Forfattare VARCHAR(255) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL CHECK (Pris > 0),
    Lagerstatus INT DEFAULT 0
);

-- Tabell: Bestallningar
-- Här sparas varje beställning som en kund gör
CREATE TABLE Bestallningar (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT NOT NULL,
    Datum DATE NOT NULL,
    Totalbelopp DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID)
);

-- Tabell: Orderrader
-- Detta är kopplingstabellen mellan beställningar och böcker
CREATE TABLE Orderrader (
    OrderradID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    BokID INT NOT NULL,
    Antal INT NOT NULL,
    Radpris DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Bestallningar(OrderID),
    FOREIGN KEY (BokID) REFERENCES Bocker(BokID)
);

-- Tabell: Kundlogg
-- Denna tabell används av triggern som loggar när en ny kund registreras
CREATE TABLE Kundlogg (
    LoggID INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT NOT NULL,
    Namn VARCHAR(100) NOT NULL,
    Handelse VARCHAR(100) NOT NULL,
    Tidpunkt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID)
);

-- Trigger: trigga_ny_kund_logg
-- Denna trigger loggar automatiskt när en ny kund läggs in i tabellen Kunder
DELIMITER //

CREATE TRIGGER trigga_ny_kund_logg
AFTER INSERT ON Kunder
FOR EACH ROW
BEGIN
    INSERT INTO Kundlogg (KundID, Namn, Handelse)
    VALUES (NEW.KundID, NEW.Namn, 'Ny kund registrerad');
END //

DELIMITER ;

-- Trigger: trigga_minska_lager
-- minskar lagersaldo när en ny orderrad läggs in
DELIMITER //

CREATE TRIGGER trigga_minska_lager
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    UPDATE Bocker
    SET Lagerstatus = Lagerstatus - NEW.Antal
    WHERE BokID = NEW.BokID;
END //

DELIMITER ;

-- Testdata: Kunder
-- Här lägger jag in fyra kunder 
INSERT INTO Kunder (Namn, Email, Telefon, Adress) VALUES
    ('Joakim Emilsson', 'emilssonjoakim@gmail.com', '0760178885', 'Alsteråvägen 42'),
    ('Johan Johansson', 'johanssonjohan@gmail.com', '0702222222', 'Parkvägen 5'),
    ('Cecilia Holm', 'holmcecilia@gmail.com', '0703333333', 'Havsgatan 12'),
    ('Anna Svensson', 'anna.svensson@gmail.com', '0704444444', 'Skolgatan 9');

-- Denna SELECT visar alla kunder i tabellen Kunder
SELECT * FROM Kunder;

-- Testdata: Bocker
-- Här lägger jag in fyra böcker
INSERT INTO Bocker (Titel, ISBN, Forfattare, Pris, Lagerstatus) VALUES
    ('Pojken och Äventyret', 123124135235132, 'Jonsered Backen', 79.90, 200),
    ('Tiden som Tickade', 1231352453214, 'Temu Toskinen', 12.90, 75),
    ('JionDao och Kranen', 1343453234, 'Irma Svensson', 89.00, 31),
    ('Databas för Nybörjare', 9781234567890, 'Fredrik Lorensson', 199.00, 15);

-- Denna SELECT visar alla böcker i tabellen Bocker
SELECT * FROM Bocker;

-- Testdata: Bestallningar
INSERT INTO Bestallningar (KundID, Datum, Totalbelopp) VALUES
    (1, '2025-01-02', 159.80),
    (2, '2025-02-03', 51.60),
    (1, '2025-03-10', 89.00),
    (1, '2025-03-15', 199.00),
    (3, '2025-03-18', 79.90);

-- Denna SELECT visar alla beställningar i tabellen Bestallningar
SELECT * FROM Bestallningar;

-- Testdata: Orderrader
-- Här kopplas böcker till beställningar och Radpris visar summan för varje orderrad
INSERT INTO Orderrader (OrderID, BokID, Antal, Radpris) VALUES
    (1, 1, 2, 159.80),
    (2, 2, 4, 51.60),
    (3, 3, 1, 89.00),
    (4, 4, 1, 199.00),
    (5, 1, 1, 79.90);

-- Denna SELECT visar alla orderrader i tabellen Orderrader
SELECT * FROM Orderrader;

-- PRESENTATIONSTIPS: Denna SELECT bevisar att triggern "trigga_minska_lager" har fungerat!
-- (Till exempel: Bok 1 startade på 200 i lager, nu borde den ha minskat)
SELECT BokID, Titel, Lagerstatus FROM Bocker;

-- Denna SELECT visar att triggern för Kundlogg fungerar
SELECT * FROM Kundlogg;

-- Denna SELECT hämtar alla kunder
SELECT * FROM Kunder;

-- Denna SELECT hämtar alla beställningar
SELECT * FROM Bestallningar;

-- Denna SELECT använder WHERE för att visa en specifik kund utifrån namn
SELECT *
FROM Kunder
WHERE Namn = 'Joakim Emilsson';

-- Denna SELECT använder WHERE för att visa kunder med gmail-adress
SELECT *
FROM Kunder
WHERE Email LIKE '%gmail.com';

-- Denna SHOW bevisar för läraren att indexet på Email faktiskt är skapat
SHOW INDEX FROM Kunder;

-- Denna SELECT använder ORDER BY för att sortera böcker efter pris från lägst till högst, ascending alltså.
SELECT *
FROM Bocker
ORDER BY Pris ASC;

-- Denna JOIN visar vilka böcker som ingår i varje order
SELECT
    Orderrader.OrderID,
    Bocker.Titel,
    Orderrader.Antal,
    Orderrader.Radpris
FROM Orderrader
JOIN Bocker ON Orderrader.BokID = Bocker.BokID;

-- Detta är en INNER JOIN som visar vilka kunder som har lagt beställningar
-- Bara kunder som faktiskt har en beställning kommer med i resultatet
SELECT
    Kunder.KundID,
    Kunder.Namn,
    Bestallningar.OrderID,
    Bestallningar.Datum
FROM Kunder
INNER JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID;

-- Detta är en LEFT JOIN som visar alla kunder, även de som inte har lagt någon beställning
-- Kunder utan beställning  (Anna Svensson) får då NULL på orderuppgifterna 
SELECT
    Kunder.KundID,
    Kunder.Namn,
    Bestallningar.OrderID,
    Bestallningar.Datum
FROM Kunder
LEFT JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID;

-- Denna SELECT använder GROUP BY för att räkna hur många beställningar varje kund har gjort
SELECT
    Kunder.KundID,
    Kunder.Namn,
    COUNT(Bestallningar.OrderID) AS AntalBestallningar
FROM Kunder
LEFT JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID
GROUP BY Kunder.KundID, Kunder.Namn;

-- Denna SELECT använder HAVING för att bara visa kunder som har gjort fler än 2 beställningar
SELECT
    Kunder.KundID,
    Kunder.Namn,
    COUNT(Bestallningar.OrderID) AS AntalBestallningar
FROM Kunder
LEFT JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID
GROUP BY Kunder.KundID, Kunder.Namn
HAVING COUNT(Bestallningar.OrderID) > 2;

-- Detta är en transaktion med UPDATE
-- Här uppdaterar jag en kunds e-postadress (min egen!)
START TRANSACTION;
UPDATE Kunder
SET Email = 'joakim.nyepost@gmail.com'
WHERE KundID = 1;

-- Denna SELECT visar ändringen innan jag ångrar den
SELECT * FROM Kunder WHERE KundID = 1;

-- Här ångrar jag ändringen med ROLLBACK
ROLLBACK;

-- Denna SELECT visar att ändringen inte sparades
SELECT * FROM Kunder WHERE KundID = 1;

-- Detta är en transaktion med DELETE
-- Eftersom Kundlogg har foreign key till Kunder tar jag först bort loggraden för kunden
-- Sedan tar jag bort kunden och ångrar allt med ROLLBACK
START TRANSACTION;
DELETE FROM Kundlogg
WHERE KundID = 4;
DELETE FROM Kunder
WHERE KundID = 4;

-- Denna SELECT visar kunderna innan jag ångrar borttagningen
SELECT * FROM Kunder;

-- Här ångrar jag borttagningen med ROLLBACK
ROLLBACK;

-- Denna SELECT visar att kunden inte togs bort på riktigt
SELECT * FROM Kunder;

-- Skapa en tom testdatabas för restore to backup testet
DROP DATABASE IF EXISTS inlamning2_restoretest;
CREATE DATABASE inlamning2_restoretest
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
-- Återställer från backup
USE inlamning2_restoretest;
SHOW TABLES;
SHOW DATABASES;

USE inlamning2;
SHOW TABLES;

USE inlamning2_restoretest;
SHOW TABLES;

-- Stresstest, C# liknande iterationer, ångest!
USE inlamning2;

DELIMITER //

CREATE PROCEDURE StresstestaKunder()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    START TRANSACTION;
    
    WHILE i <= 200000 DO      
        INSERT IGNORE INTO Kunder (Namn, Email, Telefon, Adress)
        VALUES (
            CONCAT('TestKund ', i), 
            CONCAT('test', i, '@gmail.com'), 
            CONCAT('075', LPAD(i, 7, '0')), 
            'Stressgatan 1'
        );
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //

DELIMITER ;

-- 1. Detta kommando KÖR loopen och skapar 200 000 kunder Även triggen triggas.
CALL StresstestaKunder();


-- använder Index och går supersnabbt trots 200 000 Kunder:
SELECT * FROM Kunder WHERE Email = 'test199999@gmail.com';
-- Jämför: Sökning på Namn (saknar Index) vilket tvingar databasen att "läsa" / scanna alla 200 000 kunder = går mycket långsammare.
SELECT * FROM Kunder WHERE Namn = 'TestKund 199999';


SHOW INDEX FROM Kunder;


