procedure adp_px07
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADP_PX07.PRG
 \ Data....: 28-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerar carn�s do Grupo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=8, l_i:=15, c_i:=55, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " GERAR DEBITOS DO PERIODO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "    Grupo:"
@ l_s+02,c_s+1 SAY "     Gerar mais    parcelas de"
@ l_s+03,c_s+1 SAY "     para os contratos com �ltimo d�bito"
@ l_s+04,c_s+1 SAY "     vencendo entre                    ."
@ l_s+05,c_s+1 SAY "    1� Parcela vencendo em:"
@ l_s+06,c_s+1 SAY "    Confirma?"
PTAB([],[ARQGRUP],1)
IF LASTREC()=1
 SELE ARQGRUP
 GO TOP
 rgrupo=grup
ELSE
 rgrupo=[  ] //SPAC(2)                                     // Grupo
ENDI
vl_prod=0
parcf=12                                            // Parcf
vlparc=0                                           // Vlparc
rcodigo=SPAC(6)                                    // Codigo
rtipo=[1]                                       // Tipo
rcirc=SPAC(3)                                      // Circular
vini_=DATE()+31-DAY(DATE()+31) //CTOD('')          // Vencimento
vin0_=CTOD('')          // Vencimento
vfim_=vini_+1 //CTOD('')                                     // Vencimento
confirme=SPAC(1)                                   // Confirme?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rgrupo;
									PICT "!!";
									VALI CRIT("PTAB(rgrupo,'ARQGRUP',1)~GRUPO n�o existe na tabela.")
									AJUDA "Informe o grupo"
									CMDF8 "VDBF(6,32,20,77,'ARQGRUP',{'grup','classe','inicio','final','ultcirc','emissao_'},1,'grup',[])"

 @ l_s+02 ,c_s+17 GET  parcf;
									PICT "99";
									VALI CRIT("parcf>0~PARCF n�o aceit�vel")

 @ l_s+02 ,c_s+32 GET  vlparc;
									PICT "99999999.99";
									VALI CRIT("vlparc>0~VLPARC n�o aceit�vel")

 @ l_s+07 ,c_s+26 GET  rcodigo;
									PICT "999999";
									VALI CRIT("PTAB(rcodigo,'GRUPOS',1).AND.GRUPOS->situacao=[1]~Contrato cancelado |ou inexistente");
									WHEN "1=3"
									AJUDA "Informe o n�mero do contrato"
									CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+07 ,c_s+33 GET  rtipo;
									PICT "!";
									VALI CRIT("rtipo $ [123456789]~TIPO n�o aceit�vel");
									WHEN "1=3"
									AJUDA "Qual o tipo de lan�amento"
									CMDF8 "MTAB([1=J�ia |2=Taxa |3=Carn�|6=J�ia+Seguro|7=Taxa+Seguro|8=Carn�+Seguro],[TIPO])"

 @ l_s+07 ,c_s+35 GET  rcirc;
									PICT "999";
									VALI CRIT("!EMPT(rcirc)~Necess�rio informar n�mero de CIRCULAR v�lida");
									WHEN "1=3"
									AJUDA "Informe o n�mero da circular inicial a gerar"

/*
 @ l_s+04 ,c_s+22 GET  vin0_;
									PICT "@D"
									AJUDA "Data do inicial do �ltimo d�bito a considerar"
*/
 @ l_s+04 ,c_s+33 GET  vini_;
									PICT "@D";
									VALI CRIT("!EMPT(vini_)~Necess�rio informar Data v�lida")
									AJUDA "Data do Vencimento do �ltimo d�bito a considerar"

 @ l_s+05 ,c_s+30 GET  vfim_;
									PICT "@D";
									VALI CRIT("vfim_>vini_~Data v�lida a partir de hoje")
									AJUDA "Data do Vencimento da primeira parcela gerada"

 @ l_s+06 ,c_s+15 GET  confirme;
									PICT "!";
									VALI CRIT("confirme=[S]~CONFIRME? n�o aceit�vel|Tecle S para confirmar|ou|ESC para cancelar")
									AJUDA "Digite S para confirmar|ou| Tecle ESC para cancelar"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
	ROLATELA(.f.)
	LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
	RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="GERAR CARNES DO GRUPO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
