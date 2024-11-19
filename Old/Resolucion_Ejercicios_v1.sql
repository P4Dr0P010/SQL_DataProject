--1. Crea el esquema de la BBDD.
--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
SELECT title AS film_title,
	rating
FROM film AS f
WHERE rating::text LIKE 'R%';

--3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
SELECT first_name
FROM actor AS a
WHERE a.actor_id BETWEEN 30 AND 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT title
FROM film AS f
WHERE original_language_id::text LIKE language_id::text;

--5. Ordena las películas por duración de forma ascendente.
SELECT title
FROM film AS f
ORDER BY length ASC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
SELECT first_name,
	last_name
FROM actor AS a
WHERE a.last_name ILIKE '%allen%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
SELECT rating,
	count(title) AS n_peliculas
FROM film AS f
GROUP BY rating;

--8. Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
SELECT title AS films,
	length,
	rating
FROM film AS f
WHERE f.rating::text LIKE 'PG-13'
OR length > 180
ORDER BY length DESC;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT variance(replacement_cost) AS variance
FROM film AS f;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT min(length) AS min_length,
	max(length) AS max_length
FROM film AS f;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT r.rental_date,
	p.amount
FROM rental AS r
INNER JOIN payment AS p
	ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC
LIMIT 1
OFFSET 2;

--12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
SELECT title AS films,
	length,
	rating
FROM film AS f
WHERE f.rating::text NOT LIKE 'NC-17' 
	AND 
	f.rating::text NOT LIKE 'G'
ORDER BY length DESC;

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating,
	avg(length) AS average_length
FROM film AS f
GROUP BY rating;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title AS film_title,
	length 
FROM film AS f
WHERE length > 180;

--15.¿Cuánto dinero ha generado en total la empresa?
SELECT sum(amount) AS total_amount
FROM payment AS p; 

--16.Muestra los 10 clientes con mayor valor de id.
SELECT rental_id 
FROM rental AS r 
ORDER BY rental_id DESC 
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
SELECT a.first_name,
	a.last_name,
	f.title 
FROM actor AS a
INNER JOIN film_actor AS fa 
	ON a.actor_id = fa.actor_id
INNER JOIN film AS f 
	ON fa.film_id = f.film_id
WHERE f.title ILIKE 'Egg Igby'
ORDER BY a.first_name ASC;

--18. Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title
FROM film AS f;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
SELECT f.title AS title,
	c.name AS category,
	f.length AS lenght
FROM film AS f
INNER JOIN film_category AS fc 
	ON f.film_id = fc.film_id 
INNER JOIN category AS c 
	ON fc.category_id = c.category_id 
WHERE f.length > 180 AND c.name ILIKE 'Comed%'
ORDER BY f.length;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c.name AS category,
	avg(f.length) AS avg_lenght
FROM film AS f
INNER JOIN film_category AS fc 
	ON f.film_id = fc.film_id 
INNER JOIN category AS c 
	ON fc.category_id = c.category_id 
GROUP BY c.name
HAVING avg(length) > 110
ORDER BY avg_lenght DESC;

--21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT avg(return_date - rental_date)
FROM rental AS r 

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT concat(first_name, ' ', last_name) AS Name
FROM actor AS a 

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
SELECT count(rental_id) AS rentals, 
	concat(EXTRACT(DAY FROM rental_date),'/',
		EXTRACT(MONTH FROM rental_date),'/',
		EXTRACT(YEAR FROM rental_date))
FROM rental AS r 
GROUP BY rental_date 
ORDER BY rentals DESC;

--24. Encuentra las películas con una duración superior al promedio.
SELECT title, 
	length
FROM film AS f
WHERE length > (
	SELECT avg(length)
	FROM film AS f
)
ORDER BY length DESC;

--25. Averigua el número de alquileres registrados por mes.
SELECT concat(
	EXTRACT(MONTH FROM rental_date),
	'/',
	EXTRACT(YEAR FROM rental_date)) AS rental_month,
	count(rental_id) AS rentals
FROM rental AS r 
GROUP BY rental_month
ORDER BY rental_month DESC;

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
SELECT avg(amount) AS promedio,
	stddev(amount) AS desviacion_estandar,
	variance(amount) AS varianza
