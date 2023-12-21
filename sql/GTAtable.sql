
-- B_DATE 테이블생성 

CREATE TABLE B_DATA (
    BE_date TIMESTAMP (6),
    BE_ac_energy NUMBER(20, 2),
    BE_light_energy NUMBER(20, 2),
    BE_plug_energy NUMBER(20, 2),
    BE_total_energy NUMBER(20, 2),
    BE_floor NUMBER(10,0)
);

-- inform 테이블 (Oracle)
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






-- USER 테이블
CREATE TABLE b_USER (
    b_id VARCHAR2(100) NOT NULL,
    b_pwd VARCHAR2(50 BYTE),
    b_name VARCHAR2(100 BYTE),
    b_addr VARCHAR2(1000 BYTE),
    b_hp VARCHAR2(100 BYTE),
    reg_d DATE DEFAULT SYSDATE,
    b_country VARCHAR2(100)
);


-- be_device 테이블
CREATE TABLE be_device (
    be_floor NUMBER(10,0) NOT NULL,
    b_id VARCHAR2(100 BYTE) NOT NULL,
    be_date TIMESTAMP(6),
    be_ac_energy NUMBER(20, 2),
    be_light_energy NUMBER(20, 2),
    be_plug_energy NUMBER(20, 2),
    be_total_energy NUMBER(20, 2)
);

COMMENT ON COLUMN be_device.be_floor IS '숫자로만';
COMMENT ON COLUMN be_device.b_id IS '로그인';
COMMENT ON COLUMN be_device.be_date IS '형식';
COMMENT ON COLUMN be_device.be_ac_energy IS '에어컨에너지';
COMMENT ON COLUMN be_device.be_light_energy IS '전등에너지';
COMMENT ON COLUMN be_device.be_plug_energy IS '플러그에너지';
COMMENT ON COLUMN be_device.be_total_energy IS '총에너지';

-- bw_in 테이블
CREATE TABLE bw_in (
    bw_id VARCHAR2(100 BYTE) NOT NULL,
    bw_date DATE,
    bw_floor NUMBER(10,0),
    bw_in_degC NUMBER(20, 2),
    bw_in_rh NUMBER(20, 2),
    bw_in_lux NUMBER(10,0)
);
DELETE FROM bw_in;

COMMENT ON COLUMN bw_in.bw_id IS '로그인';
COMMENT ON COLUMN bw_in.bw_date IS '형식';
COMMENT ON COLUMN bw_in.bw_floor IS '숫자로만';
COMMENT ON COLUMN bw_in.bw_in_degC IS '총';
COMMENT ON COLUMN bw_in.bw_in_rh IS '내부습도';
COMMENT ON COLUMN bw_in.bw_in_lux IS '내부';


-- bw_in_out_realtime 테이블
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


-- bw_out 테이블
CREATE TABLE bw_out (
    b_id VARCHAR2(100 BYTE) NOT NULL,
    bw_date DATE,
    bw_out_degc NUMBER(20, 2),
    bw_out_sun VARCHAR2(20 BYTE)
);

COMMENT ON COLUMN bw_out.b_id IS '회원정보';
COMMENT ON COLUMN bw_out.bw_date IS '형식';
COMMENT ON COLUMN bw_out.bw_out_degc IS '외부온도';
COMMENT ON COLUMN bw_out.bw_out_sun IS '해가';

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


-- INFO_SEQ시퀀스
CREATE SEQUENCE INFO_SEQ
    MINVALUE 1
    MAXVALUE 9999
    INCREMENT BY 1
    START WITH 1;


-- 대표 아이디 
INSERT INTO b_USER (b_ID, b_pwd, b_name, b_addr, b_hp, b_country)
VALUES('gta', '123', '쭐랄롱꼰 대학교 ', '254 Phaya Thai Rd, Wang Mai, Pathum Wan, Bangkok 10330 태국','+66 2215 3555','thailand'); 




-- ANIMAL__MEMBER 테이블 삭제
DROP TABLE ANIMAL__MEMBER;

-- B_DATA 테이블 삭제
DROP TABLE B_DATA;

-- B_INFORM 테이블 삭제
DROP TABLE B_INFORM;

-- B_USER 테이블 삭제
DROP TABLE B_USER;

-- BE_DEVICE 테이블 삭제
DROP TABLE BE_DEVICE;

-- BW_IN 테이블 삭제
DROP TABLE BW_IN;

-- BW_IN_OUT_REALTIME 테이블 삭제
DROP TABLE BW_IN_OUT_REALTIME;

-- BW_OUT 테이블 삭제
DROP TABLE BW_OUT;

-- MODEL_PREDICTION 테이블 삭제
DROP TABLE MODEL_PREDICTION




-- DAY_CHART_VIEW 삭제
DROP VIEW DAY_CHART_VIEW;

-- DAY_DCHART_VIEW 삭제
DROP VIEW DAY_DCHART_VIEW;

-- MONTH_CHART_VIEW 삭제
DROP VIEW MONTH_CHART_VIEW;

-- MONTH_DCHART_VIEW 삭제
DROP VIEW MONTH_DCHART_VIEW;

-- NOW_CHART_VIEW 삭제
DROP VIEW NOW_CHART_VIEW;

-- NOW_DCHART_VIEW 삭제
DROP VIEW NOW_DCHART_VIEW;

-- WEEK_CHART_VIEW 삭제
DROP VIEW WEEK_CHART_VIEW;

-- WEEK_DCHART_VIEW 삭제
DROP VIEW WEEK_DCHART_VIEW;








