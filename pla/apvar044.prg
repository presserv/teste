procedure apvar044
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: APVAR044.PRG
 \ Data....: 29-10-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Cartinha
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=23, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+15 SAY " IMPRESSŽO DE COBRAN€A "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran‡a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       £ltima:             )"
 @ l_s+03,c_s+1 SAY " Circulares a emitir: N§      at‚"
 @ l_s+04,c_s+1 SAY " Cobran‡as com data entre:          e"
 @ l_s+05,c_s+1 SAY " e n§ de contrato entre:        e"
 @ l_s+07,c_s+1 SAY "         Reimprimir taxas j  impressas?"
 @ l_s+08,c_s+1 SAY "     Acumular valor das cobran‡as vencidas?"
 @ l_s+09,c_s+1 SAY "         Tipo das taxas a acumular :"
 @ l_s+10,c_s+1 SAY "     Imprimir do recibo n§      at‚ o n§"
 @ l_s+11,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Mensagens ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
 @ l_s+12,c_s+1 SAY "Cab-"
 @ l_s+13,c_s+1 SAY "Cab-"
 @ l_s+14,c_s+1 SAY "1-"
 @ l_s+15,c_s+1 SAY "2-"
 @ l_s+16,c_s+1 SAY "3-"
 @ l_s+17,c_s+1 SAY "4-"
 @ l_s+18,c_s+1 SAY "5-"
 @ l_s+19,c_s+1 SAY "6-"
 @ l_s+20,c_s+1 SAY "                   Confirme:"
ENDI
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
rpagin=0                                           // Pag.inicial
rpagfim=0                                          // Pag.final
rcab1=SPAC(79)                                     // Cab1
rcab2=SPAC(79)                                     // Cab2
rmen1=SPAC(70)                                     // Mens1
rmen2=SPAC(70)                                     // Mens2
rmen3=SPAC(70)                                     // Mens3
rmen4=SPAC(70)                                     // Mens4
rmen5=SPAC(70)                                     // Mens5
rmen6=SPAC(70)                                     // Mens6
IF FILE('PR044VAR.MEM')
 REST FROM PR044VAR ADDITIVE
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
                   MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 36 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 40 }

  @ l_s+03 ,c_s+26 GET  rproxcirc;
                   PICT "999";
                   VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.1=1~A Pr¢xima circular deve estar|lan‡ada em Tabela/Circulares")
                   DEFAULT "ARQGRUP->proxcirc"
                   AJUDA "Entre com o n£mero da pr¢xima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+03 ,c_s+35 GET  rultcirc;
                   PICT "999"
                   AJUDA "Entre com o n£mero da ultima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+04 ,c_s+28 GET  rem1_;
                   PICT "@D";
                   VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v lida.")
                   DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                   AJUDA "Data da Emiss„o da Circular.| Informe a data a considerar como inicial na emiss„o."

	@ l_s+04 ,c_s+39 GET  rem2_;
									 PICT "@D";
                   VALI CRIT("!EMPT(Rem2_)~Informe uma data v lida, deve ser posterior|a inicial")
                   DEFAULT "(DATE()+31)-DAY(DATE()+31)"
                   AJUDA "Imprimir a cobran‡a lan‡ada at‚ que data."

  @ l_s+05 ,c_s+26 GET  rcod1;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n£mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+05 ,c_s+35 GET  rcod2;
                   PICT "999999";
                   VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                   DEFAULT "[000000]"
                   AJUDA "Entre com o n£mero do contrato"
                   CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

  @ l_s+07 ,c_s+41 GET  rreimp;
                   PICT "!";
                   VALI CRIT("rreimp$[SN ]~Necess rio informar REIMPRIMIR?|Digite S ou N")
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todos os documentos|mesmo os que j  foram impressos anteriormente."

  @ l_s+08 ,c_s+45 GET  racum;
                   PICT "!";
                   VALI CRIT("racum$[SN ]~ACUMULAR? n„o aceit vel|Digite S ou N")
                   DEFAULT "[ ]"
                   AJUDA "Digite S para acumular o valor|das cobran‡as n„o pagas neste documento."

  @ l_s+09 ,c_s+38 GET  rtipo;
                   PICT "!!!";
                   VALI CRIT("!EMPT(rtipo)~Necess rio informar TIPOS A IMPRIMIR");
                   WHEN "racum='S'"
                   DEFAULT "[123]"
                   AJUDA "Digite 1 para J¢ia, 2 para cobran‡as e 3 p/Periodo"
                   CMDF8 "MTAB([111-J¢ia|222-p/Processos|333-Peri¢dico|122-J¢ia+Processos|133-J¢ia+Per¡odico|233-Processos+Peri¢dicos|123-Todos],[TIPOS A IMPRIMIR])"

  @ l_s+10 ,c_s+28 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n£mero do primeiro recibo a imprimir."

	@ l_s+10 ,c_s+42 GET  rpagfim;
									 PICT "9999"
                   AJUDA "Informe o n£mero do £ltimo recibo a imprimir."

  @ l_s+12 ,c_s+05 GET  rcab1;
                   PICT "@S45@!"

  @ l_s+13 ,c_s+05 GET  rcab2;
                   PICT "@S45@!"

  @ l_s+14 ,c_s+04 GET  rmen1;
                   PICT "@S45@!"

  @ l_s+15 ,c_s+04 GET  rmen2;
                   PICT "@S45@!"

  @ l_s+16 ,c_s+04 GET  rmen3;
                   PICT "@S45@!"

  @ l_s+17 ,c_s+04 GET  rmen4;
                   PICT "@S45@!"

  @ l_s+18 ,c_s+04 GET  rmen5;
                   PICT "@S45@!"

  @ l_s+19 ,c_s+04 GET  rmen6;
                   PICT "@S45@!"

  @ l_s+20 ,c_s+30 GET  confirme;
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

