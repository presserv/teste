/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: AMBARV33.PRG
 \ Data....: 07-06-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Recibo - Bom Jesus - Piracicaba
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg, mcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=22, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
V87001F9()  // Monta variaveis publicas...
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+15 SAY " IMPRESSŽO DE COBRAN€A "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran‡a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       £ltima:             )"
 @ l_s+04,c_s+1 SAY " Circulares a emitir: N§      at‚"
 @ l_s+05,c_s+1 SAY " Cobran‡as com data entre:"
 @ l_s+06,c_s+1 SAY " e n§ de contrato entre:        e"
 @ l_s+08,c_s+1 SAY "         Reimprimir taxas j  impressas?"
 @ l_s+09,c_s+1 SAY "     Acumular valor das cobran‡as vencidas?"
 @ l_s+10,c_s+1 SAY "         Tipo das taxas a acumular :"
 @ l_s+12,c_s+1 SAY "     Imprimir do recibo n§      at‚ o n§"
 @ l_s+19,c_s+1 SAY "                   Confirme:"
ENDI
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
rultcirc=SPAC(3)                                   // N§Ultima Circ.
rem1_=CTOD('')                                     // Emiss„o
rem2_=CTOD('')                                     // Emiss„o
rreimp=SPAC(1)                                     // Reimprimir?
IF !so_um_reg                             // vai receber a variaveis?
 rtp=SPAC(1)                                        // Tipo
 rcod1=SPAC(6)                                      // Contrato
 rcod2=SPAC(6)                                      // Contrato
 rtodas=[N]
 mcodaux:=[]
ELSEIF PCOU()=3
 mcodaux:=codigo+tipo+circ
 rcod1:=rcod2:=mcodaux
ELSEIF PCOU()=4
 rcod1:=rcod2:=mcodaux
ENDI
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rpagin=1                                           // Pag.inicial
rpagfim=9999                                       // Pag.final
rmens1:=rmens2:=rmens3:=rmens4:=rmens5:=rmens6:=space(60)
IF FILE('PRV33VAR.MEM')//.and.!so_um_reg
 REST FROM PRV33VAR ADDITIVE
ENDI
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
  @ l_s+01 ,c_s+20 GET  rtp;
                   PICT "9"
                   DEFAULT "[2]"
									 AJUDA "Qual o tipo de cobran‡a a imprimir neste impresso."
                   CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"

  @ l_s+02 ,c_s+09 GET  rgrupo;
                   PICT "!!";
                   VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(rgrupo)~GRUPO n„o existe na tabela")
                   AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                   CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                   MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 14 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 21 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 36 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 40 }

  @ l_s+04 ,c_s+26 GET  rproxcirc;
                   PICT "999";
                   VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.1=1~A Pr¢xima circular deve estar|lan‡ada em Tabela/Circulares")
                   DEFAULT "ARQGRUP->proxcirc"
                   AJUDA "Entre com o n£mero da pr¢xima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+04 ,c_s+35 GET  rultcirc;
                   PICT "999"
                   AJUDA "Entre com o n£mero da ultima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+05 ,c_s+28 GET  rem1_;
                   PICT "@D";
                   VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v lida.")
                   DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                   AJUDA "Data da Emiss„o da Circular.| Informe a data a considerar como inicial na emiss„o."

	@ l_s+05 ,c_s+39 GET  rem2_;
                   PICT "@D";
                   VALI CRIT("!EMPT(Rem2_)~Informe uma data v lida, deve ser posterior|a inicial")
                   DEFAULT "(DATE()+31)-DAY(DATE()+31)"
                   AJUDA "Imprimir a cobran‡a lan‡ada at‚ que data."

  @ l_s+06 ,c_s+26 GET  rcod1;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n£mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+06 ,c_s+35 GET  rcod2;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n£mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+08 ,c_s+41 GET  rreimp;
                   PICT "!";
                   VALI CRIT("rreimp$[SN ]~Necess rio informar REIMPRIMIR?|Digite S ou N")
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todos os documentos|mesmo os que j  foram impressos anteriormente."

  @ l_s+09 ,c_s+45 GET  racum;
                   PICT "!";
                   VALI CRIT("racum$[SN ]~ACUMULAR? n„o aceit vel|Digite S ou N")
                   DEFAULT "[ ]"
                   AJUDA "Digite S para acumular o valor|das cobran‡as n„o pagas neste documento."

  @ l_s+10 ,c_s+38 GET  rtipo;
                   PICT "!!!";
                   VALI CRIT("!EMPT(rtipo)~Necess rio informar TIPOS A IMPRIMIR");
                   WHEN "racum='S'"
                   DEFAULT "[123]"
                   AJUDA "Digite 1 para J¢ia, 2 para cobran‡as e 3 p/Periodo"
                   CMDF8 "MTAB([111-J¢ia|222-p/Processos|333-Peri¢dico|122-J¢ia+Processos|133-J¢ia+Per¡odico|233-Processos+Peri¢dicos|123-Todos],[TIPOS A IMPRIMIR])"

  @ l_s+12 ,c_s+28 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n£mero do primeiro recibo a imprimir."

	@ l_s+12 ,c_s+42 GET  rpagfim;
									 PICT "9999"
									 AJUDA "Informe o n£mero do £ltimo recibo a imprimir."

	@ l_s+13 ,c_s+02 GET  rmens1;
                   PICT "@!S45"
									 AJUDA "Informe a primeira linha de mensagem."

	@ l_s+14 ,c_s+02 GET  rmens2;
                   PICT "@!S45"
									 AJUDA "Informe a segunda linha de mensagem."

	@ l_s+15 ,c_s+02 GET  rmens3;
                   PICT "@!S45"
									 AJUDA "Informe a terceira linha de mensagem."
