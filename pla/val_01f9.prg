procedure val_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: VAL_01F9.PRG
 \ Data....: 26-04-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valor do relat¢rio ADP_R070
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
IF CLASSES->prior=[S]
 RETU (M->rvlaux+CLASSES->vlmensal+(GRUPOS->nrdepend*CLASSES->vldepend))*VAL(GRUPOS->formapgto)
ELSE
 M->rnraux:=1
 IF ARQGRUP->cpadmiss=[S].or.ARQGRUP->maxproc>ARQGRUP->acumproc
	 M->rnraux:=R08704F9()//+contx //LEN(detprc)
   IF ARQGRUP->maxproc=ARQGRUP->acumproc
    M->rnraux:=M->rnraux/ARQGRUP->acumproc
   ENDI

 ENDI

 RETU M->rnraux*(M->rvlaux+CLASSES->vlmensal+(CLASSES->vldepend*nrdepend))
ENDI
RETU 0       // <- deve retornar um valor qualquer

* \\ Final de VAL_01F9.PRG
