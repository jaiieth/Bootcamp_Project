-- Restaurant Owners
-- 5 tables
-- 1x Fact, 4x Dimension
-- add FK
-- write SQL 3 queries to analyze data
-- 1x subquery using with

---------------------------------------------------------------
--INVOICE--
create table if not exists invoice(
  invoiceID int primary key not null unique,
  invoiceDate date,
  menuID int,
  quantity int,
  customerID int ,
  employeeID int,
  branchID int,
  foreign key (menuID) references 'menu'(menuID),
  foreign key (customerID) references 'customer'(customerID),
  foreign key (employeeID) references 'employee'(employeeID),
  foreign key (branchID) references 'branch'(branchID)
) ;
insert into invoice values
  (1,  '2022-05-30'  ,1  ,7  ,3  ,6  ,2),
  (2,  '2022-05-30'  ,2  ,6  ,3  ,6  ,2),
  (3,  '2022-05-31'  ,3  ,2  ,2  ,5  ,1),
  (4,  '2022-05-31'  ,1  ,1  ,2  ,5  ,1),
  (5,  '2022-06-03'  ,2  ,3  ,1  ,6  ,2),
  (6,  '2022-06-03'  ,2  ,2  ,1  ,6  ,2),
  (7,  '2022-06-03'  ,3  ,1  ,1  ,6  ,2),
  (8,  '2022-06-03'  ,3  ,9  ,2  ,5  ,1),
  (9,  '2022-06-03'  ,2  ,8  ,2  ,5  ,1),
  (10, '2022-06-03'  ,1  ,4  ,4  ,6  ,2),
  (11, '2022-06-03'  ,3  ,4  ,3  ,5  ,1);

---------------------------------------------------------------
--MENU--
create table if not exists menu(
  menuID int primary key not null unique,
  name nvarchar(50),
  price numeric(5,2)
);
insert into menu values
  (1,'Burger'   ,10),
  (2,'Fries'    ,4),
  (3,'Pizza'    ,12),
  (4,'Ice cream',4),
  (5,'Drinks'   ,3);

---------------------------------------------------------------
--CUSTOMER--
create table if not exists customer(
  customerID int primary key not null unique,
  firstname nvarchar(50),
  lastname nvarchar(50),
  age int,
  email nvarchar(100),
  phone nvarchar(24)
);
insert into customer values
  (1,'John',  'Cena',   35,'johnzebra@gmail.com',  '022-222-2222'),
  (2,'John',  'Lennon', 70,'j.lennon@gmail.com',   '023-444-5555'),
  (3,'Dwayne','Johnson',16,'therock@wwe.com',      '012-0122-0221'),
  (4,'Wayne', 'Beckham',19,'goatgoat@mutd.com',    '089-999-9999'),
  (5,'Papa',  'John',   24,'ceo@papajohnpizza.com','024-111-8558');

---------------------------------------------------------------
--EMPLOYEE--
create table if not exists employee(
  employeeID int primary key not null unique,
  firstname nvarchar(50),
  lastname nvarchar(50),
  title nvarchar(50),
  hiredate date,
  branchID int,
  foreign key (branchID) references 'branch'(branchID)
);
insert into employee values
  (1,'David',  'Copperfield',  'CEO',    '1900-05-05',1),
  (2,'Mary',   'Jane',         'Manager','2000-05-05',1),
  (3,'Bradly', 'Cooper',       'Chef',   '2001-05-05',2),
  (4,'Lady',   'Gaga',         'Chef',   '2003-05-05',2),
  (5,'Elon',   'Musk',         'Waiter', '2002-05-06',1),
  (6,'Harry',  'Potter',       'Waiter', '2003-05-06',2);

---------------------------------------------------------------
--BRANCH--
create table if not exists branch(
  branchID int primary key not null unique,
  country nvarchar(30),
  city nvarchar(100)
);
insert into branch values
  (1,'USA','New York'),
  (2,'Thailand','Bangkok');
---------------------------------------------------------------
--BRANCH_MENU--
create table if not exists branch_menu as
  select br.city , me.name as menu
from branch as br , menu as me
;
Delete from branch_menu
where city = 'Bangkok' and menu = 'Ice cream';
---------------------------------------------------------------
.mode markdown
.header on
---------------------------------------------------------------
---------------------------------------------------------------
--CREATE VIEW--
create view vieworder as
  select 
    invoiceID,
    invoicedate,
    me.name           as menu,
    me.price          as unit_price,
    quantity,
    cu.lastname       as customer_name,  
    em.firstname      as employee_name,
    br.city           as Branch
  from invoice as inv
    join menu     as me on inv.menuID = me.menuID
    join customer as cu on inv.customerID = cu.customerID
    join employee as em on inv.employeeID = em.employeeID
    join branch   as br on em.branchID = br.branchID;

--SUBQUERY USING WITH--
--BRANCH TOTAL SALE--
with withorder as(
  select
    branch,
    unit_price*quantity as total
  from vieworder)
  
select 
  branch,
  count(*)    as n_order,
  sum(total)  as total_sale
from withorder
group by branch
order by 3 desc;

---------------------------------------------------------------
--TOTAL SALE PER / MENU--
create view total_sale_menu as
  select
    menu,
    sum(quantity) as n_sale,
    sum(unit_price*quantity) as total_sale
  from vieworder
  group by menu;
  
select * from total_sale_menu
  order by total_sale desc;

---------------------------------------------------------------
--BEST SELLER MENU--
select 
  menu as best_seller,
  n_sale
from total_sale_menu
where n_sale = (select max(n_sale) from total_sale_menu);

---------------------------------------------------------------
--TOP SPENDING CUSTOMER--
select 
  customer_name,
  sum(unit_price*quantity) as total_spend
from vieworder
group by 1
order by 2 desc;
---------------------------------------------------------------
--AVERAGE AGE OF CUSTOMER ORDERING EACH MENU
select 
  menu,
  cast(avg(c.age) as int) as avgAge
  --avg(c.age) as
from vieworder as v
join customer as c on c.lastname = v.customer_name
group by menu ;




--###########################################################--
/*select * from invoice;
select * from menu;
select * from customer;
select * from employee;
select * from branch;
select * from branch_menu;
select * from vieworder
select * from vieworder;
select * from customer;*/
--###########################################################--