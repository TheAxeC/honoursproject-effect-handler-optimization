# 3. :: 10 Okt - 16 Okt 2016

| Config        |          |
| ------------- |:--------:|
| src folder    | `src/3-check-for-optimization` |
| time          | **Spend approximately 16 hours this week.**      |
| head          | `a4f0392`      |

## Literature
Reading papers
- Handling Algebraic effects
- Programming with Algebraic Effects and Handlers

## Code snippets
First I thought I needed to optimize the following case:
```ocaml
with h handle
    functionCall (param)
```

However I need to be able to handle the case in which a function call is used in combination with other code.
```ocaml
with h handle
    functionCall (param) + 3
```

This code generates a Bind. This Bind is what I need to optimize.
```ocaml
((_f_283 5) >>
   (fun _gen_bind_81  -> value (Pervasives.(+) _gen_bind_81 5)))
```

Possible situations were we can optimize are:
* Function call is pure (does not use effects from enclosing handler)
* Tail call for the continuation in the Handler
