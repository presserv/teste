procedure p00801f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: P00801F9.PRG
 \ Data....: 11-01-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Lan‡amento em TAXAS->emissao_, gerado por ADP_P008
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
PARA vini_,nr_mes
PRIV dataux, diaaux

diaaux:=LEFT(DTOC(vini_),3)+SUBSTR(DTOC(vini_-DAY(vini_)+1+(31*(nr_mes-1))),4)
IF GRUPOS->diapgto>[00]
 diaaux:=GRUPOS->diapgto+substr(diaaux,3)
ENDI

dataux:=CTOD(M->diaaux)
DO WHILE EMPT(M->dataux)
 diaaux:=STR(VAL(LEFT(diaaux,2))-1,2)+SUBSTR(diaaux,3)
 dataux:=CTOD(M->diaaux)
ENDD



RETU M->dataux      // <- deve retornar um valor DATA

* \\ Final de P00801F9.PRG
