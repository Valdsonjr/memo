{-# LANGUAGE QuasiQuotes #-}

module Query (
    list,
    delete,
    insert,
    fetch
) where

import           Database.SQLite.Simple    (Query)
import           Database.SQLite.Simple.QQ (sql)

list :: Query
list = [sql|
    SELECT
        KEY || replace(hex(zeroblob(T.I - LENGTH(KEY))), '00', ' ') ||
        replace(VALUE, '\n', '\n' || replace(hex(zeroblob(T.I)), '00', ' '))
    FROM STORE
    JOIN (
        SELECT MAX(LENGTH(KEY)) + 5 AS I
        FROM STORE
        WHERE NOT HIDDEN
    ) AS T ON 1
    WHERE NOT HIDDEN |]

insert :: Query
insert =
    [sql| INSERT or IGNORE INTO STORE (KEY, VALUE, HIDDEN) VALUES (?,?,?) |]

delete :: Query
delete = [sql| DELETE FROM STORE WHERE KEY = ? |]

fetch :: Query
fetch = [sql| SELECT VALUE, HIDDEN FROM STORE WHERE KEY = ? |]
