{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    Record(..),
    Records(..),
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..)
) where
import GHC.Generics

data Record = Record {
    roll_no:: Int,
    gender :: String,
    ethnicity :: String,
    parental_level_of_education :: String
} deriving (Show, Generic)

data Records = Records {
    records :: [Record]
} deriving (Show, Generic)

data StudentPersonalDetails = StudentPersonalDetails{
    roll_no1:: Int,
    gender1 :: String,
    ethnicity1 :: String,
    parental_level_of_education1 :: String
} deriving (Show,Generic)

-- data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped{
--     details :: [StudentPersonalDetails]
-- } deriving (Show,Generic)

data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped {
    records1 :: [Record]
} deriving (Show, Generic)