procedure v03001f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: V03001F9.PRG
 \ Data....: 15-07-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R030
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

#ifdef COM_REDE
 REPBLO('ARQGRUP->proxcirc',rproxcirc)
#else
 REPL ARQGRUP->proxcirc WITH rproxcirc
#endif
RETU .t.      // <- deve retornar um valor L¢GICO

* \\ Final de V03001F9.PRG
