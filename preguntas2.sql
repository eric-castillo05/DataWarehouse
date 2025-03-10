-- 7 numero de ventas por genero
select c.gender, count(s.id_sale) as total_sales
from client c
join card ca on c.id_client = ca.id_client
join sale s on ca.id_card = s.id_card
group by c.gender;

-- 8 numero de ventas por pais
select c.country, count(s.id_sale) as total_sales
from client c
join card ca on c.id_client = ca.id_client
join sale s  on ca.id_card = s.id_card
group by c.country;

-- 9 numero de ventas por tarjeta
select c.id_card, count(s.id_sale) as total_sales
from card c
join sale s on c.id_card = s.id_card group by c.id_card;

-- 9.1 numero de ventas por trabajo
select c.job_title, count(s.id_sale) as total_sales
from client c
join card ca on c.id_client = ca.id_client
join sale s on s.id_card = ca.id_card
group by c.job_title;

-- 10 venta maxima por cliente
select c.id_client, max(s.sale_paid) as max_sale
from client c
join card ca on c.id_client = ca.id_client
join sale s on s.id_card = ca.id_card
group by c.id_client;

-- 11 venta minima por cliente
select c.id_client, min(s.sale_paid) as min_sale
from client c
join card ca on c.id_client = ca.id_client
join sale s on s.id_card = ca.id_card
group by c.id_client;

-- 12 promedio de venta por cliente
select c.id_client, avg(s.sale_paid) as avg_sale
from client c
join card ca on c.id_client = ca.id_client
join sale s on s.id_card = ca.id_card
group by c.id_client

-- 13 venta maxima por año
select to_char(date_sale, 'yyyy') as year, max(sale_paid) as max_sale
from sale group by to_char(date_sale, 'yyyy');

-- 14 venta minima por año
select to_char(date_sale, 'yyyy') as year, min(sale_paid) as min_sale
from sale group by to_char(date_sale, 'yyyy');