procedure bxc_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: BXR_01F9.PRG
 \ Data....: 20-11-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: F¢rmula (Circ 1 - 4) a mostrar na tela de BXREC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

     LOCAL reg_dbf:=POINTER_DBF(), xpend:=0
     LOCAL circax1:=circax2:=circax3:=circax4:=[]
     PTAB(codigo,'GRUPOS',3)

     PTAB(codigo,'CARNES',1)

     SELE CARNES
     DO WHILE !EOF().AND.CARNES->codigo==GRUPOS->codigo
	xpend:=xpend+ IIF(EMPT(CARNES->valorpg),1,0)
	circax1:=circax2
	circax2:=circax3
	circax3:=circax4
	circax4:=[ ]+CARNES->parc +[  ]+DTOC(CARNES->vencto_)+[ ]+;
	   TRANSF(CARNES->valor,"@E 999,999.99")+[ ]+DTOC(CARNES->pgto_)+;
	   TRANSF(CARNES->valorpg,"@E 999,999.99")
	SKIP
	@ l_s+12, c_s+2 SAY circax1
	@ l_s+13, c_s+2 SAY circax2
	@ l_s+14, c_s+2 SAY circax3
	@ l_s+15, c_s+2 SAY circax4
	@ l_s+06, c_s+46 SAY STR(xpend,3)
     ENDDO


     POINTER_DBF(reg_dbf)

RETU []         // <- deve retornar um valor qualquer

* \\ Final de BXc_01F9.PRG
