CREATE OR REPLACE FUNCTION public.tg_a_samael_activity_auto_on (
)
RETURNS trigger AS
$body$
DECLARE
stable_act numeric(15,2);
BEGIN
IF (TG_OP='UPDATE')  THEN

	IF NEW.rait_client >=50 or NEW.rait_client < 0 THEN
    	NEW.rait_client = 50;
    END IF;

	IF NEW.karma >=30 or NEW.karma < 0 THEN
    	NEW.karma = 30;
    END IF;
    
	NEW.activity_base = NEW.rait_client + NEW.karma;

	IF NEW.activity_all >=100 THEN
    	NEW.activity_all = 100;
    END IF;
    
    IF NEW.activity_ord >= 100 - NEW.activity_base THEN
    NEW.activity_ord = 100 - NEW.activity_base;
    END IF;
    
    IF NEW.activity_ord < 0  THEN
    --NEW.activity_ord = 0;
    END IF;
    
    
    NEW.activity_all =  NEW.activity_ord + NEW.activity_base;
    
    NEW.dt = NOW();
    
    stable_act = (select comment5 from auto where idx= NEW.auto and comment4 >= now() and comment5 is not null);
    IF stable_act > 0 THEN
     NEW.activity_all = stable_act;
     NEW.activity_ord = stable_act;
    END IF;
    
    IF NEW.activity_all < 0 THEN
    NEW.activity_all = 0;
    NEW.activity_ord =  OLD.activity_ord;
    END IF;
    
    INSERT INTO   public.autoeventqueue(autoid)VALUES (NEW.auto);
    
END IF;
RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

CREATE TRIGGER tg_a_samael_activity_auto_on
  BEFORE INSERT OR UPDATE 
  ON public.a_samael_activity_auto
  
FOR EACH ROW 
  EXECUTE PROCEDURE public.tg_a_samael_activity_auto_on();
  
  CREATE TRIGGER tg_a_samael_activity_auto_on
  BEFORE INSERT OR UPDATE 
  ON public.a_samael_activity_auto
  
FOR EACH ROW 
  EXECUTE PROCEDURE public.tg_a_samael_activity_auto_on();

ALTER TABLE public.a_samael_activity_auto
  OWNER TO postgres;