type cmdline =
  | Check of string
  | Repl | Help

let help =
"\n  invocation = tacit | tacit list
        list = [] | command list

     command = check <filename>
             | repl | help"

let repl = ref false
let cmd : cmdline -> unit = function
  | Check filename -> Repl.check filename
  | Help -> print_endline help
  | Repl -> repl := true

let rec parseArgs : string list -> cmdline list = function
  | [] -> []
  | "check"     :: filename :: rest -> Check filename :: parseArgs rest
  | "help"      :: rest             -> Help :: parseArgs rest
  | "repl"      :: rest             -> Repl :: parseArgs rest
  | x :: xs -> Printf.printf "Unknown command “%s”\n" x; parseArgs xs

let defaults = function
  | [] -> [Help]
  | xs -> xs

let main () =
  Array.to_list Sys.argv |> List.tl
  |> parseArgs |> defaults |> List.iter cmd;
  if !repl then Repl.repl () else ()

let () = main ()
