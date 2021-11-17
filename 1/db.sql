drop table if exists sensor_type CASCADE;
create table sensor_type
(
    id serial
        constraint sensor_type_pk
            primary key,
    name varchar not null
);

comment on table sensor_type is 'Справочник типов датчиков';

comment on column sensor_type.id is 'Идентификатор';

comment on column sensor_type.name is 'Наименование датчика';

drop table if exists sensor CASCADE;
create table sensor
(
    id serial
        constraint sensor_pk
            primary key,
    type_id int
        constraint sensor_sensor_type_id_fk
            references sensor_type,
    name varchar
);

comment on table sensor is 'Датчики';

comment on column sensor.id is 'Идентификатор';

comment on column sensor.type_id is 'Тип датчика';

comment on column sensor.name is 'Название конкретного датчика';

create index if not exists sensor_type_id_index
    on sensor (type_id);

drop table if exists sensor_readings CASCADE;
create table sensor_readings
(
    id serial
        constraint sensor_readings_pk
            primary key,
    sensor_id int not null
        constraint sensor_readings_sensor_id_fk
            references sensor (id),
    created_at timestamp default now() not null,
    pulse int,
    blood_pressure_diastolic int,
    blood_pressure_systolic int
);

comment on table sensor_readings is 'Показания датчиков';

comment on column sensor_readings.id is 'Идентификатор';

comment on column sensor_readings.sensor_id is 'Датчик';

comment on column sensor_readings.created_at is 'Дата и время показаний';

comment on column sensor_readings.pulse is 'Пульс';

comment on column sensor_readings.blood_pressure_diastolic is 'Кровяное давление(диастолическое)';

comment on column sensor_readings.blood_pressure_systolic is 'Кровяное давление(систолическое)';

create index if not exists sensor_readings_pulse_blood_pressure_index
    on sensor_readings ((created_at::time), pulse, blood_pressure_diastolic, blood_pressure_systolic);

create index if not exists sensor_readings_sensor_id_index
    on sensor_readings (sensor_id);

drop table if exists patient cascade;
create table patient
(
    id serial
        constraint patient_pk
            primary key,
    first_name varchar,
    last_name varchar,
    middle_name varchar
);

comment on table patient is 'Пациенты';

comment on column patient.id is 'Идентификатор';

comment on column patient.first_name is 'Имя';

comment on column patient.last_name is 'Фамилия';

comment on column patient.middle_name is 'Отчество';

drop table if exists patient_sensor cascade;
create table patient_sensor
(
    patient_id int
        constraint patient_sensor_patient_id_fk
            references patient (id),
    sensor_id int
        constraint patient_sensor_sensor_id_fk
            references sensor (id),
    PRIMARY KEY(patient_id, sensor_id)
);

comment on table patient_sensor is 'Связь между пациентами и датчиками';

comment on column patient_sensor.patient_id is 'Идентификатор пациента';

comment on column patient_sensor.sensor_id is 'Идентификатор датчика';

-- Запрос для выбора данных
-- выбор всех подопечных у которых после обеда были превышены нормы пульса и давления
select p.*
from sensor_readings sr
         left join sensor s on sr.sensor_id = s.id
         left join patient_sensor ps on s.id = ps.sensor_id
         left join patient p on ps.patient_id = p.id
where created_at::time >= '12:00:00'
  and (sr.pulse >= 90 or blood_pressure_diastolic >= 90 or blood_pressure_systolic >= 140)
group by p.id;
