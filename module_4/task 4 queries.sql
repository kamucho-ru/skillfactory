-- Задание 4.1
-- База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:

SELECT count(city),
       city
FROM dst_project.airports
GROUP BY city
ORDER BY COUNT DESC
LIMIT 3;

-- Answer: Moscow, Ulyanovsk
----------------------------
-- Задание 4.2
-- 1. Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. Сколько всего статусов для рейсов определено в таблице?

SELECT count(DISTINCT status)
FROM dst_project.flights;

-- Answer:  6
-------------
-- 2. Какое количество самолетов находятся в воздухе на момент среза в базе (статус рейса «самолёт уже вылетел и находится в воздухе»).

SELECT count(*)
FROM dst_project.flights
WHERE status = 'Departed';

-- Answer: 58
-------------
-- 3. Места определяют схему салона каждой модели. Сколько мест имеет самолет модели 773 (Boeing 777-300)?

SELECT count(*)
FROM dst_project.seats
WHERE aircraft_code = '773';

-- Answer: 402
--------------
-- 4. Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года?

SELECT count(*)
FROM dst_project.flights
WHERE status = 'Arrived'
  AND actual_arrival BETWEEN '2017-04-01' AND '2017-09-01';

-- Answer: 74227
----------------
-- Задание 4.3
-- 1. Сколько всего рейсов было отменено по данным базы?

SELECT count(*)
FROM dst_project.flights
WHERE status = 'Cancelled';

-- Answer: 437
--------------
-- 2. Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок?

SELECT count(*)
FROM dst_project.aircrafts
WHERE model like '%Boeing%';

-- Answer: 3

SELECT count(*)
FROM dst_project.aircrafts
WHERE model like '%Sukhoi Superjet%';

-- Answer: 1

SELECT count(*)
FROM dst_project.aircrafts
WHERE model like '%Airbus%';

-- Answer: 3
------------
-- 3. В какой части (частях) света находится больше аэропортов?

SELECT count(*)
FROM dst_project.airports;

-- Answer: 104

SELECT count(*)
FROM dst_project.airports
WHERE timezone like '%Europe%';

-- Answer: 52
-------------
-- 4. У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id).

SELECT flight_id,
       scheduled_arrival,
       actual_arrival,
       (actual_arrival - scheduled_arrival) AS delay
FROM dst_project.flights
WHERE status = 'Arrived'
ORDER BY delay DESC
LIMIT 1;

-- Answer: 157571
-----------------
-- Задание 4.4
-- 1. Когда был запланирован самый первый вылет, сохраненный в базе данных?

SELECT scheduled_departure
FROM dst_project.flights
ORDER BY scheduled_departure ASC
LIMIT 1;

-- Answer: август 14, 2016, 11:45 вечера
----------------------------------------
-- 2. Сколько минут составляет запланированное время полета в самом длительном рейсе?

SELECT extract(epoch
               FROM scheduled_arrival - scheduled_departure) / 60 AS duration
FROM dst_project.flights
ORDER BY duration DESC
LIMIT 1;

-- Answer: 530
--------------
-- 3. Между какими аэропортами пролегает самый длительный по времени запланированный рейс?

SELECT departure_airport,
       arrival_airport,
       extract(epoch
               FROM scheduled_arrival - scheduled_departure) / 60 AS duration
FROM dst_project.flights
ORDER BY duration DESC
LIMIT 1;

-- Answer: DME, UUS
-------------------
-- 4. Сколько составляет средняя дальность полета среди всех самолетов в минутах? Секунды округляются в меньшую сторону (отбрасываются до минут).

SELECT avg(duration)
FROM
  (SELECT *,
          arrival_airport,
          extract(epoch
                  FROM scheduled_arrival - scheduled_departure) / 60 AS duration
   FROM dst_project.flights) AS flights_duration;

-- Answer: 128.36
-----------------
-- Задание 4.5
-- 1. Мест какого класса у SU9 больше всего?

SELECT count(*),
       fare_conditions
FROM dst_project.seats
WHERE aircraft_code = 'SU9'
GROUP BY fare_conditions;

-- Answer: Economy
------------------
-- 2. Какую самую минимальную стоимость составило бронирование за всю историю?

SELECT total_amount
FROM dst_project.bookings
ORDER BY total_amount
LIMIT 1;

-- Answer: 3400
---------------
-- 3. Какой номер места был у пассажира с id = 4313 788533?

SELECT seat_no
FROM dst_project.boarding_passes
WHERE ticket_no =
    (SELECT ticket_no
     FROM dst_project.tickets
     WHERE passenger_id = '4313 788533' );

-- Answer: 2A
