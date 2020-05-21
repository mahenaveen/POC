CREATE OR REPLACE PROCEDURE rep_gen_cast_sp(p_status OUT VARCHAR2,v_err_msg OUT VARCHAR2)
AS
  v_file_name    VARCHAR2(50);
  v_file         utl_file.file_type;
  v_hdr          VARCHAR2(30);
  v_ftr          VARCHAR2(40);
  v_ref_id       VARCHAR2(30);
  v_count        NUMBER:=0;
  v_inst_id      NUMBER;
  v_file_data    VARCHAR2(3000);
  v_obj_data     report_typ:=report_typ();
BEGIN
v_inst_id:=batch_tracking_pkg.batch_instance_fn('REP_CAST_SP','ALL','ALL');
SELECT rep_obj(ref_id,cust_id,mobile,issue_typ,issue_desc,status,req_by,req_dttm,apr_by,apr_dttm,rej_by,rej_dttm,rej_desc,info_cng_num) 
       BULK COLLECT INTO v_obj_data FROM inc_mgmt_tb;
  v_file_name := 'Rep_gen_cast_' || '_' || TO_CHAR(SYSDATE, 'DDMMYYYY') ||'.txt';
  v_file      := utl_file.fopen('AUG_DIR', v_file_name, 'W');
  v_hdr       := 'HDR' || TO_CHAR(SYSDATE, 'DDMMYYYY');
  utl_file.put_line(v_file, v_hdr);
  
  FOR i IN (SELECT * FROM TABLE(CAST(v_obj_data AS report_typ)))
  LOOP
  v_file_data :=i.ref_id;
  v_file_data:=v_file_data||'  '||i.cust_id;
  v_file_data:=v_file_data||'  '||i.cust_id;
  v_file_data:=v_file_data||'  '||i.mobile;
  v_file_data:=v_file_data||'  '||i.issue_typ;
  v_file_data:=v_file_data||'  '||i.issue_desc;
  v_file_data:=v_file_data||'  '||i.status;
  v_file_data:=v_file_data||'  '||i.req_by;
  v_file_data:=v_file_data||'  '||i.req_dttm;
  v_file_data:=v_file_data||'  '||NVL(TO_CHAR(i.apr_by),'-');
  v_file_data:=v_file_data||'  '||NVL(TO_CHAR(i.apr_dttm),'-');
  v_file_data:=v_file_data||'  '||NVL(TO_CHAR(i.rej_by),'-');
  v_file_data:=v_file_data||'  '||NVL(TO_CHAR(i.rej_dttm),'-');
  v_file_data:=v_file_data||'  '||NVL(TO_CHAR(i.rej_desc),'-');
  v_file_data:=v_file_data||'  '||i.info_cng_num;
  utl_file.put_line(v_file, v_file_data);
  v_count := v_count + 1;
 END LOOP;
 
   v_ftr := 'FTR' || TO_CHAR(SYSDATE, 'DDMMYYYY') || LPAD(v_count, 5, 0);
   utl_file.put_line(v_file, v_ftr);
   utl_file.fclose(v_file);
   p_status := 'S';
   batch_tracking_pkg.batch_end_sp(v_inst_id);

EXCEPTION
  WHEN OTHERS THEN
    utl_file.fclose(v_file);
    p_status  := 'F';
    v_err_msg := SUBSTR(SQLERRM, 1, 50);
    batch_tracking_pkg.batch_error_sp(v_inst_id,'PROCESS','REP_CAST_SP',v_err_msg);
	batch_tracking_pkg.batch_end_sp(v_inst_id);
  END rep_gen_cast_sp;
/

 