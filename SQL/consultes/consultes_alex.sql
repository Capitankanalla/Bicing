-- 1. Iniciem les consultes dels diferents trajcetes realitzats.

 select idTRAJECTE, id_EST_origen, USUARI_idUSUARI from trajecte;

-- 2. La idea es a partir d´aquesta consulta generar noves
-- com quants trajectes a fet un usuari en concret, etc.

select idUSUARI, cognoms, DNI, tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS from usuari;

-- 3. Busquem el trajecte, la bici i la hora final del trajecte.
-- Important per la facturació.

 select idTRAJECTE, BICICLETA_idBICICLETA, Hora_final from trajecte;

-- 4. Veiem les suscripcions de cada usuari, sense id.
select Cognoms, DNI, tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS from usuari;

-- 5. quin tipus de suscripcio pot tenir cada usuari
-- per comptabilitzar el temps extra si n´hi ha.

select idSUBSCRIPCIONS, nom_de_plan from tipus_subscripcions; 

-- 6. Localitzem on es cada bicicleta. 
-- Amb un inner join podrem saber també a quina estacio es troba.

select idBICICLETA, ESTACIO_idESTACIO from bicicleta;

-- 7. Veiem les suscripcions de cada usuari, sense id.
select Cognoms, DNI, tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS from usuari;

-- 8. quin tipus de suscripcio pot tenir cada usuari
-- per comptabilitzar el temps extra si n´hi ha.

select idSUBSCRIPCIONS, nom_de_plan from tipus_subscripcions; 

-- 9. Consultem els usuaris amb dni  i el total registrat
SELECT 
    u.Nom,
    u.Cognoms,
    t.total_usuaris
FROM USUARI u
JOIN (
    SELECT COUNT(*) AS total_usuaris
    FROM USUARI
) t;
select precio_hora_extra from tipus_subscripcions;

-- 10. Consulta dels usuaris, el total registrat i el pla de cada un.
SELECT 
    e.ubicacio,
    COUNT(b.idBICICLETA) AS bicicletes,
    (e.num_docksBicing - COUNT(b.idBICICLETA)) AS docks_lliures_reals
FROM ESTACIO e
LEFT JOIN BICICLETA b 
    ON e.idESTACIO = b.ESTACIO_idESTACIO
GROUP BY e.idESTACIO, e.ubicacio, e.num_docksBicing;


-- 11. Consulta per mostrar el tipus de suscripcio del usuari 
-- la tarifa per penalitzacio.
SELECT 
    u.Cognoms,
    u.DNI,
    t.nom_de_plan,
    t.TIEMPO_GRATIS,
    t.precio_por_MEDIA_hora,
    t.precio_hora_extra
FROM USUARI u
JOIN tipus_SUBSCRIPCIONS t
    ON u.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS = t.idSUBSCRIPCIONS;
    
-- 12. Càlcul penalitzacio usuaris que han sobrepassat la tarifa contractada.
SELECT 
    t.idTRAJECTE,
    u.Nom,
    u.Cognoms,
    ts.nom_de_plan,
    TIMESTAMPDIFF(MINUTE, t.Hora_inici, t.Hora_final) AS durada_minuts,
    TIMESTAMPDIFF(HOUR, t.Hora_inici, t.Hora_final) AS durada_hores,
    precio_hora_extra *  TIMESTAMPDIFF(HOUR, t.Hora_inici, t.Hora_final) AS penalitzacio
FROM TRAJECTE t
JOIN USUARI u ON t.USUARI_idUSUARI = u.idUSUARI
JOIN tipus_SUBSCRIPCIONS ts
  ON u.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS = ts.idSUBSCRIPCIONS
WHERE t.Hora_final IS NOT NULL
AND TIMESTAMPDIFF(MINUTE, t.Hora_inici, t.Hora_final) > ts.TIEMPO_GRATIS;

-- 13. Els docks lliures de cada estacio comparant-lo amb els docks totals: 

