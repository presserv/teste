procedure v09001f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: V09001F9.PRG
 \ Data....: 31-01-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Fun‡„o F8 da variavel QTDADE, relatorio ADP_R090
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas


RETU (VAL(BOLETOS->seq)-M->numinic+1)      // <- deve retornar um valor qualquer

* \\ Final de V09001F9.PRG
