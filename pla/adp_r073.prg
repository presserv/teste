procedure adp_r073
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R073.PRG
 \ Data....: 21-02-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Titular & Dependentes
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,53,11)            // nao quis configurar...
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
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
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
   @ cl,000 SAY TRAN(codigo,"999999")              // Codigo
   @ cl,007 SAY TRAN(nome,"@!")                    // Nome
   @ cl,043 SAY TRAN(nascto_,"@D")                 // Nascto
   chv088=codigo
   SELE INSCRITS
   SEEK chv088
   IF FOUND()
    DO WHIL ! EOF() .AND. chv088=LEFT(&(INDEXKEY(0)),LEN(chv088))
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
     @ cl,002 SAY grau+'-'+STR(seq,2)              // Inscr.
     @ cl,007 SAY nome                             // Nome
     @ cl,043 SAY TRAN(nascto_,"@D")               // Nascto
     @ cl,052 SAY TRAN(falecto_,"@D")              // Falecto.
     @ cl,061 SAY TRAN(tipo,"!!!")                 // Tipo
     @ cl,066 SAY TRAN(procnr,"@R 99999/99")       // N§Processo
     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE GRUPOS                                     // volta ao arquivo pai
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
GRELA(53)                                          // grava variacao do relatorio
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
 @ 1,070 SAY "ADP_R073"                            // c¢digo relat¢rio
 @ 2,000 SAY "TITULAR & DEPENDENTES"
 @ 2,026 SAY titrel                                // t¡tulo a definir
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Codigo Nome                                Nascto    Falecto. tip Processo"
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R073.PRG
