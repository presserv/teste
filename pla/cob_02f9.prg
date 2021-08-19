procedure cob_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: COB_02F9.PRG
 \ Data....: 18-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o do campo COBRADOR, arquivo COBRADOR
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

IF VAL(cobrador) >0
 cobrador:=RIGHT([000]+ALLTRIM(cobrador),3)
ENDI

RETU .t.   // <- deve retornar um valor qualquer

* \\ Final de COB_02F9.PRG
