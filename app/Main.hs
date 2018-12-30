module Main where

import           Control.Monad                 (unless)
import           Database.SQLite.Simple        (Connection, Only (..), fold_,
                                                fromOnly, query, withConnection)
import           Query                         (delete, fetch, insert, list)
import           System.Clipboard              (setClipboardString)
import           System.Directory              (doesFileExist)
import           System.Environment            (getArgs)
import           System.Environment.Executable (getExecutablePath)
import           System.Exit                   (exitSuccess)
import           System.FilePath               (replaceFileName)
-------------------------------------------------------------------------------
-- HELPERS
-------------------------------------------------------------------------------
data Error = StoreNotFound
           | CorruptedStore
           | KeyNotFound
           | KeyAlreadyExists
           | ParsingError
           deriving (Show)

type Item = (String, String, Bool)
type App = Connection -> IO ()

failWith :: (Show a) => a -> IO b
failWith err = print err >> exitSuccess

safeHead :: [a] -> Maybe a
safeHead []      = Nothing
safeHead (h : _) = Just h

first :: (a, b, c) -> a
first (a, _, _) = a
-------------------------------------------------------------------------------
-- run :: [String] -> App
-- tries to parse the args and to execute the requested action
-------------------------------------------------------------------------------
run :: [String] -> App
run ["ls"]                  = ls
run ["get", key]            = get key
run ["del", key]            = del key
run ["put", key, val]       = put (key, val, False)
run ["put", key, val, "-h"] = put (key, val, True)
run _                       = const $ failWith ParsingError

-------------------------------------------------------------------------------
-- get :: String -> App
-- tries to print the value with given key and add it to the clipboard
-------------------------------------------------------------------------------
get :: String -> App
get key conn =
    query conn fetch (Only key)
    >>= maybe (failWith KeyNotFound) use . safeHead
    where
    use (value, hidden) = setClipboardString value
                        >> unless hidden (putStrLn value)

-------------------------------------------------------------------------------
-- del :: String -> App
-- tries to delete the value with given key
-------------------------------------------------------------------------------
del :: String -> App
del key conn = do
    [[change]] <- query conn delete (Only key) :: IO [[Int]]
    unless (change == 1) (failWith KeyNotFound)

-------------------------------------------------------------------------------
-- ls :: App
-- traverses the store printing all of its values
-------------------------------------------------------------------------------
ls :: App
ls conn = fold_ conn list () (const (putStrLn . fromOnly))

-------------------------------------------------------------------------------
-- put :: Item -> App
-- tries to insert given value with given key into the store
-------------------------------------------------------------------------------
put :: Item -> App
put item conn = do
    [[change]] <- query conn insert item :: IO [[Int]]
    unless (change == 1) (failWith KeyAlreadyExists)

main :: IO ()
main = do
    args <- getArgs
    path <- fmap (`replaceFileName` "store") getExecutablePath
    storeFound <- doesFileExist path

    if storeFound
    then withConnection path (run args)
    else failWith StoreNotFound
