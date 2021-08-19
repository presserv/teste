procedure vv4401f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: VV4401F9.PRG
 \ Data....: 24-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_RV44
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

#ifdef COM_REDE
     REPBLO('ARQGRUP->proxcirc',{||M->rproxcirc})
#else
 REPL ARQGRUP->proxcirc with M->rproxcirc
#endif

RETU .t.   // <- deve retornar um valor L¢GICO

* \\ Final de VV4401F9.PRG
