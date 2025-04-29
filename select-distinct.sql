select count( distinct country )from client;

select count(distinct(job_title)) from client;

select distinct job_title from client;

SELECT gender, COUNT(*) AS num_clients
FROM client
GROUP BY gender
ORDER BY num_clients DESC;

SELECT country, COUNT(DISTINCT gender) AS num_genders
FROM client
GROUP BY country
ORDER BY num_genders DESC limit 10;