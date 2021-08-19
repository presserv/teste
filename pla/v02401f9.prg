procedure v02401f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: V02401F9.PRG
 \ Data....: 03-01-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R024
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

/*
   -------------------------------------------------------------------
   Se abrir outros arquivos salve situacao anterior e restaure ao sair
   como no exemplo abaixo:
     LOCAL reg_dbf:=POINTER_DBF()
     ...        ...        ...        ...
     POINTER_DBF(reg_dbf)
     RETU
   -------------------------------------------------------------------
*/
   PARAMETROS('valor1',M->rvalor1)
   PARAMETROS('valor2',M->rvalor2)
   PARAMETROS('valor3',M->rvalor3)

RETU .t.   // <- deve retornar um valor L¢GICO

* \\ Final de V02401F9.PRG
