CREATE OR REPLACE FUNCTION public.a_samael_activity_fuc_predlag_orders (
  o_idx integer,
  p_autoid integer
)
RETURNS text AS
$body$
DECLARE
res text='';
rec_af record;
mo record;

gps_lat  DOUBLE PRECISION;
gps_lon DOUBLE PRECISION;
BEGIN

select * into mo from main_oper where idx=o_idx;

 -- Добавляем комментарий из штрафных санкций
          select * into rec_af 
            from main_oper ord
                 join rotaterules rr on rr.idx = ord.rotateruleid
                 join orderrule_tariff ort on ort.idx = ord.orderrule_tariffid
                 join autofines af on (af.idx = COALESCE(rr.autofinesid,ort.autofinesid))
            where ord.idx = o_idx;
           
--rec_af.activ_plus = rec_af.activ_plus + coalesce((select s_aktivity_base from main_oper where idx=p_ord.idx), 0);

rec_af.activ_plus = rec_af.activ_plus + coalesce(mo.s_aktivity_base, 0);
-- Если спец заказ
IF mo.canrejectexpl or mo.canrejectrr or mo.canrejectul THEN
rec_af.activ_min = 0;
END IF;
if rec_af.activ_plus >=5 THEN rec_af.activ_plus = 5; END IF;


res = E'\n' || '⬆️' || rec_af.activ_plus || ' ⬇️' || rec_af.activ_min ;

--Добавляем 1 раз
IF 0=(select count (idx) from a_samael_activity_tmp_predlag_orders where order_idx=o_idx and auto_idx=p_autoid) and 
rec_af.activ_plus is not null and rec_af.activ_min is not null
 THEN 

  select coalesce(latitude,0), coalesce(longitude,0) into gps_lat, gps_lon  from mtgpsdata where idauto=p_autoid;
  insert into a_samael_activity_tmp_predlag_orders 
          (order_idx,auto_idx,act_plus,act_min,lat,lon) 
          values 
          (o_idx, p_autoid, rec_af.activ_plus, rec_af.activ_min, gps_lat, gps_lon);
END IF;  
  RETURN res;
END
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;