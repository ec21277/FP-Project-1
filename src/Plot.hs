{-# LANGUAGE OverloadedStrings #-}


module Plot (
    plotChart
)
 where 
import Lucid
    ( renderText,
      body_,
      charset_,
      doctypehtml_,
      head_,
      meta_,
      ToHtml(toHtml) )
import Lucid.Html5
import Graphics.Plotly
import Graphics.Plotly.Lucid
import Lens.Micro
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as T
import qualified Data.Text as DT
import GHC.Float
import Data.Text.Internal.Builder (toLazyText)
import Data.ByteString (pack)
import qualified Data.ByteString as D

-- plotChart :: String -> [Double] -> [(String,Double)]
plotChart fileName marks =
    
    T.writeFile fileName $ renderText $ doctypehtml_ $ do
    head_ $ do meta_ [charset_ "utf-8"]
            -- & layout . title ?~"Average Marks"
               plotlyCDN
    body_ $ toHtml $ plotly "myDiv" [myTrace marks]

pointsData :: [Int] -> [(String, Int)]
pointsData marks = zip ["Math","Reading","Writing"] marks

myTrace marks
  = hbars (aes & y .~ fst
                & x .~ snd) (pointsData marks)
        


-- plotGraph dates closePrices =

-- T.writeFile "plot.html" $ renderText $ doctypehtml_ $ do

-- head_ $ do meta_ [charset_ "utf-8"]

-- plotlyCDN

-- body_ $ toHtml $ plotly "myDiv" [myTrace dates closePrices]

-- & layout . title ?~ "Closing Price by Date"

-- pointsData :: [String] -> [Float] -> [(String, Double)]

-- pointsData dates closePrices = zip dates (map float2Double closePrices)



-- myTrace dates closePrices

-- = line (aes & x .~ fst

-- & y .~ snd) (pointsData dates closePrices)