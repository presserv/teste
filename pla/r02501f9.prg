procedure r02501f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R02501F9.PRG
 \ Data....: 24-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: MOTIVO do relat¢rio ADM_R025
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas
IF !PTAB(codigo+circ,'TAXAS',1)
 RETU [Nao cadastrada]
ELSEIF TAXAS->valorpg>0
 RETU [Taxa baixada  ]
*ELSEIF !(TAXAS->cobrador=BXFCC->cobrador)
* RETU [Cobr.Diferente]
ENDIF

RETU []
* \\ Final de R02501F9.PRG
