procedure adm_rv44
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_RV44.PRG
 \ Data....: 28-10-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: N„o Sai Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=20, l_i:=16, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+12 SAY " NŽO SAI TAXAS VIP "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Emiss„o:"
@ l_s+02,c_s+1 SAY " Grupo..:      De:       -"
@ l_s+03,c_s+1 SAY " £ltima Circular.:"
@ l_s+04,c_s+1 SAY " Pr¢xima Circular:        Confirme:"
remissao_=CTOD('')                                 // Emiss„o
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+11 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_)~Informe uma data v lida p/ EMISSŽO | data de hoje ou posterior.")
                  DEFAULT "CTOD('05'+SUBSTR(DTOC(DATE()+30),3))"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

 @ l_s+02 ,c_s+11 GET  rgrupo;
                  PICT "!9";
		  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(M->rgrupo)~GRUPO n„o existe na tabela")
		  DEFAULT "M->mgrupvip"
		  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
		  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
		  MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 20 }
		  MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 27 }
		  MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 3 , 20 }
		  MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 3 , 24 }

 @ l_s+04 ,c_s+20 GET  rproxcirc;
		  PICT "999";
		  VALI CRIT("rproxcirc>=ARQGRUP->ultcirc~A Pr¢xima circular deve ser maior|ou igual a £ltima emitida")
		  AJUDA "Entre com o n£mero da pr¢xima circular"
		  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+04 ,c_s+37 GET  confirme;
		  PICT "!";
		  VALI CRIT("confirme='S'.AND.V03001F9()~CONFIRME n„o aceit vel")
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
  IF !USEARQ("GRUPOS",.t.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(tipcont,"CLASSES",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(grupo,"ARQGRUP",1,.t.)
 PTAB(grupo+ARQGRUP->proxcirc,"CIRCULAR",1,.t.)
 SET RELA TO tipcont INTO CLASSES,;                // relacionamento dos arquivos
	  TO grupo INTO ARQGRUP,;
	  TO grupo+ARQGRUP->proxcirc INTO CIRCULAR
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,39,11)           // nao quis configurar...
  CLOS ALL                                         // fecha arquivos e
  LOOP                                             // volta ao menu
 ENDI
 IF tps=2                                          // se vai para arquivo/video
  arq_=ARQGER()                                    // entao pega nome do arquivo
  IF EMPTY(arq_)                                   // se cancelou ou nao informou
   LOOP                                            // retorna
  ENDI
 ELSE
  arq_=drvporta                                    // porta de saida configurada
 ENDI
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  qqu056=0                                         // contador de registros
  DO WHIL !EOF()
   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI

   IF !(EMPT(M->rgrupo).OR.grupo=M->rgrupo)
    SKIP
    LOOP
   ENDI

   IF ARQGRUP->proxcirc<'001'
    SKIP
    LOOP
   ENDI

   IF (CLASSES->prior=[S].AND.!EMPT(rv4401f9())).OR.;
    situacao=[2]      // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(codigo,"999999")             // Codigo
    @ cl,007 SAY grupo                             // Gr
    @ cl,010 SAY TRAN(tipcont,"99")                // TC
    @ cl,013 SAY TRAN(formapgto,"99")              // FP
    @ cl,016 SAY TRAN(admissao,"@D")               // Admiss„o
    @ cl,025 SAY TRAN(tcarencia,"@D")              // Carˆncia
    @ cl,034 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
    @ cl,041 SAY TRAN(regiao,"999")                // Reg
		@ cl,045 SAY TRAN(cobrador,"!!!")               // Cob
    @ cl,050 SAY TRAN(funerais,"99")               // Fun
    @ cl,053 SAY TRAN(ultcirc,"999")               // U.C.
    @ cl,058 SAY RV4401F9()                        // Motivo
    qqu056++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu056,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(39)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|NŽO SAI TAXAS"
ALERTA()
op_=2 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1

 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE GRUPOS                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF CLASSES->prior=[S].AND.!EMPT(rv4401f9())      // se atender a condicao...

   #ifdef COM_REDE
    IF ARQGRUP->proxcirc<M->rproxcirc
     REPBLO('ARQGRUP->proxcirc',{||M->rproxcirc})
     exit
    ENDI
   #else
    IF ARQGRUP->proxcirc<M->rproxcirc
     REPL ARQGRUP->proxcirc WITH M->rproxcirc
     exit
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,070 SAY "ADM_RV44"                            // c¢digo relat¢rio
 @ 2,000 SAY "NÆO SAI TAXAS"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Codigo Gr TC FP Admiss„o Carˆncia Saitxa Reg Cob Fun U.C. Motivo",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_RV44.PRG
