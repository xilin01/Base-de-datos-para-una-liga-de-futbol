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

COMMIT;

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
SET SERVEROUTPUT ON;
--

-- 5.1.1)
CREATE OR REPLACE FUNCTION golesLocal(resultado VARCHAR) RETURN INT IS
    i INT := 2;
    goles VARCHAR(5) := SUBSTR(resultado, 1, 1);
    aux VARCHAR(1) := SUBSTR(resultado, i, 1);
BEGIN
    WHILE aux != '-' LOOP
        goles := goles || aux;
        i := i + 1;
        aux := SUBSTR(resultado, i, 1);
    END LOOP;
RETURN CAST(goles AS INT); 
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(golesLocal('4-2'));
END;
/

-- 5.1.2)
CREATE OR REPLACE FUNCTION totalGoles(resultado VARCHAR) RETURN INT IS
    i INT := 2;
    golesLocal INT;
    golesVisitante INT;
    goles VARCHAR(5) := SUBSTR(resultado, 1, 1);
    aux VARCHAR(1) := SUBSTR(resultado, i, 1);
BEGIN
    WHILE aux != '-' LOOP
        goles := goles || aux;
        i := i + 1;
        aux := SUBSTR(resultado, i, 1);
    END LOOP;
    golesLocal := CAST(goles AS INT);
    goles := SUBSTR(resultado, i + 1, 1);
    aux := SUBSTR(resultado, i + 2, 1);
    i := i + 2;
    WHILE aux IS NOT NULL LOOP
        goles := goles || aux;
        i := i + 1;
        aux := SUBSTR(resultado, i, 1);
    END LOOP;
    golesVisitante := CAST(goles AS INT);
RETURN golesLocal + golesVisitante; 
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(totalGoles('4-2'));
END;
/

-- 5.1.3)
CREATE OR REPLACE FUNCTION factorial(n INT) RETURN INT IS
    resultado INT := -1;
BEGIN
    IF n >= 0 THEN 
        resultado := 1;
        FOR i IN 2..n LOOP
            resultado := resultado * i;
        END LOOP;
    END IF;
RETURN resultado;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(factorial(6));
END;
/

-- 5.1.4)
CREATE OR REPLACE FUNCTION esPrimo(n INT) RETURN CHAR IS
    primo CHAR(1) := '-';
    i INT := 2;
BEGIN
    IF n >= 2 THEN
        primo := 'Y';
        WHILE i < n AND primo = 'Y' LOOP
            IF MOD(n, i) = 0 THEN
                primo := 'N';
            ELSE
                i := i + 1;
            END IF;
        END LOOP;
    END IF;
RETURN primo;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(esPrimo(2));
END;
/

-- 5.1.5)
CREATE OR REPLACE FUNCTION mcd(a INT, b INT) RETURN INT IS
    resultado INT := -1;
BEGIN
    IF a >= 0 AND b >= 0 AND a > b THEN
        IF a = 0 THEN
            resultado := b;
        ELSIF b = 0 THEN
            resultado := a;
        ELSE
            resultado := mcd(b, MOD(a, b));
        END IF;
    END IF;
RETURN resultado;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(mcd(15, 10));
END;
/

-- 5.1.6)
CREATE OR REPLACE FUNCTION jugadores_mas_altos(umbral FLOAT) RETURN INT IS
    resultado INT;
BEGIN
    SELECT COUNT(*) INTO resultado
    FROM Jugador J
    WHERE J.Altura > umbral;    
RETURN resultado;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(jugadores_mas_altos(1.5));
END;
/

-- 5.1.7)
CREATE OR REPLACE FUNCTION partidosGanados(cifClub Club.CIF%TYPE) RETURN INT IS
    resultado INT;
    vLocales INT;
    vVisitantes INT;
