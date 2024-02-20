CREATE TABLE Pizze (
	id_pizze INT PRIMARY KEY,
	nazov VARCHAR(50) NOT NULL,
	recept VARCHAR(255),
	cena DECIMAL(5,2) NOT NULL
);
CREATE TABLE Ingrediencie (
    id_ingrediencie INT PRIMARY KEY,
	nazov VARCHAR(50) NOT NULL
);

CREATE TABLE PouzivaneIngrediencie (
	id_pizze INT,
	id_ingrediencie INT,
	mnozstvo INT NOT NULL,
	PRIMARY KEY (id_pizze, id_ingrediencie),
	FOREIGN KEY (id_pizze) REFERENCES Pizze (id_pizze),
	FOREIGN KEY (id_ingrediencie) REFERENCES Ingrediencie (id_ingrediencie)
);

CREATE TABLE Menu (
	id_menu INT PRIMARY KEY,
	nazov VARCHAR(50) NOT NULL,
	cena DECIMAL(5,2) NOT NULL,
	popis VARCHAR(255),
    id_pizze INT,
    FOREIGN KEY (id_pizze) REFERENCES Pizze (id_pizze)
);

CREATE TABLE Objednavky (
	id_objednavky INT PRIMARY KEY,
	datum_cas DATE NOT NULL,
	zakaznik VARCHAR(50) NOT NULL,
	celkova_cena DECIMAL(6,2) NOT NULL
);

CREATE TABLE ObjednanePolozky (
	id_objednavky INT,
	id_menu INT,
	mnozstvo INT NOT NULL,
	PRIMARY KEY (id_objednavky, id_menu),
	FOREIGN KEY (id_objednavky) REFERENCES Objednavky (id_objednavky),
	FOREIGN KEY (id_menu) REFERENCES Menu (id_menu)
);



INSERT INTO Pizze VALUES  (1, 'Margherita', 'Paradajkový základ, syr mozzarella a bazalka', 5.50);
INSERT INTO Pizze VALUES (2, 'Pepperoni', 'Paradajkový základ, syr mozzarella a saláma pepperoni', 6.50);
INSERT INTO Pizze VALUES  (3, 'Capricciosa', 'Paradajkový základ, syr mozzarella, šunka, šampiňóny a olivy', 7.50);
INSERT INTO Pizze VALUES  (4, 'Vegetariánska', 'Paradajkový základ, syr mozzarella, zelenina a olivy', 7.50);
INSERT INTO Pizze VALUES (5, 'Hawai', 'Paradajkový základ, syr mozzarella, šunka a ananás', 6.50);

INSERT INTO Ingrediencie (id_ingrediencie, nazov) VALUES  (1, 'Paradajkový základ');
INSERT INTO Ingrediencie VALUES (2, 'Syr mozzarella');
INSERT INTO Ingrediencie VALUES (3, 'Saláma pepperoni');
INSERT INTO Ingrediencie VALUES (4, 'Šunka');
INSERT INTO Ingrediencie VALUES (5, 'Šampiňóny');


INSERT INTO PouzivaneIngrediencie VALUES (1, 1, 1);
INSERT INTO PouzivaneIngrediencie VALUES(1, 2, 2);
INSERT INTO PouzivaneIngrediencie VALUES(2, 1, 1);
INSERT INTO PouzivaneIngrediencie VALUES(2, 2, 2);
INSERT INTO PouzivaneIngrediencie VALUES(2, 3, 3);
INSERT INTO PouzivaneIngrediencie VALUES(3, 1, 1);
INSERT INTO PouzivaneIngrediencie VALUES(3, 2, 2);
INSERT INTO PouzivaneIngrediencie VALUES(3, 4, 2);
INSERT INTO PouzivaneIngrediencie VALUES(3, 5, 2);
INSERT INTO PouzivaneIngrediencie VALUES(4, 1, 1);
INSERT INTO PouzivaneIngrediencie VALUES(4, 2, 2);
INSERT INTO PouzivaneIngrediencie VALUES(4, 5, 3);
INSERT INTO PouzivaneIngrediencie VALUES(5, 1, 1);
INSERT INTO PouzivaneIngrediencie VALUES(5, 2, 2);
INSERT INTO PouzivaneIngrediencie VALUES(5, 4, 2);
INSERT INTO PouzivaneIngrediencie VALUES(5, 5, 1);


