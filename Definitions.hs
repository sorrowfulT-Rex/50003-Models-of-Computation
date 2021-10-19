module Definitions where

import Data.Map ( Map )
import Utilities ( addBrace, applyOn )

-- | Simple Expression:
-- E ::= v | n | E + E | E * E
data SimpleExp
  = EVar {var :: String}
  | Nmbr { num :: Integer }
  | Plus { exp1 :: SimpleExp, exp2 :: SimpleExp }
  | Prod { exp1 :: SimpleExp, exp2 :: SimpleExp }
  deriving (Eq)

{-# INLINE isNmbr #-}
{-# INLINE isPlus #-}
{-# INLINE isProd #-}
{-# INLINE isEVar #-}
isNmbr, isPlus, isProd, isEVar :: SimpleExp -> Bool
isNmbr Nmbr {} = True
isNmbr _       = False
isPlus Plus {} = True
isPlus _       = False
isProd Prod {} = True
isProd _       = False
isEVar EVar {} = True
isEVar _       = False

instance Show SimpleExp where
  show (Nmbr n) = show n
  show (EVar v) = v
  show (Plus e e')
    = show e ++
      " + " ++
      applyOn (isPlus e') addBrace (show e')
  show (Prod e e')
    = applyOn (isPlus e) addBrace (show e) ++
      " * " ++
      applyOn (not (isNmbr e' || isEVar e')) addBrace (show e')

instance Num SimpleExp where
  x + y       = Plus x y
  x * y       = Prod x y
  fromInteger = Nmbr
  abs         = undefined
  signum      = undefined
  negate      = undefined

-- | This is our entire language.
-- Command:
-- C ::= v = E | C; C | "skip" | "return" E
data Command
  = Asgn String SimpleExp
  | Command :+: Command
  | Skip
  | Ret SimpleExp
  deriving Eq

instance Show Command where
  show (Asgn v exp) = v ++ " := " ++ show exp
  show (c :+: c')   = show c ++ "\n" ++ show c'
  show Skip         = "[LINE FINISHED]"
  show (Ret exp)    = show exp

-- | The "State" or "Context" of the expression.
type Context = Map String SimpleExp
