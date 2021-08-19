procedure ins_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: INS_02F9.PRG
 \ Data....: 31-03-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o do campo NASCTO_, arquivo INSCRITS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PRIV idmes
idmes := (YEAR(DATE()) - YEAR(nascto_))*12
idmes += (MONTH(DATE()) - MONTH(nascto_))
/*
IF op_menu=1.AND.idmes > (18*12) .AND. INSCRITS->grau>'6'
 DBOX([Inscrito com ]+STR(INT(idmes/12),2)+[ anos completos])
ENDI
*/
RETU .T.       // <- deve retornar um valor L¢GICO


* \\ Final de INS_02F9.PRG
