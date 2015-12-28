------市场 - 来电明细月报-------
drop table if exists dm_db.swan_call_daily;
create table dm_db.swan_call_daily as
select a.caller_uid,a.caller,a.called_uid as broker_uid,b.broker_name,b.agent_name,b.broker_label_name,a.start_at,a.keep_time
,case when orig_channel=0 then '安个家'
when orig_channel=1 then '安居客'
when orig_channel=2 then '搜房'end as channel
,concat('http://rec.goothy.com:33887',a.record_file) as url
from db_sync.angejia__call_log a
left outer join dw_db.dw_broker_summary_basis_info_daily b 
on a.called_uid=b.user_id and b.p_dt=${dealDate},
(select last_month_beg_dt as mycaldt from dw_db.dw_cal where cal_dt = ${dealDate}) t
where a.call_type =2
and a.called_uid not in (0,3,4)
and b.broker_status='在职'
and start_at >= t.mycaldt;


----Hive数据导入mysql
----export hive  dm_db.swan_call_daily to mysql  dm_db.swan_call_daily;