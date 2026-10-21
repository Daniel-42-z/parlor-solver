module Main (main) where

import Data.Map qualified as Map
import Parlor (ParlorPuzzle, allValidSolutions, processSolutions)
import Puzzle (puzzle)

parlor :: ParlorPuzzle
parlor = Map.fromList puzzle

main :: IO ()
main = do
  let allSols = allValidSolutions parlor
  putStrLn "All possible states:"
  mapM_
    ( \x -> do
        putStrLn ""
        print x
    )
    allSols
  putStrLn ""
  putStrLn "Final solution:"
  print $ processSolutions allSols
