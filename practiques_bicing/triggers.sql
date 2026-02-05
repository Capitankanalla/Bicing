-- TRIGGERS

-- 1. validar_bateria -- abans d´assignar una bici electrica validar l´estat de carrega)
DELIMITER //

CREATE TRIGGER validar_bateria_abans_sortir
BEFORE INSERT ON TRAJECTE
FOR EACH ROW
BEGIN
    DECLARE nivell INT;
    DECLARE es_electrica INT;

    SELECT electrica, batt_lvl
    INTO es_electrica, nivell
    FROM BICICLETA
    WHERE idBICICLETA = NEW.BICICLETA_idBICICLETA;

    -- Si és elèctrica i té menys del 20%, NO pot iniciar trajecte
    IF es_electrica = 1 AND nivell < 20 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bateria insuficient: aquesta bici no pot iniciar trajecte';
    END IF;
END//

DELIMITER ;

-- 2. inici_trajecte -- sumar un dock lliure de la estacio on es la bici
DELIMITER //

CREATE TRIGGER iniciar_trajecte
BEFORE INSERT ON TRAJECTE
FOR EACH ROW
BEGIN
    -- Afegir 1 dock lliure a l'estació origen
    UPDATE ESTACIO
    SET docks_lliures = docks_lliures + 1
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

        -- Restar 1 dock lliure
        UPDATE ESTACIO
        SET docks_lliures = docks_lliures - 1
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
DELIMITER //

CREATE TRIGGER validar_subscripcio_abans_sortir
BEFORE INSERT ON TRAJECTE
FOR EACH ROW
BEGIN
    DECLARE data_fi DATE;
    DECLARE dies_restants INT;

    -- Obtenir la data de fi de la subscripció de l’usuari
    SELECT data_fi
    INTO data_fi
    FROM SUBSCRIPCIO
    WHERE USUARI_idUSUARI = NEW.USUARI_idUSUARI;

    -- Si no té subscripció → bloquejar
    IF data_fi IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La teva subscripció s´ha acabat';
    END IF;

    SET dies_restants = DATEDIFF(data_fi, CURDATE());

    -- Subscripció caducada → bloquejar
    IF dies_restants < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Subscripció caducada: truca al tlf  ********* per reactivar-la';
    END IF;

    -- Subscripció a punt de caducar → avisar
    IF dies_restants BETWEEN 0 AND 5 THEN
        INSERT INTO AVIS_SUBSCRIPCIO (idUsuari, data_avis, dies_restants, missatge)
        VALUES (NEW.USUARI_idUSUARI, NOW(), dies_restants, 'La teva subscripció caducarà aviat');
    END IF;

END//

DELIMITER ;

-- 5. Trigger per avisar al sistema de estacions plenes amb un preavis de 2 docks lliures
DELIMITER //

CREATE TRIGGER dokcs_plens
AFTER UPDATE ON bicicleta
FOR EACH ROW
BEGIN
    DECLARE docks_lliures INT;
     DECLARE msg VARCHAR(255);
    
    IF NEW.ESTACIO_idESTACIO <> OLD.ESTACIO_idESTACIO THEN
    
        SET docks_lliures = calcula_docks_lliures(NEW.ESTACIO_idESTACIO);

        IF docks_lliures <= 3 THEN
                SET msg = CONCAT(
                    'AVIS: l''estacio ', NEW.ESTACIO_idESTACIO,
                    ' esta gairebe plena (', docks_lliures, ' docks lliures)'
                );
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = msg;
        END IF;

    END IF;
END//

DELIMITER ;
