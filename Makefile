FLAGS = -use-menhir -yaccflag "--explain" -ocamlc "ocamlc -w +a-4-29"

default: native

clean:
	ocamlbuild -clean

native:
	ocamlbuild $(FLAGS) tacit.native

byte:
	ocamlbuild $(FLAGS) tacit.byte -tag 'debug'
