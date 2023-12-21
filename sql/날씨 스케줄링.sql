-- 스케줄링을 위한 Job 정의
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'JOB2',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN INSERT_bw_DATA; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; INTERVAL=1',
    enabled         => TRUE
  );
END;
--함수정의
CREATE OR REPLACE PROCEDURE INSERT_bw_DATA IS
BEGIN
  INSERT INTO bw_in_out_realtime (bw_id, bw_date,bw_floor,bw_in_degc,bw_in_lux,bw_in_rh, bw_out_sun,bw_out_degc)
  SELECT
  i.bw_id,
  sysdate,
  i.bw_floor,
  i.bw_in_degc,
  i.bw_in_lux,
  i.bw_in_rh,
  TRUNC(o.bw_out_sun * 100) AS bw_out_sun,
  o.bw_out_degc
FROM
  bw_in i
JOIN
  bw_out o ON TO_CHAR(i.bw_date, 'YYYYMMDD HH24:MI') = TO_CHAR(o.bw_date, 'YYYYMMDD HH24:MI')
WHERE
  TO_CHAR(i.bw_date, 'YYYYMMDD HH24:MI') = TO_CHAR(SYSDATE, 'YYYYMMDD HH24:MI');
  -- 위의 WHERE 절을 사용하여 같은 시간의 모든 데이터를 가져옵니다.
  COMMIT; -- 변경 내용을 확정
END;

--시간을 변수에 저장
DECLARE
  nowdate TIMESTAMP;
BEGIN
  SELECT SYSTIMESTAMP INTO nowdate FROM DUAL;
  
  -- nowdate 변수에 현재 시간이 저장되었으므로, 필요에 따라 사용할 수 있습니다.
  DBMS_OUTPUT.PUT_LINE('현재 시간: ' || TO_CHAR(nowdate, 'YYYY-MM-DD HH24:MI:SS'));
END;


select *
from b_data
where be_floor = '2';

SELECT job_name, status, actual_start_date, run_duration
FROM user_scheduler_job_run_details
ORDER BY actual_start_date DESC;



BEGIN
    DBMS_SCHEDULER.DROP_JOB('INSERT_DATA');
END;


SELECT BE_DATE, BE_AC_ENERGY, BE_LIGHT_ENERGY,BE_PLUG_ENERGY,BE_TOTAL_ENERGY,BE_FLOOR
  FROM b_data
  WHERE be_date = (SELECT MIN(be_date) FROM b_data)
SELECT *
FROM b_data;

sELECT *
FROM be_device;