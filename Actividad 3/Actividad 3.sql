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
    GolesLocal INTEGER NOT NULL CHECK (GolesLocal >= 0),
    GolesVisitante INTEGER NOT NULL CHECK (GolesVisitante >= 0),
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

-- 3.1.1)
SELECT DISTINCT P.Nombre
FROM Enfrenta E JOIN Persona P ON E.NIF = P.NIF
WHERE E.GolesLocal > E.GolesVisitante;

-- 3.1.2)
SELECT DISTINCT P.Rama
FROM Patrocinador P JOIN Financia F on P.CIF = F.CIF_P JOIN Club C ON F.CIF_C = C.CIF
WHERE 50000 < C.Num_Socios;

-- 3.1.3)
SELECT DISTINCT P.NIF, P.Nombre
FROM Persona P JOIN Asiste A ON P.NIF = A.NIF JOIN Enfrenta E ON (A.CIF_local = E.CIF_local AND A.CIF_visitante = E.CIF_visitante)
WHERE E.GolesLocal > E.GolesVisitante;

-- 3.1.4)
SELECT P.NIF, P.Nombre
FROM Persona P LEFT JOIN Jugador J ON P.NIF = J.NIF
WHERE J.CIF IS NULL
ORDER BY P.NIF ASC;

-- 3.1.5)
SELECT C.Nombre AS "ClubLocal", E.GolesLocal, E.GolesVisitante, CL.Nombre AS "ClubVisitante"
FROM Club C JOIN Enfrenta E ON C.CIF = E.CIF_local JOIN Club CL ON E.CIF_visitante = CL.CIF
WHERE E.GolesLocal > E.GolesVisitante
ORDER BY E.GolesLocal DESC, E.GolesVisitante DESC, C.Nombre DESC;

-- 3.1.6)
(SELECT DISTINCT C.Nombre
FROM Club C JOIN Enfrenta E ON C.CIF = E.CIF_local
WHERE E.GolesLocal > E.GolesVisitante)
MINUS
(SELECT DISTINCT C.Nombre
FROM Club C JOIN Enfrenta E ON C.CIF = E.CIF_local
WHERE E.GolesLocal <= E.GolesVisitante);

-- 3.1.7)
(SELECT DISTINCT C.Nombre
FROM Club C JOIN Enfrenta E ON C.CIF = E.CIF_local JOIN Persona P ON E.NIF = P.NIF
WHERE P.Nombre = 'Velasco Carballo')
UNION
(SELECT DISTINCT C.Nombre
FROM Enfrenta E JOIN Club C ON E.CIF_visitante = C.CIF JOIN Persona P ON E.NIF = P.NIF
WHERE P.Nombre = 'Velasco Carballo');

-- 3.1.8)
(SELECT DISTINCT P.NIF, P.Nombre
FROM Asiste A JOIN Jugador J ON A.NIF = J.NIF JOIN Persona P ON J.NIF = P.NIF)
UNION
(SELECT DISTINCT P.NIF, P.Nombre
FROM Asiste A JOIN Arbitro AR ON A.NIF = AR.NIF JOIN Persona P ON AR.NIF = P.NIF);

-- 3.2.1)
SELECT CIF, COUNT(*) AS "NumJugadores"
FROM Jugador
GROUP BY CIF;

-- 3.2.2)
SELECT C.CIF, C.Nombre, COUNT(*) AS "NumJugadores"
FROM Club C JOIN Jugador J ON C.CIF = J.CIF
GROUP BY C.CIF, C.Nombre;

-- 3.2.3)
SELECT MIN(Altura), MAX(Altura), ROUND(AVG(Altura), 4)
FROM Jugador J JOIN Persona P ON J.NIF = P.NIF
WHERE P.Nombre LIKE '%e%' OR P.Nombre LIKE '%E%';

-- 3.2.4)
SELECT P.NIF, P.Nombre
FROM Persona P JOIN Asiste A ON P.NIF = A.NIF JOIN Enfrenta E ON (A.CIF_local = E.CIF_local AND A.CIF_visitante = E.CIF_visitante)
WHERE E.GolesLocal > E.GolesVisitante
GROUP BY P.NIF, P.Nombre
HAVING COUNT(*) = 1;

-- 3.2.5)
SELECT P.NIF, P.Nombre, COUNT(*) AS "PartidosArbitrados"
FROM Enfrenta E JOIN Persona P ON E.NIF = P.NIF
GROUP BY P.NIF, P.Nombre
ORDER BY COUNT(*) DESC;

-- 3.2.6)
SELECT P.NIF, P.Nombre, COUNT(E.Fecha) AS "PartidosArbitrados"
FROM Arbitro A LEFT JOIN Enfrenta E ON A.NIF = E.NIF JOIN Persona P ON A.NIF = P.NIF
GROUP BY P.NIF, P.Nombre;

-- 3.2.7)
SELECT C.CIF, C.Nombre, AVG(F.Cantidad) AS "PromedioFinanciaciones", COUNT(*) AS "TotalFinanciaciones"
FROM Club C JOIN Financia F ON C.CIF = F.CIF_C
GROUP BY C.CIF, C.Nombre;

-- 3.2.8)
SELECT C.CIF, C.Nombre, COALESCE(AVG(F.Cantidad), 0) AS "PromedioFinanciaciones", COUNT(F.Cantidad) AS "TotalFinanciaciones"
FROM Club C LEFT JOIN Financia F ON C.CIF = F.CIF_C
GROUP BY C.CIF, C.Nombre;

-- 3.2.9)
SELECT C.CIF, C.Nombre, COALESCE(SUM(F.Cantidad), 0) AS "SumaFinanciaciones"
FROM Club C LEFT JOIN Financia F ON C.CIF = F.CIF_C
GROUP BY C.CIF, C.Nombre
ORDER BY COALESCE(SUM(F.Cantidad), 0) DESC, C.CIF DESC;

-- 3.2.10)
SELECT CIF
FROM Jugador    
GROUP BY CIF
HAVING 1 < COUNT(*);

-- 3.2.11)
SELECT C.CIF, C.Nombre
FROM Club C JOIN Jugador J ON C.CIF = J.CIF
GROUP BY C.CIF, C.Nombre
HAVING 1 < COUNT(*);

-- 3.2.12)
SELECT P.CIF AS "CIF_PATROCINADOR", COUNT(DISTINCT J.CIF) AS "NumClubesConPatrocinio"
FROM Patrocinador P LEFT JOIN Patrocina PA ON P.CIF = PA.CIF LEFT JOIN Jugador J ON PA.NIF = J.NIF
GROUP BY P.CIF
ORDER BY COUNT(DISTINCT J.CIF) DESC, P.CIF ASC;