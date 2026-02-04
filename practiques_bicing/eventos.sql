-- EVENTOS

-- 1. event_estat_bateries  -- verificar els estats de les bateries cada cop que s´utilitzen les bicis

-- 3. actualitzar_estat_bici -- si una bici té incidents o l´usuari informa d´un inciedn, gestionmar retirada immediata
-- 4. bloquejar_bici  -- una bici amb incidencia oberta no es pot assignar a cap usuari.
-- 5. validar_estat_bici -- una bici arreglada pot tornar a possar-se al dock


-- 2. reset_estacions  -- Cada nit a les 03:00 reiniciar els docks
/* 
event per actulitzar els dpocks lliure cada dia, per si de cas alguna cosa hagu´ñes anat mala,ment 
    ha sigut util mentre feiem proves quan els inserts 
    no tenien el trigger de sumar i restar al deixcar/recollir bicicletes
*/


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
