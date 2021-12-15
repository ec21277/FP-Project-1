module Main where

import Retrieve
import Lib
import System.IO
import DBFunctions
import DataModel
import Parental_edu
import GenderFilters


-- let URL1 = https://students.free.beeceptor.com/students
-- let glitchURL = "https://student-data-set.glitch.me/studentData"

main :: IO ()
main = do
    putStrLn ""
    putStrLn ""
    putStrLn "---------------------------------"
    putStrLn   "       Initializing System."
    putStrLn "---------------------------------"
    let url = "https://student-data-set.herokuapp.com/StudentDataSet/get-student-data"
    response <- pullData url
    putStrLn "---------------------------------"
    putStrLn "  Welcome to our Student Data Project  "
    putStrLn "  (1) Download data              "
    putStrLn "  (3) Marks by Gender   "
    putStrLn "  (2) Analysis on Parental education     "
    -- putStrLn "  (3) Total cases by country     "
    putStrLn "  (4) Quit                       "
    putStrLn "---------------------------------"
    conn <- createTables
    -- hSetBuffering stdout NoBuffering
    -- let option = 2  :: Int
    
    option <- readLn :: IO Int
    case option of
        1 -> do
            putStrLn ""
            putStr "Downloading Student Data "
            response <- pullData url
            json <- pullData url
            putStrLn " - Done"
            putStr "Parsing..."
            case (parseRequestToRecords json) of
                Left err -> print err
                Right details -> do
                    
                    putStrLn ""
                    putStr " - Removing old Data from DB "
                    deleteOldEntries conn
                    putStrLn " - Done"
                    putStr " - Saving new data in DB "
                    saveRecords conn (records details)
                    putStrLn "- Done"
                    putStrLn "------- Finished Tasks -------"

                    getGenderRatio conn

                    -- -- getStudentBestSubject conn
                    -- -- getBestMarks conn
                    -- getGenderMinMax conn
                    -- getMinMaxMarksGender conn

                    main
        2 -> do 
            showParentalAnalysis conn
            main
        3 -> do
            showGenderAnalysis conn
            main            
        4 -> print "Hope you've enjoyed using the app!"
        otherwise -> print "Invalid option"