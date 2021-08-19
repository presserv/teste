procedure r01801f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R01801F9.PRG
 \ Data....: 07-08-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: codigo de barras do relat¢rio ADM_RS18
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

 @ cl,001 say ' '+CHR(18)
 SETPRC(cl,1)               // retorna cabeca impressora
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
set printer to 'LPT1'
set devi to prin
cl:=prow()
 twinic()
 twdeflbars(2, 6)
 twdefprint(twepson)
 twdefalt(8)
 twdefcode(twc25)
 twdefsalto(12)
 @ cl,001 SAY ' ' + BARCODE(BXREC->codigo+BXREC->circ,15)
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 lpp_004=LEFT(drvtapg,op_-1)+"004"+SUBS(drvtapg,op_+3)
 IMPCTL(lpp_004)                                    // seta pagina com 66 linhas
 cl:=Prow()
 @ cl,089 SAY chr(18)                 // normal
//@ cl+9,001 say '  '

RETU []      // <- deve retornar um valor qualquer


* \\ Final de R01801F9.PRG
