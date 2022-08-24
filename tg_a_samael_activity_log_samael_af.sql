CREATE OR REPLACE FUNCTION public.tg_a_samael_activity_log_samael_af (
)
RETURNS trigger AS
$body$
DECLARE
aa_rec record;
BEGIN

select * into aa_rec from a_samael_activity_auto where auto=NEW.auto_idx;

IF (TG_OP='INSERT') and NEW.activity<>0 and NEW.type not in (6,7)  THEN
 IF aa_rec.auto is not null THEN
 	update a_samael_activity_auto set activity_ord=aa_rec.activity_ord + NEW.activity where auto=NEW.auto_idx;
    ELSE
    insert into a_samael_activity_auto (auto,  activity_all,activity_ord,  rait_client,  karma) VALUES (NEW.auto_idx, '100','20','50','30');
 END IF;
END IF;

IF (TG_OP='UPDATE') and (OLD.activity is distinct from NEW.activity) and NEW.type not in (6,7)  THEN
 update a_samael_activity_auto set activity_ord=aa_rec.activity_ord + NEW.activity-OLD.activity where auto=NEW.auto_idx;
END IF;


return new;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

CREATE TRIGGER tg_a_samael_activity_log_samael_af
  AFTER INSERT OR UPDATE 
  ON public.a_samael_activity_log
  
FOR EACH ROW 
  EXECUTE PROCEDURE public.tg_a_samael_activity_log_samael_af();