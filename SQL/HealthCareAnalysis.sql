CREATE TABLE pharmacy_sales
(
    sale_id CHAR(5) PRIMARY KEY,
    sale_date DATE,
    drug VARCHAR(30),
    category VARCHAR(20),
    region VARCHAR(20),
    sales_rep VARCHAR(20),
    units_sold INT,
    total_sales DECIMAL(10,2),
    cogs DECIMAL(10,2)
);
INSERT INTO pharmacy_sales VALUES
('S001','2025-01-01','Paracetamol','Painkiller','North','Yash',120,2400,1400),
('S002','2025-01-02','Paracetamol','Painkiller','North','Yash',150,3000,1800),
('S003','2025-01-03','Ibuprofen','Painkiller','South','Priya',100,2500,1500),
('S004','2025-01-04','Amoxicillin','Antibiotic','North','Rahul',90,4500,2500),
('S005','2025-01-05','Azithromycin','Antibiotic','West','Anita',110,5200,2900),
('S006','2025-01-06','Metformin','Diabetes','East','John',200,8000,5000),
('S007','2025-01-07','Insulin','Diabetes','East','John',170,9000,5600),
('S008','2025-01-08','Cetirizine','Allergy','South','Priya',140,2800,1600),
('S009','2025-01-09','Vitamin C','Supplement','West','Anita',210,4200,2300),
('S010','2025-01-10','Omeprazole','Gastric','North','Rahul',130,3900,2100),
('S011','2025-01-11','Paracetamol','Painkiller','North','Yash',180,3600,2100),
('S012','2025-01-12','Insulin','Diabetes','East','John',160,8500,5300);

CREATE TABLE drugs
(
    drug_id CHAR(4) PRIMARY KEY,
    drug_name VARCHAR(30),
    category VARCHAR(20),
    manufacturer VARCHAR(30),
    unit_price DECIMAL(10,2)
);
INSERT INTO drugs VALUES
('D001','Paracetamol','Painkiller','Cipla',20),
('D002','Ibuprofen','Painkiller','Sun Pharma',25),
('D003','Amoxicillin','Antibiotic','Mankind',50),
('D004','Azithromycin','Antibiotic','Pfizer',60),
('D005','Metformin','Diabetes','Dr. Reddy',40),
('D006','Insulin','Diabetes','Novo Nordisk',80),
('D007','Cetirizine','Allergy','Cipla',20),
('D008','Vitamin C','Supplement','Himalaya',15),
('D009','Omeprazole','Gastric','Sun Pharma',30);
Select * from drugs;

CREATE TABLE sales_rep
(
    rep_id CHAR(4) PRIMARY KEY,
    rep_name VARCHAR(20),
    region VARCHAR(20)
);
INSERT INTO sales_rep VALUES
('R001','Yash','North'),
('R002','Priya','South'),
('R003','Rahul','North'),
('R004','Anita','West'),
('R005','John','East');

CREATE TABLE pharmacy_sales_joins
(
    sale_id CHAR(5) PRIMARY KEY,
    sale_date DATE,
    drug_id CHAR(4),
    rep_id CHAR(4),
    units_sold INT,
    total_sales DECIMAL(10,2),
    cogs DECIMAL(10,2),

    FOREIGN KEY(drug_id) REFERENCES drugs(drug_id),
    FOREIGN KEY(rep_id) REFERENCES sales_rep(rep_id)
);
INSERT INTO pharmacy_sales_joins VALUES
('S001','2025-01-01','D001','R001',120,2400,1400),
('S002','2025-01-02','D001','R001',150,3000,1800),
('S003','2025-01-03','D002','R002',100,2500,1500),
('S004','2025-01-04','D003','R003',90,4500,2500),
('S005','2025-01-05','D004','R004',110,5200,2900),
('S006','2025-01-06','D005','R005',200,8000,5000),
('S007','2025-01-07','D006','R005',170,9000,5600),
('S008','2025-01-08','D007','R002',140,2800,1600),
('S009','2025-01-09','D008','R004',210,4200,2300),
('S010','2025-01-10','D009','R003',130,3900,2100),
('S011','2025-01-11','D001','R001',180,3600,2100),
('S012','2025-01-12','D006','R005',160,8500,5300);

