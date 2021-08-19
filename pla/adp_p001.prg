procedure adp_p001
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_P001.PRG
 \ Data....: 26-04-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: D‚bitos do mˆs
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=18, l_i:=20, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
PRIV dataux, diaaux,contx,ultprc:=[]
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " GRUPOS C/TAXAS A EMITIR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "  Utilize esta rotina para gerar o valor"
@ l_s+02,c_s+1 SAY "  da manuten‡„o de cada um dos contratos"
@ l_s+03,c_s+1 SAY " do grupo desejado (Rateio ou peri¢dico)."
@ l_s+04,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+05,c_s+1 SAY " Emiss„o:"
@ l_s+06,c_s+1 SAY " Grupo..:      De:       -"
@ l_s+07,c_s+1 SAY " £ltima Circular.:"
@ l_s+08,c_s+1 SAY " Pr¢xima Circular:"
@ l_s+10,c_s+1 SAY "    Confirme:"
remissao_=CTOD('')                                 // Emiss„o
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
rvlaux=0                                           // Valor
rnraux=0                                           // Nr.Auxiliar
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+05 ,c_s+11 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_)~Informe uma data v lida p/ EMISSŽO | data de hoje ou posterior.")
                  DEFAULT "CTOD('05'+SUBSTR(DTOC(DATE()+30),3))"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

 @ l_s+06 ,c_s+11 GET  rgrupo;
                  PICT "!!";
                  VALI CRIT("(PTAB(rgrupo,'ARQGRUP',1).AND.PTAB(ARQGRUP->classe,'CLASSES',1)).or.EMPT(rgrupo)~GRUPO n„o existe na tabela|ou|Categoria do grupo n„o cadastrada")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                  MOSTRA {"IIF(!EMPT(rgrupo),LEFT(TRAN(ARQGRUP->inicio,[999999]),06),[])", 6 , 20 }
                  MOSTRA {"IIF(!EMPT(rgrupo),LEFT(TRAN(ARQGRUP->final,[999999]),06),[])", 6 , 27 }
                  MOSTRA {"IIF(!EMPT(rgrupo),LEFT(TRAN(ARQGRUP->ultcirc,[999]),03),[])", 7 , 20 }
                  MOSTRA {"IIF(!EMPT(rgrupo),LEFT(TRAN(ARQGRUP->emissao_,[@D]),10),[])", 7 , 24 }
                  MOSTRA {"IIF(!EMPT(rgrupo),LEFT(TRAN(IIF(CLASSES->prior=[S],[Valor por mˆs......:],IIF(ARQGRUP->maxproc>ARQGRUP->acumproc,[Valor p/atendimento:],[Valor da circular.:])),[]),20),[])", 9 , 2 }
                  MOSTRA {"IIF(EMPT(rgrupo),LEFT(TRAN([Valor da circular.:],[]),20),[])", 9 , 2 }


 @ l_s+08 ,c_s+20 GET  rproxcirc;
                  PICT "999";
                  VALI CRIT("nivelop=3.OR.(rproxcirc<[001].OR.rproxcirc>=ARQGRUP->ultcirc)~A Pr¢xima circular deve ser maior|ou igual a £ltima emitida");
                  WHEN "!EMPT(rgrupo)"
                  AJUDA "Entre com o n£mero da pr¢xima circular"
                  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+09 ,c_s+22 GET  rvlaux;
                  PICT "@E 999,999.99";
                  VALI CRIT("!(rvlaux<0)~VALOR n„o aceit vel");
                  WHEN "v87001f9()"

 @ l_s+09 ,c_s+33 GET  rnraux;
                  PICT "99";
									WHEN "1=3"
                  AJUDA "Este campo ‚ utilizado para controle do sistema"

 @ l_s+10 ,c_s+15 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'.AND.V03001F9()~CONFIRME n„o aceit vel")
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
 EXIT
ENDD
cod_sos=1
msgt="DBITOS DO MES"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
	CLOSE ARQGRUP
	IF !USEARQ("ARQGRUP",.F.,10,1)                   // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("ARQGRUP")                                // abre o dbf e seus indices
 #endi
 PTAB(classe,"CLASSES",1,.t.)                      // abre arquivo p/ o relacionamento
 SET RELA TO classe INTO CLASSES                   // relacionamento dos arquivos
 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

 #ifdef COM_REDE
	IF !USEARQ("PRCESSOS",.F.,10,1)                  // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("PRCESSOS")                               // abre o dbf e seus indices
 #endi

 cpord="grup+DTOS(dfal)"
 INDTMP()

