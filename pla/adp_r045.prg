procedure adp_r045
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R045.PRG
 \ Data....: 24-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Processar Baixas (1)
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, lin_det:=[]
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("BXTXAS",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BXTXAS")                                  // abre o dbf e seus indices
#endi

PTAB(idfilial+numero,"BXFCC",1,.t.)
SET RELA TO idfilial+numero INTO BXFCC
titrel:=criterio := ""                             // inicializa variaveis
cpord="codigo+tipo+circ"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,28,11)            // nao quis configurar...
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
IMPCTL(drvpc20)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot049003 := 0                                   // inicializa variaves de totais
  qqu049=0                                         // contador de registros
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
   IF procok<[3] 			// se atender a condicao...
    lin_det+=TRAN(codigo,"999999")+[ ]+;             // Codigo
	     tipo+[-]+circ+[ ]+;                     // Circ
	     TRAN(valorpg,"@E 999,999.99")+[ |]     // Vl.Pago
    IF LEN(lin_det) > 120
     REL_CAB(1)                                     // soma cl/imprime cabecalho
     @ cl,000 SAY lin_det
     lin_det:=[]
    ENDI
    tot049003+=valorpg
    qqu049++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_CAB(1)                                     // soma cl/imprime cabecalho
  @ cl,000 SAY lin_det
  lin_det:=[]

  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,013 SAY REPL('-',10)
  @ ++cl,013 SAY TRAN(tot049003,"@E 999,999.99")   // total Vl.Pago
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu049,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtc20)                                    // retira comprimido
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(28)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|PROCESSAR BAIXAS (1)"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE BXTXAS                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF procok<[3]                                    // se atender a condicao...
   IF !PTAB(codigo+tipo+circ,"TAXAS",1)
    PTAB(codigo+SUBSTR([678  123],VAL(tipo),1)+circ,"TAXAS",1)
   ENDI
   IF !TAXAS->(EOF())
    SELE TAXAS
   #ifdef COM_REDE
    BLOREG(0,.5)
   #endi

    REPL TAXAS->valorpg WITH BXTXAS->valorpg,;
	 TAXAS->forma WITH [P],;
	 TAXAS->por WITH [FCC]+BXTXAS->IDFILIAL+BXTXAS->numero,;
	 TAXAS->pgto_ WITH BXFCC->baixa_,;
	 TAXAS->cobrador WITH BXFCC->cobrador,;
	 TAXAS->stat WITH [9],;
	 BXTXAS->procok WITH [3]



//   #ifdef COM_REDE
//    BLOREG(0,.5)
//   #endi

//   DELE                                            // exclui registro processado

    #ifdef COM_REDE
     UNLOCK                                         // libera o registro
    #endi
   ENDI
   SELE BXTXAS
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SET(_SET_DELETED,.f.)                             // os excluidos serao vistos
 SELE BXTXAS                                       // arquivo origem do processamento

/*
 #ifdef COM_REDE
  IF BLOARQ(10,.5)
//   PACK                                            // elimina os registros excluidos
   UNLOCK                                          // libera o registro
  ENDI
 #else
//  PACK                                             // elimina os registros excluidos
 #endi
*/

 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE BXTXAS                                        // salta pagina
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
 @ 1,070 SAY "ADP_R045"                            // c¢digo relat¢rio
 @ 2,000 SAY "PROCESSAMENTO DE BAIXAS (1) - Taxas"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Codigo Circ     Vl.Pago"
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R045.PRG
