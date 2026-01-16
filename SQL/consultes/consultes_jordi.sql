
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

