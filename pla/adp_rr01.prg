procedure adp_rr01
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADP_RR01.PRG
 \ Data....: 11-11-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Resumo do per°odo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=16, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+15 SAY " RESUMO DO PERIODO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " De:.....:"
@ l_s+02,c_s+1 SAY " AtÇ:....:"
@ l_s+03,c_s+1 SAY " Grupo...:"
@ l_s+04,c_s+1 SAY " Resumir.:"
@ l_s+05,c_s+1 SAY " Confirme:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // AtÇ:
rgrupo=[  ]
resumir=[S]
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess†rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+02 ,c_s+12 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess†rio informar ATê:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

  @ l_s+03 ,c_s+09 GET  rgrupo;
                   PICT "!!";
                   VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(rgrupo)~GRUPO nÑo existe na tabela")
                   AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                   CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"


 @ l_s+04 ,c_s+12 GET  resumir;
                  PICT "!";
                  VALI CRIT("resumir$ 'SN'~|Digite S ou N")
                  AJUDA "Digite S para resumir |ou|N para detalhar"

 @ l_s+05 ,c_s+12 GET  confirme;
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

 PTAB(tipcont,"CLASSES",1,.t.)                     // abre arquivo p/ o relacionamento
 SET RELA TO tipcont INTO CLASSES                  // relacionamento dos arquivos
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="tipcont"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,75,11)           // nao quis configurar...
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
    IF !USEARQ("CGRUPOS",.f.,10,1)                    // se falhou a abertura do arq
     RETU                                            // volta ao menu anterior
    ENDI
   #else
    USEARQ("CGRUPOS")                                 // abre o dbf e seus indices
   #endi

   #ifdef COM_REDE
    IF !USEARQ("CTAXAS",.f.,10,1)                    // se falhou a abertura do arq
     RETU                                            // volta ao menu anterior
    ENDI
   #else
    USEARQ("CTAXAS")                                 // abre o dbf e seus indices
   #endi

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
DBOX("[ESC] Interrompe| | ",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
//SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  go top
  skip -1
  odometer(reccount(),18,15)

  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot116004:=tot116005:=tot116006 := 0             // inicializa variaves de totais
  DO WHIL !EOF()//.and.odometer()
   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI

   SET DEVI TO PRIN
   REL_CAB(2)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY [Tipo: ]+tipcont+[-]+CLASSES->descricao// titulo da quebra
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   SET DEVI TO SCRE

   qb11601=tipcont                                 // campo para agrupar 1a quebra
   st11601004:=st11601005:=st11601006 := 0         // inicializa sub-totais

   tot117006:={0,0,0,0,0,0}// Contratos com 0,1,2,3,4ou+ debitos
   totv17006:={0,0,0,0,0,0}//
   tot117007:={0,0,0,0,0,0,0,0,0,0,0,0} // Debitos por mes
   totv17007:={0,0,0,0,0,0,0,0,0,0,0,0} // Debitos por mes
    tot117001:={0,0,0}//Recebida com atraso
    tot117002:={0,0,0}//Recebida sem atraso
    tot117003:={0,0,0}//Recebida antecipadamente
    tot117004:={0,0,0}//A receber com atraso
    tot117005:={0,0,0}//A receber sem atraso
    totv17001:={0,0,0}
    totv17002:={0,0,0}
    totv17003:={0,0,0}
    totv17004:={0,0,0}
    totv17005:={0,0,0}// inicializa variaves de totais

/*
     cl+=2                                         // soma contador de linha
     @ cl,000 SAY "...... Recebidas...........  .... A Receber ...."
     cl+=1
     @ cl,000 SAY "      No    Mes                          "
     cl+=1
     @ cl,000 SAY "Atrasad   Em Dia    Antecip   Atrasad    Em dia  "
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "=======   =======   =======   ========   ========"
*/
   DO WHIL !EOF() .AND. tipcont=qb11601.and.odometer()
    #ifdef COM_TUTOR
     IF IN_KEY()=K_ESC                             // se quer cancelar
    #else
     IF INKEY()=K_ESC                              // se quer cancelar
    #endi
     IF canc()                                     // pede confirmacao
      BREAK                                        // confirmou...
     ENDI
    ENDI
    nrtxpend:=0
    vltxpend:=0
    qconat=1                                       // variavel temporaria
    qconcan=1                                       // variavel temporaria
    qvenmes=1                                       // variavel temporaria
    IF resumir=[S]
     IF situacao=[1].AND. admissao<=M->rate
      st11601004+=qconat
      tot116004+=qconat
     ENDI
    ELSE
     IF situacao=[1]
      st11601004+=qconat
      tot116004+=qconat
     ELSE
      st11601005+=qconcan
      tot116005+=qconcan
     ENDI
    ENDI
    IF admissao>=M->rde.AND.admissao<=M->rate      // pode imprimir?
     st11601006+=qvenmes
     tot116006+=qvenmes
    ENDI
    chv117=codigo
    SELE TAXAS
    SEEK chv117
    IF FOUND()
     DO WHIL ! EOF() .AND. chv117=codigo //LEFT(&(INDEXKEY(0)),LEN(chv117))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      IF (pgto_<M->rde.AND.!EMPT(pgto_))
       SKIP
       LOOP
      ENDI
      IF !(tipo$[123])
       SKIP
       LOOP
      ENDI

      tipx:=VAL(TIPO)

      qrmesca=1                                    // variavel temporaria
      vltax:=valor
      // Pendentes
      IF emissao_<M->rde.AND.(valorpg=0) //.OR.pgto_>=M->rde)// pode imprimir?
       nrtxpend++
       vltxpend+=valor
       mes:=min(month(emissao_),12)
       if mes>1
        tot117007[mes]++      // conta os debitos do mes
        totv17007[mes]+=valor // acumula o valor dos debitos do mes
       endi
      ENDI
      // Recebida com atraso
      IF emissao_<M->rde.AND.(pgto_>=M->rde.AND.pgto_<=M->rate)// pode imprimir?
       tot117001[tipx]+=qrmesca
       totv17001[tipx]+=vltax
      ELSE
       qrmesca=0
      ENDI
      qrmessa=1                                    // variavel temporaria
      // Recebida dentro do mes (sem atraso)
      IF emissao_>=M->rde.AND.pgto_>=M->rde.AND.pgto_<=M->rate.and.emissao_<=M->rate// pode imprimir?
       tot117002[tipx]+=qrmessa
       totv17002[tipx]+=vltax
      ELSE
       qrmessa=0
      ENDI
      qrmesan=1                                    // variavel temporaria
      // Recebida antecipadamente
      IF pgto_>=M->rde.AND.pgto_<=M->rate.and.emissao_>M->rate// pode imprimir?
       tot117003[tipx]+=qrmesan
       totv17003[tipx]+=vltax
      ELSE
       qrmesan=0
      ENDI
      qarmesca=1                                   // variavel temporaria
      // A receber no mes com atraso
      IF emissao_<M->rde.AND.(EMPT(pgto_).OR.pgto_>=M->rde)// pode imprimir?
       tot117004[tipx]+=qarmesca
       totv17004[tipx]+=vltax
      ELSE
       qarmesca=0
      ENDI
      qarmessa=1                                   // variavel temporaria
      // A receber dentro do proprio mes
      IF emissao_<=M->rate.AND.emissao_>=M->rde// pode imprimir?
       tot117005[tipx]+=qarmessa
       totv17005[tipx]+=vltax
      ELSE
       qarmessa=0
      ENDI
      SKIP                                         // pega proximo registro
     ENDD
    ELSE
     tot117006[6]++
    ENDI
    nrtxpend:=MIN(nrtxpend,4)+1
    tot117006[nrtxpend]++
    totv17006[nrtxpend]+=vltxpend
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
   ENDD
   SET DEVI TO PRIN                                   // inicia a impressao

   IF cl+3>maxli                                   // se cabecalho do arq filho
    REL_CAB(0)                                     // nao cabe nesta pagina
   ENDI                                            // salta para a proxima pagina

//   @ ++cl,028 SAY REPL('-',22)
   REL_CAB(1)                                      // nao cabe nesta pagina
   @ cl,010 SAY [Contratos: Ativos.........: ]+TRAN(st11601004,"999999")        // sub-tot qtdativ
   IF resumir=[S]
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Vendidos period: ]+TRAN(st11601006,"999999")          // sub-tot qvenmes
    FOR tipx = 1 to 3
     qrecper:=tot117001[tipx]+tot117002[tipx]+tot117003[tipx]
     vrecper:=totv17001[tipx]+totv17002[tipx]+totv17003[tipx]
     IF (qrecper+vrecper+totv17005[tipx]) > 0
      REL_CAB(1)                                      // nao cabe nesta pagina
      IF tipx = 1
       @ cl,010 say [Tipo 1: ADESAO]
      ELSEIF tipx = 2
       @ cl,010 say [Tipo 2: RATEIO]
      ELSEIF tipx = 3
       @ cl,010 say [Tipo 3: PERIODICO]
      ENDI
      REL_CAB(1)                                      // nao cabe nesta pagina
      @ cl,028 SAY [         A receber no per°odo]+TRAN(tot117005[tipx],"99999")+;
                  [ ]+TRAN(totv17005[tipx],"9999999.99")// total qarmessa
      REL_CAB(1)                                      // nao cabe nesta pagina
      @ cl,028 SAY [         Recebidos no per°odo]+TRAN(qrecper,"99999")+;
                  [ ]+TRAN(vrecper,"9999999.99")// total qrmesca
     ENDI
    NEXT tipx
   ELSE
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Cancelados.....: ]+ TRAN(st11601005,"999999")          // sub-tot qtdcanc
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Vendidos period: ]+TRAN(st11601006,"999999")          // sub-tot qvenmes
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Sem debito lancado....:]+TRAN(tot117006[6],"99999")+[ ]+TRAN(totv17006[1],"9999999.99")// total qarmesca
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Sem debitos pendentes.:]+TRAN(tot117006[1],"99999")+[ ]+TRAN(totv17006[1],"9999999.99")// total qarmesca
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Com 01 deb. pendente..:]+TRAN(tot117006[2],"99999")+[ ]+TRAN(totv17006[2],"9999999.99")// total qarmesca
    REL_CAB(1)                                       // nao cabe nesta pagina
    @ cl,010 SAY [           Com 02 deb. pendente..:]+TRAN(tot117006[3],"99999")+[ ]+TRAN(totv17006[3],"9999999.99")// total qarmesca
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Com 03 deb. pendente..:]+TRAN(tot117006[4],"99999")+[ ]+TRAN(totv17006[4],"9999999.99")// total qarmesca
    REL_CAB(1)                                      // nao cabe nesta pagina
    @ cl,010 SAY [           Com 04 ou + pendencias:]+TRAN(tot117006[5],"99999")+[ ]+TRAN(totv17006[5],"9999999.99")// total qarmesca
    FOR tipx = 1 to 12
     REL_CAB(1)                                      // nao cabe nesta pagina
     @ cl,010 SAY [           Pendencias do per°odo ]+str(tipx,2)+[: ]+TRAN(tot117007[tipx],"99999")+[ ]+TRAN(totv17007[tipx],"9999999.99")// total qarmesca
    NEXT tipx
    FOR tipx = 1 to 3
      REL_CAB(1)                                      // nao cabe nesta pagina
     IF tipx = 1
      @ cl,010 say [Tipo 1: ADESAO]
     ELSEIF tipx = 2
      @ cl,010 say [Tipo 2: RATEIO]
     ELSEIF tipx = 3
      @ cl,010 say [Tipo 3: PERIODICO]
     ENDI
     REL_CAB(1)                                      // nao cabe nesta pagina
     @ cl,028 SAY [DÇbitos: A receber com atraso]+TRAN(tot117004[tipx],"99999")+[ ]+TRAN(totv17004[tipx],"9999999.99")// total qarmesca
     REL_CAB(1)                                      // nao cabe nesta pagina
     @ cl,028 SAY [         Recebidos com atraso]+TRAN(tot117001[tipx],"99999")+[ ]+TRAN(totv17001[tipx],"9999999.99")// total qrmesca
     REL_CAB(1)                                      // nao cabe nesta pagina
     @ cl,028 SAY [         A receber no per°odo]+TRAN(tot117005[tipx],"99999")+[ ]+TRAN(totv17005[tipx],"9999999.99")// total qarmessa
     REL_CAB(1)                                      // nao cabe nesta pagina
     @ cl,028 SAY [         Recebidos sem atraso]+TRAN(tot117002[tipx],"99999")+[ ]+TRAN(totv17002[tipx],"9999999.99")// total qrmessa
     REL_CAB(1)                                      // nao cabe nesta pagina
     @ cl,028 SAY [         Recebidos antecipado]+TRAN(tot117003[tipx],"99999")+[ ]+TRAN(totv17003[tipx],"9999999.99")// total qrmesan
    NEXT tipx
   ENDI
   SET DEVI TO SCRE

  ENDD
  SET DEVI TO PRIN                                   // inicia a impressao
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  IF resumir = [S]
   SELE CGRUPOS
   GO TOP
   qtaxcan:=vtaxcan:=qconcan:=0
   DO WHIL !EOF()
    IF canclto_>=M->rde.and.canclto_<=M->rate
     qconcan++
    ENDI
    SKIP
   ENDD

   SELE CTAXAS

   GO TOP
   DO WHIL !EOF()
    IF pgto_>=M->rde .AND. pgto_<=M->rate
     qtaxcan++
     vtaxcan+=valorpg
    ENDI
    SKIP
   ENDD
   REL_CAB(3)
   @ cl,000 SAY REPL("-",78)
   REL_CAB(1)
   @ cl,000 SAY " PERIODO ("+dtoc(M->rde)+[ - ]+dtoc(M->rate)
   REL_CAB(1)
   @ cl,010 SAY [ Contratos cancelados no per°odo: ]+TRAN(qconcan,"999999")          // sub-tot qvenmes
   REL_CAB(1)
   @ cl,010 SAY [ Recebimentos cancelados .......: ]+TRAN(qtaxcan,"99999")+;
                [ ]+TRAN(vtaxcan,"9999999.99")// total qrmesca
   REL_CAB(1)
   @ cl,000 SAY REPL("-",78)
  ENDI
  SET DEVI TO SCRE

 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(75)                                          // grava variacao do relatorio
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
 @ 1,070 SAY "ADP_RR01"                            // c¢digo relat¢rio
 @ 2,000 SAY "RESUMO DO PERIODO ("+dtoc(M->rde)+[ - ]+dtoc(M->rate)
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,068 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t°tulo a definir
 IMPAC("                           Ativos  Cancel. Vendids",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_RR01.PRG
