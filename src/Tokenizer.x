{
module Tokenizer where
import Data.Tokens (Token(..))
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-
    $white+     ;
    "("         { const TLeftP  }
    ")"         { const TRightP }
    "["         { const TLeftQ  }
    "]"         { const TRightQ }
    "+"         { const TPlus   }
    "-"         { const TMinus  }
    "*"         { const TMul    }
    "/"         { const TDiv    }
    $digit+     { TNum . read   }
    $alpha+     { TVar          }

{
}
