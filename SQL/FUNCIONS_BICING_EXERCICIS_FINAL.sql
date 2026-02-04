USE `bicing_prac` ; 

/* 5 FUNCIONs 

DROP FUNCTION IF EXISTS function_name;

DELIMITER //

CREATE FUNCTION function_name
RETURNS <tipus_a_retornar>
BEGIN
        -- tu código aquí
return <elqueretornis i que sigui del tipus indicat a retornar>
END
//
DELIMITER ;
*/

/* FUNCIO 1 */
-- calcula docks lliures amd la ID de l'estació 
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

-- /* FUNCIO 2 */
DROP FUNCTION IF EXISTS calcula_preu_trajecte;

DELIMITER //

CREATE FUNCTION calcula_preu_trajecte( id_trajecte int )
RETURNS decimal(8,2)
BEGIN
	set @cost = 0 ;
	-- de l'usuari associat, mirem la seva subscripció
	set @userID =	(select USUARI_idUSUARI from trajecte 	where idTRAJECTE = id_trajecte  ); /* id d'usuari igual a la del trajecte en si  	*/
    set @subscricpio = (select tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS from usuari where idUsuari = 	@userID  ) ;			 
    /* la id de subscripcio de l'usuari que té la id de l'usuari	del trajecte		*/ 
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
    
    
    
if !@dest_lliure then  
		set  @temps = @temps - 30  ; /* restem 30 min al temps a facturar , xk no era lliure,*/
end if ;

/* si no hem arribat al tram de pagament, retornem @cost que era 0 */ 
if  @TEMPS_GRATIS >= @Temps then 
	 set @cost = 0 ; 
/* en la resta de casos...*/
else 
    -- set @COST = @COST + @primera_mitja_hora , @temps = @temps - 30  ; /* afegim al cost el preu de la primera mitja hora  i restem 30 min al temps*/
    set @cost = @cost +  @temps * @preu_minut; 
 
end if;
    return @cost;
END
//
DELIMITER ;

select calcula_preu_trajecte(3);

/* FUNCIO 3 */
-- calcula el preu d'un trajecte



/* FUNCIO 4 */

/* FUNCIO 5 */
-- ------------------------ --
/* 5 PROCEDURES 
DROP PROCEDURE IF EXISTS procedure_name;
DELIMITER //
CREATE PROCEDURE procedure_name( in < params entrada <nom tipus> , > , out <params sortida> )

BEGIN
-- tu código aquí
END
//
DELIMITER ;
*/ 

/* PROCEDURE 1*/
-- mostra els trajectes en curs i la seva hora i estació d'origen , i la durada fins al moment.
DROP PROCEDURE IF EXISTS trajectes_en_curs;
DELIMITER //
CREATE PROCEDURE trajectes_en_curs(  )
/* retorna la llista de trajectes no finaltizats ( "en curs" i el seu origen*/
BEGIN
	select id_EST_origen , Hora_inici from trajecte where Hora_final IS NULL ;
END
//
DELIMITER ;

          
-- call trajectes_en_curs; 

/* PROCEDURE 2 */

-- calcula els docks lliures i actualitza les taules d'estació 

/* PROCEDURE 3  */

-- en tancar un trajecte 
-- 		resta un dock lliure a l'estació de final
-- 				o si està ocupat canvia dock_final_lliure = false 
-- 		calcula el preu del trajecte
DROP PROCEDURE IF EXISTS fi_trajecte;
DELIMITER //
CREATE PROCEDURE fi_trajecte( in id_trajecte int , id_estacio int  )
BEGIN
/* comprovem que hi ha lloc lliure a la destinació*/
if (select docks_lliures from estacio where idESTACIO = id_estacio ) = 0 then
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
end if ;
END
//
DELIMITER ;

 call fi_trajecte( 1 , 2 );
 call fi_trajecte( 2 , 3 );
 
 
/* PROCEDURE 4  */


/* PROCEDURE 5  */
-- calcula el total facturat entre 2 dates

-- ---------------------- --

/* 5 TRIGGERS */ 


/* TRIGGER 1 */ 

-- quan afegim bicicleta , resta un lloc lliure a docks_lliures de l'estació on hem deixat la bicicleta
DROP TRIGGER IF EXISTS actualitza_docs_lliures;
DELIMITER //
CREATE TRIGGER actualitza_docs_lliures
AFTER insert ON bicicleta
FOR EACH ROW
BEGIN
/* per restar a docks lliures de l'estació on deixem la bicicleta*/
	update estacio set docks_lliures = docks_lliures - 1  where estacio.idESTACIO = new.ESTACIO_idESTACIO ;
END
//
DELIMITER ;

/* TRIGGER 2 */

-- en iniciar un trajecte : 
-- 		augmenta els llocs docks_lliures de l'estació
-- 		canvia la Estacio_idestacio de la bicicleta (bicicleta.ESTACIO_idESTACIO) a -1  ( -1 xk no pot ser null

/* TRIGGER 3 */
/* TRIGGER 4 */
/* TRIGGER 5 */

-- ---------------------- -- 

/* 5 EVENTOS  

drop event if exists nombre_evento ;
delimiter //
create event nombre_evento
-- cada X (amb START i END ) -- on schedule every 1 day

-- STARTS "2026-01-29 17:43"
-- també se li pot dir quan deixa de córrer
-- ENDS 'YYYY-MM-DD HH:MM:SS'

-- cada X temps
-- on schedule every 15 second

-- un sol cop amb data concreta
-- on schedule at "2026-01-29 17:43"
do
begin
        -- codi aquí
end //
delimiter ;

*/

/* EVENT 1 */ 
-- cada dia fa resum dels trajectes

drop event if exists repassa_llocs_lliures ;
delimiter //
create event repassa_llocs_lliures 
-- cada X (amb START i END ) 
-- 
on schedule every 1 day
STARTS "2026-01-29 18:00"
-- també se li pot dir quan deixa de córrer
ENDS '2026-02-28 12:00:00'
-- cada X temps
-- on schedule every 15 second
-- un sol cop amb data concreta
-- on schedule at "2026-01-29 17:43"
do
begin
	set @count = 1 ;
    set @ID = (select count(*) from estacio ) ; /* calculem quantes estacions hi ha */
    while @ID > 0 do
			update estacio 
				set docks_lliures = calcula_docks_lliures( @ID ) where idESTACIO = @ID;
            set @ID = @ID - 1 ;
    end while;
end //
delimiter ;


/* EVENT 2 */ 
-- cada dia mostra total facturat 
/* EVENT 3 */ 

/* EVENT 4 */ 

/* EVENT 5 */ 
