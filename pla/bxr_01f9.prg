procedure bxr_01f9
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

#include "adpbig.ch"    // inicializa constantes manifestas

     LOCAL reg_dbf:=POINTER_DBF(), xpend:=0
     LOCAL circax1:=circax2:=circax3:=circax4:=[]
     PTAB(codigo,'GRUPOS',1)

     PTAB(codigo,'TAXAS',1)

     SELE TAXAS
     DO WHILE !EOF().AND.TAXAS->codigo==GRUPOS->codigo
        xpend:=xpend+ IIF(EMPT(TAXAS->valorpg),1,0)
        circax1:=circax2
        circax2:=circax3
        circax3:=circax4
        circax4:=[ ]+TAXAS->tipo+[ ]+TAXAS->circ+[ ]+DTOC(TAXAS->emissao_)+[ ]+;
           TRANSF(TAXAS->valor,"@E 999,999.99")+[ ]+DTOC(TAXAS->pgto_)+;
           TRANSF(TAXAS->valorpg,"@E 999,999.99")
        SKIP
        @ l_s+09, c_s+46 SAY STR(xpend,3)
        @ l_s+12, c_s+2 SAY circax1
        @ l_s+13, c_s+2 SAY circax2
        @ l_s+14, c_s+2 SAY circax3
        @ l_s+15, c_s+2 SAY circax4
     ENDDO
     IF xpend > 4
      DBOX(STRZERO(xpend,2)+" Circulares Pendentes!",,,,,"ATEN€ŽO, "+usuario)
     ENDIF
     POINTER_DBF(reg_dbf)

RETU [ ]        // <- deve retornar um valor qualquer

* \\ Final de BXR_01F9.PRG
