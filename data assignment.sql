select * from customer;
select * from orders ;
select * from shipping where customer_id = 153;

select * from customer a
left join  orders b using(customer_id)
left join shipping c using(customer_id)
where concat(a.first, ' ',a.last)='Janet Valdez';

#1. the total amount spent and the country for the Pending delivery status for each country.
select country,sum(amount) as total_amount_spent from customer c
inner join orders o on o.customer_id=c.customer_id
inner join shipping s on s.customer_id=c.customer_id
where status='pending'
group by country;

#2.the total number of transactions, total quantity sold, and total amount spent for each customer, along with the product details.

select concat(first, ' ',last) as name ,count(distinct order_id) as no_of_orders,count(item) quantity_sold,
sum(amount) as amt_spent,group_concat( distinct Item) item_names  from customer c
inner join orders o
on c.customer_id=o.customer_id
group by 1
order by 4 desc

#3.the maximum product purchased for each country.

with product_purchased as
(select item,country,count(item) items_purchased, 
row_number() over(partition by country order by count(item) desc,sum(amount) desc)as rank_no
from customer c
inner join orders o
on o.customer_id=c.customer_id
group by 1,2
)
select item,country from product_purchased
where rank_no=1

#4.the most purchased product based on the age category less than 30 and above 30.
select * from 
(select item as less_than_30
from orders o 
inner join customer c
on o.customer_id =c.customer_id
group by item
order by count(case when age<30 then item end) desc
limit 1) a
cross join
(select item as more_than_30
from orders o 
inner join customer c
on o.customer_id =c.customer_id
group by item
order by count(case when age>30 then item end) desc
limit 1) b


#5.the country that had minimum transactions and sales amount.
with minimum_transaction as
(select country,count(order_id) as transactions,sum(amount) as sales_amount,
dense_rank() over( order by count(order_id),sum(amount)) as min_trans
 from customer c
inner join orders o
on o.customer_id=c.customer_id
group by country
)
select country from minimum_transaction
where min_trans =1











