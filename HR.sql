#drop database HR;

create database HR;
use HR;

create table REGIONS(
REGION_ID varchar(20),
REGION_NAME varchar(45),
constraint PKregion primary key(REGION_ID));
#------------------------------------------------------------------------------------------------
create table COUNTRIES(
COUNTRY_ID varchar(20),
COUNTRY_NAME varchar(45),
REGION_ID varchar(20),
constraint PKcountry primary key(COUNTRY_ID),
constraint FKregion foreign key(REGION_ID) references REGIONS(REGION_ID));
#------------------------------------------------------------------------------------------------
create table LOCATIONS(
LOCATION_ID varchar(20),
STREET_ADDRESS varchar(45),
POSTAL_CODE varchar(20),
CITY varchar(20),
STATE_PROVINCE varchar(20),
COUNTRY_ID varchar(20),
constraint PKlocation primary key(LOCATION_ID),
constraint FKcountry foreign key(COUNTRY_ID) references COUNTRIES(COUNTRY_ID));       
#------------------------------------------------------------------------------------------------
create table DEPARTMENTS(
DEPARTMENT_ID int,
DEPARTMENT_NAME varchar(20),
MANAGER_ID varchar(20),
LOCATION_ID varchar(20),
constraint PKdepartment primary key(DEPARTMENT_ID),
constraint FKlocation foreign key(LOCATION_ID) references LOCATIONS(LOCATION_ID));
#------------------------------------------------------------------------------------------------
create table JOBS(
JOB_ID varchar(20),
JOB_TITLE varchar(45),
MIN_SALARY numeric,
MAX_SALARY numeric,
constraint PKjob primary key(JOB_ID));
#------------------------------------------------------------------------------------------------
create table EMPLOYEES(
EMPLOYEE_ID int,
FIRST_NAME varchar(20),
LAST_NAME varchar(20),
EMAIL varchar(20),
PHONE_NUMBER varchar(20),
HIRE_DATE date,
JOB_ID varchar(20),
SALARY numeric,
COMMISSION_PTC numeric,
MANAGER_ID int,
DEPARTMENT_ID int,
constraint PKemployee primary key(EMPLOYEE_ID),
constraint FKdepartment foreign key(DEPARTMENT_ID) references DEPARTMENTS(DEPARTMENT_ID),
constraint FKjob2 foreign key(JOB_ID) references JOBS(JOB_ID),
constraint FKmanager foreign key(MANAGER_ID) references EMPLOYEES(EMPLOYEE_ID));
#------------------------------------------------------------------------------------------------
create table JOB_HISTORY(
EMPLOYEE_ID int,
START_DATE date,
END_DATE date,
JOB_ID varchar(20),
DEPARTMENT_ID int,
constraint FKjob foreign key(JOB_ID) references JOBS(JOB_ID),
constraint FKdepartment2 foreign key(DEPARTMENT_ID) references DEPARTMENTS(DEPARTMENT_ID),
constraint FKemployee foreign key(EMPLOYEE_ID) references EMPLOYEES(EMPLOYEE_ID));
#------------------------------------------------------------------------------------------------
create table JOB_GRADES(
GRADE_LEVEL varchar(20),
LOWEST_SAL numeric,
HIGHEST_SAL numeric);
#------------------------------------------------------------------------------------------------
#worksheet3
#1-----------------------------------------------------------------------------------------------
select * from DEPARTMENTS
order by DEPARTMENT_ID DESC, DEPARTMENT_NAME asc;
#2-----------------------------------------------------------------------------------------------
select DEPARTMENT_ID, JOB_ID, AVG(SALARY)
from EMPLOYEES
group by DEPARTMENT_ID, JOB_ID;
#3-----------------------------------------------------------------------------------------------
select AVG(SALARY)
from EMPLOYEES
group by DEPARTMENT_ID;
#4-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
from EMPLOYEES
where FIRST_NAME like 'L%s_';
#5-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
from EMPLOYEES
where SALARY>=2600 AND SALARY<=4500 AND DEPARTMENT_ID=30;
#------------------------------------------------------------------------------------------------
#worksheet4
#1-----------------------------------------------------------------------------------------------
select EMPLOYEES.EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENTS.DEPARTMENT_ID, DEPARTMENT_NAME
from EMPLOYEES, DEPARTMENTS
where EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;
#2-----------------------------------------------------------------------------------------------
select EMPLOYEES.EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_NAME
from EMPLOYEES, DEPARTMENTS
where EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID AND SALARY>2500 AND SALARY NOT BETWEEN 3500 AND 4500;
#3-----------------------------------------------------------------------------------------------
select JOBS.JOB_ID, JOB_TITLE, EMPLOYEES.EMPLOYEE_ID, END_DATE
from JOBS, JOB_HISTORY, EMPLOYEES
where JOB_HISTORY.JOB_ID = JOBS.JOB_ID
AND JOB_HISTORY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
AND year(END_DATE) < 1998
AND year(END_DATE) <> 1993;
#4-----------------------------------------------------------------------------------------------
select JOB_TITLE
from JOB_HISTORY
left join JOBS
on JOB_HISTORY.JOB_ID = JOBS.JOB_ID; 
#5-----------------------------------------------------------------------------------------------
select JOB_TITLE
from JOB_HISTORY
right join JOBS
on JOB_HISTORY.JOB_ID = JOBS.JOB_ID;
#6 PROF WAY--------------------------------------------------------------------------------------
select e.MANAGER_ID, m.LAST_NAME, e.EMPLOYEE_ID, e.LAST_NAME
from EMPLOYEES e, EMPLOYEES m
where e.MANAGER_ID = m.EMPLOYEE_ID
order by e.MANAGER_ID;
#7 MOE WAY---------------------------------------------------------------------------------------
select e.LAST_NAME AS 'EMPLOYEES', m.LAST_NAME AS 'MANAGER'
from EMPLOYEES AS e
left outer join EMPLOYEES AS m
on m.EMPLOYEE_ID = e.MANAGER_ID;
#------------------------------------------------------------------------------------------------
#worksheet5
#1-----------------------------------------------------------------------------------------------
select JOB_ID, JOB_TITLE
from JOBS
where JOB_ID 
IN ( select JOB_ID from JOB_HISTORY );#The brakets work first
#2-----------------------------------------------------------------------------------------------
select JOB_ID
from JOBS 
MINUS#Require extended library
select JOB_ID
from JOB_HISTORY;
#3-----------------------------------------------------------------------------------------------
select JOB_ID, JOB_TITLE
from JOBS
intersect#Require extended library
select JOB_ID
from JOB_HISTORY;#We can use the one of Q1 with not IN
#4-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, LAST_NAME, SALARY, DEPARTMENT_ID
from EMPLOYEES
where SALARY<(select AVG(SALARY) from EMPLOYEES where DEPARTMENT_ID = 60);
#5-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, LAST_NAME, SALARY, DEPARTMENT_ID
from EMPLOYEES
where DEPARTMENT_ID=60
AND SALARY <( select min(SALARY) from EMPLOYEES where DEPARTMENT_ID = 30 );
#------------------------------------------------------------------------------------------------
#worksheet6
#1-----------------------------------------------------------------------------------------------
select DEPARTMENT_NAME, CITY
from DEPARTMENTS
natural join (select l.LOCATION_ID, l.CITY, l.COUNTRY_ID
	from LOCATIONS l
	join COUNTRIES c
	on ( l.COUNTRY_ID = c.COUNTRY_ID )
	join REGIONS using ( REGION_ID )
	where REGION_NAME = 'Europe')d;
