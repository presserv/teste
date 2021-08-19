procedure apder044
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_R044.PRG
 \ Data....: 01-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Peri¢dico
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=4, c_s:=1, l_i:=20, c_i:=79, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
// Preparados em R08701F9()
vlout:=vlseg:=valororig:=0  // Composi‡„o do valor
lindeb:=[]  // Linha resumo dos d‚bitos (Tipo+circ ...)
decl detdeb[10] // Detalhamento dos d‚bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
ultprc:=[]  // Ultima cartinha montada, se for igual n„o refaz...
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
@ l_s,c_s+28 SAY " IMPRESSŽO DE COBRAN€A "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Tipo da Cobran‡a:                             ÚÄÄÄÄÄÄÄÄ Mensagem ÄÄÄÄÄÄÄÄÄÄ¿"
@ l_s+02,c_s+1 SAY " Grupo:     (      -       £lt.:             ) ³                            ³"
@ l_s+03,c_s+1 SAY "                                               ³                            ³"
@ l_s+04,c_s+1 SAY " Circulares a emitir: N§      at‚              ³                            ³"
@ l_s+05,c_s+1 SAY " Cobran‡as  entre:                             ³                            ³"
@ l_s+06,c_s+1 SAY " e n§ de contrato entre:        e              ³                            ³"
@ l_s+07,c_s+1 SAY "                                               ³                            ³"
@ l_s+08,c_s+1 SAY "         Reimprimir taxas j  impressas?        ³                            ³"
@ l_s+09,c_s+1 SAY "     Acumular valor das cobran‡as vencidas?    ³                            ³"
@ l_s+10,c_s+1 SAY "         Tipo das taxas a acumular :           ³                            ³"
@ l_s+11,c_s+1 SAY "                                               ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
@ l_s+12,c_s+1 SAY " Local de Pagamento:"
@ l_s+14,c_s+1 SAY " Imprimir os recibos do n£mero      at‚"
@ l_s+15,c_s+1 SAY "                                 Confirme:"
rtp=SPAC(1)                                        // Tipo
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
rultcirc=SPAC(3)                                   // N§Ultima Circ.
rem1_=CTOD('')                                     // Emiss„o
rem2_=CTOD('')                                     // Emiss„o
rcod1=SPAC(6)                                      // Contrato
rcod2=SPAC(6)                                      // Contrato
rreimp=SPAC(1)                                     // Reimprimir?
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rmens1=SPAC(28)                                    // Mens1
rmens2=SPAC(28)                                    // Mens2
rmens3=SPAC(28)                                    // Mens3
rmens4=SPAC(28)                                    // Mens4
rmens5=SPAC(28)                                    // Mens5
rmens6=SPAC(28)                                    // Mens6
rmens7=SPAC(28)                                    // Mens7
rmens8=SPAC(28)                                    // Mens8
rmens9=SPAC(28)                                    // Mens9
rlocpg1=SPAC(50)                                   // Rlocpg1
rlocpg2=SPAC(50)                                   // Rlocpg1
rpagin=0                                           // Pag.inicial
rpagfim=0                                          // Pag.final
confirme=SPAC(1)                                   // Confirme
IF FILE('PRP44VAR.MEM')
 REST FROM PRp44VAR ADDITIVE
ENDI
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+20 GET  rtp;
                  PICT "!";
                  VALI CRIT("rtp $ [123]~TIPO n„o aceit vel");
                  WHEN "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"
                  DEFAULT "[3]"
                  AJUDA "Qual o tipo de cobran‡a a imprimir neste impresso."
                  CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"

 @ l_s+02 ,c_s+09 GET  rgrupo;
                  PICT "!!";
                  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(rgrupo)~GRUPO n„o existe na tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
									MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 14 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 21 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 34 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 38 }

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

 @ l_s+05 ,c_s+20 GET  rem1_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v lida.")
                  DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                  AJUDA "Data da Emiss„o da Circular.| Informe a data a considerar como inicial na emiss„o."

 @ l_s+05 ,c_s+31 GET  rem2_;
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

 @ l_s+02 ,c_s+49 GET  rmens1
									AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+03 ,c_s+49 GET  rmens2
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+04 ,c_s+49 GET  rmens3
									AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+05 ,c_s+49 GET  rmens4
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+06 ,c_s+49 GET  rmens5
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+07 ,c_s+49 GET  rmens6
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+08 ,c_s+49 GET  rmens7
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+09 ,c_s+49 GET  rmens8
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+10 ,c_s+49 GET  rmens9
                  AJUDA "Informe a mensagem do recibo|de cobran‡a"

 @ l_s+12 ,c_s+22 GET  rlocpg1;
                  PICT "@!"

 @ l_s+13 ,c_s+22 GET  rlocpg2;
                  PICT "@!"

 @ l_s+14 ,c_s+32 GET  rpagin;
                  PICT "9999"
                  AJUDA "Informe o n£mero do primeiro recibo a imprimir."

 @ l_s+14 ,c_s+41 GET  rpagfim;
		              PICT "9999"
		               AJUDA "Informe o n£mero do £ltimo recibo a imprimir."

 @ l_s+15 ,c_s+44 GET  confirme;
									PICT "!";
									VALI CRIT("confirme='S'.AND.V87001F9()~CONFIRME n„o aceit vel")
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
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
	CLOSE ALL                                        // fecha todos arquivos abertos
	RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_076=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_076:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
