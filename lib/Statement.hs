module Statement
  ( true,
    false,
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
    constCnt,
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
import Parlor (Color (Black, Blue, White), ParlorSolution (ParlorSolution), ParlorStatement, StatementPos, truthValuesOfColor)

false :: ParlorStatement
false _ _ = False

true :: ParlorStatement
true _ _ = True

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

constCnt :: Int -> CountingStatement
constCnt n = \_ _ -> n

allTrueBoxesCount :: CountingStatement
allTrueBoxesCount _ (ParlorSolution _ tvs) = (Map.elems tvs) & map and & filter id & length

allFalseBoxesCount :: CountingStatement
allFalseBoxesCount _ (ParlorSolution _ tvs) = (Map.elems tvs) & map (all not) & filter id & length

boxTrueStatementsCount :: Color -> CountingStatement
boxTrueStatementsCount c _ sol = length $ filter id $ truthValuesOfColor sol c

boxFalseStatementsCount :: Color -> CountingStatement
boxFalseStatementsCount c _ sol = length $ filter not $ truthValuesOfColor sol c

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

hasGems :: Color -> ParlorStatement
hasGems color _ (ParlorSolution ans _) = ans == color

empty :: Color -> ParlorStatement
empty color _ (ParlorSolution ans _) = ans /= color

allTrue :: Color -> ParlorStatement
allTrue color _ sol = and $ truthValuesOfColor sol color

allFalse :: Color -> ParlorStatement
allFalse color _ sol = all not $ truthValuesOfColor sol color

someTrue :: Color -> ParlorStatement
someTrue color _ sol = or $ truthValuesOfColor sol color

someFalse :: Color -> ParlorStatement
someFalse color _ sol = any not $ truthValuesOfColor sol color

thisBox :: (Color -> ParlorStatement) -> ParlorStatement
thisBox colorProp = \(color, i) sol -> colorProp color (color, i) sol

gemBox :: (Color -> ParlorStatement) -> ParlorStatement
gemBox colorProp = \pos (ParlorSolution ans tvs) -> colorProp ans pos (ParlorSolution ans tvs)

someBox :: (Color -> ParlorStatement) -> (Color -> ParlorStatement) -> ParlorStatement
someBox prop1 prop2 = \pos sol -> not $ null [c | c <- [Blue, White, Black], prop1 c pos sol && prop2 c pos sol]

allBoxes :: (Color -> ParlorStatement) -> (Color -> ParlorStatement) -> ParlorStatement
allBoxes cond prop = \pos sol -> all (\color -> prop color pos sol) [c | c <- [Blue, White, Black], cond c pos sol]
