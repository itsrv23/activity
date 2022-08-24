CREATE TABLE public.a_samael_activity_auto (
  idx SERIAL,
  auto INTEGER NOT NULL,
  activity_all NUMERIC(15,2) DEFAULT 100,
  activity_ord NUMERIC(15,2) DEFAULT 0,
  activity_base NUMERIC(15,2) DEFAULT 0,
  rait_client NUMERIC(15,2) DEFAULT 0,
  karma NUMERIC(15,2) DEFAULT 0,
  rait_client2 NUMERIC(15,2) DEFAULT 0,
  karma2 NUMERIC(15,2) DEFAULT 0,
  dt TIMESTAMP WITH TIME ZONE DEFAULT now(),
  CONSTRAINT a_samael_activity_auto_auto_key UNIQUE(auto),
  CONSTRAINT a_samael_activity_auto_pkey PRIMARY KEY(idx)
) 
WITH (oids = false);

COMMENT ON TABLE public.a_samael_activity_auto
IS 'Samael Активность Экипажи';

COMMENT ON COLUMN public.a_samael_activity_auto.idx
IS 'idx';

COMMENT ON COLUMN public.a_samael_activity_auto.auto
IS 'Экипаж
ref auto';

COMMENT ON COLUMN public.a_samael_activity_auto.activity_all
IS 'Активность';

COMMENT ON COLUMN public.a_samael_activity_auto.activity_ord
IS 'Активность по заказам';

COMMENT ON COLUMN public.a_samael_activity_auto.activity_base
IS 'Активность несгораемая';

COMMENT ON COLUMN public.a_samael_activity_auto.rait_client
IS 'Активность. Оценка от клиентов';

COMMENT ON COLUMN public.a_samael_activity_auto.karma
IS 'Активность. Подача авто';

COMMENT ON COLUMN public.a_samael_activity_auto.rait_client2
IS 'Оценка от Клиентов';

COMMENT ON COLUMN public.a_samael_activity_auto.karma2
IS 'Оценка Подача';

COMMENT ON COLUMN public.a_samael_activity_auto.dt
IS 'Дата';

/*
CREATE TRIGGER tg_a_samael_activity_auto_on
  BEFORE INSERT OR UPDATE 
  ON public.a_samael_activity_auto
  
FOR EACH ROW 
  EXECUTE PROCEDURE public.tg_a_samael_activity_auto_on();

ALTER TABLE public.a_samael_activity_auto
  OWNER TO postgres;
  */