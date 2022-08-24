CREATE OR REPLACE FUNCTION public.a_samael_activity_get_karma (
)
RETURNS void AS
$body$
DECLARE
m_o record;
p_o record;
osrm record;

alat DOUBLE PRECISION;
alon DOUBLE PRECISION;

dst numeric;
tm_plan numeric;
tm_fakt numeric;
tm numeric;
log_txt  text;
p_karma integer=0;
BEGIN

--osrm = (select a_samael_get_distance_osrm ('45.0382697581','38.94468832859','45.0379824562','38.9449775219') );

for m_o in (select * from main_oper where s_karma is null and s_dt_starttax is not null and s_dt_starttax >= now () - '5 minute'::interval
--(state='AutodialOnTheGoWait' or state='EndSucc' or state='TaxometerStopped' or state='PaymentManual')
 limit 1 ) LOOP
 	--Если предварительный тогда возьмем время completetime
    
    IF m_o.predvar='t'  THEN
    m_o.appointtime = m_o.completetime;
    END IF;
    
	for p_o in (select * from a_samael_activity_tmp_predlag_orders where order_idx=m_o.idx and  auto_idx=m_o.aautoid) LOOP
    
     select latitude,longitude into alat, alon from mtgpsdata_history where idauto=m_o.aautoid::integer and dt <= m_o.appointtime
     and dt >= m_o.appointtime - '1 minute'::interval
     and dt >= now () - '360 minute'::interval
      order by idx desc limit 1;
    
		IF p_o.idx > 0 
        and alat >=0 
        and alon >=0 
        and m_o.latitude >=0 
        and m_o.longitude >=0 THEN
          osrm = (select a_samael_get_distance_osrm(alat, alon, m_o.latitude, m_o.longitude));
            
          tm_plan = osrm.duration;
          tm_plan = tm_plan / 60;
          
          dst = osrm.distance;
          tm_fakt =  (select extract(epoch FROM age(m_o.s_dt_waiting,m_o.appointtime))/60);

		  IF dst > 0 and  tm_plan > 0 and tm_fakt > 0 THEN
          dst = round(dst,2);
          tm_plan = round(tm_plan,2);
          tm_fakt = round(tm_fakt,2);
          tm = tm_fakt - tm_plan;
          IF tm < 0 				THEN p_karma=5; END IF;
          IF tm between 0 and 3  	THEN p_karma=5; END IF;
          IF tm between 3 and 5  	THEN p_karma=4; END IF;
          IF tm between 5 and 7  	THEN p_karma=3; END IF;
          IF tm between 7 and 999  	THEN p_karma=2; END IF;
          
          --На время снегопада
          --IF p_karma <=4 THEN p_karma=4; END IF; 
          IF p_karma is null THEN p_karma = 0; END IF;
          
            --Если предварительный, и подал вовремя
            IF m_o.predvar='t' and m_o.s_dt_waiting <=m_o.targettime THEN
             p_karma = 5;
            END IF;
          
          log_txt = ' ' || ' Расстояние=' || dst || 'метров, ПланВремя=' || tm_plan || 'мин, ФактВремя=' || tm_fakt || ', ОценкаЗаПодачу=' || p_karma ;
          PERFORM xlog_main_write(m_o.idx, log_txt ,'<Система>', m_o.aautoid,m_o.avehicleid,m_o.adriverid);
		  PERFORM a_samael_send_message_to_driver (log_txt,m_o.aautoid);
          update a_samael_activity_log set karma = p_karma where  order_idx=m_o.idx and  auto_idx=m_o.aautoid;
          
          END IF;
          
        END IF;
	END LOOP;
    update main_oper set s_karma=p_karma where idx=m_o.idx;
END LOOP;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION public.a_samael_activity_get_karma ()
  OWNER TO postgres;