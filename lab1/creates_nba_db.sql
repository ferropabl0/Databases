DROP SCHEMA IF EXISTS nba_db;
CREATE DATABASE IF NOT EXISTS nba_db
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE nba_db;
DROP TABLE IF EXISTS Person;
CREATE TABLE IF NOT EXISTS Person (
	IDNumber INT UNSIGNED NOT NULL,
    PersonName VARCHAR(30) NOT NULL,
    Surname VARCHAR(30) NOT NULL,
    Nationality VARCHAR(30) NOT NULL,
    Gender VARCHAR(1) NOT NULL,
    BirthDate DATE DEFAULT NULL,
    CONSTRAINT PK_Person PRIMARY KEY (IDNumber)
    );
    
DROP TABLE IF EXISTS Conference;
CREATE TABLE IF NOT EXISTS Conference (
	CName VARCHAR(30) NOT NULL,
    Location VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Conference PRIMARY KEY (CName)
);

DROP TABLE IF EXISTS Arena;
CREATE TABLE IF NOT EXISTS Arena (
	AName VARCHAR(30) NOT NULL,
    City VARCHAR(30) NOT NULL,
    Capacity INT NOT NULL,
    CONSTRAINT PK_Arena PRIMARY KEY (AName)
);

DROP TABLE IF EXISTS Franchise;
CREATE TABLE IF NOT EXISTS Franchise (
	FName VARCHAR(30) NOT NULL,
    HomeCity VARCHAR(30) NOT NULL,
    AnnualBudget INT NOT NULL,
    NBARings INT UNSIGNED NULL,
    IDCoach INT NOT NULL,
    Conference VARCHAR(30) NOT NULL,
    Arena VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Franchise_Conference FOREIGN KEY (Conference) REFERENCES Conference(CName),
    CONSTRAINT FK_Franchise_Arena FOREIGN KEY (Arena) REFERENCES Arena(AName),
    CONSTRAINT PK_Franchise PRIMARY KEY (FName)
);

DROP TABLE IF EXISTS Player;
CREATE TABLE IF NOT EXISTS Player (
	IDNumber INT UNSIGNED NOT NULL,
    PROYear INT UNSIGNED NOT NULL,
    University VARCHAR(50) DEFAULT NULL,
    NBARings INT UNSIGNED DEFAULT NULL,
    CONSTRAINT FK_Player_Person FOREIGN KEY (IDNumber) REFERENCES Person(IDNumber),
    CONSTRAINT PK_Player PRIMARY KEY (IDNumber)
    );
 
DROP TABLE IF EXISTS Plays;    
CREATE TABLE IF NOT EXISTS Plays (
    PlayerID INT UNSIGNED NOT NULL,
    FName VARCHAR(30) NOT NULL,
    ShirtNum INT UNSIGNED NOT NULL,
    StartContract DATE NOT NULL,
    EndContract DATE NOT NULL,
    Salary INT UNSIGNED NOT NULL,
    PRIMARY KEY (PlayerID, FName),
    CONSTRAINT FK_Plays_Player FOREIGN KEY (PlayerID) REFERENCES Player(IDNumber),
    CONSTRAINT FK_Plays_Franchise FOREIGN KEY (FName) REFERENCES Franchise(FName)
       
);

DROP TABLE IF EXISTS HeadCoach;    
CREATE TABLE IF NOT EXISTS HeadCoach (
	IDNumber INT UNSIGNED NOT NULL,
    VictoryPercentage FLOAT NOT NULL,
    Salary FLOAT NOT NULL,
    CONSTRAINT FK_HeadCoach_Person FOREIGN KEY (IDNumber) REFERENCES Person(IDNumber),
    CONSTRAINT PK_HeadCoach PRIMARY KEY (IDNumber)
);

DROP TABLE IF EXISTS NationalTeam;
CREATE TABLE IF NOT EXISTS NationalTeam (
    YearNT INT UNSIGNED NOT NULL,
    Country VARCHAR(30) NOT NULL,
    CoachID INT UNSIGNED NOT NULL,
	CONSTRAINT FK_NationalTeam_HeadCoach FOREIGN KEY (CoachID) REFERENCES HeadCoach(IDNumber),
    CONSTRAINT PK_NationalTeam PRIMARY KEY (YearNT, Country),
	KEY Country (Country)
);

