###- Création des tables -###
CREATE TABLE Client (
    NumClient VARCHAR(12),
    Civilite VARCHAR(4),
    Nom VARCHAR(30),
    Prenom VARCHAR(30),
    Adresse VARCHAR(30),
    CodePostal VARCHAR(5),
    Commune VARCHAR(30),
    Telephone CHAR(10),
    Tportable CHAR(10),
    DateNaissance DATE,
    Email VARCHAR(30),
    PtsFidelite DECIMAL,
    CONSTRAINT pk_client PRIMARY KEY (NumClient),
    CONSTRAINT ck_client_civilite CHECK (Civilite IN ('MR', 'MLLE', 'MME')),
    CONSTRAINT ck_client_ptsfidelite CHECK (PtsFidelite >= 0)
);

CREATE TABLE Bon (
    NumBon VARCHAR(12),
    DateBon DATE,
    MontantReduc FLOAT,
    NumClient VARCHAR(12),
    CONSTRAINT bon PRIMARY KEY (NumBon),
    CONSTRAINT ck_bon_montantreduc CHECK (MontantReduc IN (15, 30, 50, 65, 100)),
    CONSTRAINT ck_bon_ptsfidelite CHECK (MontantReduc >= 0),
    CONSTRAINT fk_bon_numclient FOREIGN KEY (NumClient) REFERENCES Client(NumClient)      
);

CREATE TABLE Adresse_Client (
    NumLiv VARCHAR(12),
    ModeLiv VARCHAR(10),
    FraisLiv FLOAT,
    NumBon VARCHAR(12) UNIQUE,
    NumClient VARCHAR(12) UNIQUE,
    CONSTRAINT pk_adresse_client PRIMARY KEY (NumLiv),
    CONSTRAINT ck_adresse_client_modeliv CHECK (ModeLiv IN ('PointRelais', 'Domicile', 'Express')),
    CONSTRAINT ck_adresse_client_fraisliv CHECK (FraisLiv IN (0.0, 2.0, 9.9)),
    CONSTRAINT fk_adresse_client_numbon FOREIGN KEY (NumBon) REFERENCES Bon(NumBon),
    CONSTRAINT fk_adresse_client_numclient FOREIGN KEY (NumClient) REFERENCES Client(NumClient)
);

CREATE TABLE Adresse (
    NumLiv VARCHAR(12),
    ModeLiv VARCHAR(10),
    FraisLiv FLOAT,
    NumBon VARCHAR(12) UNIQUE,
    NomLiv VARCHAR(30),
    PrenomLiv VARCHAR(30),
    CodePostalLiv CHAR(5), 
    CommuneLiv VARCHAR(30),
    TelephoneLiv CHAR(10),
    CONSTRAINT pk_adresse PRIMARY KEY (NumLiv),
    CONSTRAINT ck_adresse_modeliv CHECK (ModeLiv IN ('PointRelais', 'Domicile', 'Express')),
    CONSTRAINT ck_adresse_fraisliv CHECK (FraisLiv IN (0.0, 2.0, 9.9)),
    CONSTRAINT fk_adresse_numbon FOREIGN KEY (NumBon) REFERENCES Bon(NumBon)
);

CREATE TABLE Point_Relais (
    NumLiv VARCHAR(12),
    ModeLiv VARCHAR(11),
    FraisLiv FLOAT,
    NumBon VARCHAR(12) UNIQUE,
    NumPointRelais VARCHAR(12),
    NomPointRelais VARCHAR(30),
    AdressePointRelais VARCHAR(30),
    CodePostalPointRelais CHAR(5), 
    CommunePointRelais VARCHAR(30),
    CONSTRAINT pk_point_relais PRIMARY KEY (NumLiv),
    CONSTRAINT ck_point_relais_modeliv CHECK (ModeLiv IN ('PointRelais', 'Domicile', 'Express')),
    CONSTRAINT ck_point_relais_fraisliv CHECK (FraisLiv IN (0.0, 2.0, 9.9)),
    CONSTRAINT fk_point_relais_numbon FOREIGN KEY (NumBon) REFERENCES Bon(NumBon)
);

CREATE TABLE Article (
    Reference CHAR(6),
    NumPage VARCHAR(3),
    Designation VARCHAR(120),
    PrixUnitaire FLOAT NOT NULL,    
    CONSTRAINT pk_article PRIMARY KEY (Reference),
    CONSTRAINT ck_article_prixunitaire CHECK (PrixUnitaire > 0)    
);

CREATE TABLE Commander (
	NumBon VARCHAR(12),
	Reference CHAR(6),	
	Quantite DECIMAL NOT NULL,	
	CONSTRAINT fk_commander_numbon FOREIGN KEY (NumBon) REFERENCES BON(NumBon),
	CONSTRAINT fk_commander_reference FOREIGN KEY (Reference) REFERENCES ARTICLE(Reference),
	CONSTRAINT pk_commander PRIMARY KEY (NumBon, Reference),
	CONSTRAINT ck_commander_quantité CHECK (Quantite > 0)
);

