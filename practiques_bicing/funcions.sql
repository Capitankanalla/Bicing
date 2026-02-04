-- Recomanacions funcions, procedures, triggers i events

-- FUNCIONS.

-- 1. Calcular_cost trajecte(id_trajecte)
-- 2. nivell bateria(id_bicicleta)
DELIMITER //

CREATE FUNCTION nivell_bateria(id_bici INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE nivell INT;

    SELECT batt_lvl
    INTO nivell
    FROM BICICLETA
    WHERE idBICICLETA = id_bici
      AND electrica = 1;

    RETURN nivell;
END//

DELIMITER ;

-- 3. duracio_trajecte(id_trajecte)
 DELIMITER //
 
CREATE FUNCTION duracio_trajecte(idT INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE minuts INT;

    SELECT TIMESTAMPDIFF(MINUTE, Hora_inici, Hora_final)
    INTO minuts
    FROM TRAJECTE
    WHERE idTRAJECTE = idT;

    RETURN minuts;
END;

DELIMITER; 

select * from 


-- 4 incidéncies_bici(id_bici)
-- 5.Bici_operativa(id_bici)
DELIMITER //

CREATE FUNCTION Bici_operativa(id_bici INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE incidents INT;
    DECLARE electrica TINYINT;
    DECLARE bateria DECIMAL(3,0);

    SELECT incident_acumulats, electrica, batt_lvl
    INTO incidents, electrica, bateria
    FROM bicicleta
    WHERE idBICICLETA = id_bici;

    IF incidents >= 3 THEN
        RETURN 'NO OPERATIVA';
    END IF;

    IF electrica = 1 AND bateria < 20 THEN
        RETURN 'NO OPERATIVA';
    END IF;

    RETURN 'OPERATIVA';
END//

DELIMITER ;

-- Validem estat de les bicis
SELECT * FROM bicicleta WHERE idBICICLETA = 5;
SELECT Bici_operativa(5);


-- PROCEDURES

-- 1. Iniciar_trajecte(id_trajecte, id_estacioFi)
-- 2. finalitzar_trajecte(id_trajecte, id_estacio_fi)
-- 3. assignar_bici(id_usuari, id_estacio)
-- 4. actualitzar_estacio(id_bici, id_nova_ubicacio)
-- 5. reinserir_bici(id_bici) -- per les bicicletes retirades del servei per incidencies.

-- TRIGGERS

-- 1. validar_bateria -- abans d´assignar una bici electrica validar l´estat de carrega)
-- 2. inici_trajecte -- sumar un dock lliure de la estacio on es la bici
DELIMITER //

CREATE TRIGGER iniciar_trajecte
BEFORE INSERT ON TRAJECTE
FOR EACH ROW
BEGIN
    -- Restar 1 dock lliure a l'estació origen
    UPDATE ESTACIO
    SET docks_lliures = docks_lliures - 1
    WHERE idESTACIO = NEW.id_EST_origen;
END//

DELIMITER ;


-- 3. Final_trajecte -- restar un dock de la estacio on es deixa la bici
DELIMITER //

CREATE TRIGGER finalitzar_trajecte
AFTER UPDATE ON TRAJECTE
FOR EACH ROW
BEGIN
    DECLARE docks INT;

    -- activa quan el trajecte es tanca no abans
    IF OLD.Hora_final IS NULL AND NEW.Hora_final IS NOT NULL THEN
        
        -- Comprovar docks lliures a l'estació final
        SELECT docks_lliures INTO docks
        FROM ESTACIO
        WHERE idESTACIO = NEW.id_EST_fin;

        IF docks <= 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No hi ha docks lliures a l\'estació final';
        END IF;

        -- Sumar 1 dock lliure
        UPDATE ESTACIO
        SET docks_lliures = docks_lliures + 1
        WHERE idESTACIO = NEW.id_EST_fin;

        -- Moure la bici a l'estació final
        UPDATE BICICLETA
        SET ESTACIO_idESTACIO = NEW.id_EST_fin
        WHERE idBICICLETA = NEW.BICICLETA_idBICICLETA;

    END IF;
END//

DELIMITER ;




-- Abans del trigger els docks estàn tots buits.
SELECT idESTACIO, docks_lliures 
FROM ESTACIO 
WHERE idESTACIO IN (5,1);

INSERT INTO TRAJECTE
(Hora_inici, Hora_final, dock_final_lliure, id_EST_origen, id_EST_fin,
 BICICLETA_idBICICLETA, USUARI_idUSUARI)
VALUES
(NOW(), NULL, 1, 5, 10, 3, 2);




-- 4. caducitat_subscripcio -- Verificar i avisar al usuari que la seva subscripcio caduca
-- 5. eliminar_usuari -- si la subscripcio té més de 6 mesos inactiva eliminar usuari

-- EVENTOS

-- 1. event_estat_bateries  -- verificar els estats de les bateries cada cop que s´utilitzen les bicis
-- 2. reset_estacions  -- Cada nit a les 03:00 reiniciar els docks
-- 3. actualitzar_estat_bici -- si una bici té incidents o l´usuari informa d´un inciedn, gestionmar retirada immediata
-- 4. bloquejar_bici  -- una bici amb incidencia oberta no es pot assignar a cap usuari.
-- 5. validar_estat_bici -- una bici arreglada pot tornar a possar-se al dock

