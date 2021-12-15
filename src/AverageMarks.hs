{-# LANGUAGE OverloadedStrings #-}

module AverageMarks(
    showAverageMarks
)
where
import DataModel
import Database.SQLite.Simple
    ( query, field, Connection, FromRow(..), close )
-- import Data.List
import Text.SimpleTableGenerator

average_data = [] :: [String]

instance FromRow StudentAverageData where
  fromRow = StudentAverageData <$> field <*> field <*> field <*> field  

getStudentsDataForAverageMarks :: Connection -> IO [StudentAverageData]
getStudentsDataForAverageMarks conn = do
    let roll_no = 1 :: Int 
    let sql_query = "Select studentData.roll_no,math,reading,writing FROM studentData INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND 1=?"
    query conn sql_query [roll_no]

getAverageMarks :: Connection  -> IO [StudentAverageData ]
getAverageMarks conn = do
    let roll_no = 1 :: Int 
    let sql_query = "Select studentData.roll_no, AVG( reading ) FROM `studentData` INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND 1=?"
    query conn sql_query [roll_no]

    -- avg :: Int -> Int -> Float

showAverageMarks :: Connection -> IO ()
showAverageMarks conn = do
    print "student avg marks:: "
    studentData <- getAverageMarks conn
    print studentData
    close conn
    print "showAverageMarks fn"
