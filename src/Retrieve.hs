module Retrieve
(
    pullData,
    parseRequestToRecords,
    parseRequestToRecordsScore,
    parseStudentBackgroundRequestToRecords

) where


import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Simple
import DataModel
import Data.Aeson


type URL = String

pullData :: URL -> IO L8.ByteString
pullData url = do 
    request <- parseRequest url
    response <- httpLBS request
    return $ getResponseBody response


renameFields1 "roll_no_sc" = "roll_no"
renameFields1 other = other

renameFields2 "student_roll_no" = "roll_no"
renameFields2 other = other

renameFields "date" = "dateRep"
renameFields "continent" = "continentExp" 
renameFields "country" = "countriesAndTerritories" 
renameFields "population" = "popData2019"
renameFields other = other

customOptions = defaultOptions {
    fieldLabelModifier = renameFields
}


customOptions1 = defaultOptions {
    fieldLabelModifier = renameFields1 
}
customOptions2 = defaultOptions {
    fieldLabelModifier = renameFields2
}


instance FromJSON StudentPersonalDetails where
    parseJSON = genericParseJSON customOptions

instance FromJSON StudentPersonalDetailsGrouped


parseRequestToRecords :: L8.ByteString -> Either String StudentPersonalDetailsGrouped 
parseRequestToRecords json = eitherDecode json :: Either String StudentPersonalDetailsGrouped
 
 
instance FromJSON StudentScores where
    parseJSON = genericParseJSON customOptions1

instance FromJSON StudentScoresGrouped

parseRequestToRecordsScore :: L8.ByteString -> Either String StudentScoresGrouped 
parseRequestToRecordsScore json = eitherDecode json :: Either String StudentScoresGrouped



instance FromJSON StudentBackgroundDetails where
    parseJSON = genericParseJSON customOptions2
    
instance FromJSON StudentBackgroundDetailsGrouped


parseStudentBackgroundRequestToRecords :: L8.ByteString -> Either String StudentBackgroundDetailsGrouped 
parseStudentBackgroundRequestToRecords json = eitherDecode json :: Either String StudentBackgroundDetailsGrouped
 
