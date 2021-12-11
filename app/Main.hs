module Main where

import Retrieve
import Lib
import System.IO
import DBFunctions
import DataModel
import DBFunctions (saveStudentBackgroundRecords)


main :: IO ()
main = do
    putStrLn "---------------------------------"
    print "Initializing System..."
    let url = "https://student-data-set.herokuapp.com/StudentDataSet/get-student-data"
    response <- pullData url
    putStrLn "---------------------------------"
    putStrLn "  Welcome to our Student Data Project  "
    putStrLn "  (1) Download data              "
    -- putStrLn "  (2) All entries by country     "
    putStrLn "  (3) Download Scores    "
    putStrLn "  (4) Quit                       "
    putStrLn "---------------------------------"
    conn <- createTables
    -- hSetBuffering stdout NoBuffering
    putStr "Choose an option: "
    option <- readLn :: IO Int
    case option of
        1 -> do
            putStr "Downloading Student Data..."
            response <- pullData url
            -- print response
            json <- pullData url
            print ""
            print "Parsing..."
            case (parseRequestToRecords json) of
                Left err -> print err
                Right details -> do
                    
                    print ""
                    print "Removing old data "
                    deleteOldEntries conn
                    print " - Done"
                    print "Saving on DB..."
                    -- print json
                    saveRecords conn (records1 details)
                    print "Saved!"
                    main
        2 -> do
            print "Downloading Student background Data..."
            json <- pullData url
            case (parseStudentBackgroundRequestToRecords json) of
                Left err -> print err
                Right details1 -> do
                    print "Saving on DB..."
                    -- print json
                    saveStudentBackgroundRecords conn (records details1)
                    print "Saved!"
                    main
        3 -> do
            print "Downloading Student Data..."
            response <- pullData url
            -- print response
            json <- pullData url
            print "Parsing..."
            case (parseRequestToRecordsScore json) of
                Left err -> print err
                Right details2 -> do
                    print "Saving on DB..."
                    -- print json
                    saveRecordsScore conn (records2 details2)
                    print "Saved!"
                    main
        4 -> print "Hope you've enjoyed using the app!"
        otherwise -> print "Invalid option"


    