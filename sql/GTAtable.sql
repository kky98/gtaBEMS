
-- B_DATE ���̺���� 

CREATE TABLE B_DATA (
    BE_date TIMESTAMP (6),
    BE_ac_energy NUMBER(20, 2),
    BE_light_energy NUMBER(20, 2),
    BE_plug_energy NUMBER(20, 2),
    BE_total_energy NUMBER(20, 2),
    BE_floor NUMBER(10,0)
);

-- inform ���̺� (Oracle)
CREATE TABLE b_inform (
    b_id VARCHAR2(100 BYTE) NOT NULL,
    i_num number(38,0) DEFAULT INFO_SEQ.NEXTVAL PRIMARY key,
    i_date TIMESTAMP(6) NOT NULL,
    i_name VARCHAR2(100 BYTE) NOT NULL,
    i_rank VARCHAR2(100 BYTE) NOT NULL,
    i_title VARCHAR2(100 BYTE) NOT NULL,
    i_contents VARCHAR2(4000 BYTE) NOT NULL,
    i_del VARCHAR2(255 BYTE) DEFAULT 'N' NOT NULL,
    i_pwd VARCHAR2(255 BYTE)
);






-- USER ���̺�
CREATE TABLE b_USER (
    b_id VARCHAR2(100) NOT NULL,
    b_pwd VARCHAR2(50 BYTE),
    b_name VARCHAR2(100 BYTE),
    b_addr VARCHAR2(1000 BYTE),
    b_hp VARCHAR2(100 BYTE),
    reg_d DATE DEFAULT SYSDATE,
    b_country VARCHAR2(100)
);


-- be_device ���̺�
CREATE TABLE be_device (
    be_floor NUMBER(10,0) NOT NULL,
    b_id VARCHAR2(100 BYTE) NOT NULL,
    be_date TIMESTAMP(6),
    be_ac_energy NUMBER(20, 2),
    be_light_energy NUMBER(20, 2),
    be_plug_energy NUMBER(20, 2),
    be_total_energy NUMBER(20, 2)
);

COMMENT ON COLUMN be_device.be_floor IS '���ڷθ�';
COMMENT ON COLUMN be_device.b_id IS '�α���';
COMMENT ON COLUMN be_device.be_date IS '����';
COMMENT ON COLUMN be_device.be_ac_energy IS '������������';
COMMENT ON COLUMN be_device.be_light_energy IS '�������';
COMMENT ON COLUMN be_device.be_plug_energy IS '�÷��׿�����';
COMMENT ON COLUMN be_device.be_total_energy IS '�ѿ�����';

-- bw_in ���̺�
CREATE TABLE bw_in (
    bw_id VARCHAR2(100 BYTE) NOT NULL,
    bw_date DATE,
    bw_floor NUMBER(10,0),
    bw_in_degC NUMBER(20, 2),
    bw_in_rh NUMBER(20, 2),
    bw_in_lux NUMBER(10,0)
);
DELETE FROM bw_in;

COMMENT ON COLUMN bw_in.bw_id IS '�α���';
COMMENT ON COLUMN bw_in.bw_date IS '����';
COMMENT ON COLUMN bw_in.bw_floor IS '���ڷθ�';
COMMENT ON COLUMN bw_in.bw_in_degC IS '��';
COMMENT ON COLUMN bw_in.bw_in_rh IS '���ν���';
COMMENT ON COLUMN bw_in.bw_in_lux IS '����';


-- bw_in_out_realtime ���̺�
CREATE TABLE bw_in_out_realtime (
    bw_id VARCHAR2(100 BYTE) NOT NULL,
    bw_date DATE,
    bw_floor NUMBER(10,0),
    bw_in_degC NUMBER(20, 2),
    bw_in_rh NUMBER(20, 2),
    bw_in_lux NUMBER(10,0),
    bw_out_degc NUMBER(20, 2),
    bw_out_sun VARCHAR2(3 BYTE)
);


-- bw_out ���̺�
CREATE TABLE bw_out (
    b_id VARCHAR2(100 BYTE) NOT NULL,
    bw_date DATE,
    bw_out_degc NUMBER(20, 2),
    bw_out_sun VARCHAR2(20 BYTE)
);

