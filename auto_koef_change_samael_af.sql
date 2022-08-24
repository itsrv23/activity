CREATE FUNCTION tg_auto_koef_change_samael_af (
)
RETURNS trigger AS
$body$
DECLARE
BEGIN
-- При отказе от заказа, штатными средствами добавится строка на понижение активности
-- Ее нужно сделать в штрафных санкциях. Временное понижение дин.приоритета Ф.10
-- Так можно штрафовать стандартными средствами, без мучений с числом отказов и т.п.
IF NEW.value < 0 THEN
update a_samael_activity_tmp_predlag_orders set reject='t' and order_idx=NEW.orderid and  auto_idx=NEW.autoid;
END IF;
return new;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

CREATE TRIGGER tg_auto_koef_change_samael_af
  AFTER INSERT 
  ON public.auto_koef_change
  
FOR EACH ROW 
  EXECUTE PROCEDURE tg_auto_koef_change_samael_af();