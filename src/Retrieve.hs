module Retrieve
(
    pullData,
    parseRequestToRecords
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


renameFields "date" = "dateRep"
renameFields "continent" = "continentExp" 
renameFields "country" = "countriesAndTerritories" 
renameFields "population" = "popData2019"
renameFields other = other

customOptions = defaultOptions {
    fieldLabelModifier = renameFields
}


instance FromJSON Record where
    parseJSON = genericParseJSON customOptions

instance FromJSON Records

parseRequestToRecords :: L8.ByteString -> Either String Records 
parseRequestToRecords json = eitherDecode json :: Either String Records
 