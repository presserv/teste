procedure cad_04f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: CAD_04F9.PRG
 \ Data....: 22-04-97
 \ Sistema.: Controle de Processos da Funer ria
 \ Funcao..: Valida‡„o do campo CONTRATO, arquivo CADPROC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adPbig.ch"    // inicializa constantes manifestas
para op_menu
 LOCAL reg_dbf1:=POINTER_DBF(), contraux:=GRUPOS->codigo
 LOCAL cipend:=vlpend:=0
IF !(op_menu=1)
 retu .t.
ENDI
msg:=LEFT(MEMOLINE(GRUPOS->obs,60,1),35)
IF !EMPT(msg)
 msg+=[|]
ENDI
msg+=LEFT(MEMOLINE(GRUPOS->obs,60,2),35)
IF !EMPT(msg)
 msg+=[|]
ELSE
 msg:=[]
ENDI
IF GRUPOS->funerais>0
 msg+=[|*** |ATENCAO: CONTRATO COM ]+STR(GRUPOS->funerais,2)+[ funerais.|]
ENDI
 IF PTAB(GRUPOS->codigo,'MENSAG',2)
  SELE MENSAG
  DO WHILE ! EOF() .AND. MENSAG->codigo = GRUPOS->codigo
   msg:=dtoc(lancto_)+' '+RTRIM(por)+' '+MENSAG->mens1+[|]+M->msg
   SKIP
  ENDDO
 ENDI
IF !EMPT(msg)
 op_=DBOX(msg,,,E_MENU,,"SITUACAO DO CONTRATO!") //
ENDI

 POINTER_DBF(reg_dbf1)

RETU .t.  // <- deve retornar um valor L¢GICO

* \\ Final de CAD_04F9.PRG
