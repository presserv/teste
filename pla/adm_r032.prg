procedure adm_r032
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADM_R032.PRG
 \ Data....: 26-04-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Proc.Cancelamentos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("CANCELS",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CANCELS")                                 // abre o dbf e seus indices
#endi

titrel:=criterio := ""                             // inicializa variaveis
cpord="ccodigo"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,1,11)             // nao quis configurar...
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
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

PTAB(grupo,"ARQGRUP",1,.t.)                        // abre arquivo p/ o relacionamento
SET RELA TO grupo INTO ARQGRUP                     // relacionamento dos arquivos
cpord="codigo"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("ECOB",.f.,10,1)                       // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("ECOB")                                    // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

cpord="codigo"
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
SELE CANCELS
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
	 IF !EMPT(procto_)
    SKIP
    LOOP
   ENDI
	 IF EMPT(procto_)                                // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(cnumero,"999999")            // N�mero
    @ cl,007 SAY TRAN(ccodigo,"999999")            // Codigo
    @ cl,014 SAY TRAN(cgrupo,"!!")                 // Grupo
    @ cl,020 SAY cmotivo
                 //SUBSTR([Falta pgto |Mudou      |Ignorado   |Desist�ncia],AT(cmotivo,[Falta pgto |Mudou      |Ignorado   |Desist�ncia]),11)// Motivo
    chv010=ccodigo
    SELE GRUPOS
    SEEK chv010
    IF FOUND()
     IF cl+6>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=1                                         // soma contador de linha
     IMPAC(nemp,cl,000)                            // nome da empresa
     @ cl,070 SAY "PAG"
		 @ cl,074 SAY TRAN(pg_,'9999')                 // n�mero da p�gina
     cl+=1                                         // soma contador de linha
     IMPAC(nsis,cl,000)                            // t�tulo aplica��o
     @ cl,070 SAY "ADM_R032"                       // c�digo relat�rio
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY titrel                           // t�tulo a definir
     @ cl,062 SAY NSEM(DATE())                     // dia da semana
     IMPCTL(drvpenf)
     @ cl,070 SAY DTOC(DATE())                     // data do sistema
     IMPCTL(drvtenf)
		 cl+=1                                         // soma contador de linha
     @ cl,000 SAY "CONTRATOS"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY REPL("-",78)
		 DO WHIL ! EOF() .AND. chv010=codigo //LEFT(&(INDEXKEY(0)),LEN(chv010))
			#ifdef COM_TUTOR
			 IF IN_KEY()=K_ESC                           // se quer cancelar
			#else
			 IF INKEY()=K_ESC                            // se quer cancelar
			#endi
			 IF canc()                                   // pede confirmacao
				BREAK                                      // confirmou...
			 ENDI
			ENDI
			IF GRUPOS->codigo==CANCELS->ccodigo          // se atender a condicao...
			 REL_CAB(2)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY "Codigo:"
       @ cl,008 SAY TRAN(codigo,"999999")          // Codigo
       @ cl,015 SAY TRAN(grupo,"!!")               // Grupo
       IMPAC("Situa��o:",cl,018)
       @ cl,028 SAY TRAN(situacao,"9")             // Situa��o
       @ cl,031 SAY "Nome:"
       @ cl,037 SAY nome                           // Nome
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY "Nascto:"
       @ cl,008 SAY TRAN(nascto_,"@D")             // Nascto
       @ cl,018 SAY "E.Civil.:"
       @ cl,028 SAY TRAN(estcivil,"!!")            // Est Civil
       @ cl,031 SAY "CPF.:"
       @ cl,037 SAY TRAN(cpf,"@R 999.999.999-99")  // CPF
       @ cl,053 SAY "R.G.:"
       @ cl,059 SAY TRAN(rg,"@!")                  // R.G.
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       IMPAC("Endere�o:",cl,000)
       @ cl,010 SAY endereco                       // Endere�o
       @ cl,046 SAY "Bairro:"
       @ cl,056 SAY bairro                         // Bairro
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY "Cidade..:"
       @ cl,010 SAY cidade                         // Cidade
       @ cl,037 SAY "CEP:"
       @ cl,042 SAY TRAN(cep,"@R 99999-999")       // CEP
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY "Contato.:"
       @ cl,010 SAY TRAN(contato,"@!")             // Contato
			 @ cl,037 SAY "TipCont.:"
       @ cl,047 SAY TRAN(tipcont,"99")             // TipCont
       @ cl,051 SAY "Vlcarne:"
       @ cl,060 SAY vlcarne                        // Vlcarne
			 @ cl,065 SAY "FormaPgto:"
       @ cl,076 SAY TRAN(formapgto,"99")           // FormaPgto
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       IMPAC("Admiss�o:",cl,000)
       @ cl,010 SAY TRAN(admissao,"@D")            // Admiss�o
       IMPAC("Car�ncia:",cl,020)
       @ cl,030 SAY TRAN(tcarencia,"@D")           // T.Car�ncia
       @ cl,039 SAY "SaiTxa:"
       @ cl,047 SAY TRAN(saitxa,"@R 99/99")        // Saitxa
       @ cl,054 SAY "Vend/Reg/Cob:"
       @ cl,068 SAY TRAN(vendedor,"!!")            // Vendedor
       @ cl,070 SAY "/"
       @ cl,071 SAY TRAN(regiao,"999")             // Regi�o
       @ cl,074 SAY "/"
			 @ cl,075 SAY TRAN(cobrador,"!!!")            // Cobrador
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY "Obs.....:"
       IMPMEMO(obs,35,1,cl,010,.f.)                // Obs (memo)
       @ cl,046 SAY "Renovar.:"
       @ cl,056 SAY TRAN(renovar,"@D")             // Renovar
       qli_m=MLCOUNT(obs,35)-1                     // quantas linhas a imprimir?
       li_m=0
       DO WHIL .t.                                 // imprime linhas do memo
        li_m++
        IF li_m>qli_m                              // fim do memo
         EXIT
        ENDI
        REL_CAB(1)                                 // soma cl/imprime cabecalho
        IMPMEMO(obs,35,1+li_m,cl,010,.f.)          // imprime...
        #ifdef COM_TUTOR
         IF IN_KEY()=K_ESC                         // se quer cancelar
        #else
         IF INKEY()=K_ESC                          // se quer cancelar
        #endi
         IF canc()                                 // pede confirmacao
          BREAK                                    // confirmou...
         ENDI
        ENDI
       ENDD
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY "Funerais:"
			 @ cl,010 SAY TRAN(funerais,"99")            // Funerais
       @ cl,014 SAY "Circulares:- Inicial:"
       @ cl,036 SAY TRAN(circinic,"999")           // Circ.Inicial
       @ cl,041 SAY "Ultima:"
			 @ cl,049 SAY TRAN(ultcirc,"999")            // Ult.Circular
			 @ cl,054 SAY "Emitdas:"
			 @ cl,063 SAY TRAN(qtcircs,"999")            // Qt.Circulares
			 @ cl,068 SAY "Pagas:"
			 @ cl,075 SAY TRAN(qtcircpg,"999")           // Circ.Pagas
			 chv011=codigo
			 SELE ECOB
			 SEEK chv011
			 IF FOUND()
				IF cl+4>maxli                              // se cabecalho do arq filho
				 REL_CAB(0)                                // nao cabe nesta pagina
				ENDI                                       // salta para a proxima pagina
				cl+=1                                      // soma contador de linha
				IMPAC("Tipo Endere�o                            Bairro",cl,000)
				cl+=1                                      // soma contador de linha
				@ cl,005 SAY "CEP       Cidade                    UF Telefone       Obs"
				cl+=1                                      // soma contador de linha
				@ cl,000 SAY "==== =================================== ================================="
				DO WHIL ! EOF() .AND. chv011=codigo //LEFT(&(INDEXKEY(0)),LEN(chv011))
         #ifdef COM_TUTOR
          IF IN_KEY()=K_ESC                        // se quer cancelar
         #else
          IF INKEY()=K_ESC                         // se quer cancelar
         #endi
          IF canc()                                // pede confirmacao
           BREAK                                   // confirmou...
          ENDI
         ENDI
         REL_CAB(1)                                // soma cl/imprime cabecalho
         @ cl,000 SAY TRAN(tipo,"!")               // Tipo
         @ cl,005 SAY TRAN(endereco,"@!")          // Endere�o
         @ cl,041 SAY TRAN(bairro,"@!")            // Bairro
         REL_CAB(1)                                // soma cl/imprime cabecalho
         @ cl,005 SAY TRAN(cep,"@R 99999-999")     // CEP
         @ cl,015 SAY TRAN(cidade,"@!")            // Cidade
         @ cl,041 SAY TRAN(uf,"!!")                // UF
         @ cl,044 SAY TRAN(telefone,"@!")          // Telefone
         @ cl,059 SAY obs                          // Obs
         SKIP                                      // pega proximo registro
        ENDD
        cl+=3                                      // soma contador de linha
			 ENDI
       SELE GRUPOS                                 // volta ao arquivo pai
       chv011=codigo
       SELE INSCRITS
       SEEK chv011
       IF FOUND()
        IF cl+2>maxli                              // se cabecalho do arq filho
         REL_CAB(0)                                // nao cabe nesta pagina
        ENDI                                       // salta para a proxima pagina
        cl+=1                                      // soma contador de linha
				@ cl,000 SAY "INSCRITOS"
				DO WHIL ! EOF() .AND. chv011=codigo //LEFT(&(INDEXKEY(0)),LEN(chv011))
				 #ifdef COM_TUTOR
					IF IN_KEY()=K_ESC                        // se quer cancelar
				 #else
					IF INKEY()=K_ESC                         // se quer cancelar
				 #endi
					IF canc()                                // pede confirmacao
					 BREAK                                   // confirmou...
					ENDI
				 ENDI
				 REL_CAB(1)                                // soma cl/imprime cabecalho
				 @ cl,000 SAY REPL("-",78)
         REL_CAB(1)                                // soma cl/imprime cabecalho
         @ cl,000 SAY "Inscr.:"
         @ cl,008 SAY TRAN(grau,"9")               // Inscr.
         @ cl,010 SAY "Seq.:"
         @ cl,016 SAY TRAN(seq,"99")               // Seq
         @ cl,020 SAY "Titular.?:"
         @ cl,031 SAY TRAN(ehtitular,"!")          // Titular?
         @ cl,035 SAY "Nome.:"
         @ cl,042 SAY nome                         // Nome
         REL_CAB(1)                                // soma cl/imprime cabecalho
         @ cl,000 SAY "Nascto:"
         @ cl,008 SAY TRAN(nascto_,"@D")           // Nascto
         @ cl,020 SAY "Est.Civil:"
         @ cl,031 SAY estcivil                     // Est Civil
				 @ cl,035 SAY "Interdito:"
				 @ cl,046 SAY TRAN(interdito,"!")          // Interdito
				 @ cl,049 SAY "Sexo:"
				 @ cl,055 SAY TRAN(sexo,"!")               // Sexo
				 IMPAC("Car�ncia:",cl,058)
				 @ cl,068 SAY TRAN(tcarencia,"@D")         // T.Car�ncia
				 REL_CAB(1)                                // soma cl/imprime cabecalho
				 @ cl,000 SAY "V/F...:"
				 @ cl,008 SAY TRAN(vivofalec,"!")          // V/F
				 @ cl,011 SAY "Falecto:"
				 @ cl,020 SAY TRAN(falecto_,"@D")          // Falecto.
				 @ cl,031 SAY "Tipo:"
				 @ cl,037 SAY TRAN(tipo,"!!!")             // Tipo
				 @ cl,043 SAY "N�Processo:"
				 @ cl,055 SAY TRAN(procnr,"@R 99999/99")   // N�Processo
				 SKIP                                      // pega proximo registro
				ENDD
				cl+=2                                      // soma contador de linha
			 ENDI
			 SELE GRUPOS                                 // volta ao arquivo pai
			 chv011=codigo
			 SELE TAXAS
			 SEEK chv011
			 IF FOUND()
				IF cl+3>maxli                              // se cabecalho do arq filho
				 REL_CAB(0)                                // nao cabe nesta pagina
				ENDI                                       // salta para a proxima pagina
				cl+=1                                      // soma contador de linha
				@ cl,000 SAY "Tipo Circ Emissao       Valor Pagamento Valor pago Cob Forma"
				cl+=1                                      // soma contador de linha
				@ cl,000 SAY "==== ==== ======== ========== ========= ========== === ====="
				DO WHIL ! EOF() .AND. chv011=codigo //LEFT(&(INDEXKEY(0)),LEN(chv011))
         #ifdef COM_TUTOR
          IF IN_KEY()=K_ESC                        // se quer cancelar
         #else
          IF INKEY()=K_ESC                         // se quer cancelar
         #endi
          IF canc()                                // pede confirmacao
           BREAK                                   // confirmou...
          ENDI
         ENDI
         REL_CAB(1)                                // soma cl/imprime cabecalho
         @ cl,000 SAY TRAN(tipo,"!")               // Tipo
         @ cl,005 SAY TRAN(circ,"999")             // Circ
         @ cl,010 SAY TRAN(emissao_,"@D")          // Emissao
				 @ cl,019 SAY TRAN(valor,"@E 999,999.99")  // Valor
				 @ cl,030 SAY TRAN(pgto_,"@D")             // Pagamento
				 @ cl,040 SAY TRAN(valorpg,"@E 999,999.99")// Valor pago
				 @ cl,051 SAY TRAN(cobrador,"!!!")          // Cob
         @ cl,055 SAY TRAN(forma,"!")              // Forma
         SKIP                                      // pega proximo registro
        ENDD
        cl+=3                                      // soma contador de linha
			 ENDI
       SELE GRUPOS                                 // volta ao arquivo pai
       SKIP                                        // pega proximo registro
      ELSE                                         // se nao atende condicao
       SKIP                                        // pega proximo registro
      ENDI
     ENDD
     cl+=2                                         // soma contador de linha
    ENDI
    SELE CANCELS                                   // volta ao arquivo pai
    SKIP                                           // pega proximo registro
	 ELSE                                            // se nao atende condicao
		SKIP                                           // pega proximo registro
	 ENDI
	ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(1)                                           // grava variacao do relatorio

