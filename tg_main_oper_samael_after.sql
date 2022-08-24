---------- Активность ----------
DECLARE
gps_lat  DOUBLE PRECISION;
gps_lon DOUBLE PRECISION;
BEGIN

IF TG_OP = 'UPDATE' 
	and (OLD.completeid is distinct from NEW.completeid) 
    and  NEW.completeid = 1 
    and NEW.aautoid is not null 
    THEN
	update a_samael_activity_tmp_predlag_orders set accept = 't' where order_idx=NEW.IDX and auto_idx=NEW.aautoid;   
END IF;


--Вставляем если взяли из свободных  
IF TG_OP = 'UPDATE' and (NEW.showas_freeorder is true or  NEW.predvar is true) 
and (OLD.completeid is distinct from NEW.completeid)
and  NEW.completeid = 1
and NEW.aautoid is not null THEN
   
   select coalesce(latitude,0), coalesce(longitude,0) into gps_lat, gps_lon  from mtgpsdata where idauto=NEW.aautoid;
   
       IF 0=(select count (idx) from a_samael_activity_tmp_predlag_orders where order_idx=NEW.idx and auto_idx=NEW.aautoid) THEN 
        insert into a_samael_activity_tmp_predlag_orders 
                (order_idx,auto_idx,act_plus,act_min,lat,lon,accept) 
                values 
                (NEW.idx, NEW.aautoid,COALESCE(NEW.s_aktivity_base,0) + 1, 0, gps_lat, gps_lon,true); 
        insert into a_samael_activity_log (order_idx,auto_idx,activity,type)values(NEW.idx, NEW.aautoid, COALESCE(NEW.s_aktivity_base,0) + 1,1); 
       END IF;  
END IF;  
    

IF (TG_OP='UPDATE') and (OLD.completeid is distinct from NEW.completeid)  THEN 
	IF NEW.completeid = 12 THEN
		insert into a_samael_activity_log (order_idx,auto_idx,activity,type,comment)values(NEW.idx, NEW.aautoid, -15,2,'Отмена по вине водителя'); 
    END IF;
END IF;

END;
---------- Активность КОНЕЦ ----------