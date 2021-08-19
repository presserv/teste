procedure adp_p002
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_P002.PRG
 \ Data....: 09-10-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Pr‚-emiss„o VIP
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0d
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=14, l_i:=15, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+21 SAY " EMISSŽO VIP "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Emiss„o........:"
@ l_s+02,c_s+1 SAY " Grupo..........:"
@ l_s+03,c_s+1 SAY " N§Proxima Circ.:            Confirme:"
remissao_=CTOD('')                                 // Emiss„o
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+19 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_).AND.remissao_>=DATE()~Informe uma data v lida p/ EMISSŽO | data de hoje ou posterior.")
                  DEFAULT "CTOD('05'+SUBSTR(DTOC(DATE()+30),3))"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

 @ l_s+02 ,c_s+19 GET  rgrupo;
                  PICT "!9";
                  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1)~GRUPO n„o existe na tabela")
                  DEFAULT "M->mgrupvip"
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"

 @ l_s+03 ,c_s+19 GET  rproxcirc;
                  PICT "999";
                  VALI CRIT("rproxcirc>=ARQGRUP->ultcirc~A Pr¢xima circular deve ser maior|ou igual a £ltima emitida")
                  AJUDA "Entre com o n£mero da pr¢xima circular"
                  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+03 ,c_s+40 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n„o aceit vel|Digite S ou Tecle ESC")
                  AJUDA "Digite S para confirmar |ou|Tecle ESC para cancelar"

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
  IF !USEARQ("GRUPOS",.t.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(tipcont,"CLASSES",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(grupo,"ARQGRUP",1,.t.)
 PTAB(ARQGRUP->grup+ARQGRUP->proxcirc,"CIRCULAR",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 SET RELA TO tipcont INTO CLASSES,;                // relacionamento dos arquivos
	  TO grupo INTO ARQGRUP,;
          TO ARQGRUP->grup+ARQGRUP->proxcirc INTO CIRCULAR,;
          TO cobrador INTO COBRADOR
 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 EXIT
ENDD

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.t.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

cod_sos=1
msgt="PR-EMISSŽO VIP"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE GRUPOS                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF CLASSES->prior=[S].AND.EMPT(rv4401f9())       // se atender a condicao...
   IF !PTAB(codigo+'2'+CIRCULAR->circ,'TAXAS',1)
    SELE TAXAS                                     // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     APPE BLAN                                     // cria registro em branco
    #endi

    SELE GRUPOS                                    // inicializa registro em branco
    REPL TAXAS->codigo WITH codigo,;
         TAXAS->tipo WITH [2],;
         TAXAS->circ WITH CIRCULAR->circ,;
         TAXAS->emissao_ WITH CIRCULAR->emissao_,;
	 TAXAS->valor WITH (CIRCULAR->valor+CLASSES->vlmensal+(nrdepend*CLASSES->vldepend))*VAL(formapgto),;
         TAXAS->cobrador WITH cobrador,;
         TAXAS->stat WITH '1'
    SELE TAXAS                                     // arquivo alvo do lancamento
    TAX_GET1(FORM_DIRETA)                          // faz processo do arq do lancamento

    #ifdef COM_REDE
     UNLOCK                                        // libera o registro
    #endi

    SELE GRUPOS                                    // arquivo origem do processamento
   ENDI

   #ifdef COM_REDE
    IF PTAB(codigo+'2'+CIRCULAR->circ,'TAXAS',1)
     REPBLO('TAXAS->emissao_',CIRCULAR->emissao_)
     REPBLO('TAXAS->valor',CLASSES->vlmensal+(nrdepend*CLASSES->vldepend))
     REPBLO('TAXAS->cobrador',cobrador)
    ENDI
   #else
    IF PTAB(codigo+'2'+CIRCULAR->circ,'TAXAS',1)
     REPL TAXAS->emissao_ WITH CIRCULAR->emissao_
     REPL TAXAS->valor WITH CLASSES->vlmensal+(nrdepend*CLASSES->vldepend)
     REPL TAXAS->cobrador WITH cobrador
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
 SELE GRUPOS                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
 RETU

* \\ Final de ADM_P002.PRG
