-- DDL
drop table division cascade constraints;
drop table district cascade constraints;
drop table citizen cascade constraints;
drop table license cascade constraints;
drop table accident cascade constraints;
drop table incident cascade constraints;
drop table hospital cascade constraints;
drop table admission cascade constraints;
drop type vmobiles;

Create Table division (
    division_name varchar2(20),
    division_size int,
    description varchar2(20),
    primary key (division_name)
);

Create Table district(
    district_name varchar2(20),
    district_size int,
    description varchar2(20),
    division_name varchar2(20) not null,
    primary key (district_name),
    foreign key (division_name) references division(division_name) on delete cascade
);

Create Table citizen (
    nid  varchar2(20),
    name  varchar2(20),
    date_of_birth date,
    occupation  varchar2(20),
    blood_group  varchar2(20),
    division_name  varchar2(20) not null,
    district_name  varchar2(20) not null,
    primary key(nid),
    foreign key (division_name) references division(division_name) on delete cascade,
    foreign key (district_name) references district(district_name) on delete cascade
);

Create Table license (
    license_id  varchar2(20),
    license_type  varchar2(20),
    issue_date date,
    expiration_date date,
    nid  varchar2(20) unique not null,
    primary key(license_id),
    foreign key (nid) references citizen(nid) on delete cascade
);

Create Table accident(
    incident_id varchar2(20),
    date_of_accident date,
    district_name  varchar2(20),
    number_of_death int,
    primary key (incident_id),
    foreign key (district_name) references district (district_name)
);

-- incident ekta junction table
Create Table incident(
    incident_id varchar2(20),
    license_id varchar2(20),
    foreign key(incident_id) references accident (incident_id) on delete cascade,
    foreign key(license_id) references license (license_id) on delete cascade
);

create or replace type vmobiles as varray(10) of varchar2(20)
/
-- i do not know why this multi value attribute creation breaks Oracle .. apparantly it was the / 
Create Table hospital(
    hospital_id  varchar2(20),
    hospital_name  varchar2(20),
    contact_number vmobiles,
    primary key (hospital_id)
);

--admission ekta juncion table
Create Table admission(
    admission_id   varchar2(20),
    date_of_admission date,
    description  varchar2(20),
    release_date date,
    hospital_id  varchar2(20),
    nid  varchar2(20),
    primary key (admission_id),
    foreign key(hospital_id) references hospital(hospital_id),
    foreign key(nid) references citizen(nid)
);

-- QUERIES

-- Task 1
select division_name,count(district_name) as no_of_districts
from district
group by division_name
order by no_of_districts desc;

-- Task 2
select district_name, count(nid) as no_of_citizen
from citizen
group by district_name
having count(nid) >= 20000
order by count(nid) desc;

-- Task 3
select c.name as citizen_name, count(i.incident_id) as no_of_accidents
from citizen c, license l, incident i
where c.nid = l.nid and l.license_id = i.license_id and c.nid = '210'
group by c.name;

-- Task 4
select *
from (select hospital_id, max(hospital_name) as hospital_name, count(admission_id) as no_of_patients
        from admission natural join hospital
        group by hospital_id)
where rownum <=5;

-- Task 5
select h.hospital_name as hospital_name, c.blood_group as patient_blood_group
from admission a, citizen c, hospital h
where a.hospital_id = h.hospital_id and a.nid = c.nid
order by h.hospital_id;

-- Task 6
select division_name, (division_size/no_of_citizen) as population_density
from (select division_name, count(nid) as no_of_citizen, max(division_size) as division_size
        from citizen natural join division
        group by division_name
        order by count(nid) desc
    );

-- Task 7
select *
from (select division_name, (division_size/no_of_citizen) as population_density
        from (select division_name, count(nid) as no_of_citizen, max(division_size) as division_size
                from citizen natural join division
                group by division_name
                order by count(nid) desc
            )
    )
where rownum<=3;

-- Task 8
select district_name, count(incident_id) as no_of_accidents
from accident
group by district_name
order by no_of_accidents desc;

-- Task 9
select division_name , no_of_accidents
from (select division_name, count(incident_id) as no_of_accidents  
        from district natural join accident
        group by division_name
        order by no_of_accidents
        )
where rownum <=1;

-- Task 10
select license_type, count(incident_id) as no_of_accidents
from license natural join incident
where license_id = license_id and (license_type = 'professional' or license_type = 'non-professional')
group by license_type
order by no_of_accidents;

-- Task 11
select *
from (select nid,name, (to_date(release_date)- to_date(date_of_admission)) as admission_time
        from citizen natural join admission
        order by admission_time desc)
where rownum<=1;

-- Task 12
select *
from (select division_name, count(nid) as no_of_young_people
        from citizen
        where current_date-date_of_birth >=15 and current_date-date_of_birth <=30
        group by division_name
        order by no_of_young_people)
where rownum<=1;

-- Task 13
select nid,name
from citizen natural join license
where current_date>expiration_date
order by nid;

-- Task 14
select c.nid as nid,max(c.name) as name,count(a.incident_id) as no_of_accidents
from citizen c, license l, incident a
where c.nid = l.nid and 
        l.license_id = a.license_id and 
        l.license_id =  (select license_id
                        from citizen natural join license
                        where current_date>expiration_date)
group by c.nid
order by no_of_accidents desc;

-- Task 15
select license_id, name
from license natural join citizen
where license_id not in (select license_id
                        from license natural join incident)
order by nid;

-- Task 16
select division_name, sum(number_of_death) as total_number_of_deaths
from district natural join accident
group by division_name
order by total_number_of_deaths;

-- Task 17
select name
from citizen natural join license
where trunc(months_between(issue_date,date_of_birth)/12) <= 22 or
        trunc(months_between(issue_date,date_of_birth)/12)>=40
order by license_id;

-- Task 18
select c.name as citizen_name
from citizen c, license l, incident i, accident a, admission ad
where c.nid = l.nid and 
        l.license_id = i.incident_id and 
        i.incident_id = a.incident_id and 
        ad.nid = c.nid and
        a.date_of_accident = ad.date_of_admission
order by name;

-- Task 19
select *
from (select h.hospital_name as hospital_name, count(c.nid) as number_of_people_from_dhaka
from citizen c, admission a, hospital h
where c.nid = a.nid and 
        h.hospital_id = a.hospital_id and 
        c.division_name = 'Dhaka'
group by h.hospital_name
order by number_of_people_from_dhaka desc)
where rownum<=1;

-- Task 20
select c.name as citizen_name
from citizen c, license l, incident i, accident a
where c.nid = l.nid and
        l.license_id = i.license_id and
        i.incident_id = a.incident_id and
        c.district_name != a.district_name
order by name;

--  ;-;