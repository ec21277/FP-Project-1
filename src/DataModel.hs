{-# LANGUAGE DeriveGeneric #-}


module DataModel(
    Record(..),
    Records(..)
) where
import GHC.Generics

data Record = Record {
    gender :: String,
    ethnicity :: String,
    parental_lvel_of_education :: String,
    lunch :: String,
    test_preparation_course :: String,
    math :: Int,
    reading :: Int,
    writing :: Int   
} deriving (Show, Generic)

data Records = Records {
    records :: [Record]
} deriving (Show, Generic)
