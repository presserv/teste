procedure txe_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica-Limeira (019)452.6623
 \ Programa: TXE_01F9.PRG
 \ Data....: 22-10-96
 \ Sistema.: Administradora -CRêD/COBRANÄA
 \ Funcao..: ValidaáÑo do campo CIRC, arquivo TXENTR
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
IF op_menu=INCLUSAO
__KEYBOARD(CHR(13)+CHR(13)+CHR(13))
ENDI
RETU.T.    // <- deve retornar um valor L¢GICO

* \\ Final de TXE_01F9.PRG
