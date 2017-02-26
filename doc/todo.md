# Todo for the honoursprogramme

## Todo :: 26 Sept - 2 Okt 2016
- [x] Get familiar with Eff and OCaml syntax

## Todo :: 3 Okt - 9 Okt 2016
- [x] Get familiar with Eff and OCaml syntax
- [x] Read papers (3 done)
- [x] Study compiler structure
- [x] Study existing optimizations

## Todo :: 10 Okt - 16 Okt 2016
- [x] Make layout for main-log.md
- [x] Read papers (2 done)
- [x] Write log
- [x] Try value case in handler for optimization tests

## Todo :: 17 Okt - 23 Okt 2016
- [x] Write guide: syntax overview Ocaml and Eff
- [ ] Write optimization - no-effects-used
    * [x] Started first tests

## Todo :: 24 Okt - 30 Okt 2016
- [x] Explanation papers
- [x] Explain optimizations in Guide
- [x] Write optimization - no-effects-used
- [x] Write optimization - no-effects-used-first-part-of-bind
- [x] Run test suite
- [x] Run N-Queens
- [x] Reorder existing optimizations to be more efficient

- [x] Check if optimization works with interpreter: No
- [x] Add unoptimized file to be able to compare optimized and non-optimized

## Todo :: 31 Okt - 6 Nov 2016
- [x] Fix optimization
  * Fix is wrong

## Todo :: 7 Nov - 13 Nov 2016
- [x] Fix optimization using constraints
- [ ] Clone efficient-handlers benchmark repository
- [x] Write split-handler optimization: specialization

## Todo :: 14 Nov - 20 Nov 2016
- [x] Write split-handler optimization: specialization
- [x] Write split-handler optimization: generalization
- [x] Fix letin example optimization error
- [x] Fix apply example optimization error
- [x] Fix comment apply - purelambda optimization error
- [x] Add simpler automated testing
- [ ] Clone efficient-handlers benchmark repository

## Todo :: 21 Nov - 27 Nov 2016
- [x] Clone efficient-handlers benchmark repository
- [x] Write handler optimization: let-rec
- [ ] Write benchmark programs (monad transformers vb porten naar Eff: paper monad modular interpreter)
  * work in progress

## Todo :: 28 Nov - 4 Dec 2016
- [ ] Write benchmark programs (monad transformers vb porten naar Eff: paper monad modular interpreter)
  * used effects wrong

## Todo :: 5 Dec - 11 Dec 2016
- [x] Start working on ICFP paper: rewrite-rules
- [x] Write benchmark programs (monad transformers vb porten naar Eff: paper monad modular interpreter)

## Todo :: 12 Dec - 18 Dec 2016
- [x] let x = e1 in c1
- [x] pure => empty set
- [x] operational semantics
- [x] parser
- [ ] parser/interpreter inlining/optimizing code

## Todo :: 19 Dec - 25 Dec 2016
- [x] parser/interpreter inlining/optimizing code

## Todo :: 25 Dec 2016 - 01 Jan 2017
- [x] parser inlining/optimizing code

## Todo :: 03 Jan - 06 Jan 2017
- [x] fix benchmark to remove handlers
- [x] benchmark: make examples
- [x] push benchmarks to repo
- [x] ~~convert let to bind~~
- [x] ~~add pervasives/ compile with -no-pervasives~~

## Todo :: 06 Jan - 13 Jan 2017
- [x] small loop benchmark
- [ ] native parser (option + fail)
- [ ] native interpreter (option + fail)
- [ ] unoptimized loop benchmark

## Todo :: 13 Jan - 03 Feb 2017
- [x] exams

## Todo :: 03 Feb - 12 Feb 2017
- [x] unoptimized loop benchmark
- [x] read paper
- [x] nqueens: cps style native version
- [x] make result table in paper
- [ ] ~~native parser (option + fail) (parser will not be included in paper)~~
- [ ] ~~native interpreter (interpreter will not be included in paper)~~
- [ ] ~~check for lambda inlining => allow additional optimizations (no priority)~~

## Todo :: 13 Feb - 27 Feb 2017
- [x] multicore ocaml backend (Change eff file untill it works for multicore)
- [x] Eff directly in OCaml
- [x] Compiling links effect handlers for the ocaml backend / Liberating Effects with Rows and Handlers
- [x] handlers in action repository ocaml
- [x] compare interpreted version
- [x] read paper
- [ ] ~~native parser (option + fail + cps)~~
- [x] native interpreter
- [ ] ~~change definitions of primitives (free monad datatype => cps style)~~
- [x] try kayceesrk/eff_delimcc_ocaml => doesn't work
- [x] Delimcc message KC
- [x] multicore-links-queens benchmark: 9,10,11,12,13,14,15 queens
