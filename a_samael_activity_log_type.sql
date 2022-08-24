CREATE TABLE public.a_samael_activity_log_type (
  idx SERIAL,
  name TEXT,
  CONSTRAINT a_samael_activity_log_type_pkey PRIMARY KEY(idx)
) 
WITH (oids = false);

COMMENT ON TABLE public.a_samael_activity_log_type
IS 'Samael Активность Типы начислений активности';

COMMENT ON COLUMN public.a_samael_activity_log_type.idx
IS 'idx';

COMMENT ON COLUMN public.a_samael_activity_log_type.name
IS 'Наименование';

/* Data for the 'public.a_samael_activity_log_type' table  (Records 1 - 5) */

INSERT INTO public.a_samael_activity_log_type ("idx", "name")
VALUES 
  (1, E'Заказ'),
  (2, E'Штраф'),
  (3, E'Покупка тарифа'),
  (4, E'Сгорание за бездействие'),
  (5, E'Ручное ');

INSERT INTO public.a_samael_activity_log_type ("idx", "name")
VALUES 
  (6, E'Оценка от клиентов'),
  (7, E'Оценка за подачу');