create database salon;

\connect salon

create table customers(
  customer_id serial primary key,
  phone varchar not null unique,
  name varchar not null
);

create table services(
  service_id serial primary key,
  name varchar not null
);

create table appointments(
  appointment_id serial primary key,
  customer_id int not null references customers(customer_id),
  service_id int not null references services(service_id),
  time varchar not null
);

insert into services(name) values ('hair'), ('nail'), ('skin');
