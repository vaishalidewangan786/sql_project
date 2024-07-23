-- project 

-- solution 1 with CTE


with 
	total_order as (
		select 
		c.customer_id,
		c.customer_name,
		datediff(day,min(o.order_purchase_date),max(o.order_purchase_date)) as length_of_stay_days,
		count(o.order_status)tot_order 
		from 
			orders o
		join 
			customers c 
		on
			c.customer_id = o.customer_id
		group by
			c.customer_id,c.customer_name
	), 
	total_return as(
		SELECT 
			c.customer_id, 
			c.customer_name,
			count(r.order_id) tot_return
		from 
			customers c
		join 
			orders o
		on 
			c.customer_id=o.customer_id
		 left join 
			returns r
		on 
			o.order_id=r.order_id
		group by
			c.customer_id, c.customer_name
	),
	total_sales as
		(
		select 
			o.customer_id,
			c.customer_name,
			sum(trans.sales)as order_value,
			round(sum(trans.quantity)/count(trans.quantity),0)as avg_basket_size
		from 
			orders o
		join 
			transactions trans
		on 
			trans.order_id = o.order_id
		join 
			customers c
		on 
			c.customer_id = o.customer_id
		group by 
			o.customer_id, customer_name
		)
select
	t_o.customer_name,
	t_o.tot_order,	
	t_r.tot_return,
	t_s.order_value,
	t_s.avg_basket_size,
	round(t_s.order_value/t_o.tot_order,0)as avg_basket_value,
	length_of_stay_days,
	length_of_stay_days/tot_order as order_purchase_frequency
from 
	total_order t_o
join 
	total_return t_r
on 
	t_o.customer_name =t_r.customer_name 
join 
	total_sales t_s
on 
	t_s.customer_id = t_o.customer_id

order by
	customer_name,
	t_o.customer_id
	


-- solution 2 with joins

select 
	c.customer_name,
	count(distinct(t.order_id)) as tot_orders,
	count(distinct(r.order_id)) as tot_returns,
	sum(sales) as order_value,
	floor(sum(Quantity)/ COUNT(distinct(t.order_id))) as avg_basket_size,
	format(round(sum(sales)/count(distinct(t.order_id)),2), 'c', 'en-US') as avg_basket_value,
	datediff(day, min(order_purchase_date), max(order_purchase_date)) as length_of_stay_days,
	datediff(day, min(order_purchase_date), max(order_purchase_date))/count(distinct(t.order_id)) as order_purchase_frequency
from 
	customers C
join 
	orders o
on 
	c.customer_id = o.customer_id
join 
	transactions t
on 
	o.order_id = t.order_id
left join 
	returns r
on 
	o.order_id = r.order_id
group by 
	c.customer_name,
	o.customer_id
order by
	c.customer_name,
	o.customer_id