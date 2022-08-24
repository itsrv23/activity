ALTER TABLE public.autofines
  ADD COLUMN activ_plus NUMERIC(15,2);

ALTER TABLE public.autofines
  ALTER COLUMN activ_plus SET DEFAULT 0;

COMMENT ON COLUMN public.autofines.activ_plus
IS 'Активность +';

ALTER TABLE public.autofines
  ADD COLUMN activ_min NUMERIC(15,2);

ALTER TABLE public.autofines
  ALTER COLUMN activ_min SET DEFAULT 0;

COMMENT ON COLUMN public.autofines.activ_min
IS 'Активность -';

update autofines set activ_plus=0, activ_min=0;

ALTER TABLE public.autofines
ALTER COLUMN activ_plus SET NOT NULL;
ALTER TABLE public.autofines
ALTER COLUMN activ_min SET NOT NULL;

