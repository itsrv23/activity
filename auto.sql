ALTER TABLE public.auto
  ADD COLUMN on_way_carma NUMERIC(15,2);

ALTER TABLE public.auto
  ALTER COLUMN on_way_carma SET DEFAULT 5;

COMMENT ON COLUMN public.auto.on_way_carma
IS 'Оценка за подачу';


ALTER TABLE public.auto
  ADD COLUMN s_activity NUMERIC(15,2);

ALTER TABLE public.auto
  ALTER COLUMN s_activity SET DEFAULT 100;

COMMENT ON COLUMN public.auto.s_activity
IS 'Активность';
  
--Считаем карму по подачи авто, рейтинг, активность
select COALESCE(karma2, 0), COALESCE(rait_client2, 0),COALESCE(activity_all, 0) into NEW.on_way_carma,NEW.rating, NEW.s_activity from a_samael_activity_auto where auto =  new.idx ;

NEW.s_activity = COALESCE(NEW.s_activity,100);
NEW.dyn_koef := COALESCE(NEW.s_activity,100);