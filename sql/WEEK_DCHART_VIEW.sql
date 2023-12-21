
  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."WEEK_DCHART_VIEW" ("BE_FLOOR", "DAY", "LABEL", "DAY_OF_WEEK", "BE_AC_ENERGY", "BE_PLUG_ENERGY", "BE_LIGHT_ENERGY") AS 
  SELECT 
    be_floor,
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
 TO_CHAR(be_date, 'DY')|| TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(be_date, 'DY') AS day_of_week,
  SUM(be_ac_energy) AS be_ac_energy,
  SUM(be_plug_energy) AS be_plug_energy,
  SUM(be_light_energy) AS be_light_energy
FROM be_device
WHERE TRUNC(be_date) > TRUNC(SYSDATE, 'D') -1-- 현재 주의 시작일 이후
  AND b_id = 'gta'
GROUP BY be_floor,
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00',
 TO_CHAR(be_date, 'DY')|| TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' ,
  TO_CHAR(be_date, 'DY') 
  ORDER BY day;

