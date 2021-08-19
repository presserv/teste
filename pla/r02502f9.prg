procedure r02502f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R02502F9.PRG
 \ Data....: 23-09-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: MOTIVO do relat¢rio ADM_R028
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

IF !PTAB(codigo+circ,'TAXAS',1)
 RETU [Nao cadastrada]
ELSEIF TAXAS->valorpg>0
 RETU [Taxa baixada  ]
ENDIF

RETU []
* \\ Final de R02502F9.PRG
