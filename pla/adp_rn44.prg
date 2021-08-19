procedure adp_rn44
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: ADP_RP44.PRG
 \ Data....: 24-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Modelo p/Per�odo
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL,l_s:=4, c_s:=16, l_i:=21, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+15 SAY " IMPRESS�O DE COBRAN�A "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran�a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       �ltima:             )"
 @ l_s+04,c_s+1 SAY " Circulares a emitir: N�      at�"
 @ l_s+05,c_s+1 SAY " Cobran�as com data entre:          e"
 @ l_s+06,c_s+1 SAY " e n� de contrato entre:        e"
 @ l_s+08,c_s+1 SAY "         Reimprimir taxas j� impressas?"
 @ l_s+09,c_s+1 SAY "     Acumular valor das cobran�as vencidas?"
 @ l_s+10,c_s+1 SAY "         Tipo das taxas a acumular :"
 @ l_s+12,c_s+1 SAY "     Imprimir do recibo n�      at� o n�"
 @ l_s+13,c_s+1 SAY " Parcela �nica:         "
 @ l_s+14,c_s+1 SAY " Mens1: "
 @ l_s+15,c_s+1 SAY " Mens2: "
 @ l_s+16,c_s+1 SAY "                   Confirme:"
ENDI
rtp=SPAC(1)                                        // Tipo
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
IF !so_um_reg                             // vai receber a variaveis?
 rcod1=SPAC(6)                                      // Contrato
 rcod2=SPAC(6)                                      // Contrato
 rtodas=[N]
endi
rreimp=SPAC(1)                                     // Reimprimir?
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rpagin=1                                           // Pag.inicial
rpagfim=9999                                          // Pag.final
rval1:=0
ultcod:=[ ]
rmen1:=rmen2:=space(30)
confirme=SPAC(1)                                   // Confirme
IF FILE('PR044VAR.MEM')
 REST FROM PR044VAR ADDITIVE