BEGIN 
    SELECT COUNT(*) INTO resultado
    FROM Club C
    WHERE C.CIF = cifClub;
    IF resultado = 1 THEN
        SELECT COUNT(*) INTO vLocales
        FROM Enfrenta E
        WHERE E.CIF_local = cifClub AND E.GolesLocal > E.GolesVisitante;
        SELECT COUNT(*) INTO vVisitantes
        FROM Enfrenta E
        WHERE E.CIF_visitante = cifClub AND E.GolesVisitante > E.GolesLocal;
        resultado := vLocales + vVisitantes;
    ELSE 
        resultado := -1;
    END IF;
RETURN resultado;
END;
/
    
BEGIN
DBMS_OUTPUT.PUT_LINE(partidosGanados('11111111X'));
END;
/

-- 5.1.8)
CREATE OR REPLACE FUNCTION victoriasLocales(nifArbitro Arbitro.NIF%TYPE) RETURN INT IS
    resultado INT;
BEGIN 
    SELECT COUNT(*) INTO resultado
    FROM Arbitro A
    WHERE A.NIF = nifArbitro;
    IF resultado = 1 THEN
        SELECT COUNT(*) INTO resultado
        FROM Enfrenta E
        WHERE E.NIF = nifArbitro AND E.GolesLocal > E.GolesVisitante;
    ELSE 
        resultado := -1;
    END IF;
RETURN resultado;
END;
/

CREATE OR REPLACE FUNCTION victoriasLocales(nifArbitro Arbitro.NIF%TYPE) RETURN INT IS
    resultado INT := 0;
    CURSOR cEnfrenta IS SELECT C.Nombre AS Local, CL.Nombre AS Visitante, E.GolesLocal, E.GolesVisitante
                        FROM Enfrenta E JOIN Club C ON E.CIF_local = C.CIF JOIN Club CL ON E.CIF_visitante = CL.CIF
                        WHERE E.NIF = nifArbitro AND E.GolesLocal > E.GolesVisitante;
BEGIN 
    SELECT COUNT(*) INTO resultado
    FROM Arbitro A
    WHERE A.NIF = nifArbitro;
    IF resultado = 1 THEN
        resultado := 0;
        FOR row IN cEnfrenta LOOP
            DBMS_OUTPUT.PUT_LINE(row.Local || ' ' || row.GolesLocal || ' - ' || row.GolesVisitante || ' ' || row.Visitante);
            resultado := resultado + 1;
        END LOOP;
    ELSE 
        resultado := -1;
    END IF;
RETURN resultado;
END;
/
    
BEGIN
DBMS_OUTPUT.PUT_LINE(victoriasLocales('00000003X'));
END;
/

-- 5.1.9)
CREATE OR REPLACE FUNCTION clubes_por_jugadores(n Club.Num_Socios%TYPE) RETURN VARCHAR IS
    cadena VARCHAR(3000) := '';
BEGIN
    FOR row IN (SELECT C.CIF, COUNT(J.NIF) AS nJugadores
                FROM Club C LEFT JOIN Jugador J ON C.CIF = J.CIF
                WHERE C.Num_Socios > n
                GROUP BY C.CIF
                ORDER BY COUNT(J.NIF) DESC, C.CIF ASC) LOOP
        cadena := cadena || '(' || row.CIF || ',' || row.nJugadores || ')';
    END LOOP;
RETURN cadena;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(clubes_por_jugadores(500));
END;
/

-- 5.1.10)
CREATE OR REPLACE FUNCTION puntos(cifClub Club.CIF%TYPE) RETURN INT IS
    resultado INT;
BEGIN
    SELECT COUNT(*) INTO resultado
    FROM Club C
    WHERE C.CIF = cifClub;
    IF resultado = 1 THEN
        resultado := 0;
        FOR row IN (SELECT E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_local = cifCLub AND E.GolesLocal >= E.GolesVisitante) LOOP
            IF row.GolesLocal > row.GolesVisitante THEN
                resultado := resultado + 3;
            ELSE 
                resultado := resultado + 1;
            END IF;
        END LOOP;
        FOR row IN (SELECT E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_visitante = cifCLub AND E.GolesVisitante >= E.GolesLocal) LOOP
            IF row.GolesVisitante > row.GolesLocal THEN
                resultado := resultado + 3;
            ELSE 
                resultado := resultado + 1;
            END IF;
        END LOOP;
    ELSE 
        resultado := -1;
    END IF;
