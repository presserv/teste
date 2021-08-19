procedure rv4401f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: RV4401F9.PRG
 \ Data....: 29-09-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Motivo do relat¢rio ADM_RV44
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

priva doneaux:=[],mqtcircs:=GRUPOS->qtcircs
IF GRUPOS->ultcirc=M->rproxcirc
 mqtcircs-=1
ENDI
DO CASE
 CASE GRUPOS->situacao!=[1]
	doneaux:=[Cancelado        ]
 CASE mqtcircs>=IIF(ARQGRUP->poratend=[S],(MAX(GRUPOS->funerais,0)+1),1)*ARQGRUP->qtdremir
	doneaux:=[Remido]
 CASE GRUPOS->saitxa=[9999]
	doneaux:=[Remido]
 CASE VAL_01F9()=0
	doneaux:=[Taxa zerada]
 CASE CTOD('01/'+TRAN(GRUPOS->saitxa,"@R 99/99")) > M->remissao_
	doneaux:=[SaiTxa > Emissao ]
 CASE EMPT(VAL(GRUPOS->ultcirc)).OR.GRUPOS->ultcirc=M->rproxcirc
	doneaux:=[]
 CASE CLASSES->prior=[S].AND.(VAL(M->rproxcirc)<(VAL(GRUPOS->ultcirc)+VAL(GRUPOS->formapgto)))
	doneaux:=[N„o sai neste mes]
ENDCASE
RETU doneaux      // <- retorna vazio se contrato em codic”es de emiss„o.

* \\ Final de RV4401F9.PRG