ENDI
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+20 GET  rtp;
                   PICT "9"
                   DEFAULT "[3]"
                   AJUDA "Qual o tipo de cobran�a a imprimir neste impresso."
                   CMDF8 "MTAB([1=J�ia |2=Taxa |3=Carn�],[TIPO])"

  @ l_s+02 ,c_s+09 GET  rgrupo;
                   PICT "!!";
                   VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(rgrupo)~GRUPO n�o existe na tabela")
                   AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                   CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                   MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 14 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 21 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 36 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 40 }

  @ l_s+04 ,c_s+26 GET  rproxcirc;
                   PICT "999";
                   VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.1=1~A Pr�xima circular deve estar|lan�ada em Tabela/Circulares")
                   DEFAULT "ARQGRUP->proxcirc"
                   AJUDA "Entre com o n�mero da pr�xima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+04 ,c_s+35 GET  rultcirc;
                   PICT "999"
                   AJUDA "Entre com o n�mero da ultima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

	@ l_s+05 ,c_s+28 GET  rem1_;
                   PICT "@D";
                   VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v�lida.")
                   DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                   AJUDA "Data da Emiss�o da Circular.| Informe a data a considerar como inicial na emiss�o."

  @ l_s+05 ,c_s+39 GET  rem2_;
                   PICT "@D";
                   VALI CRIT("!EMPT(Rem2_)~Informe uma data v�lida, deve ser posterior|a inicial")
                   DEFAULT "(DATE()+31)-DAY(DATE()+31)"
		   AJUDA "Imprimir a cobran�a lan�ada at� que data."

  @ l_s+06 ,c_s+26 GET  rcod1;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n�o aceit�vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n�mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+06 ,c_s+35 GET  rcod2;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n�o aceit�vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n�mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+08 ,c_s+41 GET  rreimp;
                   PICT "!";
                   VALI CRIT("rreimp$[SN ]~Necess�rio informar REIMPRIMIR?|Digite S ou N")
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todos os documentos|mesmo os que j� foram impressos anteriormente."

  @ l_s+09 ,c_s+45 GET  racum;
                   PICT "!";
                   VALI CRIT("racum$[SN ]~ACUMULAR? n�o aceit�vel|Digite S ou N")
                   DEFAULT "[ ]"
                   AJUDA "Digite S para acumular o valor|das cobran�as n�o pagas neste documento."

  @ l_s+10 ,c_s+38 GET  rtipo;
                   PICT "!!!";
                   VALI CRIT("!EMPT(rtipo)~Necess�rio informar TIPOS A IMPRIMIR");
                   WHEN "racum='S'"
                   DEFAULT "[123]"
                   AJUDA "Digite 1 para J�ia, 2 para cobran�as e 3 p/Periodo"
                   CMDF8 "MTAB([111-J�ia|222-p/Processos|333-Peri�dico|122-J�ia+Processos|133-J�ia+Per�odico|233-Processos+Peri�dicos|123-Todos],[TIPOS A IMPRIMIR])"

  @ l_s+12 ,c_s+28 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n�mero do primeiro recibo a imprimir."

	@ l_s+12 ,c_s+42 GET  rpagfim;
									 PICT "9999"
									 AJUDA "Informe o n�mero do �ltimo recibo a imprimir."

	@ l_s+04 ,c_s+30 GET  rval1;
									 PICT "@E 999,999.99"
									 AJUDA "Entre com o valor da parcela �nica"

	@ l_s+05 ,c_s+10 GET  rmen1;
									 when rval1>0
									 AJUDA "Entre com a primeira mensagem da parcela �nica"

	@ l_s+06 ,c_s+10 GET  rmen2;
									 when rval1>0
									 AJUDA "Entre com a segunda mensagem da parcela �nica"

	@ l_s+13 ,c_s+30 GET  confirme;
		   PICT "!";
                   VALI CRIT("confirme='S'.AND.V87001F9()~CONFIRME n�o aceit�vel")
                   AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"

  READ
  SET KEY K_ALT_F8 TO
  IF rola_t
   ROLATELA(.f.)
   LOOP
  ENDI
  IF LASTKEY()=K_ESC                               // se quer cancelar
   RETU                                            // retorna
  ENDI
 ENDI

 #ifdef COM_REDE
  IF !USEARQ("TAXAS",.F.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
// PTAB(codigo,"EMCARNE",2,.t.)
// PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
		TO GRUPOS->tipcont INTO CLASSES,;
		TO cobrador INTO COBRADOR,;
		TO GRUPOS->grupo+circ INTO CIRCULAR,;
		TO codigo+tipo+circ INTO CSTSEG  //,;
//		TO codigo INTO EMCARNE,;
//	  TO EMCARNE->tip INTO TCARNES

 titrel:=criterio := ""                            // inicializa variaveis
 cpord=""
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
	IF !opcoes_rel(lin_menu,col_menu,39,11)          // nao quis configurar...
   CLOS ALL                                        // fecha arquivos e
   LOOP                                            // volta ao menu
  ENDI

 #ifdef COM_REDE

  ELSE

   tps=lin_menu

 #endi

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
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura��o do tamanho da p�gina!"         // foi informado errado
	DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_022=LEFT(drvtapg,op_-1)+"018"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_022:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
SAVE TO PR044VAR ALL LIKE R*
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=14                                           // maximo de linhas no relatorio
IMPCTL(lpp_022)                                    // seta pagina com 22 linhas
SET MARG TO 3                                      // ajusta a margem esquerda
IMPCTL(drvpcom)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
  IF so_um_reg
   GO imp_reg
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.(!so_um_reg.OR.(M->rcod1<=TAXAS->codigo.AND.M->rcod2>=TAXAS->codigo))
   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
		IF INKEY()=K_ESC                               // se quer cancelar
	 #endi
		IF canc()                                      // pede confirmacao
		 BREAK                                         // confirmou...
		ENDI
	 ENDI
	 IF (R08701F9()) .OR. so_um_reg                  // se atender a condicao...
		IF so_um_reg.AND. valorpg>0
			SKIP
			LOOP
		ELSE
		 IF (pg_<M->rpagin .OR.pg_>M->rpagfim)
			pg_++
			SKIP
			LOOP
		 ENDI
		ENDI
		valororig=R08702F9()                           // variavel temporaria
		 IF TAXAS->codigo != ultcod.and.TAXAS->tipo=[3].AND.M->rval1>0
			ultcod:=TAXAS->codigo
			PRC_UNIC()
		 ENDI

		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,009 SAY LEFT(GRUPOS->nome,27)                       // Nome
		 @ cl,049 SAY LEFT(GRUPOS->nome,27)                       // Nome
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,003 SAY GRUPOS->endereco                   // Endere�o
		 @ cl,043 SAY LEFT(GRUPOS->endereco,33)                   // Endere�o
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,003 SAY GRUPOS->bairro                     // Endere�o
		 @ cl,043 SAY GRUPOS->bairro                     // Endere�o
		 REL_CAB(3)                                      // soma cl/imprime cabecalho
		 @ cl,002 SAY TRAN(TAXAS->codigo,"999999")              // Codigo
		 @ cl,010 SAY TRAN(TAXAS->tipo,"!")                     // Tipo
		 @ cl,011 SAY TRAN(TAXAS->circ,"999")                   // Circular
		 @ cl,015 SAY TRAN(TAXAS->emissao_,"@D")                // Emissao
		 @ cl,025 SAY TRAN(TAXAS->valor,"@E 999,999.99")        // Valor
		 @ cl,042 SAY TRAN(TAXAS->codigo,"999999")              // Codigo
		 @ cl,050 SAY TRAN(TAXAS->tipo,"!")                     // Tipo
		 @ cl,051 SAY TRAN(TAXAS->circ,"999")                   // Circular
		 @ cl,055 SAY TRAN(TAXAS->emissao_,"@D")                // Emissao
		 @ cl,065 SAY TRAN(TAXAS->valor,"@E 999,999.99")        // Valor
		 REL_CAB(2)                                      // soma cl/imprime cabecalho
		 @ cl,063 SAY ""        // Valor
		 IF M->combarra=[S]
			CODBARRAS({{codigo+tipo+circ,4,10,64}},10,6)
		 ENDI
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,030 SAY TRAN(TAXAS->tipo,"!")                     // Tipo
		 @ cl,031 SAY TRAN(TAXAS->circ,"999")                   // Circular
		 @ cl,063 SAY ""        // Valor
		 IF M->combarra=[S]
			CODBARRAS({{codigo+tipo+circ,4,10,64}},10,6)
		 ENDI

	 #ifdef COM_REDE
		IF stat < [2]
		 rlock()
		 REPL TAXAS->stat WITH [2]
//     REPBLO('TAXAS->stat',{||[2]})
		ENDI

	 #else
		IF stat < [2]
		 REPL TAXAS->stat WITH [2]
		ENDI
	 #endi


		 SKIP                                            // pega proximo registro
		 cl=999                                          // forca salto de pagina

	 ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcom)                                    // retira comprimido
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(39)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R066.PRG
FUNC PRC_UNIC

	 REL_CAB(1)                                      // soma cl/imprime cabecalho
	 @ cl,009 SAY LEFT(GRUPOS->nome,27)                       // Nome
	 @ cl,049 SAY LEFT(GRUPOS->nome,27)                       // Nome
	 REL_CAB(1)                                      // soma cl/imprime cabecalho
	 @ cl,003 SAY M->rmen1                   // Endere�o
	 @ cl,043 SAY M->rmen1                   // Endere�o
	 REL_CAB(1)                                      // soma cl/imprime cabecalho
	 @ cl,003 SAY M->rmen2                     // Endere�o
	 @ cl,043 SAY M->rmen2                     // Endere�o
	 REL_CAB(3)                                      // soma cl/imprime cabecalho
	 @ cl,002 SAY TRAN(GRUPOS->codigo,"999999")              // Codigo
	 @ cl,009 SAY [UNICA]                   // Circular
	 @ cl,015 SAY TRAN(TAXAS->emissao_,"@D")                // Emissao
	 @ cl,025 SAY TRAN(M->rval1,"@E 999,999.99")        // Valor
	 @ cl,042 SAY TRAN(TAXAS->codigo,"999999")              // Codigo
	 @ cl,049 SAY [UNICA]
	 @ cl,055 SAY TRAN(TAXAS->emissao_,"@D")                // Emissao
	 @ cl,065 SAY TRAN(M->rval1,"@E 999,999.99")        // Valor
	 REL_CAB(2)                                      // soma cl/imprime cabecalho
	 @ cl,063 SAY ""        //
	 IF M->combarra=[S]
		CODBARRAS({{codigo+[9]+TAXAS->circ,4,10,64}},10,6)
	 ENDI
	 REL_CAB(1)                                      // soma cl/imprime cabecalho
	 @ cl,030 SAY TRAN([9],"!")                     // Tipo
	 @ cl,031 SAY TRAN(TAXAS->circ,"999")                   // Circular
	 @ cl,063 SAY ""        //
	 IF M->combarra=[S]
		CODBARRAS({{codigo+[9]+TAXAS->circ,4,10,64}},10,6)
	 ENDI
	 cl=999

RETURN .T.

* \\ Final de ADP_RP44.PRG
