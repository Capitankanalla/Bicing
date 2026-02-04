-- Recomanacions funcions, procedures, triggers i events

-- FUNCIONS.

-- 1. Calcular_cost trajecte(id_trajecte)
DROP FUNCTION IF EXISTS calcula_preu_trajecte;

DELIMITER //

CREATE FUNCTION calcula_preu_trajecte( id_trajecte int )
RETURNS decimal(8,2)
BEGIN
	set @cost = 0 ;
	-- de l'usuari associat, mirem la seva subscripció
	set @userID =	(select USUARI_idUSUARI from trajecte 	where idTRAJECTE = id_trajecte  ); /* id d'usuari igual a la del trajecte en si  	*/
    set @subscricpio = (select tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS from usuari where idUsuari = 	@userID  ) ;			 
                            /* la id de subscripcio de l'usuari que té la id de l'usuari del trajecte */ 
	set @primera_mitja_hora = ( select precio_por_MEDIA_hora from tipus_subscripcions where idSUBSCRIPCIONS = @subscricpio );
	set @TEMPS_GRATIS = ( select TIEMPO_GRATIS from tipus_subscripcions where idSUBSCRIPCIONS = @subscricpio );
    set @preu_hora_extra = ( select precio_hora_extra from tipus_subscripcions where idSUBSCRIPCIONS = @subscricpio );
    set @preu_minut = @preu_hora_extra / 60  ;
	set @dest_lliure = (select dock_final_lliure from trajecte where idTRAJECTE = id_trajecte );
    if ( select trajecte.Hora_final from trajecte where idTRAJECTE = id_trajecte ) IS NOT NULL then 
        		set @Temps =  ( select  TIMESTAMPDIFF(minute, trajecte.Hora_inici , trajecte.Hora_final) from trajecte where idTRAJECTE = id_trajecte  ) ;
	else 
				return 0 ;
    end if; /* si té hora final, asignem un temps, sinó... 0 */ 
    
    
    
if !@dest_lliure then  /* si la destinació no té llocs lliures */
		set  @temps = @temps - 30  ; /* restem 30 min al temps a facturar */
end if ;

/* si no hem arribat al tram de pagament, retornem @cost que era 0 */ 
if  @TEMPS_GRATIS >= @Temps then 
	 set @cost = 0 ; 
/* en la resta de casos...*/
else 
    -- set @COST = @COST + @primera_mitja_hora , @temps = @temps - 30  ; /* afegim al cost el preu de la primera mitja hora  i restem 30 min al temps*/
    set  @temps = @temps - @TEMPS_GRATIS   ;
    set @cost = @cost +  @temps * @preu_minut; 
 end if;
    return @cost;
END
//
DELIMITER ;

-- select calcula_preu_trajecte(3);

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


-- call fi_trajecte( 9 , 10 );
 
-- 3. assignar_bici(id_usuari, id_estacio)
-- 4. actualitzar_estacio(id_bici, id_nova_ubicacio)
 /* -- reinserir_bici(id_bici) -- per les bicicletes retirades del servei per incidencies. */
-- 5. mostra els trajectes en curs i la seva hora i estació d'origen , i la durada fins al moment.
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

