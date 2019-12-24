module Data.Tokens(Token(..)) where

data Token =
    TLeftQ      |
    TRightQ     |
    TLeftP      |
    TRightP     |
    TPlus       |
    TMinus      |
    TMul        |
    TDiv        |
    TVar String |
    TNum Int    deriving (Show,Eq)
