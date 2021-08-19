procedure adc_r067
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADC_R067.PRG
 \ Data....: 19-03-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Acerto c/Vendedor
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+12 SAY " ACERTO C/VENDEDOR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " A partir de::"
@ l_s+02,c_s+1 SAY " At‚.........:"
@ l_s+03,c_s+1 SAY " Confirme....:"
inicio_=CTOD('')                                   // A partir de:
final_=CTOD('')                                    // At‚
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+16 GET  inicio_;
                  PICT "@D"
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+02 ,c_s+16 GET  final_;
                  PICT "@D";
                  VALI CRIT("EMPT(final_).OR.final_>inicio_~Necess rio informar AT que data")
                  DEFAULT "DATE()"
                  AJUDA "Informe at‚ que data"

 @ l_s+03 ,c_s+16 GET  confirme;
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
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->vendedor+tipo+circ,"PCBRAD",1,.t.)
 PTAB(GRUPOS->vendedor,"COBRADOR",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->vendedor+tipo+circ INTO PCBRAD,;
          TO GRUPOS->vendedor INTO COBRADOR
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="GRUPOS->vendedor"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,54,11)           // nao quis configurar...
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
  tot086006 := 0                                   // inicializa variaves de totais
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
   IF pgto_>=M->inicio_.AND.pgto_<=M->final_.AND.valorpg>0.AND.PTAB(GRUPOS->vendedor+tipo+circ,[PCBRAD],1)// se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY [Vendedor: (]+GRUPOS->vendedor+[) ]+COBRADOR->nome// titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb08601=GRUPOS->vendedor                       // campo para agrupar 1a quebra
    st08601006 := 0                                // inicializa sub-totais
    DO WHIL !EOF() .AND. GRUPOS->vendedor=qb08601
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF pgto_>=M->inicio_.AND.pgto_<=M->final_.AND.valorpg>0.AND.PTAB(GRUPOS->vendedor+tipo+circ,[PCBRAD],1)// se atender a condicao...
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(GRUPOS->codigo,"999999")   // Contrato
      @ cl,009 SAY tipo+[-]+circ                   // Circ
      @ cl,015 SAY TRAN(emissao_,"@D")             // Emissao
      @ cl,024 SAY TRAN(valor,"@E 999,999.99")     // Valor
      @ cl,035 SAY TRAN(pgto_,"@D")                // Pagamento
      st08601006+=valorpg
      tot086006+=valorpg
      @ cl,045 SAY TRAN(valorpg,"@E 999,999.99")   // Valor pago
			@ cl,056 SAY TRAN(cobrador,"!!!")             // Cobrador
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    IF cl+3>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    @ ++cl,045 SAY REPL('-',10)
    @ ++cl,045 SAY TRAN(st08601006,"@E 999,999.99")// sub-tot Valor pago
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,045 SAY REPL('-',10)
  @ ++cl,045 SAY TRAN(tot086006,"@E 999,999.99")   // total Valor pago
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(54)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
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
 @ 1,070 SAY "ADC_R067"                            // c¢digo relat¢rio
 @ 2,000 SAY "ACERTO C/VENDEDOR"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Contrato Circ  Emissao       Valor Pagamento Valor pago Cobrador"
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADC_R067.PRG
