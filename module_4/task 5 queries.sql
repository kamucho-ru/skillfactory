-- Задание 5.1
-- 1. Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?

SELECT count(*)
FROM dst_project.flights
WHERE arrival_airport = 'AAQ'
  AND actual_arrival BETWEEN '2017-01-01' AND '2018-01-01';

-- Answer: 486
------
-- 2. Сколько рейсов из Анапы вылетело зимой 2017 года?

SELECT count(*)
FROM dst_project.flights
WHERE departure_airport = 'AAQ'
  AND (date_part('year', actual_departure) = 2017)
  AND (date_part('month', actual_departure) IN (1,
                                                2,
                                                12));

-- Answer: 127
------
-- 3. Посчитайте количество отмененных рейсов из Анапы за все время.

SELECT count(*)
FROM dst_project.flights
WHERE departure_airport = 'AAQ'
  AND status = 'Cancelled';

-- Answer: 1
----
-- 4. Сколько рейсов из Анапы не летают в Москву?

SELECT count(*)
FROM dst_project.flights
WHERE departure_airport = 'AAQ'
  AND arrival_airport not in
    (SELECT airport_code
     FROM dst_project.airports
     WHERE city = 'Moscow');

-- Answer: 453
------
-- 5. Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?

SELECT aircraft_code,
       count(aircraft_code) AS seats
FROM dst_project.seats
WHERE aircraft_code in
    (SELECT DISTINCT aircraft_code
     FROM dst_project.flights
     WHERE departure_airport = 'AAQ')
GROUP BY aircraft_code
ORDER BY seats DESC
LIMIT 1;

-- Answer: 773 (Boeing 737-300)
