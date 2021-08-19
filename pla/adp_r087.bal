/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Informatica Ltda. - ME
 \ Programa: APVAR044.PRG
 \ Data....: 01.04.2001
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Recibo de cobran�a - Baldochi
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg, rcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=24, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
PUBL vlaux:=0,vlout:=0,vlseg:=valororig:=0  // Composi��o do valor
PUBL lindeb:=[]  // Linha resumo dos d�bitos (Tipo+circ ...)
publ detdeb[12] // Detalhamento dos d�bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
PUBL ultprc:=[]  // Ultima cartinha montada, se for igual n�o refaz...
publ detprc[12] // Cartinha dos falecidos
afill(detprc,[])
publ contar:=.t., contx :=0

// Custos adicionais
PUBL vlcst:=0
publ detcst[12]
afill(detcst,[])



so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+15 SAY " IMPRESS�O DE COBRAN�A "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran�a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       �ltima:             )"
 @ l_s+03,c_s+1 SAY " Circulares a emitir: N�      at�"
 @ l_s+04,c_s+1 SAY " Cobran�as com data entre:          e"
 @ l_s+05,c_s+1 SAY " e n� de contrato entre:        e"
 @ l_s+06,c_s+1 SAY " Cobrador=                      "
 @ l_s+07,c_s+1 SAY "         Reimprimir taxas j� impressas?"
 @ l_s+08,c_s+1 SAY "     Acumular valor das cobran�as vencidas?"
 @ l_s+09,c_s+1 SAY "         Tipo das taxas a acumular :"
 @ l_s+10,c_s+1 SAY "     Imprimir do recibo n�      at� o n�"
 @ l_s+11,c_s+1 SAY " Data Vencimento:"
 @ l_s+12,c_s+1 SAY "������������������� Mensagens ��������������������"
 @ l_s+13,c_s+1 SAY "Cab-"
 @ l_s+14,c_s+1 SAY "Cab-"
 @ l_s+15,c_s+1 SAY "1-"
 @ l_s+16,c_s+1 SAY "2-"
 @ l_s+17,c_s+1 SAY "3-"
 @ l_s+18,c_s+1 SAY "4-"
 @ l_s+19,c_s+1 SAY "5-"
 @ l_s+20,c_s+1 SAY "6-"
 @ l_s+21,c_s+1 SAY "                   Confirme:"
ENDI
if !so_um_reg
 rtp=SPAC(1)                                        // Tipo
 rcod1:=SPAC(6)                                      // Contrato
 rcod2:=SPAC(6)                                      // Contrato
 rtodas:=[ ]
 rcodaux:=[]
elseif pcount()=3
 rcodaux:=codigo+tipo+circ
 rcod1:=rcod2:=rcodaux
elseif pcount()=4
 rcod1:=rcod2:=rcodaux
endi

rlaser=.F.
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
rven_=CTOD('')                                     // Emiss�o
rregiao=[000]                                      // Tipos a imprimir
rcobrad=SPAC(3)                                      // Tipos a imprimir
rreimp=SPAC(1)                                     // Reimprimir?

racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rpagin=1                                           // Pag.inicial
rpagfim=9999                                          // Pag.final
rcab1=SPAC(70)                                     // Cab1
rcab2=SPAC(70)                                     // Cab2
rmen1=SPAC(70)                                     // Mens1
rmen2=SPAC(70)                                     // Mens2
rmen3=SPAC(70)                                     // Mens3
rmen4=SPAC(70)                                     // Mens4
rmen5=SPAC(70)                                     // Mens5
rmen6=SPAC(70)                                     // Mens6
rcodempr:=[0340870000000753]
IF FILE('PR087VAR.MEM')
 REST FROM PR087VAR ADDITIVE
ENDI
rven_:=DATE()
if pcount()=3
 rcodaux:=codigo+tipo+circ
 rcod1:=rcod2:=rcodaux
elseif pcount()=4
 rcod1:=rcod2:=rcodaux
