module Main where

import Fetch
import Lib
import System.IO
import Database
import Types
import Parental_edu
import GenderFilters
import ParseGradeDistribution
import AverageMarks


-- let URL1 = https://students.free.beeceptor.com/students
-- let glitchURL = "https://student-data-set.glitch.me/studentData"

main :: IO ()
main = do
    putStrLn ""
    putStrLn "---------------------------------"
    putStrLn   "       Initializing System."
    putStrLn "---------------------------------"
    let url = "https://student-data-set.herokuapp.com/StudentDataSet/get-student-data"
    response <- pullData url
    putStrLn "---------------------------------"
    putStrLn "  Welcome to our Student Data Analysis Project (S.D.A.P.)"
    putStrLn "  (1) Download                    "
    putStrLn "  (2) Average marks analysis      "
    putStrLn "  (3) Analysis of marks based on Parental Education "
    putStrLn "  (4) Average marks based on gender"
    putStrLn "  (5) Lowest/highest marks of a specific student based on r_no"
    putStrLn "  (6) List of ppl whose average is more than 50     "
    putStrLn "  (7) Class Grade distribution - Fail/Pass/Distinction"
    putStrLn "  (8)                                                 "
    putStrLn "  (9) Quit                       "
    putStrLn "---------------------------------"
    conn <- createTables
    -- hSetBuffering stdout NoBuffering
    -- let option = 3 :: Int
    
    option <- readLn :: IO Int
    case option of
        1 -> do
            putStrLn ""
            -- | Downloads, parses data
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
                    main
        2 -> do
            averageMarksInGeneral conn
            main
        3 -> do
            showParentalAnalysis conn
            main
        4 -> do
            -- Add sakshi's function here
            showGenderAnalysis conn 
            main
        5 -> do
            -- #TODO
            showAverageMarksBasedOnPrepAndNonPrep conn
        6 -> do
            -- #TODO
            showAverageMarksBasedOnPrepAndNonPrep conn
        7 -> do
            showGradeAnalysis conn
            main
        8 -> print "Hope you've enjoyed using the app!"
        otherwise -> print "Invalid option"