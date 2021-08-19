procedure adp_p007
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_P007.PRG
 \ Data....: 28-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerar carnˆ do contrato
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=10, l_i:=12, c_i:=51, tela_fp007:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " LAN€AMENTO DE PARCELAS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "    Contrato:"
@ l_s+02,c_s+1 SAY "    Gerar    parcelas de"
@ l_s+03,c_s+1 SAY "    com tipo  , n£mero inicial     e"
@ l_s+04,c_s+1 SAY "    vencimento a partir de"
rcodigo=SPAC(6)                                    // Codigo
parcf=0                                            // Parcf
vlparc=0                                           // Vlparc
rtipo=SPAC(1)                                      // Tipo
rcirc=SPAC(3)                                      // Circular
vini_=CTOD('')                                     // Vencimento
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+15 GET  rcodigo;
                  PICT "999999";
									VALI CRIT("1=1~Contrato cancelado |ou inexistente")
									AJUDA "Informe o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+02 ,c_s+11 GET  parcf;
									PICT "99";
                  VALI CRIT("parcf>0~PARCF n„o aceit vel")

 @ l_s+02 ,c_s+26 GET  vlparc;
                  PICT "99999999.99";
                  VALI CRIT("vlparc>0~VLPARC n„o aceit vel")

 @ l_s+03 ,c_s+14 GET  rtipo;
                  PICT "!";
                  VALI CRIT("!EMPT(rtipo)~TIPO n„o aceit vel")
                  AJUDA "Qual o tipo de lan‡amento"
                  CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ|4=Acerto|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])"

 @ l_s+03 ,c_s+32 GET  rcirc;
                  PICT "999";
                  VALI CRIT("!EMPT(rcirc)~Necess rio informar n£mero de CIRCULAR v lida")
									AJUDA "Informe o n£mero da circular inicial a gerar"

 @ l_s+04 ,c_s+28 GET  vini_;
									PICT "@D";
									VALI CRIT("!EMPT(vini_)~Necess rio informar Data v lida")
									AJUDA "Data da Vencimento Circular|Mantido pela emissao do recibo"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
	ROLATELA(.f.)
	LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
	RESTSCREEN(,0,MAXROW(),79,tela_fp007)                // restaura tela do fundo
	RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="GERAR CARNE DO CONTRATO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
//  CLOSE GRUPOS
	IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("TCARNES",.f.,10,1)                    // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TCARNES")                                 // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT

#ifdef COM_REDE
 IF !USEARQ("EMCARNE",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("EMCARNE")                                 // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT
 SELE GRUPOS                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 PTAB(M->rcodigo,[GRUPOS],1)
 DO WHIL !EOF().and.odometer()
  IF !PTAB(str(M->parcf,02,00)+rtipo+str(vlparc*parcf,8,2),[TCARNES],2)
   SELE TCARNES                                    // arquivo alvo do lancamento

   #ifdef COM_REDE
    TCA_CRIA_SEQ()
    SELE TCARNES
    TCA_GERA_SEQ()
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
		ENDD
   #else
    TCA_GERA_SEQ()
    APPE BLAN                                      // cria registro em branco
   #endi

   TCA_GRAVA_SEQ()
   SELE GRUPOS                                     // inicializa registro em branco
   REPL TCARNES->tipcob WITH M->rtipo,;
        TCARNES->formapgto WITH [01],;
        TCARNES->pari WITH 1,;
        TCARNES->vali WITH M->vlparc*parcf,;
        TCARNES->parf WITH M->parcf

   #ifdef COM_REDE
    TCARNES->(DBUNLOCK())                          // libera o registro
   #endi

  ENDI
  SELE EMCARNE                                     // arquivo alvo do lancamento

  #ifdef COM_REDE
   EMC_CRIA_SEQ()
   SELE EMCARNE
   EMC_GERA_SEQ()
   DO WHIL .t.
    APPE BLAN                                      // tenta abri-lo
    IF NETERR()                                    // nao conseguiu
     DBOX(ms_uso,20)                               // avisa e
		 LOOP                                          // tenta novamente
    ENDI
    EXIT                                           // ok. registro criado
   ENDD
  #else
   EMC_GERA_SEQ()
   APPE BLAN                                       // cria registro em branco
  #endi

  EMC_GRAVA_SEQ()
  SELE GRUPOS                                      // inicializa registro em branco
  REPL EMCARNE->codigo WITH M->rcodigo,;
       EMCARNE->vendedor WITH vendedor,;
       EMCARNE->tip WITH TCARNES->tip,;
       EMCARNE->circ WITH M->rcirc,;
       EMCARNE->vencto_ WITH M->vini_,;
			 EMCARNE->lancto_ WITH DATE(),;
			 EMCARNE->por WITH M->usuario,;
			 EMCARNE->parok WITH M->parcf

	#ifdef COM_REDE
	 EMCARNE->(DBUNLOCK())                           // libera o registro
	#endi
  mcodlan:=[EMC-]+EMCARNE->intlan+[-001-]
  FOR nparc=1 TO parcf
   nrcircax:=RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3)
   SELE TAXAS
   SEEK GRUPOS->codigo+rtipo+nrcircax
   IF EOF()
    SELE TAXAS                                      // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                     // tenta abri-lo
      IF NETERR()                                   // nao conseguiu
       DBOX(ms_uso,20)                              // avisa e
       LOOP                                         // tenta novamente
      ENDI
      EXIT                                          // ok. registro criado
     ENDD
    #else
     APPE BLAN                                      // cria registro em branco
    #endi

    SELE GRUPOS                                     // inicializa registro em branco
    REPL TAXAS->codigo WITH codigo,;
	       TAXAS->tipo WITH rtipo,;
	       TAXAS->circ WITH RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3),;
         TAXAS->codlan WITH [PG]+dtos(date())+left(time(),2)+;
             substr(time(),4,2)+M->usuario,;
         TAXAS->stat WITH [1],;
         TAXAS->codlan WITH mcodlan+RIGHT('00'+ALLTRIM(STR(nparc)),3)

   ENDI
   IF TAXAS->valorpg=0
    REPL TAXAS->emissao_ WITH P00801F9(vini_,nparc),;
	       TAXAS->valor WITH M->vlparc,;
	       TAXAS->cobrador WITH cobrador

    #ifdef COM_REDE
     TAXAS->(DBUNLOCK())                            // libera o registro
    #endi
   ENDI
   SELE GRUPOS
  NEXT

//  SKIP                                             // pega proximo registro
	exit
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
// ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
//CLOSE ALL                                          // fecha todos os arquivos e
RESTSCREEN(,0,MAXROW(),79,tela_fp007)                // restaura tela do fundo
RETU                                               // volta para o menu anterior

* \\ Final de ADP_P007.PRG
