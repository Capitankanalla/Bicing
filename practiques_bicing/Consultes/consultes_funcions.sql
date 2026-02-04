-- Consultes de la tasca:

SHOW TRIGGERS LIKE 'TRAJECTE';
SHOW TRIGGERS;


-- Per saber quantes i quines id tenen les bicis electriques que tenim.
SELECT
   idBICICLETA,
   nivell_bateria(idBICICLETA) AS nivell
   FROM BICICLETA
   WHERE electrica = 1;

-- prova del trigger del Estat de carrega
SELECT idBICICLETA, electrica, batt_lvl
FROM BICICLETA
WHERE idBICICLETA = 2;    -- Veiem el nivell de bateria de la bici num 2
-- I ara provem si la podem utilitzar i hauría de donar un error.
SELECT idBICICLETA, batt_lvl
FROM BICICLETA
WHERE electrica = 1;



 