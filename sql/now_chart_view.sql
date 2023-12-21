
  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."NOW_CHART_VIEW" ("LABEL", "TODAY_DATA", "YESTERDAY_DATA", "TOTAL_MODEL_DATA") AS 
  SELECT 
  COALESCE(yesterday.label, today.label, total_model.label) AS label,
  COALESCE(today.TODAY_DATA, 0) AS TODAY_DATA,
  COALESCE(yesterday.YESTERDAY_DATA, 0) AS YESTERDAY_DATA,
  COALESCE(total_model.TOTAL_MODEL_DATA, 0) AS TOTAL_MODEL_DATA
FROM 
(
    -- 저번(30분단위)
    SELECT 
  CASE
    WHEN EXTRACT(HOUR FROM be_date) >= 12
    THEN TO_CHAR(TRUNC(be_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(be_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END AS label,
  SUM(be_total_energy) AS yesterday_data
FROM be_device
WHERE TO_CHAR(TRUNC(be_date), 'YYYY-MM-DD') = TO_CHAR(TRUNC(SYSDATE - INTERVAL '12' HOUR), 'YYYY-MM-DD')
  AND b_id = 'gta'
  AND (
    (TO_CHAR((SYSDATE - INTERVAL '12' HOUR), 'HH24:MI:SS') >= '00:00:00' AND TO_CHAR((SYSDATE - INTERVAL '12' HOUR), 'HH24:MI:SS') < '12:00:00' AND TO_CHAR(be_date, 'HH24:MI:SS') < '12:00:00') OR
    (TO_CHAR((SYSDATE - INTERVAL '12' HOUR), 'HH24:MI:SS') >= '12:00:00' AND TO_CHAR((SYSDATE - INTERVAL '12' HOUR), 'HH24:MI:SS') <= '23:59:59' AND TO_CHAR(be_date, 'HH24:MI:SS') >= '12:00:00')
  )
GROUP BY 
  CASE
    WHEN EXTRACT(HOUR FROM be_date) >= 12
    THEN TO_CHAR(TRUNC(be_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(be_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END
ORDER BY label
  ) yesterday FULL OUTER JOIN 

  (
    -- 이번(30분단위)
  SELECT 
  CASE
    WHEN EXTRACT(HOUR FROM be_date) >= 12
    THEN TO_CHAR(TRUNC(be_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(be_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END AS label,
  SUM(be_total_energy) AS TODAY_DATA
FROM be_device
WHERE TRUNC(be_date) = TRUNC(SYSDATE)
  AND b_id = 'gta'
  AND (
    (TO_CHAR(SYSDATE, 'HH24:MI:SS') >= '00:00:00' AND TO_CHAR(SYSDATE, 'HH24:MI:SS') < '12:00:00' AND TO_CHAR(be_date, 'HH24:MI:SS') < '12:00:00') OR
    (TO_CHAR(SYSDATE, 'HH24:MI:SS') >= '12:00:00' AND TO_CHAR(SYSDATE, 'HH24:MI:SS') <= '23:59:59' AND TO_CHAR(be_date, 'HH24:MI:SS') >= '12:00:00')
  )
GROUP BY 
  CASE
    WHEN EXTRACT(HOUR FROM be_date) >= 12
    THEN TO_CHAR(TRUNC(be_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(be_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(be_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END
ORDER BY label
  ) today ON  yesterday.label = today.label

  FULL OUTER JOIN 
  (
    -- 예측(30분단위)
    SELECT 
  CASE
    WHEN EXTRACT(HOUR FROM model_date) >= 12
    THEN TO_CHAR(TRUNC(model_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(model_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(model_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(model_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END AS label,
  SUM(model_energy) AS total_model_data
FROM model_prediction
WHERE TO_CHAR(TRUNC(model_date), 'YYYY-MM-DD') = TO_CHAR(TRUNC(SYSDATE + INTERVAL '12' HOUR), 'YYYY-MM-DD')
  AND division = 'total'
  AND (
    (TO_CHAR((SYSDATE + INTERVAL '12' HOUR), 'HH24:MI:SS') >= '00:00:00' AND TO_CHAR((SYSDATE - INTERVAL '12' HOUR), 'HH24:MI:SS') < '12:00:00' AND TO_CHAR(model_date, 'HH24:MI:SS') < '12:00:00') OR
    (TO_CHAR((SYSDATE + INTERVAL '12' HOUR), 'HH24:MI:SS') >= '12:00:00' AND TO_CHAR((SYSDATE - INTERVAL '12' HOUR), 'HH24:MI:SS') <= '23:59:59' AND TO_CHAR(model_date, 'HH24:MI:SS') >= '12:00:00')
  )
GROUP BY 
  CASE
    WHEN EXTRACT(HOUR FROM model_date) >= 12
    THEN TO_CHAR(TRUNC(model_date - INTERVAL '12' HOUR, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(model_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
    ELSE TO_CHAR(TRUNC(model_date, 'HH24') + (TRUNC(TO_NUMBER(TO_CHAR(model_date, 'MI')) / 30) * (1/48)) + INTERVAL '30' MINUTE, 'HH24:MI')
  END
ORDER BY label
 ) total_model  ON yesterday.label = total_model.label
ORDER BY label;

