-- Generem un procediment per cada cop que un usuari agafa una bici executi el procediment per
-- fer un trajecte.

DELIMITER //

CREATE PROCEDURE generar_trajecte()
BEGIN
    INSERT INTO TRAJECTE 
    (Hora_inici, Hora_final, dock_final_lliure, 
     id_EST_origen, id_EST_fin,
     BICICLETA_idBICICLETA, USUARI_idUSUARI)
    SELECT
        DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
        DATE_ADD(NOW(), INTERVAL FLOOR(RAND() * 720) MINUTE),
        1,
        FLOOR(1 + (RAND() * 50)),
        FLOOR(1 + (RAND() * 50)),
        b.idBICICLETA,
        FLOOR(1 + (RAND() * 15))
    FROM BICICLETA b
    JOIN DOCK d ON d.bicicleta_idBICICLETA = b.idBICICLETA
    WHERE NOT EXISTS (
        SELECT 1
        FROM TRAJECTE t
        WHERE t.BICICLETA_idBICICLETA = b.idBICICLETA
          AND t.Hora_final IS NULL
    )
    ORDER BY RAND()
    LIMIT 1;
END//

DELIMITER ;


CALL generar_trajecte();

-- SELECT * FROM TRAJECTE ORDER BY idTRAJECTE DESC LIMIT 5;

