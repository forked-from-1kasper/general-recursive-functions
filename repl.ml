open Lexing
open Error
open Expr
open Vm

let lexfile filename = Lexing.from_channel (open_in filename)

let parse f lexbuf =
  try f Lexer.main lexbuf with Parser.Error ->
    raise (Parser (lexbuf.lex_curr_p.pos_lnum, lexeme lexbuf))

let st : ctx ref = ref Env.empty
let check filename = try
  Printf.printf "Parsing “%s”.\n" filename;
  List.iter (fun (x, e) ->
    let k = infer !st e in
    st := Env.add x (k, e) !st)
    (parse Parser.file (lexfile filename))
  with ex -> error ex

let repl () =
  try while true do
    print_string "> ";
    let recv = read_line () in
    try let (x, xs) = parse Parser.repl (Lexing.from_string recv) in
      Printf.printf "%d\n" (eval !st (Var x) xs)
    with ex -> error ex
  done with End_of_file -> ()