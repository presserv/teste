procedure adm_rn33
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADP_R044.PRG
 \ Data....: 01-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Peri�dico
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=4, c_s:=1, l_i:=21, c_i:=79, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
// Preparados em R08701F9()
vlaux:=vlseg:=valororig:=0  // Composi��o do valor
lindeb:=[]  // Linha resumo dos d�bitos (Tipo+circ ...)
decl detdeb[10] // Detalhamento dos d�bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
ultprc:=[]  // Ultima cartinha montada, se for igual n�o refaz...
decl detprc[10] // Cartinha dos falecidos
afill(detprc,[])
contar:=.t.
contx :=0

// Custos adicionais
vlcst:=0
decl detcst[10]
afill(detcst,[])

nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+28 SAY " IMPRESS�O DE COBRAN�A "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Tipo da Cobran�a:                             ��������� Mensagem ���������Ŀ"
@ l_s+02,c_s+1 SAY " Grupo:     (      -       �lt.:             ) �                            �"
@ l_s+03,c_s+1 SAY "                                               �                            �"
@ l_s+04,c_s+1 SAY " Circulares a emitir: N�      at�              �                            �"
@ l_s+05,c_s+1 SAY " Cobran�as  entre:                             �                            �"
@ l_s+06,c_s+1 SAY " e n� de contrato entre:        e              �                            �"
@ l_s+07,c_s+1 SAY " Pendentes: M�nimo:     M�ximo.:               �                            �"
@ l_s+08,c_s+1 SAY "         Reimprimir taxas j� impressas?        �                            �"
@ l_s+09,c_s+1 SAY "     Acumular valor das cobran�as vencidas?    �                            �"
@ l_s+10,c_s+1 SAY "         Tipo das taxas a acumular :           �                            �"
@ l_s+11,c_s+1 SAY "                                               ������������������������������"
@ l_s+12,c_s+1 SAY "     Instrucoes ...:"
@ l_s+15,c_s+1 SAY " Imprimir os recibos do n�mero      at�"
@ l_s+16,c_s+1 SAY "                                 Confirme:"
rtp=SPAC(1)                                        // Tipo
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
rcod1=SPAC(6)                                      // Contrato
rcod2=SPAC(6)                                      // Contrato
rpend:=rpendx:=0                                 // Pag.final
rreimp=SPAC(1)                                     // Reimprimir?
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rmens1=SPAC(50)                                    // Mens1
rmens2=SPAC(50)                                    // Mens2
rmens3=SPAC(50)                                    // Mens3
rmens4=SPAC(50)                                    // Mens4
rmens5=SPAC(50)                                    // Mens5
rmens6=SPAC(50)                                    // Mens6
rmens7=SPAC(50)                                    // Mens7
rmens8=SPAC(50)                                    // Mens8
rmens9=SPAC(50)                                    // Mens9
rlocpg1=SPAC(33)                                   // Rlocpg1
rlocpg2=SPAC(33)                                  // Rlocpg1
rlocpg3=SPAC(33)                                   // Rlocpg1
rpagin=0                                           // Pag.inicial
rpagfim=0                                          // Pag.final
confirme=SPAC(1)                                   // Confirme
IF FILE('PRV33VAR.MEM')
 REST FROM PRV33VAR ADDITIVE
