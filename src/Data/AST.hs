{-# LANGUAGE OverloadedStrings #-}

module Data.AST
  ( AST(..)
  , astToDot
  ) where

import           Data.Function (on)
import           Data.GraphViz
import           Data.Map      as M
import           Data.Set      as S

data AST
  = Imm Int
  | Arg Int
  | Add AST AST
  | Sub AST AST
  | Mul AST AST
  | Div AST AST
  deriving (Eq,Ord,Show)

{-
instance Eq AST where
  Add a b == Add c d = (a == c && b == d) || (a == d && b == c)
  Mul a b == Mul c d = (a == c && b == d) || (a == d && b == c)
  Sub a b == Sub c d = a == c && b == d
  Div a b == Div c d = a == c && b == d
  Imm a == Imm b = a == b
  Arg a == Arg b = a == b
  _ == _ = False

instance Ord AST where
  Imm a <= Imm b = a <= b
  Arg a <= Arg b = a <= b
  Add a b <= Add c d = (a <= c && a <= d) || (b <= c && b <= d)
  Mul a b <= Mul c d = (a <= c && a <= d) || (b <= c && b <= d)
  Sub a b <= Sub c d = (a <= c && a <= d) || (b <= c && b <= d)
  Div a b <= Div c d = (a <= c && a <= d) || (b <= c && b <= d)
  Imm a <= _ = True
  Arg a <= Imm _ = False
  Arg a <= _ = True
  Add _ _ <= Imm _ = False
  Add _ _ <= Arg _ = False
  Add _ _ <= _ = True
  Mul _ _ <= Sub _ _ = True
  Mul _ _ <= Div _ _ = True
  Mul _ _ <= _ = False
  Sub _ _ <= Div _ _ = True
  Sub _ _ <= _ = False
  Div _ _ <= _ = False

-}

subASTs p@(Add a b) = S.insert p ((S.union `on` subASTs) a b)
subASTs p@(Sub a b) = S.insert p ((S.union `on` subASTs) a b)
subASTs p@(Mul a b) = S.insert p ((S.union `on` subASTs) a b)
subASTs p@(Div a b) = S.insert p ((S.union `on` subASTs) a b)
subASTs p           = S.singleton p

astMap p = M.fromList $ S.toList (subASTs p) `zip` [0 ..]

astToDotNode m x =
  let p = M.findWithDefault 0 x m
   in astToDotNode' p x

astToDotNode' m (Imm x)   = DotNode m [toLabel x, shape BoxShape]
astToDotNode' m (Arg x)   = DotNode m [toLabel x, shape Box3D]
astToDotNode' m (Add _ _) = DotNode m [textLabel "+", shape Circle]
astToDotNode' m (Sub _ _) = DotNode m [textLabel "-", shape Circle]
astToDotNode' m (Mul _ _) = DotNode m [textLabel "*", shape Circle]
astToDotNode' m (Div _ _) = DotNode m [textLabel "/", shape Circle]

astToNodes m x = S.map (astToDotNode m) $ subASTs x

astToEdges m = astToEdges'
  where
    astToId x = findWithDefault 0 x m
    astToEdges' p@(Add a b) =
      [DotEdge (astToId a) (astToId p) [], DotEdge (astToId b) (astToId p) []] ++ astToEdges' a ++ astToEdges' b
    astToEdges' p@(Sub a b) =
      [DotEdge (astToId a) (astToId p) [], DotEdge (astToId b) (astToId p) []] ++ astToEdges' a ++ astToEdges' b
    astToEdges' p@(Mul a b) =
      [DotEdge (astToId a) (astToId p) [], DotEdge (astToId b) (astToId p) []] ++ astToEdges' a ++ astToEdges' b
    astToEdges' p@(Div a b) =
      [DotEdge (astToId a) (astToId p) [], DotEdge (astToId b) (astToId p) []] ++ astToEdges' a ++ astToEdges' b
    astToEdges' _ = []

astToDot :: AST -> DotGraph Int
astToDot x =
  let m = astMap x
   in DotGraph
        { strictGraph = False
        , directedGraph = True
        , graphID = Nothing
        , graphStatements =
            DotStmts {attrStmts = [], subGraphs = [], nodeStmts = S.toList $ astToNodes m x, edgeStmts = astToEdges m x}
        }
