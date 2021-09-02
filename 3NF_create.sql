CREATE TABLE IF NOT EXISTS typevoie2(
	Code_type_de_voie integer PRIMARY KEY,
    Type_de_voie bpchar
);

CREATE TABLE IF NOT EXISTS voie2(
    Type_de_voie bpchar,
	code_voie bpchar,
    voie bpchar
);
/* adding primary key */
ALTER TABLE voie2 ADD COLUMN voie_id SERIAL PRIMARY KEY;
ALTER TABLE voie2 ADD COLUMN Code_type_de_voie INTEGER;

/* adding foreign key */
UPDATE voie2 vo
SET Code_type_de_voie = tv.Code_type_de_voie
FROM typevoie2 tv
WHERE tv.Type_de_voie = vo.Type_de_voie;

ALTER TABLE voie2 
   ADD CONSTRAINT fk_typevoie2
   FOREIGN KEY (Code_type_de_voie) 
   REFERENCES typevoie2(Code_type_de_voie);
 
 /*dropping therapist column- inconsistent with data group */
ALTER TABLE voie2
DROP COLUMN Type_de_voie;

CREATE TABLE IF NOT EXISTS typelocal2(
    Code_type_local integer PRIMARY KEY,
    Type_local bpchar
);

CREATE TABLE IF NOT EXISTS local2(
    surface_reelle_bati integer,
    nombre_pieces_principales integer,
    Type_local bpchar
);

/* adding primary key */
ALTER TABLE local2 ADD COLUMN local_id SERIAL PRIMARY KEY;
ALTER TABLE local2 ADD COLUMN Code_type_local INTEGER;

/* adding foreign key */
UPDATE local2 lo
SET Code_type_local = tl.Code_type_local
FROM typelocal2 tl
WHERE tl.Type_local = lo.Type_local;

ALTER TABLE local2 
   ADD CONSTRAINT fk_typelocal2
   FOREIGN KEY (Code_type_local) 
   REFERENCES typelocal2(Code_type_local);
 
 /*dropping therapist column- inconsistent with data group */
ALTER TABLE local1
DROP COLUMN Type_local;

CREATE TABLE IF NOT EXISTS commune1(
	code_ID_commune integer PRIMARY KEY,
    Code_postal VARCHAR(100),
    Commune bpchar,
	Code_department bpchar,
    Code_commune bpchar
);
/* adding primary key */
ALTER TABLE commune1 ADD COLUMN department_id INTEGER;

/* adding foreign key */
UPDATE commune1 co
SET department_id = dp.department_id
FROM department1 dp
WHERE dp.code_department = co.code_department;

ALTER TABLE commune1 
   ADD CONSTRAINT fk_department1
   FOREIGN KEY (department_id) 
   REFERENCES department1(department_id);
 
 /*dropping therapist column- inconsistent with data group */
ALTER TABLE department1 
DROP COLUMN Type_local;

CREATE TABLE IF NOT EXISTS department1(
	Code_postal VARCHAR(100),
	Commune bpchar,
	code_department bpchar,
    Code_commune bpchar
);
/* adding primary key */
ALTER TABLE department1 ADD COLUMN department_id SERIAL PRIMARY KEY;

CREATE TABLE IF NOT EXISTS mutation1(

    No_disposition integer,
    Dates_mutation timestamp,
    Nature_mutation bpchar,
    Valeur_fonciere VARCHAR,
	commune bpchar
);

/* adding primary key */
ALTER TABLE mutation1 ADD COLUMN mutation_id SERIAL PRIMARY KEY;
ALTER TABLE mutation1 ADD COLUMN Code_ID_commune INTEGER;

/* adding foreign key */
UPDATE mutation1 mt
SET Code_ID_commune = co.Code_ID_commune
FROM commune co
WHERE co.commune = mt.commune;

ALTER TABLE mutation1
   ADD CONSTRAINT fk_commune
   FOREIGN KEY (Code_ID_commune) 
   REFERENCES commune(Code_ID_commune);
 
 /*dropping column- inconsistent with data group */
ALTER TABLE mutation1
DROP COLUMN commune;


CREATE TABLE IF NOT EXISTS loty
(
    lot1 bpchar,
    Surface_carrez_du_1er_lot double precision,
    Nombre_de_lots integer,
	Commune bpchar,
    Surface_terrain integer
)   

/* adding primary key */
ALTER TABLE loty ADD COLUMN lot_id SERIAL PRIMARY KEY;
ALTER TABLE loty ADD COLUMN Code_ID_commune INTEGER;

/* adding foreign key */
UPDATE loty ly
SET Code_ID_commune = co.Code_ID_commune
FROM commune co
WHERE co.commune = ly.commune;

ALTER TABLE loty
   ADD CONSTRAINT fk_commune
   FOREIGN KEY (Code_ID_commune) 
   REFERENCES commune(Code_ID_commune);
 
 /*dropping column- inconsistent with data group */
ALTER TABLE loty
DROP COLUMN commune;

CREATE TABLE public.address1
(
    Voie bpchar,
	code_postal double precision,
	Type_de_voie bpchar,
    No_voie integer,
    BTQ VARCHAR(2),
    Code_department VARCHAR,
    Commune bpchar,
    Type_local bpchar
);
/* adding primary key */
ALTER TABLE address1 ADD COLUMN address_id SERIAL PRIMARY KEY;
ALTER TABLE address1 ADD COLUMN Code_type_de_voie INTEGER;

/* adding foreign key */
UPDATE address1 ad
SET Code_type_de_voie = tv.Code_type_de_voie
FROM typevoie1 tv
WHERE tv.Type_de_voie = ad.Type_de_voie;

ALTER TABLE address1
   ADD CONSTRAINT fk_typevoie1
   FOREIGN KEY (Code_type_de_voie) 
   REFERENCES typevoie1(Code_type_de_voie);
 
 /*dropping column- inconsistent with data group */
ALTER TABLE address1
DROP COLUMN Type_de_voie;

