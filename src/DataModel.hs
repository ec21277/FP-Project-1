{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    -- Record(..),
    -- Records(..),
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..),
    StudentBackgroundDetails(..),
    StudentBackgroundDetailsGrouped(..)
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

data StudentBackgroundDetails = StudentBackgroundDetails{
    student_roll_no:: Int,
    lunch :: String,
    test_preparation_course :: String
} deriving (Show,Generic)


data StudentBackgroundDetailsGrouped = StudentBackgroundDetailsGrouped{
    records :: [StudentBackgroundDetails]
} deriving (Show,Generic)

data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped{
    records1 :: [StudentPersonalDetails]
} deriving (Show,Generic)
