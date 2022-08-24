DECLARE
  l_res text;
  txt text;

---
 

  txt = '!!!';
if p_ord.idx > 0 and  p_autoid >= 0 then
   txt = (a_samael_activity_fuc_predlag_orders(p_ord.idx, p_autoid));
   else 
   IF p_ord.idx > 0 THEN
   	txt = (select '⬆️' || COALESCE(s_aktivity_base+1,2)  from main_oper where idx=p_ord.idx);
   END IF;
end if;

l_res = coalesce(l_res, 'АКТИВНОСТЬ: ') || txt;
