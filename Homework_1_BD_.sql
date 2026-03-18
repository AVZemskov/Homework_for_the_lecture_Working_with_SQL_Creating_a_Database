CREATE TABLE musical_genres (
    musikal_genres_id SERIAL PRIMARY KEY,
    name_genres VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE performers (
    executor_id SERIAL PRIMARY KEY,
    name_executor VARCHAR(200) NOT NULL
);

CREATE TABLE performers_genres (
    performer_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (performer_id, genre_id),
    FOREIGN KEY (performer_id) REFERENCES performers(executor_id),
    FOREIGN KEY (genre_id) REFERENCES musical_genres(musikal_genres_id)
);

CREATE TABLE albums (
    albums_id SERIAL PRIMARY KEY,
    alboms_name VARCHAR(200) NOT NULL,
    year_release INTEGER NOT NULL
);

CREATE TABLE performers_albums (
    performer_id INTEGER NOT NULL,
    album_id INTEGER NOT NULL,
    PRIMARY KEY (performer_id, album_id),
    FOREIGN KEY (performer_id) REFERENCES performers(executor_id),
    FOREIGN KEY (album_id) REFERENCES albums(albums_id)
);

CREATE TABLE track (
    treck_id SERIAL PRIMARY KEY,
    treck_name VARCHAR(200) NOT NULL,
    time INTERVAL NOT NULL,
    alboms_id INTEGER NOT NULL,
    FOREIGN KEY (alboms_id) REFERENCES albums(albums_id)
);

CREATE TABLE compilations (
    compilation_id SERIAL PRIMARY KEY,
    compilation_name VARCHAR(200) NOT NULL,
    year_release INTEGER NOT NULL
);

CREATE TABLE compilation_tracks (
    compilation_id INTEGER NOT NULL,
    track_id INTEGER NOT NULL,
    PRIMARY KEY (compilation_id, track_id),
    FOREIGN KEY (compilation_id) REFERENCES compilations(compilation_id),
    FOREIGN KEY (track_id) REFERENCES track(treck_id)
);

-- ЗАПОЛНЕНИЕ --

-- 1. Заполнение исполнителей
INSERT INTO performers (name_executor) VALUES 
('Zefirych'),
('Zivert'),
('Pankevich'),
('Бастон'),
('Бетхов');

-- 2. Заполнение жанров
INSERT INTO musical_genres (name_genres) VALUES 
('Рок'),
('Поп'),
('Реп'),
('Класическая');

-- 3. Заполнение альбомов
INSERT INTO albums (alboms_name, year_release) VALUES 
('Linkin Garden', 2017),
('Tralee-Woolie', 2019),
('Бастон/AND/Zivert', 2013),
('Баста за 40', 2020),
('Dreams-26', 2020);

-- 4. Заполнение сборников
INSERT INTO compilations (compilation_name, year_release) VALUES 
('Рок хиты 2017', 2018),
('Зажигательная музыка', 2020),
('Реп-баллады', 2021),
('Хиты десятилетия', 2022),
('Авто сборник', 2023);

-- 5. Заполнение связей исполнителей с жанрами
INSERT INTO performers_genres (performer_id, genre_id) VALUES 
(1, 1), (1, 3), (2, 2), (2, 3), (3, 3), (4, 4), (4, 2), (5, 2), (5, 3);

-- 6. Заполнение связей исполнителей с альбомами
INSERT INTO performers_albums (performer_id, album_id) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- 7. Заполнение треков
INSERT INTO track (treck_name, time, alboms_id) VALUES 
('Believer', '00:03:24', 1),
('Thunder', '00:03:07', 1),
('Life', '00:03:08', 2),
('Get Lucky', '00:04:08', 3),
('Сансара', '00:04:35', 4),
('Blinding Lights', '00:03:20', 5),
('Whatever It Takes', '00:03:21', 1),
('Fly', '00:03:15', 2),
('my treck', '00:03:00', 1);

-- 8. Заполнение связей сборников с треками
INSERT INTO compilation_tracks (compilation_id, track_id) VALUES 
(1, 1), (1, 2), (1, 6),
(2, 3), (2, 4), (2, 8),
(3, 1), (3, 7),
(4, 5), (4, 6),
(5, 2), (5, 4), (5, 5), (5, 6);

-- Задание №2 SELECT-запросы --

-- 1. Название и продолжительность самого длительного трека
SELECT treck_name, time 
FROM track 
ORDER BY time DESC 
LIMIT 1;

-- 2. Название треков, продолжительность которых не менее 3,5 мин.
SELECT treck_name 
FROM track 
WHERE time >= INTERVAL '3 minutes 30 seconds';

-- 3. Название сборников, вышедших в период с 2018 по 2020г. включительно
SELECT compilation_name 
FROM compilations 
WHERE year_release BETWEEN 2018 AND 2020;

-- 4. Исполнители чье имя состоит из одного слова
SELECT name_executor 
FROM performers 
WHERE name_executor NOT LIKE '% %';

-- 5. Название треков, которые содержат слово "мой" или "my"
SELECT treck_name 
FROM track 
WHERE treck_name ILIKE '%my%' OR treck_name ILIKE '%мой%';

-- Задание 3 SELECT-запросы --

-- 1. Количество исполнителей в каждом жанре
SELECT g.name_genres AS "Жанр", COUNT(pg.performer_id) AS "Количество исполнителей"
FROM musical_genres g
JOIN performers_genres pg ON g.musikal_genres_id = pg.genre_id
GROUP BY g.name_genres
ORDER BY COUNT(pg.performer_id) DESC;

-- 2. Количество треков, вошедших в альбомы 2019–2020 годов
SELECT COUNT(t.treck_id) AS "Количество треков"
FROM track t
JOIN albums a ON t.alboms_id = a.albums_id
WHERE a.year_release BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по каждому альбому
SELECT a.alboms_name AS "Альбом", AVG(t.time) AS "Средняя продолжительность"
FROM track t
JOIN albums a ON t.alboms_id = a.albums_id
GROUP BY a.alboms_name
ORDER BY AVG(t.time) DESC;

-- 4. Все исполнители, которые не выпустили альбомы в 2020 году
SELECT p.name_executor AS "Исполнитель"
FROM performers p
WHERE p.executor_id NOT IN (
    SELECT pa.performer_id
    FROM performers_albums pa
    JOIN albums a ON pa.album_id = a.albums_id
    WHERE a.year_release = 2020
);

-- 5. Названия сборников, в которых присутствует конкретный исполнитель (выберем 'Zefirych')
SELECT DISTINCT c.compilation_name AS "Сборник"
FROM compilations c
JOIN compilation_tracks ct ON c.compilation_id = ct.compilation_id
JOIN track t ON ct.track_id = t.treck_id
JOIN albums a ON t.alboms_id = a.albums_id
JOIN performers_albums pa ON a.albums_id = pa.album_id
JOIN performers p ON pa.performer_id = p.executor_id
WHERE p.name_executor = 'Zefirych';
