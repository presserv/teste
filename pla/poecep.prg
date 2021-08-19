procedure poecep
SELE B
USE CEP
INDE ON NOME_LOG TO BB
?
SELE A
USE GRUPOS
INDE ON ENDERECO TO AA
DO WHILE .NOT. EOF()
 IF CEP!= [00000000]
  SKIP
  LOOP
 ENDI
 _endereco = ALLTRIM(endereco)
 _cidade=cidade
 CEP_OK = CEP
 ?? CEP_OK +[-]
 DO CASE

  CASE [SANTO]$_cidade
   _cidade=[SANTO ANDRE]
  CASE [ANDRE]$_cidade
   _cidade=[SANTO ANDRE]

  CASE [SUL]$_cidade
   _cidade=[SAO CAETANO DO SUL]
  CASE [CAETANO]$_cidade
   _cidade=[SAO CAETANO DO SUL]

  CASE [CAMPO]$_cidade
   _cidade=[SAO BERNARDO DO CAMPO]
  CASE [BERNARDO]$_cidade
   _cidade=[SAO BERNARDO DO CAMPO]

 ENDC
 pponto:=AT([.],_endereco)
 if pponto>0
  _endereco:=SUBSTR(_endereco,pponto+1)
 endi
 pvirgu:=AT([,],_endereco)
 if pvirgu>0
  _endereco:=LEFT(_endereco,pvirgu-1)
 endi
 SELE B
 SEEK _endereco
 ?? A->CODIGO,_ENDERECO,_CIDADE

 DO WHILE .NOT. EOF() .AND. nome_log=_endereco
  ?? [.]
  IF Local_log=_CIDADE
   Cep_ok = cep8_log
   exit
  endi

  skip
 endd
 sele a
 ?? [-]+CEP_OK +[   /   ]
 ?
  REPL CEP WITH CEP_OK
 skip
endd

