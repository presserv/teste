procedure r06901f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: R06901F9.PRG
 \ Data....: 30-01-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Condi‡„o para processamento TAXAS->valor, gerado por ADP_R069
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

   LOCAL reg_dbf:=POINTER_DBF()
     LOCAL doneaux:=.f.
     SELE TAXAS
     DO WHILE ! EOF() .AND.CODIGO=CSTSEG->contrato
      IF TAXAS->valorpg>0.OR.!(TAXAS->tipo=[3])
       SKIP
       LOOP
      ENDI
      IF TAXAS->emissao_ <M->rini_ .OR.TAXAS->emissao_>M->rfim_
       SKIP
       LOOP
      ENDI
      doneaux:=.t.
      keyaux:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
      EXIT
     ENDDO

   POINTER_DBF(reg_dbf)
   IF doneaux
    PTAB(keyaux,[TAXAS],1)
   ENDI
 RETU doneaux   // <- deve retornar um valor L¢GICO

* \\ Final de R06901F9.PRG
