Inlämning 2 – Databaser  
Joakim Emilsson – YH24  

Syftet med databasen är att hålla koll på kunder, böcker och beställningar i en liten bokhandel. 
Systemet ska visa vilka böcker som finns i lager, vilka som är köpta, av vem och när.
I inlämning 2 har jag byggt vidare på detta system för att även hantera automatiska loggar, säkerhet och bättre sökningar.

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

Fungerar som en kopplingstabell (jointable), mellan Beställningar och Böcker. Den möjliggör den många till många relation som uppstår när en beställning kan innehålla flera böcker och en bok kan förekomma i flera beställningar.
Attribut: OrderradID, OrderID, BokID, Antal, Radpris.

	Kundlogg (Ny tabell)

En säkerhetstabell som sparar information när en styrsignal (trigger) upptäcker att en ny kund registreras.
Attribut: LoggID, KundID, Namn, Händelse, Tidpunkt.

---

	Relationer

En kund kan göra flera beställningar.  
En beställning kan innehålla flera böcker. 

För att hantera detta skapar man tabellen orderrader, som fungerar som en kopplingstabell mellan Beställningar och Böcker.

Orderrader gör att samma bok kan förekomma i flera beställningar och att en beställning kan innehålla flera böcker. Detta är nödvändigt för att "normalisera" databasen, vilket innebär att: varje tabell ska innehålla en sak, varje kolumn ska ha ett värde per cell och att ingen data ska dupliceras i onödan. Som jag förstått det blir databasen även effektivare att söka i och långt mer prestanda effektiv i synnerhet i stora databaser.

Den nya tabellen Kundlogg har också en relation till Kunder. En kund kan ha flera logghändelser.
 
---

	Nytt i inlämning 2

Utöver strukturen har databasen utvecklats med nya funktioner:

Triggers
En trigger (trigga_ny_kund_logg) loggar automatiskt i Kundlogg när en ny kund registreras.
En andra trigger (trigga_minska_lager) minskar lagersaldot för böcker automatiskt när en order läggs in i Orderrader. 

Transaktioner
Jag har använt transaktioner med kommandot ROLLBACK för att säkert kunna uppdatera kunders information och ta bort data, med möjligheten att ångra ändringarna om något går fel i processen.

Sökningar och filtrering
Databasen har nu mer avancerade sökningar som JOINs (för att se köp kopplat till rätt person), samt GROUP BY och HAVING för att smidigt kunna räkna ut vilka kunder som handlat mer än två gånger.

Backup och återställning
Jag har skapat en backup av hela databasen för att kunna återställa all data om systemet skulle krascha.

---

	Reflektioner

När jag byggde tabellen Bocker fick jag problem med vilken datatyp jag skulle använda för kolumnen ISBN. Det som först såg enkelt ut visade sig ha flera praktiska fallgropar, och jag var tvungen att testa mig fram genom olika lösningar.

1. Jag började med INT
Först satte jag ISBN som INT, eftersom ISBN består av siffror. Det gav ganska snart problem.
ISBN är för långa för en vanlig INT

2. Jag bytte till VARCHAR
Mitt nästa steg var att ändra ISBN till VARCHAR, vilket löste problemet med längden. Men detta skapade nya frågor:
VARCHAR tillåter även bokstäver, även om ISBN ska vara numeriska
MySQL validerar inte om man råkar skriva "ABC123"
Det gör inmatningen mer flexibel, men mindre säker.
Jag insåg att VARCHAR funkar, men inte ger någon kontroll över att värdet verkligen är numeriskt.

3. Slutligt val: BIGINT
Efter att ha provat båda alternativen och samtalat med läraren om problemet så valde jag BIGINT:
BIGINT klarar upp till 19 siffror → perfekt för ISBN.
MySQL validerar automatiskt att värdet är numeriskt
Data blir mer konsekvent och lättare att söka/filtrera på
Detta blev den bästa kompromissen för just denna uppgift.

Prestanda vid 100 000 kunder
I uppgiften skulle vi reflektera över hur strukturen skulle påverkas av 100 000 kunder i stället för 10.
Med små datamängder går alla sökningar snabbt, men med 100 000 kunder och enorma mängder ordrar skulle databasen snabbt bli långsam utan optimering.
För att hantera en så stor skala skulle jag behöva införa fler index. Just nu har jag endast index på Email, men i en storskalig butik hade jag behövt indexera kolumner som Namn och Datum, eftersom dessa ofta används i sökningar och kvartalsrapporter. Jag hade sannolikt också behövt bryta ut äldre färdiga beställningar till ett eget arkiv så att systemet slipper gå igenom fem år gamla ordrar vid varje daglig sökning.


	Svårigheter

Val av rätt datatyper.
Vilken datatyp man använder avgör hur säker, korrekt och sökbar datan blir.

Att förstå varför orderrader (många till många) behövs.
Utan Orderrader hade strukturen blivit fel och svår att söka i.

Vad är normalisering?
Det tog ett tag innan jag förstod normaliseringen.
Inget ska upprepas i onödan, varje tabell ska representera en sak och varje kolumn ska hålla ett värde.

---

	Filer & Diagram

Filer i repot:
inlamning2.sql (SQL koden)
inlamning2backup.sql (Databasbackup)
README.md (Denna fil)

Diagrammet finns här:
images/er-diagram.png