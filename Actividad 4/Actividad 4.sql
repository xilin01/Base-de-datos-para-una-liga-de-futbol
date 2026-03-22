-- Borro todas las tablas para empezar desde cero
-- Si alguna no existe mostrará un error, pero se puede ignorar
-- Antes de borrar una tabla es necesario haber borrado las tablas que la referencian o el sistema impediría la eliminación (a no ser que se use CASCADE CONSTRAINTS)
DROP TABLE Asiste;
DROP TABLE Enfrenta;
DROP TABLE Financia;
DROP TABLE Patrocina;
DROP TABLE Arbitro;
DROP TABLE Jugador;
DROP TABLE Persona;
DROP TABLE Patrocinador;
DROP TABLE Club;

-- Definición de las tablas
CREATE TABLE Club(
    CIF CHAR(9) PRIMARY KEY,
    Nombre VARCHAR(40) NOT NULL UNIQUE,
    Sede VARCHAR(30) NOT NULL,
    Num_Socios INTEGER NOT NULL,
    
    CONSTRAINT NumSociosPositivos CHECK (Num_Socios >= 0)
);

CREATE TABLE Patrocinador(
    CIF CHAR(9) PRIMARY KEY,
    NomPat VARCHAR(20) NOT NULL, 
    Rama VARCHAR(20) NOT NULL,
    Eslogan VARCHAR(30) NOT NULL,

    -- Puede haber patrocinadores con el mismo nombre de distintas ramas
    CONSTRAINT NombreYRamaUnicos UNIQUE(NomPat, Rama)
);

CREATE TABLE Persona(
    NIF CHAR(9) PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL
);

CREATE TABLE Jugador(
    NIF CHAR(9) PRIMARY KEY REFERENCES Persona(NIF) ON DELETE CASCADE,
    Altura DECIMAL(3,2) NOT NULL CHECK (Altura > 0),
    CIF CHAR(9) NOT NULL REFERENCES Club(CIF)
);

CREATE TABLE Arbitro(
    NIF CHAR(9) PRIMARY KEY REFERENCES Persona(NIF) ON DELETE CASCADE,
    Colegio VARCHAR(20) NOT NULL,   
    Fecha_colegiatura DATE NOT NULL
);

CREATE TABLE Patrocina(
    NIF CHAR (9) NOT NULL REFERENCES Jugador(NIF),
    CIF CHAR(9) NOT NULL REFERENCES Patrocinador(CIF),
    Cantidad DECIMAL(10,2) NOT NULL CHECK (Cantidad > 0),
    
    CONSTRAINT PKPatrocina PRIMARY KEY (NIF, CIF)
);

CREATE TABLE Financia(
    CIF_P CHAR(9) NOT NULL REFERENCES Patrocinador(CIF),
    CIF_C CHAR(9) NOT NULL REFERENCES Club(CIF),
    Cantidad DECIMAL(10,2) NOT NULL CHECK (Cantidad > 0),
    
    CONSTRAINT PKFinancia PRIMARY KEY (CIF_P, CIF_C)
);

CREATE TABLE Enfrenta(
    CIF_local CHAR(9) NOT NULL REFERENCES Club(CIF),
    CIF_visitante CHAR(9) NOT NULL REFERENCES Club(CIF),
    Goles_local INTEGER NOT NULL CHECK (Goles_local >= 0),
    Goles_visitante INTEGER NOT NULL CHECK (Goles_visitante >= 0),
    Fecha DATE NOT NULL,
    NIF CHAR(9) NOT NULL REFERENCES Arbitro(NIF),
    
    CONSTRAINT PKEnfrenta PRIMARY KEY (CIF_local, CIF_visitante),
    CONSTRAINT DosClubes CHECK (CIF_local <> CIF_visitante)
    -- Para evitar errores al introducir un partido
);

CREATE TABLE Asiste(
    NIF CHAR(9) NOT NULL REFERENCES Persona(NIF),
    CIF_local CHAR(9) NOT NULL,
    CIF_visitante CHAR(9) NOT NULL,
    
    CONSTRAINT PKAsiste PRIMARY KEY (CIF_local, CIF_visitante, NIF),
    CONSTRAINT FGEnfrentamiento FOREIGN KEY (CIF_local,CIF_visitante) REFERENCES Enfrenta(CIF_local, CIF_visitante)
);

