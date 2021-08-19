procedure r02701f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R02701F9.PRG
 \ Data....: 24-12-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: motivo do relat¢rio ADM_R027 // N„o impress„o do recibo
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
 CASE mqtcircs>=IIF(ARQGRUP->poratend=[S],(GRUPOS->funerais+1),1)*ARQGRUP->qtdremir
  doneaux:=[Remido]
 CASE CTOD('01/'+TRAN(GRUPOS->saitxa,"@R 99/99")) > (CTOD('01/'+TRAN(CIRCULAR->mesref,'@R 99/99')))
  doneaux:=[SaiTxa > Emissao]
ENDCASE

RETU doneaux      // <- retorna vazio se contrato em codic”es de emiss„o.

* \\ Final de R02701F9.PRG
