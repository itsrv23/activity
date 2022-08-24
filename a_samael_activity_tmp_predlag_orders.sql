CREATE TABLE public.a_samael_activity_tmp_predlag_orders (
  idx SERIAL,
  order_idx INTEGER NOT NULL,
  auto_idx INTEGER NOT NULL,
  act_plus NUMERIC(15,2) DEFAULT 0,
  act_min NUMERIC(15,2) DEFAULT 0,
  lat DOUBLE PRECISION DEFAULT 0,
  lon DOUBLE PRECISION DEFAULT 0,
  create_dt TIMESTAMP WITH TIME ZONE DEFAULT now(),
  accept BOOLEAN,
  reject BOOLEAN,
  karma NUMERIC(15,2),
  CONSTRAINT a_samael_activity_tmp_predlag_orders_pkey PRIMARY KEY(idx)
) 
WITH (oids = false);

COMMENT ON TABLE public.a_samael_activity_tmp_predlag_orders
IS 'Samael Активность tmp Назначения';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.idx
IS 'idx';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.order_idx
IS 'order
ref main_oper';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.auto_idx
IS 'auto
ref auto';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.act_plus
IS '+';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.act_min
IS '-';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.lat
IS 'lat';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.lon
IS 'lon';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.create_dt
IS 'dt';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.accept
IS 'Принял';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.reject
IS 'Отклонил';

COMMENT ON COLUMN public.a_samael_activity_tmp_predlag_orders.karma
IS 'Карма';

CREATE INDEX a_samael_activity_tmp_predlag_orders_create_dt ON public.a_samael_activity_tmp_predlag_orders
  USING btree (create_dt);

CREATE INDEX a_samael_activity_tmp_predlag_orders_order_auto ON public.a_samael_activity_tmp_predlag_orders
  USING btree (order_idx, auto_idx);


CREATE OR REPLACE FUNCTION public.a_samael_activity_tmp_predlag_orders_samael_af (
)
RETURNS trigger AS
$body$
DECLARE

BEGIN

IF (TG_OP='UPDATE') and (OLD.accept is distinct from NEW.accept) and NEW.accept is true  THEN
	IF 0 =(select count (idx) from a_samael_activity_log where order_idx=new.order_idx and type=1 and auto_idx=new.auto_idx) THEN
 		insert into a_samael_activity_log (order_idx,auto_idx,activity,type)values(new.order_idx, new.auto_idx, new.act_plus,1); 
    END IF;
END IF;

IF (TG_OP='UPDATE') and (OLD.reject is distinct from NEW.reject) and NEW.reject is true  THEN
 insert into a_samael_activity_log (order_idx,auto_idx,activity,type)values(new.order_idx, new.auto_idx, new.act_min,2); 
END IF;


return new;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

CREATE TRIGGER a_samael_activity_tmp_predlag_orders_samael_af
  AFTER UPDATE 
  ON public.a_samael_activity_tmp_predlag_orders
  
FOR EACH ROW 
  EXECUTE PROCEDURE public.a_samael_activity_tmp_predlag_orders_samael_af();