#Assign a sequential number to each sale based on highest sales.
select *,row_number() over(order by total_sales desc) as 'Squence' from pharmacy_sales;

#Assign a row number to each drug sale within its category based on total sales.
select *,row_number() over(partition by category order by total_sales) as 'RN' from pharmacy_sales;

#Rank all drug sales based on total sales.
select drug,total_sales,rank() over(order by total_sales desc) from pharmacy_sales;

#Rank drugs within each category according to total sales.
select drug,total_sales,category, rank() over(partition by category order by total_sales desc) from pharmacy_sales;

#Display the top 3 highest-selling drug records.
select drug,units_sold, dense_rank() over(order by units_sold desc) from pharmacy_sales limit 3;

#Find the second highest-selling drug in each category.
with cte as (select drug,category,units_sold,dense_rank() over(partition by category order by units_sold desc) as 'Rank' from pharmacy_sales)
select * from cte where cte.Rank=2;

#Display every sale along with the company's total sales.
select *,sum(total_sales) over() from pharmacy_sales;

#Display every sale with the average sales of its category.
select *,avg(total_sales) over(partition by category) from pharmacy_sales;

#Show every drug sale along with the highest sale in its category.
select drug,category,total_sales,max(total_sales) over(partition by category) from pharmacy_sales;

#Show every sale along with the number of sales in its category.
select sale_id,category,count(total_sales) over(partition by category) from pharmacy_sales;

#Display cumulative average sales over time.
select sale_date,total_sales, avg(total_sales) over(order by sale_date rows between unbounded preceding and current row) from pharmacy_sales;

#Display previous day's sales amount.
select sale_date,total_sales, lag(total_sales) over(order by sale_date desc) from pharmacy_sales;

#Show the next transaction date for each drug.
select drug,sale_date, lead(sale_date) over(partition by drug order by sale_date) from pharmacy_sales;

#Display the highest sale in every category for each row.
select drug,category,first_value(total_sales) over(partition by category order by total_sales desc) from pharmacy_sales;
select drug,category,max(total_sales) over(partition by category) from pharmacy_sales;

#Display the most recent transaction date for each drug.
with cte as(select drug,max(sale_date) from pharmacy_sales group by drug)
Select * from cte;

#Display profit for every sale.
select sale_id,(total_sales-cogs) as 'profit' from pharmacy_sales;

#Rank drugs based on profit.
with cte as(Select drug,sum(total_sales-cogs) as'Profit' from pharmacy_sales group by drug)
Select *,rank() over(order by Profit desc) from cte;


-- CTE
#Display all sales where the profit (total_sales - cogs) is greater than ₹2000.
with profit1 as(Select *,total_sales-cogs as 'Profit' from pharmacy_sales)
select * from profit1 where Profit>2000;

#Display all drugs that generated a negative profit.
with Loss1 as(Select drug,total_sales - cogs as 'Loss' from pharmacy_sales)
select * from Loss1 where Loss<0;

#Find all transactions whose profit is above the average profit.
with Profit2 as(Select *,avg(total_sales-cogs) over() as 'Avg_Profit'  from pharmacy_sales)
select * from Profit2 where total_sales-cogs>Avg_Profit;

#Find the category that generated the highest total sales.
with T_Sales1 as(Select category,max(total_sales)as 'C_Sales' from pharmacy_sales group by category order by max(total_sales) desc)
select * from T_Sales1 limit 1;

#Find the drug with the highest total profit.
with T_Profit1 as(Select drug,max(total_sales-cogs)as 'D_Profit' from pharmacy_sales group by drug order by max(total_sales-cogs) desc)
select * from T_Profit1 limit 1;

#Display regions whose total profit is greater than the company's average regional profit.
with R_profit as(Select region,sum(total_sales-cogs)as 'Total_RProfit' from pharmacy_sales group by region),
	A_profit as(Select avg(Total_RProfit) as 'Avg_Profit' from R_Profit)
select T1.region,T1.Total_RProfit from R_profit as T1 join A_profit as T2 where T1.Total_RProfit>T2.Avg_Profit;

#Display sales where the profit of a transaction is greater than the average profit of its category.
with Sales as(select category,sum(total_sales-cogs) as 'Category_Profit' from pharmacy_sales group by category),
	avg_sales as(Select avg(Category_Profit) as 'Avg_sales' from Sales)
