procedure adm_r006
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R006.PRG
 \ Data....: 17-04-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Reintegra‡„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=15, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 2                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+15 SAY " REINTEGRA€ŽO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Reintegra‡„o n£mero:"
@ l_s+02,c_s+1 SAY " Reintegrar o cancelamento n£mero"
@ l_s+04,c_s+1 SAY " Reativar em.:  Grupo:     C¢digo:"
@ l_s+05,c_s+1 SAY " Motivo.:"
rnumero=SPAC(6)                                    // N£mero
rcnumero=SPAC(6)                                   // Canc.N§
rgrupo=SPAC(2)                                     // Grupo
rcodigo=SPAC(6)                                    // Codigo
rmotivo=SPAC(30)                                   // Motivo
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+23 GET  rnumero;
                  PICT "999999";
                  VALI CRIT("!EMPT(rnumero)~Necess rio informar N£MERO")
                  DEFAULT "STRZERO(M->nrreint+1,6)"

 @ l_s+02 ,c_s+35 GET  rcnumero;
                  PICT "999999";
                  VALI CRIT("PTAB(rcnumero,'CGRUPOS',1).AND.EMPT(CGRUPOS->reintnum)~CANCELAMENTO inv lido|ou|j  reintegrado.")
                  AJUDA "Informe o n£mero do cancelamento a reintegrar."
                  CMDF8 "VDBF(6,17,20,77,'CGRUPOS',{'numero','grupo','codigo','nome'},2,'numero',[])"
                  MOSTRA {"LEFT(TRAN(CGRUPOS->nome,[]),35)", 3 , 6 }

 @ l_s+04 ,c_s+24 GET  rgrupo;
                  PICT "!!";
		  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1)~GRUPO n„o existe na tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,51,20,77,'ARQGRUP',{'grup','classe','inicio','final'},1,'grup')"

 @ l_s+04 ,c_s+36 GET  rcodigo;
                  PICT "999999";
                  VALI CRIT("(PTAB(M->rcodigo,'GRUPOS',1).AND.GRUPOS->situacao=[2]).OR.(!PTAB(rcodigo,'GRUPOS',1))~CODIGO n„o aceit vel,|ultrapassa os limites permitidos|pelo grupo ou|contrato encontra-se Ativo.")
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,64,20,77,'GRUPOS',{'grupo','codigo'},1,'codigo',[GRUPOS->situacao='2'])"

 @ l_s+05 ,c_s+11 GET  rmotivo;
                  PICT "@!";
                  VALI CRIT("!EMPT(rmotivo)~Necess rio informar MOTIVO")
                  AJUDA "Entre com a justificativa"

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
  CLOSE CGRUPOS
  IF !USEARQ("CGRUPOS",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CGRUPOS")                                // abre o dbf e seus indices
 #endi

 PTAB(grupo,"ARQGRUP",1,.t.)                       // abre arquivo p/ o relacionamento
 SET RELA TO grupo INTO ARQGRUP                    // relacionamento dos arquivos
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="numero"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,2,11)            // nao quis configurar...
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
 IF !USEARQ("COECOB",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("COECOB")                                  // abre o dbf e seus indices
#endi

cpord="numero"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("CINSCRIT",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CINSCRIT")                                // abre o dbf e seus indices
#endi

cpord="numero+grau+STR(seq,02,00)"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("CTAXAS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CTAXAS")                                  // abre o dbf e seus indices
#endi

cpord="numero+tipo+circ"
INDTMP()

criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE CGRUPOS
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
  PTAB(M->rcnumero,[CGRUPOS],1)
  DO WHIL !EOF().AND.numero=M->rcnumero
   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF numero==M->rcnumero                          // se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cancelamento.:"
    IMPCTL(drvpenf)
    @ cl,017 SAY numero+[ (]+grupo+[/]+codigo+[ ]+motivo+[)]// Cancelamento
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Reintegra‡Æo.:",cl,000)
    IMPCTL(drvpenf)
    @ cl,017 SAY M->rnumero+[ (]+M->rgrupo+[/]+M->rcodigo+[ ]+M->rmotivo+[)]// Reintegra‡Æo
    IMPCTL(drvtenf)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Situa‡„o:",cl,000)
    @ cl,010 SAY TRAN(situacao,"9")                // Situa‡„o
    @ cl,014 SAY "Nome:"
    @ cl,020 SAY nome                              // Nome
    @ cl,057 SAY "Nascto.:"
    @ cl,066 SAY TRAN(nascto_,"@D")                // Nascto
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "EstCivil:"
    @ cl,010 SAY TRAN(estcivil,"!!")               // Est Civil
    @ cl,014 SAY "CPF.:"
    @ cl,020 SAY TRAN(cpf,"@R 999.999.999-99")     // CPF
    @ cl,037 SAY "R.G.:"
    @ cl,043 SAY TRAN(rg,"@!")                     // R.G.
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o:",cl,000)
    @ cl,010 SAY endereco                          // Endere‡o
    @ cl,046 SAY "Bairro:"
    @ cl,054 SAY bairro                            // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Cidade..:"
    @ cl,010 SAY cidade                            // Cidade
    @ cl,037 SAY "CEP.:"
    @ cl,043 SAY TRAN(cep,"@R 99999-999")          // CEP
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contato.:"
    @ cl,010 SAY TRAN(contato,"@!")                // Contato
    @ cl,037 SAY "TipCont:"
    @ cl,046 SAY TRAN(tipcont,"99")                // TipCont
    @ cl,051 SAY "Vlcarne:"
    @ cl,060 SAY vlcarne                           // Vlcarne
    @ cl,065 SAY "FormaPgto:"
    @ cl,076 SAY TRAN(formapgto,"99")              // FormaPgto
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Admiss„o:",cl,000)
    @ cl,010 SAY TRAN(admissao,"@D")               // Admiss„o
    IMPAC("Carˆncia:",cl,020)
    @ cl,030 SAY TRAN(tcarencia,"@D")              // T.Carˆncia
    @ cl,040 SAY "SaiTxa:"
    @ cl,048 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
    @ cl,055 SAY "Vend/Reg/Cob.:"
    @ cl,070 SAY TRAN(vendedor,"!!")               // Vendedor
    @ cl,072 SAY "/"
    @ cl,073 SAY TRAN(regiao,"999")                // Regi„o
    @ cl,076 SAY "/"
		@ cl,077 SAY TRAN(cobrador,"!!!")               // Cobrador
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Obs.....:"
    IMPMEMO(obs,35,1,cl,010,.f.)                   // Obs (memo)
    @ cl,051 SAY "Renovar:"
    @ cl,060 SAY TRAN(renovar,"@D")                // Renovar
    qli_m=MLCOUNT(obs,35)-1                        // quantas linhas a imprimir?
    li_m=0
    DO WHIL .t.                                    // imprime linhas do memo
     li_m++
     IF li_m>qli_m                                 // fim do memo
      EXIT
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     IMPMEMO(obs,35,1+li_m,cl,010,.f.)             // imprime...
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
    ENDD
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Funerais:"
    @ cl,010 SAY TRAN(funerais,"99")               // Funerais
    @ cl,014 SAY "Circulares:- Inicial:"
    @ cl,036 SAY TRAN(circinic,"999")              // Circ.Inicial
    IMPAC("£ltima:",cl,041)
    @ cl,049 SAY TRAN(ultcirc,"999")               // Ult.Circular
    @ cl,054 SAY "Emitidas:"
    @ cl,064 SAY TRAN(qtcircs,"999")               // Qt.Circulares
    @ cl,069 SAY "Pagas:"
    @ cl,076 SAY TRAN(qtcircpg,"999")              // Circ.Pagas
    chv012=numero
    SELE COECOB
    SEEK chv012
    IF FOUND()
     IF cl+4>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     IMPAC("Tipo Endere‡o                            Bairro               CEP",cl,000)
     cl+=1                                         // soma contador de linha
     @ cl,005 SAY "Cidade                    UF Telefone       Obs"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "==== =================================== ==================== ========="
     DO WHIL ! EOF() .AND. chv012=numero //LEFT(&(INDEXKEY(0)),LEN(chv012))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(tipo,"!")                  // Tipo
      @ cl,005 SAY TRAN(endereco,"@!")             // Endere‡o
      @ cl,041 SAY TRAN(bairro,"@!")               // Bairro
      @ cl,062 SAY TRAN(cep,"@R 99999-999")        // CEP
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,005 SAY TRAN(cidade,"@!")               // Cidade
      @ cl,031 SAY TRAN(uf,"!!")                   // UF
      @ cl,034 SAY TRAN(telefone,"@!")             // Telefone
      @ cl,049 SAY obs                             // Obs
      SKIP                                         // pega proximo registro
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE CGRUPOS                                   // volta ao arquivo pai
    chv012=numero
    SELE CINSCRIT
    SEEK chv012
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "INSCRITOS"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY REPL("-",78)
     DO WHIL ! EOF() .AND. chv012=numero //LEFT(&(INDEXKEY(0)),LEN(chv012))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
	BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "Inscr..:"
      @ cl,009 SAY TRAN(grau,"9")                  // Inscr.
      @ cl,010 SAY "/"
      @ cl,011 SAY TRAN(seq,"99")                  // Seq
      @ cl,016 SAY "Titular?:"
      @ cl,026 SAY TRAN(ehtitular,"!")             // Titular?
      @ cl,029 SAY nome                            // Nome
      @ cl,065 SAY IIF(Interdito='S',[Interdito],[         ])// Interdito
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,001 SAY "Sexo..:"
      @ cl,009 SAY TRAN(sexo,"!")                  // Sexo
      @ cl,012 SAY "Est. Civil.:"
      @ cl,025 SAY estcivil                        // Est Civil
      @ cl,034 SAY "Nascto.:"
      @ cl,043 SAY TRAN(nascto_,"@D")              // Nascto
      IMPAC("T.Carˆncia:",cl,053)
      @ cl,065 SAY TRAN(tcarencia,"@D")            // T.Carˆncia
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,001 SAY "V/F...:"
      @ cl,009 SAY TRAN(vivofalec,"!")             // V/F
      @ cl,012 SAY "Falecimento:"
      @ cl,025 SAY TRAN(falecto_,"@D")             // Falecto.
      @ cl,034 SAY "Tipo...:"
      @ cl,043 SAY TRAN(tipo,"!!!")                // Tipo
      @ cl,053 SAY "N§Processo:"
      @ cl,065 SAY TRAN(procnr,"@R 99999/99")      // N§Processo
      SKIP                                         // pega proximo registro
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE CGRUPOS                                   // volta ao arquivo pai
    chv012=numero
    SELE CTAXAS
    SEEK chv012
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
		 @ cl,000 SAY "Tipo Circular Emissao       Valor Pagamento Valor pago Cobrador Forma"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "==== ======== ======== ========== ========= ========== ======== ====="
     DO WHIL ! EOF() .AND. chv012=numero //LEFT(&(INDEXKEY(0)),LEN(chv012))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(tipo,"!")                  // Tipo
      @ cl,005 SAY TRAN(circ,"999")                // Circular
      @ cl,014 SAY TRAN(emissao_,"@D")             // Emissao
      @ cl,023 SAY TRAN(valor,"@E 999,999.99")     // Valor
      @ cl,034 SAY TRAN(pgto_,"@D")                // Pagamento
      @ cl,044 SAY TRAN(valorpg,"@E 999,999.99")   // Valor pago
			@ cl,055 SAY TRAN(cobrador,"!!!")             // Cobrador
      @ cl,064 SAY TRAN(forma,"!")                 // Forma
      SKIP                                         // pega proximo registro
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE CGRUPOS                                   // volta ao arquivo pai
		SELE CGRUPOS                                   // volta ao arquivo pai
		SKIP                                           // pega proximo registro
	 ELSE                                            // se nao atende condicao
		SKIP                                           // pega proximo registro
	 ENDI
	 exit
	ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET MARG TO                                        // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(2)                                           // grava variacao do relatorio

#ifdef COM_REDE
 CLOSE GRUPOS
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("ECOB",.f.,10,1)                       // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("ECOB")                                    // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi


msgt="PROCESSAMENTOS DO RELAT¢RIO|REINTEGRA€ŽO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE CGRUPOS                                      // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 PTAB(M->rcnumero,[CGRUPOS],1)
 DO WHIL !EOF().and.odometer()
  IF numero==M->rcnumero                           // se atender a condicao...
   IF !PTAB(M->rcodigo,'GRUPOS',1)
    SELE GRUPOS                                    // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     APPE BLAN                                     // cria registro em branco
    #endi

    SELE CGRUPOS                                   // inicializa registro em branco
    REPL GRUPOS->codigo WITH M->rcodigo,;
	 GRUPOS->grupo WITH M->rgrupo,;
	 GRUPOS->situacao WITH [1],;
	 GRUPOS->nome WITH nome,;
	 GRUPOS->nascto_ WITH nascto_,;
	 GRUPOS->estcivil WITH estcivil,;
	 GRUPOS->cpf WITH cpf,;
	 GRUPOS->rg WITH rg,;
	 GRUPOS->endereco WITH endereco,;
	 GRUPOS->bairro WITH bairro,;
	 GRUPOS->cidade WITH cidade,;
	 GRUPOS->uf WITH uf,;
	 GRUPOS->cep WITH cep,;
	 GRUPOS->contato WITH contato,;
	 GRUPOS->telefone WITH telefone,;
	 GRUPOS->tipcont WITH tipcont,;
	 GRUPOS->vlcarne WITH vlcarne,;
	 GRUPOS->formapgto WITH formapgto,;
	 GRUPOS->seguro WITH seguro,;
	 GRUPOS->admissao WITH admissao,;
	 GRUPOS->tcarencia WITH tcarencia,;
	 GRUPOS->saitxa WITH saitxa
    REPL GRUPOS->vendedor WITH vendedor,;
	 GRUPOS->regiao WITH regiao,;
	 GRUPOS->cobrador WITH cobrador,;
	 GRUPOS->obs WITH obs,;
	 GRUPOS->renovar WITH renovar,;
	 GRUPOS->funerais WITH funerais,;
	 GRUPOS->circinic WITH circinic,;
	 GRUPOS->ultcirc WITH ultcirc,;
	 GRUPOS->qtcircs WITH qtcircs,;
	 GRUPOS->qtcircpg WITH qtcircpg,;
	 GRUPOS->titular WITH titular,;
	 GRUPOS->particv WITH 0,;
	 GRUPOS->particf WITH particf,;
	 GRUPOS->nrdepend WITH nrdepend,;
	 GRUPOS->ultimp_ WITH ultimp_,;
	 GRUPOS->ender_ WITH ender_,;
	 GRUPOS->ultend WITH ultend
    SELE GRUPOS                                    // arquivo alvo do lancamento
    GRU_GET1(FORM_DIRETA)                          // faz processo do arq do lancamento

    #ifdef COM_REDE
     UNLOCK                                        // libera o registro
    #endi

    SELE CGRUPOS                                   // arquivo origem do processamento
   ENDI
   PARAMETROS('nrreint',M->nrreint+1)

   #ifdef COM_REDE
    IF PTAB(rgrupo,'ARQGRUP',1)
     REPBLO('ARQGRUP->contrat',{||ARQGRUP->contrat + 1 + R00601F9()})
    ENDI
    IF PTAB(M->rcodigo,'GRUPOS',1)
     REPBLO('GRUPOS->situacao',{||[1]})
    ENDI
    REPBLO('GRUPOS->grupo',{||M->rgrupo})
    REPBLO('GRUPOS->nome',{||nome})
    REPBLO('GRUPOS->nascto_',{||nascto_})
    REPBLO('GRUPOS->estcivil',{||estcivil})
    REPBLO('GRUPOS->cpf',{||cpf})
    REPBLO('GRUPOS->rg',{||rg})
    REPBLO('GRUPOS->endereco',{||endereco})
    REPBLO('GRUPOS->bairro',{||bairro})
    REPBLO('GRUPOS->cidade',{||cidade})
    REPBLO('GRUPOS->uf',{||uf})
    REPBLO('GRUPOS->cep',{||cep})
    REPBLO('GRUPOS->contato',{||contato})
    REPBLO('GRUPOS->telefone',{||telefone})
    REPBLO('GRUPOS->tipcont',{||tipcont})
    REPBLO('GRUPOS->vlcarne',{||vlcarne})
    REPBLO('GRUPOS->formapgto',{||formapgto})
    REPBLO('GRUPOS->seguro',{||seguro})
    REPBLO('GRUPOS->admissao',{||admissao})
    REPBLO('GRUPOS->tcarencia',{||tcarencia})
    REPBLO('GRUPOS->saitxa',{||saitxa})
    REPBLO('GRUPOS->diapgto',{||diapgto})
    REPBLO('GRUPOS->vendedor',{||vendedor})
    REPBLO('GRUPOS->regiao',{||regiao})
    REPBLO('GRUPOS->cobrador',{||cobrador})
    REPBLO('GRUPOS->obs',{||obs})
    REPBLO('GRUPOS->renovar',{||renovar})
    REPBLO('GRUPOS->funerais',{||funerais})
    REPBLO('GRUPOS->circinic',{||circinic})
    REPBLO('GRUPOS->ultcirc',{||ultcirc})
    REPBLO('GRUPOS->qtcircs',{||qtcircs})
    REPBLO('GRUPOS->qtcircpg',{||qtcircpg})
    REPBLO('GRUPOS->titular',{||titular})
    REPBLO('GRUPOS->particv',{||0})
    REPBLO('GRUPOS->particf',{||particf})
    REPBLO('GRUPOS->nrdepend',{||nrdepend})
    REPBLO('GRUPOS->ultimp_',{||ultimp_})
    REPBLO('GRUPOS->ender_',{||ender_})
    REPBLO('GRUPOS->ultend',{||ultend})
    REPBLO('GRUPOS->natural',{||natural})
    REPBLO('GRUPOS->relig',{||relig})
   #else
   PARAMETROS('nrreint',M->nrreint+1)
    IF PTAB(rgrupo,'ARQGRUP',1)
     REPL ARQGRUP->contrat WITH ARQGRUP->contrat + 1 + R00601F9()
    ENDI
    IF PTAB(M->rcodigo,'GRUPOS',1)
     REPL GRUPOS->situacao WITH [1]
    ENDI
    REPL GRUPOS->nome WITH nome
    REPL GRUPOS->grupo WITH M->rgrupo
    REPL GRUPOS->nascto_ WITH nascto_
    REPL GRUPOS->estcivil WITH estcivil
    REPL GRUPOS->cpf WITH cpf
    REPL GRUPOS->rg WITH rg
    REPL GRUPOS->endereco WITH endereco
    REPL GRUPOS->bairro WITH bairro
    REPL GRUPOS->cidade WITH cidade
    REPL GRUPOS->cep WITH cep
    REPL GRUPOS->contato WITH contato,;
         GRUPOS->telefone WITH telefone
    REPL GRUPOS->tipcont WITH tipcont
    REPL GRUPOS->vlcarne WITH vlcarne
    REPL GRUPOS->formapgto WITH formapgto
    REPL GRUPOS->seguro WITH seguro
    REPL GRUPOS->admissao WITH admissao
    REPL GRUPOS->tcarencia WITH tcarencia
    REPL GRUPOS->saitxa WITH saitxa,;
         GRUPOS->diapgto WITH diapgto
    REPL GRUPOS->vendedor WITH vendedor
    REPL GRUPOS->regiao WITH regiao
    REPL GRUPOS->cobrador WITH cobrador,;
         GRUPOS->obs WITH  obs
    REPL GRUPOS->renovar WITH renovar
    REPL GRUPOS->funerais WITH funerais
    REPL GRUPOS->natural WITH natural,;
	 GRUPOS->circinic WITH circinic,;
	 GRUPOS->ultcirc WITH ultcirc,;
	 GRUPOS->qtcircs WITH qtcircs,;
	 GRUPOS->qtcircpg WITH qtcircpg,;
	 GRUPOS->titular WITH titular,;
	 GRUPOS->particv WITH 0,;
	 GRUPOS->particf WITH particf,;
	 GRUPOS->nrdepend WITH nrdepend,;
	 GRUPOS->ultimp_ WITH ultimp_,;
	 GRUPOS->ender_ WITH ender_,;
	 GRUPOS->ultend WITH ultend
    REPL GRUPOS->relig WITH relig
   #endi

   chv012=numero
   SELE COECOB
   SEEK chv012
   IF FOUND()
    DO WHIL ! EOF() .AND. chv012=LEFT(&(INDEXKEY(0)),LEN(chv012))
     SELE ECOB                                     // arquivo alvo do lancamento

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

     SELE COECOB                                   // inicializa registro em branco
     REPL ECOB->codigo WITH M->rcodigo,;
          ECOB->tipo WITH tipo,;
          ECOB->endereco WITH endereco,;
          ECOB->bairro WITH bairro,;
          ECOB->cep WITH cep,;
	  ECOB->cidade WITH cidade,;
          ECOB->uf WITH uf,;
          ECOB->telefone WITH telefone,;
	  ECOB->obs WITH obs

     #ifdef COM_REDE
      ECOB->(DBUNLOCK())                           // libera o registro
     #endi

     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE CGRUPOS                                    // volta ao arquivo pai
   chv012=numero
   SELE CINSCRIT
   SEEK chv012
   IF FOUND()
    DO WHIL ! EOF() .AND. chv012=LEFT(&(INDEXKEY(0)),LEN(chv012))
     SELE INSCRITS                                 // arquivo alvo do lancamento

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

     SELE CINSCRIT                                 // inicializa registro em branco
     REPL INSCRITS->codigo WITH M->rcodigo,;
          INSCRITS->grau WITH grau,;
          INSCRITS->seq WITH seq,;
          INSCRITS->ehtitular WITH ehtitular,;
	  INSCRITS->nome WITH nome,;
	  INSCRITS->nascto_ WITH nascto_,;
          INSCRITS->estcivil WITH estcivil,;
          INSCRITS->interdito WITH interdito,;
          INSCRITS->sexo WITH sexo,;
          INSCRITS->tcarencia WITH tcarencia,;
          INSCRITS->lancto_ WITH lancto_,;
	  INSCRITS->vivofalec WITH vivofalec,;
          INSCRITS->falecto_ WITH falecto_,;
          INSCRITS->tipo WITH tipo,;
	  INSCRITS->procnr WITH procnr,;
          INSCRITS->por WITH M->usuario
     SELE INSCRITS                                 // arquivo alvo do lancamento
     INS_GET1(FORM_DIRETA)                         // faz processo do arq do lancamento

     #ifdef COM_REDE
      UNLOCK                                       // libera o registro
     #endi

     SELE CINSCRIT                                 // arquivo origem do processamento

     #ifdef COM_REDE
      IF vivofalec = [V]
       REPBLO('ARQGRUP->partic',{||ARQGRUP->partic + 1})
      ENDI
     #else
      IF vivofalec = [V]
       REPL ARQGRUP->partic WITH ARQGRUP->partic + 1
      ENDI
     #endi

     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE CGRUPOS                                    // volta ao arquivo pai
   chv012=numero
   SELE CTAXAS
   SEEK chv012
   IF FOUND()
    DO WHIL ! EOF() .AND. chv012=LEFT(&(INDEXKEY(0)),LEN(chv012))
     IF PTAB(M->rcodigo,'GRUPOS',1)
      SELE TAXAS                                   // arquivo alvo do lancamento

      #ifdef COM_REDE
       DO WHIL .t.
	APPE BLAN                                  // tenta abri-lo
	IF NETERR()                                // nao conseguiu
         DBOX(ms_uso,20)                           // avisa e
         LOOP                                      // tenta novamente
        ENDI
        EXIT                                       // ok. registro criado
       ENDD
      #else
       APPE BLAN                                   // cria registro em branco
      #endi

      SELE CTAXAS                                  // inicializa registro em branco
      REPL TAXAS->codigo WITH M->rcodigo,;
           TAXAS->tipo WITH tipo,;
           TAXAS->circ WITH circ,;
           TAXAS->emissao_ WITH emissao_,;
           TAXAS->valor WITH valor,;
           TAXAS->pgto_ WITH pgto_,;
           TAXAS->valorpg WITH valorpg,;
	   TAXAS->cobrador WITH cobrador,;
           TAXAS->forma WITH forma,;
           TAXAS->baixa_ WITH baixa_,;
           TAXAS->flag_excl WITH flag_excl,;
           TAXAS->codlan WITH codlan,;
           TAXAS->filial WITH filial,;
           TAXAS->stat WITH stat,;
           TAXAS->por WITH por

      #ifdef COM_REDE
       TAXAS->(DBUNLOCK())                         // libera o registro
      #endi

     ENDI
     SKIP                                          // pega proximo registro
    ENDD
   ENDI
   SELE CGRUPOS                                    // volta ao arquivo pai
	 #ifdef COM_REDE
    REPBLO('CGRUPOS->reintnum',{||M->rnumero})
    REPBLO('CGRUPOS->codreint',{||M->rgrupo+M->rcodigo})
    REPBLO('CGRUPOS->motreint',{||M->rmotivo})
    IF EMPT(CGRUPOS->reintem_)
     REPBLO('CGRUPOS->reintem_',{||DATE()})
    ENDI
    IF EMPT(CGRUPOS->reintpor)
     REPBLO('CGRUPOS->reintpor',{||M->usuario})
    ENDI
   #else
    REPL CGRUPOS->reintnum WITH M->rnumero
    REPL CGRUPOS->codreint WITH M->rgrupo+M->rcodigo
    REPL CGRUPOS->motreint WITH M->rmotivo
    IF EMPT(CGRUPOS->reintem_)
     REPL CGRUPOS->reintem_ WITH DATE()
    ENDI
    IF EMPT(CGRUPOS->reintpor)
     REPL CGRUPOS->reintpor WITH M->usuario
    ENDI
   #endi
   SELE CGRUPOS                                    // volta ao arquivo pai
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
  EXIT
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
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
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,070 SAY "ADM_R006"                            // c¢digo relat¢rio
 @ 2,000 SAY titrel                                // t¡tulo a definir
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 IMPCTL(drvpenf)
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 IMPCTL(drvtenf)
 IMPAC("REINTEGRA€ŽO",3,000)
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADM_R006.PRG
