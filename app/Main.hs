
{-|
Module      : Main Module
Description : Performs basic UI interactions
Copyright   : (c) Prashanth Gurunath, 2021
                  Mohit Agarwal,2021
                  Sakshi chhande,2021
License     : GPL-3
Maintainer  : ec21277@qmul.ac.uk
Stability   : experimental
Portability : POSIX

-}

module Main where

import Fetch
import System.IO
import Database
import Types
import Parental_edu
import GenderFilters
import ParseGradeDistribution
import AverageMarks
import Text.SimpleTableGenerator
import EthnicityFilters



-- let URL1 = https://students.free.beeceptor.com/students
-- let glitchURL = "https://student-data-set.glitch.me/studentData"

main :: IO ()
main = do
    let url = "https://student-data-set.herokuapp.com/StudentDataSet/get-student-data"


    putStrLn ""
    putStrLn "  Welcome to our Student Data Analysis Project (S.D.A.P.)"
    putStrLn $ makeDefaultSimpleTable [["(1)","Download"],["(2)","Average marks analysis"],["(3)","Analysis of marks based on Parental Education"],["(4)","Average marks based on Gender"],["(5)","Analysis based on Prep course taken vs not taken"],["(6)","Class Grade distribution - Fail/Pass/Distinction"],["(7)","Analysis according to Ethnicity"],["(8)","Quit"]]
    response <- pullData url
    conn <- createTables

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
            showGenderAnalysis conn 
            main
        5 -> do
            showAverageMarksBasedOnPrepAndNonPrep conn
            main
        6 -> do
            showGradeAnalysis conn
            main
        7 -> do
            showEthnicityAnalysis conn
            main
        8 -> print "Hope you've enjoyed using the app!"
        otherwise -> print "Invalid option"