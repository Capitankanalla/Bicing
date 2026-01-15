(
  SELECT 
      -- 'MES LLARG' AS tipus,
      idTRAJECTE,
      BICICLETA_idBICICLETA,
      TIMESTAMPDIFF(MINUTE, Hora_inici, Hora_final) AS durada_minuts
  FROM TRAJECTE
  WHERE Hora_final IS NOT NULL
  ORDER BY durada_minuts DESC
   LIMIT 3
)
UNION ALL
(
  SELECT 
      -- 'MES CURT' AS tipus,
      idTRAJECTE,
      BICICLETA_idBICICLETA,
      TIMESTAMPDIFF(MINUTE, Hora_inici, Hora_final) AS durada_minuts
  FROM TRAJECTE
  WHERE Hora_final IS NOT NULL
  ORDER BY durada_minuts DESC
  LIMIT 3
);
