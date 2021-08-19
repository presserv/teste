procedure rv3301f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica
 \ Programa: RV3301F9.PRG
 \ Data....: 30-08-97
 \ Sistema.: Auxiliar de Personaliza‡„o
 \ Funcao..: PROCESSOS do relat¢rio ADM_RV33
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "pers.ch"      // inicializa constantes manifestas

LOCAL reg_dbf:=POINTER_DBF()
PUBL DETPRC[15]
AFILL(DETPRC,[])
PTAB(CIRCULAR->grupo+CIRCULAR->numero,[CPRCIRC],1)
SELE CPRCIRC
contx:=[0]
DO WHILE .NOT. EOF() .AND. contx<15
 contx+=1
 detprc[contx]:=CPRCIRC->num+[ ]+DTOC(CPRCIRC->dfal)+CPRCIRC->fal
 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU .t.      // <- deve retornar um valor qualquer

* \\ Final de RV3301F9.PRG
