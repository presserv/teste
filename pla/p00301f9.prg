procedure p00301f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: P00301F9.PRG
 \ Data....: 11-03-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Processo direto no campo vlempr, arquivo CSTSEG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
IF EMPT(GRSEGUR->ultemis_)
 RETU (YEAR(TAXAS->emissao_)-YEAR(GRSEGUR->aberseg_))*12+(MONTH(TAXAS->emissao_)-MONTH(GRSEGUR->aberseg_))+1
ENDI
RETU (YEAR(TAXAS->emissao_)-YEAR(GRSEGUR->ultemis_))*12+(MONTH(TAXAS->emissao_)-MONTH(GRSEGUR->ultemis_))
    // <- deve retornar um valor NUMRICO

* \\ Final de P00301F9.PRG
