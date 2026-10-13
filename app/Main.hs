module Main (main) where

import Data.Map qualified as Map
import Parlor (Color (Black, Blue, White), ParlorPuzzle, allValidSolutions)
import Statement

parlor :: ParlorPuzzle
parlor =
  Map.fromList
    [ (Blue, [someBox someTrue empty, someBox someFalse empty, empty White]),
      (White, [someBox allTrue empty, empty Black, orStatement (empty White) (empty Black)]),
      (Black, [someBox (\c -> more (boxFalseStatementsCount c) (constCnt 1)) (empty), empty Black, someBox allFalse empty])
    ]

main :: IO ()
main = do
  mapM_ print $ allValidSolutions parlor
