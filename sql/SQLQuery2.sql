use romantsov_test;
go

drop table #t_dates
drop table #t_dates_agr

select '2019-01-31' as date
into #t_dates
union all
select '2019-02-28' as date
union all
select '2019-03-31' as date
union all
select '2019-04-30' as date
union all
select '2019-05-31' as date

select #t_dates.date, Agreements.agreement
into #t_dates_agr
from #t_dates
left join Agreements on Agreements.agreement = 'agr1'

select #t_dates_agr.agreement, #t_dates_agr.date,
a_s.sum,
a_s2.sum,
ISNULL(a_s.sum, 0) - ISNULL(a_s2.sum, 0) as delta

from #t_dates_agr
left join agreement_sum as a_s  on  #t_dates_agr.agreement = a_s.agreement  and #t_dates_agr.date = a_s.month
  left join agreement_sum as a_s2 on   #t_dates_agr.agreement = a_s2.agreement   and #t_dates_agr.date = EOMONTH(a_s2.month, 1)