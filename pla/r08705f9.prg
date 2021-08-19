procedure r08705f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08705F9.PRG
 \ Data....: 31-01-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Lan‡amento em BOLETOS->nnumero, gerado por ADP_R087
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
donex:=M->rnnum
M->rnnum:=STRZERO(VAL(M->rnnum)+1,10)
//TRAN(VAL(M->rnnum)+1,[9999999999])
RETU M->donex       // <- deve retornar um valor CARACTER

* \\ Final de R08705F9.PRG
