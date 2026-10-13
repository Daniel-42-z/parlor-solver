module Puzzle (puzzle) where

import Parlor (Color (Black, Blue, White))
import Statement

-- Write the puzzle to solve here
puzzle =
  [ ( Blue,
      [ someBox someTrue empty,
        someBox someFalse empty,
        empty White
      ]
    ),
    ( White,
      [ someBox allTrue empty,
        empty Black,
        orStatement (empty White) (empty Black)
      ]
    ),
    ( Black,
      [ someBox (\c -> more (boxFalseStatementsCount c) (constCnt 1)) (empty),
        empty Black,
        someBox allFalse empty
      ]
    )
  ]
