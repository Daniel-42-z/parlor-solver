module Vocab
  ( truth,
    lie,
    notStatement,
    iff,
    ifStatement,
    andStatement,
    orStatement,
    xorStatement,
    contents,
    eq,
    moreThan,
    geq,
    lessThan,
    leq,
    count,
    allTrueBoxesCount,
    allFalseBoxesCount,
    boxTrueStatementsCount,
    boxFalseStatementsCount,
    totalTrueStatements,
    totalFalseStatements,
    allTrue,
    allFalse,
    someTrue,
    someFalse,
    hasGems,
    empty,
    thisBox,
    gemBox,
    forSomeBox,
    forAllBoxes,
    allBoxes,
  )
where

import Data.Function ((&))
import Data.Map qualified as Map
import Parlor (Box (Black, Blue, White), ParlorSolution (ParlorSolution), ParlorStatement, StatementPos, truthValuesOfBox)

truth :: ParlorStatement
truth = \_ _ -> True

lie :: ParlorStatement
lie = \_ _ -> False

notStatement :: ParlorStatement -> ParlorStatement
notStatement st = (not .) . st

iff :: ParlorStatement -> ParlorStatement -> ParlorStatement
iff st1 st2 pos sol = st1 pos sol == st2 pos sol

ifStatement :: ParlorStatement -> ParlorStatement -> ParlorStatement
ifStatement st1 st2 pos sol = not (st1 pos sol && not (st2 pos sol))

andStatement :: ParlorStatement -> ParlorStatement -> ParlorStatement
andStatement st1 st2 pos sol = st1 pos sol && st2 pos sol

orStatement :: ParlorStatement -> ParlorStatement -> ParlorStatement
orStatement st1 st2 pos sol = st1 pos sol || st2 pos sol

xorStatement :: ParlorStatement -> ParlorStatement -> ParlorStatement
xorStatement st1 st2 pos sol = st1 pos sol /= st2 pos sol

type Prop a = StatementPos -> ParlorSolution -> a

count :: Int -> Prop Int
count n = \_ _ -> n

allTrueBoxesCount :: Prop Int
allTrueBoxesCount _ (ParlorSolution _ tvs) = (Map.elems tvs) & map and & filter id & length

allFalseBoxesCount :: Prop Int
allFalseBoxesCount _ (ParlorSolution _ tvs) = (Map.elems tvs) & map (all not) & filter id & length

boxStatementsCount :: Box -> Prop Int
boxStatementsCount b _ sol = length $ truthValuesOfBox sol b

boxTrueStatementsCount :: Box -> Prop Int
boxTrueStatementsCount b _ sol = length $ filter id $ truthValuesOfBox sol b

boxFalseStatementsCount :: Box -> Prop Int
boxFalseStatementsCount b _ sol = length $ filter not $ truthValuesOfBox sol b

totalStatements :: Prop Int
totalStatements pos sol = sum $ map (\b -> boxStatementsCount b pos sol) allBoxes

totalTrueStatements :: Prop Int
totalTrueStatements pos sol = sum $ map (\b -> boxTrueStatementsCount b pos sol) allBoxes

totalFalseStatements :: Prop Int
totalFalseStatements pos sol = sum $ map (\b -> boxFalseStatementsCount b pos sol) allBoxes

data BoxContents = Empty | Gems deriving (Eq, Ord, Show)

contents :: Box -> Prop BoxContents
contents b pos sol = if hasGems b pos sol then Gems else Empty

eq :: (Eq a) => Prop a -> Prop a -> ParlorStatement
eq c1 c2 pos sol = c1 pos sol == c2 pos sol

moreThan :: (Ord a) => Prop a -> Prop a -> ParlorStatement
moreThan c1 c2 pos sol = c1 pos sol > c2 pos sol

geq :: (Ord a) => Prop a -> Prop a -> ParlorStatement
geq c1 c2 pos sol = c1 pos sol >= c2 pos sol

lessThan :: (Ord a) => Prop a -> Prop a -> ParlorStatement
lessThan c1 c2 pos sol = c1 pos sol < c2 pos sol

leq :: (Ord a) => Prop a -> Prop a -> ParlorStatement
leq c1 c2 pos sol = c1 pos sol <= c2 pos sol

type BoxPredicate = Box -> ParlorStatement

hasGems :: BoxPredicate
hasGems box _ (ParlorSolution ans _) = ans == box

empty :: BoxPredicate
empty box _ (ParlorSolution ans _) = ans /= box

allTrue :: BoxPredicate
allTrue box _ sol = and $ truthValuesOfBox sol box

allFalse :: BoxPredicate
allFalse box _ sol = all not $ truthValuesOfBox sol box

someTrue :: BoxPredicate
someTrue box _ sol = or $ truthValuesOfBox sol box

someFalse :: BoxPredicate
someFalse box _ sol = any not $ truthValuesOfBox sol box

thisBox :: BoxPredicate -> ParlorStatement
thisBox predi = \(box, i) sol -> predi box (box, i) sol

gemBox :: BoxPredicate -> ParlorStatement
gemBox predi = \pos (ParlorSolution ans tvs) -> predi ans pos (ParlorSolution ans tvs)

forSomeBox :: BoxPredicate -> BoxPredicate -> ParlorStatement
forSomeBox pred1 pred2 = \pos sol -> not $ null [c | c <- [Blue, White, Black], pred1 c pos sol && pred2 c pos sol]

forAllBoxes :: BoxPredicate -> BoxPredicate -> ParlorStatement
forAllBoxes cond predi = \pos sol -> all (\box -> predi box pos sol) [c | c <- [Blue, White, Black], cond c pos sol]

allBoxes :: [Box]
allBoxes = [Blue, White, Black]
