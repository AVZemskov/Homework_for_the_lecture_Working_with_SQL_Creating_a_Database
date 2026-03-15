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