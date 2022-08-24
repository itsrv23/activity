CREATE OR REPLACE FUNCTION public.a_samael_activity_ticker_update_rait_and_karma (
)
RETURNS void AS
$body$
DECLARE
act_auto RECORD;
ocenka_atrait numeric (15,2);
atrait numeric (15,2);
cnt_atrait integer;

ocenka_a_karma numeric (15,2);
a_karma numeric (15,2);
cnt_a_karma integer;

a_rec record;
BEGIN



  FOR act_auto in (select * from a_samael_activity_auto ) LOOP
	--Считаем оценки клиентов
    select count(1),(round((sum(rate*weight)::numeric)/sum(weight) , 4)) 
    into cnt_atrait,atrait     
    from  autorating where idx in (select idx from autorating where autoid=act_auto.auto order by idx desc limit 30);
    --Если нет оценок
    atrait = coalesce(atrait,5);
    --Если меньше 30, то добиваем 5
    IF cnt_atrait < 30 THEN
    atrait = ((5 * (30-cnt_atrait)) + (atrait*cnt_atrait))/30 ;
    END IF;
    
    ocenka_atrait = atrait;
    
  	select count(1),avg(karma) into cnt_a_karma, a_karma 
    from a_samael_activity_log where idx in     (select idx from a_samael_activity_log where karma >=1 and auto_idx=act_auto.auto order by idx desc limit 30);
  	
     --Если нет оценок Кармы, тогда 5
    a_karma = coalesce(a_karma,5);
    --Если меньше 100, то добиваем 5
    IF cnt_a_karma < 100 THEN
    a_karma = ((5 * (100-cnt_a_karma)) + (a_karma*cnt_a_karma))/100 ;
    END IF;
    
    ocenka_a_karma = a_karma;
    
    atrait = (atrait - 4.5) * 100;
  	IF atrait < 0 THEN atrait=0; END IF;
    
  	a_karma = (a_karma - 4.5) * 60;
  	IF a_karma < 0 THEN a_karma=0; END IF;
    
  	update a_samael_activity_auto set rait_client=atrait,
    					rait_client2=ocenka_atrait,
                                        karma = a_karma,
                                        karma2 = ocenka_a_karma 
                                        where auto = act_auto.auto;
    -- Логируем изменения по оценкам
    IF atrait <> act_auto.rait_client THEN
    insert into a_samael_activity_log (auto_idx,activity,type)values(act_auto.auto, atrait - act_auto.rait_client,6);
    END IF;
    
    -- Логируем изменения по карме 
    IF a_karma <> act_auto.karma THEN
    insert into a_samael_activity_log (auto_idx,activity,type)values(act_auto.auto, a_karma - act_auto.karma,7);
    END IF;
    
    
    
  END LOOP;


  FOR a_rec  in (select idx from auto where deleted='f' and dyn_koef > 91 and  datelastorder between (now() - '2 DAY'::interval) and (now() - '1 DAY'::interval)) LOOP
     IF 0=(select count (idx) from a_samael_activity_log  where auto_idx=a_rec.idx and 
     create_dt between now() - '2 DAY'::interval and now() - '1 DAY'::interval 
     and type='4') THEN
     insert into a_samael_activity_log (auto_idx,activity,type)values(a_rec.idx, -1,4); 
    END IF;
  END LOOP;
  

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION public.a_samael_activity_ticker_update_rait_and_karma ()
  OWNER TO postgres;