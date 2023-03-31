USE nba_db;
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_person_v1.csv"
INTO TABLE Person
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_headcoach_v1.csv"
INTO TABLE HeadCoach
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_player_v1.csv"
INTO TABLE Player
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_nationalteam_v1.csv"
INTO TABLE NationalTeam
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_nationalteam_player_v1.csv"
INTO TABLE Selected
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

DROP TABLE IF EXISTS ArenaData;
CREATE TEMPORARY TABLE ArenaData (
	AName VARCHAR(30),
	City VARCHAR(30),
	Capacity INT,
    ArenaName1 VARCHAR(30),
    ZCode INT,
    IsVIP INT,
    ArenaName2 VARCHAR(30),
    ZoneCode INT,
    SNumber INT,
    SColour VARCHAR(30)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_ArenaData_v1.csv"
INTO TABLE ArenaData
FIELDS TERMINATED BY '$$'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

INSERT INTO Arena(AName, City, Capacity)
	SELECT DISTINCT AName, City, Capacity
    FROM ArenaData;
    
INSERT INTO Zone(ArenaName, ZoneCode, isVIP)
	SELECT DISTINCT ArenaName1, Zcode, IsVIP
    FROM ArenaData;
    
INSERT INTO Seat(ArenaName, ZoneCode, SeatNumber, Colour)
	SELECT DISTINCT ArenaName2, Zonecode, SNumber, SColour
    FROM ArenaData;
    
DROP TABLE IF EXISTS ConferenceFranchise;
CREATE TEMPORARY TABLE ConferenceFranchise (
	ConferenceName VARCHAR(30),
    GeographicZone VARCHAR(30),
    FName VARCHAR(30),
    City VARCHAR(30),
    Budget INT,
    NBARings INT,
    IDCoach INT,
    ArenaName VARCHAR(30),
    ConferenceName2 VARCHAR(30)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_conference_franchise_v1.csv"
INTO TABLE ConferenceFranchise
FIELDS TERMINATED BY '&&'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

INSERT INTO Conference(CName, Location)
	SELECT DISTINCT ConferenceName, GeographicZone
    FROM ConferenceFranchise;
    
INSERT INTO Franchise(FName, HomeCity, AnnualBudget, NBARings,IDCoach ,Conference, Arena)
	SELECT DISTINCT FName, City, Budget, NBARings, IDCoach, ConferenceName2, ArenaName
    FROM ConferenceFranchise;

DROP TABLE IF EXISTS RegularSeasonFranchise;
CREATE TEMPORARY TABLE IF NOT EXISTS RegularSeasonFranchise (
	SYear INT UNSIGNED NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
	FranchiseName VARCHAR(30) NOT NULL,
    SeasonYear INT UNSIGNED NOT NULL,
    Victory BOOLEAN NOT NULL
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_regularseason_franchise_season_v1.csv"
INTO TABLE RegularSeasonFranchise
FIELDS TERMINATED BY '%%'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

INSERT INTO Season(SYear, StartDate, EndDate)
	SELECT DISTINCT SYear, StartDate, EndDate
    FROM RegularSeasonFranchise;
    
INSERT INTO PlaysOn(FranchiseName, SeasonYear, Victory)
	SELECT DISTINCT FranchiseName, SeasonYear, Victory
    FROM RegularSeasonFranchise;


DROP TABLE IF EXISTS Assistant1;
CREATE TEMPORARY TABLE Assistant1 (
	IDNumber INT UNSIGNED NOT NULL,
    Speciality VARCHAR(30) NOT NULL,
    BossID INT UNSIGNED,
    Fname VARCHAR(30)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_assistant_v1.csv"
INTO TABLE Assistant1
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

INSERT INTO Assistant(IDNumber,Speciality)
	SELECT DISTINCT IDNumber,Speciality
    FROM Assistant1;
    

INSERT INTO Works(AssistantID,FranchiseName)
	SELECT DISTINCT IDNumber, Fname
    FROM Assistant1;
    

INSERT INTO Boss(BossID,EmployeeID)
	SELECT DISTINCT BossID, IDNumber
    FROM Assistant1
    WHERE BossID IS NOT NULL;


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_player_franchise_v1.csv"
INTO TABLE Plays
FIELDS TERMINATED BY '@@'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/nba_db_draft_player_franchise_v1.csv"
INTO TABLE DraftedFor
FIELDS TERMINATED BY '::'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;