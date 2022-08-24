CREATE OR REPLACE FUNCTION public.a_samael_activity_get_feauteres_summ (
  mo_feauteres integer []
)
RETURNS numeric AS
$body$
/*
Функция возвращает сторимость диспетчерских, по характеристикам
Передаем заказ, получаем положительное число - которое будем уже списывать  
*/
DECLARE
i INTEGER=1;
o_feauteres integer[];
idx_feauteres integer;
all_activity numeric(15,2)=0;
all_activity_summ numeric(15,2)=0;
BEGIN

o_feauteres = mo_feauteres;

  LOOP
      idx_feauteres := o_feauteres[i];
      IF idx_feauteres > 0   THEN
      all_activity := (select s_activity from feauteres where idx = idx_feauteres);
      
          IF all_activity <> 0 THEN 
          all_activity_summ := all_activity_summ + all_activity;
          END IF;
      i:= i + 1; 
      else
      EXIT;   
      END IF;
    
  END LOOP;
  
  if all_activity_summ is null then all_activity_summ = 0; end if;

return all_activity_summ;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;