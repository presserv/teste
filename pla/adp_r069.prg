procedure adp_r069
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R069.PRG
 \ Data....: 26-04-98
 \ Sistema.: Seguros
 \ Funcao..: Lan‡ar Custos nas Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=18, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+3 SAY " LAN€AR CUSTOS ADICIONAIS NAS TAXAS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "   As taxas que receber„o o valor dos"
@ l_s+02,c_s+1 SAY "  custos, est„o com Emiss„o/Vencimento"
@ l_s+03,c_s+1 SAY "           em que per¡odo?"
@ l_s+04,c_s+1 SAY "     De:              At‚:"
@ l_s+06,c_s+1 SAY "  Ignorar os custos adicionais com data"
@ l_s+07,c_s+1 SAY "  de emiss„o posterior a         ."
@ l_s+08,c_s+1 SAY "               Confirme"
rini_=CTOD('')                                     // De:
rfim_=CTOD('')                                     // At‚:
remiss_=CTOD('')                                   // Emiss„o
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+04 ,c_s+10 GET  rini_;
                  PICT "@D";
                  VALI CRIT("!EMPT(rini_)~Necess rio informar Data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+04 ,c_s+28 GET  rfim_;
                  PICT "@D";
                  VALI CRIT("!EMPT(rfim_)~Necess rio informar Data final a considerar")
                  DEFAULT "DATE()+35-DAY(DATE()+35)"
                  AJUDA "Informe a data final a considerar"

 @ l_s+07 ,c_s+26 GET  remiss_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remiss_)~Informe uma data v lida p/ EMISSŽO")
									DEFAULT "DATE()-DAY(DATE())"
                  AJUDA "Informe a data final dos custos a considerar"

 @ l_s+08 ,c_s+25 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme=[S].AND.(PTAB([],[TAXAS],1).or.1=1)~CONFIRME n„o aceit vel")
                  AJUDA "Digite S para confirmar ou Tecle ESC para cancelar"

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
  IF !USEARQ("CSTSEG",.t.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CSTSEG")                                 // abre o dbf e seus indices
 #endi

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="DTOS(emissao_)"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,3,11)            // nao quis configurar...
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
  tot012005:=tot012006 := 0                        // inicializa variaves de totais
  qqu012=0                                         // contador de registros
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
   IF circ<[001].AND.M->remiss_>emissao_.AND.(PTAB(contrato+[3],'TAXAS',1).AND.R06901F9())// se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY &drvpenf.+DTOC(emissao_)+&drvtenf.// titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb01201=emissao_                               // campo para agrupar 1a quebra
    qqu01201=0                                     // contador de registros
    DO WHIL !EOF() .AND. emissao_=qb01201
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF circ<[001].AND.M->remiss_>emissao_.AND.(PTAB(contrato+[3],'TAXAS',1).AND.R06901F9())// se atender a condicao...
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(hora,"99:99")              // Hora
      @ cl,006 SAY TRAN(historic,"999")            // Hist
      @ cl,011 SAY TRAN(contrato,"999999")         // Contr.
      @ cl,018 SAY TRAN(complement,"@!")           // Complemento
      tot012005+=qtdade
      @ cl,054 SAY TRAN(qtdade,"99999")            // Qtde.
      tot012006+=valor
      @ cl,060 SAY TRAN(valor,"999999.99")         // Valor
      IF R06901F9()                                // pode imprimir?
       @ cl,070 SAY TAXAS->tipo+[ ]+TAXAS->circ    // Circ.
      ENDI
      qqu01201++                                   // soma contadores de registros
      qqu012++                                     // soma contadores de registros
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "* Quantidade "+TRAN(qqu01201,"@E 999,999")
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,054 SAY REPL('-',15)
  @ ++cl,054 SAY TRAN(tot012005,"99999")           // total Qtde.
  @ cl,060 SAY TRAN(tot012006,"999999.99")         // total Valor
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu012,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(3)                                           // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|LAN€AR CUSTOS NAS TAXAS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE CSTSEG                                       // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  IF circ<[001].AND.M->remiss_>emissao_.AND.(PTAB(contrato+[3],'TAXAS',1).AND.R06901F9())// se atender a condicao...

   #ifdef COM_REDE
    REPBLO('TAXAS->valor',{||TAXAS->valor+valor})
    REPBLO('CSTSEG->tipo',{||TAXAS->tipo})
    REPBLO('CSTSEG->circ',{||TAXAS->circ})
   #else
    REPL TAXAS->valor WITH TAXAS->valor+valor
    REPL CSTSEG->tipo WITH TAXAS->tipo
    REPL CSTSEG->circ WITH TAXAS->circ
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
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
 @ 1,070 SAY "ADP_R069"                            // c¢digo relat¢rio
 IMPAC("LAN€AR CUSTOS NAS TAXAS",2,000)
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Hora  Hist Contr. Complemento                         Qtde.     Valor Circ."
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R069.PRG
