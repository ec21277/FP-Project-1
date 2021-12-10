{-# LANGUAGE OverloadedStrings #-}

module DBFunctions (
    createTables
) where 

import DataModel
import Database.SQLite.Simple




createTables :: IO Connection
createTables = do
        conn <- open "covid.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS studentData (\
            \gender VARCHAR(6) NOT NULL, \
            \ethnicity VARCHAR(50) NOT NULL, \
            \parental_level_of_education VARCHAR(20) DEFAULT NULL, \
            \lunch VARCHAR(20) DEFAULT NULL, \
            \test_preparation_course VARCHAR(10) DEFAULT NULL, \
            \math INT DEFAULT NULL, \
            \reading INT DEFAULT NULL, \
            \writing INT DEFAULT NULL \
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS entries (\
            \date VARCHAR(40) NOT NULL, \
            \day VARCHAR(40) NOT NULL, \
            \month VARCHAR(40) NOT NULL, \
            \year VARCHAR(40) NOT NULL, \
            \cases INT DEFAULT NULL, \
            \deaths INT DEFAULT NULL, \
            \fk_country INTEGER\
            \)"
        return conn