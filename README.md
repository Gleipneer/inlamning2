Inlämning 2 – Databaser  
Joakim Emilsson – YH25 

Syftet med databasen är att hålla koll på kunder, böcker och beställningar i en liten bokhandel. 
Systemet ska visa vilka böcker som finns i lager, vilka som är köpta, av vem och när.
I inlämning 2 har jag byggt vidare på detta system för att även hantera automatiska loggar, bättre sökningar och backup.

Jag valde att dela upp databasen i fem tabeller – Kunder, Böcker, Beställningar, Orderrader och Kundlogg – för att undvika dubbel data och få tydliga relationer. 
En kund kan göra flera beställningar, och varje beställning kan innehålla flera böcker.
Orderrader används därför för att koppla samman vilka böcker som ingår i varje beställning.

---

Databasens tabeller

	Kunder

Lagrar information om kunder som kan göra beställningar.
Nytt för denna inlämning är ett index på Email för snabbare sökningar.
Attribut: KundID, Namn, Email, Telefon, Adress, Registreringsdatum.

	Böcker

Lagrar butikens böcker.
Nytt för inlämning 2 är en constraint som tvingar priset att alltid vara över noll.
Attribut: BokID, Titel, ISBN, Författare, Pris, Lagerstatus.

	Beställningar

Representerar köp som kunder gör.  
Attribut: OrderID, KundID, Datum, Totalbelopp.

	Orderrader

Fungerar som en kopplingstabell mellan Beställningar och Böcker. Den möjliggör den många till många relation som uppstår när en beställning kan innehålla flera böcker och en bok kan förekomma i flera beställningar.
Attribut: OrderradID, OrderID, BokID, Antal, Radpris.

	Kundlogg (Ny tabell)

En loggtabell som sparar information när en trigger registrerar en ny kund.

---

	Relationer

En kund kan göra flera beställningar.  
En beställning kan innehålla flera böcker. 

För att hantera detta skapar man tabellen orderrader, som fungerar som en kopplingstabell mellan Beställningar och Böcker.

Orderrader gör att samma bok kan förekomma i flera beställningar och att en beställning kan innehålla flera böcker. Detta behövs för att normalisera databasen, vilket betyder att varje tabell ska innehålla en typ av information och att onödig dubbellagring undviks. Det gör databasen tydligare och bättre att söka i.

Den nya tabellen Kundlogg har också en relation till Kunder. En kund kan ha flera logghändelser.
 
---

	Nytt i inlämning 2

Utöver strukturen har databasen utvecklats med nya funktioner:

Triggers
En trigger (trigga_ny_kund_logg) loggar automatiskt i Kundlogg när en ny kund registreras.
En andra trigger (trigga_minska_lager) minskar lagersaldot för böcker automatiskt när en order läggs in i Orderrader. 

Transaktioner
Jag har använt transaktioner med kommandot ROLLBACK för att säkert kunna uppdatera kunders information och ta bort data, med möjligheten att ångra ändringarna.

Sökningar och filtrering
Databasen har nu mer avancerade sökningar som JOINs (för att se köp kopplat till rätt person), samt GROUP BY och HAVING för att smidigt kunna räkna ut vilka kunder som handlat mer än två gånger.

Backup och återställning
Jag har skapat en backup av hela databasen för att kunna återställa all data om systemet skulle krascha.

---

	Reflektioner

När jag byggde tabellen Bocker fick jag fundera på vilken datatyp som passade bäst för ISBN. Jag började med INT, testade även VARCHAR, men valde till sist BIGINT. Anledningen var att ISBN är för långt för INT, medan BIGINT klarar långa numeriska värden bättre och därför passade bäst i denna uppgift.

Prestanda vid 100 000 kunder
I uppgiften skulle vi reflektera över hur strukturen skulle påverkas av 100 000 kunder i stället för 10.
Med små datamängder går alla sökningar snabbt, men med 100 000 kunder och enorma mängder ordrar skulle databasen snabbt bli långsam utan optimering.
För att hantera en så stor skala skulle jag behöva införa fler index. Just nu har jag endast index på Email, men i en storskalig butik hade jag behövt indexera kolumner som Namn och Datum, eftersom dessa ofta används i sökningar.
Jag gjorde vid ett tillfälle ett stresstest på databasen genom att lägga till 200 000 användare i ett kör med ett C# liknande skript. Sedan sökta jag efter användare (tog ca 04 sekunder) därefter sökte jag genom index (mailadress) och det tog 0.00 sekunder. 

	Svårigheter

Val av rätt datatyper.
Vilken datatyp man använder avgör hur säker, korrekt och sökbar datan blir. Dessutom när man är ny inom db området är det svårt att veta vilka datatyper som är bäst att använda.

Att förstå varför orderrader (många till många) behövs.
Utan Orderrader hade strukturen blivit fel och svår att söka i.

Vad är normalisering?
Det tog ett tag innan jag förstod normaliseringen.
Inget ska upprepas i onödan, varje tabell ska representera en sak och varje kolumn ska hålla ett värde.

---

# Restore från backup i MySQL Workbench

1. Öppna `Server -> Data Import`
2. Välj `Import from Self-Contained File`
3. Välj filen `bokhandel_backup.sql`
4. Välj eller skapa `Default Target Schema`
5. Klicka `Start Import`

# Verifiering efter restore

    sql
USE inlamning2;
SHOW TABLES;
SELECT * FROM kunder;
SELECT * FROM bocker;
SELECT * FROM bestallningar;
SELECT * FROM orderrader;
SELECT * FROM kundlogg;
SHOW TRIGGERS;

	Filer & Diagram

Filer i repot:
inlamning2.sql (SQL koden)
bokhandel_backup.sql (Databasbackup)
README.md (Denna fil)

Diagrammet finns här:
images/er-diagram.png