#ifdef COM_REDE
 IF !USEARQ("CGRUPOS",.f.,10,1)                    // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CGRUPOS")                                 // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("COECOB",.f.,10,1)                     // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("COECOB")                                  // abre o dbf e seus indices
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

msgt="PROCESSAMENTOS DO RELAT�RIO|PROC.CANCELAMENTOS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE CANCELS                                      // processamentos apos emissao
 nrproxcan=cnumero
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF EMPT(procto_)                                 // se atender a condicao...

   chv011=ccodigo
   SELE GRUPOS
   SEEK chv011
   IF FOUND()
    DO WHIL ! EOF() .AND. chv011=codigo //LEFT(&(INDEXKEY(0)),LEN(chv011))
     IF GRUPOS->codigo==CANCELS->ccodigo           // se atender a condicao...
      SELE CGRUPOS                                 // arquivo alvo do lancamento
      GO BOTT
      nrproxcan:=sTRzero(VAL(numero)+1,6,0)
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

      SELE GRUPOS                                  // inicializa registro em branco
      REPL CGRUPOS->numero WITH nrproxcan,;
	   CGRUPOS->codigo WITH CANCELS->ccodigo,;
	   CGRUPOS->grupo WITH CANCELS->cgrupo,;
	   CGRUPOS->motivo WITH CANCELS->cmotivo,;
	   CGRUPOS->canclto_ WITH DATE(),;
	   CGRUPOS->cancpor WITH M->usuario,;
	   CGRUPOS->situacao WITH [2],;
	   CGRUPOS->nome WITH nome,;
	   CGRUPOS->nascto_ WITH nascto_,;
	   CGRUPOS->estcivil WITH estcivil,;
	   CGRUPOS->cpf WITH cpf,;
	   CGRUPOS->rg WITH rg,;
	   CGRUPOS->endereco WITH endereco,;
	   CGRUPOS->bairro WITH bairro,;
	   CGRUPOS->cidade WITH cidade,;
	   CGRUPOS->uf WITH uf
      REPL CGRUPOS->cep WITH cep,;
	   CGRUPOS->contato WITH contato,;
	   CGRUPOS->tipcont WITH tipcont,;
	   CGRUPOS->vlcarne WITH vlcarne,;
	   CGRUPOS->formapgto WITH formapgto,;
	   CGRUPOS->seguro WITH seguro,;
	   CGRUPOS->admissao WITH admissao,;
	   CGRUPOS->tcarencia WITH tcarencia,;
	   CGRUPOS->saitxa WITH saitxa,;
	   CGRUPOS->vendedor WITH vendedor,;
	   CGRUPOS->regiao WITH regiao,;
		 CGRUPOS->cobrador WITH cobrador,;
	   CGRUPOS->renovar WITH renovar,;
	   CGRUPOS->funerais WITH funerais,;
	   CGRUPOS->circinic WITH circinic,;
	   CGRUPOS->ultcirc WITH ultcirc,;
	   CGRUPOS->qtcircs WITH qtcircs,;
	   CGRUPOS->qtcircpg WITH qtcircpg,;
	   CGRUPOS->titular WITH titular,;
	   CGRUPOS->particv WITH particv,;
	   CGRUPOS->particf WITH particf,;
	   CGRUPOS->nrdepend WITH nrdepend,;
	   CGRUPOS->ultimp_ WITH ultimp_
      REPL CGRUPOS->ender_ WITH ender_,;
	   CGRUPOS->ultend WITH ultend,;
	   CGRUPOS->telefone WITH telefone,;
	   CGRUPOS->natural WITH natural,;
	   CGRUPOS->obs WITH obs,;
	   CGRUPOS->relig WITH relig

      #ifdef COM_REDE
       CGRUPOS->(DBUNLOCK())                       // libera o registro
      #endi


      chv012=codigo
      SELE ECOB
      SEEK chv012
      IF FOUND()
       DO WHIL ! EOF() .AND. chv012=codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
	SELE COECOB                                // arquivo alvo do lancamento

	#ifdef COM_REDE
	 DO WHIL .t.
	  APPE BLAN                                // tenta abri-lo
	  IF NETERR()                              // nao conseguiu
	   DBOX(ms_uso,20)                         // avisa e
	   LOOP                                    // tenta novamente
	  ENDI
          EXIT                                     // ok. registro criado
         ENDD
	#else
         APPE BLAN                                 // cria registro em branco
        #endi

        SELE ECOB                                  // inicializa registro em branco
        REPL COECOB->numero WITH nrproxcan,;
	     COECOB->tipo WITH tipo,;
	     COECOB->endereco WITH endereco,;
	     COECOB->bairro WITH bairro,;
	     COECOB->cep WITH cep,;
             COECOB->cidade WITH cidade,;
             COECOB->uf WITH uf,;
             COECOB->telefone WITH telefone,;
	     COECOB->obs WITH obs

	#ifdef COM_REDE
         COECOB->(DBUNLOCK())                      // libera o registro
        #endi


        #ifdef COM_REDE
         BLOREG(0,.5)
	#endi

        DELE                                       // exclui registro processado

        #ifdef COM_REDE
	 UNLOCK                                    // libera o registro
	#endi

        SKIP                                       // pega proximo registro
       ENDD
      ENDI
      SELE GRUPOS                                  // volta ao arquivo pai
      chv012=codigo
      SELE INSCRITS
      SEEK chv012
      IF FOUND()
       DO WHIL ! EOF() .AND. chv012=codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
        SELE CINSCRIT                              // arquivo alvo do lancamento

	#ifdef COM_REDE
	 DO WHIL .t.
          APPE BLAN                                // tenta abri-lo
	  IF NETERR()                              // nao conseguiu
	   DBOX(ms_uso,20)                         // avisa e
           LOOP                                    // tenta novamente
          ENDI
          EXIT                                     // ok. registro criado
         ENDD
        #else
	 APPE BLAN                                 // cria registro em branco
	#endi

	SELE INSCRITS                              // inicializa registro em branco
	REPL CINSCRIT->numero WITH nrproxcan,;
	     CINSCRIT->codigo WITH CANCELS->ccodigo,;
	     CINSCRIT->grau WITH grau,;
	     CINSCRIT->seq WITH seq,;
	     CINSCRIT->ehtitular WITH ehtitular,;
	     CINSCRIT->nome WITH nome,;
	     CINSCRIT->nascto_ WITH nascto_,;
	     CINSCRIT->estcivil WITH estcivil,;
	     CINSCRIT->interdito WITH interdito,;
	     CINSCRIT->sexo WITH sexo,;
	     CINSCRIT->tcarencia WITH tcarencia,;
	     CINSCRIT->lancto_ WITH lancto_,;
	     CINSCRIT->vivofalec WITH vivofalec,;
	     CINSCRIT->falecto_ WITH falecto_,;
	     CINSCRIT->tipo WITH tipo,;
	     CINSCRIT->procnr WITH procnr,;
	     CINSCRIT->por WITH por

	#ifdef COM_REDE
	 CINSCRIT->(DBUNLOCK())                    // libera o registro
	#endi

