procedure ins_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Funer ria Bom Pastor
 \ Programa: INS_01F9.PRG
 \ Data....: 21-11-94
 \ Sistema.: Controle da Organiza‡Æo
 \ Funcao..: Valor inicial do campo SEQ, arquivo INSCRITS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"   // inicializa constantes manifestas

IF (grau==[8] .AND. M->pgrau==[7]) .OR. grau<[7]
   M->pseq:=0
ENDIF
M->pgrau:=grau
M->pseq+=IIF(grau>[6],1,0)
RETU M->pseq

* \\ Final de INS_01F9.PRG