ENDI
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+20 GET  rtp;
                  PICT "!";
                  VALI CRIT("rtp $ [ 123]~TIPO n�o aceit�vel")
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
                  MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 34 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 38 }

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
/*
 @ l_s+05 ,c_s+20 GET  rem1_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v�lida.")
                  DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                  AJUDA "Data da Emiss�o da Circular.| Informe a data a considerar como inicial na emiss�o."
*/
 @ l_s+05 ,c_s+31 GET  rem2_;
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


 @ l_s+07 ,c_s+21 GET  rpend;
									PICT "99";
									VALI CRIT("rpend>0~NRPEND n�o aceit�vel")
									DEFAULT "1"
									AJUDA "Informe o n�mero m�nimo de taxas|pendentes para listar"

 @ l_s+07 ,c_s+34 GET  rpendx;
									PICT "99";
									VALI CRIT("rpendx>=rpend~NRPEND n�o aceit�vel")
									DEFAULT "3"
									AJUDA "Informe o n�mero m�ximo de taxas|pendentes para listar"

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

 @ l_s+02 ,c_s+49 GET  rmens1;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+03 ,c_s+49 GET  rmens2;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+04 ,c_s+49 GET  rmens3;
                  PICT "@S28"
									AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+05 ,c_s+49 GET  rmens4;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+06 ,c_s+49 GET  rmens5;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+07 ,c_s+49 GET  rmens6;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+08 ,c_s+49 GET  rmens7;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+09 ,c_s+49 GET  rmens8;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+10 ,c_s+49 GET  rmens9;
                  PICT "@S28"
                  AJUDA "Informe a mensagem do recibo|de cobran�a"

 @ l_s+12 ,c_s+22 GET  rlocpg1

 @ l_s+13 ,c_s+22 GET  rlocpg2

 @ l_s+14 ,c_s+22 GET  rlocpg3

 @ l_s+15 ,c_s+32 GET  rpagin;
                  PICT "9999"
                  AJUDA "Informe o n�mero do primeiro recibo a imprimir."

 @ l_s+15 ,c_s+41 GET  rpagfim;
									PICT "9999"
									AJUDA "Informe o n�mero do �ltimo recibo a imprimir."

 @ l_s+16 ,c_s+44 GET  confirme;
									PICT "!";
									VALI CRIT("confirme='S'.AND.V87001F9()~CONFIRME n�o aceit�vel")
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

 SAVE TO PRV33VAR ALL LIKE R*

 #ifdef COM_REDE
	IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(M->mgrupvip+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO M->mgrupvip+circ INTO CIRCULAR,;
          TO codigo+tipo+circ INTO CSTSEG
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,33,11)           // nao quis configurar...
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
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura��o do tamanho da p�gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
	CLOSE ALL                                        // fecha todos arquivos abertos
	RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_076=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_076:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe| | ",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=74                                           // maximo de linhas no relatorio
IMPCTL(lpp_076)                                    // seta pagina com 76 linhas
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
veni_:=M->rem1_
venf_:=M->rem2_
mchave:=[]
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
	INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF M->rcod1>[000000]
   SEEK M->rcod1
  ENDI
	ccop++                                           // incrementa contador de copias
	DO WHIL !EOF().AND.(M->rcod2=[000000].or.codigo<=M->rcod2)
	 #ifdef COM_TUTOR
		IF IN_KEY()=K_ESC                              // se quer cancelar
	 #else
		IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   SET DEVI TO SCRE                                // inicia a impressao
   @ 17,35 say codigo+tipo+circ
   @ 18,35 say pg_

   SET DEVI TO PRIN                                // inicia a impressao

   IF R087X1F9()                                   // se atender a condicao...
    qr076x1f9:=R076X1F9()
    IF qR076X1F9 < M->rpend .or. qR076X1F9 > M->rpendx
     SEEK MCHAVE
     SKIP
     LOOP
    ENDI
    SEEK MCHAVE

		IF (pg_<M->rpagin .OR.pg_>M->rpagfim)//.AND.!so_um_reg
     pg_++
     SKIP
     LOOP
    ENDI
		valororig=R087X2F9()+vlseg-vlcst               // variavel temporaria
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,004 SAY GRUPOS->nome                      // Nome
		IMPCTL(drvpenf)
		@ cl,048 SAY GRUPOS->codigo+[ ]+GRUPOS->grupo  // Codigo
		IMPCTL(drvtenf)
		IMPCTL(drvpcom)
		@ cl,062 SAY LEFT(CLASSES->descricao,28)       // definicao 1
		IMPCTL(drvtcom)
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpenf)
		@ cl,004 SAY SUBSTR(DTOC(emissao_-DAY(emissao_)),4)