FROM payment AS p;

--27. ¿Qué películas se alquilan por encima del precio medio?
SELECT title,
	rental_rate 
FROM film AS f 
WHERE rental_rate > (
	SELECT avg(rental_rate) 
	FROM film AS f
);

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
WITH sub_actors	AS (
	SELECT actor_id,
		count(film_id) AS n_films
	FROM film_actor AS fa
	GROUP BY actor_id
)
SELECT actor_id,
	n_films
FROM sub_actors
WHERE n_films > 40;

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
SELECT film_id, 
	count(inventory_id) AS items
FROM inventory AS i 
GROUP BY film_id; 

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT actor_id, 
	count(film_id) AS n_films
FROM film_actor AS fa 
GROUP BY actor_id 
ORDER BY n_films DESC;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT title,
	concat(a.first_name, ' ', a.last_name) AS actor
FROM film AS f 
LEFT JOIN film_actor AS fa 
	ON fa.film_id = f.film_id
LEFT JOIN actor AS a 
	ON a.actor_id = fa.actor_id 
ORDER BY actor;

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT concat(a.first_name, ' ', a.last_name) AS actor,
	f.title 
FROM film_actor AS fa 
LEFT JOIN film AS f
	ON f.film_id = fa.film_id
LEFT JOIN actor AS a 
	ON a.actor_id = fa.actor_id
ORDER BY actor;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT f.title AS film,
	r.customer_id AS customer,
	r.rental_date AS rental_date,
	r.return_date AS return_date,
	p.amount AS amount
FROM film AS f
INNER JOIN inventory AS i 
	ON i.film_id = f.film_id 
INNER JOIN rental AS r
	ON r.inventory_id = i.inventory_id 
INNER JOIN payment AS p 
	ON p.customer_id = r.customer_id 
ORDER BY f.title;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT customer_id,
	sum(amount) AS total_paid
FROM payment AS p 
GROUP BY customer_id 
ORDER BY total_paid DESC
LIMIT 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT first_name,
	last_name 
FROM actor AS a 
WHERE first_name ILIKE 'JoHnny%'

--36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
ALTER TABLE actor
RENAME COLUMN first_name TO nombre;
ALTER TABLE actor
RENAME COLUMN last_name TO apellido;

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MAX(actor_id) AS high_id,
	MIN(actor_id) AS low_id
FROM actor AS a;

--38. Cuenta cuántos actores hay en la tabla “actorˮ.
SELECT count(actor_id) AS n_actor
FROM actor AS a;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
SELECT first_name,
	last_name
FROM actor AS a 
ORDER BY last_name ASC;

--40. Selecciona las primeras 5 películas de la tabla “filmˮ.
SELECT title 
FROM film AS f 
LIMIT 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
SELECT first_name,
	count(first_name) AS n_repetitions
FROM actor AS a
GROUP BY first_name 
ORDER BY n_repetitions DESC
LIMIT 1;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
SELECT c.first_name,
	c.last_name,
	r.rental_date 
FROM rental AS r
INNER JOIN customer AS c 
	ON c.customer_id = r.customer_id
ORDER BY r.rental_date DESC;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
SELECT c.first_name,
	c.last_name,
	f.title AS film_title
FROM customer AS c
LEFT JOIN rental AS r 
	ON c.customer_id = r.customer_id
INNER JOIN inventory AS i 
	ON i.inventory_id = r.inventory_id 
INNER JOIN film AS f 
	ON f.film_id = i.inventory_id 
ORDER BY c.first_name DESC;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT *
FROM film AS f
LEFT JOIN film_category AS fc
	ON fc.film_id = f.film_id 
CROSS JOIN category AS c;

Un CROSS JOIN entre estas tablas genera una combinación cartesiana muy extensa y no genera ningun valor ya que resulta en un conjunto de datos igual al producto del número de filas de las tablas film_category y category, otorgando todas las categorias a todas las peliculas y desvirtuando la catergoria real a la que pertenece la pelicula.

--45.Encuentra los actores que han participado en películas de la categoría 'Action'.
SELECT a.first_name,
	a.last_name,
	f.title
