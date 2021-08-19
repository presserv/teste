procedure adp_r067
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R067.PRG
 \ Data....: 04-05-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerar contr.Cobradores
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=20, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+9 SAY " GERAR CONTR.COBRADORES "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Emiss„o.:"
@ l_s+02,c_s+1 SAY " Mˆs Ref.:              Confirme:"
remissao_=CTOD('')                                 // Emiss„o
remissa2_=CTOD('')                                 // Emiss„o
rmesref=SPAC(4)                                    // Mes.Ref.
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_)~Informe uma data v lida p/ EMISSŽO")
                  DEFAULT "DATE()"
                  AJUDA "Data da Emiss„o da Circular.| Data inicial a considerar."

 @ l_s+01 ,c_s+24 GET  remissa2_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissa2_)~Informe uma data v lida p/ EMISSŽO")
                  DEFAULT "DATE()"
                  AJUDA "Data da Emiss„o da Circular.| Data final a considerar."

 @ l_s+02 ,c_s+12 GET  rmesref;
                  PICT "@R 99/99";
                  VALI CRIT("MMAA(rmesref)~Necess rio informar MES.REF.")
                  DEFAULT "SUBSTR(DTOC(remissao_),4,2)+RIGHT(DTOC(remissao_),2)"
                  AJUDA "Mˆs de referˆncia da cobran‡a"

 @ l_s+02 ,c_s+35 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~CONFIRME n„o aceit vel")
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
  IF !USEARQ("TAXAS",.t.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo+tipo+circ,"TXENTR",3,.t.)             // abre arquivo p/ o relacionamento
 PTAB(cobrador,"COBRADOR",1,.t.)
 SET RELA TO codigo+tipo+circ INTO TXENTR,;        // relacionamento dos arquivos
          TO cobrador INTO COBRADOR
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="cobrador+DTOS(emissao_)"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,40,11)           // nao quis configurar...
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
 IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF
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
  tot059001 := 0                                   // inicializa variaves de totais
  qqu059=0                                         // contador de registros
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
   IF valorpg=0.and.emissao_>=M->remissao_.AND.emissao_<=M->remissa2_          // se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY [Cobrador: ]+COBRADOR->cobrador+[-]+COBRADOR->nome// titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb05901=cobrador                               // campo para agrupar 1a quebra
    qqu05901=0                                     // contador de registros
    DO WHIL !EOF() .AND. cobrador=qb05901
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF valorpg=0.and.emissao_>=M->remissao_.AND.emissao_<=M->remissa2_          // se atender a condicao...
      qqu05901++                                   // soma contadores de registros
      qqu059++                                     // soma contadores de registros
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    SKIP -1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Total:"
    tot059001+=valor
    @ cl,008 SAY TRAN(valor,"@E 999,999.99")       // Valor
    SKIP
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY "* Quantidade "+TRAN(qqu05901,"@E 999,999")
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,008 SAY REPL('-',10)
  @ ++cl,008 SAY TRAN(tot059001,"@E 999,999.99")   // total Valor
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,008 SAY "*** Quantidade total "+TRAN(qqu059,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(40)                                          // grava variacao do relatorio

#ifdef COM_REDE
 IF !USEARQ("TXENTR",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TXENTR")                                  // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT
msgt="PROCESSAMENTOS DO RELAT¢RIO|GERAR CONTR.COBRADORES"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TAXAS                                        // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF valorpg=0.and.emissao_>=M->remissao_.AND.emissao_<=M->remissa2_          // se atender a condicao...
   IF !PTAB(codigo+tipo+circ,'TXENTR',3)
    SELE TXENTR                                    // arquivo alvo do lancamento

    #ifdef COM_REDE
     TXE_CRIA_SEQ()
     SELE TXENTR
     TXE_GERA_SEQ()
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     TXE_GERA_SEQ()
     APPE BLAN                                     // cria registro em branco
    #endi

    TXE_GRAVA_SEQ()
    SELE TAXAS                                     // inicializa registro em branco
    REPL TXENTR->codigo WITH codigo,;
         TXENTR->tipo WITH tipo,;
         TXENTR->circ WITH circ,;
         TXENTR->valor WITH valor,;
         TXENTR->cob WITH cobrador,;
         TXENTR->mesref WITH M->rmesref

    #ifdef COM_REDE
     TXENTR->(DBUNLOCK())                          // libera o registro
    #endi

   ENDI
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE TAXAS                                         // salta pagina
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
 @ 1,070 SAY "ADP_R067"                            // c¢digo relat¢rio
 @ 2,000 SAY "GERAR CONTR.COBRADORES"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R067.PRG
