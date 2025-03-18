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
 
select (count(articles)) as products_sold from sale; 

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