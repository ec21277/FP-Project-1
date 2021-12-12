{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..),
    StudentScores(..)
) where
import GHC.Generics


data StudentScores = StudentScores{
    roll_no_score:: Int,
    math_score :: Int,
    reading_score :: Int, 
    writing_score :: Int
    } deriving (Show,Generic)

data StudentPersonalDetails = StudentPersonalDetails{
    roll_no:: Int,
    gender :: String,
    ethnicity :: String,
    parental_level_of_education :: String,
    math :: Int,
    reading :: Int, 
    writing :: Int,
    lunch :: String,
    test_preparation_course :: String
} deriving (Show,Generic)

data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped{
    records :: [StudentPersonalDetails]
} deriving (Show,Generic)
