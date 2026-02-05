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


-- _______________________PROCEDURE 2________________________ --

-- calcula el total facturat entre 2 dates
DROP PROCEDURE IF EXISTS facturacio_entre_dates;
DELIMITER //
CREATE PROCEDURE facturacio_entre_dates( in data1 date , data2 date  )
BEGIN

select sum(preu) from facturacio where CAST( hora as DATE ) between data1 and data2 ; 
 
END
//
DELIMITER ;
 
-- call facturacio_entre_dates( "2026-02-02" , "2026-02-2" );

-- _____________Procedure 3 __________________________________--

DROP PROCEDURE IF EXISTS fi_trajecte;
DELIMITER //
CREATE PROCEDURE fi_trajecte( in id_trajecte int , id_estacio int  )
BEGIN
/* comprovem que hi ha lloc lliure a la destinació*/
if (select docks_lliures from estacio where idESTACIO = id_estacio ) <= 0 then
	/* si no hi havia lloc, marquem el rtajecte amb 0 ( NO/FALSE ) per poder facturar d'acord */
	update trajecte set dock_final_lliure = false where idTRAJECTE = id_trajecte  ;
    select " Has de buscar una altra estació amb llocs lliures";
else 
	update trajecte  /* marquem hora final i estació de final*/
		set Hora_final = now() , id_EST_fin = id_estacio 
        where  idTRAJECTE = id_trajecte  ; /* pel trajecte en concret */
	/* a l'estació hem de ocupar un lloc , per tant té un lliure menys . */
    update estacio 
			set docks_lliures = docks_lliures - 1 where idESTACIO = id_estacio ; 
	update bicicleta 
			set ESTACIO_idESTACIO = id_estacio 
            where idBICICLETA = ( select BICICLETA_idBICICLETA from trajecte where idTRAJECTE = id_trajecte);
end if ;
-- select idTrajecte as "estas tancant el trajecte " from trajecte where idTRAJECTE = id_trajecte; 
END
//
DELIMITER ;


-- call fi_trajecte( 5 , 10 );
 -- _____________________Procedure 4 _______________________________--

DROP PROCEDURE IF EXISTS trajectes_en_curs;
DELIMITER //
CREATE PROCEDURE trajectes_en_curs(  )
/* retorna la llista de trajectes no finaltizats ( "en curs" i el seu origen*/
BEGIN
	select id_EST_origen , Hora_inici from trajecte where Hora_final IS NULL ;
END
//
DELIMITER ;

--   call trajectes_en_curs;    

-- _______________Procedure 5 _______________________________________-- 
