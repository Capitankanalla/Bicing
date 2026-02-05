-- EVENTOS

-- 1. event_estat_bateries  
-- verifica els estats de les bateries cada hora

CREATE EVENT IF NOT EXISTS event_estat_bateries
ON SCHEDULE EVERY 1 HOUR
DO
    UPDATE BICICLETA
    SET incident_acumulats = incident_acumulats + 1    
    WHERE electrica = 1 AND batt_lvl < 20;

-- 2. actualitzar els docks lliures
drop event if exists repassa_llocs_lliures ;
delimiter //
create event repassa_llocs_lliures 
-- cada X (amb START i END ) 
-- 
on schedule every 1 day
STARTS "2026-01-29 3:00"
-- també se li pot dir quan deixa de córrer
ENDS '2026-02-28 12:00:00'
-- cada X temps
-- on schedule every 15 second
-- un sol cop amb data concreta
-- on schedule at "2026-01-29 17:43"
do
begin
	-- set @count = 1 ;
    set @ID = (select count(*) from estacio ) ; /* calculem quantes estacions hi ha */
    while @ID > 0 do
			update estacio 
				set docks_lliures = calcula_docks_lliures( @ID ) where idESTACIO = @ID;
            set @ID = @ID - 1 ;
    end while;
end //
delimiter ;


-- -- 3. avisar usuaris inactius
CREATE EVENT IF NOT EXISTS neteja_usuaris_inactius
ON SCHEDULE EVERY 1 DAY
DO
    CALL gestionar_usuaris_inactius();
-- 4. bloquejar_bici es repassa cada hora l´estat de la flota de bicis  
-- una bici amb incidencies obertes no es pot assignar a cap usuari.
CREATE EVENT IF NOT EXISTS estat_bici
ON SCHEDULE EVERY 1 HOUR
DO
    UPDATE BICICLETA
    SET ESTACIO_idESTACIO = NULL   -- bici retirada del servei
    WHERE incident_acumulats >= 3;


-- 5. validar_estat_bici -- una bici arreglada pot tornar a possar-se al dock
CREATE EVENT IF NOT EXISTS event_validar_estat_bici
ON SCHEDULE EVERY 1 HOUR
DO
    UPDATE BICICLETA
    SET ESTACIO_idESTACIO = 1
    WHERE incident_acumulats = 0 AND ESTACIO_idESTACIO IS NULL;


