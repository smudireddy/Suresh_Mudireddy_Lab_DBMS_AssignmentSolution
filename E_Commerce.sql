create database E_Commerce;
use E_Commerce;

create table if not exists supplier(supp_id int primary key, 
	supp_name varchar(50) not null, 
	supp_city varchar(50) not null, 
	supp_phone varchar(50) not null, 
	constraint chk_phone check(supp_phone not like '%[^0-9]%'));
desc supplier;

create table if not exists customer(cus_id int primary key, 
	cus_name varchar(20) not null, 
	cus_phone varchar(10) not null, 
    cus_city varchar(30) not null, 
    cus_gender char, 
    constraint chk_cus_phone check(cus_phone not like '%[^0-9]%'),
    check(cus_gender in ('M','F','T')));

desc customer;

create table if not exists category(cat_id int primary key,
	cat_name varchar(20) not null);

desc category;

create table if not exists product(prod_id int primary key,
	pro_name varchar(20) not null default 'Dummy', 
	pro_desc varchar(60), 
	cat_id int,
	foreign key(cat_id) references category(cat_id));

desc product;

create table if not exists supplier_pricing(pricing_id int primary key, 
	pro_id int, 
    supp_id int, 
    supp_price int default 0,
    foreign key(pro_id) references product(prod_id),
    foreign key(supp_id) references supplier(supp_id));

desc supplier_pricing;

create table if not exists orders(ord_id int primary key,
	ord_amount int not null,
    ord_date date not null,
    cus_id int,
    pricing_id int,
    foreign key(cus_id) references customer(cus_id),
    foreign key(pricing_id) references supplier_pricing(pricing_id));
 
 desc orders;
 
 create table if not exists rating(rat_id int primary key,
	ord_id int,
    rat_ratstars int not null,
    foreign key(ord_id) references orders(ord_id));
desc rating;

-- supplier
insert into supplier values(1,'Rajesh Retails', 'Delhi', '1234567890');
insert into supplier values(2,'Appario Ltd.','Mumbai','2589631470');
insert into supplier values(3,'Knome products','Banglore','9785462315');
insert into supplier values(4,'Bansal Retails','Kochi','8975463285');
insert into supplier values(5,'Mittal Ltd.','Lucknow','7898456532');

-- customer
insert into customer(cus_id,cus_name,cus_phone,cus_city,cus_gender) values
	(1,'AAKASH','9999999999','DELHI','M'),	
	(2,'AMAN','9785463215','NOIDA','M'),
	(3,'NEHA','9999999999','MUMBAI','F'),
	(4,'MEGHA','9994562399','KOLKATA','F'),
	(5,'PULKIT','7895999999','LUCKNOW','M');

-- Category Table
insert into category(cat_id, cat_name) values
	(1,'BOOKS'),
	(2,'GAMES'),
	(3,'GROCERIES'),
	(4,'ELECTRONICS'),
	(5,'CLOTHES');

