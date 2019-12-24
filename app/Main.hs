module Main where

import           Lib

main :: IO ()
main = interact (render . astToDot . parse)
