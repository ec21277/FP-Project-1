{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    StudentDataParental(..),
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..),
    StudentScores(..),
    StudentScoreGender(..)
) where
import GHC.Generics


data StudentDataParental = StudentDataParental {
    roll_no_parental :: Int,
    gender_parental :: String,
    parental_level_of_education_parental :: String,
    math_parental :: Int,
    reading_parental :: Int,
    writing_parental :: Int
} deriving (Show,Generic)

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

data StudentScoreGender = StudentScoreGender {
    roll_no_gen :: Int,
    math_marks:: Int,
    reading_marks :: Int,
    writing_marks :: Int,
    gender_marks :: String
} deriving (Show, Generic)

data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped{
    records :: [StudentPersonalDetails]
} deriving (Show,Generic)
