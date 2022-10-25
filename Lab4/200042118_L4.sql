drop table depositor;
drop table borrower;
drop table account;
drop table loan;
drop table customer;
drop table branch;

create table branch
   (branch_name varchar(15) not null,
    branch_city varchar(15) not null,
    assets number not null,
    primary key(branch_name));
    
create table customer
   (customer_name varchar(15) not null,
    customer_street varchar(12) not null,
    customer_city varchar(15) not null,
    primary key(customer_name));

create table account
   (account_number varchar(15) not null,
    branch_name varchar(15) not null,
    balance number not null,
    primary key(account_number),
    foreign key(branch_name) references branch(branch_name));


create table loan
   (loan_number varchar(15) not null,
    branch_name varchar(15) not null,
    amount number not null,
    primary key(loan_number),
    foreign key(branch_name) references branch(branch_name));

create table depositor
   (customer_name varchar(15) not null,
    account_number varchar(15) not null,
    primary key(customer_name, account_number),
    foreign key(account_number) references account(account_number),
    foreign key(customer_name) references customer(customer_name));

create table borrower
   (customer_name varchar(15) not null,
    loan_number varchar(15) not null,
    primary key(customer_name, loan_number),
    foreign key(customer_name) references customer(customer_name),
    foreign key(loan_number) references loan(loan_number));

/* populate relations */

insert into customer values ('Jones',	'Main',		'Harrison');
insert into customer values ('Smith',	'Main',		'Rye');
insert into customer values ('Hayes',	'Main',		'Harrison');
insert into customer values ('Curry',	'North',	'Rye');
insert into customer values ('Lindsay',	'Park',		'Pittsfield');
insert into customer values ('Turner',	'Putnam',	'Stamford');
insert into customer values ('Williams',	'Nassau',	'Princeton');
insert into customer values ('Adams',	'Spring',	'Pittsfield');
insert into customer values ('Johnson',	'Alma',		'Palo Alto');
insert into customer values ('Glenn',	'Sand Hill',	'Woodside');
insert into customer values ('Brooks',	'Senator',	'Brooklyn');
insert into customer values ('Green',	'Walnut',	'Stamford');
insert into customer values ('Jackson',	'University',	'Salt Lake');
insert into customer values ('Majeris',	'First',	'Rye');
insert into customer values ('McBride',	'Safety',	'Rye');

insert into branch values ('Downtown',	'Brooklyn',	 900000);
insert into branch values ('Redwood',	'Palo Alto',	2100000);
insert into branch values ('Perryridge',	'Horseneck',	1700000);
insert into branch values ('Mianus',	'Horseneck',	 400200);
insert into branch values ('Round Hill',	'Horseneck',	8000000);
insert into branch values ('Pownal',	'Bennington',	 400000);
insert into branch values ('North Town',	'Rye',		3700000);
insert into branch values ('Brighton',	'Brooklyn',	7000000);
insert into branch values ('Central',	'Rye',		 400280);
 
insert into account 	values ('A-101',	'Downtown',	500);
insert into account 	values ('A-215',	'Mianus',	700);
insert into account 	values ('A-102',	'Perryridge',	400);
insert into account 	values ('A-305',	'Round Hill',	350);
insert into account 	values ('A-201',	'Perryridge',	900);
insert into account 	values ('A-222',	'Redwood',	700);
insert into account 	values ('A-217',	'Brighton',	750);
insert into account 	values ('A-333',	'Central',	850);
insert into account 	values ('A-444',	'North Town',	625);

insert into depositor values ('Johnson','A-101');
insert into depositor values ('Smith',	'A-215');
insert into depositor values ('Hayes',	'A-102');
insert into depositor values ('Hayes',	'A-101');
insert into depositor values ('Turner',	'A-305');
insert into depositor values ('Johnson','A-201');
insert into depositor values ('Jones',	'A-217');
insert into depositor values ('Lindsay','A-222');
insert into depositor values ('Majeris','A-333');
insert into depositor values ('Smith',	'A-444');

insert into loan 	values ('L-17',		'Downtown',	1000);
insert into loan 	values ('L-23',		'Redwood',	2000);
insert into loan 	values ('L-15',		'Perryridge',	1500);
insert into loan 	values ('L-14',		'Downtown',	1500);
insert into loan 	values ('L-93',		'Mianus',	500);
insert into loan 	values ('L-11',		'Round Hill',	900);
insert into loan 	values ('L-16',		'Perryridge',	1300);
insert into loan 	values ('L-20',		'North Town',	7500);
insert into loan 	values ('L-21',		'Central',	570);

