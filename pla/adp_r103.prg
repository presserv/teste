procedure adp_r103
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADP_R103.PRG
 \ Data....: 26-02-99
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Vendas p/Bairro
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=17, l_i:=15, c_i:=66, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+21 SAY " RANKING "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY " Per°odo..: De:            AtÇ:"
@ l_s+03,c_s+1 SAY " Confirme:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // AtÇ:
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+17 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess†rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+02 ,c_s+33 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess†rio informar ATê:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

 @ l_s+03 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME nÑo aceit†vel|Digite S ou Tecle ESC")
                  AJUDA "Digite S para confirmar |ou|Tecle ESC para cancelar"

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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

// PTAB(vendedor,"COBRADOR",1,.t.)                   // abre arquivo p/ o relacionamento
// SET RELA TO vendedor INTO COBRADOR                // relacionamento dos arquivos
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="bairro+vendedor"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,22,11)           // nao quis configurar...
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
maxli=63                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot036003 := 0                                   // inicializa variaves de totais
  qqu036=0                                         // contador de registros
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
   IF admissao>=M->rde.AND.admissao<=M->rate       // se atender a condicao...
/*
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY [Bairro ]+bairro                  // titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
*/
    RELEASE ALL LIKE omt036*                       // imprime campos omitidos
    qb03601=bairro                                 // campo para agrupar 1a quebra
    st03601003 := 0                                // inicializa sub-totais
    qqu03601=0                                     // contador de registros
    DO WHIL !EOF() .AND. bairro=qb03601
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF admissao>=M->rde.AND.admissao<=M->rate     // se atender a condicao...
/*
      REL_CAB(2)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY [Vendedor ]+vendedor            // titulo da quebra
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      RELEASE ALL LIKE omt036*                     // imprime campos omitidos
*/
      qb03602=vendedor                             // campo para agrupar 1a quebra
      st03602003 := 0                              // inicializa sub-totais
      qqu03602=0                                   // contador de registros
      DO WHIL !EOF() .AND. bairro=qb03601 .AND. vendedor=qb03602
       #ifdef COM_TUTOR
        IF IN_KEY()=K_ESC                          // se quer cancelar
       #else
        IF INKEY()=K_ESC                           // se quer cancelar
       #endi
        IF canc()                                  // pede confirmacao
         BREAK                                     // confirmou...
        ENDI
       ENDI
       IF admissao>=M->rde.AND.admissao<=M->rate   // se atender a condicao...
/*
        REL_CAB(1)                                 // soma cl/imprime cabecalho
        @ cl,000 SAY "Bairro               Vendedor                            qtdade"
        REL_CAB(1)                                 // soma cl/imprime cabecalho
        @ cl,000 SAY REPL("-",78)
        REL_CAB(1)                                 // soma cl/imprime cabecalho
*/
        IF TYPE("omt036001")!="C" .OR. omt036001!=bairro// imp se dif do anterior
         REL_CAB(1)                                 // soma cl/imprime cabecalho
         @ cl,000 SAY TRAN(bairro,"@!")            // Bairro
         omt036001=bairro                          // imp se dif do anterior
        ENDI
//        @ cl,021 SAY vendedor+[-]+COBRADOR->nome   // Vendedor
        st03601003+=1
        st03602003+=1
        tot036003+=1
//        @ cl,058 SAY 1                             // qtdade
        qqu03601++                                 // soma contadores de registros
        qqu03602++                                 // soma contadores de registros
        qqu036++                                   // soma contadores de registros
        SKIP                                       // pega proximo registro
       ELSE                                        // se nao atende condicao
        SKIP                                       // pega proximo registro
       ENDI
      ENDD
/*
      IF cl+3>maxli                                // se cabecalho do arq filho
       REL_CAB(0)                                  // nao cabe nesta pagina
      ENDI                                         // salta para a proxima pagina
      @ ++cl,058 SAY REPL('-',5)
*/
      PTAB(qb03602,"COBRADOR",1,.t.)                   // abre arquivo p/ o relacionamento
      @ cl,021 SAY qb03602+[-]+COBRADOR->nome   // Vendedor
      @ cl,058 SAY st03602003                    // sub-tot qtdade
      @ cl,068 SAY st03601003                      // sub-tot qtdade
      REL_CAB(1)                                   // soma cl/imprime cabecalho

//      @ cl,000 SAY "* Quantidade "+TRAN(qqu03602,"@E 999,999")
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    REL_CAB(1)                                   // soma cl/imprime cabecalho
/*
    IF cl+3>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    @ ++cl,058 SAY REPL('-',5)
    @ ++cl,058 SAY st03601003                      // sub-tot qtdade
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "* Quantidade "+TRAN(qqu03601,"@E 999,999")
*/
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,058 SAY REPL('-',5)
  @ ++cl,058 SAY tot036003                         // total qtdade
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu036,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(22)                                          // grava variacao do relatorio
SELE GRUPOS                                        // salta pagina
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
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p†gina
 IMPAC(nsis,1,000)                                 // t°tulo aplicaáÑo
 @ 1,028 SAY titrel                                // t°tulo a definir
 @ 1,070 SAY "ADP_R103"                            // c¢digo relat¢rio
 @ 2,000 SAY "VENDAS P/BAIRRO   De:"
 @ 2,022 SAY TRAN(M->rde,"@D")                     // De:
 @ 2,034 SAY "ate:"
 @ 2,039 SAY TRAN(M->rate,"@D")                    // AtÇ:
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,068 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Bairro               Vendedor                                 Qtdade  Total"
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R103.PRG
