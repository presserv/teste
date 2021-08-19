procedure adm_r003
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R003.PRG
 \ Data....: 14-12-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Cancelamentos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "admbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 3                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " CANCELAMENTOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " N£mero:"
@ l_s+02,c_s+1 SAY " Grupo.:     Contrato:"
@ l_s+04,c_s+1 SAY " Motivo:"
cnumero=SPAC(6)                                    // N£mero
cgrupo=SPAC(2)                                     // Grupo
ccodigo=SPAC(5)                                    // Codigo
cmotivo=SPAC(1)                                    // Motivo
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+10 GET  cnumero;
                  PICT "999999";
                  VALI CRIT("!EMPT(cnumero)~Necess rio informar N£MERO")
                  DEFAULT "STRZERO(M->nrcanc+1,6)"

 @ l_s+02 ,c_s+10 GET  cgrupo;
                  PICT "!9";
                  VALI CRIT("PTAB(cgrupo,'ARQGRUP',1)~GRUPO n„o existe na tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,51,20,77,'ARQGRUP',{'grup','classe','inicio','final'},1,'grup',[])"

 @ l_s+02 ,c_s+24 GET  ccodigo;
                  PICT "99999";
                  VALI CRIT("PTAB(cgrupo+ccodigo,'GRUPOS',1)~CODIGO n„o aceit vel")
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo',[situacao!=[2]])"
                  MOSTRA {"LEFT(TRAN(GRUPOS->nome,[]),35)", 3 , 5 }

 @ l_s+04 ,c_s+10 GET  cmotivo;
                  PICT "!";
                  VALI CRIT("cmotivo$[FMID]~Necess rio informar MOTIVO");
                  WHEN "MTAB([Falta pgto|Mudou|Ignorado|Desistˆncia],[MOTIVO])"
                  AJUDA "Entre com a justificativa"
                  CMDF8 "MTAB([Falta pgto|Mudou|Ignorado|Desistˆncia],[MOTIVO])"

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
  CLOSE GRUPOS
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(grupo,"ARQGRUP",1,.t.)                       // abre arquivo p/ o relacionamento
 SET RELA TO grupo INTO ARQGRUP                    // relacionamento dos arquivos
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,3,11)            // nao quis configurar...
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
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
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

cpord="grupo+codigo"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)          // abre arquivo p/ o relacionamento
PTAB(cobrador+CIRCULAR->mesref+GRUPOS->grupo+circ,"FCCOB",1,.t.)
SET RELA TO GRUPOS->grupo+circ INTO CIRCULAR,;     // relacionamento dos arquivos
         TO cobrador+CIRCULAR->mesref+GRUPOS->grupo+circ INTO FCCOB
cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=63                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF()
   IF INKEY()=K_ESC                                // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF GRUPOS->codigo==M->ccodigo                   // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "N§"
    IMPCTL(drvpenf)
    @ cl,002 SAY TRAN(M->cnumero,"999999")         // N£mero
    IMPCTL(drvtenf)
    @ cl,009 SAY "Grupo:"
    @ cl,016 SAY TRAN(M->cgrupo,"!9")              // Grupo
    IMPAC("C¢digo:",cl,020)
    @ cl,028 SAY TRAN(M->ccodigo,"99999")          // Codigo
    IMPCTL(drvpenf)
    @ cl,035 SAY TRAN(M->cmotivo,"@!")             // Motivo
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Admiss„o......:",cl,000)
    @ cl,018 SAY TRAN(admissao,"@D")               // Admiss„o
    @ cl,028 SAY "Saitxa.:"
    @ cl,037 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
    @ cl,044 SAY "Cobrador.:"
    @ cl,056 SAY cobrador                          // Cobrador
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Funerais......:"
    @ cl,018 SAY TRAN(funerais,"99")               // Funerais
    @ cl,023 SAY "Vlcarne:"
    @ cl,032 SAY vlcarne                           // Vlcarne
    @ cl,037 SAY "Circ.Inicial.:"
    @ cl,052 SAY TRAN(circinic,"999")              // Circ.Inicial
    @ cl,057 SAY "Final.:"
    @ cl,065 SAY TRAN(ultcirc,"999")               // Ult.Circular
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Regi„o........:",cl,000)
    @ cl,018 SAY TRAN(regiao,"999")                // Regi„o
    @ cl,023 SAY "Circ.Emitidas:"
    @ cl,038 SAY TRAN(qtcircs,"999")               // Qt.Circulares
    @ cl,042 SAY "Pagas:"
    @ cl,049 SAY TRAN(qtcircpg,"999")              // Circ.Pagas
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Titular.......:"
    @ cl,018 SAY titular                           // Titular
    @ cl,023 SAY "Nome...:"
    @ cl,032 SAY nome                              // Nome
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o......:",cl,000)
    @ cl,018 SAY endereco                          // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Bairro........:"
    @ cl,018 SAY bairro                            // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cidade........:"
    @ cl,018 SAY TRAN(cep,"@R 99999-999")          // CEP
    @ cl,029 SAY cidade                            // Cidade
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Part.Vivos....:"
    @ cl,018 SAY TRAN(particv,"99")                // Part.Vivos
    @ cl,021 SAY "Part.Falecidos:"
    @ cl,039 SAY TRAN(particf,"99")                // Part.Falecidos
    chv012=grupo+codigo
    SELE INSCRITS
    SEEK chv012
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "INSCRITOS"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY REPL("-",78)
     DO WHIL ! EOF() .AND. chv012=grupo+codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
      IF INKEY()=K_ESC                             // se quer cancelar
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Inscr.:"
      @ cl,008 SAY TRAN(grau,"9")                  // Inscr.
      @ cl,011 SAY "Seq.:"
      @ cl,018 SAY TRAN(seq,"99")                  // Seq
      @ cl,022 SAY "Titular?.:"
      @ cl,033 SAY TRAN(ehtitular,"!")             // Titular?
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Nome..:"
      @ cl,007 SAY nome                            // Nome
      @ cl,043 SAY "SEXO:"
      @ cl,048 SAY TRAN(sexo,"!")                  // SEXO
      @ cl,051 SAY "Est Civil:"
      @ cl,061 SAY estcivil                        // Est Civil
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      IMPAC("Endere‡o:",cl,000)
      @ cl,009 SAY ruares                          // Rua de Residˆncia
      @ cl,045 SAY "Bairro:"
      @ cl,052 SAY baires                          // Baires
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Municipio:"
      @ cl,010 SAY munres                          // Municipio
      @ cl,036 SAY "UF:"
      @ cl,039 SAY TRAN(ufres,"!!")                // UF
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Naturalde:"
      @ cl,010 SAY natural                         // Natural de
      IMPAC("Nasc.Cart¢rio:",cl,036)
      @ cl,050 SAY nascartor                       // Nasc.Cart¢rio
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Data Nascto:"
      @ cl,012 SAY TRAN(nascto_,"@D")              // Nascto
      IMPAC("Profiss„o:",cl,022)
      @ cl,032 SAY profiss                         // Profiss„o
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Cor:"
      @ cl,004 SAY cor                             // Cor
      IMPAC("Grau Instru‡ao:",cl,015)
      @ cl,030 SAY TRAN(grauinstr,"!")             // Grau Instru‡ao
      @ cl,032 SAY "RG:"
      @ cl,035 SAY rg                              // RG
      @ cl,051 SAY "CPF:"
      @ cl,055 SAY TRAN(ncpf,"@R 999.999.999-99")  // CPF
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Eleitor em:"
      @ cl,011 SAY eraeleitor                      // Eraeleitor
      @ cl,037 SAY "Zona:"
      @ cl,042 SAY zona                            // Zona
      @ cl,048 SAY "Titulo:"
      @ cl,055 SAY nrtitulo                        // N§titulo
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Reservista:"
      @ cl,011 SAY TRAN(reservista,"!")            // Reservista
      @ cl,013 SAY "Categoria:"
      @ cl,023 SAY rescat                          // Categoria
      IMPAC("N£mero:",cl,026)
      @ cl,033 SAY resnum                          // N£mero
      IMPAC("S‚rie:",cl,044)
      @ cl,050 SAY resserie                        // S‚rie
      @ cl,054 SAY "CSM.:"
      @ cl,059 SAY rescsm                          // CSM
      @ cl,063 SAY "RM.:"
      @ cl,067 SAY resrm                           // RM
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Cad.em:"
      @ cl,007 SAY TRAN(lancto_,"@D")              // Lan‡to.
      @ cl,016 SAY "V/F.:"
      @ cl,021 SAY TRAN(vivofalec,"!")             // V/F
      @ cl,023 SAY "Falecto.:"
      @ cl,032 SAY TRAN(falecto_,"@D")             // Falecto.
      @ cl,041 SAY "Tipo:"
      @ cl,046 SAY TRAN(tipo,"!!!")                // Tipo
      @ cl,050 SAY "N§Processo:"
      @ cl,061 SAY TRAN(procnr,"99999/99")         // N§Processo
      SKIP                                         // pega proximo registro
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    chv012=codigo
    SELE TAXAS
    SEEK chv012
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "Circular Emissao       Valor Pagamento Valor pago Cobrador Forma"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "======== ======== ========== ========= ========== ======== ====="
     DO WHIL ! EOF() .AND. chv012=codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
      IF INKEY()=K_ESC                             // se quer cancelar
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(circ,"999")                // Circular
      @ cl,009 SAY TRAN(emissao_,"@D")             // Emissao
      @ cl,018 SAY TRAN(valor,"@E 999,999.99")     // Valor
      @ cl,029 SAY TRAN(pgto_,"@D")                // Pagamento
      @ cl,039 SAY TRAN(valorpg,"@E 999,999.99")   // Valor pago
      @ cl,050 SAY cobrador                        // Cobrador
      @ cl,059 SAY forma                           // Forma
      SKIP                                         // pega proximo registro
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET MARG TO                                        // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)                // mostra o arquivo gravado
ENDI
GRELA(3)                                           // grava variacao do relatorio