SAVE TO PRP44VAR ALL LIKE R*
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=74                                           // maximo de linhas no relatorio
IMPCTL(lpp_076)                                    // seta pagina com 76 linhas
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
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
	 IF R08701F9()                                   // se atender a condicao...
		IF (pg_<M->rpagin .OR.pg_>M->rpagfim).AND.!so_um_reg
		 pg_++
		 SKIP
		 LOOP
		ENDI
		REL_CAB(6)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY GRUPOS->nome                      // Nome
		IMPCTL(drvpenf)
		@ cl,053 SAY GRUPOS->codigo+[ ]+GRUPOS->grupo  // Codigo
		IMPCTL(drvtenf)
		IMPCTL(drvpcom)
		@ cl,067 SAY LEFT(CLASSES->descricao,20)       // definicao 1
		IMPCTL(drvtcom)
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpenf)
		@ cl,003 SAY SUBSTR(DTOC(emissao_-DAY(emissao_)),4)
//		@ cl,003 SAY tipo+[-]+circ                     // compl.codigo 1
		IMPCTL(drvtenf)
		@ cl,014 SAY TRAN(emissao_,"@D")               // Emissao
		valororig=R08702F9() //+vlseg-vlcst               // variavel temporaria
		@ cl,028 SAY TRAN(valororig,"@E 999,999.99")  // Valor Contribuicao
		@ cl,040 SAY TRAN(vlseg,"@E 999,999.99")       // Valor Seguro
		@ cl,053 SAY TRAN(vlcst,"@E 999,999.99")// Valor Locacao
		@ cl,069 SAY TRAN(valororig+vlcst+vlseg+vlout,"@E 999,999.99")// Valor
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY &drvpcom+[   Data    Descricao                           Valor]+&drvtcom// titulo custos
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[1]                         // cst01
		@ cl,051 SAY M->rmens1                         // Mens1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[2]                         // cst02
		@ cl,051 SAY M->rmens2                         // Mens2
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[3]                         // cst03
		@ cl,051 SAY M->rmens3                         // Mens3
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[4]                         // cst04
		@ cl,051 SAY M->rmens4                         // Mens4
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[5]                         // cst05
		@ cl,051 SAY M->rmens5                         // Mens5
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[6]                         // cst06
		@ cl,051 SAY M->rmens6                         // Mens6
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[7]                         // cst07
		@ cl,051 SAY M->rmens7                         // Mens7
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[8]                         // cst08
		@ cl,051 SAY M->rmens8                         // Mens8
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[9]                         // cst09
		@ cl,051 SAY M->rmens9                         // Mens9
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,005 SAY detcst[10]                        // cst10
		REL_CAB(7)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY TRAN(M->rlocpg1,"@!")             // Rlocpg1
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,66}},10,6)
		ENDI

		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY TRAN(M->rlocpg2,"@!")             // Rlocpg2
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,66}},10,6)
		ENDI

		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[1]                         // csr01
		@ cl,070 SAY tipo+[-]+circ                     // compl.codigo 1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[02]                        // csr02
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpcom)
		@ cl,000 SAY LEFT(CLASSES->descricao,20)       // definicao 2
		IMPCTL(drvtcom)
		IMPCTL(drvpenf)
		@ cl,012 SAY GRUPOS->codigo                    // Codigo 2
		IMPCTL(drvtenf)
		@ cl,024 SAY detcst[03]                        // csr03
		IMPCTL(drvpcom)
		@ cl,085 SAY LEFT(CLASSES->descricao,20)       // definicao 3
		IMPCTL(drvtcom)
		@ cl,072 SAY GRUPOS->codigo                    // Codigo 3
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[04]                        // csr04
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY LEFT(DTOC(DATE()),6)+RIGHT(DTOC(DATE()),2)// data
		@ cl,012 SAY LEFT(DTOC(emissao_),6)+RIGHT(DTOC(emissao_),2)// Emissao 2
		@ cl,024 SAY detcst[05]                        // csr05
		@ cl,060 SAY LEFT(DTOC(DATE()),6)+RIGHT(DTOC(DATE()),2)// data
		@ cl,071 SAY LEFT(DTOC(emissao_),6)+RIGHT(DTOC(emissao_),2)// Emissao_ 3
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[06]                        // csr06
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,008 SAY TRAN(valororig+vlcst+vlseg+vlout,"@E 999,999.99")// Valor
		@ cl,024 SAY detcst[07]                        // csr07
		@ cl,068 SAY TRAN(valororig+vlcst+vlseg+vlout,"@E 999,999.99")// Valor
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[08]                        // csr08
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[09]                        // csr09
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,024 SAY detcst[10]                        // csr10
		REL_CAB(14)                                    // soma cl/imprime cabecalho
		@ cl,016 SAY GRUPOS->nome                      // Nome 2
		IMPCTL(drvpenf)
		@ cl,068 SAY tipo+[-]+circ                     // compl.codigo 2
		IMPCTL(drvtenf)
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,016 SAY GRUPOS->endereco                  // Endere‡o
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
msgt="PROCESSAMENTOS DO RELAT¢RIO|PERI¢DICO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TAXAS                                        // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  IF R08701F9()                                    // se atender a condicao...

   #ifdef COM_REDE
    IF stat < [2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI
   #else
    IF stat < [2]
		 REPL TAXAS->stat WITH [2]
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
