procedure p00302f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: P00302F9.PRG
 \ Data....: 04-04-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Express„o de filtro do relat¢rio SEG_P003.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
PRIV DONEX:=EMPT(rtipo).OR.tipo=rtipo
donex:=donex .AND. (SUBSTR('123  123',VAL(tipo),1)+circ > GRSEGUR->ulttipo+GRSEGUR->circ)
donex:=donex .AND. EMPT(valorpg)
donex:=donex .AND. emissao_>=M->remiss_.AND.emissao_<=M->remis2_
RETU donex       // <- deve retornar um valor L¢GICO

* \\ Final de P00302F9.PRG
