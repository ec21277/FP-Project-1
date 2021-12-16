module Fetch
(
    pullData,
    parseRequestToRecords
) where



import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Simple
import Types
import Data.Aeson


type URL = String

-- | Fetches the data from given URL
pullData :: URL -> IO L8.ByteString
pullData url = do 
    request <- parseRequest url
    response <- httpLBS request
    return $ getResponseBody response



renameFields "math" = "math"
renameFields other = other

customOptions = defaultOptions {
    fieldLabelModifier = renameFields
}


instance FromJSON StudentPersonalDetails where
    parseJSON = genericParseJSON customOptions

instance FromJSON StudentPersonalDetailsGrouped

parseRequestToRecords :: L8.ByteString -> Either String StudentPersonalDetailsGrouped 
parseRequestToRecords json = eitherDecode json :: Either String StudentPersonalDetailsGrouped
 