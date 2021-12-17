{-# LANGUAGE OverloadedStrings #-}

module EthnicityFilters(
showEthnicityAnalysis
)
where
import Types
import Database.SQLite.Simple
import Data.List
import Text.SimpleTableGenerator
import Lucid
    ( renderText,
      body_,
      charset_,
      doctypehtml_,
      head_,
      meta_,
      ToHtml(toHtml) )
import Lucid.Html5
import Graphics.Plotly
import Graphics.Plotly.Lucid
import Lens.Micro
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as T
import qualified Data.Text as DT
import GHC.Float
import Data.Text.Internal.Builder (toLazyText)
import Data.ByteString (pack)
import qualified Data.ByteString as D
import Plot

ethnicity_data = [] :: String 

-- | Get Unique values from List
uniq :: Eq a => [a] -> [a]
uniq [] = []
uniq (x:xs) = (if x `elem` xs then id else (x:)) $ uniq xs

-- | To define the row of the SQL Query result
instance FromRow StudentScoreEthnicity where
  fromRow = StudentScoreEthnicity <$> field <*> field <*> field <*> field <*> field  

-- | This function fetches the marks for all students along with their ethnicity
getEthnicity :: Connection -> IO [StudentScoreEthnicity]
getEthnicity conn = do
    let sql_query = "Select studentData.roll_no,math,reading,writing,ethnicity FROM studentData INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no"
    query conn sql_query ()

-- | This function selects the data for a particular ethnicity 
getStudentDataEthnicity conn level = do
    let sql_query = "Select studentData.roll_no,math,reading,writing,ethnicity FROM studentData INNER JOIN studentScores ON studentData.roll_no = studentScores.roll_no AND studentData.ethnicity = ?"
    query conn sql_query [level]

-- | Fetches distinct type of ethnicity and then performs analysis for each type
showEthnicityAnalysis :: Connection -> IO ()
showEthnicityAnalysis conn = do
    studentData <- getEthnicity conn
    let allTypes = map ethnicity_marks studentData
    let distinctEthnicityType = uniq allTypes
    mapM_ (analyseEachType conn) distinctEthnicityType


-- loopthough :: [String] -> [[String]]
loopthough [] = []
loopthough (x:xs) = (analyseEachType x) : loopthough xs 

-- | calculates average marks for each type 
analyseEachType conn level= do
    response <- getStudentDataEthnicity conn level

    let entries_count = length response
    let total_math_marks = sum (map math_marks_eth response)
    let total_reading_marks = sum (map reading_marks_eth response)
    let total_writing_marks = sum (map writing_marks_eth response)
    
    let avg_math_score = div total_math_marks entries_count
    let avg_reading_score = div total_reading_marks entries_count
    let avg_writing_score = div total_writing_marks entries_count
    let heading = ["Level","Avg in Math","Avg in Reading", "Avg in Writing"]
    let analysedData = [level,(show avg_math_score),show avg_reading_score, show avg_writing_score]

    putStrLn $ makeDefaultSimpleTable [heading,analysedData]

    plotChart "ethnicity.html" [avg_math_score,avg_reading_score,avg_writing_score]


