import Lib

testCode = [
    "[a b] a*a+2*a*b+b*b-(a+b)*(a+b)",
    "[a b] a*a+a*b+b*a+b*b-(a+b)*(a-b)",
    "[a b c ] (a+b+c)*3-a*b*c"
  ]

main :: IO ()
main = putStrLn $ render $ astToDot $ parse $ testCode!!2