#ifdef COM_REDE
 IF !USEARQ("CIRCULAR",.F.,10,1)                   // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CIRCULAR")                                // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("CPRCIRC",.F.,10,1)                    // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

 SELE ARQGRUP                                      // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  IF (grup=M->rgrupo).OR.(EMPT(M->rgrupo).AND.proxcirc>[000])                                // se atender a condicao...
   IF EMPT(M->rgrupo)
    rproxcirc:=proxcirc
   ENDI
   IF !PTAB(grup+rproxcirc,[CIRCULAR],1)
    SELE CIRCULAR                                  // arquivo alvo do lancamento
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
    SELE ARQGRUP                                   // inicializa registro em branco
    REPL CIRCULAR->grupo WITH M->rgrupo,;
	       CIRCULAR->circ WITH M->rproxcirc,;
	       CIRCULAR->emissao_ WITH M->remissao_,;
	       CIRCULAR->valor WITH M->rvlaux

    #ifdef COM_REDE
    CIRCULAR->(DBUNLOCK())                        // libera o registro
    #endi
   ELSE
    M->remissao_:=CIRCULAR->emissao_
    M->rvlaux:=CIRCULAR->valor
   ENDI
   REPBLO('ARQGRUP->ultcirc',{||M->rproxcirc})
   REPBLO('ARQGRUP->emissao_',{||M->remissao_})

   chv044=grup
   SELE PRCESSOS
   SEEK chv044
   IF FOUND()
    DO WHIL ! EOF() .AND. chv044=grup //LEFT(&(INDEXKEY(0)),LEN(chv044))
     IF !(CLASSES->prior=[S]).AND.(saiu<[001].OR.saiu=M->rproxcirc)// se atender a condicao...
      IF CIRCULAR->procpend<ARQGRUP->maxproc
       SELE CPRCIRC                                // arquivo alvo do lancamento

	 #ifdef COM_REDE
				DO WHIL .t.
				 APPE BLAN                                 // tenta abri-lo
				 IF NETERR()                               // nao conseguiu
					DBOX(ms_uso,20)                          // avisa e
					LOOP                                     // tenta novamente
				 ENDI
				 EXIT                                      // ok. registro criado
				ENDD
			 #else
				APPE BLAN                                  // cria registro em branco
			 #endi

			 SELE PRCESSOS                               // inicializa registro em branco
			 REPL CPRCIRC->grupo WITH ARQGRUP->grup,;
						CPRCIRC->circ WITH M->rproxcirc,;
						CPRCIRC->processo WITH processo,;
						CPRCIRC->categ WITH categ,;
						CPRCIRC->num WITH num,;
						CPRCIRC->fal WITH fal,;
						CPRCIRC->ends WITH ends,;
						CPRCIRC->cids WITH cids,;
						CPRCIRC->dfal WITH dfal
			 SELE CPRCIRC                                // arquivo alvo do lancamento
			 CPR_GET1(FORM_DIRETA)                       // faz processo do arq do lancamento

			 #ifdef COM_REDE
				UNLOCK                                     // libera o registro
			 #endi

			 SELE PRCESSOS                               // arquivo origem do processamento
       RLOCK()
       REPL saiu WITH M->rproxcirc
			ENDI
			SKIP                                         // pega proximo registro
		 ELSE                                          // se nao atende condicao
			SKIP                                         // pega proximo registro
		 ENDI
		ENDD

	 ENDI
	 SELE ARQGRUP                                    // volta ao arquivo pai
	 SKIP                                            // pega proximo registro
	ELSE                                             // se nao atende condicao
	 SKIP                                            // pega proximo registro
	ENDI
 ENDD
 SELE ARQGRUP                                      // salta pagina
 SET RELA TO                                       // retira os relacionamentos

 #ifdef COM_REDE
	IF !USEARQ("GRUPOS",.F.,10,1)                    // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(tipcont,"CLASSES",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(grupo,"ARQGRUP",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 SET RELA TO tipcont INTO CLASSES,;                // relacionamento dos arquivos
					TO grupo INTO ARQGRUP,;
					TO cobrador INTO COBRADOR
 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.F.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

 SELE GRUPOS                                       // processamentos apos emissao

 go top
 skip -1
 odometer(reccount(),18,15)

 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 GO TOP
 DO WHIL !EOF()