FROM film AS f 
LEFT JOIN film_category AS fc 
	ON f.film_id = fc.film_id 
LEFT JOIN category AS c
	ON c.category_id = fc.category_id
LEFT JOIN film_actor AS fa 
	ON fa.film_id = f.film_id 
LEFT JOIN actor AS a 
	ON a.actor_id = fa.actor_id 
WHERE c.name = 'Action'
ORDER BY a.first_name; 

--46. Encuentra todos los actores que no han participado en películas.
SELECT first_name,
	last_name,
	fa.film_id
FROM actor AS a 
LEFT JOIN film_actor AS fa 
	ON fa.actor_id = NULL;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
SELECT a.first_name, 
	count(fa.film_id) AS n_films
FROM film_actor AS fa
INNER JOIN actor AS a 
	ON a.actor_id = fa.actor_id 
GROUP BY a.first_name

--48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS 
	SELECT a.first_name, 
		count(fa.film_id) AS n_films
	FROM film_actor AS fa
	INNER JOIN actor AS a 
		ON a.actor_id = fa.actor_id
	GROUP BY a.first_name

--49. Calcula el número total de alquileres realizados por cada cliente.
SELECT customer_id AS customer,
	count(rental_id) AS n_rentals
FROM payment AS p
GROUP BY customer_id
ORDER BY n_rentals DESC;

--50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT c.name AS cat_name,
	sum(f.length) AS total_lenght
FROM film AS f 
LEFT JOIN film_category AS fc 
	ON f.film_id = fc.film_id 
LEFT JOIN category AS c
	ON c.category_id = fc.category_id
WHERE c.name = 'Action'
GROUP BY c.name; 

--51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
WITH cliente_rentas_temporal AS (
		SELECT customer_id AS customer,
			count(rental_id) AS n_rentals
		FROM payment AS p
		GROUP BY customer_id
		)
	SELECT *
	FROM cliente_rentas_temporal
	ORDER BY customer ASC;

--52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
WITH peliculas_alquiladas AS (
		SELECT f.title,
			count(r.rental_date) AS n_rentals
		FROM film AS f 
		INNER JOIN inventory AS i 
			ON i.film_id = f.film_id 
		INNER JOIN rental AS r 
			ON r.inventory_id = i.inventory_id
		GROUP BY f.title
		)
	SELECT *
	FROM peliculas_alquiladas
	WHERE n_rentals >= 10;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película
SELECT concat(c.first_name, ' ', c.last_name) AS complete_name,
	f.title,
	r.return_date 
FROM rental AS r 
	LEFT JOIN customer AS c 
		ON c.customer_id = r.customer_id
		LEFT JOIN inventory AS i 
			ON i.inventory_id = r.inventory_id 
			LEFT JOIN film AS f 
				ON f.film_id = i.film_id 
WHERE c.first_name ILIKE 'Tammy' 
	AND c.last_name ILIKE 'Sanders' 
		AND r.return_date IS NULL
ORDER BY f.title ASC;

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.
SELECT f_name AS first_name, 
FROM (
	SELECT DISTINCT a.actor_id AS a_id, 
		a.first_name AS f_name, 
		a.last_name AS l_name,
		c.name AS cat_name
	FROM actor AS a
	LEFT JOIN film_actor AS fa 
		ON a.actor_id = fa.actor_id 
	LEFT JOIN film_category AS fc 
		ON fc.film_id = fa.film_id 
	LEFT JOIN category AS c
		ON c.category_id = fc.category_id
	) 
	AS actors
WHERE cat_name = 'Sci-Fi'
ORDER BY l_name; 

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT DISTINCT foo.complete_name,
	foo.first_name,
	foo.last_name
FROM film AS f2
	INNER JOIN inventory AS i2 
		ON i2.film_id = f2.film_id
		INNER JOIN rental AS r2 
			ON r2.inventory_id = i2.inventory_id
			INNER JOIN film_actor AS fa 
				ON fa.film_id = f2.film_id 
				INNER JOIN (	
						SELECT DISTINCT aa.actor_id, 
							aa.first_name, 
							aa.last_name,
							concat(aa.first_name, ' ', aa.last_name) AS complete_name
						FROM actor AS aa
						ORDER BY aa.actor_id
						) AS foo
					ON foo.actor_id = fa.actor_id 
