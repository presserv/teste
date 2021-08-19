procedure adc_r063
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADC_R063.PRG
 \ Data....: 28-07-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Emiss„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("TX2VIA",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TX2VIA")                                  // abre o dbf e seus indices
#endi

PTAB(codigo,"GRUPOS",1,.t.)                        // abre arquivo p/ o relacionamento
PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
PTAB(GRUPOS->regiao,"REGIAO",1,.t.)
PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
PTAB(codigo+tipo+circ,"TAXAS",1,.t.)
SET RELA TO codigo INTO GRUPOS,;                   // relacionamento dos arquivos
         TO GRUPOS->grupo INTO ARQGRUP,;
         TO GRUPOS->regiao INTO REGIAO,;
         TO GRUPOS->grupo+circ INTO CIRCULAR,;
         TO codigo+tipo+circ INTO TAXAS
titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,50,11)            // nao quis configurar...
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
SET PRINTER TO (arq_)                              // redireciona saida
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("CPRCIRC",.t.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

cpord="grupo+circ+DTOS(dfal)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE TX2VIA
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_048=LEFT(drvtapg,op_-1)+"051"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_048:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=19                                           // maximo de linhas no relatorio
IMPCTL(lpp_048)                                    // seta pagina com 48 linhas
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  ult_imp=0                                        // ultimo reg impresso
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
   REL_CAB(1,.t.)                                  // soma cl/imprime cabecalho
   @ cl,000 SAY "."
   ult_imp=RECNO()                                 // ultimo reg impresso
   chv086=GRUPOS->grupo+TAXAS->circ
   SELE CPRCIRC
   SEEK chv086
   IF FOUND()
    DO WHIL ! EOF() .AND. chv086=LEFT(&(INDEXKEY(0)),LEN(chv086))
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     IMPCTL(drvpc20)                               // comprime os dados
     @ cl,030 SAY num                              // Contrato
     @ cl,041 SAY processo                         // Processo
     @ cl,054 SAY fal                              // Falecido
     @ cl,091 SAY TRAN(ALLTRIM(ends)+'-'+ALLTRIM(cids),"@!")// Ends
     @ cl,149 SAY TRAN(dfal,"@D")                  // Data
     IMPCTL(drvtc20)                               // retira comprimido
     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE TX2VIA                                     // volta ao arquivo pai
   SKIP                                            // pega proximo registro
   cl=999                                          // forca salto de pagina
  ENDD
  REL_RDP(.t.)                                     // imprime rodape' do relatorio
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(50)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|EMISSŽO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TX2VIA                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()

  #ifdef COM_REDE
   BLOREG(0,.5)
  #endi

  DELE                                             // exclui registro processado

  #ifdef COM_REDE
   UNLOCK                                          // libera o registro
  #endi

  SKIP                                             // pega proximo registro
 ENDD
 SET(_SET_DELETED,.f.)                             // os excluidos serao vistos
 SELE TX2VIA                                       // arquivo origem do processamento

 #ifdef COM_REDE
  IF BLOARQ(10,.5)
   PACK                                            // elimina os registros excluidos
   UNLOCK                                          // libera o registro
  ENDI
 #else
  PACK                                             // elimina os registros excluidos
 #endi

 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE TX2VIA                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_RDP(volta_reg)                     // rodape'
LOCAL ar_:=ALIAS(), reg_atual
SELE TX2VIA                                        // volta ao arquivo pai
reg_atual=RECNO()
IF volta_reg
 GO ult_imp                                        // ajusta reg p/ imp de campos no rodape'
ENDI
@ 21,008 SAY CHR(18)+[2¦ Via ]+IIF(TAXAS->valorpg>0,[-Taxa Paga],[ ])// Mensagem
@ 25,017 SAY TRAN(TAXAS->valor,"@E 999,999.99")    // Valor
@ 25,065 SAY TRAN(TAXAS->valor,"@E 999,999.99")    // Valor 2
IMPCTL(drvpenf)
@ 28,020 SAY [2¦ Via]                              // N§ Recibo
IMPCTL(drvtenf)
IMPCTL(drvpenf)
@ 28,068 SAY [2¦ Via]                              // N§ Recibo 2
IMPCTL(drvtenf)
@ 31,002 SAY TAXAS->circ+[     ]+DTOC(TAXAS->emissao_)+[     ]+STR(GRUPOS->funerais,2)// Circular 1
@ 31,038 SAY TAXAS->circ+[     ]+DTOC(TAXAS->emissao_)+[     ]+STR(GRUPOS->funerais,2)// Circular 2
@ 34,002 SAY GRUPOS->grupo +[        ]+codigo+[       ]+GRUPOS->cobrador// Grupo 1
@ 34,038 SAY GRUPOS->grupo +[        ]+codigo+[       ]+GRUPOS->cobrador// Grupo 2
@ 36,000 SAY GRUPOS->nome                          // Nome
@ 36,036 SAY GRUPOS->nome                          // Nome 2
@ 37,000 SAY GRUPOS->endereco                      // Endere‡o
@ 37,036 SAY GRUPOS->endereco                      // Endere‡o 2
@ 38,000 SAY GRUPOS->bairro                        // Bairro
@ 38,036 SAY GRUPOS->bairro                        // Bairro 2
@ 39,000 SAY GRUPOS->cidade+[ ] +GRUPOS->cep       // Cidade
@ 39,036 SAY GRUPOS->cidade+[ ] +GRUPOS->cep       // Cidade 2
@ 40,000 SAY [Inic:]+DTOC(GRUPOS->admissao)+[ Ult:]+GRUPOS->ultcirc+[ QtTx:]+STR(GRUPOS->qtcircs,3)// Inicio
@ 40,036 SAY [Inic:]+DTOC(GRUPOS->admissao)+[ Ult:]+GRUPOS->ultcirc+[ QtTx:]+STR(GRUPOS->qtcircs,3)// Inicio 2
@ 42,000 SAY ""
IF M->combarra=[S]
 CODBARRAS({{codigo+tipo+circ,4,13,18}},10,6)
ENDI
@ 43,002 SAY [ ]                                   // data 1
@ 43,039 SAY [ ]                                   // data 2
IF M->combarra=[S]
 CODBARRAS({{codigo+tipo+circ,4,13,18}},10,6)
ENDI
IF volta_reg
 GO reg_atual                                      // retorna reg a posicao original
ENDI
SELE (ar_)
RETU 

STATIC PROC REL_CAB(qt, volta_reg)                 // cabecalho do relatorio
LOCAL ar_:=ALIAS()
volta_reg=IF(volta_reg=NIL,.f.,volta_reg)
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP(volta_reg)                               // imprime rodape' do relatorio
 ENDI
 SELE TX2VIA                                       // volta ao arquivo pai
 @ 1,007 SAY GRUPOS->nome                          // Nome
 @ 1,058 SAY TRAN(codigo,"99999")                  // Codigo
 @ 1,076 SAY TRAN(GRUPOS->grupo,"!9")              // Grupo
 @ 3,032 SAY TRAN(TAXAS->valor,"@E 999,999.99")    // Valor
 SELE (ar_)
 cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de ADC_R063.PRG
