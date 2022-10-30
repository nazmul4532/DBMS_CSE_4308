drop table Branch cascade constraints;
drop table Employee cascade ;
drop table ContactPerson cascade constraints;
drop table Clients cascade constraints;
drop table House cascade constraints;
drop table Owner cascade constraints;
drop table Visitation cascade constraints;
drop table Customer cascade constraints;

create table Branch
	(branch_name varchar2(20),
	street varchar2(20),
	city varchar2(20),
	post_code varchar2(20),
	primary key (branch_name)
	);
create table Employee
	(employee_id varchar2(20),
	first_name varchar2(20),
	last_name varchar2(20),
	date_of_birth date,
	position varchar2(20),
	salary numeric(10,0),
	branch_name varchar2(20),
	primary key (employee_id),
	foreign key (branch_name) references Branch
	);
create table ContactPerson
	(employee_id varchar2(20),
	first_name varchar2(20),
	last_name varchar2(20),
	primary key (employee_id),
	foreign key (employee_id) references Employee
	);
create table Clients
	(first_name varchar2(20),
	last_name varchar2(20),
	telephone varchar2(20),
	email varchar2(20),
	preferred_type varchar2(20),
	max_rent varchar2(20),
	employee_id varchar2(20),
	primary key (email),
	foreign key (employee_id) references ContactPerson
	);
create table Customer
	(branch_name varchar2(20),
	email varchar2(20),
	foreign key (email) references Clients,
	foreign key (branch_name) references Branch(branch_name)
	);
create table Owner
	(first_name varchar2(20),
	last_name varchar2(20),
	telephone varchar2(20),
	password varchar2(20),
	email varchar2(20),
	primary key (email)
	);
create table House
	(house_id varchar2(20),
	street varchar2(20),
	city varchar2(20),
	postcode varchar2(20),
	type varchar2(20),
	email varchar2(20),
	primary key (house_id),
	foreign key (email) references Owner(email)
	);
create table Visitation
	(date_of_visit date,
	client_comment varchar2(20),
	client_email varchar2(20) unique,
	house_id varchar2(20),
	primary key (date_of_visit),
	foreign key (client_email) references Clients(email),
	foreign key (house_id) references House(house_id)
	);

