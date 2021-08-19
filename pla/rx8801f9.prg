procedure rx8801f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: RX8801F9.PRG
 \ Data....: 26-04-98
 \ Sistema.: Seguros
 \ Funcao..: Express„o de filtro do relat¢rio ADP_RX88.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL reg_dbf:=POINTER_DBF()
contrax:=CSTSEG->contrato
vlaux:=0
DO WHILE !EOF() .AND. contrax=CSTSEG->contrato
 IF !(circ<[001])
  SKIP
  LOOP
 ENDI
 vlaux+=CSTSEG->valor
 SKIP
ENDDO
POINTER_DBF(reg_dbf)

RETU vlaux       // <- deve retornar um valor L¢GICO

* \\ Final de RX8801F9.PRG
