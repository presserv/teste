procedure txa_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: TXA_01F9.PRG
 \ Data....: 16-01-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: F¢rmula (TipCont) a mostrar na tela de TXACONTR
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PRIVA doneresp:=[]

doneresp:= GRUPOS->tipcont+[ Carnˆ:]+GRUPOS->vlcarne+[ F.Pgto.:]+GRUPOS->formapgto+[ ]
doneresp+= IIF(PTAB(GRUPOS->tipcont,'CLASSES',1),ALLTRIM(CLASSES->descricao),[])+[ ]

IF GRUPOS->formapgto<[01]
 RETU LEFT(doneresp,61)
ENDI

IF GRUPOS->formapgto<[05]
 doneresp+=SUBSTR(tbfpgto,(VAL(GRUPOS->formapgto)-1)*13+1,13)
ELSE
 doneresp+=GRUPOS->formapgto
ENDI

RETU LEFT(doneresp,61)  // <- deve retornar um valor qualquer
* \\ Final de TXA_01F9.PRG