/*
	@ l_s+16 ,c_s+02 GET  rmens4;
                   PICT "@!S45"
									 AJUDA "Informe a quarta linha de mensagem."

	@ l_s+17 ,c_s+02 GET  rmens5;
                   PICT "@!S45"
									 AJUDA "Informe a quinta linha de mensagem."

	@ l_s+18 ,c_s+02 GET  rmens6;
                   PICT "@!S45"
									 AJUDA "Informe a sexta linha de mensagem."
*/
	@ l_s+19 ,c_s+30 GET  confirme;
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
 PTAB(codigo,"EMCARNE",1,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO GRUPOS->grupo+circ INTO CIRCULAR,;
          TO codigo+tipo+circ INTO CSTSEG,;
          TO codigo INTO EMCARNE,;
          TO EMCARNE->tip INTO TCARNES
 titrel:=criterio:=cpord := ""                            // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,23,11)          // nao quis configurar...
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
DBOX("[ESC] Interrompe| |",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
IF !so_um_reg
 SAVE TO PRV33VAR ALL LIKE R*
ENDI
SET DEVI TO PRIN                                   // inicia a impressao
maxli=65                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   SEEK M->mcodaux
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.(!so_um_reg.OR.(TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->mcodaux))
   #ifdef COM_TUTOR
		IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
    set devi to screen
    @ 17,35 say codigo+tipo+circ
    set devi to prin
   IF M->rcod1>[000000].AND.M->rcod1>codigo
    SKIP
    LOOP
   ENDI
   IF M->rcod2>[000000].AND.M->rcod2<codigo
    IF EMPT(cpord)
     GO BOTT
    ENDI
    SKIP
    LOOP
   ENDI
   IF (so_um_reg.AND.(TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->mcodaux)).OR.R08701F9()
    IF valorpg>0
      SKIP
      LOOP
    ELSE
     IF !so_um_reg.AND. (pg_<M->rpagin .OR.pg_>M->rpagfim)
      pg_++
      SKIP
      LOOP
     ENDI
    ENDI
		vlraux=Rx8702F9()                              // variavel temporaria
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY RX8703F9()                        // Montagem dos dados
		REL_CAB(4)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,006 SAY GRUPOS->grupo                     // grupo
    @ cl,017 SAY RIGHT(GRUPOS->codigo,3)           // contrato
    @ cl,024 SAY tipo+[ ]+circ                     // circ
		IMPCTL(drvtenf)
    @ cl,034 SAY GRUPOS->nome                      // Nome
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,034 SAY GRUPOS->endereco                  // Nome
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,034 SAY GRUPOS->bairro                    // Nome
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,002 SAY TRAN(TAXAS->emissao_,"@D")        // Vencto 1
		@ cl,014 SAY [R$ ]+TRAN(vlraux,"@E 999.99")    // Valor
		@ cl,027 SAY GRUPOS->cobrador                  // Bairro
    @ cl,034 SAY GRUPOS->cidade                    // Nome
/*
		@ cl,005 SAY TRAN(GRUPOS->cep,"@R 99999-999")  // CEP
		@ cl,024 SAY GRUPOS->cidade                    // Cidade
		@ cl,049 SAY TRAN(GRUPOS->uf,"!!")             // UF
*/
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,52}},10,6)
		ENDI
		REL_CAB(3)                                    // soma cl/imprime cabecalho
    @ cl,INT((070-LEN(ALLTRIM(rmens1)))/2) SAY ALLTRIM(rmens1)
		REL_CAB(1)                                    // soma cl/imprime cabecalho
    @ cl,INT((070-LEN(ALLTRIM(rmens2)))/2) SAY ALLTRIM(rmens2)
		REL_CAB(1)                                    // soma cl/imprime cabecalho
    @ cl,INT((070-LEN(ALLTRIM(rmens3)))/2) SAY ALLTRIM(rmens3)
		IMPCTL(drvpcom)

		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[01]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[02]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[03]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[04]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[05]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[06]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[07]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[08]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[09]                  // detprc1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detprc[10]                  // detprc1
		IMPCTL(drvtcom)
		REL_CAB(5)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpcom)
    @ cl,005 SAY detdeb[1]
    @ cl,026 SAY detdeb[2]
    @ cl,046 SAY detdeb[3]
    @ cl,066 SAY detdeb[4]
    @ cl,086 SAY detdeb[5]
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY detdeb[6]
    @ cl,026 SAY detdeb[7]
    @ cl,046 SAY detdeb[8]
    @ cl,066 SAY detdeb[9]
    @ cl,086 SAY detdeb[10]
		IMPCTL(drvtcom)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY GRUPOS->grupo                     // grupo
    @ cl,014 SAY RIGHT(GRUPOS->codigo,3)           // contrato
    @ cl,024 SAY tipo+[ ]+circ                     // circ
		@ cl,033 SAY TRAN(TAXAS->emissao_,"@D")        // Vencto 1
		@ cl,046 SAY [R$ ]+TRAN(vlraux,"@E 999.99")    // Valor
		@ cl,063 SAY GRUPOS->cobrador                  // Bairro
		REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY GRUPOS->nome                      // Nome
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,52}},10,6)
		ENDI
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY GRUPOS->endereco                  // Nome
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,52}},10,6)
		ENDI
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY GRUPOS->bairro                    // Nome
    @ cl,030 SAY GRUPOS->cidade                    // Nome

		REL_CAB(3)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpcom)
    @ cl,005 SAY detdeb[1]
    @ cl,026 SAY detdeb[2]
    @ cl,046 SAY detdeb[3]
    @ cl,066 SAY detdeb[4]
    @ cl,086 SAY detdeb[5]
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY detdeb[6]
    @ cl,026 SAY detdeb[7]
    @ cl,046 SAY detdeb[8]
    @ cl,066 SAY detdeb[9]
    @ cl,086 SAY detdeb[10]
		IMPCTL(drvtcom)

   #ifdef COM_REDE
    IF stat < [2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI
   #else
    IF stat < [2]
     REPL TAXAS->stat WITH [2]
    ENDI
   #endi


		SKIP                                           // pega proximo registro
		cl=999                                         // forca salto de pagina
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
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(23)                                          // grava variacao do relatorio
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
 cl=qt+2 ; pg_++
ENDI
RETU   // Final de AMBARV33.PRG

STATIC FUNC RX8703F9()
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08703F9.PRG
 \ Data....: 21-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Montagem dos dados dos falecimentos da circular.
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

LOCAL reg_dbf:=POINTER_DBF()
IF ultprc = CIRCULAR->grupo+CIRCULAR->circ .OR. !(TAXAS->tipo='2')
 RETU []
ENDI
AFILL(DETPRC,[])
ultprc:=CIRCULAR->grupo+CIRCULAR->circ
PTAB(ultprc,[CPRCIRC],1)
SELE CPRCIRC
contx:=0
DO WHILE .NOT. EOF() .AND. contx<LEN(detprc).AND.ultprc=grupo+circ
 IF ARQGRUP->cpadmiss=[S].AND. GRUPOS->admissao>CPRCIRC->dfal
  SKIP
  LOOP
 ENDI
 contx+=1

 detprc[contx]:=CPRCIRC->fal+[   ]
 IF PTAB(processo,[PRCESSOS],1)
  detprc[contx]+=LEFT(TRAN(SUBSTR([Titular  .Pai      .Mae      .Sogro    .Sogra    .Esposo(a).Filho(a) .Dependente],(VAL(PRCESSOS->grau)-1)*10+1,10),[]),10)
 ELSE
  detprc[contx]+=SPACE(10)
 ENDI
 detprc[contx]+=[   Contrato ]+right(CPRCIRC->num,3)+;
                [  Faleceu ]+DTOC(CPRCIRC->dfal)+[ ]+CPRCIRC->cids
 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU []      // <- deve retornar um valor qualquer

* \\ Final de R08703F9.PRG
static func rx8702f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08702F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valor Total do relat¢rio ADP_R087
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

 LOCAL reg_dbf1:=POINTER_DBF()
 cod:=codigo     // C¢digo da taxa a imprimir
 emx:=emissao_   // Emiss„o da taxa a ser impressa...
 keycst:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
 M->recvalor:=IIF(M->racum=[S],0,valor)
 vlseg:=vlcst:=vlout:=0
 M->contx:=0
 afill(detcst,[])
 IF PTAB(keycst,[CSTSEG],3,.t.)
	SELE CSTSEG
	DO WHILE ! EOF() .AND. keycst = contrato+tipo+circ
	 contx+=1
	 IF CONTX<11
		detcst[contx]:=&drvpcom+DTOC(CSTSEG->emissao_)+[ ]+;
		LEFT(CSTSEG->complement,30)+[ ]+;
		TRANSF(CSTSEG->QTDADE,"999")+;
		TRANSF(CSTSEG->valor,"@E 9,999.99")+&drvtcom
	 ENDI

	 IF " LOCACAO" $ UPPER(CSTSEG->complement)
		vlcst+=CSTSEG->valor  // Total de locacao

	 ELSEIF "AUXILIO"  $ UPPER(CSTSEG->complement)
		vlseg+=CSTSEG->valor  // Total de seguro

	 ELSE
		vlout+=CSTSEG->valor  // Outros custos adicionais
	 ENDI

	 SKIP
	ENDDO
	SELE TAXAS
 ENDI

 SELE TAXAS

 PTAB(cod,'TAXAS',1,.t.)

 M->contx:=0
 lindeb:=[]
 afill(detdeb,[])
 DO WHILE !EOF().AND.TAXAS->codigo=cod.AND.M->racum=[S]
	IF TAXAS->valorpg>0         // Somente taxas pendentes
	 SKIP
	 LOOP
	ENDI

// Ser„o consideradas vencidas as taxas anteriores a emiss„o da
// que ser  impressa.

	IF TAXAS->emissao_ <= emx .AND.TAXAS->tipo$M->rtipo // Somente taxas pendentes

	 M->recvalor+=TAXAS->valor
   keycst:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
	 IF PTAB(keycst,[CSTSEG],3)
    SELE CSTSEG
		DO WHILE ! EOF() .AND. keycst = contrato+tipo+circ
		 IF [AUXILIO]$UPPER(CSTSEG->complement)
      vlseg+=CSTSEG->valor
     ENDI
		 SKIP
    ENDDO
    SELE TAXAS
   ENDI

   IF TAXAS->emissao_ <= emx // detalha somente as taxas atrasadas.
    contx+=1
    IF CONTX<11             // as ultimas 10 parcelas
	  	detdeb[contx]:= LEFT(DTOC(TAXAS->emissao_),6)+RIGHT(DTOC(TAXAS->emissao_),2)+;
	  	                [   ]+TRANSF(TAXAS->valor,"@E 9,999.99")

    ENDI
		lindeb+=TAXAS->tipo+[-]+TAXAS->circ+[, ]//+DTOC(TAXAS->emissao_)
   ENDI
  ENDI
  SKIP
 ENDDO

 M->recvalor-=(M->vlseg+M->vlcst+M->vlout)
// dbox([recvalor ]+str(M->recvalor)+[|vlseg ]+str(M->vlseg)+[|vlcst ]+str(vlcst))

 POINTER_DBF(reg_dbf1)

RETU M->recvalor          // <- deve retornar um valor qualquer

* \\ Final de Rx8702F9.PRG
