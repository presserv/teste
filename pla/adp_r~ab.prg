procedure adp_r~ab
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: ADP_R066.PRG
 \ Data....: 18-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Carnˆs Ossel
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg, mcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=19, l_i:=17, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
V87001F9()  // Monta variaveis publicas...
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+11 SAY " IMPRESSŽO DE COBRAN€A "
 SETCOLOR(drvcortel)
 @ l_s+02,c_s+1 SAY " IMPRIMIR os carnˆs JA' impressos:"
 @ l_s+04,c_s+1 SAY " Inscri‡„o de:         at‚ :"
 @ l_s+06,c_s+1 SAY "                   Confirme:"
ENDI
rtodas=[ ]                             // Todas?
IF !so_um_reg                             // vai receber a variaveis?
 rtp=SPAC(1)                                        // Tipo
 rcod1=SPAC(6)                                      // Contrato
 rcod2=SPAC(6)                                      // Contrato
 rtodas=[N]
 mcodaux:=[]
ELSEIF PCOU()=3
 mcodaux:=codigo+tipo+circ
ELSEIF PCOU()=4
 rcod1:=rcod2:=mcodaux
ENDI
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+02 ,c_s+36 GET  rtodas;
                   PICT "!"
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todas as vendas|que ainda n„o tenham sido impressas."

  @ l_s+04 ,c_s+16 GET  rcod1;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n£mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+04 ,c_s+30 GET  rcod2;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
									 DEFAULT "rcod1"
                   AJUDA "Entre com o n£mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+06 ,c_s+30 GET  confirme;
                   PICT "!";
                   VALI CRIT("confirme='S'.AND.V87001F9()~CONFIRME n„o aceit vel")
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
  IF !USEARQ("EMCARNE",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("EMCARNE")                                // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(codigo,"TAXAS",1,.t.)
 PTAB(tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
					TO tip INTO TCARNES
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,10,11)          // nao quis configurar...
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
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_018=LEFT(drvtapg,op_-1)+"018"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_018:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=14                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
IMPCTL(lpp_018)                                    // seta pagina com 18 linhas
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
ultcod=[000000]
ultcir=[000]
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   PTAB(M->mcodaux,[EMCARNE],2,.t.)
  ELSE
	 INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF M->rcod1>[000000]
    PTAB(M->rcod1,[EMCARNE],2,.t.)
   ENDI
	ENDI


	ccop++                                           // incrementa contador de copias
	DO WHIL !EOF().AND.(!so_um_reg.OR.(M->mcodaux=codigo))
	 #ifdef COM_TUTOR
		IF IN_KEY()=K_ESC                              // se quer cancelar
	 #else
		IF INKEY()=K_ESC                               // se quer cancelar
	 #endi
		IF canc()                                      // pede confirmacao
		 BREAK                                         // confirmou...
		ENDI
	 ENDI
   IF M->rcod2>[000000].AND.codigo>M->rcod2
    GO BOTT
    SKIP
    LOOP
   ENDI
   IF M->rtodas=[N].AND.!EMPT(EMCARNE->emissao_)
    SKIP
    LOOP
   ENDI
   IF codigo+tip=ultcod
    skip
    loop
   ENDI
   ultcod=codigo+tip
	 IF (M->rcod1<=EMCARNE->codigo.AND.M->rcod2>=EMCARNE->codigo)
		PTAB(EMCARNE->codigo+TCARNES->tipcob+EMCARNE->circ,[TAXAS],1)

		SELE TAXAS
		DO WHILE !EOF().AND.codigo=EMCARNE->codigo
		 #ifdef COM_TUTOR
			IF IN_KEY()=K_ESC                              // se quer cancelar
		 #else
			IF INKEY()=K_ESC                               // se quer cancelar
		 #endi
			IF canc()                                      // pede confirmacao
			 BREAK                                         // confirmou...
			ENDI
		 ENDI
		 IF valorpg>0 .OR. !(tipo=TCARNES->tipcob)
			SKIP
			LOOP
		 ENDI

		 REL_CAB(2)                                      // soma cl/imprime cabecalho
		 @ cl,006 SAY LEFT(GRUPOS->nome,27)                       // Nome
		 @ cl,045 SAY LEFT(GRUPOS->nome,27)                       // Nome
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,006 SAY GRUPOS->endereco                   // Endere‡o
		 @ cl,045 SAY LEFT(GRUPOS->endereco,33)                   // Endere‡o
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
//		 @ cl,006 SAY GRUPOS->bairro                     // Endere‡o
//		 @ cl,045 SAY GRUPOS->bairro                     // Endere‡o
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,003 SAY TRAN(TAXAS->codigo,"999999")              // Codigo
		 IF TAXAS->tipo=[1]
			@ cl,009 SAY RIGHT(TAXAS->circ,2)+"/"+STR(TCARNES->parf,2)
		 ELSE
			@ cl,011 SAY TRAN(TAXAS->tipo,"!")                     // Tipo
			@ cl,012 SAY TRAN(TAXAS->circ,"999")                   // Circular
		 ENDI
		 @ cl,017 SAY left(dtoc(TAXAS->emissao_),6)+right(dtoc(TAXAS->emissao_),2)
		 @ cl,024 SAY TRAN(TAXAS->valor,"@E 999,999.99")        // Valor
		 @ cl,042 SAY TRAN(TAXAS->codigo,"999999")              // Codigo
		 IF TAXAS->tipo=[1]
			@ cl,048 SAY RIGHT(TAXAS->circ,2)+"/"+STR(TCARNES->parf,2)
		 ELSE
			@ cl,050 SAY TRAN(TAXAS->tipo,"!")                     // Tipo
			@ cl,051 SAY TRAN(TAXAS->circ,"999")                   // Circular
		 ENDI
		 @ cl,056 SAY left(dtoc(TAXAS->emissao_),6)+right(dtoc(TAXAS->emissao_),2)                // Emissao
		 @ cl,063 SAY TRAN(TAXAS->valor,"@E 999,999.99")        // Valor
		 REL_CAB(2)                                      // soma cl/imprime cabecalho
		 @ cl,066 SAY ""        // Valor
		 IF M->combarra=[S]
			CODBARRAS({{codigo+tipo+circ,4,13,66}},10,6)
		 ENDI
		 REL_CAB(1)                                      // soma cl/imprime cabecalho
		 @ cl,033 SAY TRAN(TAXAS->tipo,"!")                     // Tipo
		 @ cl,034 SAY TRAN(TAXAS->circ,"999")                   // Circular
		 @ cl,066 SAY ""        // Valor
		 IF M->combarra=[S]
			CODBARRAS({{codigo+tipo+circ,4,13,66}},10,6)
		 ENDI
		 SKIP                                            // pega proximo registro
		 cl=999                                          // forca salto de pagina
/*
     IF CODLAN=[EMC-].AND.PTAB(SUBSTR(CODLAN,5,8),[EMCARNE],3)
		  SELE EMCARNE
		  #ifdef COM_REDE
		   REPBLO('EMCARNE->emissao_',{||DATE()})
		  #else
		   REPL EMCARNE->emissao_ WITH DATE()
		  #endi
      SELE TAXAS
     ENDI
*/

		ENDD
		SELE EMCARNE
		#ifdef COM_REDE
		 REPBLO('EMCARNE->emissao_',{||DATE()})
		#else
		 REPL EMCARNE->emissao_ WITH DATE()
		#endi

		SKIP
	 ELSE
		skip
	 ENDI
	ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET MARG TO                                        // ajusta a margem esquerda
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(10)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|CARNES OSSEL"
ALERTA()
op_=2 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE EMCARNE                                      // processamentos apos emissao
 IF so_um_reg
  GO imp_reg
 ELSE
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
 ENDI
 DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN())

  #ifdef COM_REDE
   REPBLO('EMCARNE->emissao_',{||DATE()})
  #else
   REPL EMCARNE->emissao_ WITH DATE()
  #endi

  SKIP                                             // pega proximo registro
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE EMCARNE                                       // salta pagina
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
