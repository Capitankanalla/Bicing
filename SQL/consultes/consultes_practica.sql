-- Iniciem les consultes dels diferents trajcetes realitzats.
-- De moment NO es treballen els trajectes en curs.

 select idTRAJECTE, id_EST_origen, USUARI_idUSUARI from trajecte;

-- La idea es a partir d´aquesta consulta generar noves
-- com quants trajectes a fet un usuari en concret, etc.

-- describe usuari;
select idUSUARI, cognoms, DNI, tipus_SUBSCRIPCIONS_idSUBSCRIPCIONS from usuari;

-- Busquem el trajecte, la bici i la hora final del trajecte.
-- Important per la facturació.

 -- select idTRAJECTE, BICICLETA_idBICICLETA, Hora_final from trajecte;

-- select
-- Localitzem on es cada bicicleta. 
-- Amb un inner join podrem saber també a quina estacio es troba.

select idBICICLETA, ESTACIO_idESTACIO from bicicleta;

-- Consultem els usuaris amb dni  i el total registrat
SELECT 
    u.Nom,
    u.Cognoms,
    t.total_usuaris
FROM USUARI u
JOIN (
    SELECT COUNT(*) AS total_usuaris
    FROM USUARI
) t;






 