#2-----------------------------------------------------------------------------------------------
select l.LOCATION_ID, l.CITY, l.COUNTRY_ID
	from LOCATIONS l
	join COUNTRIES c
	on(l.COUNTRY_ID = c.COUNTRY_ID)
	join regions using ( REGION_ID )
	where REGION_NAME = 'Europe';
#3-----------------------------------------------------------------------------------------------
select MANAGER_ID, DEPARTMENT_ID, FIRST_NAME
from EMPLOYEES
where ( MANAGER_ID, DEPARTMENT_ID )
in (select MANAGER_ID, DEPARTMENT_ID from EMPLOYEES where FIRST_NAME = 'John')
and FIRST_NAME <> 'John';
#4-----------------------------------------------------------------------------------------------
select MANAGER_ID, DEPARTMENT_ID, FIRST_NAME
from EMPLOYEES
where MANAGER_ID
in ( select MANAGER_ID from EMPLOYEES where FIRST_NAME = 'John' )
and DEPARTMENT_ID
in ( select DEPARTMENT_ID from EMPLOYEES where FIRST_NAME = 'John' )
and FIRST_NAME <> 'John';
#5-----------------------------------------------------------------------------------------------
select EMPLOYEES.EMPLOYEE_ID, LAST_NAME, EMPLOYEES.JOB_ID
from EMPLOYEES
where ( select count(EMPLOYEE_ID) from JOB_HISTORY where EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) >=2;
#6-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, JOB_ID
from EMPLOYEES
union 
select EMPLOYEE_ID, JOB_ID
from JOB_HISTORY
order by EMPLOYEE_ID;
#7-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, JOB_ID, SALARY
from EMPLOYEES
union
select EMPLOYEE_ID, JOB_ID, 0
from JOB_HISTORY
order by EMPLOYEE_ID;
#8-----------------------------------------------------------------------------------------------
select EMPLOYEE_ID, JOB_ID, DEPARTMENT_NAME
from JOB_HISTORY, DEPARTMENTS
where JOB_HISTORY.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
union
select EMPLOYEE_ID, JOB_ID, DEPARTMENT_NAME
from EMPLOYEES, DEPARTMENTS
where EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
order by EMPLOYEE_ID;
#9-----------------------------------------------------------------------------------------------
select FIRST_NAME
from EMPLOYEES
where FIRST_NAME like '_o%';
#10-----------------------------------------------------------------------------------------------
select MANAGER_ID
from EMPLOYEES
where MANAGER_ID between 100 and 101
or MANAGER_ID = 201;