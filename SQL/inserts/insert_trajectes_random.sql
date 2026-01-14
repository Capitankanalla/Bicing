DELIMITER $$

CREATE PROCEDURE generar_trajectes(IN num INT)
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < num DO
        INSERT INTO TRAJECTE 
        (Hora_inici, Hora_final, dock_final_lliure, id_EST_origen, id_EST_fin,
         BICICLETA_idBICICLETA, BICICLETA_ESTACIO_idESTACIO, USUARI_idUSUARI)
        SELECT
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
            DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
            1,
            FLOOR(1 + (RAND() * 50)),
            FLOOR(1 + (RAND() * 50)),
            b.idBICICLETA,
            b.ESTACIO_idESTACIO,
            FLOOR(1 + (RAND() * 15))
        FROM bicicleta b
        ORDER BY RAND()
        LIMIT 1;

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

INSERT INTO TRAJECTE 
(Hora_inici, Hora_final, dock_final_lliure, id_EST_origen, id_EST_fin,
 BICICLETA_idBICICLETA, BICICLETA_ESTACIO_idESTACIO, USUARI_idUSUARI)
SELECT
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
    DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
    1,
    FLOOR(1 + (RAND() * 50)),
    FLOOR(1 + (RAND() * 50)),
    b.idBICICLETA,
    b.ESTACIO_idESTACIO,
    FLOOR(1 + (RAND() * 15))
FROM bicicleta b
ORDER BY RAND()
LIMIT 1;

CALL generar_trajectes(100);

