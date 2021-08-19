procedure accttxas
clea
? [Refazendo contagem das emitidas. (ultima-inicial+1)]
use grupos
repl qtcircs with val(ultcirc)-val(circinic)+1, qtcircpg with qtcircs for ultcirc>[000]
? [Reorganizando contratos para contagem das pendencias]
inde on codigo to grupos
? [Abrindo arquivo de taxas]
sele b
use taxas
? [Reorganizando com as pendentes]
inde on codigo to taxas for valorpg=0
? [Relacionando taxas & contratos]
set rela to codigo into a
go top
? [Refazendo a contagem de pendencias...]
do while .not. eof()
 if valorpg=0
  ?? [.]
  repl a->qtcircpg with a->qtcircpg - 1
 endi
 skip
endd
? [Contagem efetuada.]