//  @ 5,15 say [ >>> ]+codigo + [ <<<]
  odometer()

  IF !EMPT(M->rgrupo)
   IF !(GRUPOS->grupo=M->rgrupo) // se atender a condicao...
    SKIP
    LOOP
   ENDI
  ELSE
   IF ARQGRUP->proxcirc<[001] // se atender a condicao...
    SKIP
    LOOP
   ENDI
   rproxcirc:=ARQGRUP->proxcirc
  ENDI
  IF !PTAB(ARQGRUP->grup+rproxcirc,[CIRCULAR],1)
   SKIP
   LOOP
  ENDI
  M->remissao_:=CIRCULAR->emissao_
  M->rvlaux:=CIRCULAR->valor
//  @ 6,15 say [ >>.> ]+codigo + [ <.<<]

	IF EMPT(rv4401f9())                              // se atender a condicao...

// Rotina incluida para corrigir os vencimentos em datas invalidas (30/02)

	 diaaux:=DTOC(M->remissao_)
	 IF GRUPOS->diapgto>[00]
	  diaaux:=GRUPOS->diapgto+substr(DTOC(M->remissao_),3)
	 ENDI
	 dataux:=CTOD(M->diaaux)
	 DO WHILE EMPT(M->dataux)
	  diaaux:=STR(VAL(LEFT(diaaux,2))-1,2)+SUBSTR(diaaux,3)
	  dataux:=CTOD(M->diaaux)
	 ENDD

   SELE TAXAS
   SEEK GRUPOS->codigo+IIF(CLASSES->prior=[S],[3],[2])+M->rproxcirc

   SELE GRUPOS
   IF TAXAS->valorpg>0
    SKIP
    LOOP
   ENDI
   val_txaux:=VAL_01F9()
   IF val_txaux>0
    IF TAXAS->(EOF())
	   SELE TAXAS                                     // arquivo alvo do lancamento

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

		 SELE GRUPOS                                    // inicializa registro em branco
		 REPL TAXAS->codigo WITH codigo,;
				 TAXAS->tipo WITH IIF(CLASSES->prior=[S],[3],[2]),;
				 TAXAS->circ WITH M->rproxcirc

		 REPL TAXAS->emissao_ WITH M->dataux,;
				 TAXAS->valor WITH val_txaux,;
				 TAXAS->cobrador WITH cobrador,;
				 TAXAS->stat WITH '1',;
         TAXAS->codlan WITH [PM]+dtos(date())+left(time(),2)+;
             substr(time(),4,2)+M->usuario

		 SELE TAXAS                                     // arquivo alvo do lancamento
//		TAX_GET1(FORM_DIRETA)                          // faz processo do arq do lancamento

		 #ifdef COM_REDE
		  UNLOCK                                        // libera o registro
		 #endi

		 SELE GRUPOS                                    // arquivo origem do processamento
     RLOCK()
     IF circinic<'001'
      REPL GRUPOS->circinic WITH M->rproxcirc
     ENDI
     REPL GRUPOS->ultcirc WITH M->rproxcirc
     REPL GRUPOS->qtcircs WITH GRUPOS->qtcircs + 1
	  ELSE
     SELE GRUPOS
	  #ifdef COM_REDE
     SELE TAXAS
     RLOCK()
     SELE GRUPOS
	   REPL TAXAS->emissao_ WITH M->dataux,;
				 TAXAS->valor WITH val_txaux,;
				 TAXAS->cobrador WITH cobrador,;
				 TAXAS->stat WITH '1'

     SELE GRUPOS
     RLOCK()
     IF circinic<'001'
      REPL GRUPOS->circinic WITH M->rproxcirc
     ENDI
     REPL GRUPOS->ultcirc WITH M->rproxcirc
     SELE GRUPOS
	  #else
		 REPL TAXAS->emissao_ WITH M->dataux
		 REPL TAXAS->valor WITH val_txaux
		 REPL TAXAS->cobrador WITH cobrador
		 REPL TAXAS->stat WITH [1]
     IF circinic<'001'
      REPL GRUPOS->circinic WITH M->rproxcirc
     ENDI
     REPL GRUPOS->ultcirc WITH M->rproxcirc
    #endi

    ENDI
   ENDI
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 SELE GRUPOS                                       // salta pagina
 SET RELA TO                                       // retira os relacionamentos
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de ADP_P001.PRG
