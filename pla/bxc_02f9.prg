procedure bxc_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: BXR_02F9.PRG
 \ Data....: 28-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valor inicial do campo VALORPG, arquivo BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

PARAMETROS('mcodigo',codigo)
PARAMETROS('mcirc',circ)
PARAMETROS('nrauxrec',ano+numero)
IF op_menu = INCLUSAO
 grupo=GRUPOS->grupo
ELSE
 REPL grupo WITH GRUPOS->grupo
ENDIF
RETU IIF(EMPT(CARNES->valorpg),CARNES->valor,CARNES->valorpg)


* \\ Final de BXR_02F9.PRG

