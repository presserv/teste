procedure adm_r037
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADM_R037.PRG
 \ Data....: 22-10-99
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Baixas por Per¡odo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, lindet:=[]
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=26, l_i:=15, c_i:=56, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+3 SAY " TAXAS PAGAS NO PER¡ODO "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY "   Data Inicial:"
@ l_s+03,c_s+1 SAY "   Data Final..:"
@ l_s+04,c_s+1 SAY "   Tipo........:"
@ l_s+05,c_s+1 SAY "   Anal¡tico...:"
@ l_s+06,c_s+1 SAY "   Qual a base?:"
inicio_=CTOD('')                                   // Data Inicial
final_=CTOD('')                                    // Data Final
rtipo=SPAC(1)                                      // Tipo
ranalit=SPAC(1)                                    // Anal¡tico ?
rplano=[P]                                   // Anal¡tico ?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+18 GET  inicio_;
                  PICT "@D";
                  VALI CRIT("!EMPT(inicio_)~Necess rio informar DATA INICIAL")
                  DEFAULT "DATE() - DAY(DATE())"
                  AJUDA "Listar as taxas pagas na recep‡„o|a partir de que data."

 @ l_s+03 ,c_s+18 GET  final_;
                  PICT "@D";
                  VALI CRIT("!EMPT(final_)~Necess rio informar DATA FINAL")
                  DEFAULT "(inicio_+31)-DAY(inicio_+31)"
                  AJUDA "Listar as taxas pagas na recep‡„o|at‚ que data."

 @ l_s+04 ,c_s+18 GET  rtipo;
                  PICT "9";
                  VALI CRIT("!EMPT(rtipo)~TIPO n„o aceit vel|Digite um n£mero v lido|ou|zero para todos os tipos")
                  AJUDA "Qual o tipo de lan‡amento"
                  CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"

 @ l_s+05 ,c_s+18 GET  ranalit;
                  PICT "!";
                  VALI CRIT("ranalit $ [SN]~ANAL¡TICO ? n„o aceit vel|Digite S para detalhado |ou|N para totais")
                  AJUDA "Digite S para listar com detalhes|ou|N para somente totais"
                  CMDF8 "MTAB([Sim, detalhado|N„o, apenas totais],[ANAL¡TICO ?])"

 @ l_s+06 ,c_s+18 GET  rplano;
                  PICT "!";
                  VALI CRIT("rplano $ [PR]~Qual a Base? |Digite P para Plano |ou|R para Recepcao")
                  AJUDA "Digite P para ter o Plano como base|ou|R para a recepcao"
                  CMDF8 "MTAB([Plano, arquivo TAXAS|Recepc„o, arquivo BXREC],[Qual a Base?])"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI

 IF rplano=[P]
  #ifdef COM_REDE
   IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
    RETU                                            // volta ao menu anterior
   ENDI
  #else
   USEARQ("TAXAS")                                  // abre o dbf e seus indices
  #endi

  PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
  // SET RELA TO codigo INTO GRUPOS                    // relacionamento dos arquivos
  titrel:=criterio := ""                            // inicializa variaveis
  cpord="tipo+codigo"
  criterio:=[pgto_>=M->inicio_.AND.pgto_<=M->final_.AND.(M->rtipo='0'.OR.tipo=M->rtipo)]// se atender a condicao...
 ELSE
  #ifdef COM_REDE
   IF !USEARQ("BXREC",.f.,10,1)                     // se falhou a abertura do arq
    RETU                                            // volta ao menu anterior
   ENDI
  #else
   USEARQ("BXREC")                                  // abre o dbf e seus indices
  #endi

  PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
  // SET RELA TO codigo INTO GRUPOS                    // relacionamento dos arquivos
  titrel:=criterio := ""                            // inicializa variaveis
  cpord="tipo+codigo"
  criterio:=[emitido_>=M->inicio_.AND.emitido_<=M->final_.AND.(M->rtipo='0'.OR.tipo=M->rtipo)]// se atender a condicao...
 ENDI

 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,62,11)           // nao quis configurar...
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
  tot103004 := 0                                   // inicializa variaves de totais
  qqu103=0                                         // contador de registros
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
   IF .t. //pgto_>=M->inicio_.AND.pgto_<=M->final_.AND.(M->rtipo=[0].OR.tipo=M->rtipo)// se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY [Tipo: ]+tipo                     // titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb10301=tipo                                   // campo para agrupar 1a quebra
    st10301004 := 0                                // inicializa sub-totais
    qqu10301=0                                     // contador de registros
    DO WHIL !EOF() .AND. tipo=qb10301
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF .t. //pgto_>=M->inicio_.AND.pgto_<=M->final_.AND.(M->rtipo=[0].OR.tipo=M->rtipo)// se atender a condicao...
      st10301004+=valorpg
      tot103004+=valorpg
      IF M->ranalit=[S]
       dtbx=IIF(rplano=[P],pgto_,emitido_)
       lindet+=TRAN(codigo,"999999")+;           // Codigo
              [ ]+TRAN(circ,"999")+;                // Circ
              [ ]+LEFT(DTOC(dtbx),6)+RIGHT(DTOC(dtbx),2)+; // Dt.Pgto.
              [ ]+TRAN(valorpg,"@E 9,999.99")+[ | ]     // Vlr.Pago
       IF LEN(lindet) > 90    // 4 colunas de 30 bytes
        REL_CAB(1)                                   // soma cl/imprime cabecalho
        IMPCTL(drvpcom)
        @ cl,000 SAY lindet
        IMPCTL(drvtcom)
        lindet:=[]
       ENDIF
      ENDI
      qqu10301++                                   // soma contadores de registros
      qqu103++                                     // soma contadores de registros
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    IF !EMPT(lindet)    // restou algo a imprimir ?
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     IMPCTL(drvpcom)
     @ cl,000 SAY lindet
     IMPCTL(drvtcom)
     lindet:=[]
    ENDIF
    IF cl+3>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    IF M->ranalit=[S]
     @ ++cl,030 SAY REPL('-',19)
     @ ++cl,030 SAY [Valor: ]+TRAN(st10301004,"@E 999,999.99")  // sub-tot Vlr.Pago
     REL_CAB(1)                                     // soma cl/imprime cabecalho
     @ cl,000 SAY "* Quantidade "+TRAN(qqu10301,"@E 999,999")
    ELSE
     @ cl,000 SAY "* Quantidade "+TRAN(qqu10301,"@E 999,999")
     @ cl,030 SAY [Valor: ]+TRAN(st10301004,"@E 9,999,999.99")  // sub-tot Vlr.Pago
     REL_CAB(1)                                     // soma cl/imprime cabecalho
     @ ++cl,030 SAY REPL('-',19)
    ENDI
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  IF M->ranalit=[S]
   @ ++cl,030 SAY REPL('-',19)
   @ ++cl,030 SAY [Total: ]+TRAN(tot103004,"@E 9,999,999.99")     // total Vlr.Pago
   REL_CAB(2)                                       // soma cl/imprime cabecalho
   @ cl,000 SAY "*** Quantidade total "+TRAN(qqu103,"@E 999,999")
  ELSE
   @ ++cl,030 SAY REPL('-',19)
   REL_CAB(1)                                       // soma cl/imprime cabecalho
   @ cl,000 SAY "*** Quantidade total "+TRAN(qqu103,"@E 999,999")
   @ cl,030 SAY [Total: ]+TRAN(tot103004,"@E 9,999,999.99")     // total Vlr.Pago
   REL_CAB(1)                                       // soma cl/imprime cabecalho
   @ cl,030 SAY REPL('-',19)
  ENDI
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(62)                                          // grava variacao do relatorio
IF rplano=[P]
 SELE TAXAS                                         // salta pagina
 SET RELA TO                                        // retira os relacionamentos
ELSE
 SELE BXREC
 SET RELA TO
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
 @ 1,029 SAY titrel                                // t¡tulo a definir
 @ 1,070 SAY "ADM_R037"                            // c¢digo relat¢rio
 IMPAC("BAIXAS POR PER¡ODO  De:",2,000)
 @ 2,024 SAY TRAN(M->inicio_,"@D")                 // Data Inicial
 IMPAC("at‚",2,035)
 @ 2,039 SAY TRAN(M->final_,"@D")                  // Data Final
 IF M->rtipo#[0]
  @ 2,051 SAY "Tipo"
  @ 2,056 SAY TRAN(M->rtipo,"9")                    // Tipo
 ENDI
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Codigo Circ DtPgto. Vlr.Pago"
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADM_R037.PRG