-- Product Table
insert into product(prod_id, pro_name, pro_desc, cat_id) values
	(1,'GTAV','Windows 7 and above with i5 processor and 8GB RAM',2),
    (2,'TSHIRT','SIZE-L with Black, Blue and White variations',5),
    (3,'ROG LAPTOP','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),
    (4,'OATS','Highly Nutritious from Nestle',3),
    (5,'HARRY POTTER','Best Collection of all time by J.K Rowling',1),
    (6,'MILK','1L Toned MIlk',3),
    (7,'Boat Earphones','1.5Meter long Dolby Atmos',4),
    (8,'Jeans','Stretchable Denim Jeans with various sizes and color',5),
    (9,'Project IGI','compatible with windows 7 and above',2),
    (10,'Hoodie','Black GUCCI for 13 yrs and above',5),
    (11,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),
    (12,'Train Your Brain','By Shireen Stephen',1);
	
-- Supplier_pricing Table
   insert into supplier_pricing(pricing_id, pro_id, supp_id, supp_price) values
   (1, 1,2,1500),
   (2, 3,5,30000),
   (3, 5,1,3000),
   (4, 2,3,2500),
   (5, 4,1,1000);
   
-- Order Table
insert into orders(ord_id, ord_amount, ord_date, cus_id, pricing_id) values
	(101, 1500, '2021-10-06',2,1),
	(102, 1000, '2021-10-12',3,5),
	(103, 30000, '2021-09-16',5,2),
    (104, 1500, '2021-10-05',1,1),
	(105, 3000, '2021-08-16',4,3),
	-- (106, 1450, '2021-08-18',1,9),
	-- (107, 789, '2021-09-01',3,7),
	-- (108, 780, '2021-09-07',5,6),
	-- (109, 3000, '2021-00-10',5,3),
	(110, 2500, '2021-09-10',2,4),
	(111, 1000, '2021-09-15',4,5),
	-- (112, 789, '2021-09-16',4,7),
	-- (113, 31000, '2021-09-16',1,8),
	(114, 1000, '2021-09-16',3,5),
	(115, 3000, '2021-09-16',5,3)
	-- ,(116, 99, '2021-09-17',2,14)
    ;
    
select * from orders;

-- Rating table
insert into rating(rat_id, ord_id, rat_ratstars) values
	(1,101,4),
	(2,102,3),
	(3,103,1),
	(4,104,2),
	(5,105,4),
	-- (6,106,3),
	-- (7,107,4),
	-- (8,108,4),
	-- (9,109,3),
	(10,110,5),
	(11,111,3)
	-- ,
    -- (12,112,4),
    -- (13,113,2)
	,
	(14,114,1),
	(15,115,1)
	-- ,
	-- (16, 116, 0)
	;
   
   -- -------------------------------------------------
			-- Assignment Queries ------
   -- -------------------------------------------------         
   
   -- 3) Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
    select c.cus_gender as 'Customer Gender', count(c.cus_id) as 'No of customers with order > 3000' from customer c
    where c.cus_id in (select o.cus_id from orders o group by o.cus_id having SUM(o.ord_amount) > 3000) group by c.cus_gender; 

    -- 4) Display all the orders along with product name ordered by a customer having Customer_Id=2
    select o.ord_id,o.ord_amount, o.ord_date, p.pro_name from orders o 
		inner join supplier_pricing sp on(o.pricing_id = sp.pricing_id) and o.cus_id = 2
		inner join product p on(sp.pro_id = p.prod_id);
        
	-- 5) Display the Supplier details who can supply more than one product.
    select * from supplier s where s.supp_id in (select sp.supp_id from supplier_pricing sp group by sp.supp_id having count(sp.pro_id) > 1);
    
    -- 6) Find the least expensive product from each category and print the table with category id, name, product name and price of the product
        
        select p.cat_id 'Category ID', ca.cat_name 'Category Name', p.pro_name 'Product name', spp.Product_Price  from product p 
		inner join (
            select sp.pro_id, MIN(sp.supp_price) as 'Product_Price' from supplier_pricing sp group by sp.pro_id
        ) as spp on (p.prod_id = spp.pro_id)
		inner join (
           select cat_id from product group by cat_id
        ) as pd on (pd.cat_id = p.cat_id)
        inner join category ca on(ca.cat_id = p.cat_id);
        
	-- 7) Display the Id and Name of the Product ordered after “2021-10-05”.
     select p.prod_id 'Product_ID', p.pro_name 'Product_Name' from product p where p.prod_id in (
        select sp.pro_id from supplier_pricing sp inner join orders o on (o.pricing_id = sp.pricing_id) and o.ord_date > '2021-10-05'
     );
     
     -- 8) Display customer name and gender whose names start or end with character 'A'.
      select cus_name 'Customer Name', cus_gender from customer where cus_name like 'A%' or cus_name like '%A';
      
 	/* 9) Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
    For Type_of_Service, 
    If rating =5, print “Excellent Service”,
    If rating >4 print “Good Service”, 
    If rating >2 print “Average Service” else print “Poor Service”.
    */
    
    call DisplaySupplierRatingsAndTypeOfService();
    
    
     
     
        
    
        
    
   
	
    













                

