PROMPT *-*-*-*-*-*-*-*-   CREATING cust_tb STARTS.... *-*-*-*-*-*-*-*-

DROP TABLE cust_tb
/

CREATE TABLE cust_tb 
(
  cust_id	NUMBER
, name		VARCHAR2(30)
, mobile	NUMBER(10)
, email		VARCHAR2(40)
, address	VARCHAR2(150)
)
/

PROMPT *-*-*-*-*-*-*-*-   CREATING cust_tb ENDS.... *-*-*-*-*-*-*-*-

PROMPT *-*-*-*-*-*-*-*-   CREATING inc_seq sequence STARTS.... *-*-*-*-*-*-*-*-

DROP SEQUENCE inc_seq;

CREATE SEQUENCE inc_seq
MINVALUE 1
MAXVALUE 99999999
START WITH 250
INCREMENT BY 1;

PROMPT *-*-*-*-*-*-*-*-   CREATING inc_seq sequence ENDS.... *-*-*-*-*-*-*-*-

PROMPT *-*-*-*-*-*-*-*-   INSERTING DATA into cust_tb STARTS.... *-*-*-*-*-*-*-*-

BEGIN
INSERT INTO cust_tb(   cust_id, name, mobile, email, address) 
             VALUES(1001 , 'Name_01',9898787865, 'name_01@gmail.com',NULL);
			 
INSERT INTO cust_tb(cust_id, name, mobile, email, address) 
			VALUES(1002 , 'Name_02',9898787866, 'name_02@gmail.com',NULL);

INSERT INTO cust_tb(cust_id, name, mobile, email, address) 
			VALUES(1003 , 'Name_03',9898787867, 'name_03@gmail.com',NULL);

INSERT INTO cust_tb(cust_id, name, mobile, email, address) 
             VALUES(1004 , 'Name_04',9898787868, 'name_04@gmail.com',NULL);

INSERT INTO cust_tb(cust_id, name, mobile, email, address) 
             VALUES(1005 , 'Name_05',9898787869, 'name_05@gmail.com',NULL);

COMMIT;
END;
/

PROMPT *-*-*-*-*-*-*-*-   CREATING inc_mgmt_tb STARTS.... *-*-*-*-*-*-*-*-

DROP TABLE inc_mgmt_tb;

CREATE TABLE inc_mgmt_tb
(
    ref_id        VARCHAR2(16)
  , cust_id		  NUMBER
  , mobile        NUMBER
  , issue_typ     VARCHAR2(30)
  , issue_desc    VARCHAR2(40)
  , status        VARCHAR2(10)
  , req_by		  VARCHAR2(30)
  , req_dttm      TIMESTAMP
  , apr_by        VARCHAR2(30)
  , apr_dttm      TIMESTAMP
  , rej_by        VARCHAR2(30)
  , rej_dttm      TIMESTAMP
  , rej_desc      VARCHAR2(30)
  , info_cng_num  NUMBER
);

PROMPT *-*-*-*-*-*-*-*-   CREATING inc_mgmt_tb ENDS.... *-*-*-*-*-*-*-*-

PROMPT *-*-*-*-*-* shk_batch_jobs_srefmst table createion STARTS... *-*-*-*-*-*

DROP SEQUENCE batch_job_seq;

CREATE SEQUENCE batch_job_seq
START WITH 1000
MINVALUE 1000
MAXVALUE 999999999
INCREMENT BY 1;

DROP TABLE shk_batch_jobs_srefmst;

CREATE TABLE shk_batch_jobs_srefmst
( batch_job_id     NUMBER  PRIMARY KEY
, batch_job_nm     VARCHAR2(30)
, brn_cd           VARCHAR2(10)
, prod_cd          VARCHAR2(10));


PROMPT *-*-*-*-*-* shk_batch_jobs_srefmst table creation ENDS... *-*-*-*-*-*

PROMPT *-*-*-*-*-* shk_batch_instance_txnmst sequence creation STARTS... *-*-*-*-*-*

DROP SEQUENCE instance_batch_seq;

CREATE SEQUENCE instance_batch_seq
START WITH 5550
MINVALUE 5550
MAXVALUE 999999999
INCREMENT BY 1;

PROMPT *-*-*-*-*-* shk_batch_instance_txnmst sequence creation ENDS... *-*-*-*-*-*

PROMPT *-*-*-*-*-* shk_batch_jobs_srefmst table insertion STARTS... *-*-*-*-*-*

