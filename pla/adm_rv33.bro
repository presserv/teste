/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: AMBRRV33.PRG
 \ Data....: 29-10-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Impress�o das Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=6, c_s:=16, l_i:=20, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
 circax1:=circax2:=circax3:=circax4:=[]
 circax5:=circax6:=circax7:=circax8:=[]

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
 @ l_s+13,c_s+1 SAY "                   Confirme:"
ENDI
rtp=SPAC(1)                                        // Tipo
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
rcod1=SPAC(6)                                      // Contrato
rcod2=SPAC(6)                                      // Contrato
rreimp=SPAC(1)                                     // Reimprimir?
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rpagin=1                                           // Pag.inicial
rpagfim=9999                                          // Pag.final
IF FILE('PRV33VAR.MEM')
 REST FROM PRV33VAR ADDITIVE
ENDI
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+20 GET  rtp;
                   PICT "!"
                   DEFAULT "[2]"
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

SAVE TO PRV33VAR ALL LIKE R*

 #ifdef COM_REDE
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->regiao,"REGIAO",1,.t.)
 PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->regiao INTO REGIAO,;
          TO GRUPOS->grupo INTO ARQGRUP,;
          TO GRUPOS->grupo+circ INTO CIRCULAR
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,44,11)          // nao quis configurar...
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
 lpp_051=LEFT(drvtapg,op_-1)+"051"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_051:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
set cent off
maxli=49                                           // maximo de linhas no relatorio
IMPCTL(lpp_051)                                    // seta pagina com 51 linhas
SET MARG TO 1                                      // ajusta a margem esquerda
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
  DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN())
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
		IF so_um_reg.AND.valorpg>0
			SKIP
			LOOP
		ELSE
    IF (pg_<M->rpagin .OR.pg_>M->rpagfim).AND.!so_um_reg
     pg_++
     SKIP
     LOOP
    ENDI
		ENDI
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY &drvpc20                          // comprime carta
       IMPAC("Processo     Categ Falecido                            Endere�o                                     Falecto",cl,009)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
@ cl,009 SAY "============ ===== =================================== ============================================ =========="
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[1]                         // dp1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[2]                         // dp2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[3]                         // dp3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[4]                         // dp4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[5]                         // dp5
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[6]                         // dp6
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[7]                         // dp7
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[8]                         // dp8
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[9]                         // dp9
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY detprc[10]                        // dp10
    @ cl,129 SAY &drvtc20                          // descomprime
    @ cl,129 SAY &drvtcom                          // descomprime
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY LEFT(CIRCULAR->menscirc,52)       // Mensagem
    REL_CAB(7)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    IF M->combarra=[S]
     CODBARRAS({{codigo+tipo+circ,4,13,65}},10,6)
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,024 SAY M->setup1                         // Ident1
    IF M->combarra=[S]
     CODBARRAS({{codigo+tipo+circ,4,13,65}},10,6)
    ENDI
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,024 SAY LEFT(ALLTRIM(GRUPOS->endereco)+[-]+GRUPOS->bairro,52)// Endere�o
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(GRUPOS->grupo,"!!")          // Grupo
    @ cl,007 SAY [000]+RIGHT(GRUPOS->codigo,3)     // Codigo
    @ cl,014 SAY tipo+[-]+circ                     // Circular
    @ cl,029 SAY GRUPOS->nome                      // Nome
    @ cl,073 SAY tipo+[-]+circ                     // Circular
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(GRUPOS->qtcircs+IIF(GRUPOS->ultcirc=circ,0,1),"999")// Qt.Circulares
    @ cl,012 SAY TRAN(emissao_,"@D")               // Emissao
    @ cl,024 SAY codigo             // Codigo
    @ cl,035 SAY TRAN(GRUPOS->grupo,"!!")          // Grupo
    @ cl,063 SAY TRAN(GRUPOS->qtcircs+IIF(GRUPOS->ultcirc=circ,0,1),"999")// Qt.Circulares
    @ cl,070 SAY TRAN(emissao_,"@D")               // Emissao
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY TRAN(vlaux,"@E 999,999.99")       // Valor
    @ cl,064 SAY TRAN(vlaux,"@E 999,999.99")       // Valor
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,024 SAY ALLTRIM(LEFT(circax1,4)+LEFT(circax2,4)+LEFT(circax3,4)+LEFT(circax4,4)+LEFT(circax5,4)+LEFT(circax6,4)+LEFT(circax7,4)+LEFT(circax8,4))+&drvtcom// Resumo debito

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
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
set cent on
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(44)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT�RIO|IMPRESS�O DAS TAXAS"
ALERTA()
op_=2 //DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TAXAS                                        // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 IF so_um_reg
  GO imp_reg
 ELSE
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
 ENDI
 DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN()).and.odometer()
  IF (R08701F9()) .OR. so_um_reg                   // se atender a condicao...

   #ifdef COM_REDE
    IF stat<[2]
     REPBLO('TAXAS->stat',{||stat=[2]})
    ENDI
   #else
    IF stat<[2]
     REPL TAXAS->stat WITH stat=[2]
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
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
 IF R08701F9()                                     // pode imprimir?
  @ 2,000 SAY R08703BRO()                           // Montagem dos dados
 ENDI
 @ 3,023 SAY &drvpcom+[   ]+&drvtcom+R00202F9()    // Complemento
 @ 3,051 SAY &drvpcom+[N�Doc Emiss�o Valor... Circ]+&drvtcom// Titulo debitos
 @ 4,051 SAY circax1                               // circax1
 @ 5,051 SAY circax2                               // circax2
 @ 6,051 SAY circax3                               // circax3
 @ 7,004 SAY GRUPOS->nome                          // Nome
 @ 7,051 SAY circax4                               // circax4
 @ 8,051 SAY circax5                               // circax5
 @ 9,001 SAY RIGHT(GRUPOS->codigo,3)         // Codigo
 @ 9,010 SAY TRAN(GRUPOS->grupo,"!!")              // Grupo
 @ 9,015 SAY TRAN(GRUPOS->qtcircs+IIF(GRUPOS->ultcirc=circ,0,1),"999")// Qt.Circulares
 @ 9,023 SAY TRAN(emissao_,"@D")                   // Emissao
 @ 9,051 SAY circax6                               // circax6
 @ 10,051 SAY circax7                              // circax7
 vlaux=R08702F9()                                  // variavel temporaria
 @ 11,001 SAY TRAN(vlaux,"@E 999,999.99")          // Valor
 @ 11,051 SAY circax8                              // circax8
 cl=qt+11 ; pg_++
