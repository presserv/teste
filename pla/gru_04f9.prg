procedure gru_04f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: GRU_04F9.PRG
 \ Data....: 18-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o do campo COBRADOR, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

IF VAL(cobrador)>0
 cobrador:=RIGHT([000]+ALLTRIM(cobrador),3)
ENDI

RETU PTAB(cobrador,[COBRADOR],1)      // <- deve retornar um valor L¢GICO

* \\ Final de GRU_04F9.PRG