Select * from Sales as T1 join avg_sales as T2 where T1.Category_Profit<T2.Avg_sales;

#Display the highest-selling drug from each category.
with Drug_Sell as(Select drug,category,sum(units_sold)as 'Sells' from pharmacy_sales group by category,drug),
	C_Drug as(select category,max(Sells) as 'highest' from Drug_Sell group by category)
select T1.drug,T1.category,T1.Sells from Drug_Sell as T1 join C_Drug as T2
on T1.category=T2.category
and T1.Sells=T2.highest;

#Display each drug along with: Total Profit, Company's Total Profit, Percentage Contribution
with T_P as(Select drug,sum(total_sales-cogs) as 'Total_Profit' from pharmacy_sales group by drug),
	TP as(Select sum(Total_Profit) as 'Overall_Profit' from T_P)
Select T1.drug,T1.Total_Profit,T2.Overall_Profit,(T1.Total_Profit/T2.Overall_Profit)*100 as '%'
from T_P as T1 join TP as T2;

#Display every category with: Total Sales, Total Profit, Profit Margin %
with Cat_Sales as(Select category,sum(total_sales) as 'Cat_Total_Sales' from pharmacy_sales group by category),
	Cat_Profit as(Select category,sum(total_sales-cogs) as 'Cat_Total_Profit' from pharmacy_sales group by category)
Select T1.category,T1.Cat_Total_Sales,T2.Cat_Total_Profit,
	   (T2.Cat_Total_Profit/T1.Cat_Total_Sales)*100 from Cat_Sales as T1 inner join Cat_Profit as T2
       on T1.category=T2.category;
#OR
SELECT 
    category,
    SUM(total_sales) AS Cat_Total_Sales,
    SUM(total_sales - cogs) AS Cat_Total_Profit,
    ROUND((SUM(total_sales - cogs) * 100.0) / SUM(total_sales), 0) AS 'Profit_Margin_%'
FROM pharmacy_sales
GROUP BY category;

#Find drugs whose total profit is below the company's average drug profit.
with D_Profit as(select drug,sum(total_sales-cogs) as 'Total_Profit' from pharmacy_sales group by drug),
	D_AProfit as(select avg(Total_Profit) 'Avg_Profit' from D_Profit)
Select T1.drug,T1.Total_Profit,T2.Avg_Profit from D_Profit as T1 join D_AProfit as T2
where T1.Total_Profit<T2.Avg_Profit;

#Find sales representatives who generated above-average profit
#while selling more than two different drugs.
with SR as(Select sales_rep,count(sale_id) as 'No_of_sales',sum(total_sales-cogs) as 'Total_Profit' from pharmacy_sales group by sales_rep),
	Avg_P as(Select avg(Total_Profit) as 'Average_Profit' from SR)
select T1.sales_rep,T1.No_of_sales,T1.Total_Profit,T2.Average_Profit from SR as T1 join Avg_P as T2
where T1.Total_Profit>T2.Average_Profit
and T1.No_of_sales>2;

#Find the top 3 most profitable drugs, and for each, display:
#Drug, Total Sales, Total Profit, Profit Margin %, Number of Transactions
select
	drug,
    sum(total_sales) as 'Total Sales',
    sum(total_sales-cogs) as 'Total Profit',
    round(sum(total_sales)/sum(total_sales-cogs),2) as 'Profit Margin',
    count(sale_id) as 'No. of Transaction'
from pharmacy_sales 
group by drug
order by sum(total_sales-cogs) desc
limit 3;


-- JOINS
Select * from drugs;
Select * from sales_rep;
Select * from pharmacy_sales_joins;

#Display: Drug Name,Category,Sale Date,Units Sold
Select T1.drug_name,T1.Category,T2.sale_date,T2.units_sold from drugs as T1 inner join pharmacy_sales_joins as T2 on T1.drug_id=T2.drug_id;

#Display all drugs manufactured by Cipla that were sold.
Select distinct(T2.drug_name),T2.manufacturer from pharmacy_sales_joins as T1 inner join drugs as T2 
on T1.drug_id=T2.drug_id 
where T2.manufacturer='Cipla';

