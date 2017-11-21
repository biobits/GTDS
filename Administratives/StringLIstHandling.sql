
select column_value from THE ( select  cast( in_list('abc, xyz, 012') as
strTableType ) from dual ) a;  