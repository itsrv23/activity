ALTER TABLE public.feauteres
  ADD COLUMN s_activity NUMERIC(15,2);

ALTER TABLE public.feauteres
  ALTER COLUMN s_activity SET DEFAULT 0;

COMMENT ON COLUMN public.feauteres.s_activity
IS 'Активность';

update  public.feauteres set  s_activity=0;