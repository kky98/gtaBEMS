-- 스케줄링을 위한 Job 정의
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'JOB1',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN INSERT_DATA; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; INTERVAL=1',
    enabled         => TRUE
  );
END;
-- Job1을 생성하고 스케줄을 설정합니다.
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'JOB1',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN INSERT_DATA; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; BYSECOND=0;',
    enabled         => FALSE  -- 작업을 생성할 때는 일시적으로 비활성화합니다.
  );
END;
/

-- Job2도 동일한 방법으로 생성 및 설정합니다.
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'JOB2',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN INSERT_bw_DATA; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; BYSECOND=0;',
    enabled         => FALSE
  );
END;
/

--함수정의
CREATE OR REPLACE PROCEDURE INSERT_DATA IS
BEGIN
  INSERT INTO be_device (be_date, BE_AC_ENERGY,BE_LIGHT_ENERGY,BE_PLUG_ENERGY,BE_TOTAL_ENERGY,BE_FLOOR, B_ID)
  SELECT sysdate, BE_AC_ENERGY, BE_LIGHT_ENERGY,BE_PLUG_ENERGY,BE_TOTAL_ENERGY,BE_FLOOR, 'gta' as B_ID
  FROM b_data
  WHERE be_date = to_date (2018|| TO_CHAR(TO_DATE(TO_CHAR(sysdate, 'MMDD'), 'MMDD') - INTERVAL '1' DAY, 'MMDD') || to_char(sysdate,'HH24:MI'),'YYYYMMDD HH24:MI');
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

-- Job1과 Job2를 실행합니다.
BEGIN
  DBMS_SCHEDULER.run_job('JOB1', TRUE);
  DBMS_SCHEDULER.run_job('JOB2', TRUE);
END;
BEGIN
  DBMS_SCHEDULER.enable('JOB1');
  DBMS_SCHEDULER.enable('JOB2');
END;
/

select *
from b_data
where be_floor = '2'
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

-- job 멈추기 
BEGIN
    DBMS_SCHEDULER.DISABLE('job2');
END;
-- job 삭제
BEGIN
    DBMS_SCHEDULER.DROP_JOB('job2');
END;
-- job 건수 
SELECT COUNT(*) FROM user_scheduler_jobs;
-- job 실행 조회 
SELECT job_name, status, actual_start_date, run_duration
FROM user_scheduler_job_run_details
ORDER BY actual_start_date DESC;