--------------------------------------
-- Inserción de datos en las tablas --
--------------------------------------
INSERT INTO Club VALUES ('11111111X', 'Real Madrid CF', 'Concha Espina', 70000);
INSERT INTO Club VALUES ('11111112X', 'Futbol Club Barcelona', 'Aristides Maillol', 80000);
INSERT INTO Club VALUES ('11111113X', 'Paris Saint-Germain Football Club', 'Rue du Commandant Guilbaud', 1000);
INSERT INTO Club VALUES ('11111114X', 'Real Zaragoza', 'Avda. Isabel la Católica s/n', 5000);
INSERT INTO Club VALUES ('11111115X', 'RC Celta de Vigo', 'Avda. de Balaídos s/n', 12500);
INSERT INTO Club VALUES ('11111116X', 'RC Deportivo de la Coruña', 'Calle Manuel Murguía', 12500);

INSERT INTO Patrocinador VALUES ('22222221X', 'Bwin', 'Apuestas', 'La mejor casa de apuestas');
INSERT INTO Patrocinador VALUES ('22222222X', 'Nike', 'Deportes', 'Just do it');
INSERT INTO Patrocinador VALUES ('22222223X', 'Pascual', 'Alimentos', 'La mejor leche');
INSERT INTO Patrocinador VALUES ('22222224X', 'IKEA', 'Muebles', 'Home furnishings');
INSERT INTO Patrocinador VALUES ('22222225X', 'Adidas', 'Deportes', 'Impossible is Nothing');

INSERT INTO Persona VALUES ('00000001X', 'Peter Johnoson');
INSERT INTO Persona VALUES ('00000002X', 'Ana Lopez');
INSERT INTO Persona VALUES ('00000003X', 'Mejuto Gonzalez');
INSERT INTO Persona VALUES ('00000004X', 'Velasco Carballo');
INSERT INTO Persona VALUES ('00000005X', 'Eden Hazard');
INSERT INTO Persona VALUES ('00000006X', 'Lionel Messi');
INSERT INTO Persona VALUES ('00000007X', 'Kylian Mbappe');
INSERT INTO Persona VALUES ('00000008X', 'Thibaut Courtois');
INSERT INTO Persona VALUES ('00000009X', 'José Luis Munuera');
INSERT INTO Persona VALUES ('00000010X', 'Paco Gento');
INSERT INTO Persona VALUES ('00000011X', 'Juan SEÑOR');
INSERT INTO Persona VALUES ('00000012X', 'Romário de Souza');

INSERT INTO Arbitro VALUES ('00000003X', 'Navarro', TO_DATE('2012-06-05', 'YYYY-MM-DD'));
INSERT INTO Arbitro VALUES ('00000004X', 'Andaluz', TO_DATE('2015-08-12', 'YYYY-MM-DD'));
INSERT INTO Arbitro VALUES ('00000009X', 'Valenciano', SYSDATE);

INSERT INTO Jugador VALUES ('00000005X', 1.89, '11111111X');
INSERT INTO Jugador VALUES ('00000006X', 1.7, '11111112X');
INSERT INTO Jugador VALUES ('00000007X', 1.85, '11111113X');
INSERT INTO Jugador VALUES ('00000008X', 1.95, '11111111X');
INSERT INTO Jugador VALUES ('00000011X', 1.67, '11111114X');
INSERT INTO Jugador VALUES ('00000012X', 1.67, '11111112X');

INSERT INTO Patrocina VALUES ('00000005X', '22222223X', 5000);
INSERT INTO Patrocina VALUES ('00000005X', '22222222X', 1000);
INSERT INTO Patrocina VALUES ('00000005X', '22222221X', 56);
INSERT INTO Patrocina VALUES ('00000007X', '22222221X', 1500);
INSERT INTO Patrocina VALUES ('00000008X', '22222223X', 20000);
INSERT INTO Patrocina VALUES ('00000005X', '22222225X', 6000);
INSERT INTO Patrocina VALUES ('00000012X', '22222225X', 13000);

INSERT INTO Financia VALUES ('22222221X', '11111111X', 30000);
INSERT INTO Financia VALUES ('22222222X', '11111111X', 56734);
INSERT INTO Financia VALUES ('22222222X', '11111112X', 23000);
INSERT INTO Financia VALUES ('22222223X', '11111113X', 23000);
INSERT INTO Financia VALUES ('22222225X', '11111112X', 8877);

INSERT INTO Enfrenta VALUES ('11111111X', '11111112X', 3, 2, TO_DATE('2015-06-05', 'YYYY-MM-DD'), '00000003X');
INSERT INTO Enfrenta VALUES ('11111111X', '11111113X', 2, 1, TO_DATE('2015-06-12', 'YYYY-MM-DD'), '00000003X');
INSERT INTO Enfrenta VALUES ('11111112X', '11111111X', 2, 2, TO_DATE('2015-04-29', 'YYYY-MM-DD'), '00000003X');
INSERT INTO Enfrenta VALUES ('11111112X', '11111113X', 3, 2, TO_DATE('2015-04-22', 'YYYY-MM-DD'), '00000004X');
INSERT INTO Enfrenta VALUES ('11111113X', '11111111X', 0, 2, TO_DATE('2015-03-19', 'YYYY-MM-DD'), '00000003X');
INSERT INTO Enfrenta VALUES ('11111113X', '11111112X', 0, 1, TO_DATE('2015-04-23', 'YYYY-MM-DD'), '00000004X');

INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111112X', '00000001X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111112X', '00000010X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111112X', '00000002X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111112X', '00000004X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111112X', '00000007X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111113X', '00000001X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111113X', '00000002X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111113X', '00000004X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111111X', '11111113X', '00000010X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111112X', '11111111X', '00000001X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111112X', '11111111X', '00000010X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111112X', '11111113X', '00000002X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111112X', '11111113X', '00000010X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111113X', '11111111X', '00000006X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111113X', '11111111X', '00000010X');
INSERT INTO Asiste(CIF_local, CIF_visitante, NIF) VALUES ('11111113X', '11111112X', '00000010X');

--
SELECT * FROM Club;
SELECT * FROM Patrocinador;
SELECT * FROM Persona;
SELECT * FROM Arbitro;
SELECT * FROM Jugador;
SELECT * FROM Patrocina;
SELECT * FROM Financia;
SELECT * FROM Enfrenta;
SELECT * FROM Asiste;
--

-- 4.1)
(SELECT J.NIF, P.Nombre
FROM Jugador J JOIN Persona P ON J.NIF = P.NIF)
MINUS
(SELECT DISTINCT P.NIF, PE.Nombre
FROM Patrocina P JOIN Persona PE ON P.NIF = PE.NIF)
ORDER BY NIF DESC;

SELECT J.NIF, P.Nombre
FROM Jugador J JOIN Persona P ON J.NIF = P.NIF
WHERE J.NIF NOT IN (SELECT P.NIF
                    FROM Patrocina P);

-- 4.2)
(SELECT P.CIF
FROM Patrocinador P)
MINUS
(SELECT DISTINCT F.CIF_P
FROM Financia F);

SELECT P.CIF
FROM Patrocinador P
WHERE P.CIF NOT IN (SELECT F.CIF_P
                    FROM Financia F);

-- 4.3)
(SELECT C.CIF, C.Nombre
FROM Club C)
MINUS
(SELECT DISTINCT F.CIF_C, C.Nombre
FROM Financia F JOIN Club C ON F.CIF_C = C.CIF);

SELECT C.CIF, C.Nombre
FROM Club C
WHERE C.CIF NOT IN (SELECT F.CIF_C
                    FROM Financia F);
                    
-- 4.4)
(SELECT C.CIF, C.Nombre
FROM Club C)
MINUS
(SELECT DISTINCT J.CIF, C.Nombre
FROM Jugador J JOIN Club C ON J.CIF = C.CIF);

SELECT C.CIF, C.Nombre
FROM Club C
WHERE C.CIF NOT IN (SELECT J.CIF
                    FROM Jugador J);
                    
-- 4.5)
(SELECT P.Nombre, A.NIF
FROM Arbitro A JOIN Persona P ON A.NIF = P.NIF)
MINUS
(SELECT DISTINCT P.Nombre, E.NIF
FROM Enfrenta E JOIN Persona P ON E.NIF = P.NIF);

SELECT P.Nombre, A.NIF
FROM Arbitro A JOIN Persona P ON A.NIF = P.NIF
WHERE A.NIF NOT IN (SELECT DISTINCT E.NIF
                    FROM Enfrenta E);
                    
-- 4.6)
SELECT C.Nombre
FROM Club C
WHERE NOT EXISTS (
    (SELECT J.NIF, P.Nombre
     FROM Jugador J JOIN Persona P ON J.NIF = P.NIF
     WHERE J.CIF = C.CIF)
     MINUS
    (SELECT J.NIF, P.Nombre
     FROM Jugador J JOIN Persona P ON J.NIF = P.NIF
     WHERE P.Nombre LIKE '%e%' OR P.Nombre LIKE '%E%')
);

-- 4.7)
SELECT P.NIF, P.Nombre
FROM Persona P
WHERE NOT EXISTS (
    (SELECT A.CIF_local, A.CIF_visitante
     FROM Asiste A JOIN Club C ON A.CIF_local = C.CIF JOIN Club CL ON A.CIF_visitante = CL.CIF
     WHERE C.Nombre = 'Real Madrid CF' OR CL.Nombre = 'Real Madrid CF')
     MINUS
    (SELECT A.CIF_local, A.CIF_visitante
     FROM Asiste A
     WHERE A.NIF = P.NIF)
);