BEGIN
INSERT INTO shk_batch_jobs_srefmst(batch_job_id, batch_job_nm,brn_cd, prod_cd) 
                VALUES(batch_job_seq.NEXTVAL,'STC_BATCH_DTAMGR_SP', 'ALL', 'ALL');
							 
INSERT INTO shk_batch_jobs_srefmst(batch_job_id, batch_job_nm,brn_cd, prod_cd) 
               VALUES(batch_job_seq.NEXTVAL,'DEPT_REP_GEN_SP','ALL','ALL');

INSERT INTO shk_batch_jobs_srefmst(batch_job_id, batch_job_nm,brn_cd, prod_cd) 
               VALUES(batch_job_seq.NEXTVAL,'REP_COL_SP','ALL','ALL');

INSERT INTO shk_batch_jobs_srefmst(batch_job_id, batch_job_nm,brn_cd, prod_cd) 
               VALUES(batch_job_seq.NEXTVAL,'REP_OBJ_SP','ALL','ALL');

	
INSERT INTO shk_batch_jobs_srefmst(batch_job_id, batch_job_nm,brn_cd, prod_cd) 
               VALUES(batch_job_seq.NEXTVAL,'REP_CAST_SP','ALL','ALL');						 
COMMIT;
END;
/
PROMPT *-*-*-*-*-* shk_batch_jobs_srefmst table insertion ENDS... *-*-*-*-*-*



	
DROP TABLE shk_batch_instance_txnmst;

CREATE TABLE shk_batch_instance_txnmst
( batch_job_instance_id   NUMBER
, batch_job_id            NUMBER
, start_dttm              TIMESTAMP
, end_dttm                TIMESTAMP
, job_run_status_flg      CHAR
, job_run_status_dttm     TIMESTAMP);

PROMPT *-*-*-*-*-* shk_batch_instance_txnmst table createion ENDS... *-*-*-*-*-*

PROMPT *-*-*-*-*-* shk_batch_instance_err table createion STARTS... *-*-*-*-*-*

DROP SEQUENCE error_seq;
 
CREATE SEQUENCE error_seq;

DROP TABLE shk_batch_instance_err;

CREATE TABLE shk_batch_instance_err
( error_id                NUMBER
, batch_job_instance_id   NUMBER
, error_module_nm         VARCHAR2(30)      
, error_object_nm         VARCHAR2(30)
, error_details_txt       VARCHAR2(50)
);

PROMPT *-*-*-*-*-* shk_batch_instance_err table createion ENDS... *-*-*-*-*-*

PROMPT *-*-*-*-*-* batch_employees creation STARTS... *-*-*-*-*-*

DROP TABLE batch_employees;

CREATE TABLE batch_employees(employee_id NUMBER
                         ,first_name VARCHAR2(30)
						 ,last_name VARCHAR2(30)
						 ,email VARCHAR2(30)
						 ,phone_number VARCHAR2(30)
						 ,hire_date DATE
						 ,job_id VARCHAR2(20)
						 ,salary NUMBER
						 ,commission_pct NUMBER
						 ,manager_id NUMBER
						 ,department_id NUMBER
						 ,increase NUMBER
						 ,email_id VARCHAR2(30)
						 ,PRIMARY KEY(employee_id)
						  );
						 
PROMPT *-*-*-*-*-* batch_employees creation ENDS... *-*-*-*-*-*


PROMPT *-*-*-*-*-* rep_obj OBJECT creation STARTS... *-*-*-*-*-*
 
DROP TYPE report_typ;

DROP TYPE rep_obj;

CREATE OR REPLACE TYPE rep_obj AS OBJECT
(
  ref_id       VARCHAR2(30),
  cust_id      NUMBER,
  mobile       NUMBER,
  issue_typ    VARCHAR2(30),
  issue_desc   VARCHAR2(30),
  status       VARCHAR2(30),
  req_by       VARCHAR2(30),
  req_dttm     TIMESTAMP,
  apr_by       VARCHAR2(30),
  apr_dttm     TIMESTAMP,
  rej_by       VARCHAR2(30),
  rej_dttm     TIMESTAMP,
  rej_desc     VARCHAR2(30),
  info_cng_num NUMBER

)
;
/

PROMPT *-*-*-*-*-* rep_obj OBJECT creation ENDS... *-*-*-*-*-*

PROMPT *-*-*-*-*-* report_typ TYPE creation STARTS... *-*-*-*-*-*

CREATE OR REPLACE TYPE report_typ IS TABLE OF rep_obj;
/

PROMPT *-*-*-*-*-* report_typ TYPE creation ENDS... *-*-*-*-*-*