endi
confirme=SPAC(1)                                   // Confirme
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
                   VALI CRIT("PTAB(rgrupo,[ARQGRUP]).OR.vrgrupo()~GRUPO n�o existe na tabela")
                   AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                   CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                   MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 14 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 21 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 36 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 40 }

	@ l_s+03 ,c_s+26 GET  rproxcirc;
                   PICT "999";
                   VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.1=1~A Pr�xima circular deve estar|lan�ada em Tabela/Circulares")
                   DEFAULT "ARQGRUP->proxcirc"
                   AJUDA "Entre com o n�mero da pr�xima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+03 ,c_s+35 GET  rultcirc;
                   PICT "999"
                   AJUDA "Entre com o n�mero da ultima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+04 ,c_s+28 GET  rem1_;
                   PICT "@D";
                   VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v�lida.")
                   DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                   AJUDA "Data da Emiss�o da Circular.| Informe a data a considerar como inicial na emiss�o."

        @ l_s+04 ,c_s+39 GET  rem2_;
                                                                         PICT "@D";
                   VALI CRIT("!EMPT(Rem2_)~Informe uma data v�lida, deve ser posterior|a inicial")
                   DEFAULT "(DATE()+31)-DAY(DATE()+31)"
                   AJUDA "Imprimir a cobran�a lan�ada at� que data."

  @ l_s+05 ,c_s+26 GET  rcod1;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n�o aceit�vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n�mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+05 ,c_s+35 GET  rcod2;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n�o aceit�vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n�mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+06 ,c_s+26 GET  rcobrad;
                   PICT "@!"
                   AJUDA "Entre com o cobrador a imprimir|Tecle F8 para consulta"
                   CMDF8 "VDBF(6,26,20,77,'COBRADOR',{'cobrador','nome'},1,'cobrador')"

  @ l_s+07 ,c_s+41 GET  rreimp;
                   PICT "!";
									 VALI CRIT("rreimp$[SN ]~Necess�rio informar REIMPRIMIR?|Digite S ou N")
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todos os documentos|mesmo os que j� foram impressos anteriormente."

  @ l_s+08 ,c_s+45 GET  racum;
                   PICT "!";
                   VALI CRIT("racum$[SN ]~ACUMULAR? n�o aceit�vel|Digite S ou N")
                   DEFAULT "[ ]"
                   AJUDA "Digite S para acumular o valor|das cobran�as n�o pagas neste documento."

  @ l_s+09 ,c_s+38 GET  rtipo;
                   PICT "!!!";
                   VALI CRIT("!EMPT(rtipo)~Necess�rio informar TIPOS A IMPRIMIR");
                   WHEN "racum='S'"
                   DEFAULT "[123]"
                   AJUDA "Digite 1 para J�ia, 2 para cobran�as e 3 p/Periodo"
                   CMDF8 "MTAB([111-J�ia|222-p/Processos|333-Peri�dico|122-J�ia+Processos|133-J�ia+Per�odico|233-Processos+Peri�dicos|123-Todos],[TIPOS A IMPRIMIR])"

  @ l_s+10 ,c_s+28 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n�mero do primeiro recibo a imprimir."

        @ l_s+10 ,c_s+42 GET  rpagfim;
                                                                         PICT "9999"
                   AJUDA "Informe o n�mero do �ltimo recibo a imprimir."

  @ l_s+11 ,c_s+18 GET  rven_;
                   PICT "@D"
                   AJUDA "Data da Emiss�o da Circular.| Informe a data a considerar como inicial na emiss�o."

  @ l_s+13 ,c_s+05 GET  rcab1;
                   PICT "@S45"

  @ l_s+14 ,c_s+05 GET  rcab2;
                   PICT "@S25"

  @ l_s+15 ,c_s+04 GET  rmen1;
                   PICT "@S45@!"

  @ l_s+16 ,c_s+04 GET  rmen2;
                   PICT "@S45@!"

  @ l_s+17 ,c_s+04 GET  rmen3;
                   PICT "@S45@!"

	@ l_s+18 ,c_s+04 GET  rmen4;
                   PICT "@S45@!"

  @ l_s+19 ,c_s+04 GET  rmen5;
                   PICT "@S45@!"

  @ l_s+20 ,c_s+04 GET  rmen6;
                   PICT "@S45@!"

  @ l_s+21 ,c_s+30 GET  confirme;
                   PICT "!";
                   VALI CRIT("confirme$'SB23'~CONFIRME n�o aceit�vel")
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
        IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
         RETU                                            // volta ao menu anterior
        ENDI
 #else
        USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB([],[CPRCIRC],3,.t.)
 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 PTAB(codigo,"EMCARNE",1,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 IF M->confirme$[S23]
  SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
					TO cobrador INTO COBRADOR,;
          TO GRUPOS->grupo+circ INTO CIRCULAR
 ELSE
  PTAB(codigo+tipo+circ,[TX2VIA],1,.t.)
  SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO codigo+tipo+circ INTO TX2VIA,;
          TO GRUPOS->grupo+circ INTO CIRCULAR
 ENDI
 titrel:=criterio:=cpord := ""                            // inicializa variaveis

 if !so_um_reg
  IF rcod1>[000000]
//   criterio:=[TAXAS->codigo>=M->rcod1]
  ENDI
  IF rcod2>[000000]
   IF !EMPT(criterio)
//    criterio+=[.AND.]
   ENDI
//   criterio+=[TAXAS->codigo<=M->rcod2]
  ENDI
//  cpord=IIF(confirme$[S23],"cobrador+codigo+tipo+circ","")
  cpord=[]
 endi
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,63,11)          // nao quis configurar...
//   CLOS ALL                                        // fecha arquivos e
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
 lpp_026=LEFT(drvtapg,op_-1)+"271"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_026:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI

txtini:=txtgruini:=txgrufin:=[]

arqx_:=[\INICIO.TXT]
txtini:=MEMOREAD([\INICIO.TXT]) // texto inicial
txtmei:=MEMOREAD([\MENSCIRC.TXT])   // texto intermediario
txtfin:=MEMOREAD([\FIM.TXT])    // texto final
txtmens:=MEMOREAD([\MENSAG.TXT])   // texto intermediario
arqx_:=[\_]+alltrim(M->rgrupo)+[.txt]
IF FILE(arqx_)
 txtini:=MEMOREAD(arqx_) // texto inicial do grupo "_A.TXT"
