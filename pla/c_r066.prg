procedure c_r066
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADC_R066.PRG
 \ Data....: 08-08-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Impress„o 2¦Via
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=13, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " IMPRESSŽO 2¦VIA "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Tipo....:"
@ l_s+02,c_s+1 SAY " Confirme:"
rtipo=SPAC(1)                                      // Tipo
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rtipo;
                  PICT "!";
                  VALI CRIT("rtipo $ [123]~TIPO n„o aceit vel|Tecle F8 para consulta")
                  AJUDA "Qual o tipo de Lan‡amento"
                  CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"

 @ l_s+02 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~CONFIRME n„o aceit vel|Digite S para confirmar|ou|Tecle ESC para cancelar")
                  AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI

 #ifdef COM_REDE
  IF !USEARQ("TX2VIA",.t.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TX2VIA")                                 // abre o dbf e seus indices
 #endi

 GO TOP
 DO WHILE ! EOF()

 IF !PTAB(M->rcodigo+M->rtipo+M->rcirc,[TAXAS],1)
  PTAB(M->rcodigo+SUBSTR('678  123',VAL(M->rtipo),1)+M->rcirc,[TAXAS],1)
 ENDI
 IF !EOF()
  ult_reg:=RECNO()  // imprime relatorio apos inclusao
  msg_t="IMPRESSŽO DAS TAXAS"
  SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
  tps=TP_SAIDA(,,.t.)            // escolhe a impressora
  IF LASTKEY()=K_ESC             // se teclou ESC
   EXIT                          // cai fora...
  ENDI
  IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
   IF tipo$'38'
    ADP_R044(tps,0,ult_reg)
   ENDI
   IF tipo$'27'
    ADM_RV33(tps,0,ult_reg)
   ENDI
   IF !(tipo$'2378')
    ADP_R066(tps,0,ult_reg)
   ENDI
 #else
  IF PREPIMP(msg_t)              // confima preparacao da impressora
   IF tipo$'38'
    ADP_R044(0,0,ult_reg)
   ENDI
   IF tipo$'27'
    ADM_RV33(0,0,ult_reg)
   ENDI
   IF !(tipo$'2378')
    ADP_R066(0,0,ult_reg)
   ENDI
 #endi

  REST SCREEN                    // restaura tela
  ENDI
 ENDI
ENDD
RETU

* \\ Final de ADP_RX44.PRG
