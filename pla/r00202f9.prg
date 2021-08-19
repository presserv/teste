procedure r00202f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R00202F9.PRG
 \ Data....: 02-01-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: hist 1 do relat¢rio ADM_R002
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

 LOCAL reg_dbf1:=POINTER_DBF()
 LOCAL cipend:=0
 PUBLI circax1:=circax2:=circax3:=circax4:=[]
 PUBLI circax5:=circax6:=circax7:=circax8:=[]
 cod:=codigo
// PTAB(codigo,'TAXAS',1)
// PTAB(codigo,'GRUPOS',1)

 SELE TAXAS

 PTAB(codigo,'TAXAS',1,.t.)

 M->recvalor:=0
 DO WHILE !EOF().AND.TAXAS->codigo=cod
  IF TAXAS->valorpg>0         // Somente taxas pendentes
   SKIP
   LOOP
  ENDI
  IF TAXAS->circ=ARQGRUP->proxcirc         // Somente taxas pendentes
   SKIP
   LOOP
  ENDI
  circax1:=circax2
  circax2:=circax3
  circax3:=circax4
  circax4:=circax5
  circax5:=circax6
  circax6:=circax7
  circax7:=circax8
  circax8:=DTOC(TAXAS->emissao_)+TRANSF(TAXAS->valor,"@E 99,999.99")+;
     [ (]+TAXAS->tipo+[-]+TAXAS->circ+[)]
  M->recvalor+=TAXAS->valor
  SKIP
 ENDDO
 FOR cipend= 8 TO 1 STEP -1
  ccaux:="circax"+str(cipend,1)
  IF !EMPT(&ccaux)
   &ccaux=CHR(15)+STR(GRUPOS->qtcircs-(9-cipend),3)+[ ]+&ccaux+CHR(18)
  ENDI
 NEXT
 POINTER_DBF(reg_dbf1)

RETU []         // <- deve retornar um valor qualquer


* \\ Final de R00202F9.PRG