ENDI

arqx_:=[\_]+alltrim(M->rgrupo)+[_.txt]
IF FILE(arqx_)
 txtmei:=MEMOREAD(arqx_) // texto intermediario do grupo "_A_.TXT"
ENDI

arqx_:=[\]+alltrim(M->rgrupo)+[_.txt]
IF FILE(arqx_)
 txtfin:=MEMOREAD(arqx_)  // texto final do grupo "A_.TXT"
ENDI

IF EMPT(M->rven_).OR. (M->rven_ < DATE())
 DTAUXVC:=EMISSAO_-DAY(EMISSAO_)+35
 DTAUXVC:=DTAUXVC-DAY(DTAUXVC)+DAY(EMISSAO_)
ELSEIF M->rven_ = DATE()
 DTAUXVC:=EMISSAO_
ELSE
 DTAUXVC:=M->rven_
ENDI

DBOX("[ESC] Interrompe| | ",15,,,NAO_APAGA)
IF !so_um_reg
 SAVE TO PR087VAR ALL LIKE R*
ENDI

dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
M->rcobrad:=ALLTRIM(M->rcobrad)
op_87=2
/*
IF !EMPT(M->rcobrad).AND.M->rcobrad#[BC].AND.!so_um_reg
 op_87=1
 op_87=DBOX("Somente a �ltima|Respeitar a filtragem",,,E_MENU,,"Imprimir qual?")
ENDI
*/
// Verifica se ser� utilizado DUPLEXADOR na impressora ou se s� ir� imprimir
// a parte interna do boleto.
op_873=2
//op_873=DBOX("Sim, utiliza Duplex|N�o utiliza Duplex  ",,,E_MENU,,"Utiliza Duplex?")

rlaser:=([Laser]$drvmarca)
rlaser:=.T.

rcab1:=PADL(ALLTRIM(rcab1),70)
rcab2:=PADL(ALLTRIM(rcab2),70)

SETMARG:=LEFT(GETENV("MARGEM"),4)     // tenta variavel de ambiente ESTACAO
SET DEVI TO PRIN                                   // inicia a impressao
IF EMPT(SETMARG)
 SET MARG TO 4                                      // ajusta a margem esquerda
ELSE
 SET MARG TO VAL(SETMARG)
ENDI

RCAJUSTE:=GETENV("AJUSTE")     // tenta variavel de ambiente de Ajuste
IF EMPT(RCAJUSTE)
 RAJUSTE:=0                            // ajusta a quantidade de linhas
																			 // no inicio do impresso
ELSE
 RAJUSTE:=VAL(RCAJUSTE)
ENDI

maxli=277                                           // maximo de linhas no relatorio

ultrec:=0
drvpcomx:="CHR(27)+[&k2S]"  // Comprimido
drvtcomx:="CHR(27)+[&k0S]"  // Normal
drvaux:="CHR(27)+[&l24D]"

IMPCTL(lpp_026)                                    // seta pagina com 26 linhas
IMPCTL(drvaux)  // Inicia 24 linhas p/polegada

drvaux:="CHR(27)+[&l26A]"
IMPCTL(drvaux)  // Tamanho de Papel - (Legal l3A) - (A4 l26A)

drvaux:="CHR(27)+[&l265F]"
IMPCTL(drvaux)  // Numero de linhas


IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI

M->rcobrad:=ALLTRIM(M->rcobrad)
cttx2 := 0
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   GO imp_reg
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo

/*
   IF !EMPT(M->rcobrad).and.confirme$[S23]
    seek IIF(EMPT(criterio),[],[T])+M->rcobrad
   ENDI
*/
   IF !EMPT(VAL(M->rcod1)).and.confirme$[S23]
    seek IIF(EMPT(criterio),[],[T])+M->rcod1
   ENDI
        ENDI
	ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.(!so_um_reg.OR. codigo+tipo+circ=M->rcodaux)

   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
         #endi
                IF canc()                                      // pede confirmacao
								 BREAK                                         // confirmou...
                ENDI
         ENDI
   IF op_87=1
    GO (ultimataxa(codigo+rtp)) // Nr.registro �ltima taxa.
   ELSEIF so_um_reg
    GO (ultimataxa(LEFT(M->rcodaux,7)))
   ELSEIF !(confirme$[S23])
    SELE TX2VIA
    cttx2++
    IF cttx2 > reccount()
     SELE TAXAS
     GO BOTT
     SKIP
     LOOP
    ENDI
    GO (cttx2)
    rcodaux:=codigo+tipo+circ
