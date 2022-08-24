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
BEGIN
---------------------
select * into a_rec from auto where idx = p_autoid;
  -- Вывести отчет по дин.коэффициентам по авто 
  FOR c1 IN (SELECT * FROM 
  
   public.auto_koef_values_wame where autoid = p_autoid) LOOP
   /*
      IF (1 = 1) THEN
        --title := ' ';
        result := '<p><b><font color="#FF0000">ВАШ ПАРОЛЬ= '|| a_rec.password || '</font></b></p>';
        --<p><b><font color="#FF0000">ЧАС ПИК</font></b></p>
        title := '<p><a href="https://play.google.com/store/apps/details?id=lime.taxi.driver.id175"> СКАЧАТЬ НОВОЕ ПРИЛОЖЕНИЕ, ЖМИ ТУТ </a></p>';
        
        
        RETURN NEXT;
      END IF;
      */
      /*

      IF (c1.koef_1_vidauto_value <> 0) THEN
        title := 'Кф.1 Рейтинг из вида авто';
        describe := '';
        result := 'Кф.1= '||round((c1.koef_1_vidauto_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_2_cntsucc_value <> 0) THEN
        title := 'Кф.2 За выполнение заказов с 6:30 до 9:00 с ПН по СБ';
        describe := '';
        result := 'Кф.2= '||round((c1.koef_2_cntsucc_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_3_cntsucc_rayon_value <> 0) THEN
        title := 'Кф.3 За выполнение заказов с 7:20 до 8:20 с ПН по СБ с районов Новый,Финский,ТИЗ';
        result := 'Кф.3= '||round((c1.koef_3_cntsucc_rayon_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_4_cntrej_value <> 0) THEN
        title := 'Кф.4 За отказы от заказов';
        describe := '';
        result := 'Кф.4= '||round((c1.koef_4_cntrej_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1."koef_5_medik_value" <> 0) THEN
        title := 'Кф.5 За оператора, медика';
        describe := '';
        result := 'Кф.5= '||round((c1."koef_5_medik_value")::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_6_cancelorder_value <> 0) THEN
        title := 'Кф.6 За отмененные заказы';
        describe := '';
        result := 'Кф.6= '||round((c1.koef_6_cancelorder_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_7_claim_value <> 0) THEN
        title := 'Кф.7 За Жалобы на водителя';
        describe := '';
        result := 'Кф.7= '||round((c1.koef_7_claim_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_8_cntsucc_paybycard_value <> 0) THEN
        title := 'Кф.8 За заказы с банковским терминалом';
        describe := '';
        result := 'Кф.8= '||round((c1.koef_8_cntsucc_paybycard_value)::numeric,2);
        RETURN NEXT;
      END IF;
      IF (c1.koef_9_beznal_arenda_value <> 0) THEN
        title := 'Кф.9 За Предварительные заказы';
        describe := '';
        result := 'Кф.9= '||round((c1.koef_9_beznal_arenda_value)::numeric,2);
        RETURN NEXT;
      END IF;
  
      IF (c1.koef_11_dop_orders <> 0) THEN
        title := 'Кф.11 Дополнительный';
        describe := '';
        result := 'Кф.11= '||round((c1.koef_11_dop_orders)::numeric,2);
        RETURN NEXT;
      END IF;
      */
      
   select * into activity_rec from a_samael_activity_auto where auto = p_autoid;
   

      IF activity_rec. idx > 0 THEN
        
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
      END IF;
      
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