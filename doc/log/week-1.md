# 1. :: 26 Sept - 2 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/1-learning-language` |
| time          | **Spend approximately 20 hours this week.**      |
| head          | `a4f0392`      |

## Time


Getting familiar with Eff. This means getting comfortable with the syntax, types, compiler and current optimizations.

The following are the files of interest in the Eff compiler:
* Optimization: `src/codegen/optimize.ml`
* Types: `src/syntax/typed.ml`
* Printing AST: `src/codegen/camlPrint.ml`
* AST generation: `src/codegen/codegen.ml`
* General printing: `src/utils/print.ml`
* Main file: `src/eff.ml`

## Tips
- The main website of Eff is :http://www.eff-lang.org/
- bitbucket: https://bitbucket.org/matijapretnar/eff
- Dependencies: Ocaml + Opam
- Compile command: `./eff.native -V 4 -n --compile filename.eff`
