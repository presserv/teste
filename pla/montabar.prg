procedure montabar
/********
 Passar como parametros:
 1- Codigo da Empresa - ate 15 bytes
 2- Nosso Numero - 10 Char
 3- Valor do titulo
*********/
STATIC FUNC MONTA_BARRA(wparcodemp,wnumcef,wti1valtit,wvenc)
   wti2numcef:=val(wnumcef)
   ctcodbarra:= "2379" + ;
      strzero(wvenc-ctod([07/10/1997]),4)+;
      strzero(wti1valtit * 100, 10) + ;
      SubStr(wparcodemp,11, 5)+left(wparcodemp,6)+;
      SubStr(wnumcef, 2, 14)

   soma:= 0
   fator:= 2
   for i:= 43 to 1 step -1
      soma:= soma + Val(SubStr(ctcodbarra, i, 1)) * fator++
      fator:= iif(fator = 10, 2, fator)
   next
   digcodbar:= Str(iif(11 - soma % 11 <= 1 .OR. 11 - soma % 11 > 9, ;
      1, 11 - soma % 11), 1)
   ctcodbarra:= SubStr(ctcodbarra, 1, 4) + digcodbar + ;
      SubStr(ctcodbarra, 5, 39)

   ct1cabpart:= "237" + "9" + SubStr(strzero(wti2numcef, 11), 1, 5)
   ct1digpart:= Str(digtver10(ct1cabpart), 1)
   ct1cabpart:= SubStr(ct1cabpart, 1, 5) + "." + ;
         SubStr(ct1cabpart, 6, 5) + ct1digpart + "  "
   ct2cabpart:= SubStr(strzero(wti2numcef, 11), 6, 5) + ;
         SubStr(wparcodemp, 1, 5)
   ct2digpart:= Str(digtver10(ct2cabpart), 1)
   ct2cabpart:= SubStr(ct2cabpart, 1, 5) + "." + ;
         SubStr(ct2cabpart, 6, 5) + ct2digpart + " "
   ct3cabpart:= SubStr(wparcodemp, 6, 10)
   ct3digpart:= Str(digtver10(ct3cabpart), 1)
   ct3cabpart:= SubStr(ct3cabpart, 1, 5) + "." + SubStr(ct3cabpart, ;
      6, 5) + ct3digpart + " "
   ct4cabpart:= digcodbar + " "
   ct5cabpart:= Strzero(wti1valtit * 100, 14)
   ctcabecalh:= ct1cabpart + ct2cabpart + ct3cabpart + ct4cabpart + ;
      ct5cabpart
RETU {ctcodbarra,ctcabecalh}


STATIC FUNCTION DIGTVER10(Arg1)
LOCAL Local1, Local2, Local3, Local4, Local5
Local1:= LEN(ALLTRIM(Arg1))
Local5:= 2
Local3:= 0
DO WHILE (LEN(ALLTRIM(Arg1)) != 0)
 Local2:= VAL(RIGHT(Arg1, 1))
 IF (Local2 * Local5 < 9)
  Local3:= Local3 + Local2 * Local5
 ELSE
  Local3:= Local3 + VAL(SUBSTR(STR(Local2 * Local5, 2, 0), 1, ;
  1)) + Val(SUBSTR(STR(Local2 * Local5, 2, 0), 2, 1))
 ENDI
 IF (Local5 == 2)
  Local5:= 1
 ELSEIF (Local5 == 1)
  Local5:= 2
 ENDI
 Arg1:= SUBSTR(Arg1, 1, Len(Arg1) - 1)
ENDD
RETU IIF(10 - Local3 % 10 != 10, 10 - Local3 % 10, 0)

********************************
********************************
STATIC FUNCTION DG_COBSI(Arg1)
   soma:= 0
   fator:= 2
   for i:= 10 to 1 step -1
      soma:= soma + Val(SubStr(Arg1, i, 1)) * fator++
      fator:= iif(fator = 10, 2, fator)
   next
   RETU arg1+ Str(iif(11 - soma % 11 > 9,0, 11 - soma % 11), 1)

********************************