WHERE r2.rental_date > (
	SELECT min(rental_date)
	FROM inventory AS i
		LEFT JOIN rental AS r 
			ON i.inventory_id = r.inventory_id
	WHERE i.film_id = (
		SELECT film_id
		FROM film AS f
		WHERE title ILIKE 'Spartacus Cheaper'
	)
)
ORDER BY foo.last_name; 

--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.
/*Creación de tabla temporal de actores que 
han actuado en al menos una pelicula de la categoria 'Music'*/

CREATE TEMPORARY TABLE music_actors AS 
    (
	SELECT fa.actor_id AS ma_actor_id
	FROM film_actor AS fa
	LEFT JOIN actor AS a 
		ON a.actor_id = fa.actor_id 
	LEFT JOIN film_category AS fc 
		ON fc.film_id = fa.film_id 
	INNER JOIN category AS c 
		ON c.category_id = fc.category_id 
	WHERE c.name = 'Music'
    );

/*Extracción de los actores que no estan en la tabla temporal*/
SELECT concat(a.first_name, ' ', a.last_name),
FROM actor AS a
LEFT JOIN music_actors AS ma
	ON a.actor_id = ma.actor_id
WHERE ma.actor_id IS NULL

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
SELECT f.title, 
	EXTRACT(DAY FROM(r.return_date - r.rental_date)) AS rental_days 
FROM rental AS r 
INNER JOIN inventory AS i 
	ON i.inventory_id = r.inventory_id 
INNER JOIN film AS f 
	ON i.film_id = f.film_id
WHERE EXTRACT(DAY FROM r.return_date - r.rental_date) > 8;

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.
SELECT f.title, fc2.name
	(
	SELECT fc.film_id, c.name
	FROM film_category AS fc  
		LEFT JOIN category AS c
			ON c.category_id = fc.category_id
	WHERE c.name ILIKE 'Animation'
	)
INNER JOIN film AS f 
	ON f.film_id = fc2.film_id

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.
SELECT title
FROM film AS f 
WHERE length = (
	SELECT length
	FROM film AS f 
	WHERE title ILIKE 'Dancing Fever'
	)
ORDER BY title;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c.customer_id,
	c.first_name, 
	c.last_name,	
	count(DISTINCT concat(i.film_id, '_', c.customer_id)) AS "film_rentals"
FROM rental AS r
LEFT JOIN customer AS c 
	ON r.customer_id =c.customer_id 
LEFT JOIN inventory AS i  
	ON i.inventory_id = r.inventory_id 
GROUP BY c.customer_id
HAVING count(DISTINCT concat(i.film_id, '_', c.customer_id)) > 7
ORDER BY c.last_name ASC;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c.name, 
	count(r.rental_date) AS n_rentals
FROM rental AS r 
INNER JOIN inventory AS i 
	ON i.inventory_id = r.inventory_id 
INNER JOIN film AS f 
	ON i.film_id = f.film_id
LEFT JOIN film_category AS fc 
	ON f.film_id = fc.film_id 
LEFT JOIN category AS c 
	ON c.category_id = fc.category_id 
GROUP BY c.name 
ORDER BY n_rentals DESC;

--62. Encuentra el número de películas por categoría estrenadas en 2006.
    --No haria falta aplicar el filtro WHERE ya que todas las peliculas tienen como release_year 2006

SELECT c.name,
	count(f.film_id)
FROM film_category AS fc 
INNER JOIN category AS c 
	ON c.category_id = fc.category_id
	INNER JOIN film AS f 
		ON fc.film_id = f.film_id 
WHERE f.release_year = '2006'
GROUP BY c.name;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT s.first_name,
	s.last_name, 
	s2.store_id 
FROM staff AS s 
CROSS JOIN store AS s2;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id,
	c.first_name,
	c.last_name,
	count(inventory_id) n_rentals
FROM rental AS r 
INNER JOIN customer AS c 
	ON c.customer_id = r.customer_id 
GROUP BY c.customer_id
ORDER BY n_rentals DESC;