/*
    SET DEVI TO SCRE                                // apresenta na tela
    dbox(rcodaux)
    SET DEVI TO PRIN                                // inicia a impressao
*/
    SELE TAXAS
    SEEK M->rcodaux
   ENDI

   SET DEVI TO SCRE                                // apresenta na tela
   @ 17,35 say codigo+tipo+circ
   SET DEVI TO PRIN                                // inicia a impressao

   // Se titulo ja pago
   IF valorpg>0
    SKIP
    LOOP
   ENDI

   // Se nao for o registro pedido
         IF !((so_um_reg.and.codigo+tipo+circ=M->rcodaux).or.SR08701F9())
    SKIP
    LOOP
   ENDI
   // Se nao for a pagina inicial solicitada
   IF (pg_ <M->rpagin).AND.!so_um_reg
    pg_++
		IF op_873=1 // Utiliza duplexador
     pg_++
    ENDI
    SKIP
    LOOP
   ENDI
   // Se ja passou a maior pagina solicitada
	 IF (pg_>M->rpagfim).AND.!so_um_reg
		GO BOTT
		SKIP
		LOOP
	 ENDI
	 // Se pediu o cobrador e nao for do solicitado
	 IF !EMPT(M->rcobrad).AND.!so_um_reg
		IF !(M->rcobrad $ GRUPOS->cobrador)
		 SKIP
		 LOOP
		ENDI
	 ENDI

		SET DEVI TO SCRE                                // apresenta na tela
		@ 18,35 say pg_
		SET DEVI TO PRIN                                // inicia a impressao

								valororig=SR08702F9()                           // variavel temp.de valor

		rcbarra:=[82]+SUBSTR(TAXAS->codigo,2)+tipo+RIGHT(circ,2)      // Nosso n�mero
		rcbarra+=STR(DIGTVER10(rcbarra),1)             // DV para o c�digo de barras
		c_barra:=MONTA_BARRA(rcodempr,rcbarra,valororig)  // Cod.de Barra p/Banco

		rcbarra:=DG_COBSI([82]+SUBSTR(TAXAS->codigo,2)+tipo+RIGHT(circ,2))// DV p/Nosso N�mero

								REL_CAB(6) //IIF(pg_=1,3,6))                        // soma cl/imprime cabecalho

		cl+=M->rajuste  // Variavel de ambiente para corrigir a qtdade. de linhas
										// da folha solta...

    // Alterado em 02/07/2004 a pedido do Sr.Franco por email e fax:
    // Imprimir mensagem no lugar dos falecidos, para todos os tipos de taxas.
    IF M->rtp=[1]
     FOR contx= 1 TO 12
      detprc[contx]:=MEMOLINE(txtmens,55,contx)         // Mensagem
     NEXT
    ELSE
     FOR contx= 1 TO 12
      detprc[contx]:=MEMOLINE(txtmei,55,contx)         // Mensagem
     NEXT
//		 @ cl,000 SAY R08703F9()                       // Montagem dos dados
    ENDI

IF EMPT(M->rven_).OR. (M->rven_ < DATE())
 DTAUXVC:=EMISSAO_-DAY(EMISSAO_)+35
 DTAUXVC:=DTAUXVC-DAY(DTAUXVC)+DAY(EMISSAO_)
ELSEIF M->rven_ = DATE()
 DTAUXVC:=EMISSAO_
ELSE
 DTAUXVC:=M->rven_
ENDI


		SELE TAXAS

    IMPCTL(drvtcomx)
                REL_CAB(27)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,030 SAY PADR(GRUPOS->nome,35)+TAXAS->codigo                          // Nome
                REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,030 SAY GRUPOS->endereco
                REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,030 SAY GRUPOS->bairro
                REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,030 SAY TRAN(GRUPOS->cep,[@R 99999-999])
    @ cl,042 SAY GRUPOS->cidade+GRUPOS->uf
    IMPCTL(drvtenf)
                REL_CAB(7)                                     // soma cl/imprime cabecalho
                REL_CAB(20)                                     // soma cl/imprime cabecalho
    @ cl,057 SAY GRUPOS->codigo+[  ]+GRUPOS->grupo                          // Nome
								REL_CAB(7)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)

    SET MARG TO IIF(EMPT(SETMARG),2,MAX(VAL(SETMARG)-2,0)) // margem ajustada
    @ cl,000 SAY GRUPOS->nome  // em 26/12/02 a pedido do Sr.Franco p/nomes grandes
    SET MARG TO IIF(EMPT(SETMARG),4,MAX(VAL(SETMARG),0))   // ajusta a margem esquerda

    @ cl,040 SAY GRUPOS->codigo+[  ]+GRUPOS->grupo                          // Nome
    IMPCTL(drvtenf)
    @ cl,057 SAY TAXAS->tipo+[-]+TAXAS->circ
								REL_CAB(6)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpenf)
		@ cl,000 SAY TAXAS->tipo+[-]+TAXAS->circ
		@ cl,008 SAY STR(GRUPOS->qtcircs,3)
