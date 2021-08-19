procedure adm_r016
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R016.PRG
 \ Data....: 21-10-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Resumo p/Circular
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1
cod_sos=1
msgt="CONTAGEM P/CIRCULAR"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->grupo+circ INTO CIRCULAR
 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE TAXAS                                        // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)

 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  odometer()
  IF tipo=[2]                                      // se atender a condicao...
   IF !CIRCULAR->(EOF())
    #ifdef COM_REDE

    SELE CIRCULAR
    RLOCK()
    IF !EMPT(CIRCULAR->lancto_)
     REPL CIRCULAR->emitidos WITH 0, CIRCULAR->pagos WITH 0
    ENDI
    REPL CIRCULAR->lancto_ WITH CTOD([  /  /  ]),;
         CIRCULAR->emitidos WITH CIRCULAR->emitidos + 1
//  @ 10,10 say TAXAS->codigo+TAXAS->tipo+TAXAS->circ
    IF !EMPT(TAXAS->valorpg)
     REPL CIRCULAR->pagos WITH CIRCULAR->pagos + 1
    ENDI
    DBUNLOCK()
    SELE TAXAS
    #else
    IF !EMPT(CIRCULAR->lancto_)
     REPL CIRCULAR->emitidos WITH 0
    ENDI
    IF !EMPT(CIRCULAR->lancto_)
     REPL CIRCULAR->pagos WITH 0
    ENDI
    REPL CIRCULAR->lancto_ WITH CTOD([  /  /  ])
    IF EMPT(CIRCULAR->lancto_)
     REPL CIRCULAR->emitidos WITH CIRCULAR->emitidos + 1
    ENDI
    IF !EMPT(TAXAS->valorpg)
     REPL CIRCULAR->pagos WITH CIRCULAR->pagos + 1
    ENDI
    #endi
   ENDI

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SELE TAXAS                                        // salta pagina
 SET RELA TO                                       // retira os relacionamentos

 #ifdef COM_REDE
  IF !USEARQ("CIRCULAR",.t.,10,1)                  // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CIRCULAR")                               // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE CIRCULAR                                     // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()

  IF EMPT(lancto_)
   #ifdef COM_REDE
    REPBLO('CIRCULAR->lancto_',{||DATE()})
   #else
    REPL CIRCULAR->lancto_ WITH DATE()
   #endi
  ENDI
  SKIP                                             // pega proximo registro
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e

#ifdef COM_REDE
 IF !USEARQ("CIRCULAR",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CIRCULAR")                                // abre o dbf e seus indices
#endi

titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,18,11)            // nao quis configurar...
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
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY grupo                              // Grupo
   @ cl,003 SAY TRAN(circ,"999")                   // Circular
   @ cl,009 SAY TRAN(procpend,"99")                // Procpend
   @ cl,012 SAY TRAN(emissao_,"@D")                // Emiss„o
   @ cl,024 SAY TRAN(mesref,"@R 99/99")            // Mˆs Ref.
   @ cl,030 SAY TRAN(valor,"@E 999,999.99")        // Valor
   @ cl,044 SAY TRAN(emitidos,"@E 9,999")          // Emitidos
   @ cl,055 SAY TRAN(pagos,"@E 9,999")             // Pagos
//   @ cl,055 SAY TRAN(cancelados                  // Cancelados
//   @ cl,059 SAY TRAN(lancto_,"@D")               // Lancamento
//   @ cl,068 SAY funcionar                        // Usu rio
   SKIP                                            // pega proximo registro
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(18)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,068 SAY "PAG"
 @ 0,072 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,068 SAY "ADM_R016"                            // c¢digo relat¢rio
 @ 2,000 SAY "RESUMO P/CIRCULAR"
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,068 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Gr Circ Proc Emiss„o  Mˆs      Valor  Emitid Pagos  Canc",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R016.PRG