SELECT 
    e.ubicacio,
    e.num_docksBicing        AS docks_totals,
    COUNT(b.idBICICLETA)     AS bicicletes,
    (e.num_docksBicing - COUNT(b.idBICICLETA)) AS docks_lliures
FROM ESTACIO e
LEFT JOIN BICICLETA b 
    ON e.idESTACIO = b.ESTACIO_idESTACIO
GROUP BY 
    e.idESTACIO, 
    e.ubicacio, 
    e.num_docksBicing;
    
 -- 14. Consulta per saber les estacions que registres més moviment inicial.
 
 SELECT 
    e.ubicacio,
    COUNT(t.idTRAJECTE) AS inici_trajecte
FROM TRAJECTE t
JOIN ESTACIO e ON t.id_EST_origen = e.idESTACIO
GROUP BY e.idESTACIO, e.ubicacio
ORDER BY inici_trajecte DESC;

-- 15. Consulta que registra les destinacions més moviments
SELECT 
    e.ubicacio,
    COUNT(t.idTRAJECTE) AS est_final
FROM TRAJECTE t
JOIN ESTACIO e ON t.id_EST_fin = e.idESTACIO
GROUP BY e.idESTACIO, e.ubicacio
ORDER BY est_final DESC;

-- ----------------- SUBCONSULTES -------------------------------------------------------

-- 16. consulta amb subconsulta que registra el inici i les recepcions de cada estacio.

SELECT 
    e.ubicacio,
    (SELECT COUNT(*) 
     FROM TRAJECTE t 
     WHERE t.id_EST_origen = e.idESTACIO) AS num_inicis,
    (SELECT COUNT(*) 
     FROM TRAJECTE t 
     WHERE t.id_EST_fin = e.idESTACIO) AS num_destins
FROM ESTACIO e
ORDER BY num_inicis DESC, num_destins DESC;

select batt_lvl from bicicleta;

-- 17. Consulta amb subconsulta de la quantitat de bicis electriques de cada estacio
-- i el % de carrega restant. Si no hi ha bici electrica a la estacio, la consulta 
-- sortirà la columna bici_electrica buida però el total_bici amb el total de bicicletes 
-- que hi ha anclades als docks.
SELECT 
    e.ubicacio,
    IFNULL(
        (SELECT GROUP_CONCAT(b.idBICICLETA, ': ', b.batt_lvl, '%'  ORDER BY b.idBICICLETA SEPARATOR ', ')
         FROM BICICLETA b
         WHERE b.ESTACIO_idESTACIO = e.idESTACIO
           AND b.electrica = 1
        ), ''
    ) AS bicicletes_electriques,
    (SELECT COUNT(*) 
     FROM BICICLETA b
     WHERE b.ESTACIO_idESTACIO = e.idESTACIO
    ) AS total_bici_estacio
FROM ESTACIO e;

-- SELECT idBICICLETA, data_ultim_manteniment FROM BICICLETA;

-- 18. Consulta amb subconsulta que aivsa dels manteniments de les bicicletes
-- calcula els dies sense manteniment i controla el % de bateria de les
-- bicicletes electriques.

SELECT 
    b.idBICICLETA,
    b.ESTACIO_idESTACIO,
    b.electrica,
    IFNULL(b.batt_lvl, '–') AS batt_lvl,
    b.incident_acumulats,
    b.data_ultim_manteniment,
    b.dies_des_de_ultim_manteniment,
    IF(b.electrica = 1, b.batt_lvl, '–') AS bateria_restant
FROM (
    -- Subconsulta que prepara la informació i calcula dies sense manteniment
    SELECT 
        idBICICLETA,
        ESTACIO_idESTACIO,
        electrica,
        batt_lvl,
        incident_acumulats,
        data_ultim_manteniment,
        DATEDIFF(CURDATE(), data_ultim_manteniment) AS dies_des_de_ultim_manteniment
    FROM BICICLETA
) b
WHERE b.dies_des_de_ultim_manteniment > 30
   OR (b.electrica = 1 AND b.batt_lvl <= 20)
ORDER BY b.dies_des_de_ultim_manteniment DESC, b.batt_lvl ASC;