#Display:Rep Name,Region,Drug Name,Profit
select T1.rep_name,T1.region,T2.drug_name,sum(T3.total_sales-T3.cogs) as 'Profit'
from sales_rep as T1 inner join pharmacy_sales_joins as T3 on T1.rep_id=T3.rep_id
inner join drugs as T2 on T3.drug_id=T2.drug_id
group by T1.rep_name,T1.region,T2.drug_name;

#Display all representatives who sold Antibiotic drugs.
select  T1.rep_name,T2.category 
from sales_rep as T1 inner join pharmacy_sales_joins as T3 on T1.rep_id=T3.rep_id
inner join drugs as T2 on T3.drug_id=T2.drug_id
where T2.category='Antibiotic';

#Display representatives who sold more than one type of drug.
select T1.rep_name,count(distinct T2.drug_name)
from sales_rep as T1 inner join pharmacy_sales_joins as T3 on T1.rep_id=T3.rep_id
inner join drugs as T2 on T3.drug_id=T2.drug_id
group by T1.rep_name
having count(distinct T3.drug_id)>1;

#Display every pair of drugs manufactured by the same manufacturer.
Select T1.manufacturer,T1.drug_name,T2.drug_name from drugs as T1
inner join drugs as T2
on T1.manufacturer=T2.manufacturer
and T1.drug_name!=T2.drug_name;


#Generate a management report containing:
# Representative Name,Region,Drug Name,Manufacturer,Units Sold,Total Sales,Profit,Profit Margin (%)
#using joins across all three tables.
select T1.rep_name,T1.region,T2.drug_name,T2.manufacturer,sum(T3.units_sold),sum(T3.total_sales),
sum(T3.total_sales-T3.cogs) as 'Profit', ((sum(T3.total_sales-T3.cogs)*100)/sum(T3.total_sales)) as 'Profit Margin'
from sales_rep as T1 inner join pharmacy_sales_joins as T3 on T1.rep_id=T3.rep_id
inner join drugs as T2 on T2.drug_id=T3.drug_id;

select timestampdiff(year,'2025-01-01',now());
select year(now());
select extract(day from now());
select date_format(now(),'%y-%M-%D %m:%h:%p');


-- FUNCTION
#Display the first letter of every drug.
delimiter //
create function fl_drug(name varchar(20))
returns char(1)
deterministic
begin
	return left(name,1);
end //
delimiter ;

select fl_drug(drug_name) from drugs;

#Replace "Para" with "PCM" in drug names.
delimiter //
create function para_replace(name varchar(20))
returns varchar(20)
deterministic
begin
	 return replace(name,'Para','PCM');
end //
delimiter ;

select para_replace(drug_name) from drugs where drug_name like 'Para%';


#Display the absolute difference between sales and COGS.
delimiter //
create function abs_profit(tot_sales decimal, cogs decimal)
returns decimal
deterministic
begin
	return abs(tot_sales-cogs);
end //
delimiter ;

select abs_profit(total_sales,cogs) from pharmacy_sales_joins;


#Display sales made in the first week of January.
delimiter //
create function Sale_Jan(sale_date date)
returns varchar(3)
deterministic
begin
	if month(sale_date)=1 and day(sale_date)<=7 then
		return 'yes';
	else
		return 'no';
	end if;
end //
delimiter ;
select * from pharmacy_sales_joins where  Sale_Jan(sale_date)='yes';


#If profit is greater than ₹2500 display High Profit, otherwise Low Profit.
delimiter //
create function Profit_condt(tot_sale decimal,cogs decimal)
returns varchar(15)
deterministic
begin
	if (tot_sale-cogs)>2500 then
		return 'High Profit';
	else 
		return 'Low Profit';
	end if;
end //
delimiter ;
select total_sales-cogs as 'PRofit',Profit_condt(total_sales,cogs) from pharmacy_sales_joins;

#Display the highest sales for every category.
select category,max(total_sales) as 'Highest Sales' from pharmacy_sales group by category;


#Generate a report like
#Sale: S001 | Drug: Paracetamol | Profit: 1000
#using string functions.

delimiter //
create function report(SID char(4),Drug varchar(25),total_sales decimal,cogs decimal)
returns varchar(100)
deterministic
begin
	return concat('Sale: ',SID,' | ','Drug: ',Drug,' | ','Profit: ',total_sales-cogs);
