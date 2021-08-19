procedure adp_rx98
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_RX98.PRG
 \ Data....: 22-12-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Cancelamentos/Vendedor
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
@ l_s,c_s+16 SAY " VENDEDOR POR REA "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Per¡odo..: De:            At‚:"
@ l_s+02,c_s+1 SAY " Regi„o...:"
@ l_s+03,c_s+1 SAY " Vendedor.:"
@ l_s+04,c_s+1 SAY " Anal¡tico:"
@ l_s+05,c_s+1 SAY " Confirme:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // At‚:
rregiao=SPAC(3)                                    // Regi„o
rvend=SPAC(3)                                      // Vendedor
ranalit=SPAC(1)                                    // Anal¡tico?
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+17 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+01 ,c_s+33 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess rio informar AT:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

 @ l_s+02 ,c_s+13 GET  rregiao;
                  PICT "999";
                  VALI CRIT("PTAB(rregiao,'REGIAO',1).OR.EMPT(VAL(rregiao))~REGIŽO n„o existe na tabela")
                  AJUDA "Informe a regi„o ou tecle F8 para busca em tabela"
                  CMDF8 "VDBF(6,38,20,77,'REGIAO',{'codigo','regiao'},1,'codigo')"
                  MOSTRA {"LEFT(TRAN(REGIAO->regiao,[]),30)", 2 , 17 }

 @ l_s+03 ,c_s+13 GET  rvend;
                  PICT "999";
                  VALI CRIT("PTAB(rvend,'COBRADOR',1).OR.rvend=[000]~VENDEDOR n„o existe na tabela")
                  AJUDA "Informe o c¢digo do Vendedor|ou|Tecle F8 para consulta em arquivo"
                  CMDF8 "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador')"
                  MOSTRA {"LEFT(TRAN(COBRADOR->nome,[]),30)", 3 , 17 }

 @ l_s+04 ,c_s+13 GET  ranalit;
                  PICT "!";
                  VALI CRIT("ranalit $ [SN]~ANAL¡TICO? n„o aceit vel")
                  DEFAULT "[N]"
                  AJUDA "Digite S para listar os detalhes|ou|N para somente totais"
                  CMDF8 "MTAB([Sim, liste os detalhes|N„o, apenas totalize],[ANAL¡TICO?])"

 @ l_s+05 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n„o aceit vel|Digite S ou Tecle ESC")
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
  IF !USEARQ("COBRADOR",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("COBRADOR")                                // abre o dbf e seus indices
 #endi


 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,24,11)           // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

 #ifdef COM_REDE
  IF !USEARQ("CGRUPOS",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CGRUPOS")                                // abre o dbf e seus indices
 #endi

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="vendedor"
 INDTMP()

#ifdef COM_REDE
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

cpord="vendedor"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE COBRADOR
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot038008:=tot038009:=tot038010 := 0             // inicializa variaves de totais
  qqu038:=qqux38:=0                                         // contador de registros
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
   IF !(M->rvend$'000,'+cobrador)
    SKIP
    LOOP
   ENDI
   IF M->ranalit=[S]
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY [Vendedor: ]+cobrador+[-]+COBRADOR->nome// titulo da quebra
   ENDI
   qb03801=cobrador                               // campo para agrupar 1a quebra

//   PTAB(qb03801,"GRUPOS",1,.t.)                   // abre arquivo p/ o relacionamento
   SELE GRUPOS
   SEEK qb03801
   qqux3801=0                                     // contador de registros
   IF !EOF() //(M->rvend$'000,'+vendedor)// se atender a condicao...
    DO WHIL !EOF() .AND. vendedor=qb03801
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF !(situacao=[1])
      SKIP
      LOOP
     ENDI
     IF admissao>=M->rde.AND.admissao<=M->rate.AND.(M->rregiao$'000,'+regiao).AND.(M->rvend$'000,'+vendedor)// se atender a condicao...
			IF M->ranalit=[S]

       REL_CAB(1)                                   // soma cl/imprime cabecalho
       @ cl,000 SAY TRAN(codigo,"999999")           // Codigo
       @ cl,007 SAY nome+[ ]+dtoc(admissao)                            // Nome
      ENDI
      qqux3801++                                   // soma contadores de registros
      qqux38++                                     // soma contadores de registros
      chv039=codigo

      SELE GRUPOS                                 // volta ao arquivo pai
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
   ENDI
//   PTAB(qb03801,"CGRUPOS",1,.t.)                   // abre arquivo p/ o relacionamento
   SELE CGRUPOS
   SEEK qb03801
   qqu03801=0                                     // contador de registros
   IF !EOF() //canclto_>=M->rde.AND.canclto_<=M->rate.AND.(M->rregiao$'000,'+regiao).AND.(M->rvend$'000,'+vendedor)// se atender a condicao...
    DO WHIL !EOF() .AND. vendedor=qb03801
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF !EMPT(reintem_)
      SKIP
      LOOP
     ENDI

     IF canclto_>=M->rde.AND.canclto_<=M->rate.AND.(M->rregiao$'000,'+regiao).AND.(M->rvend$'000,'+vendedor)// se atender a condicao...
			IF M->ranalit=[S]

       REL_CAB(1)                                   // soma cl/imprime cabecalho
       @ cl,000 SAY TRAN(codigo,"999999")           // Codigo
       @ cl,007 SAY nome+[ ]+dtoc(admissao)+[ ]+dtoc(canclto_)                            // Nome
      ENDI
      qqu03801++                                   // soma contadores de registros
      qqu038++                                     // soma contadores de registros
      chv039=numero

      SELE CGRUPOS                                 // volta ao arquivo pai
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
		IF M->ranalit=[S]
     @ ++cl,045 SAY REPL('-',32)
     cl++
     @ cl,060 SAY TRAN(qqux3801,"@E 999,999")
     @ cl,070 SAY TRAN(qqu03801,"@E 999,999")
    ELSE
     IF (qqux3801+qqu03801) > 0
      REL_CAB(1)                                     // soma cl/imprime cabecalho
      @ cl,000 SAY [Vendedor: ]+COBRADOR->cobrador+[-]+COBRADOR->nome// titulo da quebra
      @ cl,060 SAY TRAN(qqux3801,"@E 999,999")
      @ cl,070 SAY TRAN(qqu03801,"@E 999,999")
     ENDI
    ENDI

   SELE COBRADOR
   skip
  ENDD
  REL_CAB(1)                                      // nao cabe nesta pagina
  @ 5,000 SAY REPL("-",79)
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl++,000 SAY "*** Quantidade total Vendas       "+TRAN(qqux38,"@E 999,999")
  @ cl++,000 SAY "*** Quantidade total Cancelamentos"+TRAN(qqu038,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(24)                                          // grava variacao do relatorio
SELE CGRUPOS                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,063 SAY "PAG"
 @ 0,067 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,063 SAY "ADP_RX98"                            // c¢digo relat¢rio
 @ 2,000 SAY "VENDAS/CANCELAMENTOS (De: "+dtoc(M->rde)+[ ate: ]+dtoc(M->rate)
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,068 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Codigo Nome                                                   Qt.Vend. QT.Canc.",4,000)
 @ 5,000 SAY REPL("-",79)
 IMPCTL(drvtcom)                                   // retira comprimido
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_RX98.PRG
