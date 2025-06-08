ocamlfind ocamlopt -linkpkg -package yojson,unix main.ml -o pomo

mkdir -p ~/.local/bin
cp pomo ~/.local/bin/