procedure r07601f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: R07601F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora -CRD/COBRAN€A
 \ Funcao..: Condi‡„o de impress„o do campo Codigo, arquivo ADC_R076
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adPbig.ch"    // inicializa constantes manifestas
PARA mcod,mdataf,mdatai
LOCAL reg_dbf:=POINTER_DBF(), ct_tx:=0

PTAB(codigo,[TAXAS],1,.T.)
SELE TAXAS

impok:=EMPT(M->veni_)  //Imprimir se n„o pedir data inicial

DO WHILE !EOF() .AND. TAXAS->codigo=GRUPOS->codigo //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0
	SKIP
	LOOP
 ENDI
 IF TAXAS->emissao_ <= IIF(EMPT(M->venf_),DATE(),M->venf_)
	ct_tx++
	impok:=impok.or.(TAXAS->emissao_ >= M->veni_)   // S¢ vamos imprimir se existir uma
 ENDI
 SKIP
ENDDO

ct_tx:=IIF(impok,ct_tx,0)  // Se n„o ‚ para imprimir, vamos desconsiderar
													 // a contagem efetuada.
POINTER_DBF(reg_dbf)

RETU ct_tx       // <- deve retornar um valor L¢GICO

* \\ Final de R07601F9.PRG
