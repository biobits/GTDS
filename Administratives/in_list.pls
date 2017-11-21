create or replace
function in_list( p_string in varchar2 ) return strTableType
as
 l_string long default p_string || ',';
 l_data strTableType := strTableType();
 n number;
 begin
 loop
 exit when l_string is null;
 n := instr( l_string, ',' );
 l_data.extend;
 l_data(l_data.count) :=
ltrim( rtrim( substr( l_string, 1, n-1 ) ) );
 l_string := substr( l_string, n+1 );
 end loop;

 return l_data;
 end;