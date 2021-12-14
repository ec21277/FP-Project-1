{-# LANGUAGE OverloadedStrings #-}

module Parental_edu(
    showParentalAnalysis
)
where
import DataModel
import Database.SQLite.Simple
-- import Data.List
import Text.SimpleTableGenerator

parental_data = [] :: [String]
-- connection :: Connection

-- Get Unique values from List
uniq :: Eq a => [a] -> [a]
uniq [] = []
uniq (x:xs) = (if x `elem` xs then id else (x:)) $ uniq xs


instance FromRow StudentDataParental where
  fromRow = StudentDataParental <$> field <*> field <*> field <*> field <*> field  <*> field  


getStudentsData :: Connection -> IO [StudentDataParental]
getStudentsData conn = do
    let roll_no = 1 :: Int 
    let sql_query = "Select studentData.roll_no,gender,parental_level_of_education,math,reading,writing FROM studentData INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND 1=?"
    query conn sql_query [roll_no]


-- getStudentsDataparentalEducation :: Connection -> String -> IO [StudentDataParental]
getStudentsDataparentalEducation conn level = do
    let sql_query = "Select studentData.roll_no,gender,parental_level_of_education,math,reading,writing FROM studentData   INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND studentData.parental_level_of_education = ?"
    query conn sql_query [level]

showParentalAnalysis :: Connection -> IO ()
showParentalAnalysis conn = do
    studentData <- getStudentsData conn
    close conn
    let allTypes = map parental_level_of_education_parental studentData
    let distinctEduType = uniq  allTypes
    mapM_ (analyseEachType conn) distinctEduType
    print "Hello"

-- loopthough :: [String] -> [[String]]
loopthough [] = []
loopthough (x:xs) = (analyseEachType x) : loopthough xs 


-- analyseEachType :: Connection -> String -> [String]
analyseEachType conn level= do
    conn <- open "covid.sqlite"
    response <- getStudentsDataparentalEducation conn level
    
    let entries_count = length response
    let total_math_marks = sum (map math_parental response)
    let total_reading_marks = sum (map reading_parental response)
    let total_writing_marks = sum (map writing_parental response)
    
    let avg_math_score = div total_math_marks entries_count
    let avg_reading_score = div total_reading_marks entries_count
    let avg_writing_score = div total_writing_marks entries_count

    let analysedData = [level,(show avg_math_score),show avg_reading_score, show avg_writing_score]
    putStrLn $ makeDefaultSimpleTable [analysedData]
    -- analysedData : [parental_data]
    
    
    -- return analysedData
    
    -- print "analysedData"
    -- return analysedData