-- 4.8)
SELECT A.NIF, P.Nombre
FROM Arbitro A JOIN Persona P ON A.NIF = P.NIF
WHERE NOT EXISTS (
    (SELECT E.CIF_local
     FROM Enfrenta E JOIN Club C ON E.CIF_local = C.CIF
     WHERE C.Nombre = 'Real Madrid CF' AND E.Goles_local > E.Goles_visitante)
     MINUS
    (SELECT E.CIF_local
     FROM Enfrenta E
     WHERE E.NIF = A.NIF)
);

-- 4.9)
SELECT P.NIF, P.Nombre
FROM Persona P
WHERE NOT EXISTS (
    (SELECT P.CIF
     FROM Patrocinador P
     WHERE P.Rama = 'Deportes')
     MINUS
    (SELECT PA.CIF
     FROM Patrocina PA
     WHERE PA.NIF = P.NIF)
);

-- 4.10)
SELECT *
FROM Club C
WHERE NOT EXISTS (
    (SELECT P.CIF
     FROM Patrocinador P
     WHERE P.Rama = 'Deportes')
     MINUS
    (SELECT F.CIF_P
     FROM Financia F
     WHERE F.CIF_C = C.CIF)
);

-- 4.11)
(SELECT P.CIF, P.NomPat
FROM Patrocinador P)
MINUS
(SELECT DISTINCT P.CIF, PA.NomPat
FROM Patrocina P JOIN Patrocinador PA ON P.CIF = PA.CIF);

SELECT P.CIF, P.NomPat
FROM Patrocinador P
WHERE P.CIF NOT IN (SELECT P.CIF
                    FROM Patrocina P);

-- 4.12)
SELECT C.CIF, C.Nombre
FROM Club C
WHERE EXISTS (
    (SELECT J.NIF
     FROM Jugador J
     WHERE J.CIF = C.CIF)
     MINUS
     (SELECT P.NIF
      FROM Patrocina P)
)
ORDER BY C.CIF DESC;

-- 4.13)
SELECT C.Nombre
FROM Club C
WHERE C.Num_Socios = (SELECT MAX(C.Num_Socios)
                      FROM Club C)
ORDER BY C.Nombre ASC;

-- 4.14)
SELECT C.CIF, C.Nombre, C.Num_Socios, (SELECT AVG(C.Num_Socios)
                                       FROM Club C) AS Media_Socios 
FROM Club C;

-- 4.15)
SELECT J.NIF, P.Nombre, J.Altura
FROM Jugador J JOIN Persona P ON J.NIF = P.NIF
WHERE J.Altura > (SELECT AVG(J.Altura)
                  FROM Jugador J);  
                  
-- 4.16)
SELECT C.Nombre AS Local, E.Goles_local AS GolesLocal, E.Goles_visitante AS GolesVisitante, CL.Nombre AS Visitante
FROM Enfrenta E JOIN Club C ON E.CIF_local = C.CIF JOIN Club CL ON E.CIF_visitante = CL.CIF
WHERE E.Goles_local + E.Goles_visitante > ((SELECT AVG(E.Goles_local)
                                           FROM Enfrenta E) + (SELECT AVG(E.Goles_visitante)
                                                               FROM Enfrenta E));
             
-- 4.17)
SELECT C.CIF, C.Nombre, ABS(C.Num_Socios - (SELECT AVG(C.Num_Socios)
                                            FROM Club C)) AS Dif_Socios_Media
FROM Club C;
    
-- 4.18) 
SELECT C.CIF, C.Nombre, C.Num_Socios
FROM Club C
WHERE C.Num_Socios > (SELECT AVG(C.Num_Socios)
                      FROM Club C);
                      
-- 4.19)
SELECT C.CIF, C.Nombre, COALESCE(SUM(F.Cantidad), 0) AS TOTAL
FROM Club C LEFT JOIN Financia F ON C.CIF = F.CIF_C
GROUP BY C.CIF, C.Nombre
HAVING COALESCE(SUM(F.Cantidad), 0) > ((SELECT SUM(F.Cantidad)
                                        FROM Financia F) / (SELECT COUNT(*)
                                                            FROM Club));

-- 4.20)
SELECT E.NIF, P.Nombre
FROM Enfrenta E JOIN Persona P ON E.NIF = P.NIF
WHERE NOT EXISTS (SELECT *
                  FROM Enfrenta EN
                  WHERE (E.NIF = EN.NIF AND E.Fecha < EN.Fecha AND E.Goles_local >= EN.Goles_local) OR (E.NIF = EN.NIF AND E.Fecha != EN.Fecha AND E.Goles_local = EN.Goles_local))
GROUP BY E.NIF, P.Nombre
HAVING COUNT(*) >= 2;
