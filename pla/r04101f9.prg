procedure r04101f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: R04101F9.PRG
 \ Data....: 03-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Express„o de filtro do relat¢rio ADM_R041.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
DO CASE
CASE (codigo<M->rcodin.AND.!(M->rcodin='000000')) // Contrato menor que
 RETU .f.                                        // o pedido.
CASE (codigo>M->rcodfi.AND.!(M->rcodfi='000000')) // contrato maior.
 RETU .f.
CASE (GRUPOS->ender_<M->rlanc1_.AND.!EMPT(M->rlanc1_)) //Lan‡ado antes
 RETU .f.
CASE (GRUPOS->ender_>M->rlanc2_.AND.!EMPT(M->rlanc2_)) //Lan‡ado depois
 RETU .f.
CASE M->rreimp=[S] // Se j  foi impresso, imprimir novamente.
 RETU .t.
ENDCASE
         // Bloqueio retirado em 08/01/2020 a pedido da Ana para impressão de um contrato
         // cadastrado dia 06/01/2020
RETU .T. //(GRUPOS->ultimp_=DATE())    //S¢ quero os n„o impressos


* \\ Final de R04101F9.PRG