/*
	#ifdef COM_REDE
	 IF vivofalec=[V]
	  REPBLO('ARQGRUP->partic',{||ARQGRUP->partic - 1})
	 ENDI
	#else
	 IF vivofalec=[V]
	  REPL ARQGRUP->partic WITH ARQGRUP->partic - 1
	 ENDI
	#endi
*/

	#ifdef COM_REDE
	 SELE INSCRITS
	 BLOREG(0,.5)
	#endi

	DELE                                       // exclui registro processado

	#ifdef COM_REDE
	 UNLOCK                                    // libera o registro
	#endi

	SKIP                                       // pega proximo registro
       ENDD
      ENDI
      SELE GRUPOS                                  // volta ao arquivo pai
      chv012=codigo
      SELE TAXAS
      SEEK chv012
      IF FOUND()
       DO WHIL ! EOF() .AND. chv012=codigo //LEFT(&(INDEXKEY(0)),LEN(chv012))
	SELE CTAXAS                                // arquivo alvo do lancamento

	#ifdef COM_REDE
	 DO WHIL .t.
	  APPE BLAN                                // tenta abri-lo
	  IF NETERR()                              // nao conseguiu
	   DBOX(ms_uso,20)                         // avisa e
	   LOOP                                    // tenta novamente
	  ENDI
	  EXIT                                     // ok. registro criado
	 ENDD
	#else
	 APPE BLAN                                 // cria registro em branco
	#endi

	SELE TAXAS                                 // inicializa registro em branco
	REPL CTAXAS->numero WITH nrproxcan,;
	     CTAXAS->codigo WITH CANCELS->ccodigo,;
	     CTAXAS->tipo WITH tipo,;
	     CTAXAS->circ WITH circ,;
	     CTAXAS->emissao_ WITH emissao_,;
	     CTAXAS->valor WITH valor,;
	     CTAXAS->pgto_ WITH pgto_,;
	     CTAXAS->valorpg WITH valorpg,;
			 CTAXAS->cobrador WITH cobrador,;
	     CTAXAS->forma WITH forma,;
	     CTAXAS->baixa_ WITH baixa_,;
	     CTAXAS->por WITH por,;
	     CTAXAS->flag_excl WITH flag_excl,;
	     CTAXAS->codlan WITH codlan,;
	     CTAXAS->stat WITH stat

	#ifdef COM_REDE
	 CTAXAS->(DBUNLOCK())                      // libera o registro
	#endi


	#ifdef COM_REDE
	 BLOREG(0,.5)
	#endi

	DELE                                       // exclui registro processado

	#ifdef COM_REDE
	 UNLOCK                                    // libera o registro
	#endi

	SKIP                                       // pega proximo registro
       ENDD
      ENDI
      SELE GRUPOS                                  // volta ao arquivo pai
      PARAMETROS('nrcanc',M->nrcanc+1)

