procedure adp_r095
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R095.PRG
 \ Data....: 01-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Apagar Boletos p/ FCC
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("BXBOLET",.t.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BXBOLET")                                 // abre o dbf e seus indices
#endi

PTAB(nnumero,"BOLETOS",2,.t.)                      // abre arquivo p/ o relacionamento
PTAB(BOLETOS->codigo+BOLETOS->tipo+BOLETOS->circ,"BXTXAS",2,.t.)
SET RELA TO nnumero INTO BOLETOS,;                 // relacionamento dos arquivos
         TO BOLETOS->codigo+BOLETOS->tipo+BOLETOS->circ INTO BXTXAS
titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,48,11)            // nao quis configurar...
 CLOS ALL                                          // fecha arquivos e
 RETU                                              // volta ao menu
ENDI
IF tps=2                                           // se vai para arquivo/video
 arq_=ARQGER()                                     // entao pega nome do arquivo
 IF EMPTY(arq_)                                    // se cancelou ou nao informou
  RETU                                             // retorna
 ENDI
ELSE
 arq_=drvporta                                     // porta de saida configurada
ENDI
IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF

SET PRINTER TO (arq_)                              // redireciona saida
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot072003:=tot072004:=tot072005 := 0             // inicializa variaves de totais
  qqu072=0                                         // contador de registros
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
   IF BXTXAS->valorpg>0                            // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(seq,"99999")                 // Seq
    @ cl,006 SAY TRAN(nnumero,"9999999999")        // N.N£mero
    tot072003+=valor
    @ cl,017 SAY TRAN(valor,"@E 999,999.99")       // Valor
    tot072004+=vldesp
    @ cl,029 SAY TRAN(vldesp,"@E 999,999.99")      // Vl.Despesas
    tot072005+=BXTXAS->valorpg
    @ cl,043 SAY TRAN(BXTXAS->valorpg,"@E 999,999.99")// Valor baixado
    @ cl,055 SAY TRAN(BXTXAS->idfilial,"!!")       // Id
    @ cl,057 SAY "-"
    @ cl,058 SAY TRAN(BXTXAS->numero,"999999")     // n.fcc
    qqu072++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,017 SAY REPL('-',36)
  @ ++cl,017 SAY TRAN(tot072003,"@E 999,999.99")   // total Valor
  @ cl,029 SAY TRAN(tot072004,"@E 999,999.99")     // total Vl.Despesas
  @ cl,043 SAY TRAN(tot072005,"@E 999,999.99")     // total Valor baixado
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu072,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(48)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|APAGAR BOLETOS P/ FCC"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE BXBOLET                                      // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF BXTXAS->valorpg>0                             // se atender a condicao...

   #ifdef COM_REDE
    BLOREG(0,.5)
   #endi

   DELE                                            // exclui registro processado

   #ifdef COM_REDE
    UNLOCK                                         // libera o registro
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SET(_SET_DELETED,.f.)                             // os excluidos serao vistos
 SELE BXBOLET                                      // arquivo origem do processamento

 #ifdef COM_REDE
  IF BLOARQ(10,.5)
   PACK                                            // elimina os registros excluidos
   UNLOCK                                          // libera o registro
  ENDI
 #else
  PACK                                             // elimina os registros excluidos
 #endi

 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE BXBOLET                                       // salta pagina
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
 @ 1,070 SAY "ADP_R095"                            // c¢digo relat¢rio
 IMPAC("BOLETOS ELIMINADOS (JA LAN€ADOS NA FCC)",2,000)
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Seq   N.N£mero        Valor Vl.Despesas Valor baixado  Nr.FCC",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R095.PRG
