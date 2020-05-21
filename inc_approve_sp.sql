create or replace procedure inc_approve_sp(p_ref_id    in varchar2,
                                           p_ar_status in varchar2,
                                           p_rej_desc  in varchar2,
                                           p_status    out varchar2,
                                           p_err_msg   out varchar2) as
    v_ref_id       varchar2(30);
    v_info_cng_num number;
    ct_ex exception;
    ct_ex1 exception;
    ct_ex2 exception;
    v_apr_by    varchar2(20);
    v_apr_dttm  timestamp;
    v_rej_by    varchar2(20);
    v_ar_status varchar2(30);
    v_rej_dttm  timestamp;

begin

    select max(info_cng_num)
      into v_info_cng_num
      from inc_mgmt_tb
     where ref_id = p_ref_id
       and status = 'PFA';

    select ref_id
      into v_ref_id
      from inc_mgmt_tb i
     where i.ref_id = p_ref_id
       and i.status = 'PFA'
       and i.info_cng_num = v_info_cng_num;

    v_ar_status := upper(p_ar_status);

    if v_ar_status not in ('A', 'R') or v_ar_status is null then
        raise ct_ex;
    end if;

    if v_ar_status = 'A' and p_rej_desc is not null then
        raise ct_ex1;
    end if;

    if v_ar_status = 'R' and p_rej_desc is null then
        raise ct_ex2;
    end if;

    if v_ar_status = 'A' then
        v_apr_by   := user;
        v_apr_dttm := systimestamp;
    else
        v_rej_by   := user;
        v_rej_dttm := systimestamp;
    end if;

    update inc_mgmt_tb i
       set i.status   = v_ar_status,
           i.apr_by   = v_apr_by,
           i.apr_dttm = v_apr_dttm,
           i.rej_by   = v_rej_by,
           i.rej_dttm = v_rej_dttm
     where i.ref_id = p_ref_id
       and i.info_cng_num = v_info_cng_num;
    commit;
    p_status := 'S';

exception

    when no_data_found then
    
        p_status  := 'F';
        p_err_msg := 'Invalid Ref Id';
    
    when ct_ex then
        p_status  := 'F';
        p_err_msg := 'Status must be A/R';
    
    when ct_ex1 then
        p_status  := 'F';
        p_err_msg := 'Rejection status is not required';
    
    when ct_ex2 then
        p_status  := 'F';
        p_err_msg := 'Rejection status is mandatory';
    
end inc_approve_sp;
/
