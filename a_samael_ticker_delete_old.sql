-- Удаляем оферы заказы, для активности
delete from a_samael_activity_tmp_predlag_orders where create_dt <=  now () - '5 minute'::interval;

-- Чистим старые логи по активноси
delete from a_samael_activity_log where create_dt <= now() - '65 DAY'::interval;
