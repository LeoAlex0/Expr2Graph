module Lib
  ( simpleRender
  , parse
  , astToDot
  , render
  ) where

import           Data.AST               (astToDot)
import           Data.Graph.Inductive   (Graph)
import           Data.GraphViz          (graphToDot, nonClusteredParams, toDot)
import           Data.GraphViz.Printing (DotCode, PrintDot, renderDot)
import           Data.Text.Lazy         (Text, unpack)
import           Parser                 (parser)
import           Tokenizer              (alexScanTokens)

simpleRender :: (Graph gr) => gr nl el -> Text
simpleRender = renderDot . toDot . graphToDot nonClusteredParams

parse = parser . alexScanTokens

render :: (PrintDot a) => a -> String
render = unpack . renderDot . toDot
