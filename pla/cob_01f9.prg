procedure cob_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: COB_01F9.PRG
 \ Data....: 17-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Fun‡„o F8 do campo COBRADOR, arquivo COBRADOR
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
 LOCAL reg_dbf:=POINTER_DBF()
 PTAB([],[COBRADOR],1)
 sele cobrador
 go bott

 rcodin:=IIF(!EOF(),strzero(val(cobrador)+1,3,0),[001])

 DO WHILE PTAB(M->rcodin,[COBRADOR],1)
	rcodin:=sTRzero(VAL(rcodin)+1,3,0)
 ENDD
 POINTER_DBF(reg_dbf)

RETU M->rcodin       // <- deve retornar um valor qualquer

* \\ Final de COB_01F9.PRG
