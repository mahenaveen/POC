create or replace procedure inc_creationmgmt_sp(p_ref_id     out varchar2,
                                                p_cust_id    in number,
                                                p_mobile     in number,
                                                p_issue_typ  in varchar2,
                                                p_issue_desc in varchar2,
                                                p_status     out varchar2,
                                                p_err_msg    out varchar2) as

    v_cust_id number;
    v_mobile  number;
    bt_ex exception;
    bt_ex1 exception;

begin

    select i.cust_id,
           i.mobile
      into v_cust_id,
           v_mobile
      from cust_tb i
     where i.cust_id = p_cust_id
        or i.mobile = p_mobile;

    if upper(p_issue_typ) not in ('H',
                                  'S') then
        raise bt_ex;
    end if;

    if p_issue_desc is null or p_issue_typ is null then
        raise bt_ex1;
    end if;

    select inc_seq.nextval
      into p_ref_id
      from dual;

    p_ref_id := 'INC' || to_char(sysdate,
                                 'DDMMYYYY') || lpad(p_ref_id,
                                                     5,
                                                     0);

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
    values
        (p_ref_id,
         v_cust_id,
         v_mobile,
         p_issue_typ,
         p_issue_desc,
         'PFA',
         user,
         systimestamp,
         null,
         null,
         null,
         null,
         null,
         1);

    commit;

    p_status := 'S';

exception

    when no_data_found then
    
        p_status  := 'F';
        p_err_msg := 'Invalid Customer Id/Invalid Mobile no';
    
    when bt_ex then
        p_status  := 'F';
        p_err_msg := 'Issue Type Must be H/S';
    
    when bt_ex1 then
        p_status  := 'F';
        p_err_msg := 'Issue Desc/Type is Mandatory';
    
end inc_creationmgmt_sp;
/
