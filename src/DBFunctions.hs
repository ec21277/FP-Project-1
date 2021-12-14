{-# LANGUAGE OverloadedStrings #-}

module DBFunctions (
    createTables,
    saveRecords,
    getGenderRatio,
    deleteOldEntries,
    getMinMaxMarks,
    -- getStudentBestSubject,
    getMinMaxMarksGender,
    getGenderMinMax
) where 

import DataModel
import Database.SQLite.Simple
import Text.SimpleTableGenerator


instance FromRow StudentPersonalDetails where
    fromRow = StudentPersonalDetails <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field

instance ToRow StudentPersonalDetails where
    toRow (StudentPersonalDetails roll_no gender ethnicity parental_level_of_education math reading writing lunch test_preparation_course)
        = toRow (roll_no, gender, ethnicity, parental_level_of_education, math , reading,writing, lunch, test_preparation_course)

{-
    Row instance creation Region 
-}


data Scores = Scores Int Int Int Int deriving (Show)
instance FromRow StudentScores where
  fromRow = StudentScores <$> field <*> field <*> field <*> field

instance ToRow Scores where
    toRow (Scores roll_no math writing reading) 
        = toRow (roll_no, math, writing, reading)


data StudentDetails = StudentDetails Int String String String deriving (Show)
instance FromRow StudentDetails where
  fromRow = StudentDetails <$> field <*> field <*> field <*> field 
instance ToRow StudentDetails where
    toRow (StudentDetails roll_no gender ethnicity parental_level_of_education) 
        = toRow (roll_no, gender, ethnicity, parental_level_of_education)

data StudentBackground = StudentBackground Int String String deriving (Show)
instance FromRow StudentBackground where
  fromRow = StudentBackground <$> field <*> field <*> field 
instance ToRow StudentBackground where
    toRow (StudentBackground roll_no lunch test_preparation_course) 
        = toRow (roll_no, lunch, test_preparation_course)

instance FromRow StudentScoreGender where
  fromRow = StudentScoreGender <$> field <*> field <*> field <*> field <*> field
{-
    Row instance creation Region  ENDS
-}


createTables :: IO Connection
createTables = do
        conn <- open "covid.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentData (\
            \roll_no INT NOT NULL PRIMARY KEY, \
            \gender VARCHAR(6) NOT NULL, \
            \ethnicity VARCHAR(50) NOT NULL, \
            \parental_level_of_education VARCHAR(20) DEFAULT NULL \
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentBackgroundDetails (\
            \lunch VARCHAR(20) NOT NULL, \
            \test_preparation_course VARCHAR(20) NOT NULL, \
            \roll_no INT NOT NULL \
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentScores (\
            \roll_no INT NOT NULL PRIMARY KEY, \
            \math INT NOT NULL, \
            \reading INT NOT NULL, \
            \writing NOT NULL \
            \)"
        return conn

{-
    Removes all old entries from the current tables. 
    Only run if we call download data.
-}
deleteOldEntries  conn =do 
     execute_ conn "DELETE FROM studentData"
     execute_ conn "DELETE FROM studentScores"
     execute_ conn "DELETE FROM studentBackgroundDetails"


{-
    Reads the response row into personalDetails object
    segregates the data into multiple variables
    Runs 3 queries to inject data into 3 tables
-}
insertRows conn record = do
    let personalDetails = StudentPersonalDetails {
        roll_no = roll_no record,
        gender = gender record,
        ethnicity = ethnicity record,
        parental_level_of_education = parental_level_of_education record,
        math = math record,
        reading = reading record,
        writing = writing record,
        lunch = lunch record,
        test_preparation_course =test_preparation_course  record 
    }
    
    let roll_number  =  roll_no personalDetails 
    let math_score  =  math personalDetails 
    let reading_score  =  reading personalDetails 
    let writing_score  =  writing personalDetails 

    let gender_v = gender personalDetails
    let ethnicity_v = ethnicity personalDetails
    let parental_level_of_education_v = parental_level_of_education personalDetails

    let lunch_v = lunch personalDetails
    let test_preparation_course_v =test_preparation_course  personalDetails 

    execute conn "INSERT INTO StudentData (roll_no, gender, ethnicity,parental_level_of_education) VALUES (?,?,?,? )" (StudentDetails roll_number gender_v ethnicity_v parental_level_of_education_v)
    execute conn "INSERT INTO studentScores (roll_no, math, reading,writing) VALUES (?,?,?,? )" (Scores roll_number math_score reading_score writing_score)
    execute conn "INSERT INTO studentBackgroundDetails (roll_no, lunch, test_preparation_course) VALUES (?,?,?)" (StudentBackground roll_number lunch_v test_preparation_course_v)

saveRecords :: Connection -> [StudentPersonalDetails] -> IO ()
saveRecords conn = mapM_ (insertRows conn)


{-
    Analysis region
-}

--Analysis 1.
-- Get Ratio of male vs female students
getStudentsData :: Connection -> IO [StudentScores]
getStudentsData conn = do
    let roll_no = 0 :: Int 
    let sql_query = "Select roll_no,math as math_scores, reading as reading_score ,writing as writing_score  from studentScores where roll_no > ?"
    query conn sql_query [roll_no]

getGenderRatio :: Connection -> IO()
getGenderRatio conn = do
    score_response1 <- getStudentsData conn
    let entries_count = length score_response1
    let total_math_marks = sum (map math_score score_response1)
    let total_reading_marks = sum (map reading_score score_response1)
    let total_writing_marks = sum (map writing_score score_response1)
    
    let avg_math_score = div total_math_marks entries_count
    let avg_reading_score = div total_reading_marks entries_count
    let avg_writing_score = div total_writing_marks entries_count

    -- let total = sum (map roll_no countryEntries)
    putStr "Total Math score : "
    putStrLn (show total_math_marks) 
    putStr "Average Math score : "
    putStrLn (show avg_math_score)
    
    putStr "Total Reading score : "
    putStrLn (show total_reading_marks) 
    putStr "Average Reading score : "
    putStrLn (show avg_reading_score)
    putStrLn $ makeDefaultSimpleTable [["    ","Math","Reading","Writing"], ["Total",(show total_math_marks),(show total_reading_marks),(show total_writing_marks)], ["Average", (show avg_math_score),(show avg_reading_score),(show avg_writing_score)]]


-- Analysis 2 Highest / Lowest Marks Overall
getMinMaxMarks :: Connection -> IO()
getMinMaxMarks conn = do
    score_response1 <- getStudentsData conn
    let min_math_marks = foldr min 0 (map math_score score_response1)
    let min_read_marks = foldr min 0 (map reading_score score_response1)
    let min_write_marks = foldr min 0 (map writing_score score_response1)
    let max_math_marks = foldr max 0 (map math_score score_response1)
    let max_read_marks = foldr max 0 (map reading_score score_response1)
    let max_write_marks = foldr max 0 (map writing_score score_response1)
    putStr "Min Math score : "
    putStrLn (show min_math_marks)
    putStr "Min Reading score : "
    putStrLn (show min_read_marks)
    putStr "Min Writing score : "
    putStrLn (show min_write_marks)
    putStr "Max Math score : "
    putStrLn (show max_math_marks)
    putStr "Max Reading score : "
    putStrLn (show max_read_marks)
    putStr "Max Writing score : "
    putStrLn (show max_write_marks)

    -- print $ "Total entries: " ++ show(total)


-- getStudentBestSubject :: Connection -> IO [StudentScores]
-- getStudentBestSubject conn = do
--     putStr "Enter Roll Number of Student: "
--     rno <- getLine
--     let sql2= "SELECT roll_no,math,reading,writing FROM studentScores where roll_no = ?"
--     query conn sql2  [rno]

-- getBestMarks :: Connection -> IO()
-- getBestMarks conn = do 
--     score_response1 <- getStudentsData conn
--     let math_marks = math score_response1
--     let reading_marks = reading score_response1
--     let writing_marks = writing score_response1
--     let best = max (math_marks,reading_marks,writing_marks)

--     putStr "Best Scores are: "
--     putStrLn (show best)

-- getGenderMinMax :: Connection -> IO [StudentScoreGender]
getGenderMinMax conn = do
    putStr "Enter male or female > "
    gen <- getLine

    putStrLn gen
    let sql_query = "Select roll_no,math as math_scores, reading as reading_score ,writing as writing_score,gender from studentScores inner join StudentData USING (roll_no) where gender = ?"
    query conn sql_query [gen]




-- getMinMaxMarksGender :: Connection -> IO()
getMinMaxMarksGender conn = do
    score_response2 <- getGenderMinMax conn
    let min_math_marks = foldr min 0 (map math_score score_response2)
    let min_read_marks = foldr min 0 (map reading_score score_response2)
    let min_write_marks = foldr min 0 (map writing_score score_response2)
    let max_math_marks = foldr max 0 (map math_score score_response2)
    let max_read_marks = foldr max 0 (map reading_score score_response2)
    let max_write_marks = foldr max 0 (map writing_score score_response2)
    putStr "Min Math score : "
    putStrLn (show min_math_marks)
    putStr "Min Reading score : "
    putStrLn (show min_read_marks)
    putStr "Min Writing score : "
    putStrLn (show min_write_marks)
    putStr "Max Math score : "
    putStrLn (show max_math_marks)
    putStr "Max Reading score : "
    putStrLn (show max_read_marks)
    putStr "Max Writing score : "
    putStrLn (show max_write_marks)






-- getStudentMarksGender :: Connection -> IO [StudentScores]
-- getStudentMarksgender conn = do
--     let roll_no = 0 :: Int 
--     let sql_query = "Select roll_no,math as math_scores, reading as reading_score ,writing as writing_score from studentScores where roll_no > ?"
--     query conn sql_query [roll_no]
{-
    Analysis region ENDS
-}