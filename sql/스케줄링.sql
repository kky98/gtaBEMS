-- �����ٸ��� ���� Job ����
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
-- Job1�� �����ϰ� �������� �����մϴ�.
BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'JOB1',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN INSERT_DATA; END;',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'FREQ=MINUTELY; BYSECOND=0;',
    enabled         => FALSE  -- �۾��� ������ ���� �Ͻ������� ��Ȱ��ȭ�մϴ�.
  );
END;
/

-- Job2�� ������ ������� ���� �� �����մϴ�.
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

--�Լ�����
CREATE OR REPLACE PROCEDURE INSERT_DATA IS
BEGIN
  INSERT INTO be_device (be_date, BE_AC_ENERGY,BE_LIGHT_ENERGY,BE_PLUG_ENERGY,BE_TOTAL_ENERGY,BE_FLOOR, B_ID)
  SELECT sysdate, BE_AC_ENERGY, BE_LIGHT_ENERGY,BE_PLUG_ENERGY,BE_TOTAL_ENERGY,BE_FLOOR, 'gta' as B_ID
  FROM b_data
  WHERE be_date = to_date (2018|| TO_CHAR(TO_DATE(TO_CHAR(sysdate, 'MMDD'), 'MMDD') - INTERVAL '1' DAY, 'MMDD') || to_char(sysdate,'HH24:MI'),'YYYYMMDD HH24:MI');
  -- ���� WHERE ���� ����Ͽ� ���� �ð��� ��� �����͸� �����ɴϴ�.
  COMMIT; -- ���� ������ Ȯ��
END;

--�ð��� ������ ����
DECLARE
  nowdate TIMESTAMP;
BEGIN
  SELECT SYSTIMESTAMP INTO nowdate FROM DUAL;
  
  -- nowdate ������ ���� �ð��� ����Ǿ����Ƿ�, �ʿ信 ���� ����� �� �ֽ��ϴ�.
  DBMS_OUTPUT.PUT_LINE('���� �ð�: ' || TO_CHAR(nowdate, 'YYYY-MM-DD HH24:MI:SS'));
END;

-- Job1�� Job2�� �����մϴ�.
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

-- job ���߱� 
BEGIN
    DBMS_SCHEDULER.DISABLE('job2');
END;
-- job ����
BEGIN
    DBMS_SCHEDULER.DROP_JOB('job2');
END;
-- job �Ǽ� 
SELECT COUNT(*) FROM user_scheduler_jobs;
-- job ���� ��ȸ 
SELECT job_name, status, actual_start_date, run_duration
FROM user_scheduler_job_run_details
ORDER BY actual_start_date DESC;
