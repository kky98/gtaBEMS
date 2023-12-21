
  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."NOW_DCHART_VIEW" ("BE_FLOOR", "LABEL", "BE_AC_ENERGY", "BE_PLUG_ENERGY", "BE_LIGHT_ENERGY") AS 
  SELECT be_floor,
  CASE
    WHEN EXTRACT(HOUR FROM be_date) >= 12
    THEN TO_CHAR(TRUNC(be_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(be_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END AS label,
  SUM(be_ac_energy) AS be_ac_energy,
  SUM(be_plug_energy) AS be_plug_energy,
  SUM(be_light_energy) AS be_light_energy
FROM be_device
WHERE TRUNC(be_date) = TRUNC(SYSDATE)
  AND b_id = 'gta'
  AND (
    (TO_CHAR(SYSDATE, 'HH24:MI:SS') >= '00:00:00' AND TO_CHAR(SYSDATE, 'HH24:MI:SS') < '12:00:00' AND TO_CHAR(be_date, 'HH24:MI:SS') < '12:00:00') OR
    (TO_CHAR(SYSDATE, 'HH24:MI:SS') >= '12:00:00' AND TO_CHAR(SYSDATE, 'HH24:MI:SS') <= '23:59:59' AND TO_CHAR(be_date, 'HH24:MI:SS') >= '12:00:00')
  )
GROUP BY 
be_floor,
  CASE
    WHEN EXTRACT(HOUR FROM be_date) >= 12
    THEN TO_CHAR(TRUNC(be_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(be_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END
  ORDER BY label;