SAVE TO PR044VAR ALL LIKE R*

 #ifdef COM_REDE
	IF !USEARQ("TAXAS",.t.,10,1)                     // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+circ,"MENSAG",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 PTAB(codigo,"EMCARNE",1,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO GRUPOS->grupo+circ INTO CIRCULAR,;
          TO codigo+circ INTO MENSAG,;
          TO codigo+tipo+circ INTO CSTSEG,;
          TO codigo INTO EMCARNE,;
          TO EMCARNE->tip INTO TCARNES
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="tipo+codigo+circ"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,63,11)          // nao quis configurar...
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
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=65                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
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
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		impctl(drvtcom)
		@ cl,000 SAY REPL("=",79)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
 //   IF R08701F9()                                  // pode imprimir?
		 @ cl,000 SAY R08703F9()                       // Montagem dos dados
//    ENDI
    @ cl,016 SAY "Conforme dispoe a Clausula DECIMA do contrato, estamos"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "participando a V.Sa. os obitos ocorridos:"
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY "NOME                   DATA DE FALEC.           CONTRATO"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[1]                         // det1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[2]                         // det2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[3]                         // det3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[4]                         // det4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[5]                         // det5
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[6]                         // det6
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[7]                         // det7
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[8]                         // det8
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY detprc[9]                         // det9
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY detprc[10]                        // det10
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,016 SAY "Assim sendo, solicitamos a V.Sa., o pagamento destinado ao"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "FUNDO COMUM DE ATENDIMENTO FUNERARIO."
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY REPL("-",79)
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,018 SAY "VALOR A PAGAR      ="
		valororig=R08702F9()                           // variavel temporaria
		@ cl,041 SAY TRAN(valororig,"@E 999,999.99")   // Valor Taxa
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,016 SAY "ATE DIA"
		@ cl,024 SAY TRAN(emissao_,"@D")               // Vencimento
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,007 SAY "APOS O VENCIMENTO, SERA ACRESCIDO DE JUROS DE 5% AO MES,"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,007 SAY "CONFORME A VARIACAO DA INFLACAO."
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY REPL("-",79)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(M->rmen1,"@!")               // Mens1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(M->rmen2,"@!")               // Mens2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(M->rmen3,"@!")               // Mens3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(M->rmen4,"@!")               // Mens4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(M->rmen5,"@!")               // Mens5
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY TRAN(M->rmen6,"@!")               // Mens6
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",79)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Contrato"
    @ cl,011 SAY GRUPOS->grupo+'  '+GRUPOS->codigo // Codigo 2
    @ cl,023 SAY "Titular.:"
    @ cl,034 SAY GRUPOS->nome                      // Nome
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Endere‡o:",cl,023)
    @ cl,034 SAY GRUPOS->endereco                  // Endere‡o
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,020 SAY GRUPOS->bairro                    // Bairro
		@ cl,041 SAY GRUPOS->cidade                    // Cidade
    @ cl,067 SAY TRAN(GRUPOS->uf,"!!")             // UF
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("------------- D‚bitos anteriores -------------------+--------------------------",cl,000)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY detdeb[1]+[ ]+detdeb[6]           // deb1
    @ cl,052 SAY "|   Vencimento"
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY detdeb[2]+[ ]+detdeb[7]           // deb2
    @ cl,052 SAY "|"
    IMPEXP(cl,056,TRAN(TAXAS->emissao_,"@D"),16)   // Vencto 1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY detdeb[3]+[ ]+detdeb[8]           // deb3
    @ cl,052 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY detdeb[4]+[ ]+detdeb[9]           // deb4
    @ cl,052 SAY "|   Valor"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY detdeb[5]+[ ]+detdeb[10]          // deb5
		@ cl,052 SAY "|"
    IMPEXP(cl,056,TRAN(valororig+vlseg,"@E 999,999.99"),20)// Valor 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "---------------------------- 1.Via - Contribuinte -----------------------------"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Autenticacao"
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",79)
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY M->setup1                         // Ident1
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY M->setup2                         // Ident2
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY "Contrato:"
		@ cl,011 SAY GRUPOS->grupo+'  '+GRUPOS->codigo // Codigo 3
		@ cl,022 SAY "Titular.:"
		@ cl,032 SAY LEFT(GRUPOS->nome,30)             // Nome
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY "Numero..:"
		@ cl,015 SAY TAXAS->tipo+[  ]+TAXAS->circ// N§ 2
		@ cl,022 SAY "Vencimento:"
		@ cl,034 SAY TRAN(TAXAS->emissao_,"@D")        // Vencto 2
		@ cl,045 SAY "Valor:"
		@ cl,052 SAY TRAN(valororig+vlseg,"@E 999,999.99")// Valor 2
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,66}},10,6)
		ENDI
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,001 SAY "Debitos.:"
		@ cl,011 SAY LEFT(M->lindeb,50)                // debitos
		IF M->combarra=[S]
		 CODBARRAS({{codigo+tipo+circ,4,13,66}},10,6)
		ENDI
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "---------------------------- 2.Via - Caixa ------------------------------------"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY "Autenticacao"
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY REPL("-",79)

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
IMPCTL(drvtcom)                                    // retira comprimido
SET MARG TO                                        // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(63)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|CARTINHA"
ALERTA()
op_=2 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TAXAS                                        // processamentos apos emissao
 IF so_um_reg
  GO imp_reg
 ELSE
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
 ENDI
 DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN())
  IF (R08701F9()) .OR. so_um_reg                   // se atender a condicao...

	 #ifdef COM_REDE
		IF TCARNES->parf=VAL(TAXAS->circ).AND.EMPT(EMCARNE->emissao_).AND.tipo$'16'
		 REPBLO('EMCARNE->emissao_',{||DATE()})
		ENDI
		IF stat < [2]
		 REPBLO('TAXAS->stat',{||[2]})
		ENDI
	 #else
		IF TCARNES->parf=VAL(TAXAS->circ).AND.EMPT(EMCARNE->emissao_).AND.tipo$'16'
		 REPL EMCARNE->emissao_ WITH DATE()
		ENDI
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
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPEXP(0,000,M->setup1,80)                        // Ident1
 impctl(drvtcom)
 @ 1,000 SAY LEFT(ALLTRIM(M->setup2)+[ ]+M->setup3,79)// Ident2
 @ 2,000 SAY TRAN(M->rcab1,"@!")                   // Cab1
 @ 3,000 SAY TRAN(M->rcab2,"@!")                   // Cab2
 cl=qt+3 ; pg_++
ENDI
RETU

* \\ Final de APVAR044.PRG