do_contrat:=do_grupo:=outros_grupos:=0  // Contador de contratos de outros grupos na mesma faixa
IF op_=1
// DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
//	CLOSE GRUPOS
	IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi
 mforma:=0
 PTAB(grupo,"ARQGRUP",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(codigo,"TAXAS",1,.t.)
// SET RELA TO grupo INTO ARQGRUP,;                  // relacionamento dos arquivos
//					TO codigo INTO TAXAS
 criterio:=cpord := ""                             // inicializa variaveis
// chv_rela:=chv_1:=chv_2 := ""
// FILTRA(.T.)

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("TCARNES",.f.,10,1)                    // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TCARNES")                                 // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT

#ifdef COM_REDE
 IF !USEARQ("EMCARNE",.f.,10,1)                    // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("EMCARNE")                                 // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT
 SELE ARQGRUP
 PTAB(M->rgrupo,[ARQGRUP],1)
 M->rcodini = ARQGRUP->inicio
 M->rcodfim = ARQGRUP->final
 PTAB([],[GRUPOS],1)
 ptab([],[INSCRITS],1)
 SELE GRUPOS                                       // processamentos apos emissao
// cr_i=criterio+cpord    // se tem alteracao, liga
// FILTRA(.T.)
// DBOX(CRITERIO+[|]+GRUPOS->CODIGO)

 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()
 GO TOP
 DO WHIL !EOF().and.odometer()

	 #ifdef COM_TUTOR
		IF IN_KEY()=K_ESC                              // se quer cancelar
	 #else
		IF INKEY()=K_ESC                               // se quer cancelar
	 #endi
		IF canc()                                      // pede confirmacao
		 GO BOTT
		 SKIP
		 LOOP
    ENDI
   ENDI

	@ l_s+07 ,c_s+02 SAY [Procurando contrato]

	IF !(GRUPOS->situacao=[1]) //Contrato cancelado cai fora...
	 SKIP
	 LOOP
	ENDI
	IF codigo < M->rcodini   // Se for menor que o c�digo inicial do grupo
	 SKIP                    // Sai fora...
	 LOOP
	ENDI
	IF codigo > M->rcodfim   // Se for maior que o �ltimo c�digo cadastrado
	 GO BOTT                 // na tabela de Grupos, sai fora...
	 SKIP
	 LOOP
	ENDI

	M->rcodigo = codigo
	M->rtipo   = [3]                                       // Tipo
	M->rcirc   = '000'

	// Apresenta na tela
	@ l_s+07 ,c_s+26 SAY  rcodigo
	@ l_s+07 ,c_s+33 SAY  rtipo
	@ l_s+07 ,c_s+35 SAY  rcirc

  IF !(grupo = M->rgrupo)
   outros_grupos++
//	 @ l_s+08,c_s+02 SAY [Outro grupo]
   SKIP
   LOOP
  ENDI

	M->ultvct_:=CTOD([  /  /  ]) //M->vini_ // Inicialmente, todos terao...
	M->rcirc :=[000]
  IF (GRUPOS->saitxa=[9999]) // Contrato remido...
//    @ l_s+08,c_s+02 SAY [Remido]
    //  Contrato remido...
    SKIP
    LOOP
  ENDI

  IF !EMPT(GRUPOS->saitxa).AND.CTOD('01/'+TRAN(GRUPOS->saitxa,"@R 99/99")) > vfim_
    // SaiTxas > 1�Emissao
//    @ l_s+08,c_s+02 SAY [Saitxa>emissao]
    SKIP
    LOOP
  ENDI

  M->temtxa:=PTAB(M->rcodigo,[TAXAS],1)

  IF !EMPT(M->vin0_).AND.!temtxa  // Se n�o houver taxas cadastradas...
/*
** Se for solicitado a geracao dos debitos para ultimas parcelas em um
** periodo limitado (ultimo vencimento entre... e...), nao serao geradas
** parcelas para contratos sem debitos.
*/
    SKIP
    LOOP
	ENDI

  IF temtxa
	 SELE TAXAS
	 @ l_s+07,c_s+02 SAY [Procurando ult.circ]
	 DO WHILE !EOF() .AND. codigo= M->rcodigo  // Vamos procurar a �ltima circular
    IF tipo=[3].AND.circ>M->rcirc
	   M->rcirc = circ
	   M->ultvct_ = emissao_
    ENDI
	  SKIP
	 ENDD
  ENDI

	SELE GRUPOS
	IF M->ultvct_ > M->vini_   // Se a ultima circular for maior que a
//   @ l_s+08,c_s+02 SAY [Vcto>vini]
	 SKIP                      // data solicitada, proximo contrato...
	 LOOP
	ENDI

	IF !EMPT(M->vin0_).AND.(M->ultvct_ < M->vin0_)// Se a ultima circular for maior que a
//   @ l_s+08,c_s+02 SAY [Vcto<vini]
	 SKIP                      // data solicitada, proximo contrato...
	 LOOP
	ENDI

  PTAB(tipcont,[CLASSES])
	M->rcirc=STRZERO(VAL(M->rcirc)+1,3)  // Calcula o proximo numero.

  IF EMPT(ultvct_)
   dtproxvcto:=P00801F9(M->vfim_,1)
  ELSE
   dtproxvcto=P00801F9(ultvct_,1+val(formapgto))  // PROXIMO VENCTO
  ENDI

  ultdiavfim=vfim_ - day(vfim_)+35         // Ultimo dia do mes da 1� parcela
  ultdiavfim=ultdiavfim-day(ultdiavfim)  // a gerar
  vctosaitxa:=P00801F9(CTOD('01/'+TRAN(GRUPOS->saitxa,"@R 99/99")),1)

/*
  DBOX([CODIGO]+CODIGO+[ ULTVCTO ]+DTOC(ULTVCT_)+[|DTPROXVCTO ]+DTOC(DTPROXVCTO)+;
       [|ULTDIAVFIM ]+DTOC(ULTDIAVFIM)+[|Vctosaitxa ]+dtoc(vctosaitxa))
*/

/*
  if M->dtproxvcto > ultdiavfim   // Se o proximo for depois, tchau !
   skip
   loop
  endi
*/

  ultvct_ := IIF(dtproxvcto<vctosaitxa,vctosaitxa,dtproxvcto)
	     // proxima 1� parcela... ou saitxas...

	@ l_s+07 ,c_s+02 SAY [Gerando d�bitos    ]

   do_grupo++     // contador de contratos c/taxas geradas.

  mforma:=MAX(VAL(GRUPOS->formapgto),1)
	FOR nparc=1 TO (parcf/mforma)
	 SELE TAXAS                                      // arquivo alvo do lancamento

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
   nr_depend:=IIF(CLASSES->vldepend>0,qtnrdepX(codigo,[8]),0)
   do_contrat++     // contador de taxas geradas.
	 vl_prod=CAL_VLPROD()
	 //DBOX(str(M->vlparc)+[|]+str(CLASSES->vlmensal
	 //DBOX(codigo+[|]+str(vl_prod)+[|]+str((M->vlparc+CLASSES->vlmensal+(nr_depend*CLASSES->vldepend))*M->mforma))
	 REPL TAXAS->codigo WITH codigo,;
				TAXAS->tipo WITH rtipo,;
				TAXAS->circ WITH RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3),;
				TAXAS->emissao_ WITH P00801F9(ultvct_,(nparc-1)*M->mforma+1),;
				TAXAS->valor WITH (M->vlparc+;
 CLASSES->vlmensal+(nr_depend*CLASSES->vldepend)+vl_prod)*M->mforma
   REPL TAXAS->stat with [1],;
				TAXAS->cobrador WITH cobrador,;
	TAXAS->codlan WITH [PP]+dtos(date())+left(time(),2)+;
	     substr(time(),4,2)+M->usuario

	// Apresenta na tela
	@ l_s+07 ,c_s+35 SAY  TAXAS->circ

		SELE GRUPOS                                    // arquivo origem do processamento
    RLOCK()
    IF circinic<'001'
		 REPL GRUPOS->circinic WITH TAXAS->circ
		ENDI
		REPL GRUPOS->ultcirc WITH TAXAS->circ
    REPL GRUPOS->qtcircs WITH GRUPOS->qtcircs + 1

	 #ifdef COM_REDE
		TAXAS->(DBUNLOCK())                            // libera o registro
	 #endi

	NEXT

	@ l_s+07 ,c_s+02 SAY [                   ]

	SKIP                                             // pega proximo registro
 ENDD
 SELE GRUPOS                                       // salta pagina
 SET RELA TO                                       // retira os relacionamentos
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)

 msgt="GERAR CARNES DO GRUPO"
 IF !EMPT(outros_grupos)
  msgt+=[|Atencao ]+M->usuario+[|Existem ]+ALLTRIM(STR(outros_grupos))+;
        [ contratos de outros grupos|dentro da faixa ]+M->rcodini+[...]+M->rcodfim
 ENDI
 DBOX("Processo terminado com sucesso!|"+;
      str(do_contrat)+[ Parcelas geradas|para ]+;
      ALLTRIM(str(do_grupo))+[ contratos.],,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de ADP_PX07.PRG
FUNC QTNRDEPX
PARA mcod,mtip
LOCAL ct_tx:=0

SELE INSCRITS
seek mcod

DO WHILE !EOF() .AND. INSCRITS->codigo=Mcod //.AND.ct_tx < M->rpend
 IF INSCRITS->grau $ mtip
	ct_tx++
 ENDI
 SKIP
ENDDO

SELE GRUPOS
RETU ct_tx       // <- deve retornar um valor L�GICO

//Funcao que calcula os valores dos beneficios (cadastrados nas CLASSES)
//usando o campo GRUPOS->RELIG
FUNC CAL_VLPROD()
 SELE GRUPOS
 _relig=RELIG	//04,06,07
 IF RIGHT(_relig,1) != [,]
  _relig+=[,]	//04,06,07,
 ENDI
 _classe=[]
 _vlprod=0
 SELE CLASSES
 DO WHILE !EMPT(_relig)
  _classe=ALLTRIM(LEFT(_relig,AT(",",_relig)-1)) //04	//Verifica o carne (produto)
  IF EMPT(_classe)
   _relig=[]
   LOOP
  ENDI
  SEEK _classe
  _vlprod+=VLMENSAL
  _relig=SUBSTR(_relig,AT(",",_relig)+1) //06,07,
 ENDD
 SEEK GRUPOS->tipcont
 SELE GRUPOS
RETU _vlprod