//		@ cl,003 SAY tipo+[-]+circ                     // compl.codigo 1
		IMPCTL(drvtenf)
/*
		@ cl,014 SAY TRAN(emissao_,"@D")               // Emissao
		@ cl,028 SAY TRAN(valororig,"@E 999,999.99")  // Valor Contribuicao
		@ cl,040 SAY TRAN(vlseg,"@E 999,999.99")       // Valor Seguro
		@ cl,053 SAY TRAN(vlcst - vlseg,"@E 999,999.99")// Valor Locacao
		@ cl,069 SAY TRAN(valororig+vlcst,"@E 999,999.99")// Valor
*/
		REL_CAB(2)                                     // soma cl/imprime cabecalho
 //		@ cl,005 SAY &drvpcom+[   Data    Descricao                           Valor]+&drvtcom// titulo custos
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens1                         // Mens1
		@ cl,052 SAY detdeb[1]                         // cst01
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens2                         // Mens2
    @ cl,052 SAY detdeb[2]                         // cst02
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens3                         // Mens3
    @ cl,052 SAY detdeb[3]                         // cst03
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens4                         // Mens4
    @ cl,052 SAY detdeb[4]                         // cst04
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens5                         // Mens5
		@ cl,052 SAY detdeb[5]                         // cst05
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens6                         // Mens6
    @ cl,052 SAY detdeb[6]                         // cst06
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens7                         // Mens7
    @ cl,052 SAY detdeb[7]                         // cst07
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens8                         // Mens8
		@ cl,052 SAY detdeb[8]                         // cst08
    REL_CAb(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens9                         // Mens9
    @ cl,052 SAY detdeb[9]                         // cst09
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,052 SAY detdeb[10]                        // cst10
		REL_CAB(7)                                     // soma cl/imprime cabecalho

		REL_CAB(1)                                     // soma cl/imprime cabecalho

		REL_CAB(2)                                     // soma cl/imprime cabecalho
//@ cl,070 SAY tipo+[-]+circ                     // compl.codigo 1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,026 SAY GRUPOS->endereco                  // Endere�o
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpcom)
		@ cl,008 SAY LEFT(CLASSES->descricao,20)       // definicao 2
		IMPCTL(drvtcom)
		IMPCTL(drvpenf)
		@ cl,017 SAY GRUPOS->codigo                    // Codigo 2
		IMPCTL(drvtenf)
		@ cl,026 SAY GRUPOS->nome                  // Endere�o
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,004 SAY SUBSTR(DTOC(emissao_-DAY(emissao_)),4)
    @ cl,014 SAY SUBSTR(DTOC(emissao_),4)//LEFT(DTOC(emissao_),6)+RIGHT(DTOC(emissao_),2)// Emissao 2
		IMPCTL(drvpenf)
		@ cl,026 SAY GRUPOS->codigo+[ ]+GRUPOS->grupo  // Codigo
		IMPCTL(drvtenf)
		@ cl,060 SAY SUBSTR(DTOC(emissao_-DAY(emissao_)),4)
    @ cl,071 SAY SUBSTR(DTOC(emissao_),4)//LEFT(DTOC(emissao_),6)+RIGHT(DTOC(emissao_),2)// Emissao_ 3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY TRAN(valororig+vlcst,"@E 999,999.99")// Valor
		@ cl,025 SAY M->rlocpg1             // Rlocpg1
    @ cl,058 SAY TRAN(valororig+vlcst,"@E 999,999.99")// Valor
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,025 SAY M->rlocpg2             // Rlocpg2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,025 SAY M->rlocpg3             // Rlocpg3
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,60}},10,6)
		ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,60}},10,6)
		ENDI
		REL_CAB(16)                                    // soma cl/imprime cabecalho
		@ cl,016 SAY GRUPOS->nome                      // Nome 2
		IMPCTL(drvpenf)
		@ cl,061 SAY codigo+[-]+tipo+[-]+circ                     // compl.codigo 2
		IMPCTL(drvtenf)
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,016 SAY GRUPOS->endereco                  // Endere�o
		@ cl,052 SAY GRUPOS->bairro                    // Bairro
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,016 SAY GRUPOS->cep+[ ]+ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf// Cidade
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,068 SAY TRAN(pg_-1,"99999")                 // pagina
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
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(33)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 cl=qt+1 ; pg_++
ENDI
RETU

