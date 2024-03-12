/**
 * Normalize the database
 *
 * Create new tables and define their relationships based on the schema in `normalization.png`
 */

- create table race/gender/category (id serial primary key,name varchar(255) not null);
- create table tolkien_character (id serial primary key,name varchar(255) not null,gender_id int ,race_id int, category_id int, constraint gender_constraint foreign key(gender_id) references gender(id), constraint race_constraint foreign key(race_id) references race(id), constraint category_constraint foreign key(category_id) references category(id));

/**
 * Populate the new tables
 *
 * Populate the new tables with data from the `middle_earth_character` table.
 * Use transaction(s).
 */

 begin;

insert into gender(name) select distinct gender from middle_earth_character;

insert into race(name) select distinct race from middle_earth_character;

insert into category(name) select distinct category from middle_earth_character;


INSERT INTO tolkien_character (id, name, gender_id, race_id, category_id)
SELECT 
    middle_earth_character.id,
    middle_earth_character.name,
    gender.id AS gender_id,
    race.id AS race_id,
    category.id AS category_id
FROM 
    middle_earth_character
INNER JOIN 
    gender ON gender.name = middle_earth_character.gender
INNER JOIN 
    race ON race.name = middle_earth_character.race
INNER JOIN 
    category ON category.name = middle_earth_character.category
ORDER BY 
    middle_earth_character.id ASC;

end;

/**
 * Refactor the database
 *
 * Rename the `middle_earth_character` table to `deprecated_middle_earth_character`.
 * Create a view named `middle_earth_character` with the original structure of the data.
 * Run the query in the `app.pgsql` file and check the results.
 */
- alter table middle_earth_character rename to depricated_middle_earth_character;
- create view middle_earth_character_2 as select tolkien_character.id,tolkien_character.name,gender.name as gender,race.name as race,category.name as category from tolkien_character inner join gender on gender.id = tolkien_character.gender_id inner join race on race.id = tolkien_character.race_id inner join category on category.id = tolkien_character.category_id;
 

/**
 * Delete legacy data
 *
 * Delete the `deprecated_middle_earth_character` table.
 */

 - drop deprecated_middle_earth_character;