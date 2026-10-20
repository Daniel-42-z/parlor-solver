module Puzzle (puzzle) where

import Parlor (Box (Black, Blue, White))
import Vocab

-- Write the puzzle to solve here
puzzle =
  [ ( Blue,
      [ notStatement $ thisBox hasGems,
        foldr1 andStatement $ map hasGems allBoxes
      ]
    ),
    ( White,
      [ thisBox hasGems,
        allFalse Black `iff` allTrue Blue
      ]
    ),
    ( Black,
      [ thisBox (\b -> contents White `eq` contents b)
      ]
    )
  ]