INSERT INTO Menu VALUES (1, 'Pizza Margherita  + cola', 6, 'Classicka pizza', 1);
INSERT INTO Menu VALUES (2, 'Pizza Pepperoni  + cola', 6.50, 'Super pizza', 2);
INSERT INTO Menu VALUES (3, 'Pizza Capricciosa  + cola', 7.50, 'Uzasna pizza', 3);
INSERT INTO Menu VALUES (4, 'Pizza Vegetariánska  + cola', 7.50, 'Super pizza', 4);
INSERT INTO Menu VALUES (5, 'Pizza Hawai + cola', 7, 'Sladka pizza', 5);

INSERT INTO Objednavky VALUES (1, DATE'2023-03-20', 'Stol_1', 10);
INSERT INTO Objednavky VALUES (2, DATE'2023-03-21', 'Stol_3', 10);
INSERT INTO Objednavky VALUES (3, DATE'2023-03-22', 'Stol_4', 10);
INSERT INTO Objednavky VALUES (4, DATE'2023-03-23', 'Stol_2', 10);
INSERT INTO Objednavky VALUES (5, DATE'2023-03-24', 'Stol_5', 10);

INSERT INTO ObjednanePolozky VALUES (1,2,1);
INSERT INTO ObjednanePolozky VALUES (2,2,5);
INSERT INTO ObjednanePolozky VALUES (3,4,10);
INSERT INTO ObjednanePolozky VALUES (4,4,11);

SELECT * FROM Pizze;
SELECT * FROM Ingrediencie;
SELECT * FROM PouzivaneIngrediencie;
SELECT * FROM Menu;
SELECT * FROM ObjednanePolozky;
SELECT * FROM Objednavky;


-- Vypíšeme názov a cenu (k cene pridáme znak EURO) všetkých pizze:

CREATE VIEW CENA_PIZZE AS
SELECT NAZOV, CONCAT('€', cena) AS CENA
FROM PIZZE;

SELECT * FROM CENA_PIZZE;


-- Vypíšeme počet objednávok za každý deň:
CREATE VIEW POCET_OBJ AS
SELECT DATUM_CAS AS DATUM, COUNT(*) AS POCET
FROM OBJEDNAVKY
GROUP BY DATUM_CAS
ORDER BY DATUM;

SELECT * FROM POCET_OBJ;

-- Vypíšeme potrebné množstvo ingrediencií na každú pizzu: (spojenie 3 tabuliek)

SELECT P.NAZOV, I.NAZOV, PI.MNOZSTVO FROM PIZZE P 
    JOIN POUZIVANEINGREDIENCIE PI ON P.ID_PIZZE = PI.ID_PIZZE
    JOIN INGREDIENCIE I ON PI.ID_INGREDIENCIE = I.ID_INGREDIENCIE
    ORDER BY P.NAZOV; 


-- Vypíšeme prvé tri údaje objednávky, ktoré budú obsahovať ID objednávky, dátum a vybrané menu: (outer join)

CREATE VIEW OBJ_DETAIL AS
SELECT O.ID_OBJEDNAVKY, O.DATUM_CAS, M.NAZOV AS MENU_NAZOV
FROM OBJEDNAVKY O
LEFT OUTER JOIN OBJEDNANEPOLOZKY OP ON O.ID_OBJEDNAVKY = OP.ID_OBJEDNAVKY
LEFT OUTER JOIN MENU M ON OP.ID_MENU = M.ID_MENU
LEFT OUTER JOIN PIZZE P ON M.ID_PIZZE = P.ID_PIZZE
FETCH FIRST 3 ROWS ONLY;

SELECT * FROM OBJ_DETAIL;


-- Vypíšeme množstvo ingrediencií použitých vo všetkých pizzách: ( spojenie aspoň 2 tabuliek)

