exception TypeChecker of string
exception Parser of int * string

let guard cond msg = if not cond then raise (TypeChecker msg) else ()
let unknown x = raise (TypeChecker (Printf.sprintf "Variable “%s” was not found" x))

let error : exn -> unit = function
  | TypeChecker msg -> Printf.printf "%s\n" msg
  | Parser (x, buf) -> Printf.printf "Parsing error at line %d: “%s”\n" x buf
  | ex -> Printf.printf "Uncaught exception: %s\n" (Printexc.to_string ex)
