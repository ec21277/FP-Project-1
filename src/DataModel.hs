{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    -- Record(..),
    -- Records(..),
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..),
    StudentScores(..),
    StudentScoresGrouped(..)
) where
import GHC.Generics

-- data Record = Record {
--     roll_no:: Int,
--     gender :: String,
--     ethnicity :: String,
--     parental_level_of_education :: String
-- } deriving (Show, Generic)

-- data Records = Records {
--     records :: [Record]
-- } deriving (Show, Generic)

data StudentPersonalDetails = StudentPersonalDetails{
    roll_no:: Int,
    gender :: String,
    ethnicity :: String,
    parental_level_of_education :: String
} deriving (Show,Generic)

data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped{
    records1 :: [StudentPersonalDetails]
} deriving (Show,Generic)

data StudentScores = StudentScores{
    roll_no_sc :: Int,
    math :: Int,
    reading :: Int, 
    writing :: Int
}deriving(Show,Generic)

data StudentScoresGrouped = StudentScoresGrouped{
    records :: [StudentScores]
} deriving (Show,Generic)