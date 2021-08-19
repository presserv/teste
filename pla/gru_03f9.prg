procedure gru_03f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: GRU_03F9.PRG
 \ Data....: 18-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o do campo VENDEDOR, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
IF VAL(vendedor)>0
 vendedor:=RIGHT([000]+ALLTRIM(vendedor),3)
ENDI

RETU PTAB(vendedor,[COBRADOR],1)      // <- deve retornar um valor L¢GICO

* \\ Final de GRU_03F9.PRG