#ifdef COM_REDE
 IF !USEARQ("CGRUPOS",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CGRUPOS")                                 // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("CINSCRIT",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CINSCRIT")                                // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("CTAXAS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CTAXAS")                                  // abre o dbf e seus indices
#endi

msgt="PROCESSAMENTOS DO RELAT¢RIO|CANCELAMENTOS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE GRUPOS                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF GRUPOS->codigo==M->ccodigo                    // se atender a condicao...
   SELE CGRUPOS                                    // arquivo alvo do lancamento

   #ifdef COM_REDE
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    APPE BLAN                                      // cria registro em branco
   #endi

   SELE GRUPOS                                     // inicializa registro em branco
   REPL CGRUPOS->numero WITH M->cnumero,;
        CGRUPOS->grupo WITH M->cgrupo,;
        CGRUPOS->codigo WITH M->ccodigo,;
        CGRUPOS->situacao WITH [2],;
        CGRUPOS->motivo WITH M->cmotivo,;
        CGRUPOS->canclto_ WITH DATE(),;
        CGRUPOS->cancpor WITH M->usuario,;
        CGRUPOS->admissao WITH admissao,;
        CGRUPOS->saitxa WITH saitxa,;
        CGRUPOS->cobrador WITH cobrador,;
        CGRUPOS->funerais WITH funerais,;
        CGRUPOS->vlcarne WITH vlcarne,;
        CGRUPOS->circinic WITH circinic,;
        CGRUPOS->ultcirc WITH ultcirc,;
        CGRUPOS->regiao WITH regiao,;
        CGRUPOS->qtcircs WITH qtcircs,;
        CGRUPOS->qtcircpg WITH qtcircpg,;
        CGRUPOS->titular WITH titular,;
        CGRUPOS->nome WITH nome,;
        CGRUPOS->endereco WITH endereco,;
        CGRUPOS->bairro WITH bairro,;
        CGRUPOS->cidade WITH cidade,;
        CGRUPOS->cep WITH cep,;
        CGRUPOS->particv WITH particv,;
        CGRUPOS->particf WITH particf

   #ifdef COM_REDE
    CGRUPOS->(DBUNLOCK())                          // libera o registro
   #endi

    PARAMETROS('nrcanc',M->nrcanc+1)

   #ifdef COM_REDE
    REPBLO('ARQGRUP->contrat',ARQGRUP->contrat - 1)
    REPBLO('GRUPOS->situacao',[2])
    REPBLO('GRUPOS->admissao',CTOD([  /  /  ]))
    REPBLO('GRUPOS->cobrador',[ ])
    REPBLO('GRUPOS->titular',[ ])
    REPBLO('GRUPOS->nome',[ ])
    REPBLO('GRUPOS->endereco',[ ])
    REPBLO('GRUPOS->bairro',[ ])
    REPBLO('GRUPOS->cidade',[ ])
    REPBLO('GRUPOS->cep',[ ])
    REPBLO('GRUPOS->funerais',0)
    REPBLO('GRUPOS->qtcircs',0)
    REPBLO('GRUPOS->particv',0)
    REPBLO('GRUPOS->particf',0)
   #else
    PARAMETROS('nrcanc',M->nrcanc+1)
    REPL ARQGRUP->contrat WITH ARQGRUP->contrat - 1
    REPL GRUPOS->situacao WITH [2]
    REPL GRUPOS->admissao WITH CTOD([  /  /  ])
    REPL GRUPOS->cobrador WITH [ ]
    REPL GRUPOS->titular WITH [ ]
    REPL GRUPOS->nome WITH [ ]
    REPL GRUPOS->endereco WITH [ ]
    REPL GRUPOS->bairro WITH [ ]
    REPL GRUPOS->cidade WITH [ ]
    REPL GRUPOS->cep WITH [ ]
    REPL GRUPOS->funerais WITH 0
    REPL GRUPOS->qtcircs WITH 0
    REPL GRUPOS->particv WITH 0
    REPL GRUPOS->particf WITH 0
   #endi

   chv012=grupo+codigo
   SELE INSCRITS
   SEEK chv012
   IF FOUND()
    DO WHIL ! EOF() .AND. chv012=grupo+codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
     SELE CINSCRIT                                 // arquivo alvo do lancamento

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

     SELE INSCRITS                                 // inicializa registro em branco
     REPL CINSCRIT->numero WITH M->cnumero,;
          CINSCRIT->grupo WITH M->cgrupo,;
          CINSCRIT->codigo WITH M->Ccodigo,;
          CINSCRIT->grau WITH grau,;
          CINSCRIT->seq WITH seq,;
          CINSCRIT->ehtitular WITH ehtitular,;
          CINSCRIT->nome WITH nome,;
          CINSCRIT->sexo WITH sexo,;
          CINSCRIT->estcivil WITH estcivil,;
          CINSCRIT->ruares WITH ruares,;
          CINSCRIT->baires WITH baires,;
          CINSCRIT->munres WITH munres,;
          CINSCRIT->ufres WITH ufres,;
          CINSCRIT->natural WITH natural,;
          CINSCRIT->nascartor WITH nascartor,;
          CINSCRIT->nascto_ WITH nascto_,;
          CINSCRIT->profiss WITH profiss,;
          CINSCRIT->cor WITH cor,;
          CINSCRIT->grauinstr WITH grauinstr,;
          CINSCRIT->eraeleitor WITH eraeleitor,;
          CINSCRIT->zona WITH zona,;
          CINSCRIT->nrtitulo WITH nrtitulo,;
          CINSCRIT->rg WITH rg,;
          CINSCRIT->ncpf WITH ncpf,;
          CINSCRIT->reservista WITH reservista,;
          CINSCRIT->rescat WITH rescat,;
          CINSCRIT->resnum WITH resnum,;
          CINSCRIT->resserie WITH resserie,;
          CINSCRIT->rescsm WITH rescsm,;
          CINSCRIT->resrm WITH resrm,;
          CINSCRIT->lancto_ WITH lancto_,;
          CINSCRIT->vivofalec WITH vivofalec,;
          CINSCRIT->falecto_ WITH falecto_,;
          CINSCRIT->tipo WITH tipo,;
          CINSCRIT->procnr WITH procnr

     #ifdef COM_REDE
      CINSCRIT->(DBUNLOCK())                       // libera o registro
     #endi


     #ifdef COM_REDE
      IF vivofalec=[V]
       REPBLO('ARQGRUP->partic',ARQGRUP->partic - 1)
      ENDI
     #else
      IF vivofalec=[V]
       REPL ARQGRUP->partic WITH ARQGRUP->partic - 1
      ENDI
     #endi

     DELE                                          // exclui registro processado
     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE GRUPOS                                     // volta ao arquivo pai
   chv012=codigo
   SELE TAXAS
   SEEK chv012
   IF FOUND()
    DO WHIL ! EOF() .AND. chv012=codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
     SELE CTAXAS                                   // arquivo alvo do lancamento

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

     SELE TAXAS                                    // inicializa registro em branco
     REPL CTAXAS->numero WITH M->cnumero,;
          CTAXAS->grupo WITH M->cgrupo,;
          CTAXAS->codigo WITH M->ccodigo,;
          CTAXAS->circ WITH circ,;
          CTAXAS->emissao_ WITH emissao_,;
          CTAXAS->valor WITH valor,;
          CTAXAS->pgto_ WITH IIF(EMPT(pgto_),DATE(),pgto_),;
          CTAXAS->valorpg WITH valorpg,;
          CTAXAS->cobrador WITH cobrador,;
          CTAXAS->forma WITH IIF(EMPT(forma),[C],forma),;
          CTAXAS->baixa_ WITH baixa_,;
          CTAXAS->por WITH por

     #ifdef COM_REDE
      CTAXAS->(DBUNLOCK())                         // libera o registro
     #endi


     #ifdef COM_REDE
      IF EMPT(pgto_)
       REPBLO('FCCOB->qtdret',FCCOB->qtdret + 1)
      ENDI
      IF EMPT(pgto_)
       REPBLO('CIRCULAR->cancelados',CIRCULAR->cancelados + 1)
      ENDI
     #else
      IF EMPT(pgto_)
       REPL FCCOB->qtdret WITH FCCOB->qtdret + 1
      ENDI
      IF EMPT(pgto_)
       REPL CIRCULAR->cancelados WITH CIRCULAR->cancelados + 1
      ENDI
     #endi

     DELE                                          // exclui registro processado
     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE GRUPOS                                     // volta ao arquivo pai
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SET(_SET_DELETED,.f.)                             // os excluidos serao vistos
 SELE INSCRITS                                     // arquivo origem do processamento
* PACK                                              // elimina os registros excluidos
 SELE TAXAS                                        // arquivo origem do processamento
* PACK                                              // elimina os registros excluidos
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
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
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,070 SAY "ADM_R003"                            // c¢digo relat¢rio
 @ 2,000 SAY titrel                                // t¡tulo a definir
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 IMPCTL(drvpenf)
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 IMPCTL(drvtenf)
 @ 3,000 SAY "CANCELAMENTOS"
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADM_R003.PRG
