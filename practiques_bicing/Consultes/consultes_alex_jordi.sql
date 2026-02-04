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

-- --------------------------------------------------------------------------------------------------
-- SELECT * FROM BICICLETA;
-- SELECT * FROM DOCK ;
-- SELECT * FROM estacio;
-- select * FROM tipus_subscripcions;
-- select * from trajecte;
-- select * from usuari ;

-- SELECT * FROM estacio;
/* -- fet servir per canviar els docks lliures de cada estacio
 update estacio 
set docks_lliures = 7
where idestacio >= 39 && idestacio <= 50 
;
*/

select count(idUSUARI) as 'usuaris del pla anual'  from usuari  where usuari.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS = 3 ;
select count(idUSUARI) as 'usuaris del pla trimestral'  from usuari  where usuari.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS = 2 ;
select count(idUSUARI) as 'usuaris del pla diari'  from usuari  where usuari.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS = 1 ;
select count(idusuari) as 'usuaris totals' from usuari; 

-- usuaris de cada plan
select TS.nom_de_plan , count(U.idusuari) as 'nombre d\'usuaris'
from tipus_subscripcions TS join usuari U on TS.idSUBSCRIPCIONS = U.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS
group by TS.nom_de_plan;

-- estacions -- 

select ubicacio , E.docks_lliures , round((E.docks_lliures / E.num_docksBicing * 100) , 2 ) as "% lliure"  from estacio E 
where (( docks_lliures / num_docksBicing * 100 ) <= 100 )  -- esta a 100 però serveix per qualsevol % si es canvai el 100 per 10 50 ... 
order by 3 desc
-- limit 10 
-- podem agafar els que volguem, també amb limit 10, agafem 10...
;

-- 10 estacions amb més trajectes iniciats i finalitzats

select E.ubicacio , count( T.id_EST_origen)  as "trajectes inicats" from estacio E join trajecte T on T.id_EST_origen = E.idESTACIO 
group by ubicacio
order by 2 DESC
limit 10
;
select E.ubicacio , count( T.id_EST_fin)  as "trajectes finalitzats" from estacio E join trajecte T on T.id_EST_fin = E.idESTACIO 
group by E.ubicacio
order by 2 DESC
limit 10
;


/* 
-- hauria de poder donar iniciats i finalitzats a cada ubi/estacio 

select E.ubicacio , count(T.id_Est_fin) as "trajectes finalitzats"    , count(T.id_est_origen) as "trajecte iniciats"
from Estacio E left join trajecte T 
group  by E.ubicacio
order by 2 DESC
;

*/


/* consulta quantes bicis electriques te cada estacio*/

select e.idESTACIO , E.ubicacio /* , count(B.idbicicleta) */ , count(B.electrica) as "bicis electriques"  from estacio E join Bicicleta B on B.ESTACIO_idestacio = e.idestacio 
where B.electrica = 1 
group by e.idestacio 
order by 3 desc
;
-- consulta estacio a estacio per comprovar el resultat de la taula anterior
-- select * from bicicleta B where B.ESTACIO_idESTACIO = 1 order by B.electrica desc;

-- trajectes amb bici electrica 

select count(T.idtrajecte ) from trajecte T 
join bicicleta B on B.idBICICLETA = T.BICICLETA_idBICICLETA
where B.electrica = 1
;
-- per comprovar 
-- select * from trajecte ;

/* usuaris ordenats per més a menys trajectes i amb quin pla ho han fet*/
select U.idusuari , U.nom , count(T.idtrajecte) , TS.nom_de_plan as PLA from usuari U join trajecte T on T.USUARI_idUSUARI = U.idUSUARI  join tipus_subscripcions TS on U.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS = TS.idSUBSCRIPCIONS
group by u.idusuari
order by 3 desc
;

/*nombre de trajectes asociats a cada pla*/

select TS.nom_de_plan as "subscripció" , count(T.idtrajecte) as "nombre de trajectes" from trajecte T join usuari U on T.USUARI_idUSUARI = U.idUSUARI join tipus_subscripcions TS on TS.idSUBSCRIPCIONS = U.tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS
group by TS.idSUBSCRIPCIONS  
;



