procedure rec_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: REC_01F9.PRG
 \ Data....: 14-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valida‡„o do campo ENDERECO, arquivo RECIBOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas


PARAMETROS('impnrrec',numero)
PARAMETROS('mproc1',LEFT(processo,5))
PARAMETROS('mproc2',RIGHT(processo,2))
RETU .T.  // <- deve retornar um valor L¢GICO

* \\ Final de REC_01F9.PRG
