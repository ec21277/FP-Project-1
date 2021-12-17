{-# LANGUAGE OverloadedStrings #-}

{-|
Module      : AverageMarks
Description : Module extracts and analyses the average marks of student based on their performance in each subject
Stability   : experimental
Portability : POSIX

-}

module AverageMarks(
    showAverageMarksBasedOnPrepAndNonPrep
)
where
import Types
import Database.SQLite.Simple
    ( query, field, Connection, FromRow(..), close )
-- import Data.List
import Text.SimpleTableGenerator
import Plot

average_data = [] :: [String]

instance FromRow StudentAverageData where
  fromRow = StudentAverageData <$> field <*> field <*> field <*> field  <*> field  

-- |Compare the marks scored by students who took 
--test prep and marks of students who didn't take it
averageMarksForNoTestPrep :: Connection -> IO [StudentAverageData]
averageMarksForNoTestPrep conn = do
    let test_prep = "none" :: String 
    let sql_query = "Select studentScores.roll_no ,math,reading,writing, studentBackgroundDetails.test_preparation_course FROM studentScores INNER JOIN studentBackgroundDetails ON studentBackgroundDetails.roll_no = studentScores.roll_no AND test_preparation_course=?"
    query conn sql_query [test_prep]

averageMarksForCompletedTestPrep :: Connection -> IO [StudentAverageData]
averageMarksForCompletedTestPrep conn = do
    let test_prep = "completed" :: String 
    let sql_query = "Select studentScores.roll_no ,math,reading,writing, studentBackgroundDetails.test_preparation_course FROM studentScores INNER JOIN studentBackgroundDetails ON studentBackgroundDetails.roll_no = studentScores.roll_no AND test_preparation_course=?"
    query conn sql_query [test_prep]


showAverageMarksBasedOnPrepAndNonPrep :: Connection -> IO()
showAverageMarksBasedOnPrepAndNonPrep conn = do
    score_response1 <- averageMarksForNoTestPrep conn
    let entries_count = length score_response1
    let total_math_marks = sum (map math_for_avg score_response1)
    let total_reading_marks = sum (map reading_for_avg score_response1)
    let total_writing_marks = sum (map writing_for_avg score_response1)
    
    let avg_math_score = div total_math_marks entries_count
    let avg_reading_score = div total_reading_marks entries_count
    let avg_writing_score = div total_writing_marks entries_count

    putStrLn $ makeDefaultSimpleTable [["    ","Math","Reading","Writing"], ["Total",(show total_math_marks),(show total_reading_marks),(show total_writing_marks)], ["Average", (show avg_math_score),(show avg_reading_score),(show avg_writing_score)]]


    score_response1 <- averageMarksForCompletedTestPrep conn
    let entries_count = length score_response1

    -- | Find total marks of the 3 subjects individually
    let total_math_marks = sum (map math_for_avg score_response1)
    let total_reading_marks = sum (map reading_for_avg score_response1)
    let total_writing_marks = sum (map writing_for_avg score_response1)
    
    -- | average = total marks / total count
    let avg_math_score = div total_math_marks entries_count
    let avg_reading_score = div total_reading_marks entries_count
    let avg_writing_score = div total_writing_marks entries_count

    putStrLn $ makeDefaultSimpleTable [["    ","Math","Reading","Writing"], ["Total",(show total_math_marks),(show total_reading_marks),(show total_writing_marks)], ["Average", (show avg_math_score),(show avg_reading_score),(show avg_writing_score)]]

    putStrLn " It is seen that students who took the preperation course scored higher overall compared to ones who didnt take the course."
    plotChart "AverageMarks.html" [avg_math_score,avg_reading_score,avg_writing_score]