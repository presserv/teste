procedure r07701f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R07701F9.PRG
 \ Data....: 26-12-97
 \ Sistema.: Administradora -CRD/COBRAN€A
 \ Funcao..: Express„o de filtro do relat¢rio ADC_R077.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adPbig.ch"    // inicializa constantes manifestas
donex:=(M->pag=[S].AND.TAXAS->valorpg>0)
donex:=donex.OR.(M->pend=[S].AND.TAXAS->valorpg=0)
//donex:=donex.AND.(EMPT(M->veni_).OR.TAXAS->emissao_>=M->veni_)
donex:=donex.AND.(EMPT(M->venf_).OR.TAXAS->emissao_<=M->venf_)

RETU M->donex       // <- deve retornar um valor L¢GICO

* \\ Final de R07701F9.PRG
