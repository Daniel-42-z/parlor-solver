This project is a solver for the Parlor Box puzzles in the game Blue Prince and https://parlorbox.com/.

Each statement is encoded as a function that takes in where the gem is (`Color`), the position of the statement (given as `(Color, Int)`) and the truth value of each statement (`Map Color [Bool]`), and outputs whether it's consistent with the statement. Solving the puzzle is done by generating all possible states of the boxes (where the gem is, and each statement being true or false) and checking each state with each statement and find all of these that are consistent with every statement and is a valid solution (one box with at least one statement and all true statements, and another with at least one statement and all false statements).

## Setup

- Check the defined words for writing statements in `./lib/Statement.hs`. Most of these are self-documentary.
- Write the statements to solve in the boxes in `./Puzzle.hs`
- Run with `cabal run`
