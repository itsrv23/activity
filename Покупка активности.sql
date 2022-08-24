ALTER TABLE public.tariff_planauto
  ADD COLUMN s_acitivity_on_open_smena NUMERIC(15,2);

COMMENT ON COLUMN public.tariff_planauto.s_acitivity_on_open_smena
IS 'Активность';
  

  


CREATE OR REPLACE FUNCTION public.doc_autosmenachargeoff_samael_af_level (
)
RETURNS trigger AS
$body$
DECLARE
cnt_sm integer;
old_cnt_sm  integer;
a_rec record;
tp_rec record;

acitivity_on_open_smena NUMERIC(15,2);
buy_activity NUMERIC(15,2);
tmp_maxbuy_activity NUMERIC(15,2);
msg_to_driver text;
BEGIN

select * into a_rec from auto where idx=NEW.autoid;


  -- Покупка тарифа
  IF TG_OP = 'INSERT' THEN
	select * into tp_rec from tariff_planauto where idx=NEW.tariffplanid;
    IF tp_rec.s_acitivity_on_open_smena > 0 THEN
    
    	insert into a_samael_activity_log (auto_idx,activity,type)values(NEW.autoid, tp_rec.s_acitivity_on_open_smena,3);
        
        tmp_maxbuy_activity = 100-a_rec.s_activity; 
        IF tp_rec.s_acitivity_on_open_smena >= tmp_maxbuy_activity THEN
        buy_activity = tmp_maxbuy_activity;
        	else
        buy_activity = tp_rec.s_acitivity_on_open_smena;
        END IF;
        msg_to_driver = 'Активность за покупку тарифа: ' || tp_rec.name || ', начисленно в подарок: ' || buy_activity || ' активности!';
        --PERFORM xlog_main_write(0, 'Активность за покупку тарифа: ' || tp_rec.name || ', Купленно: ' || buy_activity || ' активности!', '<Система>', NEW.autoid, NULL ,NULL ); 
        PERFORM xlogs_write ('auto',NEW.autoid, 2, msg_to_driver, '<Изменение записи>' );
        IF buy_activity > 0 THEN
        PERFORM send_message_to_driver(msg_to_driver,NEW.autoid);
        END IF;
    END IF;
END IF;
  


  RETURN NEW;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION public.doc_autosmenachargeoff_samael_af_level ()
  OWNER TO postgres;
  
  
  CREATE TRIGGER doc_autosmenachargeoff_samael_af_level
  BEFORE INSERT OR UPDATE 
  ON public.doc_autosmenachargeoff
  
FOR EACH ROW 
  EXECUTE PROCEDURE public.doc_autosmenachargeoff_samael_af_level();