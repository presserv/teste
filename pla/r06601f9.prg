procedure r06601f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R06601F9.PRG
 \ Data....: 22-01-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Express„o de filtro do relat¢rio ADP_R066.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
PRIVA DONEIMP:=TAXAS->stat<[2] //CLASSES->prior=[S]
M->doneimp:=doneimp .AND.emissao_>=M->rem1_
M->doneimp:=doneimp .AND.emissao_<=M->rem2_
M->doneimp:=doneimp .AND.valorpg=0
M->doneimp:=doneimp .AND.(tipo$'16')
M->doneimp:=doneimp .AND.(M->rcod1='000000'.OR.codigo>=M->rcod1)
M->doneimp:=doneimp .AND.(M->rcod2='000000'.OR.codigo<=M->rcod2)
RETU M->doneimp       // <- deve retornar um valor L¢GICO

* \\ Final de R06601F9.PRG
