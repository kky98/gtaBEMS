
  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."WEEK_CHART_VIEW" ("DAY", "LABEL", "DAY_OF_WEEK", "YESTERDAY_DATA", "TODAY_DATA", "TOTAL_MODEL_DATA", "AC_DATA", "PLUG_DATA", "LIGHT_DATA") AS 
  SELECT 
    yesterday.day AS day,
    COALESCE(yesterday.label, today.label, total_model.label, ac_model.label, plug_model.label, light_model.label) AS label,
    COALESCE(yesterday.day_of_week, today.day_of_week, total_model.day_of_week, ac_model.day_of_week, plug_model.day_of_week, light_model.day_of_week) AS day_of_week,
    COALESCE(yesterday.yesterday_data, 0) AS yesterday_data,
    COALESCE(today.today_data, 0) AS today_data,
    COALESCE(total_model.total_model_data, 0) AS total_model_data,
    COALESCE(ac_model.ac_data, 0) AS ac_data,
    COALESCE(plug_model.plug_data, 0) AS plug_data,
    COALESCE(light_model.light_data, 0) AS light_data
FROM (
    -- 어제 저장데이터(1시간 단위)
   SELECT 
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
  TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(be_date, 'DY') AS day_of_week,
  SUM(be_total_energy) AS yesterday_data
FROM be_device
WHERE TRUNC(be_date) BETWEEN TRUNC(SYSDATE-7, 'D') AND TRUNC(SYSDATE, 'D') - 1
    AND b_id = 'gta'
GROUP BY TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00', TO_CHAR(be_date, 'DY'),
TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00'
ORDER BY day
) yesterday
FULL OUTER JOIN (
    SELECT 
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
   TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(be_date, 'DY') AS day_of_week,
  SUM(be_total_energy) AS today_data
FROM be_device
WHERE TRUNC(be_date) > TRUNC(SYSDATE, 'D') -1-- 현재 주의 시작일 이후
  AND b_id = 'gta'
GROUP BY TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00', TO_CHAR(be_date, 'DY'),
TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00'
ORDER BY day
) today ON yesterday.label = today.label AND yesterday.day_of_week = today.day_of_week
FULL OUTER JOIN (
    SELECT 
  TO_CHAR(MODEL_DATE, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(MODEL_DATE, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
  TO_CHAR(MODEL_DATE, 'DY')||TO_CHAR(TRUNC(TO_CHAR(MODEL_DATE, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(MODEL_DATE, 'DY') AS day_of_week,
  SUM(MODEL_ENERGY) AS total_model_data
FROM model_prediction
WHERE TRUNC(MODEL_DATE) BETWEEN TRUNC(SYSDATE+7, 'D') AND TRUNC(SYSDATE+7, 'D') + 6
    AND division = 'total'
GROUP BY  TO_CHAR(MODEL_DATE, 'DY')||TO_CHAR(TRUNC(TO_CHAR(MODEL_DATE, 'HH24')/6+1)*6, 'FM00') || ':00', TO_CHAR(MODEL_DATE, 'DY'), TO_CHAR(MODEL_DATE, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(MODEL_DATE, 'HH24')/6+1)*6, 'FM00') || ':00'
ORDER BY day
) total_model ON yesterday.label = total_model.label AND yesterday.day_of_week = total_model.day_of_week
FULL OUTER JOIN (
    SELECT 
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
  TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(be_date, 'DY') AS day_of_week,
  SUM(BE_AC_ENERGY) AS ac_data
FROM be_device
WHERE TRUNC(be_date) > TRUNC(SYSDATE, 'D')-1 -- 현재 주의 시작일 이후
    AND b_id = 'gta'
GROUP BY TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00', TO_CHAR(be_date, 'DY'), TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00'
ORDER BY day
) ac_model ON yesterday.label = ac_model.label AND yesterday.day_of_week = ac_model.day_of_week
FULL OUTER JOIN (
    SELECT 
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
  TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(be_date, 'DY') AS day_of_week,
  SUM(be_plug_energy) AS plug_data
FROM be_device
WHERE TRUNC(be_date) > TRUNC(SYSDATE, 'D')-1 -- 현재 주의 시작일 이후
    AND b_id = 'gta'
GROUP BY TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00', TO_CHAR(be_date, 'DY'), TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00'
ORDER BY day
) plug_model ON yesterday.label = plug_model.label AND yesterday.day_of_week = plug_model.day_of_week
FULL OUTER JOIN (
    SELECT 
  TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS day,
  TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00' AS label,
  TO_CHAR(be_date, 'DY') AS day_of_week,
  SUM(be_light_energy) AS light_data
FROM be_device
WHERE TRUNC(be_date) > TRUNC(SYSDATE, 'D')-1 -- 현재 주의 시작일 이후
    AND b_id = 'gta'
GROUP BY TO_CHAR(be_date, 'DY')||TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00', TO_CHAR(be_date, 'DY'), TO_CHAR(be_date, 'YYYY-MM-DD') || ' ' || TO_CHAR(TRUNC(TO_CHAR(be_date, 'HH24')/6+1)*6, 'FM00') || ':00'
ORDER BY day
) light_model ON yesterday.label = light_model.label AND yesterday.day_of_week = light_model.day_of_week
ORDER BY day;

