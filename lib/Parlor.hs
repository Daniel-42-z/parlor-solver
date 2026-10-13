module Parlor
  ( ParlorStatement,
    StatementPos,
    ParlorPuzzle,
    ParlorSolution (..),
    checkSolution,
    Color (..),
    allValidSolutions,
    statementsOfColor,
    truthValuesOfColor,
  )
where

import Data.Function ((&))
import Data.Map (Map)
import Data.Map qualified as Map

data Color = Blue | White | Black deriving (Eq, Ord, Show)

data ParlorSolution = ParlorSolution
  { answer :: Color,
    truthValuesMap :: Map Color [Bool]
  }
  deriving (Eq)

instance Show ParlorSolution where
  show (ParlorSolution ans tvs) = "Gem in " ++ show ans ++ " box." ++ "\n" ++ "Truth values for each box:\n" ++ show (Map.toList tvs)

type StatementPos = (Color, Int)

type ParlorStatement = StatementPos -> ParlorSolution -> Bool -- Returns true if statement doesn't contradict input state

condFlip :: ParlorStatement -> Bool -> ParlorStatement
condFlip st b = if b then st else (not .) . st

type ParlorPuzzle = Map Color [ParlorStatement]

statementsOfColor :: ParlorPuzzle -> Color -> [ParlorStatement]
statementsOfColor pzl color = Map.findWithDefault [] color pzl

truthValuesOfColor :: ParlorSolution -> Color -> [Bool]
truthValuesOfColor (ParlorSolution _ tss) color = Map.findWithDefault [] color tss

validSolution :: ParlorSolution -> Bool
validSolution sol = any (\bs -> not (null bs) && and bs) ts && any (\bs -> not (null bs) && all (== False) bs) ts
  where
    ts = Map.elems (truthValuesMap sol)

checkSolution :: ParlorPuzzle -> ParlorSolution -> Bool
checkSolution pzl solution
  | not $ validSolution solution = False
  | Map.map length pzl /= Map.map length (truthValuesMap solution) = False
  | otherwise =
      [Blue, White, Black]
        & map
          ( \color ->
              let (statements, truthValues) = (statementsOfColor pzl color, truthValuesOfColor solution color)
                  consistencies = zipWith3 (\i statement truthValue -> condFlip statement truthValue (color, i) solution) [0 ..] statements truthValues
               in and consistencies
          )
        & and

allValidSolutions :: ParlorPuzzle -> [ParlorSolution]
allValidSolutions pzl =
  let allBoolLists :: Int -> [[Bool]]
      allBoolLists 0 = [[]]
      allBoolLists n = (map (True :) $ allBoolLists (n - 1)) ++ (map (False :) $ allBoolLists (n - 1))
      allTruthValueMaps :: [Map Color [Bool]]
      allTruthValueMaps =
        [ [ (Blue, blueTvs),
            (White, whiteTvs),
            (Black, blackTvs)
          ]
        | blueTvs <- allBoolLists $ length $ statementsOfColor pzl Blue,
          whiteTvs <- allBoolLists $ length $ statementsOfColor pzl White,
          blackTvs <- allBoolLists $ length $ statementsOfColor pzl Black
        ]
          & map (Map.fromList)
   in filter
        (checkSolution pzl)
        [ParlorSolution color tvMap | color <- [Blue, White, Black], tvMap <- allTruthValueMaps]
