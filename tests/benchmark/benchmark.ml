open Core.Std
open Core_bench.Std

let run_interp = true

let () =
  if run_interp then begin
  Printf.printf "INTERPRETER BENCHMARK:\n";
  Command.run (Bench.make_command [
      Bench.Test.create ~name:"Optimized" (fun () -> Opt._bigTest_459);
      Bench.Test.create ~name:"Not optimized" (fun () -> Notopt._bigTest_500);
    ]);
  Printf.printf "\n\n"
  end
