{-# LANGUAGE OverloadedStrings #-}

module DBFunctions (
    createTables,
    saveRecords,
    saveStudentBackgroundRecords,
    getGenderRatio,
    deleteOldEntries
) where 

import DataModel
import Database.SQLite.Simple



createTables :: IO Connection
createTables = do
        conn <- open "studentData.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentData (\
            \roll_no INT NOT NULL PRIMARY KEY, \
            \gender VARCHAR(6) NOT NULL, \
            \ethnicity VARCHAR(50) NOT NULL, \
            \parental_level_of_education VARCHAR(20) DEFAULT NULL \
            \)"
        conn <- open "studentBackgroundDetails.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentBackgroundDetails (\
            \lunch VARCHAR(20) NOT NULL, \
            \parental_level_of_education VARCHAR(20) NOT NULL, \
            \roll_no INT NOT NULL \
            \)"
        return conn

{-
    Removes all old entries from the current tables. 
    Only run if we call download data.
-}
deleteOldEntries  conn =do 
     execute_ conn "DELETE FROM studentData"
     execute_ conn "DELETE FROM entries"

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
    execute conn "INSERT INTO studentData VALUES (?,?,?,?)" entry


{-
    REGION - Student Background 
-}

instance ToRow StudentBackgroundDetails where
    toRow (StudentBackgroundDetails student_roll_no lunch test_preparation_course)
        = toRow (student_roll_no, lunch, test_preparation_course)

insertRowsForStudentBackgroundDetails :: Connection -> StudentBackgroundDetails -> IO ()
insertRowsForStudentBackgroundDetails conn record = do
    
    let entry = StudentBackgroundDetails {
        lunch = lunch record,
        test_preparation_course= test_preparation_course record,
        student_roll_no = student_roll_no record 
    
    }
    execute_ conn "DELETE FROM studentBackgroundDetails"
    execute conn "INSERT INTO studentBackgroundDetails VALUES (?,?,?)" entry
    print "stu-bd"

saveRecords :: Connection -> [StudentPersonalDetails] -> IO ()
saveRecords conn = mapM_ (insertRows conn)

saveStudentBackgroundRecords :: Connection -> [StudentBackgroundDetails] -> IO ()
saveStudentBackgroundRecords conn = mapM_ (insertRowsForStudentBackgroundDetails conn)




instance FromRow StudentPersonalDetails where
    fromRow = StudentPersonalDetails <$> field <*> field <*> field <*> field

getStudentsData :: Connection -> IO [StudentPersonalDetails]
getStudentsData conn = do
    print "Enter country name > "
    countryName <- getLine
    let sql_query = "Select * from studentData where 1=?"
    query conn sql_query [countryName]

getGenderRatio :: Connection -> IO()
getGenderRatio conn = do
    print "lol"
    countryEntries <- getStudentsData conn
    let total = sum (map roll_no countryEntries)
    print $ "Total entries: " ++ show(total)