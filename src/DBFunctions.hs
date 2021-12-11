{-# LANGUAGE OverloadedStrings #-}

module DBFunctions (
    createTables,
    saveRecords
) where 

import DataModel
import Database.SQLite.Simple




createTables :: IO Connection
createTables = do
        conn <- open "covid.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentData (\
            \roll_no INT NOT NULL PRIMARY KEY, \
            \gender VARCHAR(6) NOT NULL, \
            \ethnicity VARCHAR(50) NOT NULL, \
            \parental_level_of_education VARCHAR(20) DEFAULT NULL \
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS entries (\
            \date VARCHAR(40) NOT NULL, \
            \day VARCHAR(40) NOT NULL, \
            \month VARCHAR(40) NOT NULL, \
            \year VARCHAR(40) NOT NULL, \
            \cases INT DEFAULT NULL, \
            \deaths INT DEFAULT NULL, \
            \fk_country INTEGER\
            \)"
        return conn


-- insertRows :: Connection -> Record -> IO ()
-- insertRows conn record = do
--     print "SomeShit"
--     -- country <- getOrCreateCountry conn (country record) (continent record) (population record)
--     -- let record = Record {
--     --     gender = gender record,
--     --     day_ = day record,
--     --     month_ = month record,
--     --     year_ = year record,
--     --     cases_ = cases record,
--     --     deaths_ = deaths record,
--     --     fk_country = id_ country
--     -- }
--     -- execute conn "INSERT INTO entries VALUES (?,?,?,?,?,?,?)" record

instance ToRow Record where
    toRow (Record roll_no gender ethnicity parental_level_of_education)
        = toRow (roll_no, gender, ethnicity, parental_level_of_education)

insertRows :: Connection -> Record -> IO ()
insertRows conn record = do
    
    let entry = Record {
        roll_no = roll_no record,
        gender = gender record,
        ethnicity = ethnicity record,
        parental_level_of_education = parental_level_of_education record
    
    }
    execute conn "INSERT INTO studentData VALUES (?,?,?,?)" entry
    print "s"


saveRecords :: Connection -> [Record] -> IO ()
saveRecords conn = mapM_ (insertRows conn)




-- insertRowsAndReturnValues :: Connection -> [Record] -> IO ()
-- insertRowsAndReturnValues conn = mapM_ (insertRows conn)
