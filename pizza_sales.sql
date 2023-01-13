/* This dataset is from a fictitious pizza place, 
including the date and time of each order and the pizzas served, with additional details 
on the type, size, quantity, price, and ingredients. */


use pizza_sales;

--- joining all the tables 

create TEMPORARY  table master_data as (
select date,time,a.order_id, b.order_details_id,b.pizza_id, quantity, c.pizza_type_id,size,price,name,category,ingredients 
from orders a
join order_details b
on a.order_id =  b.order_id 
join pizzas c
on b.pizza_id = c.pizza_id
join pizza_types d 
on c.pizza_type_id = d.pizza_type_id
);

-- number of pizza in each category  (number of combinations in the menu) 

select distinct category , count(name) from pizza_types
group by 1;

--- number of pizaa by category and size 
select distinct category , size,  count(pizza_id) from pizza_types a
join pizzas b
on a.pizza_type_id = b.pizza_type_id
group by 1,2

-- qtys of pizza sold by category and size 
with total_sales as (
select category, size , sum(quantity) as total_qty_sold, rank() over(order by sum(quantity) desc) as pizza_rank
from pizza_types a
join pizzas b
on a.pizza_type_id = b.pizza_type_id
join order_details c
on b.pizza_id = c.pizza_id
join orders d
on c.order_id = d.order_id
group by 1,2) 
select category, size,total_qty_sold from total_sales
where pizza_rank = 1;

----- *** supreme l,m,s should be changed *** --- 


-- top selling pizza 
select pizza_id, sum(quantity) as quantity  from order_details
group by 1
order by quantity desc;

---- average price of orders weekdays and weekends



-- top selling pizza each month

with total_sales as (
select month(date) as month , pizza_id , sum(quantity) as total_sales
from orders a 
join order_details b
on a.order_id = b.order_id
group by 1,2) ,
ranked_sale as (
select month,pizza_id, total_sales, rank() over(partition by month order by total_sales desc) as qty_ranked
from total_sales )
select month, pizza_id, total_sales from ranked_sale
where qty_ranked = 1

-- result:- big meat small is the best seller

--- top selling pizza in different category
with total_sales as (
select size , b.pizza_id , sum(quantity) as total_qty_sold, rank() over( partition by size order by sum(quantity) desc) as pizza_rank
from pizzas a
join order_details b
on a.pizza_id = b.pizza_id
join orders c
on b.order_id = c.order_id
group by 1,2) 
select size,pizza_id,total_qty_sold from total_sales
where pizza_rank = 1;
/*
L	thai_ckn_l	1410	1
M	classic_dlx_m	1181	1
S	big_meat_s	1914	1
XL	the_greek_xl	552	1
XXL	the_greek_xxl	28	1  */

--- ***small pizza size are sold more often*****-----

-- top selling pizza in all categories 
with total_sales as (
select a.category , b.pizza_id , sum(quantity) as total_qty_sold, rank() over( partition by size order by sum(quantity) desc) as pizza_rank
from pizza_types a
join pizzas b
on a.pizza_type_id = b.pizza_type_id
join order_details c
on b.pizza_id = c.pizza_id
group by 1,2) 
select category ,pizza_id,total_qty_sold from total_sales
where pizza_rank = 1;

/*
Chicken	thai_ckn_l	1410
Classic	classic_dlx_m	1181
Classic	big_meat_s	1914
Classic	the_greek_xl	552
Classic	the_greek_xxl	28 */




-- monthly sales of the pizzas



-- mom sales 



-- number of pizza in chicken , beef, veg category


-- percentage of order monhtly accompined by side orders 



-- 












