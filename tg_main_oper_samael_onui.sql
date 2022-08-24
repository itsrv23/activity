---------- Активность ----------
DECLARE

BEGIN


  IF TG_OP = 'UPDATE' or TG_OP='INSERT' THEN

      --Если заказ не предварительный проставим коэффициенты
      IF TG_OP='INSERT'  THEN      
        NEW.s_aktivity_base = a_samael_activity_get_calendar();
        
       -- Если Безнал Организация
        IF NEW.dogovorid > 0  THEN
        NEW.s_aktivity_base = NEW.s_aktivity_base + (select coalesce(d_activity,3) from dogovor where idx= NEW.dogovorid);
        END IF;
       -- Если предварительный
        IF NEW.predvar is true THEN                
          NEW.s_aktivity_base = NEW.s_aktivity_base + 1;            
        END IF;
      END IF;                
      
            
      IF TG_OP = 'UPDATE' THEN
      
      -- Если заказ предварительный, и начинает предлагаться
          IF NEW.s_aktivity_base = 0 and NEW.predvar is true and (NEW.state = 'FreeSearch') and old.state is distinct from NEW.state THEN
          NEW.s_aktivity_base = a_samael_activity_get_calendar();
          END IF;
          
      -- Если Безнал Организация
          IF NEW.dogovorid > 0 and old.dogovorid is distinct from NEW.dogovorid THEN
          	
          NEW.s_aktivity_base = NEW.s_aktivity_base + (select coalesce(d_activity,3) from dogovor where idx= NEW.dogovorid);
          END IF;
      
      END IF;
      
      
      -- Посчитаем по характеристикам к заказу, если длина массива больше 0, при создании
      IF (TG_OP='INSERT' and array_length(NEW.feauteres, 1) > 0)  THEN
      	NEW.s_aktivity_base = NEW.s_aktivity_base + (select a_samael_activity_get_feauteres_summ(NEW.feauteres));         
      END IF;
      
      -- При изменении по характеристикам
      IF (TG_OP = 'UPDATE' and (old.feauteres is distinct from NEW.feauteres)) THEN
      	NEW.s_aktivity_base = NEW.s_aktivity_base - (select a_samael_activity_get_feauteres_summ(OLD.feauteres)); 
        NEW.s_aktivity_base = NEW.s_aktivity_base + (select a_samael_activity_get_feauteres_summ(NEW.feauteres)); 
      END IF;    
      
    IF NEW.s_aktivity_base < 1 THEN NEW.s_aktivity_base = 1; END IF;
    IF NEW.s_aktivity_base > 5 THEN NEW.s_aktivity_base = 5; END IF;
    
   -- PS Даже если оператор изменит, когда водитель взял заказ, активность не изменится. Так как считается фактическая, на момент взятия s_aktivity_base + по цепочкам
  END IF;  
    



END;
---------- Активность КОНЕЦ ----------
