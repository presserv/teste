procedure cgu_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: GRU_01F9.PRG
 \ Data....: 10-07-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valida‡„o do campo CODIGO, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistaa
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

     LOCAL reg_dbf:=POINTER_DBF()
     SELE ARQGRUP
     DO WHILE ! EOF()
      IF ARQGRUP->final < M->codigo
       SKIP
       LOOP
      ENDIF
      IF ARQGRUP->inicio > M->codigo
       SKIP
       LOOP
      ENDIF
      M->grupo = ARQGRUP->grup
      EXIT
     ENDDO

     POINTER_DBF(reg_dbf)

RETU (!EMPT(M->grupo))   // <- deve retornar um valor L¢GICO

* \\ Final de GRU_01F9.PRG
