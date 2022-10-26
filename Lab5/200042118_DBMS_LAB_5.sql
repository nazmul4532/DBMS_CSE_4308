
-->Tasks Start Here <--
alter table instructor rename column ID to i_ID;
@F:\DBMS_LAB\DBMS_Lab_5\DDL+drop.sql
@F:\DBMS_LAB\DBMS_Lab_5\smallRelationsInsertFile.sql


-->Task 1<--
create or replace view Advisor_Selection as 
select i_ID,name,dept_name
from instructor;

-->Task 2<--
create or replace view Student_Count as
select name,count(s_ID) as student_count
from Advisor_Selection natural join advisor
group by name;

create role students;
grant select on dbms_200042118.advisor to students;
grant select on dbms_200042118.course to students;

create role course_teacher;
grant select on dbms_200042118.student to course_teacher;
grant select on dbms_200042118.course to course_teacher;

create role dept_head;
grant course_teacher to dept_head;.
grant select on dbms_200042118.instructor to dept_head;
grant insert on dbms_200042118.instructor to dept_head;

create role administrator;
grant select on dbms_200042118.department to administrator;
grant select on dbms_200042118.instructor to administrator;
grant update (budget) on dbms_200042118.department to administrator;


create user nazz identified by naz4532;
grant students to nazz;
grant create session to nazz

create user bakht identified by bakht4532;
grant course_teacher to bakht;

create user armk identified by armk4532;
grant dept_head to armk;

create user sian identified by sian4532;
grant administrator to sian;



conn nazz/naz4532
select * from dbms_200042118.course;
select * from dbms_200042118.advisor;
select * from dbms_200042118.instructor; -->doesn't show<--
select * from dbms_200042118.department; -->doesn't show<--

conn bakht/bakht4532
select * from dbms_200042118.course;
select * from dbms_200042118.student;
select * from dbms_200042118.instructor;
 -->doesn't show<--
select * from dbms_200042118.department;
 -->doesn't show<--

conn armk/armk4532
select * from dbms_200042118.course;
select * from dbms_200042118.student;
select * from dbms_200042118.instructor;
 -->shows<--
select * from dbms_200042118.department; 
-->doesn't show<--
insert into dbms_200042118.instructor values ('45311', 'Sian', 'Comp. Sci.', '42000');
 -->can add new instructor<--
select * from dbms_200042118.instructor;


conn sian/sian4532
-->works<--
select * from dbms_200042118.department;
-->works<--
select * from dbms_200042118.instructor;
--> can update budget<--
Update dbms_200042118.department
Set budget = 69000000
where dept_name = 'Biology';
select * from dbms_200042118.department;

Update dbms_200042118.department
Set dept_name = 'Bio'
where dept_name = 'Biology';
select * from dbms_200042118.department;
-->doesn't work because no access to update dept_name <--