RETURN resultado;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(puntos('11111111X'));
END;
/

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

-- 5.2.1)
CREATE OR REPLACE PROCEDURE actualiza_altura(umbral Jugador.Altura%TYPE) IS
BEGIN
    IF umbral >= 0 THEN
        FOR row IN (SELECT J.NIF, J.Altura
                    FROM Jugador J) LOOP
             IF row.Altura > umbral THEN
                UPDATE Jugador
                SET Altura = Altura * 1.05
                WHERE NIF = row.NIF;
             ELSE
                UPDATE Jugador
                SET Altura = Altura * 1.10
                WHERE NIF = row.NIF;
             END IF;
        END LOOP;
    END IF;
END;
/

BEGIN
  actualiza_altura(1.7);
  actualiza_altura(-0.75);
END;
/

-- 5.2.2)
DROP TABLE JugadoresBorrados;

CREATE TABLE JugadoresBorrados(
    CIF CHAR(9) PRIMARY KEY
);

CREATE OR REPLACE PROCEDURE borra_jugadores(umbral Jugador.Altura%TYPE) IS
BEGIN
    FOR row IN (SELECT J.NIF, J.Altura
                FROM Jugador J) LOOP
         IF row.Altura <= umbral THEN
            DELETE FROM Jugador
            WHERE NIF = row.NIF;
            INSERT INTO JugadoresBorrados VALUES (row.NIF);
         END IF;       
    END LOOP;
END;
/

BEGIN
  borra_jugadores(1.7);
END;
/

-- 5.2.3)
CREATE OR REPLACE PROCEDURE puntua_clubes_asistencia IS
BEGIN
    DELETE FROM Clasificacion;
    FOR row IN (SELECT C.CIF
                FROM Club C) LOOP
        INSERT INTO Clasificacion VALUES (row.CIF, 0);
    END LOOP;
    FOR row IN (SELECT A.CIF_local, A.CIF_visitante, COUNT(*) AS nAsistentes
                FROM Asiste A
                GROUP BY A.CIF_local, A.CIF_visitante) LOOP
        IF row.nAsistentes >= 2 THEN
            UPDATE Clasificacion
            SET Puntos = Puntos + 2
            WHERE CIF = row.CIF_local OR CIF = row.CIF_visitante;
        ELSIF row.nAsistentes = 1 THEN
            UPDATE Clasificacion
            SET Puntos = Puntos + 1
            WHERE CIF = row.CIF_local OR CIF = row.CIF_visitante;
        END IF;
    END LOOP;
END;
/

-- 5.2.4)
CREATE OR REPLACE PROCEDURE actualiza_socios(cifClub Club.CIF%TYPE) IS
    existe INT;
BEGIN 
    SELECT COUNT(*) INTO existe
    FROM Club C
    WHERE C.CIF = cifClub; 
    IF existe = 1 THEN
        FOR row IN (SELECT COUNT(*) AS nAsistentes
                    FROM Asiste A
                    WHERE A.CIF_local = cifCLub OR A.CIF_visitante = cifClub
                    GROUP BY A.CIF_local, A.CIF_visitante) LOOP
            IF 1 <= row.nAsistentes AND row.nAsistentes <= 3 THEN
                UPDATE Club
                SET Num_Socios = Num_Socios + 10
                WHERE CIF = cifClub;
            ELSIF row.nAsistentes > 3 THEN
                UPDATE Club
                SET Num_Socios = Num_Socios + 100
                WHERE CIF = cifClub;
            END IF;
        END LOOP;
    END IF;
END;
/

BEGIN
  actualiza_socios('11111111X');
  actualiza_socios('11111122J');  
  actualiza_socios('11111113X');
END;
/

CREATE OR REPLACE PROCEDURE actualiza_socios(cifClub Club.CIF%TYPE) IS
    existe INT;
    cont INT := 0;
    nombre Club.Nombre%TYPE; 
