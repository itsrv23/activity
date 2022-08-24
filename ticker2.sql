CREATE OR REPLACE FUNCTION public.a_samael_ticker2 (
)
RETURNS void AS
$body$
DECLARE

BEGIN
--Открытие заказов c Характеристикой безнал
--perform a_samael_open_order_for_beznal();
PERFORM a_samael_activity_get_karma();

RETURN;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION public.a_samael_ticker2 ()
  OWNER TO postgres;