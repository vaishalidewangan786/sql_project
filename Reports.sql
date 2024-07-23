
--Report 1 : Prepare a Purchase Year, Month wise report of Sales

-- Q1 In the year 2017, which purchase month recorded the highest sales?

select 
	year(orders.order_purchase_date)as purchase_year,
	month(orders.order_purchase_date)as purchase_month,
	sum(transactions.Sales) as total_sales
from orders
join transactions 
on  
	orders.order_id=transactions.order_id

group by
	year(orders.order_purchase_date),
	month(orders.order_purchase_date)
order by
	year(orders.order_purchase_date),
	total_sales desc
-- ans November

-- Q2 The total sales in the month of March 2018 is ________

select 
	year(orders.order_purchase_date)as purchase_year,
	month(orders.order_purchase_date)as purchase_month,
	sum(transactions.Sales) as total_sales
from orders
join transactions 
on  
	orders.order_id=transactions.order_id
group by
	year(orders.order_purchase_date),
	month(orders.order_purchase_date)
having 
	year(orders.order_purchase_date)=2018
and
	month(orders.order_purchase_date)=3

-- ans 205397.8