procedure vx0902f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Grupo Bom Pastor
 \ Programa: V00902F9.PRG
 \ Data....: 17-08-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o da variavel RCODIG2, relatorio ADP_P009
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

     LOCAL reg_dbf:=POINTER_DBF()
     PTAB([],[ARQGRUP],1)
     gru2:=[  ]
     SELE ARQGRUP
     DO WHILE ! EOF()
      IF ARQGRUP->final < M->rcodig2
       SKIP
       LOOP
      ENDIF
      IF ARQGRUP->inicio > M->rcodig2
       SKIP
       LOOP
      ENDIF
      gru2 = ARQGRUP->grup
      EXIT
     ENDDO

     POINTER_DBF(reg_dbf)

RETU gru2   // <- deve retornar um valor L¢GICO

* \\ Final de V00902F9.PRG