end //
delimiter ;
Select report(sale_id,drug,total_sales,cogs) from pharmacy_sales;

-- Stored Procedure
#Display all sales between two dates
delimiter //
create procedure sales_range(start_date date,end_date date)
begin
	select sale_id,sale_date from pharmacy_sales where sale_date between start_date and end_date;
end //
delimiter ;
call sales_range('2025-01-03','2025-01-06');

#Display total profit of a region
delimiter //
create procedure profit_region(region varchar(20))
begin
	select sum(total_sales-cogs) from pharmacy_sales;
end //
delimiter ;
drop procedure in_out1;
call profit_region('West');

#Input: Drug, Output: Total Profit
delimiter //
create procedure in_out1(IN drug varchar(20),OUT Total_profit decimal)
begin
	select sum(total_sales-cogs) into Total_profit from pharmacy_sales_joins as T1
    inner join drugs as T2 on T1.drug_id=T2.drug_id where drug_name = drug;
end //
delimiter ;
call in_out1('Paracetamol',@Total_profit);
select @Total_profit;

#Insert a sale. If anything fails,rollback. Otherwise commit.
create table auto_ID(num int primary key unique auto_increment);
delimiter //
create procedure trans(drug_id varchar(20),rep_id varchar(20),units_sold decimal,total_sales decimal,cogs decimal)
begin
	declare n int;
    declare sale_id char(4);
	insert into auto_ID values(null);
    savepoint r1;
    set n=last_insert_id();
    case when n<10 then
			set sale_id=concat('S','0',n);
		when n<100 then
			set sale_id=concat('S',n);
	end case;
    savepoint r2;
    insert into pharmacy_sales(sale_id,drug,sales_rep,units_sold,total_sales,cogs) values (sale_id,drug_id,rep_id,units_sold,total_sales,cogs);
end //
delimiter ;

-- SUB-QUERY
select * from pharmacy_sales_joins;
select * from sales_rep;
select * from drugs;
#Display the sale having the maximum total sales.
select drug_id,units_sold from pharmacy_sales_joins where units_sold=(select max(units_sold) from pharmacy_sales_joins); 

#Display all drugs whose units sold are greater than the average units sold.
select drug_id,units_sold from pharmacy_sales_joins where units_sold>(Select avg(units_sold) from pharmacy_sales_joins);

#Display all sales made by representatives working in the North region.
select rep_name,region from sales_rep where region in (Select region from sales_rep where region='North');

#Display manufacturers whose drugs have been sold.
select manufacturer from drugs where exists (Select 1 from pharmacy_sales_joins as T1 where T1.drug_id=drugs.drug_id);

#Display the second highest total sales without using LIMIT.
select max(total_sales) from pharmacy_sales_joins where total_sales<(Select max(total_sales) from pharmacy_sales_joins);

#Display the manufacturer of the highest-selling drug.
select manufacturer from drugs where drug_id=(select drug_id from pharmacy_sales_joins group by drug_id order by sum(total_sales) desc limit 1);

#Display categories where every transaction generated a profit greater than ₹1,000.
select distinct category from drugs 
where category in(select category from drugs inner join pharmacy_sales_joins as T2 
					on drugs.drug_id=T2.drug_id group by category having sum(total_sales-cogs)>1000);
                    
#Generate a report displaying:
#Drug, Total Sales, Total Profit, Company Average Profit, Profit Status
#where: High → Profit > Company Average Profit
#Low → Otherwise
with drug_deatils as(SELECT 
        drug_id,
        SUM(total_sales) AS Total_Sales,
        SUM(total_sales - cogs) AS Total_Profit
    FROM pharmacy_sales_joins group by drug_id),
CAP AS (
    SELECT AVG(Total_Profit) AS Company_Average_Profit 
    FROM Drug_deatils
)
Select d.drug_id AS Drug,
    d.Total_Sales,
    d.Total_Profit,
    ROUND(c.Company_Average_Profit, 2) AS Company_Average_Profit,
    CASE when d.total_Profit>c.Company_Average_Profit then 'High'
		else 'Low'
	END as Profit_Sat
    from drug_deatils as d
    join CAP as c;