/*      #ifdef COM_REDE
//       REPBLO('ARQGRUP->contrat',{||ARQGRUP->contrat - 1})
       REPBLO('GRUPOS->admissao',{||CTOD([  /  /  ])})
			 REPBLO('GRUPOS->cobrador',{||[ ]})
       REPBLO('GRUPOS->titular',{||[ ]})
       REPBLO('GRUPOS->nome',{||[ ]})
       REPBLO('GRUPOS->endereco',{||[ ]})
       REPBLO('GRUPOS->bairro',{||[ ]})
       REPBLO('GRUPOS->cidade',{||[ ]})
       REPBLO('GRUPOS->cep',{||[ ]})
       REPBLO('GRUPOS->uf',{||[ ]})
       REPBLO('GRUPOS->funerais',{||0})
       REPBLO('GRUPOS->qtcircs',{||0})
       REPBLO('GRUPOS->particv',{||0})
       REPBLO('GRUPOS->particf',{||0})
       REPBLO('GRUPOS->seguro',{||0})
       REPBLO('GRUPOS->nascto_',{||CTOD('  /  /  ')})
       REPBLO('GRUPOS->estcivil',{||[  ]})
       REPBLO('GRUPOS->cpf',{||[  ]})
       REPBLO('GRUPOS->rg',{||[ ]})
       REPBLO('GRUPOS->contato',{||[ ]})
       REPBLO('GRUPOS->telefone',{||[ ]})
       REPBLO('GRUPOS->tipcont',{||[ ]})
       REPBLO('GRUPOS->formapgto',{||[ ]})
       REPBLO('GRUPOS->tcarencia',{||CTOD('  /  /  ')})
       REPBLO('GRUPOS->saitxa',{||[ ]})
       REPBLO('GRUPOS->regiao',{||[ ]})
       REPBLO('GRUPOS->circinic',{||[ ]})
       REPBLO('GRUPOS->ultcirc',{||[ ]})
       REPBLO('GRUPOS->qtcircpg',{||0})
       REPBLO('GRUPOS->nrdepend',{||0})
       REPBLO('GRUPOS->situacao',{||[2]})
       REPBLO('GRUPOS->natural',{||[ ]})
       REPBLO('GRUPOS->relig',{||[ ]})
      #else
       PARAMETROS('nrcanc',M->nrcanc+1)
       REPL ARQGRUP->contrat WITH ARQGRUP->contrat - 1
*/
	#ifdef COM_REDE
	 SELE GRUPOS
	 BLOREG(0,.5)
	#endi



       REPL GRUPOS->admissao WITH CTOD([  /  /  ])
			 REPL GRUPOS->cobrador WITH [ ]
       REPL GRUPOS->titular WITH [ ]
       REPL GRUPOS->nome WITH [ ]
       REPL GRUPOS->endereco WITH [ ]
       REPL GRUPOS->bairro WITH [ ]
       REPL GRUPOS->cidade WITH [ ]
       REPL GRUPOS->uf WITH [ ]
       REPL GRUPOS->cep WITH [ ]
       REPL GRUPOS->funerais WITH 0
       REPL GRUPOS->qtcircs WITH 0
       REPL GRUPOS->particv WITH 0
       REPL GRUPOS->particf WITH 0
       REPL GRUPOS->seguro WITH 0
       REPL GRUPOS->nascto_ WITH CTOD('  /  /  ')
       REPL GRUPOS->estcivil WITH [  ]
       REPL GRUPOS->cpf WITH [  ]
       REPL GRUPOS->rg WITH [ ]
       REPL GRUPOS->contato WITH [ ]
       REPL GRUPOS->telefone WITH [ ]
       REPL GRUPOS->tipcont WITH [ ]
       REPL GRUPOS->formapgto WITH [ ]
       REPL GRUPOS->tcarencia WITH CTOD('  /  /  ')
       REPL GRUPOS->saitxa WITH [ ]
       REPL GRUPOS->regiao WITH [ ]
       REPL GRUPOS->qtcircpg WITH 0
       REPL GRUPOS->nrdepend WITH 0
       REPL GRUPOS->circinic WITH [ ]
       REPL GRUPOS->ultcirc WITH [ ]
       REPL GRUPOS->situacao WITH [2]
       REPL GRUPOS->natural WITH [ ]
       REPL GRUPOS->obs WITH [ ]
       REPL GRUPOS->relig WITH [ ]
