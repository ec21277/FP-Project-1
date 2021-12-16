{-# LANGUAGE DeriveGeneric #-}


module Types(
    StudentDataParental(..),
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..),
    StudentScores(..),
    StudentAverageData(..)
) where
import GHC.Generics


{- 
Creates data models StudentDataParental, StudentAverageData,
                    StudentScores,       StudentPersonalDetails
-}

data StudentDataParental = StudentDataParental {
    roll_no_parental :: Int,
    gender_parental :: String,
    parental_level_of_education_parental :: String,
    math_parental :: Int,
    reading_parental :: Int,
    writing_parental :: Int
} deriving (Show,Generic)

data StudentAverageData = StudentAverageData {
    roll_no_for_avg :: Int,
    math_for_avg :: Int,
    reading_for_avg :: Int,
    writing_for_avg :: Int,
    test_preparation_course_for_avg :: String
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

data StudentPersonalDetailsGrouped = StudentPersonalDetailsGrouped{
    records :: [StudentPersonalDetails]
} deriving (Show,Generic)
