procedure adp_rx88
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_RX88.PRG
 \ Data....: 26-04-98
 \ Sistema.: Seguros
 \ Funcao..: Gerar Taxa c/Adicional
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=5, c_s:=14, l_i:=18, c_i:=64, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " CRIAR TAXAS DE SEGUROS "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY "     Esta rotina ir  lan‡ar como taxas todas"
@ l_s+03,c_s+1 SAY "  as cobran‡as adicionais ainda n„o lan‡adas"
@ l_s+04,c_s+1 SAY "      nas taxas de cobran‡a do Plano M£tuo."
@ l_s+06,c_s+1 SAY " Qual a data da cobran‡a a gerar ?"
@ l_s+07,c_s+1 SAY " Qual o valor m¡nimo a cobrar ?"
@ l_s+09,c_s+1 SAY "      Ignorar os custos com data de emiss„o"
@ l_s+10,c_s+1 SAY "              posterior a         ."
@ l_s+11,c_s+1 SAY "                  Confirma ?"
rini_=CTOD('')                                     // De:
rvalor=0                                           // Valor
remiss_=CTOD('')                                   // Emiss„o
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+06 ,c_s+36 GET  rini_;
                  PICT "@D";
                  VALI CRIT("!EMPT(rini_)~Necess rio informar Data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+07 ,c_s+33 GET  rvalor;
                  PICT "@E 999,999.99";
                  VALI CRIT("!(rvalor<0)~VALOR n„o aceit vel|Deve ser um valor positivo")
                  AJUDA "Informe o valor m¡nimo acumulado|do seguro para gerar a cobran‡a?"

 @ l_s+10 ,c_s+27 GET  remiss_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remiss_)~Informe uma data v lida p/ EMISSŽO")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final dos custos a considerar"

 @ l_s+11 ,c_s+30 GET  confirme;
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
  IF !USEARQ("CSTSEG",.t.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CSTSEG")                                 // abre o dbf e seus indices
 #endi

 PTAB(contrato,"GRUPOS",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
 SET RELA TO contrato INTO GRUPOS,;                // relacionamento dos arquivos
          TO GRUPOS->grupo INTO ARQGRUP
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="contrato"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,4,11)            // nao quis configurar...
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
  tot013006:=tot013007 := 0                        // inicializa variaves de totais
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
   IF circ<[001].AND.M->remiss_>emissao_.AND.(RX8801F9()>M->rvalor.OR.(PTAB(contrato+[3]+ARQGRUP->proxcirc,[TAXAS],1).AND.TAXAS->valorpg=0))// se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY &drvpenf.+DTOC(emissao_)+&drvtenf.// titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb01301=emissao_                               // campo para agrupar 1a quebra
    DO WHIL !EOF() .AND. emissao_=qb01301
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF circ<[001].AND.M->remiss_>emissao_.AND.(RX8801F9()>M->rvalor.OR.(PTAB(contrato+[3]+ARQGRUP->proxcirc,[TAXAS],1).AND.TAXAS->valorpg=0))// se atender a condicao...
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      IF (RX8801F9()>0)                            // pode imprimir?
       @ cl,000 SAY TRAN(emissao_,"@D")            // Emiss„o
      ENDI
      @ cl,009 SAY TRAN(hora,"99:99")              // Horas
      @ cl,015 SAY TRAN(historic,"999")            // Hist
      @ cl,020 SAY TRAN(contrato,"999999")         // Contr.
      @ cl,027 SAY TRAN(&drvpcom+complement+&drvtcom,"@!")// Complemento
      tot013006+=qtdade
      @ cl,058 SAY TRAN(qtdade,"99999")            // Qtdade
      tot013007+=valor
      @ cl,064 SAY TRAN(valor,"999999.99")         // Valor
      IF PTAB(contrato+[3]+ARQGRUP->proxcirc,[TAXAS],1)// pode imprimir?
       @ cl,074 SAY TAXAS->tipo+[ ]+TAXAS->circ    // Circ.
      ENDI
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,058 SAY REPL('-',15)
  @ ++cl,058 SAY TRAN(tot013006,"99999")           // total Qtdade
  @ cl,064 SAY TRAN(tot013007,"999999.99")         // total Valor
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(4)                                           // grava variacao do relatorio

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.t.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

msgt="PROCESSAMENTOS DO RELAT¢RIO|GERAR TAXA C/ADICIONAL"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE CSTSEG                                       // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  IF circ<[001].AND.M->remiss_>emissao_.AND.(RX8801F9()>M->rvalor.OR.(PTAB(contrato+[3]+ARQGRUP->proxcirc,[TAXAS],1).AND.TAXAS->valorpg=0))// se atender a condicao...
   SELE TAXAS
   SEEK contrato+[3]+ARQGRUP->ultcirc
   IF EOF() //!PTAB(contrato+[3]+ARQGRUP->ultcirc,[TAXAS],1)
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

    SELE CSTSEG                                    // inicializa registro em branco
    REPL TAXAS->codigo WITH contrato,;
         TAXAS->tipo WITH [3],;
	       TAXAS->circ WITH ARQGRUP->ultcirc,;
         TAXAS->emissao_ WITH M->rini_,;
         TAXAS->cobrador WITH IIF(PTAB(contrato,[GRUPOS],1),GRUPOS->cobrador,[  ]),;
         TAXAS->codlan WITH [PS]+dtos(date())+left(time(),2)+;
             substr(time(),4,2)+M->usuario

    #ifdef COM_REDE
     TAXAS->(DBUNLOCK())                           // libera o registro
    #endi

   ENDI
   SELE CSTSEG
   #ifdef COM_REDE
    IF TAXAS->valorpg=0 //PTAB(contrato+[3]+ARQGRUP->proxcirc,[TAXAS],1)
     REPBLO('TAXAS->valor',{||TAXAS->valor+valor})
     REPBLO('CSTSEG->tipo',{||TAXAS->tipo})
     REPBLO('CSTSEG->circ',{||TAXAS->circ})
    ENDI
   #else
    IF PTAB(contrato+[3]+ARQGRUP->proxcirc,[TAXAS],1)
     REPL TAXAS->valor WITH TAXAS->valor+valor
    ENDI
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
SELE CSTSEG                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,071 SAY "ADP_RX88"                            // c¢digo relat¢rio
 @ 2,000 SAY "GERAR TAXA C/ADICIONAL"
 @ 2,026 SAY titrel                                // t¡tulo a definir
 @ 2,063 SAY NSEM(DATE())                          // dia da semana
 @ 2,071 SAY DTOC(DATE())                          // data do sistema
 IMPAC("Emiss„o  Horas Hist Contr. Complemento                   Qtdade     Valor Circ",3,000)
 @ 4,000 SAY REPL("-",79)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_RX88.PRG
