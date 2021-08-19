procedure cab
clea
nrrec=500
@ 10,5 say [Informe o numero (aproximado) de recibos a imprimir: ] get nrrec
read
? [Coloque o recibo de cobranca na impressora e]
? [ tecle algo para continuar. ou Tecle ESC para cancelar]
k=0
k=inkey(0)
vez=0
set devi to prin
do while .not. (k=27)
 vez = vez+1
 if vez>nrrec
  exit
 endi
 @ 14,005 say  [    Rua Campos Sales, 564 - Centro - CEP 09015-200 - Santo Andr‚,SP ]
 eject
 if vez=1
  set devi to scre
  set prin off
  set prin to
  ? [Verifique a impress„o e tecle algo para continuar ou ESC para cancelar]
  k = inkey(0)
  set prin on
  set devi to prin
 else
  k=inkey()
 endi
enddo
set devi to scree

