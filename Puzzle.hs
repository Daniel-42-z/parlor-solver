module Puzzle (puzzle) where

import Parlor (Box (Black, Blue, White))
import Vocab

-- Write the puzzle to solve here
puzzle =
  [ ( Blue,
      [ hasGems Black `orStatement` hasGems White,
        allTrueBoxesCount `moreThan` allFalseBoxesCount
      ]
    ),
    ( White,
      [ foldr1 andStatement $ map hasGems allBoxes
      ]
    ),
    ( Black,
      [ notStatement $ thisBox hasGems,
        allTrue White `xorStatement` allTrue Blue
      ]
    )
  ]
