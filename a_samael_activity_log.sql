CREATE TABLE public.a_samael_activity_log (
  idx SERIAL,
  order_idx INTEGER,
  auto_idx INTEGER NOT NULL,
  activity NUMERIC(15,2) DEFAULT 0,
  karma NUMERIC(15,2) DEFAULT 0,
  type INTEGER,
  comment TEXT,
  create_dt TIMESTAMP WITH TIME ZONE DEFAULT now(),
  CONSTRAINT a_samael_activity_log_pkey PRIMARY KEY(idx)
) 
WITH (oids = false);

ALTER TABLE public.a_samael_activity_log
  ALTER COLUMN auto_idx SET STATISTICS 0;

COMMENT ON TABLE public.a_samael_activity_log
IS 'Samael Активность Логи ';

COMMENT ON COLUMN public.a_samael_activity_log.idx
IS 'idx';

COMMENT ON COLUMN public.a_samael_activity_log.order_idx
IS 'Заказ
ref main';

COMMENT ON COLUMN public.a_samael_activity_log.auto_idx
IS 'Экипаж
ref auto';

COMMENT ON COLUMN public.a_samael_activity_log.activity
IS 'Активность';

COMMENT ON COLUMN public.a_samael_activity_log.karma
IS 'Оценка за подачу';

COMMENT ON COLUMN public.a_samael_activity_log.type
IS 'Тип
ref a_samael_activity_log_type';

COMMENT ON COLUMN public.a_samael_activity_log.comment
IS 'Комментарий';

COMMENT ON COLUMN public.a_samael_activity_log.create_dt
IS 'Дата создания';

CREATE INDEX a_samael_activity_log_auto_dt ON public.a_samael_activity_log
  USING btree (auto_idx, create_dt);

CREATE INDEX a_samael_activity_log_ord_auto ON public.a_samael_activity_log
  USING btree (order_idx, auto_idx);