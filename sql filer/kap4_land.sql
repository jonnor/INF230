-- Database: Land


-- Sletter tabellene

-- DROP TABLE Grense;
-- DROP TABLE Innbyggertall;
-- DROP TABLE Byer;
-- DROP TABLE Land;



-- Oppretter tabellene

CREATE TABLE Land
(
    LandId        INTEGER,
    Navn          VARCHAR(100),
    Flateinnhold  INTEGER,
    Hovedstad     INTEGER,
    CONSTRAINT LandPN PRIMARY KEY (LandId)
);


CREATE TABLE Byer
(
    ById          INTEGER,
    Navn          VARCHAR(100),
    Flateinnhold  INTEGER,
    LandId        INTEGER,
    CONSTRAINT ByerPN PRIMARY KEY (ById)
);


CREATE TABLE Innbyggertall
(
    LandId     INTEGER,
    Årstall    INTEGER,
    Antall     INTEGER,
    CONSTRAINT InnbyggertallPN PRIMARY KEY (LandId, Årstall)
);


CREATE TABLE Grense
(
    LandId1    INTEGER,
    LandId2    INTEGER,
    CONSTRAINT GrensePN PRIMARY KEY (LandId1, LandId2)
);


ALTER TABLE Byer
  ADD KEY ByerLandIdx (LandId);

ALTER TABLE Land
  ADD UNIQUE KEY LandHovedstadIdx (Hovedstad);

ALTER TABLE Grense
  ADD KEY GrenseLandIdx1 (LandId1);

ALTER TABLE Grense
  ADD KEY GrenseLandIdx2 (LandId2);

ALTER TABLE Byer
  ADD CONSTRAINT ByerLandFN FOREIGN KEY (LandId) REFERENCES Land (LandId);

ALTER TABLE Land
  ADD CONSTRAINT LandByerFN FOREIGN KEY (Hovedstad) REFERENCES Byer (ById);

ALTER TABLE Grense
  ADD CONSTRAINT InnbyggertallLandFN1 FOREIGN KEY (LandId1) REFERENCES Land (LandId),
  ADD CONSTRAINT InnbyggertallLandFN2 FOREIGN KEY (LandId2) REFERENCES Land (LandId);

ALTER TABLE Innbyggertall
  ADD CONSTRAINT InnbyggertallLandFN FOREIGN KEY (LandId) REFERENCES Land (LandId);



-- Setter inn eksempeldata (kun noen få rader med dummy-data i første omgang)

INSERT INTO Land (LandId, Navn, Flateinnhold, Hovedstad) VALUES
( 1, 'Norge',   323787, NULL ),
( 2, 'Sverige', 878575, NULL );

INSERT INTO Byer (ById, Navn, Flateinnhold, LandId) VALUES
( 1, 'Oslo',      20000, 1 ),
( 2, 'Stockholm', 30000, 2 );

INSERT INTO Innbyggertall (LandId, Årstall, Antall) VALUES
(1, 2013, 5084000 ),
(2, 2013, 9593000 );

INSERT INTO Grense (LandId1, LandId2) VALUES
( 1, 2 ),
( 2, 1 );

UPDATE Land
SET Hovedstad = 1
WHERE LandId = 1;

UPDATE Land
SET Hovedstad = 2
WHERE LandId = 2;

