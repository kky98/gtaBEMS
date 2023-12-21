
  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "GTA"."DAY_CHART_VIEW" ("LABEL", "YESTERDAY_DATA", "TODAY_DATA", "TOTAL_MODEL_DATA") AS 
  SELECT 
    COALESCE(yesterday.label, today.label, total_model.label) AS label,
    COALESCE(yesterday.yesterday_data, 0) AS yesterday_data,
    COALESCE(today.today_data, 0) AS today_data,
    COALESCE(total_model.total_model_data, 0) AS total_model_data

FROM (
    -- 어제 저장데이터(1시간 단위)
    SELECT TO_CHAR(TRUNC(be_date, 'HH24'), 'HH24:MI') AS label,
           SUM(be_total_energy) AS yesterday_data
    FROM be_device
    WHERE TO_CHAR(be_date, 'YY-MM-DD') = TO_CHAR(SYSDATE-1, 'YY-MM-DD')
      AND b_id = 'gta'
    GROUP BY TRUNC(be_date, 'HH24')
) yesterday
FULL OUTER JOIN (
    -- 오늘 저장데이터(1시간 단위)
    SELECT TO_CHAR(TRUNC(be_date, 'HH24'), 'HH24:MI') AS label,
           SUM(be_total_energy) AS today_data
    FROM be_device
    WHERE TO_CHAR(be_date, 'YY-MM-DD') = TO_CHAR(SYSDATE, 'YY-MM-DD')
      AND b_id = 'gta'
    GROUP BY TRUNC(be_date, 'HH24')
) today ON yesterday.label = today.label
FULL OUTER JOIN (
    -- 예측 total 저장데이터(1시간 단위)
    SELECT TO_CHAR(TRUNC(model_date, 'HH24'), 'HH24:MI') AS label,
           SUM(model_energy) AS total_model_data
    FROM model_prediction
    WHERE TO_CHAR(model_date, 'YY-MM-DD') = TO_CHAR(SYSDATE, 'YY-MM-DD')
      AND division = 'total'
    GROUP BY TRUNC(model_date, 'HH24')
) total_model ON yesterday.label = total_model.label

ORDER BY TO_DATE(label, 'HH24:MI');