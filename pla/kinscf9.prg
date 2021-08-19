procedure kinscf9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: KINSCF9.PRG
 \ Data....: 19-08-95
 \ Sistema.: Controle de Processos da Funer ria V.á
 \ Funcao..: Fun‡„o F8 do campo CODDECL, arquivo CADPROC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

RETU INSCRITS->codigo+INSCRITS->grau+STR(INSCRITS->seq,02,00)

* \\ Final de KINSCF9.PRG
