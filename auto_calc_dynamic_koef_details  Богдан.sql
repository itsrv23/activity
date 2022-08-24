CREATE OR REPLACE FUNCTION public.auto_calc_dynamic_koef_details (
  p_autoid integer,
  out title text,
  out describe text,
  out result text
)
RETURNS SETOF record AS
$body$
DECLARE
  c1 record;
  ref record;
  a_rec record;
  activity_rec record;
  
  current_lvl text;
  lvl text;
  cnt_act numeric(15,2);
BEGIN
---------------------
select * into a_rec from auto where idx = p_autoid;
  -- Вывести отчет по дин.коэффициентам по авто 
  FOR c1 IN (SELECT * FROM 
  
   public.auto_koef_values_wame where autoid = p_autoid) LOOP
   
      
   select * into activity_rec from a_samael_activity_auto where auto = p_autoid;
   

      IF activity_rec. idx > 0 THEN
        title := '<p style="text-align: center;"><a href="/autocabinet/fullnews?idx=20" >ОПИСАНИЕ РАБОТЫ В ПРОГРАММЕ И НЕ ТОЛЬКО</a></p>'
        ;
        describe := '';
        result := '';
        RETURN NEXT;
        
      	------------------------------
        -- УРОВНИ
        ------------------------------
        current_lvl = (select s_comment from vid_auto va inner join auto a on a.id_vid_auto=va.idx and a.idx=p_autoid);
        cnt_act  = COALESCE(a_rec.s_activity_for_level,0);
        
        -- частники
        IF a_rec.id_vid_auto in (16,17,216,217,316,317) THEN
        
        IF cnt_act > -9999 and  cnt_act < 80 THEN
        lvl = 
         '<p><b><font color="#FF0000"> ' || 'ТЕКУЩИЙ УРОВЕНЬ: ' || COALESCE(current_lvl,'') ||  '</font></b></p>'|| 
        'Активность этой недели: ' || cnt_act || '</br>' ||
        'Уровень новой недели "УРОВЕНЬ 1"' || '</br>' ||
        'до "УРОВЕНЬ 2" осталось:'|| 80-cnt_act || '</br>' ||
        '</br>' ||
        '<p style="text-align: center;"><a href="/autocabinet/fullnews?idx=25" >ОПИСАНИЕ УРОВНЕЙ</a></p>'; 
        END IF;
        
        IF cnt_act >= 80 and  cnt_act < 180 THEN
        lvl = 
         '<p><b><font color="#FF0000"> ' || 'ТЕКУЩИЙ УРОВЕНЬ: ' || COALESCE(current_lvl,'') ||  '</font></b></p>'||
        'Активность этой недели: ' || cnt_act || '</br>' ||
        'Уровень новой недели "УРОВЕНЬ 2"' || '</br>' ||
        'до "УРОВЕНЬ 3" осталось:'|| 180-cnt_act || '</br>' ||
        '</br>' ||
        '<p style="text-align: center;"><a href="/autocabinet/fullnews?idx=25" >ОПИСАНИЕ УРОВНЕЙ</a></p>'; 
        END IF;
        
        IF cnt_act >= 180 and  cnt_act < 9999 THEN
        lvl = 
         '<p><b><font color="#FF0000"> ' || 'ТЕКУЩИЙ УРОВЕНЬ: ' || COALESCE(current_lvl,'') ||  '</font></b></p>'|| 
        'Активность этой недели: ' || cnt_act || '</br>' ||
        'Уровень новой недели "УРОВЕНЬ 3"' || '</br>' ||
		'<b>ВЫ БОЛЬШОЙ МОЛОДЕЦ!</b>' ||
        '</br>' ||
        '<p style="text-align: center;"><a href="/autocabinet/fullnews?idx=25" >ОПИСАНИЕ УРОВНЕЙ</a></p>'; 
        END IF;
        
        END IF;
        
        END IF;
        
          --по графику
        IF a_rec.id_vid_auto in (19,219,319) THEN
        
        lvl = 
         '<p><b><font color="#FF0000"> ' || 'ТЕКУЩИЙ УРОВЕНЬ: ' || COALESCE(current_lvl,'') ||  '</font></b></p>'|| 
        'Активность этой недели: ' || cnt_act || '</br>' ||
        'Купи 5 смен в неделю, и получи УРОВЕНЬ 2' || '</br>' ||
        'Купи 6 смен в неделю, и получи УРОВЕНЬ 3' || '</br>' ||
        '<p style="text-align: center;"><a href="/autocabinet/fullnews?idx=26" >ОПИСАНИЕ УРОВНЕЙ</a></p>'; 
        
        END IF;
        
        --Аренда
        IF a_rec.id_vid_auto in (14,27,28,214,227,228,314,327,328)  THEN
        
        lvl = 
         '<p><b><font color="#FF0000"> ' || 'ТЕКУЩИЙ УРОВЕНЬ: ' || COALESCE(current_lvl,'') ||  '</font></b></p>'|| 
        'Активность этой недели: ' || cnt_act || '</br>' ; 
        
        END IF;
        
        
        
        
        title := '';
        result := COALESCE(lvl,'');
        RETURN NEXT;
      	------------------------------
        -- УРОВНИ
        ------------------------------
         title := '<p style="text-align: center;"><a href="https://youtu.be/qE1UTHoDBrE" target="_blank">ЖМИ СЮДА, ДЛЯ ПРОСМОТРА ВИДЕО ПО АКТИВНОСТИ</a></p>'
         || '</br>' || 'Вы можете повысить свою активность выполняя заказы, и потерять за отказы от заказов
        </br>Основа активности - оценки, клиентов и оценка за подачу авто на адрес
        ';
        describe := '';
        result := '<p><b><font color="#FF0000"> ' ||'Активность: '||round((activity_rec.activity_all)::numeric,2) || '</font></b></p>';
        RETURN NEXT;
        title := ' ';
        result := 'Оценка от клиентов: '||round((a_rec.rating)::numeric,2);
        RETURN NEXT;
        title := ' ';
        result := 'Оценка за подачу: '||round((a_rec.on_way_carma)::numeric,2);
        RETURN NEXT;
        
        title := ' ';
        result := a_samael_activity_get_infokoef(p_autoid);
        RETURN NEXT;
        
      
      
      --Вывод значений по рефералке
  /*
      IF 1 > 0 THEN 
      title := 'Реферальная система "Приведи друга"';
      describe := '';
      result := (
                  select array_to_string(array_agg(ref_text), '<br> ') from 

		  (select a.pozivnoy || ' ' || a.name_for_client ||  ', Заказов: ' ||r.cnt_order_end as ref_text from auto a 
                  inner join a_samael_referalka_drivers r on r.kogo_privel=a.idx
                  where a.idx in (select r1.kogo_privel from a_samael_referalka_drivers r1 where kto_privel =p_autoid and r1.deleted='f')
                  and  r.deleted='f'
                  ) s
                  );
             
      RETURN NEXT;
      
      END IF;
      */
  END LOOP;
  
  

  RETURN;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100 ROWS 1000;

ALTER FUNCTION public.auto_calc_dynamic_koef_details (p_autoid integer, out title text, out describe text, out result text)
  OWNER TO postgres;