/*
		@ cl,015 SAY LEFT(DTOC(TAXAS->emissao_),6)+RIGHT(DTOC(TAXAS->emissao_),2)
		@ cl,025 SAY STR(TAXAS->valor,6,2)
		IMPCTL(drvtenf)
		@ cl,043 SAY STR(TAXAS->valor,6,2)
		@ cl,054 SAY STR(GRUPOS->qtcircs,3)+[   ]+DTOC(TAXAS->emissao_)
								REL_CAB(6)                                     // soma cl/imprime cabecalho
		@ cl,058 SAY STR(TAXAS->valor,7,2)
*/
		@ cl,015 SAY LEFT(DTOC(M->dtauxvc),6)+RIGHT(DTOC(M->dtauxvc),2)
		@ cl,025 SAY STR(valororig,6,2)
		IMPCTL(drvtenf)
		@ cl,043 SAY STR(valororig,6,2)
		@ cl,054 SAY STR(GRUPOS->qtcircs,3)+[   ]+DTOC(M->dtauxvc)
								REL_CAB(6)                                     // soma cl/imprime cabecalho
		@ cl,058 SAY STR(valororig,7,2)
		IMPCTL(drvpenf)
		IMPCTL(drvpcomx)
    IF !(M->rtp=[1])
//		 @ cl,000 SAY [ Contr. Falecido                           Processo]
    ENDI
		IMPCTL(drvtenf)
								REL_CAB(1)                                     // soma cl/imprime cabecalho
		FOR contx:=1 TO 12                             // Falecidos
								 REL_CAB(4)                                    // soma cl/imprime cabecalho
								 @ cl,000 SAY detprc[M->contx]+[   ]+;
															detdeb[M->contx]
		 IF contx=2
			IMPCTL(drvtcomx)
		  @ cl+2,058 SAY STR(valororig,7,2)	//@ cl+2,058 SAY STR(TAXAS->valor,7,2)
			IMPCTL(drvpcomx)
		 ELSEIF contx=11
			IMPCTL(drvtcomx)
			@ cl,058 SAY LEFT(GRUPOS->nome,17)
			IMPCTL(drvpcomx)
		 ENDI

		NEXT contx
		IMPCTL(drvtcomx)
/*
		REL_CAB(3)
		IMPCTL(drvtcomx)
		@ cl,054 SAY LEFT(GRUPOS->nome,17)
*/
//		REL_CAB(03)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY ""
		CODBARRAS({{TAXAS->codigo+TAXAS->tipo+TAXAS->circ,4,10,36}},10,6)

								REL_CAB(10)                                    // soma cl/imprime cabecalho
								REL_CAB(05)                                    // soma cl/imprime cabecalho
		IMPCTL(drvpenf)
                /* Comentado em 29/12/2001 por motivo de alteracao no
                documento pre-impresso, a pedido do Sr.Franco
		@ cl, 20 SAY LEFT(c_barra [2],3)+[ ]+c_barra [2]  // Linha digitavel
    */
		@ cl, 24 SAY c_barra [2]  // Linha digitavel

		IMPCTL(drvtenf)

		// 160
								REL_CAB(7)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpcomx)
		@ cl,008 SAY rcab1                 // Local de Pagamento
		IMPCTL(drvtcomx)
		IMPCTL(drvpenf)
		@ cl,058 SAY DTOC(M->dtauxvc)      // Vencimento
		IMPCTL(drvtenf)

								REL_CAB(7)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY M->setup1             // Cedente

		IMPCTL(drvpenf)
		@ cl,056 SAY &drvpcomx+TRAN(rcodempr,[@R 9999-999.99999999-9])+&drvtcomx
		IMPCTL(drvtenf)

								REL_CAB(4)                                     // soma cl/imprime cabecalho
                /* Comentado em 29/12/2001 por motivo de alteracao no
                documento pre-impresso, a pedido do Sr.Franco
								@ cl,062 SAY &drvpcomx+[/ N.Numero]+&drvtcomx
                */
								REL_CAB(3)
		@ cl,000 SAY TRAN(DATE(),[@D])  // Data do documento
		@ cl,012 SAY codigo+[-]+tipo+[-]+circ+[  OU      2]  // Numero documento
		@ cl,040 SAY DATE()             // Data do processamento
		IMPCTL(drvpenf)
			@ cl,053 SAY TRAN(rcbarra,[@R 9999999999-9]) // Nosso numero
