{
module Parser where
import Data.Tokens
import qualified Data.Map as M
import Data.AST
}

%name parser
%tokentype  { Token }
%error      { parseError }

%token
    '['     { TLeftQ    }
    ']'     { TRightQ   }
    '('     { TLeftP    }
    ')'     { TRightP   }
    '+'     { TPlus     }
    '-'     { TMinus    }
    '*'     { TMul      }
    '/'     { TDiv      }
    Var     { TVar $$   }
    Num     { TNum $$   }

%%

func :: { AST }
func : '[' args ']' expr    { $4 $ M.fromList $ zip $2 [0..] }

args :: { [String] }
args : Var args             { $1:$2 }
     | {- empty -}          { []    }


expr :: { M.Map String Int -> AST }
expr : term                 { $1 }
     | expr '+' term        { \m -> $1 m `Add` $3 m }
     | expr '-' term        { \m -> $1 m `Sub` $3 m }

term :: { M.Map String Int -> AST }
term : fact                 { $1 }
     | term '*' fact        { \m -> $1 m `Mul` $3 m }
     | term '/' fact        { \m -> $1 m `Div` $3 m }

fact :: { M.Map String Int -> AST }
fact : Num                  { const $ Imm $1 }
     | Var                  { \m -> let Just i = M.lookup $1 m in Arg i }
     | '(' expr ')'         { $2 }

{
parseError = error "ParseError"
}
