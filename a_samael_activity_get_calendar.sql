CREATE OR REPLACE FUNCTION public.a_samael_activity_get_calendar (
)
RETURNS numeric AS
$body$
DECLARE
aktivity_base numeric (15,2)=1;
BEGIN
    	
    -- Календарь час пик
      IF 1=(select count(idx) from calendar where idx=100 and intervalactive='t') THEN
      aktivity_base = 1;
      END IF;
      
    -- Календарь 1.15
      IF 1=(select count(idx) from calendar where idx=31 and intervalactive='t') THEN
      aktivity_base = 1.15;
      END IF;
      
    -- Календарь 1.25
      IF 1=(select count(idx) from calendar where idx=32 and intervalactive='t') THEN
      aktivity_base = 1.25;
      END IF;
      
    -- Календарь 1.5
      IF 1=(select count(idx) from calendar where idx=33 and intervalactive='t') THEN
      aktivity_base = 1.5;
      END IF;
      
      
      return aktivity_base;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;