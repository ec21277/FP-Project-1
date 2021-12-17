{-# LANGUAGE OverloadedStrings #-}

module ParseGradeDistribution(
    showGradeAnalysis
)
where
import Types
import Database.SQLite.Simple
import Data.List
import Text.SimpleTableGenerator
import Plot

instance FromRow StudentGrades where
  fromRow = StudentGrades <$> field <*> field <*> field  

getScores :: Connection -> IO [StudentGrades]
getScores conn = do
    let roll_no = 1 :: Int 
    execute_ conn "CREATE TEMPORARY TABLE IF NOT EXISTS temp_table AS SELECT roll_no, math+ writing+reading as totalScores from studentScores;"
    let sql_query = "WITH distinction_value AS (SELECT count(roll_no) as distinction FROM temp_table where totalScores > 210 ), pass_values AS (SELECT count(roll_no) as pass FROM temp_table totalScores WHERE totalScores >= 150 AND totalScores <= 210), fail_values AS (SELECT count(roll_no) as fail FROM temp_table where totalScores < 150) SELECT distinction,pass,fail from studentData,distinction_value,pass_values,fail_values where studentData.roll_no = 1"
    query conn sql_query ()

showGradeAnalysis :: Connection -> IO ()
showGradeAnalysis conn = do
    studentData <- getScores conn
    let distinction_num = map distinction studentData
    let pass_num = map pass studentData
    let fail_num = map failure studentData

    let printableResponse = [["Student Grade Distribution","Students with Distinction","Students with Pass","Students who Failed"],["Number",show (distinction_num),show (pass_num),show (fail_num )]]
    putStrLn $ makeDefaultSimpleTable printableResponse



