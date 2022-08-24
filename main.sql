ALTER TABLE public.main_parent
  ADD COLUMN s_karma INTEGER;

COMMENT ON COLUMN public.main_parent.s_karma
IS 'Карма за подачу';

ALTER TABLE public.main_parent
  ADD COLUMN s_aktivity_base NUMERIC(15,2);

ALTER TABLE public.main_parent
  ALTER COLUMN s_aktivity_base SET DEFAULT 0;

COMMENT ON COLUMN public.main_parent.s_aktivity_base
IS 'Базовая активность';

COMMENT ON COLUMN public.main.s_aktivity_base
IS 'Базовая активность';

COMMENT ON COLUMN public.main_oper.s_aktivity_base
IS 'Базовая активность';


COMMENT ON COLUMN public.main_parent.s_karma
IS 'Карма за подачу';

COMMENT ON COLUMN public.main.s_karma
IS 'Карма за подачу';

COMMENT ON COLUMN public.main_oper.s_karma
IS 'Карма за подачу';

