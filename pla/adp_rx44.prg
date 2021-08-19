procedure adp_rx44
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_RX44.PRG
 \ Data....: 08-08-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Uma a uma
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=16, l_i:=13, c_i:=59, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " TAXAS (2¦ VIA) "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Contrato:"
@ l_s+04,c_s+1 SAY " Circular:  -               Confirma?"
rcodigo=SPAC(6)                                    // Codigo
RTIPX=SPAC(1)                                      // Tipo
rcirc=SPAC(3)                                      // Circular
confirme=SPAC(1)                                   // Confirme?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rcodigo;
		  PICT "999999";
		  VALI CRIT("PTAB(rcodigo,'GRUPOS',1)~Necess rio informar CODIGO")
		  AJUDA "Informe o n£mero do contrato"
		  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'grupo','codigo','nome','cidade'},1,'codigo',[])"
		  MOSTRA {"LEFT(TRAN(GRUPOS->nome,[@!]),35)", 2 , 5 }
		  MOSTRA {"LEFT(TRAN(GRUPOS->endereco,[]),35)", 3 , 5 }

 @ l_s+04 ,c_s+12 GET  RTIPX;
		  PICT "!";
		  VALI CRIT("RTIPX $ [123456789]~TIPO n„o aceit vel")
		  AJUDA "Qual o tipo de lan‡amento"
		  CMDF8 "MTAB([1=J¢ia|2=Taxa|3=Carnˆ],[TIPO])"

 @ l_s+04 ,c_s+14 GET  rcirc;
		  PICT "999";
		  VALI CRIT("PTAB(rcodigo+RTIPX+rcirc,'TAXAS',1).OR.PTAB(rcodigo+SUBSTR('6789 1234',VAL(RTIPX),1)+rcirc,'TAXAS',1)~Necess rio informar CIRCULAR v lida")
		  AJUDA "Informe o n£mero da circular a imprimir"
		  CMDF8 "VDBF(6,3,20,77,'TAXAS',{'codigo','tipo','circ','emissao_','valor','pgto_','valorpg','cobrador','por'},1,'circ',[])"

 @ l_s+04 ,c_s+39 GET  confirme;
                  PICT "!";
		  VALI CRIT("confirme='S'~Digite S para confirmar|ou|Tecle ESC para cancelar")
		  AJUDA "Digite S para confirmar|ou|Tecle ESC para cancelar"

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
  CLOSE TAXAS
	IF !USEARQ("TAXAS",.F.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 IF !PTAB(M->rcodigo+M->RTIPX+M->rcirc,[TAXAS],1)
  PTAB(M->rcodigo+SUBSTR('6789 1234',VAL(M->RTIPX),1)+M->rcirc,[TAXAS],1)
 ENDI
 IF !EOF()
  ult_reg:=RECNO()  // imprime relatorio apos inclusao
  rcod1:=rcod2:=codigo+tipo+circ
  msg_t="IMPRESSŽO DAS TAXAS"
  SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
  tps=TP_SAIDA(,,.t.)            // escolhe a impressora
  IF LASTKEY()=K_ESC             // se teclou ESC
   EXIT                          // cai fora...
  ENDI
  IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
   DO CASE
   CASE tipo$'38'
    IIF(M->p_recp=[S],ADP_RP44(tps,0,ult_reg,rcod1),ADP_R044(tps,0,ult_reg,rcod1))
   CASE tipo$'27'
    IIF(M->p_recp=[S],ADM_RP33(tps,0,ult_reg,rcod1),ADM_RV33(tps,0,ult_reg,rcod1))
   OTHER
    IIF(M->p_recp=[S],ADM_RP38(tps,0,ult_reg,rcod1),ADP_R066(tps,0,ult_reg,rcod1))
   ENDC
 #else
  IF PREPIMP(msg_t)              // confima preparacao da impressora
   DO CASE
   CASE tipo$'38'
    IIF(M->p_recp=[S],ADP_RP44(0,0,ult_reg,rcod1),ADP_R044(0,0,ult_reg,rcod1))
   CASE tipo$'27'
    IIF(M->p_recp=[S],ADM_RP33(0,0,ult_reg,rcod1),ADM_RV33(0,0,ult_reg,rcod1))
   OTHER
    IIF(M->p_recp=[S],ADM_RP38(0,0,ult_reg,rcod1),ADP_R066(0,0,ult_reg,rcod1))
   ENDC
 #endi

  REST SCREEN                    // restaura tela
  ENDI
 ENDI
// EXIT
ENDD
RETU

* \\ Final de ADP_RX44.PRG
