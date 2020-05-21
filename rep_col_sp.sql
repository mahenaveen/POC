CREATE OR REPLACE PROCEDURE rep_col_sp(p_status  OUT VARCHAR2,
                                       v_err_msg OUT VARCHAR2) AS
  TYPE ref_typ IS TABLE OF inc_mgmt_tb.ref_id%TYPE;
  TYPE cust_typ IS TABLE OF inc_mgmt_tb.cust_id%TYPE;
  TYPE mobile_typ IS TABLE OF inc_mgmt_tb.mobile%TYPE;
  TYPE issue_typ IS TABLE OF inc_mgmt_tb.issue_typ%TYPE;
  TYPE issue_desc_typ IS TABLE OF inc_mgmt_tb.issue_desc%TYPE;
  TYPE status_typ IS TABLE OF inc_mgmt_tb.status%TYPE;
  TYPE req_typ IS TABLE OF inc_mgmt_tb.req_by%TYPE;
  TYPE req_dttm_typ IS TABLE OF inc_mgmt_tb.req_dttm%TYPE;
  TYPE apr_typ IS TABLE OF inc_mgmt_tb.apr_by%TYPE;
  TYPE apr_dttm_typ IS TABLE OF inc_mgmt_tb.apr_dttm%TYPE;
  TYPE rej_typ IS TABLE OF inc_mgmt_tb.rej_by%TYPE;
  TYPE rej_dttm_typ IS TABLE OF inc_mgmt_tb.rej_dttm%TYPE;
  TYPE rej_desc_typ IS TABLE OF inc_mgmt_tb.rej_desc%TYPE;
  TYPE inf_cng_typ IS TABLE OF inc_mgmt_tb.info_cng_num%TYPE;
  v_ref_id       ref_typ := ref_typ();
  v_cust_id      cust_typ := cust_typ();
  v_mobile       mobile_typ := mobile_typ();
  v_issue_typ    issue_typ := issue_typ();
  v_issue_desc   issue_desc_typ := issue_desc_typ();
  v_status       status_typ := status_typ();
  v_req_by       req_typ := req_typ();
  v_req_dttm     req_dttm_typ := req_dttm_typ();
  v_apr_by       apr_typ := apr_typ();
  v_apr_dttm     apr_dttm_typ := apr_dttm_typ();
  v_rej_by       rej_typ := rej_typ();
  v_rej_dttm     rej_dttm_typ := rej_dttm_typ();
  v_rej_desc     rej_desc_typ := rej_desc_typ();
  v_info_cng_num inf_cng_typ := inf_cng_typ();
  v_file_name    VARCHAR2(50);
  v_inst_id      NUMBER;
  v_file         utl_file.file_type;
  v_hdr          VARCHAR2(30);
  v_ftr          VARCHAR2(40);
  v_file_data    VARCHAR2(3000);
  v_count        NUMBER := 0;
  CURSOR v_data IS
    SELECT * FROM inc_mgmt_tb WHERE TRUNC(req_dttm)=TRUNC(SYSDATE) ORDER BY ref_id,info_cng_num;

BEGIN
  v_inst_id:=batch_tracking_pkg.batch_instance_fn('REP_COL_SP','ALL','ALL');
  OPEN v_data;
  FETCH v_data BULK COLLECT
    INTO v_ref_id, v_cust_id, v_mobile, v_issue_typ, v_issue_desc, v_status, v_req_by, v_req_dttm, v_apr_by, v_apr_dttm, v_rej_by, v_rej_dttm, v_rej_desc, v_info_cng_num;
  CLOSE v_data;
  v_file_name := 'Rep_gen_utl_col' || '_' || TO_CHAR(SYSDATE, 'DDMMYYYY') ||
                 '.txt';
  v_file      := utl_file.fopen('AUG_DIR', v_file_name, 'W');
  v_hdr       := 'HDR' || TO_CHAR(SYSDATE, 'DDMMYYYY');
  utl_file.put_line(v_file, v_hdr);
  FOR i IN 1 .. v_ref_id.COUNT LOOP
    v_file_data := v_ref_id(i) || '  ' || v_cust_id(i) || '  ' ||
                   v_mobile(i) || '  ' || v_issue_typ(i) || '  ' ||
                   v_issue_desc(i) || '  ' || v_status(i) || '  ' ||
                   v_req_by(i) || '  ' || v_req_dttm(i) || '  ' ||
                   NVL(v_apr_by(i), '-') || '  ' ||
                   NVL(TO_CHAR(v_apr_dttm(i)), '-') || '  ' ||
                   NVL(v_rej_by(i), '-') || '  ' ||
                   NVL(TO_CHAR(v_rej_dttm(i)), '-') || '  ' ||
                   NVL(v_rej_desc(i), '-') || '  ' || v_info_cng_num(i);
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
	batch_tracking_pkg.batch_error_sp(v_inst_id,'PROCESS','REP_COL_SP',v_err_msg);
	batch_tracking_pkg.batch_end_sp(v_inst_id);
	COMMIT;
END rep_col_sp;
/