CREATE TABLE C4 (
	NumBon VARCHAR(12),
	NumPaiement VARCHAR(12),
	SupportPaiement VARCHAR(6),
	NumC4 CHAR(9),
	DateNaissanceC4 DATE,
	TypePaiementC4 CHAR(1),	
	CONSTRAINT pk_c4 PRIMARY KEY (NumPaiement),	
	CONSTRAINT ck_c4_supportpaiement CHECK (SupportPaiement = 'C4'),
	CONSTRAINT fk_c4_numbon FOREIGN KEY (NumBon) REFERENCES BON(NumBon),
	CONSTRAINT uk_c4_numbon UNIQUE (NumBon)		
);

CREATE TABLE CB	(
	NumBon VARCHAR(12),
	NumPaiement VARCHAR(12),
	SupportPaiement VARCHAR(6),
	NumCB CHAR(16),
	NomCB VARCHAR(30),	
	DateExpiration CHAR(4),
	Cryptogramme CHAR(3),
	TypePaiementCB CHAR(1),	
	CONSTRAINT pk_cb PRIMARY KEY (NumPaiement),	
	CONSTRAINT fk_cb_numbon FOREIGN KEY (NumBon) REFERENCES BON(NumBon),
	CONSTRAINT uk_cb_numbon UNIQUE (NumBon),
	CONSTRAINT ck_cb_typepaiementcb CHECK (TypePaiementCB IN ('C', 'M')),
	CONSTRAINT ck_cb_supportpaiement CHECK (SupportPaiement = 'CB')
);

CREATE TABLE Cheque (
	NumBon VARCHAR(12),
	NumPaiement VARCHAR(12),
	SupportPaiement VARCHAR(6),	
	CONSTRAINT pk_cheque PRIMARY KEY (NumPaiement),	
	CONSTRAINT ck_cheque_supportpaiement CHECK (SupportPaiement = 'Chèque'),
	CONSTRAINT fk_cheque_numbon FOREIGN KEY (NumBon) REFERENCES BON(NumBon),
	CONSTRAINT uk_cheque_numbon UNIQUE (NumBon)	
);


##- Insertion des données -##

/*1er bon*/
INSERT INTO Client
(NumClient, Civilite, Nom, Prenom, Adresse, CodePostal, Commune, Telephone, PtsFidelite)
VALUES ('000100', 'MME', 'AZTAKES', 'Hélène', 'Av de Rangueil', '31000', 'Toulouse', '0600000000', 45);

INSERT INTO Bon
(NumBon, DateBon, MontantReduc, NumClient)
VALUES ('1', '', 0, '000100');

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('471147', 'Linge de lit chalet Drap 240x300', 14.95);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('1', '471147', 1);

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('471159', 'Linge de lit chalet Drap housse', 17.45);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('1', '471159', 1);

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('471162', 'Linge de lit chalet Taie traversin', 11.45);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('1', '471162', 1);

INSERT INTO Cheque
(NumPaiement, SupportPaiement, NumBon)
VALUES ('1', 'Chèque', '1');

INSERT INTO Adresse_Client
(NumLiv, ModeLiv, FraisLiv, NumBon, NumClient)
VALUES ('1', 'Domicile', 2.0, '1', '000100');


/*2e bon*/
INSERT INTO Client
(NumClient, Civilite, Nom, Prenom, Adresse, CodePostal, Commune, Telephone, DateNaissance, Email, PtsFidelite)
VALUES ('000200', 'MR', 'ASSEIN', 'Marc', 'rue du chêne', '31000', 'TOULOUSE', '600000006', '01/12/2001', 'marc@orange.fr', 105);

INSERT INTO Bon
(NumBon, DateBon, MontantReduc, NumClient)
VALUES ('2', '', 15.0, '000200');

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('905968', 'Drap de bain 100x150 grisperle', 24.67);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('2', '905968', 3);

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('905784', 'Tapis de bain 60x100 grisperle', 17.17);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('2', '905784', 1);

INSERT INTO CB
(NumPaiement, NumCB, NomCB, DateExpiration, Cryptogramme, TypePaiementCB, SupportPaiement, NumBon)
VALUES ('2', '0001000100010001', 'ASSEIN', '01/24', '001', 'C', 'CB', '2');

INSERT INTO Point_Relais
(NumLiv, NumPointRelais, NomPointRelais, AdressePointRelais, CodePostalPointRelais, CommunePointRelais, ModeLiv, FraisLiv, NumBon)
VALUES ('2', '52035', 'INTERMARCHE CONTACT', 'AVENUE DE REVEL', '81700', 'PUYLAURENS', 'PointRelais', 0.0, '1');


/*3e bon*/
INSERT INTO Client
(NumClient, Civilite, Nom, Prenom, Adresse, CodePostal, Commune, Telephone, TPortable, PtsFidelite)
VALUES ('000300', 'MME', 'TERRIEUR', 'Alex', 'rue de la caille', '81000', 'ALBI', '0500000000', '0600000060', 10);