//		@ cl,053 SAY codigo+[ ]+GRUPOS->grupo+;
//                 &drvpcomx+[  (]+tipo+[-]+circ+[)]+&drvtcomx//TRAN(rcbarra,[@R 9999999999-9]) // Nosso numero
		IMPCTL(drvtenf)
								REL_CAB(5)                                     // soma cl/imprime cabecalho
		@ cl,012 SAY [  SR     R$]
		IMPCTL(drvpenf)
		@ cl,058 SAY TRAN(valororig,"@E 9,999.99")    // Valor 2
		IMPCTL(drvtenf)

		IMPCTL(drvpcomx)
								REL_CAB(9)                                     // soma cl/imprime cabecalho
		@ cl,003 SAY M->rmen1                          // Nome
								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,003 SAY M->rmen2                          // Nome
								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,003 SAY M->rmen3                          // Nome
								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,003 SAY M->rmen4                          // Nome
								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,003 SAY M->rmen5                          // Nome
								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,003 SAY M->rmen6                          // Nome
		IMPCTL(drvtcomx)
								REL_CAB(12)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY GRUPOS->nome+[   ]+;                  // Nome
								 IIF(!EMPT(GRUPOS->cpf),[CPF: ]+TRAN(GRUPOS->cpf,[@R 999.999.999-99]),[ ])

		//218
								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY ALLTRIM(GRUPOS->endereco)+[  ]+ALLTRIM(GRUPOS->bairro)      // Endere�o

								REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf+[  CEP: ]+;
			TRAN(GRUPOS->cep,"@R 99999-999")
								REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,045 SAY [(]+codigo+[-]+tipo+[-]+circ+[/]+;
						 TRAN(GRUPOS->qtcircs,[999])+[)]
		@ cl,069 say str(pg_-1,5)
								cl+=3
		@ cl,000 SAY ""
		CODBARRAS({{c_barra [1],4,40,00}},10,6)
								cl+=3
		@ cl,000 SAY ""
		CODBARRAS({{c_barra [1],4,40,00}},10,6)

								cl+=3 //REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY ""
		CODBARRAS({{c_barra [1],4,40,00}},10,6)
								cl+=3 //                REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY ""
		CODBARRAS({{c_barra [1],4,40,00}},10,6)

/*
		// 238
								cl+=3 //                REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY ""
		CODBARRAS({{c_barra [1],4,40,00}},10,6)
*/
         #ifdef COM_REDE
                IF stat < [2]
     SELE TAXAS
     DO WHILE !RLOCK()
     ENDD
                 REPL TAXAS->stat WITH [2]

//               REPBLO('TAXAS->stat',{||[2]})
                ENDI
         #else
                IF stat < [2]
								 REPL TAXAS->stat WITH [2]
                ENDI
         #endi
   IF op_873=1
    REL_CAB(128)                                     // soma cl/imprime cabecalho
    @ cl,015 SAY [(]+GRUPOS->grupo+[ ]+codigo+[-]+ GRUPOS->cobrador+[)]  // Numero documento
          REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,015 SAY ALLTRIM(GRUPOS->nome)  // Numero documento
          REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,015 SAY GRUPOS->endereco                      // Endere�o
					REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,015 SAY GRUPOS->bairro                        // Bairro
          REL_CAB(4)                                     // soma cl/imprime cabecalho
		@ cl,015 SAY ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf+[  CEP: ]+;
      TRAN(GRUPOS->cep,"@R 99999-999")
   // 393
          REL_CAB(1)                                     // soma cl/imprime cabecalho
//   IMPCTL("CHR(12)+CHR(13)") // For�a Salto de Pagina
   ELSE
    pg_++  // Continuar pulando duas paginas mesmo sem duplex
   ENDI

         cl=999                                         // forca salto de pagina
   IF so_um_reg                             // vai receber a variaveis?
    EXIT
   ENDI
   skip // Refeito em 27/06 (havia sumido o skip)
				ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcomx)                                    // retira comprimido
SET MARG TO                                        // coloca margem esquerda = 0
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video

IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(63)                                          // grava variacao do relatorio
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
 cl=qt+25 ; pg_++
ENDI
RETU

* \\ Final de APVAR044.PRG
STAT FUNC vrgrupo()
IF PTAB(rgrupo,'ARQGRUP',1)
  rcod1:=ARQGRUP->inicio
  rcod2:=ARQGRUP->final
ELSE
 rcod1:=rcod2:=[000000]
ENDI
RETU .T.

/********
 Passar como parametros:
 1- Codigo da Empresa - ate 15 bytes
 2- Nosso Numero - 10 Char
 3- Valor do titulo
*********/
STAT FUNC MONTA_BARRA(wparcodemp,wnumcef,wti1valtit)
   wti2numcef:=val(wnumcef)
	 ctcodbarra:= "1049" + ;
			strzero(wti1valtit * 100, 14) + ;
			SubStr(wnumcef, 1, 10) + SubStr(wparcodemp, 1, 15)
	 soma:= 0
	 fator:= 2
	 for i:= 43 to 1 step -1
			soma:= soma + Val(SubStr(ctcodbarra, i, 1)) * fator++
			fator:= iif(fator = 10, 2, fator)
	 next
	 digcodbar:= Str(iif(11 - soma % 11 <= 1 .OR. 11 - soma % 11 > 9, ;
			1, 11 - soma % 11), 1)
	 ctcodbarra:= SubStr(ctcodbarra, 1, 4) + digcodbar + ;
			SubStr(ctcodbarra, 5, 39)

	 ct1cabpart:= "104" + "9" + SubStr(strzero(wti2numcef, 11), 1, 5)
   ct1digpart:= Str(digtver10(ct1cabpart), 1)
   ct1cabpart:= SubStr(ct1cabpart, 1, 5) + "." + ;
         SubStr(ct1cabpart, 6, 5) + ct1digpart + "  "
   ct2cabpart:= SubStr(strzero(wti2numcef, 11), 6, 5) + ;
         SubStr(wparcodemp, 1, 5)
   ct2digpart:= Str(digtver10(ct2cabpart), 1)
   ct2cabpart:= SubStr(ct2cabpart, 1, 5) + "." + ;
         SubStr(ct2cabpart, 6, 5) + ct2digpart + "  "
   ct3cabpart:= SubStr(wparcodemp, 6, 10)
	 ct3digpart:= Str(digtver10(ct3cabpart), 1)
   ct3cabpart:= SubStr(ct3cabpart, 1, 5) + "." + SubStr(ct3cabpart, ;
      6, 5) + ct3digpart + " "
	 ct4cabpart:= " " + digcodbar + " "
   ct5cabpart:= " " + alltrim(Str(wti1valtit * 100, 15))
   ctcabecalh:= ct1cabpart + ct2cabpart + ct3cabpart + ct4cabpart + ;
      ct5cabpart
