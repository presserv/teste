procedure emc_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: EMC_02F9.PRG
 \ Data....: 20-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Lan‡amento em TAXAS->valorpg, gerado por EMCARNE
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
LOCAL sit_dbf:=POINTER_DBF()
proxcont:=[]
SELE EMCARNE
GO BOTT
proxcont:=RIGHT([000000]+ALLTRIM(STR(VAL(codigo)+1)),6)
POINTER_DBF(sit_dbf)

RETU proxcont       // <- deve retornar um valor NUMRICO

* \\ Final de EMC_02F9.PRG