CREATE VIEW POCET_POUZITICH_ING AS
SELECT I.NAZOV AS INGREDIENCIA_NAZOV, COUNT(PI.ID_INGREDIENCIE) AS POCET_POUZITI
FROM INGREDIENCIE I
JOIN POUZIVANEINGREDIENCIE PI ON I.ID_INGREDIENCIE = PI.ID_INGREDIENCIE
GROUP BY I.NAZOV
ORDER BY POCET_POUZITI DESC;

SELECT * FROM POCET_POUZITICH_ING;


-- Vypíšeme priemerné ceny objednávky za každý deň:

CREATE VIEW PREMIERNA_CENA_PIZZ AS
SELECT DATUM_CAS, AVG(CELKOVA_CENA) AS PREMIERNA_CENA 
FROM OBJEDNAVKY
GROUP BY DATUM_CAS
ORDER BY DATUM_CAS;

SELECT * FROM PREMIERNA_CENA_PIZZ;


-- Vypíšeme počet všetkých pizze v menu:

CREATE VIEW POCET_PIZZE AS
SELECT COUNT(*) AS POCET_PIZZ FROM PIZZE;

SELECT * FROM POCET_PIZZE;


-- Vypíšeme názov pizze, ktorá končí na a, jej recept a cenu, ktorá je vyššia ako 6:

CREATE VIEW PIZZA_DETAIL AS
SELECT * FROM PIZZE WHERE CENA > 6
INTERSECT
SELECT * FROM PIZZE WHERE NAZOV LIKE ('%a');

SELECT * FROM PIZZA_DETAIL;


-- Vypíšeme názov, popis a cenu najlacnejšej pizze:

CREATE VIEW MIN_PIZZE AS
SELECT NAZOV, POPIS, CENA FROM Menu 
WHERE CENA = (SELECT MIN(CENA) FROM MENU);

SELECT * FROM MIN_PIZZE;


-- Vypíšeme id, názov, recept a cenu pizze, ktorá stojí viac ako priemerná cena pizze:

CREATE VIEW MORE_AVG_PRICE AS
SELECT * FROM PIZZE 
WHERE CENA > (SELECT AVG(CENA) FROM PIZZE);

SELECT * FROM MORE_AVG_PRICE;

-- sekvencia na vytvorenie id v tabuľke pizza:

CREATE SEQUENCE ID_PIZZE_SEQ 
	START WITH 6
	INCREMENT BY 1
	NOCYCLE
	NOCACHE;





-- trigger na vloženie nových id do tabuľky Pizza spolu s novými údajmi:

CREATE OR REPLACE TRIGGER ID_PIZZE_TRIGGER 
	BEFORE INSERT ON PIZZE
	FOR EACH ROW
	BEGIN
		SELECT ID_PIZZE_SEQ.NEXTVAL INTO :NEW.ID_PIZZE FROM DUAL;
	END;
/

-- test vlozenim novych hodnot bez primary key:

INSERT INTO PIZZE (NAZOV, RECEPT, CENA) VALUES ('DIABLO', 'PARADAJKOVÝ ZÁKLAD, SYR MOZZARELLA, ČILI, JALAPENOS, SALAMI', 5.5);


-- trigger, ktorý kontroluje, aby pri vkladaní nových údajov do tabuľky nebol dátum starší ako dnešný dátum:

CREATE TRIGGER OBJEDNAVKY_DO_BUDUCNOSTY
BEFORE INSERT ON OBJEDNAVKY
FOR EACH ROW
DECLARE
    CURR_DATE DATE := SYSDATE;
BEGIN
    IF :NEW.DATUM_CAS > CURR_DATE THEN
        RAISE_APPLICATION_ERROR(-20003, 'NIE JE MOŽNÉ ZADAŤ OBJEDNÁVKU V BUDÚCNOSTI.');
    END IF;
END;
/

-- test pridávania budúcich dátumov:

INSERT INTO OBJEDNAVKY VALUES (6, DATE'2023-09-24', 'DELIVERY', 10);


 