RETU {ctcodbarra,ctcabecalh}


STATIC FUNCTION DIGTVER10(Arg1)
LOCAL Local1, Local2, Local3, Local4, Local5
Local1:= LEN(ALLTRIM(Arg1))
Local5:= 2
Local3:= 0
DO WHILE (LEN(ALLTRIM(Arg1)) != 0)
 Local2:= VAL(RIGHT(Arg1, 1))
 IF (Local2 * Local5 < 9)
  Local3:= Local3 + Local2 * Local5
 ELSE
  Local3:= Local3 + VAL(SUBSTR(STR(Local2 * Local5, 2, 0), 1, ;
  1)) + Val(SUBSTR(STR(Local2 * Local5, 2, 0), 2, 1))
 ENDI
 IF (Local5 == 2)
  Local5:= 1
 ELSEIF (Local5 == 1)
  Local5:= 2
 ENDI
 Arg1:= SUBSTR(Arg1, 1, Len(Arg1) - 1)
ENDD
RETU IIF(10 - Local3 % 10 != 10, 10 - Local3 % 10, 0)

********************************
********************************
STATIC FUNCTION DG_COBSI(Arg1)
	 soma:= 0
   fator:= 2
   for i:= 10 to 1 step -1
      soma:= soma + Val(SubStr(Arg1, i, 1)) * fator++
      fator:= iif(fator = 10, 2, fator)
   next
   RETU arg1+ Str(iif(11 - soma % 11 > 9,0, 11 - soma % 11), 1)

********************************
STAT FUNC ULTIMATAXA
PARA mcod
//LOCAL reg_dbf:=POINTER_DBF(), dt_tx:=ctod('  /  /  ')
IF pcount()=0
 mcod = codigo
ENDI
SELE TAXAS
xcob:=cobrador
//SEEK xcob+M->mcod
dt_tx:=TAXAS->emissao_
nr_tx:=recno() //codigo+tipo+circ
DO WHILE !EOF() .AND. codigo+tipo+circ=M->Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->emissao_ > dt_tx.and.TAXAS->emissao_<=M->rem2_
				 dt_tx:=TAXAS->emissao_
				 nr_tx:=recno() //codigo+tipo+circ
 ENDI
 SKIP
ENDDO

RETU nr_tx       // <- deve retornar um valor DATA

STAT FUNC SR08701F9
donex:=.t.
DO CASE
CASE valorpg>0 // J� paga, tchau!!!
 donex:=.f.
CASE !(tipo=M->rtp) //N�o � meu tipo!!!
 donex:=.f.
CASE (stat>[1].AND.!(M->rreimp=[S])) //J� foi impressa !!!
 donex:=.f.
CASE !EMPT(M->rgrupo).AND.!(GRUPOS->grupo=M->rgrupo)// Quero s� o grupo!!
 donex:=.f.
CASE !(GRUPOS->situacao=[1]) //Contrato esta cancelado...
 donex:=.f.
CASE VAL(M->rproxcirc)>0.AND.(TAXAS->circ<M->rproxcirc)//Circular menor
 donex:=.f.
CASE VAL(M->rultcirc)>0.AND.(TAXAS->circ>M->rultcirc)//Circular maior
 donex:=.f.
CASE VAL(M->rcod1)>0.AND.TAXAS->codigo<M->rcod1
 donex:=.f.
CASE VAL(M->rcod2)>0.AND.TAXAS->codigo>M->rcod2
 donex:=.f.
CASE TAXAS->emissao_< M->rem1_.OR.TAXAS->emissao_>M->rem2_
 donex:=.f.
OTHERWISE
 donex:=.t.
ENDCASE

RETU  M->donex     // <- deve retornar um valor L�GICO

STAT FUNC SR08702F9

 cod:=codigo                                     // C�digo da taxa a imprimir
 emx:=emissao_                                   // Emiss�o da taxa a ser impressa...
 keycst:=RECNO()

 M->recvalor:=IIF(M->racum=[S],0,valor)
 vlseg:=vlcst:=vlout:=0
 M->contx:=0
 afill(detcst,[])

 SELE TAXAS
 in_=INDEXORD()
 SET ORDER TO 1
 seek cod

 M->contx:=0
 lindeb:=[]
 afill(detdeb,[])
 DO WHILE !EOF().AND.TAXAS->codigo=cod  //.AND.M->racum=[S]
				IF TAXAS->valorpg>0                            // Somente taxas pendentes
				 SKIP
				 LOOP
				ENDI