ENDI
RETU

* \\ Final de AMBRRV33.PRG
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: R00202F9.PRG
 \ Data....: 02-01-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: hist 1 do relat�rio ADM_R002
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
function r00202f9
//#include "adpbig.ch"    // inicializa constantes manifestas

 LOCAL reg_dbf1:=POINTER_DBF()
 LOCAL cipend:=0
 PUBLI circax1:=circax2:=circax3:=circax4:=[]
 PUBLI circax5:=circax6:=circax7:=circax8:=[]
 cod:=codigo
// PTAB(codigo,'TAXAS',1)
// PTAB(codigo,'GRUPOS',1)

 SELE TAXAS

 PTAB(codigo,'TAXAS',1,.t.)

 M->recvalor:=0
 DO WHILE !EOF().AND.TAXAS->codigo=cod
  IF TAXAS->valorpg>0         // Somente taxas pendentes
   SKIP
   LOOP
  ENDI
  IF TAXAS->circ=ARQGRUP->proxcirc         // Somente taxas pendentes
   SKIP
   LOOP
  ENDI
  circax1:=circax2
  circax2:=circax3
  circax3:=circax4
  circax4:=circax5
  circax5:=circax6
  circax6:=circax7
  circax7:=circax8
  circax8:=DTOC(TAXAS->emissao_)+TRANSF(TAXAS->valor,"@E 99,999.99")+;
     [ (]+TAXAS->tipo+[-]+TAXAS->circ+[)]
  M->recvalor+=TAXAS->valor
  SKIP
 ENDDO
 FOR cipend= 8 TO 1 STEP -1
  ccaux:="circax"+str(cipend,1)
  IF !EMPT(&ccaux)
   &ccaux=&drvpcom+STR(GRUPOS->qtcircs-(9-cipend),3)+[ ]+&ccaux+&drvtcom
  ENDI
 NEXT
 POINTER_DBF(reg_dbf1)

RETU []         // <- deve retornar um valor qualquer


* \\ Final de R00202F9.PRG
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

FUNC R08703BRO
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
/*
 // Bom Pastor
 detprc[contx]:=[  ]+CPRCIRC->num+[    ]+;
                TRAN(CPRCIRC->processo,'@R 99999/99/!!')+;
                [  ]+CPRCIRC->fal+[ ]+;
                CPRCIRC->ends+[     ]+LEFT(DTOC(CPRCIRC->dfal),6)+;
                right(DTOC(CPRCIRC->dfal),2)


 // Baldochi - Ribeir�o Preto
 detprc[contx]:=[CONTR.:]+CPRCIRC->num+[->Atendido: ]+CPRCIRC->fal+;
  [ em ]+DTOC(CPRCIRC->dfal)+[ ]+CPRCIRC->cids+[ Nr.Obito:]+CPRCIRC->processo

 // Geral - Padrao
 detprc[contx]:=CPRCIRC->num+[ ]+CPRCIRC->fal+[ ]+DTOC(CPRCIRC->dfal)+;
 [ ]+CPRCIRC->cids+[ ]+CPRCIRC->processo
*/
 // Brotas
 detprc[contx]:=TRAN(CPRCIRC->processo,'@R 99999/99/!!')+[  ]+;
                CPRCIRC->categ+[  ]+;
                CPRCIRC->fal+[ ]+;
                CPRCIRC->ends+[     ]+LEFT(DTOC(CPRCIRC->dfal),6)+;
                right(DTOC(CPRCIRC->dfal),2)
/*
 // Bracalente
 detprc[contx]:=CPRCIRC->num+[    ]+CPRCIRC->fal+[  ]+;
                LEFT(DTOC(CPRCIRC->dfal),6)+right(DTOC(CPRCIRC->dfal),2)
*/

 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU []      // <- deve retornar um valor qualquer

* \\ Final de R08703F9.PRG
