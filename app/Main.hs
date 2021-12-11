module Main where

import Retrieve
import Lib
import System.IO
import DBFunctions
import DataModel

-- let URL1 = https://students.free.beeceptor.com/students
-- let glitchURL = "https://student-data-set.glitch.me/studentData"

main :: IO ()
main = do
    print "Initializing System..."
    let url = "https://students.free.beeceptor.com/students"
    response <- pullData url
    -- parsedData <- parseRequest response
    print response
    putStrLn "---------------------------------"
    putStrLn "  Welcome to our Student Data Project  "
    putStrLn "  (1) Download data              "
    -- putStrLn "  (2) All entries by country     "
    -- putStrLn "  (3) Total cases by country     "
    putStrLn "  (4) Quit                       "
    putStrLn "---------------------------------"
    conn <- createTables
    -- hSetBuffering stdout NoBuffering
    putStr "Choose an option: "
    option <- readLn :: IO Int
    case option of
        1 -> do
            let url = "https://students1.free.beeceptor.com/students"
            print "Downloading Student Data..."
            response <- pullData url
            print response
            json <- pullData url
            print "Parsing..."
            case (parseRequestToRecords json) of
                Left err -> print err
                Right details -> do
                    print "Saving on DB..."
                    print json
                    saveRecords conn (records details)
                    print "Saved!"
                    main
        -- 2 -> do
        --     entries <- queryCountryAllEntries conn
        --     mapM_ print entries
        --     main
        -- 3 -> do
        --     queryCountryTotalCases conn
        --     main
        4 -> print "Hope you've enjoyed using the app!"
        otherwise -> print "Invalid option"