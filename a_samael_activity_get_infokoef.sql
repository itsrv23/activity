CREATE OR REPLACE FUNCTION public.a_samael_activity_get_infokoef (
  autoid integer,
  out txt_out text
)
RETURNS text AS
$body$
DECLARE
info record;
BEGIN
txt_out = 'ТИП/Активность/Подача' || '</br>';
    	
    for info in (select l.order_idx as order_idx,l.activity,l.karma,l.comment, lt.name, l.create_dt from a_samael_activity_log l  inner join a_samael_activity_log_type lt on lt.idx=l.type   where l.auto_idx= autoid and l.activity <> 0 order by l.idx desc limit 10 ) LOOP
    
    txt_out := COALESCE(txt_out, '') ||  COALESCE(info.name, '')::text || ' ' 
    --|| ' / ' || COALESCE(info.order_idx::text, '0') || ' / ' 
    || COALESCE(info.activity::text, '0') || ' / ' ||  COALESCE(info.karma::text, '0') || ' / ' ||  COALESCE(info.comment, '') 
    || ' ' || to_char (info.create_dt, 'YYYY-MM-DD HH24:MI') || '</br>';
    END LOOP;
      
      
      --return COALESCE(txt_out, '');
      --return txt_out;
      
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION public.a_samael_activity_get_infokoef (autoid integer, out txt_out text)
  OWNER TO postgres;