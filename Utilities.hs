{-# LANGUAGE FlexibleContexts #-}

module Utilities where
import Data.Maybe ( fromJust, isJust )
import Control.Monad.Identity ( Identity )
import Text.Parsec ( Parsec, Stream )
import Text.Parsec.Char ( char, digit, oneOf )
import Text.Parsec.Prim ( Stream, Parsec, many, try )
import Control.Monad ( void )

-- | Add a pair of round braces to the String.
{-# INLINE addBrace #-}
addBrace :: String -> String
addBrace = ('(' :) . (++ ")")

-- | Apply a function if the predicate is True.
{-# INLINE applyOn #-}
applyOn :: Bool -> (a -> a) -> a -> a
applyOn p f a = if p then f a else a

-- | Ignore blankspace.
{-# INLINE eatBlankSpace #-}
eatBlankSpace :: Stream s Identity Char => Parsec s u [Char]
eatBlankSpace = many (char ' ');

-- | Parse a decimal digit.
int :: Stream s Identity Char => Parsec s u Integer
int = read <$> do
  f <- oneOf "-0123456789"
  r <- many digit
  void (try (void $ many $ char ' '))
  return (f : r)
