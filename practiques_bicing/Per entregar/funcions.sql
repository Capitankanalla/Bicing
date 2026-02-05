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


-- 4 manteniment_bici(id_bici)
-- Comprobem quantes bicicletes necessiten manteniment o són averiades
DELIMITER //

CREATE FUNCTION cal_manteniment (p_id_bici INT)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE v_incidents INT;
    DECLARE v_greu INT;

    -- Nombre total d'incidències acumulades
    SELECT incident_acumulats
    INTO v_incidents
    FROM BICICLETA
    WHERE idBICICLETA = p_id_bici;

    -- Última incidència greu
    SELECT 
        MAX(roda + frens + manillar + sillin)
    INTO v_greu
    FROM INCIDENT_feedback i
    JOIN TRAJECTE t ON i.TRAJECTE_idTRAJECTE = t.idTRAJECTE
    WHERE t.BICICLETA_idBICICLETA = p_id_bici;

    IF v_incidents >= 3 OR v_greu >= 1 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END //

DELIMITER ;

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

-- _____________FUNC_5__________________-- 

DROP FUNCTION IF EXISTS calcula_docks_lliures ; 

DELIMITER //
CREATE FUNCTION calcula_docks_lliures (  id_estacio int )
RETURNS int 
BEGIN       
       set @num_bicis   =  	(select count(idBicicleta) from bicicleta where ESTACIO_idESTACIO = id_estacio  ) ;
       set @dock_lliure = 	( select num_docksBicing from estacio where idESTACIO = id_estacio ) - @num_bicis ;
return @dock_lliure  ;

END
//
DELIMITER ;



