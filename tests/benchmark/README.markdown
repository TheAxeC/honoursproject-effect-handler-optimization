# Running benchmarks

To compile the benchmarks, first install [OPAM](https://opam.ocaml.org).
Then, using OPAM, install the `core_bench` package:

    opam install core_bench

After everything is installed, you can go to `benchmarks` directory and compile the benchmark with

    ocamlbuild -use-ocamlfind benchmark.native

and run it with

    ./benchmark.native -quota 1
