procedure cgr_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: GRU_02F9.PRG
 \ Data....: 22-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Fun‡„o F8 do campo CODIGO, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

SELE CGRUPOS
GO BOTT
rcodin:=sTRzero(VAL(numero)+1,6,0)
//POINTER_DBF(reg_dbf)

RETU M->rcodin       // <- deve retornar um valor qualquer

* \\ Final de GRU_02F9.PRG