BEGIN 
    SELECT COUNT(*) INTO existe
    FROM Club C
    WHERE C.CIF = cifClub; 
    IF existe = 1 THEN
        SELECT C.Nombre INTO nombre
        FROM Club C
        WHERE C.CIF = cifClub;
        DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO NUMERO DE SOCIOS DEL CLUB: ' || nombre); 
        DBMS_OUTPUT.PUT_LINE('#############################################################');
        FOR row IN (SELECT C.Nombre AS Local, CL.Nombre AS Visitante, COUNT(A.NIF) AS nAsistentes
                    FROM Enfrenta E LEFT JOIN Asiste A ON (E.CIF_local = A.CIF_local AND E.CIF_visitante = A.CIF_visitante) JOIN Club C ON E.CIF_local = C.CIF JOIN Club CL ON E.CIF_visitante = CL.CIF
                    WHERE E.CIF_local = cifCLub OR E.CIF_visitante = cifClub
                    GROUP BY C.Nombre, CL.Nombre) LOOP
            DBMS_OUTPUT.PUT_LINE(existe || ') ' || row.Local || ' vs. ' || row.Visitante); 
            IF row.nAsistentes = 0 THEN 
                DBMS_OUTPUT.PUT_LINE(row.nAsistentes || ' asistentes -> +0 socios');
                DBMS_OUTPUT.PUT_LINE('');
            ELSIF 1 <= row.nAsistentes AND row.nAsistentes <= 3 THEN
                DBMS_OUTPUT.PUT_LINE(row.nAsistentes || ' asistentes -> +10 socios');
                DBMS_OUTPUT.PUT_LINE('');
                cont := cont + 10;  
            ELSE 
                DBMS_OUTPUT.PUT_LINE(row.nAsistentes || ' asistentes -> +100 socios');
                DBMS_OUTPUT.PUT_LINE('');
                cont := cont + 100;
            END IF;
            existe := existe + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('TOTAL: incremento de ' || cont || ' socios nuevos'); 
        UPDATE Club
        SET Num_Socios = Num_Socios + cont
        WHERE CIF = cifClub;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ningún club con CIF ' || cifClub);        
    END IF;
END;
/

BEGIN
  actualiza_socios('11111111X');
  actualiza_socios('11111124X');  
END;
/

-- 5.2.5)
CREATE OR REPLACE PROCEDURE actualiza_patrocinios(cifClub Club.CIF%TYPE) IS
    existe INT;
    cont INT := 0;
BEGIN
    SELECT COUNT(*) INTO existe
    FROM Club C
    WHERE C.CIF = cifCLub;
    IF existe = 1 THEN
        FOR row IN (SELECT E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_local = cifClub AND E.GolesLocal > E.GolesVisitante) LOOP
            cont := cont + (row.GolesLocal - row.GolesVisitante) * 100;
        END LOOP;
        FOR row IN (SELECT E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_visitante = cifClub AND E.GolesVisitante > E.GolesLocal) LOOP
            cont := cont + (row.GolesVisitante - row.GolesLocal) * 200;
        END LOOP;        
        FOR row IN (SELECT E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_visitante = cifClub AND E.GolesVisitante = E.GolesLocal) LOOP
            cont := cont + 50;  
        END LOOP;      
        UPDATE Financia
        SET Cantidad = Cantidad + cont
        WHERE CIF_C = cifCLub;
    END IF;
END;
/

BEGIN
  actualiza_patrocinios('11111111X');
  actualiza_patrocinios('11111145G');
  actualiza_patrocinios('11111113X');
END;
/   

CREATE OR REPLACE PROCEDURE actualiza_patrocinios(cifClub Club.CIF%TYPE) IS
    existe INT;
    cont INT := 0;
    nombre Club.Nombre%TYPE;
