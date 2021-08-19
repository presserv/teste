procedure r08704f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08704F9.PRG
 \ Data....: 28-10-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valor Mensal do relat¢rio ADP_R088
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL reg_dbf:=POINTER_DBF()
IF ultprc=CIRCULAR->grupo+CIRCULAR->circ.AND.;  // Se foi o ultimo contado.
   ARQGRUP->cpadmiss=[N]                  // Se nao compara admissao
  RETU contx
ENDI

ultprc:=M->rgrupo+M->rproxcirc
PTAB(ultprc,[CPRCIRC],1)
SELE CPRCIRC
contx:=0
DO WHILE .NOT. EOF() .AND. contx< 10.AND.ultprc=CPRCIRC->grupo+CPRCIRC->circ
 IF ARQGRUP->cpadmiss=[S].AND. GRUPOS->admissao>CPRCIRC->dfal
  SKIP
  LOOP
 ENDI
 contx+=1
 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU contx      // <- deve retornar um valor qualquer

* \\ Final de R08704F9.PRG