// Ser�o consideradas vencidas as taxas anteriores a emiss�o da
// que ser� impressa.

				IF TAXAS->emissao_ <= emx //.AND.TAXAS->tipo$M->rtipo // Somente taxas pendentes

				 M->recvalor+=IIF(M->racum=[S].AND.TAXAS->tipo$M->rtipo,TAXAS->valor,0)

	 IF TAXAS->emissao_ < emx                     // detalha somente as taxas atrasadas.
		contx+=1
		IF CONTX<11                                  // as ultimas 10 parcelas
								detdeb[contx]:=TAXAS->tipo+[ ]+TAXAS->circ+[ ]+;
			 LEFT(DTOC(TAXAS->emissao_),6)+RIGHT(DTOC(TAXAS->emissao_),2) +[ ]+;
								TRANSF(TAXAS->valor,"@E 9,999.99")

    ENDI
                lindeb+=TAXAS->tipo+[-]+TAXAS->circ+[, ]     //+DTOC(TAXAS->emissao_)
	 ENDI
  ENDI
  SKIP
 ENDDO
 M->recvalor-=(M->vlseg+M->vlcst+M->vlout)

SET ORDER TO in_                                 // RESTAURA ordem dos indices
GO keycst

RETU M->recvalor                                 // <- deve retornar um valor qualquer

* \\ Final de R08701F9.PRG

/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: R08703F9.PRG
 \ Data....: 21-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Montagem dos dados dos falecimentos da circular.
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

STAT FUNC R08703F9

//LOCAL reg_dbf:=POINTER_DBF()
IF ultprc = CIRCULAR->grupo+CIRCULAR->circ .OR. !(TAXAS->tipo='2')
 RETU []
ENDI
AFILL(DETPRC,[])
ultprc:=CIRCULAR->grupo+CIRCULAR->circ
agrau:={[Tit.],[Pai],[Mae],[Sogro],[Sogra],[Espos.],[Filh.],[Dep.]}
//PTAB(ultprc,[CPRCIRC],3,.t.)
SELE CPRCIRC

SEEK ultprc

contx:=0
DO WHILE .NOT. EOF() .AND. contx<LEN(detprc).AND.ultprc=grupo+circ
/*   Bom Pastor Nao verifica este item...
 IF ARQGRUP->cpadmiss=[S].AND. GRUPOS->admissao>CPRCIRC->dfal
	SKIP
	LOOP
 ENDI
*/
 contx+=1

/* // Bom Pastor
 detprc[contx]:=[  ]+CPRCIRC->num+[    ]+;
								TRAN(CPRCIRC->processo,'@R 99999/99/!!')+;
								[  ]+LEFT(CPRCIRC->fal,30)+[ ]+;
PADR(ALLTRIM(CPRCIRC->ends)+[-]+ALLTRIM(CPRCIRC->bais)+[-]+ALLTRIM(CPRCIRC->cids),50)+[  ]+;
								LEFT(DTOC(CPRCIRC->dfal),6)+right(DTOC(CPRCIRC->dfal),2)
*/

// Baldochi - modelo de boleto  01/04/2001
 PTAB(CPRCIRC->processo,[PRCESSOS],1,.t.)
 detprc[contx]:=[ ]+CPRCIRC->num+[-]+;
								PADR(ALLTRIM(CPRCIRC->fal)+[-]+;
								IIF(PRCESSOS->grau$[12345678],agrau[VAL(PRCESSOS->grau)],[]),35)+[ ]+;
								TRAN(CPRCIRC->processo,'@R 99999/99/!!')
/*
 // Baldochi - Ribeir�o Preto
 detprc[contx]:=[CONTR.:]+CPRCIRC->num+[->Atendido: ]+CPRCIRC->fal+;
	[ em ]+DTOC(CPRCIRC->dfal)+[ ]+CPRCIRC->cids+[ Nr.Obito:]+CPRCIRC->processo

 // Geral - Padrao
 detprc[contx]:=CPRCIRC->num+[ ]+CPRCIRC->fal+[ ]+DTOC(CPRCIRC->dfal)+;
 [ ]+CPRCIRC->cids+[ ]+CPRCIRC->processo

 // Brotas
 detprc[contx]:=TRAN(CPRCIRC->processo,'@R 99999/99/!!')+[  ]+;
								CPRCIRC->categ+[  ]+;
								CPRCIRC->fal+[ ]+;
								CPRCIRC->ends+[     ]+LEFT(DTOC(CPRCIRC->dfal),6)+;
								right(DTOC(CPRCIRC->dfal),2)
*/

 SKIP
ENDDO

//POINTER_DBF(reg_dbf)
SELE TAXAS

RETU []      // <- deve retornar um valor qualquer

* \\ Final de R08703F9.PRG
