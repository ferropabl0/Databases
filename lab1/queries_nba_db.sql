-- 1
SELECT * FROM Person
NATURAL JOIN Player
WHERE LOWER(Person.Nationality) <> 'united states';

-- 2
SELECT FName, HomeCity, AnnualBudget, Arena FROM Franchise
WHERE Arena = (SELECT Arena FROM Franchise
GROUP BY Arena
HAVING COUNT(*) > 1);

-- 3
SELECT PersonName, Surname, BirthDate FROM PERSON
NATURAL JOIN HeadCoach
WHERE HeadCoach.VictoryPercentage > 30
ORDER BY HeadCoach.VictoryPercentage DESC;

-- 4
SELECT CName, Location, count(FName) AS FranchiseCount FROM Conference
JOIN Franchise
ON Conference.CName = Franchise.Conference
GROUP BY CName;

-- 5
SELECT Person.IDNumber, Person.PersonName, Person.Surname, Person.Nationality, 
DraftedFor.YearD, DraftedFor.FranchiseName, DraftedFor.ListRank FROM DraftedFor
JOIN Person ON Person.IDNumber = DraftedFor.IDPlayer
WHERE YearD = 2019;

-- 6
SELECT Person.PersonName, Person.Surname, Player.PROYear, Plays.FName FROM Person
JOIN Player ON Player.IDNumber = Person.IDNumber
JOIN Plays ON Player.IDNumber = Plays.PlayerID
WHERE LOWER(Plays.FName = 'chicago bulls');

-- 7
SELECT PersonName, Surname, Nationality FROM Person
JOIN Selected ON Selected.PlayerID = Person.IDNumber;

-- 8
SELECT DISTINCT Person.IDNumber, Person.PersonName, Person.Surname, Person.Nationality,
Person.Gender, Person.BirthDate, Assistant.Speciality FROM Boss, Person
JOIN Assistant ON Assistant.IDNumber = Person.IDNumber;

-- 9
SELECT P1.IDNumber, P1.PersonName, P1.Surname FROM Person AS P1, Person AS P2
WHERE P1.PersonName = P2.PersonName
AND P1.SURNAME = P2.SURNAME
AND P1.IDNumber <> P2.IDNumber;

-- 10
SELECT * FROM headcoach
JOIN NationalTeam ON NationalTeam.CoachID = headcoach.IDNumber
JOIN Franchise ON Franchise.IDCoach = headcoach.IDNumber
WHERE NationalTeam.YearNT = 2020;

-- 11
SELECT Person.IDNumber, Person.PersonName, Person.Surname, Plays.Salary, Plays.Salary - Plays.Salary*(12/100) AS NewSalary FROM Person
JOIN Plays ON Person.IDNumber = Plays.PlayerID
WHERE LOWER(Person.Nationality) = 'united states';

-- 12
SELECT * FROM Person
JOIN Player ON Player.IDNumber = Person.IDNumber
WHERE Player.PROYear > 2019 
AND (Player.University IN (SELECT University FROM Player WHERE Player.University IS NULL)
OR Player.IDNumber NOT IN (SELECT DISTINCT PlayerID FROM SELECTED));
