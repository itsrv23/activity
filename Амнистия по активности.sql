
insert into a_samael_activity_log (auto_idx,activity,type, comment)
 (select idx, 90-dyn_koef,'5','Амнистрия по активности. Кто давно не выходил' from auto where deleted='f' and  dyn_koef < 90 and datelastorder is null);


insert into a_samael_activity_log (auto_idx,activity,type, comment)
 (select idx, 90-dyn_koef,'5','Амнистрия по активности.' from auto where deleted='f' and  dyn_koef < 90);

insert into autoeventqueue (autoid)(select idx from auto);