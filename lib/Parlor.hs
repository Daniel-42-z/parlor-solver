module Parlor
  ( ParlorStatement,
    StatementPos,
    ParlorPuzzle,
    ParlorSolution (..),
    checkSolution,
    Box (..),
    allValidSolutions,
    statementsOfBox,
    truthValuesOfBox,
    processSolutions,
  )
where

import Data.Function ((&))
import Data.Map (Map)
import Data.Map qualified as Map
import Data.Set qualified as Set

data Box = Blue | White | Black deriving (Eq, Ord, Show)

data ParlorSolution = ParlorSolution
  { answer :: Box,
    truthValuesMap :: Map Box [Bool]
  }
  deriving (Eq)

instance Show ParlorSolution where
  show (ParlorSolution ans tvs) = "Gems in " ++ show ans ++ " box." ++ "\n" ++ "Truth values for each box:\n" ++ show (Map.toList tvs)

type StatementPos = (Box, Int)

type ParlorStatement = StatementPos -> ParlorSolution -> Bool -- Returns true if statement doesn't contradict input state

condFlip :: ParlorStatement -> Bool -> ParlorStatement
condFlip st b = if b then st else (not .) . st

type ParlorPuzzle = Map Box [ParlorStatement]

statementsOfBox :: ParlorPuzzle -> Box -> [ParlorStatement]
statementsOfBox pzl box = Map.findWithDefault [] box pzl

truthValuesOfBox :: ParlorSolution -> Box -> [Bool]
truthValuesOfBox (ParlorSolution _ tss) box = Map.findWithDefault [] box tss

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
          ( \box ->
              let (statements, truthValues) = (statementsOfBox pzl box, truthValuesOfBox solution box)
                  consistencies = zipWith3 (\i statement truthValue -> condFlip statement truthValue (box, i) solution) [0 ..] statements truthValues
               in and consistencies
          )
        & and

allValidSolutions :: ParlorPuzzle -> [ParlorSolution]
allValidSolutions pzl =
  let allBoolLists :: Int -> [[Bool]]
      allBoolLists 0 = [[]]
      allBoolLists n = (map (True :) $ allBoolLists (n - 1)) ++ (map (False :) $ allBoolLists (n - 1))
      allTruthValueMaps :: [Map Box [Bool]]
      allTruthValueMaps =
        [ [ (Blue, blueTvs),
            (White, whiteTvs),
            (Black, blackTvs)
          ]
        | blueTvs <- allBoolLists $ length $ statementsOfBox pzl Blue,
          whiteTvs <- allBoolLists $ length $ statementsOfBox pzl White,
          blackTvs <- allBoolLists $ length $ statementsOfBox pzl Black
        ]
          & map (Map.fromList)
   in filter
        (checkSolution pzl)
        [ParlorSolution box tvMap | box <- [Blue, White, Black], tvMap <- allTruthValueMaps]

data FinalSolution = Contradictory | Determinate Box | Indeterminate [Box] deriving (Eq, Show)

processSolutions :: [ParlorSolution] -> FinalSolution
processSolutions solutions = case solutions of
  [] -> Contradictory
  (sol : sols) ->
    let firstAns = answer sol
     in if all (\solution -> answer solution == firstAns) sols
          then Determinate $ answer sol
          else Indeterminate $ Set.toList $ Set.fromList $ map answer solutions