BEGIN
    SELECT COUNT(*) INTO existe
    FROM Club C
    WHERE C.CIF = cifCLub;
    IF existe = 1 THEN
        SELECT C.Nombre INTO nombre
        FROM Club C
        WHERE C.CIF = cifClub;
        DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO PATROCINIOS DEL CLUB: ' || nombre);
        DBMS_OUTPUT.PUT_LINE('#############################################################');
        FOR row IN (SELECT E.CIF_local, E.CIF_visitante, E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_local = cifClub OR E.CIF_visitante = cifClub) LOOP
            DBMS_OUTPUT.PUT(row.CIF_local || ' - ' || row.CIF_visitante || ' (' || row.GolesLocal || '-' || row.GolesVisitante || ') -> +');
            IF row.GolesLocal > row.GolesVisitante THEN
                IF row.CIF_local = cifCLub THEN
                    DBMS_OUTPUT.PUT_LINE((row.GolesLocal - row.GolesVisitante) * 100 || ' EUR');
                    cont := cont + (row.GolesLocal - row.GolesVisitante) * 100;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('0 EUR');
                END IF;
            ELSIF row.GolesLocal = row.GolesVisitante THEN
                IF row.CIF_visitante = cifCLub THEN
                    DBMS_OUTPUT.PUT_LINE('50 EUR');
                    cont := cont + 50;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('0 EUR');
                END IF;
            ELSE 
                IF row.CIF_visitante = cifCLub THEN
                    DBMS_OUTPUT.PUT_LINE((row.GolesVisitante - row.GolesLocal) * 200 || ' EUR');
                    cont := cont + (row.GolesVisitante - row.GolesLocal) * 200;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('0 EUR');
                END IF;
            END IF;
        END LOOP; 
        DBMS_OUTPUT.PUT_LINE('* Actualizando +' || cont || ' EUR cada patrocinio al club');
        UPDATE Financia
        SET Cantidad = Cantidad + cont
        WHERE CIF_C = cifCLub;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe ningún club con CIF ' || cifClub);
    END IF;
END;
/

BEGIN
  actualiza_patrocinios('11111112X');
  actualiza_patrocinios('11111117X');
END;
/   

-- 5.2.6)
CREATE OR REPLACE PROCEDURE clasifica IS
    puntos INT;
    golesFavor INT;
    golesContra INT;
BEGIN
    DELETE FROM Clasificacion;
    FOR i IN (SELECT C.CIF
              FROM Club C) LOOP
        puntos := 0;
        golesFavor := 0; 
        golesContra := 0;
        FOR j IN (SELECT E.CIF_local, E.CIF_visitante, E.GolesLocal, E.GolesVisitante
                    FROM Enfrenta E
                    WHERE E.CIF_local = i.CIF OR E.CIF_visitante = i.CIF) LOOP
            IF j.GolesLocal > j.GolesVisitante THEN
                IF j.CIF_local = i.CIF THEN
                    puntos := puntos + 3;
                    golesFavor := golesFavor + j.GolesLocal;
                    golesContra := golesContra + j.golesVisitante;
                ELSE
                    golesFavor := golesFavor + j.GolesVisitante;
                    golesContra := golesContra + j.golesLocal;
                END IF;
            ELSIF j.GolesLocal = j.GolesVisitante THEN
                puntos := puntos + 1;
                IF j.CIF_local = i.CIF THEN
                    golesFavor := golesFavor + j.GolesLocal;
                    golesContra := golesContra + j.golesVisitante;
                ELSE
                    golesFavor := golesFavor + j.GolesVisitante;
                    golesContra := golesContra + j.golesLocal;
                END IF;
            ELSE 
                IF j.CIF_visitante = i.CIF THEN
                    puntos := puntos + 3;
                    golesFavor := golesFavor + j.GolesVisitante;
                    golesContra := golesContra + j.golesLocal;
                ELSE
                    golesFavor := golesFavor + j.GolesLocal;
                    golesContra := golesContra + j.golesVisitante;
                END IF;
            END IF;
        END LOOP;
        INSERT INTO Clasificacion VALUES (i.CIF, puntos, golesFavor, golesContra);
    END LOOP;
END;
/
