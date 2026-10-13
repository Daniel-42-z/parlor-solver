module Statement
  ( truth,
    lie,
    notStatement,
    iff,
    ifStatement,
    andStatement,
    orStatement,
    eq,
    more,
    geq,
    less,
    leq,
    constCount,
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
    someBox,
    allBoxes,
  )
where

import Data.Function ((&))
import Data.Map qualified as Map
import Parlor (Box (Black, Blue, White), ParlorSolution (ParlorSolution), ParlorStatement, StatementPos, truthValuesOfBox)

truth :: ParlorStatement
truth _ _ = True

lie :: ParlorStatement
lie _ _ = False

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

type CountingStatement = StatementPos -> ParlorSolution -> Int

constCount :: Int -> CountingStatement
constCount n = \_ _ -> n

allTrueBoxesCount :: CountingStatement
allTrueBoxesCount _ (ParlorSolution _ tvs) = (Map.elems tvs) & map and & filter id & length

allFalseBoxesCount :: CountingStatement
allFalseBoxesCount _ (ParlorSolution _ tvs) = (Map.elems tvs) & map (all not) & filter id & length

boxTrueStatementsCount :: Box -> CountingStatement
boxTrueStatementsCount c _ sol = length $ filter id $ truthValuesOfBox sol c

boxFalseStatementsCount :: Box -> CountingStatement
boxFalseStatementsCount c _ sol = length $ filter not $ truthValuesOfBox sol c

totalTrueStatements :: CountingStatement
totalTrueStatements pos sol = sum $ map (\c -> boxTrueStatementsCount c pos sol) [Blue, White, Black]

totalFalseStatements :: CountingStatement
totalFalseStatements pos sol = sum $ map (\c -> boxFalseStatementsCount c pos sol) [Blue, White, Black]

eq :: CountingStatement -> CountingStatement -> ParlorStatement
eq c1 c2 pos sol = c1 pos sol == c2 pos sol

more :: CountingStatement -> CountingStatement -> ParlorStatement
more c1 c2 pos sol = c1 pos sol > c2 pos sol

geq :: CountingStatement -> CountingStatement -> ParlorStatement
geq c1 c2 pos sol = c1 pos sol >= c2 pos sol

less :: CountingStatement -> CountingStatement -> ParlorStatement
less c1 c2 pos sol = c1 pos sol < c2 pos sol

leq :: CountingStatement -> CountingStatement -> ParlorStatement
leq c1 c2 pos sol = c1 pos sol <= c2 pos sol

hasGems :: Box -> ParlorStatement
hasGems box _ (ParlorSolution ans _) = ans == box

empty :: Box -> ParlorStatement
empty box _ (ParlorSolution ans _) = ans /= box

allTrue :: Box -> ParlorStatement
allTrue box _ sol = and $ truthValuesOfBox sol box

allFalse :: Box -> ParlorStatement
allFalse box _ sol = all not $ truthValuesOfBox sol box

someTrue :: Box -> ParlorStatement
someTrue box _ sol = or $ truthValuesOfBox sol box

someFalse :: Box -> ParlorStatement
someFalse box _ sol = any not $ truthValuesOfBox sol box

thisBox :: (Box -> ParlorStatement) -> ParlorStatement
thisBox prop = \(box, i) sol -> prop box (box, i) sol

gemBox :: (Box -> ParlorStatement) -> ParlorStatement
gemBox prop = \pos (ParlorSolution ans tvs) -> prop ans pos (ParlorSolution ans tvs)

someBox :: (Box -> ParlorStatement) -> (Box -> ParlorStatement) -> ParlorStatement
someBox prop1 prop2 = \pos sol -> not $ null [c | c <- [Blue, White, Black], prop1 c pos sol && prop2 c pos sol]

allBoxes :: (Box -> ParlorStatement) -> (Box -> ParlorStatement) -> ParlorStatement
allBoxes cond prop = \pos sol -> all (\box -> prop box pos sol) [c | c <- [Blue, White, Black], cond c pos sol]
