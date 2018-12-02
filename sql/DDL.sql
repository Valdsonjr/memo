--
-- File generated with SQLiteStudio v3.1.1 on dom dez 2 10:08:22 2018
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: STORE
CREATE TABLE STORE (
    [KEY]  VARCHAR (100) PRIMARY KEY
                         NOT NULL,
    VALUE  TEXT          NOT NULL,
    HIDDEN BOOLEAN       NOT NULL
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
