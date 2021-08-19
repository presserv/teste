procedure adp_r096
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R096.PRG
 \ Data....: 01-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerar FCC dos Boletos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("LBXBOLET",.t.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("LBXBOLET")                                // abre o dbf e seus indices
#endi

titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,47,11)            // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("BXBOLET",.t.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BXBOLET")                                 // abre o dbf e seus indices
#endi

PTAB(nnumero,"BOLETOS",2,.t.)                      // abre arquivo p/ o relacionamento
PTAB(M->p_filial+LBXBOLET->nfcc,"BXFCC",1,.t.)
SET RELA TO nnumero INTO BOLETOS,;                 // relacionamento dos arquivos
         TO M->p_filial+LBXBOLET->nfcc INTO BXFCC
cpord="nrlote"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE LBXBOLET
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
   IF EMPT(nfcc)                                   // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(nrlote,"999999")             // Nr Lote
    @ cl,008 SAY TRAN(emissao_,"@D")               // Emiss„o
    @ cl,025 SAY TRAN(totdesp,"@E 999,999.99")     // Total das Despesas
    @ cl,044 SAY TRAN(totcred,"@E 999,999.99")     // Total dos Cr‚ditos
    @ cl,062 SAY TRAN(totliq,"@E 999,999.99")      // Liquido creditado
    chv072=nrlote
    SELE BXBOLET
    SEEK chv072
    IF FOUND()
     IF cl+4>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=2                                         // soma contador de linha
     IMPAC("Seq   N.N£mero        Valor Vl.Despesas",cl,000)
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "===== ========== ========== ==========="
     DO WHIL ! EOF() .AND. chv072=LEFT(&(INDEXKEY(0)),LEN(chv072))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(seq,"99999")               // Seq
      @ cl,006 SAY TRAN(nnumero,"9999999999")      // N.N£mero
      @ cl,017 SAY TRAN(valor,"@E 999,999.99")     // Valor
      @ cl,029 SAY TRAN(vldesp,"@E 999,999.99")    // Vl.Despesas
      SKIP                                         // pega proximo registro
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE LBXBOLET                                  // volta ao arquivo pai
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(47)                                          // grava variacao do relatorio

#ifdef COM_REDE
 IF !USEARQ("BXFCC",.t.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BXFCC")                                   // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT

#ifdef COM_REDE
 IF !USEARQ("BXTXAS",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BXTXAS")                                  // abre o dbf e seus indices
#endi

msgt="PROCESSAMENTOS DO RELAT¢RIO|GERAR FCC DOS BOLETOS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE LBXBOLET                                     // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF EMPT(nfcc)                                    // se atender a condicao...
   SELE BXFCC                                      // arquivo alvo do lancamento

   #ifdef COM_REDE
    BXF_CRIA_SEQ()
    SELE BXFCC
    BXF_GERA_SEQ()
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    BXF_GERA_SEQ()
    APPE BLAN                                      // cria registro em branco
   #endi

   BXF_GRAVA_SEQ()
   SELE LBXBOLET                                   // inicializa registro em branco
   REPL BXFCC->idfilial WITH M->p_filial,;
        BXFCC->lancto_ WITH DATE(),;
        BXFCC->por WITH M->usuario,;
        BXFCC->nomecobr WITH [Baixa p/Boleto Bancario],;
        BXFCC->despesas WITH totdesp,;
        BXFCC->baixa_ WITH emissao_

   #ifdef COM_REDE
    BXFCC->(DBUNLOCK())                            // libera o registro
   #endi


   #ifdef COM_REDE
    REPBLO('LBXBOLET->nfcc',{||BXFCC->numero})
   #else
    REPL LBXBOLET->nfcc WITH BXFCC->numero
   #endi

   chv072=nrlote
   SELE BXBOLET
   SEEK chv072
   IF FOUND()
    DO WHIL ! EOF() .AND. chv072=LEFT(&(INDEXKEY(0)),LEN(chv072))
     SELE BXTXAS                                   // arquivo alvo do lancamento

     #ifdef COM_REDE
      DO WHIL .t.
       APPE BLAN                                   // tenta abri-lo
       IF NETERR()                                 // nao conseguiu
        DBOX(ms_uso,20)                            // avisa e
        LOOP                                       // tenta novamente
       ENDI
       EXIT                                        // ok. registro criado
      ENDD
     #else
      APPE BLAN                                    // cria registro em branco
     #endi

     SELE BXBOLET                                  // inicializa registro em branco
     REPL BXTXAS->idfilial WITH M->p_filial,;
          BXTXAS->numero WITH LBXBOLET->nfcc,;
          BXTXAS->seq WITH seq,;
          BXTXAS->codigo WITH BOLETOS->codigo,;
          BXTXAS->tipo WITH BOLETOS->tipo,;
          BXTXAS->circ WITH BOLETOS->circ,;
          BXTXAS->valorpg WITH valor

     #ifdef COM_REDE
      BXTXAS->(DBUNLOCK())                         // libera o registro
     #endi


     #ifdef COM_REDE
      REPBLO('BXFCC->parcpag',{||BXFCC->parcpag +1})
      REPBLO('BXFCC->vltaxas',{||BXFCC->vltaxas +valor})
     #else
      REPL BXFCC->parcpag WITH BXFCC->parcpag +1
      REPL BXFCC->vltaxas WITH BXFCC->vltaxas +valor
     #endi

     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE LBXBOLET                                   // volta ao arquivo pai
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
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
 @ 1,070 SAY "ADP_R096"                            // c¢digo relat¢rio
 @ 2,000 SAY "GERAR FCC DOS BOLETOS"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Nr Lote Emiss„o  Total das Despesas Total dos Cr‚ditos Liquido creditado",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R096.PRG
