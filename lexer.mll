{
  open Parser
  open Lexing

  let nextLine lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
    { pos with pos_bol = pos.pos_cnum;
               pos_lnum = pos.pos_lnum + 1 }
}

let nl               = "\r\n"|"\r"|"\n"
let inlineComment    = "--" [^ '\n' '\r']* (nl|eof)
let multilineComment = "{-" [^ '-']* '-' ([^ '-' '}'][^ '-']* '-' | '-')* '}'
let comment          = inlineComment | multilineComment

let lat1   = [^ '\t' ' ' '\r' '\n' '(' ')' ',']
let beg    = lat1 # '-'
let bytes2 = ['\192'-'\223']['\128'-'\191']
let bytes3 = ['\224'-'\239']['\128'-'\191']['\128'-'\191']
let bytes4 = ['\240'-'\247']['\128'-'\191']['\128'-'\191']['\128'-'\191']

let digit = ['0'-'9']
let nat   = digit+

let utf8  = lat1|bytes2|bytes3|bytes4
let ident = beg utf8*
let ws    = ['\t' ' ']

let succ  = "S"
let const = "C"
let proj  = "\xCF\x80" (* π *)
let comp  = "\xE2\x88\x98" (* ∘ *)
let recur = "\xCF\x81" (* ρ *)
let min   = "\xCE\xBC" (* μ *)

let defeq = ":=" | "\xE2\x89\x94" | "\xE2\x89\x9C" | "\xE2\x89\x9D" (* ≔ | ≜ | ≝ *)

rule main = parse
| nl         { nextLine lexbuf; main lexbuf }
| comment    { nextLine lexbuf; main lexbuf }
| ws+        { main lexbuf }
| ','        { COMMA }
| '('        { LPARENS }
| ')'        { RPARENS }
| const      { CONST }
| succ       { SUCC }
| proj       { PROJ }
| recur      { RECUR }
| min        { MIN }
| defeq      { DEFEQ }
| comp       { COMP }
| nat as s   { NAT (int_of_string s) }
| ident as s { IDENT s }
| eof        { EOF }