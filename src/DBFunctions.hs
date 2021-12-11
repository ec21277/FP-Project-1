{-# LANGUAGE OverloadedStrings #-}

module DBFunctions (
    createTables,
    saveRecords,
    saveRecordsScore
    
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
        execute_ conn "CREATE TABLE IF NOT EXISTS StudentScores (\
            \roll_no_sc INT NOT NULL PRIMARY KEY, \
            \math INT NOT NULL, \
            \reading INT NOT NULL, \
            \writing NOT NULL \
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

instance ToRow StudentPersonalDetails where
    toRow (StudentPersonalDetails roll_no gender ethnicity parental_level_of_education)
        = toRow (roll_no, gender, ethnicity, parental_level_of_education)

insertRows :: Connection -> StudentPersonalDetails -> IO ()
insertRows conn record = do
    
    let entry = StudentPersonalDetails {
        roll_no = roll_no record,
        gender = gender record,
        ethnicity = ethnicity record,
        parental_level_of_education = parental_level_of_education record
    
    }
    execute_ conn "DELETE FROM studentData"
    execute conn "INSERT INTO studentData VALUES (?,?,?,?)" entry
    print "s"


saveRecords :: Connection -> [StudentPersonalDetails] -> IO ()
saveRecords conn = mapM_ (insertRows conn)




-- insertRowsAndReturnValues :: Connection -> [Record] -> IO ()
-- insertRowsAndReturnValues conn = mapM_ (insertRows conn)



instance ToRow StudentScores where
    toRow (StudentScores roll_no_sc math reading writing)
        = toRow (roll_no_sc, math,reading,writing)

insertRowsScore :: Connection -> StudentScores -> IO ()
insertRowsScore conn record2 = do
    
    let entry = StudentScores {
        roll_no_sc = roll_no_sc record2,
        math = math record2,
        reading = reading record2,
        writing = writing record2
    
    }
    -- execute_ conn "DELETE FROM StudentScores"
    execute conn "INSERT INTO StudentScores VALUES (?,?,?,?)" entry
    print "s2"


saveRecordsScore :: Connection -> [StudentScores] -> IO ()
saveRecordsScore conn = mapM_ (insertRowsScore conn)