* \\ Final de ADP_R044.PRG

/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: R087X1F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Express�o de filtro do relat�rio ADP_R087.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
FUNCT R087X1F9
donex:=V87001F9()
DO CASE
CASE valorpg>0 // J� paga, tchau!!!
 donex:=.f.
CASE !(M->rtp$tipo+[ ]) //N�o � meu tipo!!! (especifico ou todos)
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
//CASE TAXAS->emissao_< M->rem1_.OR.TAXAS->emissao_>M->rem2_
CASE TAXAS->emissao_>M->rem2_
 donex:=.f.
OTHERWISE
 donex:=.t.
ENDCASE

RETU  M->donex     // <- deve retornar um valor L�GICO

* \\ Final de R087X1F9.PRG


/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: R087X2F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valor Total do relat�rio ADP_R087
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
FUNC R087X2F9

 LOCAL reg_dbf1:=POINTER_DBF()
 cod:=codigo     // C�digo da taxa a imprimir
 emx:=emissao_+1   // Emiss�o da taxa a ser impressa...
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

 DO WHILE !EOF().AND.TAXAS->codigo=cod.AND.M->racum=[S]
	IF TAXAS->valorpg>0         // Somente taxas pendentes
	 SKIP
	 LOOP
	ENDI

// Ser�o consideradas vencidas as taxas anteriores a emiss�o da
// que ser� impressa.

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

   IF TAXAS->emissao_ < emx // detalha somente as taxas atrasadas.
    contx+=1
    IF CONTX<11             // as ultimas 10 parcelas
	  	detdeb[contx]:=TAXAS->tipo+[ ]+TAXAS->circ+[ ]+;
       LEFT(DTOC(TAXAS->emissao_),6)+RIGHT(DTOC(TAXAS->emissao_),2)+[ ]+;
	  	TRANSF(TAXAS->valor,"@E 9,999.99")  //+[ | ]

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

* \\ Final de R087X2F9.PRG
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: R07601F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora -CR�D/COBRAN�A
 \ Funcao..: Condi��o de impress�o do campo Codigo, arquivo ADC_R076
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

FUNC R076X1F9
LOCAL reg_dbf:=POINTER_DBF(), ct_tx:=0

//PTAB(codigo,[TAXAS],1,.T.)
SELE TAXAS
mchave:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
COD_X:=CODIGO
impok:=EMPT(M->veni_)  //Imprimir se n�o pedir data inicial
ct_tx:=0
DO WHILE !EOF() .AND. TAXAS->codigo=COD_X //GRUPOS->codigo //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0
	SKIP
	LOOP
 ENDI
 IF TAXAS->emissao_ <= IIF(EMPT(M->venf_),DATE(),M->venf_)
	ct_tx++
	impok:=impok.or.(TAXAS->emissao_ >= M->veni_)   // S� vamos imprimir se existir uma
  mchave:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
 ENDI
 SKIP
ENDDO

ct_tx:=IIF(impok,ct_tx,0)  // Se n�o � para imprimir, vamos desconsiderar
													 // a contagem efetuada.
POINTER_DBF(reg_dbf)

RETU ct_tx       // <- deve retornar um valor L�GICO

* \\ Final de R07601F9.PRG