INSERT INTO Bon
(NumBon, DateBon, MontantReduc, NumClient)
VALUES ('3', '', 50, '000300');

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('950728', 'Couette Dodo 240x220', 129.90);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('3', '950728', 1);

INSERT INTO Article
(Reference, Designation, PrixUnitaire)
VALUES ('950614', 'Oreiller ergonomique 60x60', 29.90);
INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('3', '950614', 2);

INSERT INTO Cheque
(NumPaiement, SupportPaiement, NumBon)
VALUES ('3', 'Chèque', '3');

INSERT INTO Adresse_Client
(NumLiv, ModeLiv, FraisLiv, NumBon, NumClient)
VALUES ('3', 'Express', 9.9, '3', '000300');

/*4e bon*/
INSERT INTO Bon
(NumBon, DateBon, MontantReduc, NumClient)
VALUES ('4', '', 100, '000200');

INSERT INTO Commander
(NumBon, Reference, Quantite)
VALUES ('4', '950728', 3);

INSERT INTO Cheque
(NumPaiement, SupportPaiement, NumBon)
VALUES ('4', 'Chèque', '4');

INSERT INTO Point_Relais
(NumLiv, ModeLiv, FraisLiv, NumBon, NumPointRelais, NomPointRelais, AdressePointRelais, CodePostalPointRelais, CommunePointRelais)
VALUES ('4', 'PointRelais', 0.0, '4', '52035', 'INTERMARCHE CONTACT', 'AVENUE DE REVEL', '81700', 'PUYLAURENS');


##- Requêtes LID -##

/*Nombre de commandes passées*/
SELECT COUNT(NumBon) AS Nb_Commandes
FROM Bon;

/*Montant total et montant des commandes*/
SELECT Bon.NumBon, SUM((Commander.Quantite * Article.PrixUnitaire)) - Bon.MontantReduc AS Montant_Bon,
    SUM(Commander.Quantite * Article.PrixUnitaire) + 6.99 + COALESCE(Adresse.FraisLiv, 0) + COALESCE(Adresse_Client.FraisLiv, 0) + COALESCE(Point_Relais.FraisLiv, 0)- Bon.MontantReduc AS Montant_Total_Bon
FROM Bon, Article, Commander, Adresse, Adresse_Client, Point_Relais
WHERE Commander.NumBon = Bon.NumBon
AND Commander.Reference = Article.Reference
AND Adresse.NumBon(+) = Bon.NumBon
AND Adresse_Client.NumBon(+) = Bon.NumBon
AND Point_Relais.NumBon(+) = Bon.NumBon
GROUP BY Bon.NumBon, Bon.MontantReduc, Adresse.FraisLiv, Adresse_Client.FraisLiv, Point_Relais.FraisLiv
ORDER BY Bon.NumBon ASC;

/*Nombre de ventes par produits*/
SELECT Article.Designation, SUM(DISTINCT Commander.Quantite) AS Quantité
FROM Article, Commander
WHERE Commander.Reference = Article.Reference
GROUP BY Article.Designation;

/*Nombre de commandes passées par clients*/
SELECT Client.Prenom, Client.Nom, COUNT(Bon.NumBon) AS Nb_Commandes
FROM Bon, Client
WHERE Bon.NumClient = Con.NumClient
GROUP BY Client.Prenom, Client.Nom;

/*Nombre de commandes passées et montant total par genre (civilité) des clients*/
SELECT DISTINCT Client.Civilite AS Genre, COUNT(DISTINCT Bon.NumBon) AS Nb_Commandes,
SUM(Article.PrixUnitaire * Commander.Quantite) + SUM(DISTINCT COALESCE(Adresse.FraisLiv, 0)) + SUM(DISTINCT COALESCE(Adresse_Client.FraisLiv, 0)) + SUM(DISTINCT COALESCE(Point_Relais.FraisLiv, 0)) + 6.99*COUNT(DISTINCT(Bon.NumBon)) - SUM(DISTINCT Bon.MontantReduc) AS Montant_Total
FROM Client, Bon, Artile, Commander, Adresse_Client, Adresse, Point_Relais
WHERE Commander.NumBon = Bon.NumBon
AND Client.NumClient = Bon.NumClient
AND Article.Reference = Commander.Reference
AND Adresse_Client.NumBon(+) = Bon.NumBon
AND Point_Relais.NumBon(+) = Bon.NumBon
AND Adresse_Client.NumBon(+) = Bon.NumBon
GROUP BY Client.Civilite;

/*Obtenir le pri unitaire du produit n°950728*/
SELECT PrixUnitaire
FROM Article
WHERE Reference = '950728';

/*Obtenir les clients ayant commandé le produit n°950728 avec la quantité commandée*/
SELECT Client.Prenom, Client.Nom, SUM(DISTINCT Commander.Quantite) AS Quantité
FROM Client, Commander, Bon
WHERE Commander.Reference = '950728'
AND Bon.NumBon = Commander.NumBon
AND Client.NumClient = Bon.NumClient
GROUP BY Client.Prenom, Client.Nom;