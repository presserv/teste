procedure adm_r010
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R010.PRG
 \ Data....: 24-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Resumo Taxas Emitidas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
IF nivelop < 3                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
nucop=1

#ifdef COM_REDE
 IF !USEARQ("ARQGRUP",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("ARQGRUP")                                 // abre o dbf e seus indices
#endi

PTAB(grup+proxcirc,"CIRCULAR",1,.t.)               // abre arquivo p/ o relacionamento
PTAB(classe,"CLASSES",1,.t.)
SET RELA TO grup+proxcirc INTO CIRCULAR,;          // relacionamento dos arquivos
         TO classe INTO CLASSES
titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,22,11)            // nao quis configurar...
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
 IF !USEARQ("CPRCIRC",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

PTAB(processo+categ,"PRCESSOS",1,.t.)              // abre arquivo p/ o relacionamento
SET RELA TO processo+categ INTO PRCESSOS           // relacionamento dos arquivos
cpord="grupo+DTOS(dfal)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE ARQGRUP
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
   IF proxcirc>[000].AND.!(CLASSES->prior=[S])     // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(grup,"!!")                   // Grupo
    @ cl,004 SAY TRAN(classe,"99")                 // Classe
    @ cl,007 SAY inicio                            // Nr.Inicial
    @ cl,015 SAY final                             // Nr.Final
    @ cl,022 SAY TRAN(acumproc,"99")               // N§.Processos
    @ cl,029 SAY TRAN(periodic,"999")              // Periodicidade
    @ cl,037 SAY TRAN(qtdremir,"99")               // Remido
    @ cl,040 SAY TRAN(ultcirc,"999")               // Ultcirc
    @ cl,048 SAY TRAN(emissao_,"@D")               // Emissao
    @ cl,058 SAY TRAN(procpend,"999")              // Processos
    @ cl,062 SAY TRAN(contrat,"999999")            // Contratos
    @ cl,069 SAY TRAN(partic,"99999")              // Partic.
    @ cl,076 SAY TRAN(proxcirc,"999")              // Circ.Emtd.
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,003 SAY TRAN(CIRCULAR->emissao_,"@D")     // Emiss„o
    @ cl,012 SAY TRAN(CIRCULAR->mesref,"@R 99/99") // Mˆs Ref.
    @ cl,018 SAY TRAN(CIRCULAR->valor,"@E 999,999.99")// Valor
    @ cl,029 SAY TRAN(CIRCULAR->menscirc,"@!")     // Mensagem
    chv040=grup
    SELE CPRCIRC
    SEEK chv040
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "Processo  Circ Gr Contr  Falecido                            Data"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "========= ==== == =====  ============================================"
     DO WHIL ! EOF() .AND. chv040=grupo //LEFT(&(INDEXKEY(0)),LEN(chv040))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      IF ARQGRUP->proxcirc=circ                    // se atender a condicao...
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY processo                       // Processo
       @ cl,010 SAY circ                           // Circular
       @ cl,015 SAY TRAN(grupo,"!!")               // Grupo
       @ cl,018 SAY num                            // Contrato
       @ cl,025 SAY TRAN(fal,"@!")                 // Fal
       @ cl,061 SAY TRAN(dfal,"@D")                // Data
       SKIP                                        // pega proximo registro
      ELSE                                         // se nao atende condicao
       SKIP                                        // pega proximo registro
      ENDI
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE ARQGRUP                                   // volta ao arquivo pai
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
GRELA(22)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|RESUMO TAXAS EMITIDAS"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE ARQGRUP                                      // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF proxcirc>[000].AND.!(CLASSES->prior=[S])      // se atender a condicao...

   chv040=grup
   SELE CPRCIRC
   SEEK chv040
   IF FOUND()
    DO WHIL ! EOF() .AND. chv040=grupo //LEFT(&(INDEXKEY(0)),LEN(chv040))
     IF ARQGRUP->proxcirc=circ                     // se atender a condicao...
      PTAB(processo+categ,"PRCESSOS",1,.t.)              // abre arquivo p/ o relacionamento
      #ifdef COM_REDE
       REPBLO('PRCESSOS->saiu',{||circ})
       REPBLO('ARQGRUP->procpend',{||ARQGRUP->procpend-1})
      #else
       REPL PRCESSOS->saiu WITH circ
       REPL ARQGRUP->procpend WITH ARQGRUP->procpend-1
      #endi

      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
   ENDI
   SELE ARQGRUP                                    // volta ao arquivo pai
   #ifdef COM_REDE
    REPBLO('ARQGRUP->ultcirc',{||proxcirc})
    REPBLO('ARQGRUP->emissao_',{||CIRCULAR->emissao_})
    REPBLO('ARQGRUP->proxcirc',{||[000]})
   #else
    REPL ARQGRUP->ultcirc WITH proxcirc
    REPL ARQGRUP->emissao_ WITH CIRCULAR->emissao_
    REPL ARQGRUP->proxcirc WITH [000]
   #endi
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE CPRCIRC                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
SELE ARQGRUP                                       // salta pagina
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
 @ 1,071 SAY "ADM_R010"                            // c¢digo relat¢rio
 @ 2,000 SAY "RESUMO TAXAS EMITIDAS"
 @ 2,063 SAY NSEM(DATE())                          // dia da semana
 @ 2,071 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Grp Cl Inicial Final Procs Periodic Rem Ultcirc Emissao  Procs Cont Partic Emtd"
 @ 5,000 SAY REPL("-",79)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R010.PRG
