{-# LANGUAGE OverloadedStrings #-}

module GenderFilters(
getStudentDataGender,
getGender,
showGenderAnalysis
)
where
import DataModel
import Database.SQLite.Simple
import Data.List
import Text.SimpleTableGenerator

gender_data = [] :: String 

-- Get Unique values from List
uniq :: Eq a => [a] -> [a]
uniq [] = []
uniq (x:xs) = (if x `elem` xs then id else (x:)) $ uniq xs



instance FromRow StudentScoreGender where
  fromRow = StudentScoreGender <$> field <*> field <*> field <*> field <*> field  

getGender :: Connection -> IO [StudentScoreGender]
getGender conn = do
    putStr "GetGender \n"
    let roll_no = 1 :: Int 
    let sql_query = "Select studentData.roll_no,math,reading,writing,gender FROM studentData INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND 1=?"
    query conn sql_query [roll_no]


getStudentDataGender conn level = do
    putStr "GetStudentDataGender \n"
    let sql_query = "Select studentData.roll_no,math,reading,writing,gender FROM studentData INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND studentData.gender = ?"
    query conn sql_query [level]

showGenderAnalysis :: Connection -> IO ()
showGenderAnalysis conn = do
    putStr "Inside GenderAnalysis \n"
    studentData <- getGender conn
    close conn
    let allTypes = map gender_marks studentData
    let distinctGenType = uniq allTypes
    mapM_ (analyseEachType conn) distinctGenType
    print "HelloGen \n"


-- loopthough :: [String] -> [[String]]
loopthough [] = []
loopthough (x:xs) = (analyseEachType x) : loopthough xs 

analyseEachType conn level= do
    putStr "Inside analysis \n"
    conn <- open "covid.sqlite"
    response <- getStudentDataGender conn level

    let entries_count = length response
    let total_math_marks = sum (map math_marks response)
    let total_reading_marks = sum (map reading_marks response)
    let total_writing_marks = sum (map writing_marks response)
    
    let avg_math_score = div total_math_marks entries_count
    let avg_reading_score = div total_reading_marks entries_count
    let avg_writing_score = div total_writing_marks entries_count

    let analysedData = [level,(show avg_math_score),show avg_reading_score, show avg_writing_score]

    putStrLn $ makeDefaultSimpleTable [analysedData]

