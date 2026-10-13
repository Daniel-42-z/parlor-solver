module Main (main) where

import Data.Map qualified as Map
import Parlor (ParlorPuzzle, allValidSolutions)
import Puzzle (puzzle)

parlor :: ParlorPuzzle
parlor = Map.fromList puzzle

main :: IO ()
main = do
  mapM_ print $ allValidSolutions parlor
