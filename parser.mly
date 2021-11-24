%{ open Expr %}

%token <string> IDENT
%token <int> NAT
%token EOF LPARENS RPARENS COMMA DEFEQ
%token CONST SUCC PROJ COMP RECUR MIN
%right COMP

%start <string * int list> repl
%start <file> file

%%

exp :
  | CONST NAT NAT { Const ($2, $3) }
  | PROJ NAT NAT { Proj ($2, $3) }
  | exp COMP LPARENS separated_list(COMMA, exp) RPARENS { Comp ($1, $4) }
  | exp COMP exp { Comp ($1, [$3]) }
  | RECUR exp0 exp0 { Recur ($2, $3) }
  | MIN exp0 { Min $2 }
  | exp0 { $1 }

exp0 :
  | SUCC { Succ }
  | NAT { Nat $1 }
  | IDENT { Var $1 }
  | LPARENS exp RPARENS { $2 }

decl : IDENT DEFEQ exp { ($1, $3) }
file : decl* EOF { $1 }

repl : IDENT LPARENS separated_list(COMMA, NAT) RPARENS { ($1, $3) }