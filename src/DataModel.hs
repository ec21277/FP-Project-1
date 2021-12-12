{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    StudentPersonalDetails(..),
    StudentPersonalDetailsGrouped(..)
) where
import GHC.Generics

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
