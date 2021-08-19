procedure r00201f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R00201F9.PRG
 \ Data....: 24-12-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Pr‚-valida‡„o da variavel RECMENSAG, relaotiro ADM_R002
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
priva doneaux:=[],mqtcircs:=GRUPOS->qtcircs

IF GRUPOS->ultcirc=ARQGRUP->proxcirc
 mqtcircs-=1
ENDI
DO CASE
 CASE GRUPOS->situacao!=[1]
  doneaux:=[Cancelado]
 CASE mqtcircs>=(GRUPOS->funerais+1)*ARQGRUP->qtdremir
  doneaux:=[Remido]
 CASE GRUPOS->saitxa="9999"
  doneaux:=[Remido]
 CASE CTOD('01/'+TRAN(GRUPOS->saitxa,"@R 99/99")) > (CTOD('01/'+TRAN(CIRCULAR->mesref,'@R 99/99')))
  doneaux:=[SaiTxa > Emissao]
ENDCASE

RETU doneaux      // <- retorna vazio se contrato em codic”es de emiss„o.

* \\ Final de R00201F9.PRG

