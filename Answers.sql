-- Q1 How many customers are having an outlook.com email domain? 

select 
	count(*) 
from 
	customers
where 
	customer_email like '%outlook.com';

-- Q2 How many customers placed order in 2018?

select 
	count(distinct(customer_id)) 
from 
	orders
where 
	DATEPART(year, order_purchase_date)=2018;

-- Q3 How many customers placed order in Dec 2017?

select 
	count(distinct(customer_id)) 
from 
	orders
where 
	month(order_purchase_date)=12 
and 
	DATEPART(year, order_purchase_date)=2017;

-- Q4 Create a new column called ‘Week Period’ for every order purchase date.
--Week period is defined as the date of Sunday to date of Saturday of the week in which the purchase date falls into. 
--Ex. If the order purchase date is 11th May, it falls in the week 6th May to 12th May where 6th May is the Sunday of that week and 12th May is Saturday.

select 
	order_id, 
	order_purchase_date,
	dateadd(day,-datepart(weekday,order_purchase_date)-1,order_purchase_date),
	dateadd(day,(7-datepart(weekday,order_purchase_date)),order_purchase_date),
	format(dateadd(day,-datepart(weekday,order_purchase_date)-1,order_purchase_date),'dd-MMM')+' To '+
	format(dateadd(day,(7-datepart(weekday,order_purchase_date)),order_purchase_date),'dd-MMM') 
as week
from orders

-- Q5 How many orders were approved within 24 hours of the purchase date?

select 
	count(*)
from 
	orders
where 
	datediff(hour, order_purchase_date, order_approved_at)<=24;

-- Q6 How many customers have orders with an estimated delivery date falling on a weekday?

select 
	count(distinct(customer_id)) 
from 
	orders
where  
	datepart(weekday,order_estimated_delivery_date) between 2 and 6;

-- Q7 Write query to derive a new column called profitability_status from the table transactions.
--If profit column has +ve values, set profitability_status = 'Profit' else 'Loss' .

select *,
case
	when Profit<0 then 'Loss'
	else 'Profit'
	end
	as profitability_status
from transactions;