DROP TABLE IF EXISTS DraftedFor;
CREATE TABLE IF NOT EXISTS DraftedFor (
	YearD INT UNSIGNED NOT NULL,
    IDPlayer INT UNSIGNED NOT NULL,
    FranchiseName VARCHAR(30) NOT NULL,
    ListRank INT UNSIGNED NOT NULL,
    CONSTRAINT FK_DraftedFor_Player FOREIGN KEY (IDPlayer) REFERENCES Player(IDNumber),
    CONSTRAINT FK_DraftedFor_Franchise FOREIGN KEY (FranchiseName) REFERENCES Franchise(FName),
    CONSTRAINT PK_DraftedFor PRIMARY KEY (YearD, IDPlayer, FranchiseName)
    
);

DROP TABLE IF EXISTS Zone;
CREATE TABLE IF NOT EXISTS Zone (
	ArenaName VARCHAR(30) NOT NULL,
	ZoneCode INT UNSIGNED NOT NULL,
    isVIP BOOLEAN NOT NULL,
    CONSTRAINT FK_Zone_Arena FOREIGN KEY (ArenaName) REFERENCES Arena(AName),
    CONSTRAINT PK_Zone PRIMARY KEY (ArenaName, ZoneCode),
    KEY ZoneCode (ZoneCode)
);
DROP TABLE IF EXISTS Seat;
CREATE TABLE IF NOT EXISTS Seat (
	ArenaName VARCHAR(30) NOT NULL,
    ZoneCode INT UNSIGNED NOT NULL,
    SeatNumber INT UNSIGNED NOT NULL,
    Colour VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Seat_Arena FOREIGN KEY (ArenaName) REFERENCES Arena(AName),
    CONSTRAINT FK_Seat_Zone FOREIGN KEY (ZoneCode) REFERENCES Zone(ZoneCode),
    CONSTRAINT PK_Seat PRIMARY KEY (ArenaName, ZoneCode, SeatNumber)
);
DROP TABLE IF EXISTS Season;
CREATE TABLE IF NOT EXISTS Season (
    SYear INT UNSIGNED NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CONSTRAINT PK_Season PRIMARY KEY (SYear)

);
DROP TABLE IF EXISTS PlaysOn;
CREATE TABLE IF NOT EXISTS PlaysOn (
    FranchiseName VARCHAR(30) NOT NULL,
    SeasonYear INT UNSIGNED NOT NULL,
    Victory BOOLEAN NOT NULL,
    CONSTRAINT FK_PlaysOn_Franchise FOREIGN KEY (FranchiseName) REFERENCES Franchise(FName),
    CONSTRAINT FK_PlaysOn_Season FOREIGN KEY (SeasonYear) REFERENCES Season(SYear),
    CONSTRAINT PK_PlaysOn PRIMARY KEY (FranchiseName, SeasonYear)
    
);
DROP TABLE IF EXISTS Assistant;
CREATE TABLE IF NOT EXISTS Assistant (
	IDNumber INT UNSIGNED NOT NULL,
    Speciality VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Assistant_Person FOREIGN KEY (IDNumber) REFERENCES Person(IDNumber),
    CONSTRAINT PK_Zone PRIMARY KEY (IDNumber)
    
);
DROP TABLE IF EXISTS Boss;
CREATE TABLE IF NOT EXISTS Boss (
	BossID INT UNSIGNED NOT NULL,
    EmployeeID INT UNSIGNED NOT NULL,
    CONSTRAINT FK_Boss_Assistant1 FOREIGN KEY (BossID) REFERENCES Assistant(IDNumber),
    CONSTRAINT FK_Boss_Assistant2 FOREIGN KEY (EmployeeID) REFERENCES Assistant(IDNumber),
    CONSTRAINT PK_Boss PRIMARY KEY (BossID, EmployeeID)
    
);

DROP TABLE IF EXISTS Works;
CREATE TABLE IF NOT EXISTS Works (
	AssistantID INT UNSIGNED NOT NULL,
    FranchiseName VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Works_Franchise FOREIGN KEY (FranchiseName) REFERENCES Franchise(FName),
    CONSTRAINT FK_Works_Assistant FOREIGN KEY (AssistantID) REFERENCES Assistant(IDNumber),
    CONSTRAINT PK_Works PRIMARY KEY (FranchiseName, AssistantID)
    
);
DROP TABLE IF EXISTS Selected;
CREATE TABLE IF NOT EXISTS Selected (
    SYear INT UNSIGNED NOT NULL,
    Nation VARCHAR(30) NOT NULL,
    PlayerID INT UNSIGNED NOT NULL,
    ShirtNumber INT UNSIGNED NOT NULL,
    CONSTRAINT FK_Selected_NationalTeam FOREIGN KEY (Nation) REFERENCES NationalTeam(Country),
    CONSTRAINT FK_Selected_Player FOREIGN KEY (PlayerID) REFERENCES Player(IDNumber),
    CONSTRAINT PK_Selected PRIMARY KEY (SYear, Nation, PlayerID)
);