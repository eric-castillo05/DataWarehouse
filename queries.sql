-- 1 numero de clientes: 16000
select (count(*)) from client;

-- 2 numero de paises diferentes

select count( distinct country )from client;

-- 2.1 numero de clientes por pais
select country, count(*) as num_clients from client group by country order by num_clients desc;

-- 3 numero de trabajos diferentes
select count(distinct(job_title)) from client;

 
-- 4 trabajos diferentes
select distinct job_title from client;
  
-- 5 numero de clientes por genero
SELECT gender, COUNT(*) AS num_clients
FROM client
GROUP BY gender
ORDER BY num_clients DESC;

-- 5.1 cuantos generos hay por pais
SELECT country, COUNT(DISTINCT gender) AS num_genders
FROM client
GROUP BY country
ORDER BY num_genders DESC limit 10;

-- 5.2 cuantos generos hay por card
SELECT c.card, COUNT(DISTINCT cl.gender) AS num_genders
FROM card c
JOIN client cl ON c.id_client = cl.id_client
GROUP BY c.card
ORDER BY num_genders DESC;

-- ALTER TABLE sale_product ADD CONSTRAINT p_id_product_fk FOREIGN KEY (id_product) REFERENCES product(id_product)

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


-- 15
-- promedio de venta por año
-- puede tener relacion con #12
select to_char(date_sale, 'yyyy') as year, avg(sale_paid) as avg_sales from sale group by to_char(date_sale, 'yyyy');


-- 16
-- venta maxima por año, mes
-- puede tener relacion con #13
select to_char(date_sale, 'MM') as month, to_char(date_sale, 'yyyy') as year, max(sale_paid) as max_sale 
from sale 
group by to_char(date_sale, 'yyyy'), to_char(date_sale, 'MM');


-- 17
-- venta minima por año, mes
-- puede tener relacion con #14

select to_char(date_sale, 'MM') as month, to_char(date_sale, 'yyyy') as year, min(sale_paid) as min_sale 
from sale 
group by to_char(date_sale, 'yyyy'), to_char(date_sale, 'MM');


-- 18
-- venta promedio por año, mes
-- puede tener relacion con #15
select to_char(date_sale, 'MM') as month, to_char(date_sale, 'yyyy') as year, avg(sale_paid) as avg_sale 
from sale 
group by to_char(date_sale, 'yyyy'), to_char(date_sale, 'MM');



-- 19
-- venta maxima por dia
SELECT to_char(date_sale, 'DD') AS day, 
       to_char(date_sale, 'MM') AS month, 
       to_char(date_sale, 'YYYY') AS year, 
       MAX(sale_paid) AS max_sale 
FROM sale 
GROUP BY to_char(date_sale, 'DD'), 
         to_char(date_sale, 'MM'), 
         to_char(date_sale, 'YYYY');
-- 20
-- venta minima por dia
SELECT to_char(date_sale, 'DD') AS day, 
       to_char(date_sale, 'MM') AS month, 
       to_char(date_sale, 'YYYY') AS year, 
       MIN(sale_paid) AS min_sale 
FROM sale 
GROUP BY to_char(date_sale, 'DD'), 
         to_char(date_sale, 'MM'), 
         to_char(date_sale, 'YYYY');
   
     
-- 21
-- venta promedio por dia
SELECT to_char(date_sale, 'DD') AS day, 
       to_char(date_sale, 'MM') AS month, 
       to_char(date_sale, 'YYYY') AS year, 
       avg(sale_paid) AS avg_sale 
FROM sale 
GROUP BY to_char(date_sale, 'DD'), 
         to_char(date_sale, 'MM'), 
         to_char(date_sale, 'YYYY');
   
-- 22
-- numero de productos vendidos
 
SELECT SUM(articles) AS total_products_sold 
FROM sale;   

-- 25
-- promedio de articulos vendidos
select avg(articles) as avg_articles from sale;
   
-- 26
-- numero de productos vendidos
select (count(articles)) as products_sold from sale;
   
-- 27
-- numero de productos vendidos por año
select (count(articles)), to_char(date_sale, 'yyyy') as products_sold from sale group by to_char(date_sale, 'yyyy');
   
   
-- 28
-- total de dinero pagado por pais, y tarjeta
SELECT c.country, 
    cr.card, 
    SUM(s.sale_paid) AS total_paid 
FROM sale s 
JOIN card cr ON s.id_card = cr.id_card 
JOIN client c ON cr.id_client = c.id_client 
GROUP BY c.country, cr.card;

   
-- 29
-- total de dinero pagado por pais, tarjeta y genero
SELECT c.gender,
    c.country, 
    cr.card, 
    SUM(s.sale_paid) AS total_paid 
FROM sale s 
JOIN card cr ON s.id_card = cr.id_card 
JOIN client c ON cr.id_client = c.id_client 
GROUP BY c.country, cr.card, c.gender;
   
-- 30
-- total de dinero pagado por pais, tarjeta y trabajo
SELECT c.job_title,  c.country, 
    cr.card, 
    SUM(s.sale_paid) AS total_paid 
FROM sale s 
JOIN card cr ON s.id_card = cr.id_card 
JOIN client c ON cr.id_client = c.id_client 
GROUP BY c.country, cr.card, c.job_title;
   
   
-- 31
-- total de dinero pagado por año, pais, tarjeta y genero
SELECT to_char(s.date_sale, 'yyyy'),  c.country, 
    cr.card, 
    SUM(s.sale_paid) AS total_paid 
FROM sale s 
JOIN card cr ON s.id_card = cr.id_card 
JOIN client c ON cr.id_client = c.id_client 
GROUP BY c.country, cr.card, to_char(s.date_sale, 'yyyy');
   
   
-- 32  # apartir de aqui
-- total de dinero pagado por año,  pais, tarjeta y genero

   
-- 33
-- total de dinero pagado por año,  pais, tarjeta, genero, trabajo

   
-- 34
-- total de dinero pagado por año, mes, pais, tarjeta
 
   
-- 35
-- total de dinero pagado por año, mes,  pais, tarjeta, genero

   
-- 36
-- total de dinero pagado por año, mes, pais, tarjeta, genero, trabajo

   
   
--- general
-- 37
-- total de dinero pagado por año,  pais, tarjeta

   
-- 38
-- total de dinero pagado por año, pais, tarjeta y genero

    
-- 39
-- total de dinero pagado por año, pais, tarjeta, genero, trabajo