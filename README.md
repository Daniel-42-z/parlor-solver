# Parlor solver

Solve the Parlor Box puzzles from **Blue Prince** and [parlorbox.com](https://parlorbox.com/). Translate the writing on each box into a small vocabulary of Haskell expressions in [Puzzle.hs](Puzzle.hs), then run the solver. No programming experience is needed: keep the supplied file structure and replace its statements using the examples below.

## Install Haskell and Cabal

You need **GHC**, which compiles Haskell, and **Cabal**, which builds and runs this project. Prefer your operating system's package manager when it offers compatible versions. **GHCup** can install specific versions when the packages available for your system do not match this project.

This project requires `base >= 4.20.2.0 && < 4.21`, the standard library supplied with **GHC 9.10.2 or 9.10.3**. Older compiler series and newer ones such as 9.12 do not satisfy that requirement. You do not install `base` separately. The project also uses the `GHC2024` language setting, so use a recent Cabal that supports it. Stack and the Haskell Language Server are optional.

### Linux: prefer your distribution's packages

Check your distribution's packages first. The package names are usually `ghc` and `cabal-install`; the latter supplies the `cabal` command.

| Distribution    | Check available versions             | Install packages                     |
| --------------- | ------------------------------------ | ------------------------------------ |
| Debian / Ubuntu | `apt-cache policy ghc cabal-install` | `sudo apt install ghc cabal-install` |
| Fedora          | `dnf info ghc cabal-install`         | `sudo dnf install ghc cabal-install` |
| Arch Linux      | `pacman -Si ghc cabal-install`       | `sudo pacman -Syu ghc cabal-install` |

See the official package listings for [Ubuntu](https://packages.ubuntu.com/cabal-install), [Fedora](https://packages.fedoraproject.org/pkgs/ghc/ghc/), and [Arch](https://archlinux.org/packages/extra/x86_64/ghc/). Versions vary by distribution release: availability alone does not mean the compiler is compatible. If the offered GHC is not 9.10.2 or 9.10.3, or Cabal is too old to understand `GHC2024`, use the GHCup fallback below. For another distribution, check its package manager for the same tools.

### macOS: Homebrew

If you use [Homebrew](https://brew.sh/), it provides both [Cabal](https://formulae.brew.sh/formula/cabal-install) and the compatible [GHC 9.10 series](https://formulae.brew.sh/formula/ghc@9.10):

```sh
brew install ghc@9.10 cabal-install
export PATH="$(brew --prefix ghc@9.10)/bin:$PATH"
```

The versioned GHC package is keg-only: the `export` line makes its commands available in the current terminal. Add that same line to your shell configuration (`~/.zshrc` for the default macOS shell) to keep it available in future terminals. Use `ghc@9.10` rather than the unversioned `ghc` package, which may install an incompatible newer series.

If you do not use Homebrew, use GHCup below.

### GHCup fallback for Linux and macOS

Use the [official GHCup installer](https://www.haskell.org/ghcup/) when compatible packages are unavailable. Its [system requirements](https://www.haskell.org/ghcup/install/#system-requirements) explain any tools or system libraries needed for your operating system. Follow its dependency prompts; on macOS this may include Apple's command-line tools.

Open Terminal and run the installer as your regular user:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Allow it to make GHCup available in your shell when prompted. Close and reopen Terminal afterward, then follow “Select versions with GHCup” below.

### Windows

Open PowerShell as your regular user and run the official installer:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; try { & ([ScriptBlock]::Create((Invoke-WebRequest https://www.haskell.org/ghcup/sh/bootstrap-haskell.ps1 -UseBasicParsing))) -Interactive -DisableCurl } catch { Write-Error $_ }
```

Follow its prompts, including installing MSYS2 if requested. Close and reopen PowerShell afterward. See the [GHCup installation guide](https://www.haskell.org/ghcup/install/) if installation fails.

### Select versions with GHCup

Only follow this subsection if you installed GHCup, including on Windows. In your reopened terminal, run each line separately:

```sh
ghcup install ghc 9.10.2
ghcup set ghc 9.10.2
ghcup install cabal latest
ghcup set cabal latest
```

If GHCup says that version is already installed, continue with the next line.

### Verify your installation

Whichever installation method you used, check both commands:

```sh
ghc --version
cabal --version
```

GHC should report **9.10.2 or 9.10.3**, and Cabal should print its version. If a different GHC is selected, check your shell's PATH or use GHCup to select the compatible version before continuing.

## Get the project and run it

Download the ZIP from **Code → Download ZIP** on the [project page](https://github.com/Daniel-42-z/parlor-solver), then extract it. Open the extracted folder in a text editor. Use a plain-text/code editor so the file stays named `Puzzle.hs`, not `Puzzle.hs.txt`.

Open a terminal in that folder, or use `cd` to enter it. Replace the example path below with your extracted folder's location:

```sh
cd "path/to/parlor-solver-main"
cabal update
cabal run
```

The folder must contain `parlor-solver.cabal` and `Puzzle.hs`. `cabal update` downloads the package index; you normally only need it during setup or when the index needs refreshing. The first `cabal run` can take a while as it downloads dependencies and compiles the project. Later runs rebuild what changed.

Your everyday workflow is: edit **only `Puzzle.hs`**, save it, and run `cabal run` again in the project folder.

## Edit the statements in Puzzle.hs

The file already has the imports and entries for `Blue`, `White`, and `Black`. Keep those parts. Replace the expressions inside each box's inner square brackets with translations of its printed statements, in top-to-bottom order.

**Spoilers:** the worked examples include real puzzles and answers, starting with [wiki puzzle #008](https://blueprince.wiki.gg/wiki/Parlor_Game/List_of_Parlor_Games#008).

| Box   | Claim, paraphrased       | Translation       |
| ----- | ------------------------ | ----------------- |
| Blue  | White has no gems.       | `empty White`     |
| White | This box has no gems.    | `thisBox empty`   |
| Black | This box holds the gems. | `thisBox hasGems` |

Here is the complete file for that puzzle. You can copy it over the contents of `Puzzle.hs`:

```haskell
module Puzzle (puzzle) where

import Parlor (Box (Black, Blue, White))
import Vocab

puzzle =
  [ ( Blue,
      [ empty White
      ]
    ),
    ( White,
      [ thisBox empty
      ]
    ),
    ( Black,
      [ thisBox hasGems
      ]
    )
  ]
```

You do not need to build the surrounding list of box/statement pairs yourself. For a different puzzle, keep the structure above and edit the three inner lists.

- Put a comma **between** statements, with no comma after the last one.
- Use one entry per printed statement. If one statement says “A and B,” combine its clauses into one expression rather than creating two entries.
- A box with no writing has an empty list: `(White, [])`. Do not put `truth` or `lie` in place of a blank statement.
- Preserve spelling and capitalization. `White` is a box; `white` is not the same name.
- Text after `--` on a line is a comment for the reader and does not affect the puzzle.

For example, two separate statements on Blue could have this inner list:

```haskell
[ empty White,
  thisBox hasGems
]
```

### Translate the claim, not your verdict

The solver assumes exactly one box holds the gems. It requires at least one box with writing whose statements are all true, and another box with writing whose statements are all false. A third box can have any mix of truth values.

Write what each statement **claims**, even when you suspect it is lying. For “Blue holds the gems,” write `hasGems Blue`. Do not change it to `empty Blue` because you believe the statement is false. The solver decides which statements are true by checking all possible gem locations and truth assignments for consistency.

Self-references and impossible claims can be intentional. Keep them in the puzzle rather than removing them.

## Read the result

Running the first example ends with:

```text
Final solution:
Determinate Blue
```

Before that, the program prints every consistent state, with the gem location and each box's statement truth values. For this example:

```text
Gems in Blue box.
Truth values for each box:
[(Blue,[True]),(White,[True]),(Black,[False])]
```

`True` means the claim is true in that state; `False` means it is false. Within each box's list, values follow the top-to-bottom order of the statements you entered.

| Final result                 | Meaning                                                                                              |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- |
| `Determinate Blue`           | Every consistent state puts the gems in Blue. There may still be several possible truth assignments. |
| `Indeterminate [Blue,White]` | Different consistent states put the gems in different boxes; the listed boxes are possible answers.  |
| `Contradictory`              | No state satisfies your translations and the solver's rules. Check the wording and encoding.         |

## Basic vocabulary

The full implementation is in [lib/Vocab.hs](lib/Vocab.hs). The following sections explain every exported vocabulary word.

### Gems and truth claims

| Claim                                   | Expression        |
| --------------------------------------- | ----------------- |
| Blue contains the gems.                 | `hasGems Blue`    |
| White does not contain the gems.        | `empty White`     |
| This box contains the gems.             | `thisBox hasGems` |
| This box is empty.                      | `thisBox empty`   |
| Every statement on Black is true.       | `allTrue Black`   |
| Every statement on Black is false.      | `allFalse Black`  |
| Black has at least one true statement.  | `someTrue Black`  |
| Black has at least one false statement. | `someFalse Black` |
| Every statement on this box is true.    | `thisBox allTrue` |
| The gem box has a true statement.       | `gemBox someTrue` |
| The gem box has only false statements.  | `gemBox allFalse` |

`hasGems`, `empty`, `allTrue`, `allFalse`, `someTrue`, and `someFalse` are **predicates**: recipes for making a claim about a box. Supply a box name, or let `thisBox` or `gemBox` select a box for the recipe.

`thisBox` means the box carrying the statement you are translating. `gemBox` means whichever box contains the gems in the state being checked. A “true box” usually means `allTrue`; “a box with a true statement” means `someTrue`. These differ when boxes have multiple statements.

`truth` is an always-true statement; `lie` is an always-false statement. Use them for facts settled by looking at the room or the writing. For example, if there are three boxes, “There are three boxes” can be `truth` and “There are four boxes” can be `lie`. Do not use them to guess the truth of a claim that depends on the gems or other statements.

### Combine clauses into one statement

| Claim                                                        | Expression                                 |
| ------------------------------------------------------------ | ------------------------------------------ |
| It is not true that Blue has only true statements.           | `notStatement (allTrue Blue)`              |
| Blue and White are both empty.                               | ``empty Blue `andStatement` empty White``  |
| Blue or White is empty, or both are.                         | ``empty Blue `orStatement` empty White``   |
| If Blue has only true statements, White is empty.            | ``allTrue Blue `ifStatement` empty White`` |
| Blue has only true statements if and only if White is empty. | ``allTrue Blue `iff` empty White``         |

The backtick character (`` ` ``) lets a two-input vocabulary word sit **between** its inputs. For example, ``empty Blue `andStatement` empty White`` also means `andStatement (empty Blue) (empty White)`.

- `orStatement` includes the possibility that both clauses are true. For “exactly one of A or B,” combine “A or B” with “not (A and B).”
- `ifStatement` takes the **condition first**, then the consequence. It is false only when the condition is true and the consequence is false. A false condition makes the implication true.
- `iff` is true when both clauses have the same truth value, including when both are false. It makes a stronger claim than a one-way implication.
- `notStatement (allTrue Blue)` means **at least one false statement**, not necessarily all false. Use `allFalse Blue` for the latter.

Use parentheses to make grouping explicit:

```haskell
(empty Blue `orStatement` empty White)
  `andStatement` notStatement (allTrue Black)
```

This is one claim: “Blue or White is empty, and Black does not have all true statements.” Newlines do not split it into separate printed statements; commas in the box's list do that.

You will also see `$`. It means “use everything to the right as the input,” avoiding an outer pair of parentheses:

```haskell
notStatement $ thisBox hasGems
```

This means the same thing as `notStatement (thisBox hasGems)`, or simply `thisBox empty`.

## Count and compare

A **count** produces a number; a comparison turns two counts into a statement.

| Count expression                | What it counts                           |
| ------------------------------- | ---------------------------------------- |
| `allTrueBoxesCount`             | Boxes whose statements are all true.     |
| `allFalseBoxesCount`            | Boxes whose statements are all false.    |
| `boxTrueStatementsCount Blue`   | True statements on Blue.                 |
| `boxFalseStatementsCount White` | False statements on White.               |
| `totalTrueStatements`           | True statements across all three boxes.  |
| `totalFalseStatements`          | False statements across all three boxes. |
| `count 2`                       | Always the number 2.                     |

Use `count` to put a fixed number into a comparison; do not write a bare `2` where a count recipe is expected.

| Claim                                           | Expression                                                              |
| ----------------------------------------------- | ----------------------------------------------------------------------- |
| Exactly two statements are true.                | ``totalTrueStatements `eq` count 2``                                    |
| More than one statement on Black is false.      | ``boxFalseStatementsCount Black `moreThan` count 1``                    |
| At least two statements are false.              | ``totalFalseStatements `geq` count 2``                                  |
| Fewer than two boxes have only true statements. | ``allTrueBoxesCount `lessThan` count 2``                                |
| At most one box has only false statements.      | ``allFalseBoxesCount `leq` count 1``                                    |
| Blue has more true statements than White.       | ``boxTrueStatementsCount Blue `moreThan` boxTrueStatementsCount White`` |

`eq`, `moreThan`, `geq`, `lessThan`, and `leq` mean equal, greater than, greater than or equal, less than, and less than or equal, respectively. Counting boxes and statements differ: a box with three true statements contributes **one** to `allTrueBoxesCount` and **three** to `totalTrueStatements`.

### Worked puzzle: counts and the gem box

In [wiki puzzle #012](https://blueprince.wiki.gg/wiki/Parlor_Game/List_of_Parlor_Games#012), Blue claims a total of two truths, White affirms Blue, and Black places the gems in a box with a truth. Since each box has one statement, `allTrue Blue` expresses White's claim.

```haskell
module Puzzle (puzzle) where

import Parlor (Box (Black, Blue, White))
import Vocab

puzzle =
  [ ( Blue,
      [ totalTrueStatements `eq` count 2
      ]
    ),
    ( White,
      [ allTrue Blue
      ]
    ),
    ( Black,
      [ gemBox someTrue
      ]
    )
  ]
```

Expected result: `Determinate Black`. Several consistent truth assignments can agree on one gem location.

## Lambdas: write your own box predicate

Some claims need a recipe assembled from several vocabulary words. A **lambda** lets you write that recipe without giving it a permanent name:

```text
\box -> expression
```

Read it as "given a box, use this expression." The backslash `\` introduces the recipe, `box` is a temporary name for its input, and the arrow `->` begins the expression that uses that input. Use a backslash, not a forward slash `/`.

For example:

```haskell
thisBox (\box -> hasGems box)
```

`thisBox` supplies the box carrying the statement. On White, substitute `White` for `box`, giving `hasGems White`. This is a longer way to write `thisBox hasGems`; the longer form becomes useful when the recipe is more complex.

The temporary name is your choice: `\box -> hasGems box` and `\x -> hasGems x` mean the same thing. Keep its spelling consistent inside the expression and start it with a lowercase letter. It does not change the meaning of `thisBox` or select a box by itself.

### Combine traits or use a box-dependent count

“This box has a mix of true and false statements”:

```haskell
thisBox (\box -> someTrue box `andStatement` someFalse box)
```

“This box has exactly one true statement”:

```haskell
thisBox (\box -> boxTrueStatementsCount box `eq` count 1)
```

“There are more entirely true boxes than true statements on this box”:

```haskell
thisBox (\box -> allTrueBoxesCount `moreThan` boxTrueStatementsCount box)
```

The lambda's body must form a statement about the supplied box. Here `boxTrueStatementsCount box` supplies a count, and `moreThan` turns the comparison into a statement. The exported names are `allTrueBoxesCount` and `boxTrueStatementsCount`; use those exact names.

Keep the lambda in parentheses when passing it to `thisBox`, `gemBox`, or another vocabulary word. This makes its boundaries clear.

### Compare contents

`contents Blue` describes whether Blue is empty or holds gems. Use `eq` to compare two such descriptions:

```haskell
contents Blue `eq` contents White
```

This claims Blue and White have identical contents. Under the one-gem-box rule, two different boxes can have identical contents only if both are empty.

“This box has the same contents as White” uses a lambda:

```haskell
thisBox (\box -> contents box `eq` contents White)
```

Do not compare `contents` to a number; compare contents with contents, and counts with counts.

## Claims about some or all boxes

`forSomeBox` and `forAllBoxes` each take **two box predicates**: a selection condition and a claim about the selected boxes.

| Claim                                              | Expression                    |
| -------------------------------------------------- | ----------------------------- |
| At least one box with a true statement is empty.   | `forSomeBox someTrue empty`   |
| At least one entirely false box contains the gems. | `forSomeBox allFalse hasGems` |
| Every entirely true box is empty.                  | `forAllBoxes allTrue empty`   |
| Both empty boxes have a false statement.           | `forAllBoxes empty someFalse` |

`forSomeBox` requires at least one box satisfying **both** predicates. `forAllBoxes` checks the second predicate on **every** box satisfying the first. It does not assert that a matching box exists: if none match, the universal claim is true. If existence is part of the wording, encode it too.

For “A box with more than one false statement is empty,” assemble the selection predicate with a lambda:

```haskell
forSomeBox
  (\box -> boxFalseStatementsCount box `moreThan` count 1)
  empty
```

For “Every box with a mix of true and false statements is empty”:

```haskell
forAllBoxes
  (\box -> someTrue box `andStatement` someFalse box)
  empty
```

### All three boxes explicitly

`allBoxes` is the list `[Blue, White, Black]`. To claim that every box contains gems:

```haskell
foldr1 andStatement $ map hasGems allBoxes
```

`map hasGems allBoxes` makes the three claims `hasGems Blue`, `hasGems White`, and `hasGems Black`. `foldr1 andStatement` joins them with “and.” Replacing `andStatement` with `orStatement` claims at least one box contains gems. Only use `foldr1` with a nonempty list; `allBoxes` always has three entries.

The all-gems claim is impossible under the rules, but it can still appear as a false statement in a valid puzzle. Another way to express it is `forAllBoxes (\box -> truth) hasGems`: the first predicate selects every box and ignores its temporary `box` input.

## Left, right, and other boxes

`Box` has an ordering corresponding to the usual left-to-right arrangement:

```text
Blue < White < Black
```

For box names, ordinary `>` means “to the right of,” `<` means “to the left of,” `==` means “the same box,” and `/=` means “a different box.” These comparisons yield an ordinary yes/no value. Convert that value into a vocabulary statement with `if ... then truth else lie`.

“Some box to the right of White contains gems”:

```haskell
forSomeBox (\box -> if box > White then truth else lie) hasGems
```

“Every box to the left of Black is empty”:

```haskell
forAllBoxes (\box -> if box < Black then truth else lie) empty
```

“The gems are to the right of this box” needs two temporary box names:

```haskell
thisBox (\ownBox ->
  forSomeBox (\otherBox -> if otherBox > ownBox then truth else lie) hasGems)
```

The outer lambda remembers the box carrying the statement; the inner lambda considers possible gem boxes. On Blue, `ownBox` stays Blue while `otherBox` ranges over all three boxes. For “The other boxes are empty,” use the same pattern with `/=`:

```haskell
thisBox (\ownBox ->
  forAllBoxes (\otherBox -> if otherBox /= ownBox then truth else lie) empty)
```

Ordinary box comparisons such as `box > White` differ from vocabulary comparisons such as ``totalTrueStatements `moreThan` count 1``. The former compare fixed box identities; the latter compare properties that depend on the state the solver is checking.

There is no dedicated adjacency helper. For “next to” claims, identify the neighbors from the arrangement: White neighbors both Blue and Black, while each end box neighbors only White. Being somewhere to the right does not necessarily mean being immediately next to a box. Adapt translations if your puzzle uses a different physical arrangement.

## Multiple statements and blank boxes

### Worked puzzle: two statements on each box

For [wiki puzzle #064](https://blueprince.wiki.gg/wiki/Parlor_Game/List_of_Parlor_Games#064), enter these claims in order:

| Box   | First claim, paraphrased | Second claim, paraphrased |
| ----- | ------------------------ | ------------------------- |
| Blue  | This box is empty.       | White is empty.           |
| White | This box is empty.       | Blue holds gems.          |
| Black | This box is empty.       | Blue holds gems.          |

```haskell
module Puzzle (puzzle) where

import Parlor (Box (Black, Blue, White))
import Vocab

puzzle =
  [ ( Blue,
      [ thisBox empty,
        empty White
      ]
    ),
    ( White,
      [ thisBox empty,
        hasGems Blue
      ]
    ),
    ( Black,
      [ thisBox empty,
        hasGems Blue
      ]
    )
  ]
```

Expected result: `Determinate Black`. The truth lists are Blue `[True,True]`, White `[True,False]`, and Black `[False,False]`. White is mixed: neither `allTrue White` nor `allFalse White` holds.

### Blank boxes have special counting behavior

Represent a box without statements using `[]`. Under the current vocabulary:

- Both `allTrue` and `allFalse` return true for a blank box: there is no statement contradicting either “all” claim.
- Both `someTrue` and `someFalse` return false for it.
- It contributes one to **both** `allTrueBoxesCount` and `allFalseBoxesCount`, and zero to statement counts.
- It cannot serve as the solver's required box with writing that is entirely true or entirely false.

This matters when translating puzzles with blank boxes. If “true box” explicitly excludes blank boxes, use a combined predicate such as ``\box -> allTrue box `andStatement` someTrue box``. Do not silently assume the box counters exclude blanks.

## Final worked puzzle: combine the vocabulary

[Wiki puzzle #090](https://blueprince.wiki.gg/wiki/Parlor_Game/List_of_Parlor_Games#090) brings together existential claims, whole-box truth, counts, and a reference to printed wording. Here are its claims, paraphrased, in top-to-bottom order:

| Box   | Top                                | Middle                     | Bottom                                               |
| ----- | ---------------------------------- | -------------------------- | ---------------------------------------------------- |
| Blue  | A box with a truth is empty.       | A box with a lie is empty. | White is empty.                                      |
| White | An entirely true box is empty.     | Black is empty.            | A box sharing a statement with another box is empty. |
| Black | A box with multiple lies is empty. | Black is empty.            | A box with zero truths is empty.                     |

Translate Blue's first two claims with `forSomeBox someTrue empty` and `forSomeBox someFalse empty`. White's top claim uses `allTrue`, requiring all its selected box's statements to be true. Black's top claim needs a lambda comparing its selected box's false-statement count with one; its bottom claim uses a count of zero.

For White's bottom claim, inspect the text yourself: White and Black share their middle statement. Thus the eligible boxes are White and Black, and the claim becomes ``empty White `orStatement` empty Black``. The solver stores your translations, not the original wording, so it cannot discover duplicated text automatically.

```haskell
module Puzzle (puzzle) where

import Parlor (Box (Black, Blue, White))
import Vocab

puzzle =
  [ ( Blue,
      [ forSomeBox someTrue empty,
        forSomeBox someFalse empty,
        empty White
      ]
    ),
    ( White,
      [ forSomeBox allTrue empty,
        empty Black,
        empty White `orStatement` empty Black
      ]
    ),
    ( Black,
      [ forSomeBox
          (\box -> boxFalseStatementsCount box `moreThan` count 1)
          empty,
        empty Black,
        forSomeBox
          (\box -> boxTrueStatementsCount box `eq` count 0)
          empty
      ]
    )
  ]
```

Expected result: `Determinate Black`. Blue's truth list is `[True,True,True]`, White's is `[True,False,True]`, and Black's is `[False,False,False]`.

## When wording needs manual interpretation

The vocabulary does not directly read letters, count printed words, recognize duplicate statements, or observe the room. Resolve those fixed details yourself, then encode the logical claim they imply. For example, a claim selecting boxes whose text contains a particular word can become an “or” over the eligible boxes. Use `truth` or `lie` only when the entire claim is fixed by those observed facts.

There is also no exported vocabulary helper for the truth of a specific numbered statement. `allTrue Blue` means every statement on Blue is true; it does not select Blue's first statement. Such references require additional Haskell beyond this vocabulary guide. Avoid replacing an individual-statement reference with a whole-box claim unless the box has only one statement.

## Troubleshooting

| Problem                                                 | What to check                                                                                                                                         |
| ------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ghcup`, `ghc`, or `cabal` is not found.                | Reopen the terminal after installation. Check GHCup's shell/PATH setup in its installation guide.                                                     |
| Cabal cannot find the project.                          | Open the terminal in the folder containing `parlor-solver.cabal`.                                                                                     |
| Dependency resolution fails with a `base` constraint.   | Run `ghc --version` and select GHC 9.10.2 with GHCup. A newer compiler series may supply an incompatible `base`.                                      |
| Downloads or the package index fail.                    | Check your connection and run `cabal update` again.                                                                                                   |
| A parse error points at a comma, bracket, or next line. | Check the preceding expression too. Balance parentheses/brackets and put commas between statement entries, with none after the last.                  |
| A name is “not in scope.”                               | Check spelling and capitalization against `Vocab.hs`, and preserve both imports in `Puzzle.hs`.                                                       |
| A type error appears.                                   | Supply a box to predicates, compare counts with `count`, and pass a lambda when a selector needs a custom box predicate.                              |
| The solution is unexpected or contradictory.            | Encode each claim as written; check “some” versus “all,” statement counts versus box counts, implication direction, grouping, and blank-box behavior. |
| Your edits seem ignored.                                | Save `Puzzle.hs` before running `cabal run` again.                                                                                                    |