COMMENT ON COLUMN bw_out.b_id IS 'ȸ������';
COMMENT ON COLUMN bw_out.bw_date IS '����';
COMMENT ON COLUMN bw_out.bw_out_degc IS '�ܺοµ�';
COMMENT ON COLUMN bw_out.bw_out_sun IS '�ذ�';

CREATE TABLE MODEL_PREDICTION (
 MODEL_DATE TIMESTAMP(6),
 MODEL_ENERGY NUMBER (20, 2),
 DIVISION VARCHAR2(15 BYTE) 
);


-- DAY_CHART_VIEW
CREATE VIEW DAY_CHART_VIEW AS
SELECT TO_CHAR(MODEL_DATE, 'YYYY-MM-DD') AS CHART_DATE,
       MODEL_ENERGY AS CHART_ENERGY,
       DIVISION
FROM MODEL_PREDICTION;

-- DAY_DCHART_VIEW
CREATE VIEW DAY_DCHART_VIEW AS
SELECT TO_CHAR(MODEL_DATE, 'YYYY-MM-DD') AS CHART_DATE,
       MODEL_ENERGY AS CHART_ENERGY,
       DIVISION
FROM MODEL_PREDICTION;

-- MONTH_CHART_VIEW
CREATE VIEW MONTH_CHART_VIEW AS
SELECT TO_CHAR(MODEL_DATE, 'YYYY-MM') AS CHART_DATE,
       SUM(MODEL_ENERGY) AS CHART_ENERGY,
       DIVISION
FROM MODEL_PREDICTION
GROUP BY TO_CHAR(MODEL_DATE, 'YYYY-MM'), DIVISION;

-- MONTH_DCHART_VIEW
CREATE VIEW MONTH_DCHART_VIEW AS
SELECT TO_CHAR(MODEL_DATE, 'YYYY-MM') AS CHART_DATE,
       SUM(MODEL_ENERGY) AS CHART_ENERGY,
       DIVISION
FROM MODEL_PREDICTION
GROUP BY TO_CHAR(MODEL_DATE, 'YYYY-MM'), DIVISION;


-- INFO_SEQ������
CREATE SEQUENCE INFO_SEQ
    MINVALUE 1
    MAXVALUE 9999
    INCREMENT BY 1
    START WITH 1;


-- ��ǥ ���̵� 
INSERT INTO b_USER (b_ID, b_pwd, b_name, b_addr, b_hp, b_country)
VALUES('gta', '123', '����ղ� ���б� ', '254 Phaya Thai Rd, Wang Mai, Pathum Wan, Bangkok 10330 �±�','+66 2215 3555','thailand'); 




-- ANIMAL__MEMBER ���̺� ����
DROP TABLE ANIMAL__MEMBER;

-- B_DATA ���̺� ����
DROP TABLE B_DATA;

-- B_INFORM ���̺� ����
DROP TABLE B_INFORM;

-- B_USER ���̺� ����
DROP TABLE B_USER;

-- BE_DEVICE ���̺� ����
DROP TABLE BE_DEVICE;

-- BW_IN ���̺� ����
DROP TABLE BW_IN;

-- BW_IN_OUT_REALTIME ���̺� ����
DROP TABLE BW_IN_OUT_REALTIME;

-- BW_OUT ���̺� ����
DROP TABLE BW_OUT;

-- MODEL_PREDICTION ���̺� ����
DROP TABLE MODEL_PREDICTION




-- DAY_CHART_VIEW ����
DROP VIEW DAY_CHART_VIEW;

-- DAY_DCHART_VIEW ����
DROP VIEW DAY_DCHART_VIEW;

-- MONTH_CHART_VIEW ����
DROP VIEW MONTH_CHART_VIEW;

-- MONTH_DCHART_VIEW ����
DROP VIEW MONTH_DCHART_VIEW;

-- NOW_CHART_VIEW ����
DROP VIEW NOW_CHART_VIEW;

-- NOW_DCHART_VIEW ����
DROP VIEW NOW_DCHART_VIEW;

-- WEEK_CHART_VIEW ����
DROP VIEW WEEK_CHART_VIEW;

-- WEEK_DCHART_VIEW ����
DROP VIEW WEEK_DCHART_VIEW;








