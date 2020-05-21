CREATE OR REPLACE PACKAGE batch_tracking_pkg
AS
FUNCTION batch_instance_fn(p_batch_name IN VARCHAR2,p_brn_cd IN VARCHAR2,p_prod_cd IN VARCHAR2)
RETURN NUMBER;
PROCEDURE batch_end_sp(p_instance_id IN NUMBER);
PROCEDURE batch_error_sp(p_inst_id IN NUMBER,p_module_nm IN VARCHAR2,p_object_nm IN VARCHAR2,p_err_msg IN VARCHAR2);
END batch_tracking_pkg;
/

CREATE OR REPLACE PACKAGE BODY batch_tracking_pkg 
AS

function batch_instance_fn(p_batch_name in varchar2,
                                       p_brn_cd     in varchar2,
                                       p_prod_cd    in varchar2) return number as

    v_instance_id  number;
    v_batch_job_id number;
    pragma autonomous_transaction;

begin

    select instance_batch_seq.nextval
      into v_instance_id
      from dual;
    
    select batch_job_id
      into v_batch_job_id
      from shk_batch_jobs_srefmst
     where batch_job_nm = p_batch_name
       and brn_cd = NVL(p_brn_cd,
                        'ALL')
       and prod_cd = NVL(p_prod_cd,
                         'ALL');
						 
		
    insert into shk_batch_instance_txnmst
        (batch_job_instance_id,
         batch_job_id,
         start_dttm,
         end_dttm,
         job_run_status_flg,
         job_run_status_dttm)
    values
        (v_instance_id,
         v_batch_job_id,
         systimestamp,
         null,
         'R',
         systimestamp);
    commit;
    return v_instance_id;

end batch_instance_fn;

PROCEDURE batch_end_sp(p_instance_id IN NUMBER)
AS
v_count NUMBER;
BEGIN

SELECT COUNT(*) INTO v_count FROM shk_batch_instance_err WHERE batch_job_instance_id=p_instance_id;
UPDATE shk_batch_instance_txnmst SET end_dttm=SYSTIMESTAMP,job_run_status_flg=DECODE(v_count,0,'C','E') WHERE batch_job_instance_id=p_instance_id;
COMMIT;

END batch_end_sp;

PROCEDURE batch_error_sp(p_inst_id IN NUMBER,p_module_nm IN VARCHAR2,p_object_nm IN VARCHAR2,p_err_msg IN VARCHAR2)
AS
v_err_id NUMBER;
BEGIN 
SELECT error_seq.NEXTVAL INTO v_err_id FROM dual;
DBMS_OUTPUT.PUT_LINE(v_err_id);
INSERT INTO shk_batch_instance_err(error_id,batch_job_instance_id,error_module_nm,error_object_nm,error_details_txt)VALUES(v_err_id,p_inst_id,p_module_nm,p_object_nm,p_err_msg);
COMMIT;
END batch_error_sp;

END batch_tracking_pkg;
/