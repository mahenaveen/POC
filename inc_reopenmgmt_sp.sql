create or replace procedure inc_reopenmgmt_sp(p_ref_id  in varchar2,
                                              p_status  out varchar2,
                                              p_err_msg out varchar2) as

    v_ref_id       varchar2(20);
    v_info_cng_num number;

begin

    select max(info_cng_num)
      into v_info_cng_num
      from inc_mgmt_tb
     where ref_id = p_ref_id;

    select ref_id
      into v_ref_id
      from inc_mgmt_tb
     where ref_id = p_ref_id
       and status = 'R'
       and info_cng_num = v_info_cng_num;

    insert into inc_mgmt_tb
        (ref_id,
         cust_id,
         mobile,
         issue_typ,
         issue_desc,
         status,
         req_by,
         req_dttm,
         apr_by,
         apr_dttm,
         rej_by,
         rej_dttm,
         rej_desc,
         info_cng_num)
        (select ref_id,
                cust_id,
                mobile,
                issue_typ,
                issue_desc,
                'PFA',
                user,
                systimestamp,
                null,
                null,
                null,
                null,
                null,
                v_info_cng_num + 1
           from inc_mgmt_tb
          where ref_id = p_ref_id
            and info_cng_num = v_info_cng_num);
    commit;
    p_status := 'S';

exception
    when no_data_found then
        p_status  := 'F';
        p_err_msg := 'Invalid Ref_id/Status must be in R to Reopen';
    
end inc_reopenmgmt_sp;
/