insert into borrower values ('Jones',	'L-17');
insert into borrower values ('Smith',	'L-23');
insert into borrower values ('Hayes',	'L-15');
insert into borrower values ('Jackson',	'L-14');
insert into borrower values ('Curry',	'L-93');
insert into borrower values ('Smith',	'L-11');
insert into borrower values ('Williams','L-17');
insert into borrower values ('Adams',	'L-16');
insert into borrower values ('McBride',	'L-20');
insert into borrower values ('Smith',	'L-21');

commit;


/*Task Starts Here*/


<--- 1 --->
select distinct customer.customer_name 
from customer,depositor,borrower
where customer.customer_name = depositor.customer_name and customer.customer_name = borrower.customer_name
order by customer.customer_name;

select distinct customer_name
from customer natural join depositor natural join borrower
order by customer_name;

select customer_name
from customer
intersect
select customer_name
from depositor
intersect
select customer_name
from borrower;

<--- 2 --->
select customer_name 
from depositor
union 
select customer_name
from borrower;

select distinct customer.customer_name 
from customer,depositor,borrower
where customer.customer_name = depositor.customer_name or customer.customer_name = borrower.customer_name
order by customer.customer_name;

<--- 3 --->
select customer_name
from customer
intersect
select customer_name
from borrower
minus 
select customer_name
from depositor;

select customer_name
from (select customer_name
from customer
intersect
select customer_name
from borrower)
where customer_name not in ( select customer_name from depositor)
order by customer_name;

<--- 4 --->
select sum(assets) as Total_Asset
from branch;

<--- 5 --->

select branch_city, count(account_number) as number_of_accounts
from branch natural join account
group by branch_city;

<--- 6 ---> // EKHANE BHUL chilo
select branch_name, avg(balance) as average_balance
from branch natural join account
group by branch_name
order by average_balance desc;

<--- 7 --->
select branch_city, sum(balance) as total_balance
from branch natural join account
group by branch_city
order by total_balance desc;

<--- 8 --->
select branch_name, avg(amount) as average_loan
from branch natural join loan
group by branch_name
having branch_name not in ('Horseneck');

select branch_name, avg(amount) as average_loan
from branch natural join loan
where branch_name not in ('Horseneck')
group by branch_name;

<--- 9 --->
select account_number, customer_name, balance
from account natural join depositor
where balance = ALL (
    select max(balance) as max_balance
    from account natural join depositor
);

select *
from (select account_number, customer_name, max(balance) as max_balance
from account natural join depositor
group by account_number, customer_name
order by max_balance desc)
where rownum <=1;

<--- 10 --->
select c.customer_name,c.customer_street,c.customer_city
from account a, customer c, branch b , depositor d
where c.customer_city = b.branch_city and
c.customer_name = d.customer_name and
a.account_number = d.account_number and
a.branch_name = b.branch_name;

<--- 11 --->
select branch_city, avg(amount) as average_loan
from branch natural join loan
group by branch_city
having avg(amount) >=1500
order by average_loan desc;

select *
from (select branch_city, avg(amount) as average_loan
from branch natural join loan
group by branch_city
order by average_loan desc) temp
where temp.average_loan >= 1500;


<--- 12 ---> // Ekhane bhul ase
select branch_name
from (select avg(assets) as average_assets from branch) temp1,
    (select branch_name, sum(assets) as total_assets from branch group by branch_name) temp2
where average_assets < total_assets;

<--- 13 ---> 
select distinct c.customer_name
from account a, depositor d, customer c, borrower b, loan l
where a.account_number = d.account_number and
c.customer_name = d.customer_name and
c.customer_name = b.customer_name and
b.loan_number = l.loan_number and 
a.balance >= l.amount;

<--- 14 --->
select branch.branch_name, branch_city, branch.assets
from branch
where branch.branch_city in (select customer.customer_city
                             from customer
                             where customer.customer_name not in (select depositor.customer_name
                                                                  from depositor)
                                   and customer.customer_name not in (select borrower.customer_name
                                                                      from borrower))
      and branch.branch_name in (select loan.branch_name
                                 from loan)
      and branch.branch_name in (select account.branch_name
                                 from account);