//      #endi

	#ifdef COM_REDE
	 UNLOCK                                    // libera o registro
	#endi


      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
     EXIT
    ENDD
   ENDI
   SELE CANCELS                                    // volta ao arquivo pai
   chv011=ccodigo
	 #ifdef COM_REDE
		REPBLO('CANCELS->procto_',{||date()})
	 #else
		REPL CANCELS->procto_ WITH date()
	 #endi
	 SKIP                                            // pega proximo registro
	ELSE                                             // se nao atende condicao
	 SKIP                                            // pega proximo registro
	ENDI
 ENDD
 SET(_SET_DELETED,.f.)                             // os excluidos serao vistos
 SELE ECOB                                         // arquivo origem do processamento

 #ifdef COM_REDE
	IF BLOARQ(10,.5)
//   PACK                                            // elimina os registros excluidos
	 UNLOCK                                          // libera o registro
	ENDI
 #else
//  PACK                                             // elimina os registros excluidos
 #endi

 SELE INSCRITS                                     // arquivo origem do processamento

 #ifdef COM_REDE
  IF BLOARQ(10,.5)
//   PACK                                            // elimina os registros excluidos
   UNLOCK                                          // libera o registro
  ENDI
 #else
//  PACK                                             // elimina os registros excluidos
 #endi

 SELE TAXAS                                        // arquivo origem do processamento

 #ifdef COM_REDE
  IF BLOARQ(10,.5)
//   PACK                                            // elimina os registros excluidos
   UNLOCK                                          // libera o registro
  ENDI
 #else
//  PACK                                             // elimina os registros excluidos
 #endi


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
 @ 0,074 SAY TRAN(pg_,'9999')                      // n�mero da p�gina
 IMPAC(nsis,1,000)                                 // t�tulo aplica��o
 @ 1,070 SAY "ADM_R032"                            // c�digo relat�rio
 @ 2,000 SAY "PROC.CANCELAMENTOS"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t�tulo a definir
 IMPAC("N�mero Codigo Grupo Motivo",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R032.PRG
