
  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."MONTH_CHART_VIEW" ("LABEL", "YESTERDAY_DATA", "TOTAL_MODEL_DATA", "TODAY_DATA") AS 
  SELECT 
  COALESCE(yesterday.label, total_model.label, today.label) AS label,
  COALESCE(yesterday.yesterday_data, 0) AS yesterday_data,
  COALESCE(total_model.total_model_data, 0) AS total_model_data,
  COALESCE(today.today_data, 0) AS today_data
FROM (
  -- 이전 저장데이터(일 단위)
  SELECT 
    TO_CHAR(TRUNC(be_date), 'DD') AS label,
    SUM(be_total_energy) AS yesterday_data
  FROM be_device
  WHERE TO_CHAR(be_date, 'YY-MM') = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YY-MM')
    AND b_id = 'gta'
  GROUP BY TRUNC(be_date)
) yesterday
FULL OUTER JOIN (
  -- 이번달 저장데이터(일 단위)
  SELECT TO_CHAR(TRUNC(be_date), 'DD') AS label,
       SUM(be_total_energy) AS today_data
FROM be_device
WHERE TO_CHAR(be_date, 'YY-MM') = TO_CHAR(SYSDATE, 'YY-MM')
  AND b_id = 'gta'
GROUP BY TRUNC(be_date)
ORDER BY TRUNC(be_date)
) today ON yesterday.label = today.label
FULL OUTER JOIN (
  -- 모델 저장데이터(일 단위)
  SELECT TO_CHAR(TRUNC(model_date), 'DD') AS label,
       SUM(model_energy) AS total_model_data
FROM model_prediction
WHERE TO_CHAR(model_date, 'YY-MM') = TO_CHAR(SYSDATE,'YY-MM')
  AND division = 'total'
GROUP BY TRUNC(model_date)
ORDER BY TRUNC(model_date)
) total_model ON yesterday.label = total_model.label

ORDER BY label;