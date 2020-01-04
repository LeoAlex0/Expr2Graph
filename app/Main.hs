module Main where

import           Lib

main :: IO ()
main = putStrLn . render . astToDot . parse =<< getLine

