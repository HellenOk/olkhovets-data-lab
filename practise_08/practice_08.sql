-- Завдання 1
select country, count(id) as users_count
from `bigquery-public-data.thelook_ecommerce.users`
group by country
order by count(id) desc
limit 10;

-- Завдання 2
select 
  p.category, 
  count(oi.id) as items_sold, 
  round(sum(oi.sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
inner join `bigquery-public-data.thelook_ecommerce.products` as p
  on oi.product_id = p.id
group by p.category
order by revenue desc;

-- Завдання 3

select 
  status, 
  count(order_id) as orders_count
from `bigquery-public-data.thelook_ecommerce.orders`
where status in ('Complete', 'Shipped')
group by status;

-- Завдання 4

select 
  format_date('%Y-%m', date(created_at)) as month,
  count(id) as items_sold,
  round(avg(sale_price), 2) as avg_price
from `bigquery-public-data.thelook_ecommerce.order_items`
where extract(year from created_at) in (2024, 2025)
group by month
order by month asc;

-- Завдання 5

select 
  p.category, 
  round(sum(oi.sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
inner join `bigquery-public-data.thelook_ecommerce.products` as p
  on oi.product_id = p.id
group by p.category
having revenue > 100000
order by revenue desc;

-- Завдання 6
select 
  p.name as product_name,
  p.brand,
  count(oi.id) as times_sold,
  round(sum(oi.sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
inner join `bigquery-public-data.thelook_ecommerce.products` as p
  on oi.product_id = p.id
group by product_name, p.brand
order by revenue desc
limit 10;

-- Завдання 7

select 
  p.category,
  count(oi.id) as total_items,
  countif(oi.returned_at is not null) as returned_items,
  round((countif(oi.returned_at is not null) / count(oi.id)) * 100, 1) as return_rate_pct
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
inner join `bigquery-public-data.thelook_ecommerce.products` as p
  on oi.product_id = p.id
group by p.category
order by return_rate_pct desc;

-- Завдання 8

with unique_buyers as (
  select distinct
    p.category,
    u.id as user_id,
    u.age
  from `bigquery-public-data.thelook_ecommerce.order_items` as oi
  inner join `bigquery-public-data.thelook_ecommerce.products` as p
    on oi.product_id = p.id
  inner join `bigquery-public-data.thelook_ecommerce.users` as u
    on oi.user_id = u.id
)
select 
  category,
  count(user_id) as buyers,
  round(avg(age), 2) as avg_age
from unique_buyers
group by category
order by avg_age desc;

-- Завдання 9

select 
  format_date('%Y-%m', date(created_at)) as month,
  round(sum(sale_price), 2) as revenue,
  rank() over (order by sum(sale_price) desc) as revenue_rank
from `bigquery-public-data.thelook_ecommerce.order_items`
where extract(year from created_at) = 2025
group by month
order by revenue_rank asc;

-- Завдання 10

with monthly_revenue as (
  select 
    format_date('%Y-%m', date(created_at)) as month,
    round(sum(sale_price), 2) as revenue
  from `bigquery-public-data.thelook_ecommerce.order_items`
  where extract(year from created_at) = 2025
  group by month
)
select 
  month,
  revenue,
  lag(revenue) over (order by month) as prev_month_revenue,
  round(((revenue - lag(revenue) over (order by month)) / lag(revenue) over (order by month)) * 100, 1) as growth_pct
from monthly_revenue
order by month asc;

-- Завдання 11

select 
  p.category,
  p.name as product_name,
  round(sum(oi.sale_price), 2) as revenue,
  row_number() over (partition by p.category order by sum(oi.sale_price) desc) as rank_in_category
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
inner join `bigquery-public-data.thelook_ecommerce.products` as p
  on oi.product_id = p.id
group by p.category, product_name
qualify rank_in_category <= 3
order by p.category asc, rank_in_category asc;

