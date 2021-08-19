procedure adp_r0~1
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind�stria de Urnas Bignotto Ltda
 \ Programa: ADP_RF87.PRG
 \ Data....: 01-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Emiss�o Unibanco
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADPbig.ch"    // inicializa constantes manifestas
PARA  lin_menu, col_menu, imp_reg, mcodaux
so_um_reg=(PCOU()>2)
opc_04=2
v04=SAVESCREEN(0,0,MAXROW(),79)
DO WHIL opc_04!=0
 cod_sos=4
 RESTSCREEN(0,0,MAXROW(),79,v04)
 menu04="UNIBANCO|"+;
        "BANESPA/Am.do Sul"
 msgt="Modelo de Boleto"
 opc_04=DBOX(menu04,5,39,E_MENU,NAO_APAGA,msgt,,,opc_04)
 DO CASE
  CASE opc_04=1     // Unibanco
   IF PCOU()=4
    ADP_R087X(lin_menu, col_menu,imp_reg, mcodaux)
   ELSEIF PCOU()=3
    ADP_R087X(lin_menu, col_menu,imp_reg)
   ELSE
    ADP_R087X(lin_menu, col_menu)
   ENDI
  CASE opc_04=2     // Banespa
   IF PCOU()=4
    ADP_RC87(lin_menu, col_menu,imp_reg, mcodaux)
   ELSEIF PCOU()=3
    ADP_RC87(lin_menu, col_menu,imp_reg)
   ELSE
    ADP_RC87(lin_menu, col_menu)
   ENDI

 ENDC
 CLEA GETS
ENDD
 RESTSCREEN(0,0,MAXROW(),79,v04)
retu

proc adp_r087x
LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg, mcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=23, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
V87001F9()  // Monta variaveis publicas...
so_um_reg=(PCOU()>2)
IF .T. //!so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+10 SAY " IMPRESS�O DE COBRAN�A UNIBANCO"
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran�a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       �ltima:             )"
 @ l_s+03,c_s+1 SAY " Circulares a emitir: N�      at�"
 @ l_s+04,c_s+1 SAY " Cobran�as com data entre:          e"
 @ l_s+05,c_s+1 SAY " e n� de contrato entre:        e"
 @ l_s+06,c_s+1 SAY "         Reimprimir taxas j� impressas?"
 @ l_s+07,c_s+1 SAY "     Acumular valor das cobran�as vencidas?"
 @ l_s+08,c_s+1 SAY "         Tipo das taxas a acumular :"
 @ l_s+09,c_s+1 SAY " Banco:"
 @ l_s+10,c_s+1 SAY " Mens1:"
 @ l_s+11,c_s+1 SAY " Mens2:"
 @ l_s+12,c_s+1 SAY " Mens3:"
 @ l_s+13,c_s+1 SAY " Mens4:"
 @ l_s+14,c_s+1 SAY " Mens5:"
 @ l_s+15,c_s+1 SAY " Mens6:"
 @ l_s+16,c_s+1 SAY " Mens7:"
 @ l_s+17,c_s+1 SAY " Mens8:"
 @ l_s+18,c_s+1 SAY " N�mero do primeiro boleto:"
 @ l_s+19,c_s+1 SAY " Imprimir do recibo n�      at� o n�"
 @ l_s+20,c_s+1 SAY "                   Confirme:"
ENDI
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
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
rlocpgto=SPAC(40)                                  // Local de Pagamento
rmens1=SPAC(40)                                    // Mensagem
rmens2=SPAC(40)                                    // Mensagem
rmens3=SPAC(40)                                    // Mensagem
rmens4=SPAC(40)                                    // Mensagem
rmens5=SPAC(40)                                    // Mensagem
rmens6=SPAC(40)                                    // Mensagem
rmens7=SPAC(40)                                    // Mensagem
rmens8=SPAC(40)                                    // Mensagem
rnnum=SPAC(10)                                     // N.N�mero
rpagin=1                                           // Pag.inicial
rpagfim=9999                                          // Pag.final
confirme=SPAC(1)                                   // Confirme
IF FILE('PR087VAR.MEM')//.and.!so_um_reg
 REST FROM PR087VAR ADDITIVE
ENDI
IF PCOU()=3
 mcodaux:=codigo+tipo+circ
 rcod1:=rcod2:=mcodaux
ELSEIF PCOU()=4
 rcod1:=rcod2:=mcodaux
ENDI

DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF .T. //!so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+20 GET  rtp;
                   PICT "9"
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

  @ l_s+06 ,c_s+41 GET  rreimp;
                   PICT "!";
                   VALI CRIT("rreimp$[SN ]~Necess�rio informar REIMPRIMIR?|Digite S ou N")
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todos os documentos|mesmo os que j� foram impressos anteriormente."

  @ l_s+07 ,c_s+45 GET  racum;
                   PICT "!";
                   VALI CRIT("racum$[SN ]~ACUMULAR? n�o aceit�vel|Digite S ou N")
                   DEFAULT "[ ]"
                   AJUDA "Digite S para acumular o valor|das cobran�as n�o pagas neste documento."

  @ l_s+08 ,c_s+38 GET  rtipo;
                   PICT "!!!";
                   VALI CRIT("!EMPT(rtipo)~Necess�rio informar TIPOS A IMPRIMIR");
                   WHEN "racum='S'"
                   DEFAULT "[123]"
                   AJUDA "Digite 1 para J�ia, 2 para cobran�as e 3 p/Periodo"
                   CMDF8 "MTAB([111-J�ia|222-p/Processos|333-Peri�dico|122-J�ia+Processos|133-J�ia+Per�odico|233-Processos+Peri�dicos|123-Todos],[TIPOS A IMPRIMIR])"

  IF so_um_reg
   CLEAR GETS
  ENDI

  @ l_s+09 ,c_s+09 GET  rlocpgto
                   AJUDA "Informe o local de Pagamento que|ser� impresso no boleto banc�rio"

  @ l_s+10 ,c_s+09 GET  rmens1
                   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc,40),[])"
                   AJUDA "Entre com a primeira linha de mensagem|a ser impressa no boleto"

  @ l_s+11 ,c_s+09 GET  rmens2
		   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,SUBSTR(CIRCULAR->menscirc,41),[])"
                   AJUDA "Entre com a Segunda linha de mensagem|a ser impressa no boleto"

  @ l_s+12 ,c_s+09 GET  rmens3
                   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc1,40),[])"
                   AJUDA "Entre com a terceira linha de mensagem|a ser impressa no boleto"

  @ l_s+13 ,c_s+09 GET  rmens4
                   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc2,40),[])"
                   AJUDA "Entre com a quarta linha de mensagem|a ser impressa no boleto"

  @ l_s+14 ,c_s+09 GET  rmens5
                   AJUDA "Entre com a quinta linha de mensagem|a ser impressa no boleto"

  @ l_s+15 ,c_s+09 GET  rmens6
                   AJUDA "Entre com a sexta linha de mensagem|a ser impressa no boleto"

  @ l_s+16 ,c_s+09 GET  rmens7
                   AJUDA "Entre com a s�tima linha de mensagem|a ser impressa no boleto"

  @ l_s+17 ,c_s+09 GET  rmens8
                   AJUDA "Entre com a �ltima linha de mensagem|a ser impressa no boleto"

  @ l_s+18 ,c_s+29 GET  rnnum;
                   PICT "9999999999";
                   VALI CRIT("!EMPT(rnnum)~Necess�rio informar N.N�MERO")
                   AJUDA "Informe o n�mero do boleto|Chamado pelo banco de Nosso N�mero"

  @ l_s+19 ,c_s+24 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n�mero do primeiro recibo a imprimir."

  @ l_s+19 ,c_s+38 GET  rpagfim;
                   PICT "9999"
                   AJUDA "Informe o n�mero do �ltimo recibo a imprimir."

  @ l_s+20 ,c_s+30 GET  confirme;
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
 IF !USEARQ("BOLETOS",.t.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BOLETOS")                                 // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT

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
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 PTAB(codigo,"EMCARNE",2,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO GRUPOS->grupo+circ INTO CIRCULAR,;
          TO codigo+tipo+circ INTO CSTSEG,;
          TO codigo INTO EMCARNE,;
          TO EMCARNE->tip INTO TCARNES

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,46,11)          // nao quis configurar...
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
 lpp_024=LEFT(drvtapg,op_-1)+"024"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_024:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
IF !so_um_reg
 SAVE TO PR087VAR ALL LIKE R*
ENDI
SET MARG TO 1                                      // ajusta a margem esquerda
op_2=1
DO WHIL op_2=1 .AND. tps=1                         // teste de posicionamento
 msg="Testar Posicionamento|Emitir o Relat�rio|"+;
     "Cancelar a Opera��o"
 op_2=DBOX(msg,,,E_MENU,,"POSICIONAMENTO DO PAPEL")// menu de opcoes
 IF op_2=0 .OR. op_2=3                             // cancelou ou teclou ESC
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU
 ELSEIF op_2=2                                     // emite conteudos...
  EXIT
 ELSE                                              // testar posicionamento
  SET DEVI TO PRIN                                 // direciona para impressora
  IMPCTL(lpp_024)                                  // seta pagina com 24 linhas
  IMPCTL(drvpde8)                                  // ativa 8 lpp
  SET MARG TO 1                                    // ajusta a margem esquerda
  @ 001,005 SAY REPL("X",40)
  @ 001,055 SAY REPL("X",8)
  @ 002,005 SAY REPL("X",40)
  @ 006,000 SAY REPL("X",8)
  @ 006,012 SAY REPL("X",15)
  @ 006,041 SAY REPL("X",8)
  @ 008,053 SAY REPL("X",10)
  @ 011,004 SAY REPL("X",40)
  @ 012,004 SAY REPL("X",40)
  @ 013,004 SAY REPL("X",40)
  @ 014,004 SAY REPL("X",40)
  @ 015,004 SAY REPL("X",40)
  @ 016,004 SAY REPL("X",40)
  @ 017,004 SAY REPL("X",40)
  @ 020,002 SAY REPL("X",35)
  @ 021,002 SAY REPL("X",35)
  @ 021,038 SAY REPL("X",20)
  @ 022,002 SAY REPL("X",35)
  EJEC                                             // salta pagina no inicio
  SET MARG TO                                      // coloca margem esquerda = 0
  IMPCTL(drvtde8)                                  // ativa 6 lpp
  IMPCTL(lpp_066)                                  // seta pagina com 66 linhas
  SET DEVI TO SCRE                                 // se parametro maior que 0
 ENDI
ENDD
IF so_um_reg
 DBOX([SO UM REGISTRO])
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=30                                           // maximo de linhas no relatorio
IMPCTL(lpp_024)                                    // seta pagina com 24 linhas
IMPCTL(drvpde8)                                    // ativa 8 lpp
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   SEEK M->mcodaux
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF M->rcod1>[000000]
    SEEK M->rcod1
   ENDI
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
   IF M->rcod2>[000000].AND.codigo>M->rcod2
    GO BOTT
    SKIP
    LOOP
   ENDI
   IF (so_um_reg.AND.(TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->mcodaux)).OR.;
       R08701F9()
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
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY M->rlocpgto                        // Local de Pagamento
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY M->rmens1                          // Mens1
    @ cl,055 SAY TRAN(emissao_,"@D")               // Emissao
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY LEFT(DTOC(DATE()),6)+RIGHT(DTOC(DATE()),2)    // data1
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->grupo+[ ]+GRUPOS->codigo+[ ]+tipo+[ ]+circ// Codigo
    IMPCTL(drvtenf)
    @ cl,032 SAY "DS"
    @ cl,042 SAY LEFT(DTOC(DATE()),6)+RIGHT(DTOC(DATE()),2) // data2
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "CVT: 7744.5 ESPEC.   R$"
    @ cl,053 SAY TRAN(R08702F9()+vlseg,"@E 999,999.99")// Valor Total
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens2                          // Mensagem 2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens3                          // Mensagem 3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens4                          // Mensagem 4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens5                          // Mensagem 5
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens6 // Mensagem 6
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens7 // Mensagem 7
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens8 // Mensagem 8
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY GRUPOS->nome                      // Nome
    @ cl,043 SAY TRAN(pg_,'9999')                  // n�mero da p�gina
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY LEFT(ALLTRIM(GRUPOS->endereco)+;                 // Endere�o
                [ ]+GRUPOS->bairro,49)                    // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY TRAN(GRUPOS->cep,[@R 99999-999])+[ ]+ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf// Cidade

   SELE BOLETOS                                    // arquivo alvo do lancamento

   #ifdef COM_REDE
    BOL_CRIA_SEQ()
    SELE BOLETOS
    BOL_GERA_SEQ()
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    BOL_GERA_SEQ()
    APPE BLAN                                      // cria registro em branco
   #endi

   BOL_GRAVA_SEQ()
   SELE TAXAS                                      // inicializa registro em branco
   REPL BOLETOS->nnumero WITH R08705F9(),;
        BOLETOS->codigo WITH codigo,;
        BOLETOS->tipo WITH tipo,;
        BOLETOS->circ WITH circ,;
        BOLETOS->por WITH M->usuario,;
        BOLETOS->em_ WITH DATE()

   #ifdef COM_REDE
    BOLETOS->(DBUNLOCK())                          // libera o registro
   #endi

// Processamentos
   #ifdef COM_REDE
    IF stat < [2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI

    IF !EMPT(TAXAS->codlan).AND.TAXAS->tipo=[1]
     SELE EMCARNE
     DO WHILE !eof() .AND.codigo=TAXAS->codigo
      IF intlan=SUBSTR(TAXAS->codlan,5,8)
       REPBLO('EMCARNE->emissao_',{||DATE()})
       EXIT
      ENDI
      SKIP
     ENDDO
     SELE TAXAS
    ENDI

   #else
    IF stat < [2]
     REPL TAXAS->stat WITH [2]
    ENDI
    IF !EMPT(TAXAS->codlan).AND.TAXAS->tipo=[1]
     SELE EMCARNE
     DO WHILE !eof() .AND.codigo=TAXAS->codigo
      IF intlan=SUBSTR(TAXAS->codlan,5,8)
       REPL EMCARNE->emissao_ WITH DATE()
       EXIT
      ENDI
      SKIP
     ENDDO
     SELE TAXAS
    ENDI
   #endi
    sele taxas

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
IMPCTL(drvtde8)                                    // ativa 6 lpp
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(46)                                          // grava variacao do relatorio
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
 cl=qt ; pg_++
ENDI
RETU

* \\ Final de ADP_RF87.PRG
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind�stria de Urnas Bignotto Ltda
 \ Programa: ADP_RC87.PRG
 \ Data....: 01-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Emiss�o Banespa
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

proc adp_rc87

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg, mcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=24, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
V87001F9()  // Monta variaveis publicas...
so_um_reg=(PCOU()>2)
IF .T. //!so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+10 SAY " IMPRESS�O DE COBRAN�A BANESPA"
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran�a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       �ltima:             )"
 @ l_s+03,c_s+1 SAY " Circulares a emitir: N�      at�"
 @ l_s+04,c_s+1 SAY " Cobran�as com data entre:          e"
 @ l_s+05,c_s+1 SAY " e n� de contrato entre:        e"
 @ l_s+06,c_s+1 SAY "         Reimprimir taxas j� impressas?"
 @ l_s+07,c_s+1 SAY "     Acumular valor das cobran�as vencidas?"
 @ l_s+08,c_s+1 SAY " Tipo a acumular:      Regiao:"
 @ l_s+09,c_s+1 SAY " Banco:"
 @ l_s+10,c_s+1 SAY " Mens1:"
 @ l_s+11,c_s+1 SAY " Mens2:"
 @ l_s+12,c_s+1 SAY " Mens3:"
 @ l_s+13,c_s+1 SAY " Mens4:"
 @ l_s+14,c_s+1 SAY " Mens5:"
 @ l_s+15,c_s+1 SAY " Mens6:"
 @ l_s+16,c_s+1 SAY " Mens7:"
 @ l_s+17,c_s+1 SAY " Mens8:"
 @ l_s+18,c_s+1 SAY " N�mero do primeiro boleto:"
 @ l_s+19,c_s+1 SAY " Data Vencimento:"
 @ l_s+20,c_s+1 SAY "     Imprimir do recibo n�      at� o n�"
 @ l_s+21,c_s+1 SAY "                   Confirme:"
ENDI
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
rven_=CTOD('')                                     // Emiss�o
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
rregiao=SPAC(3)                                      // Tipos a imprimir
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
rlocpgto=SPAC(40)                                  // Local de Pagamento
rmens1=SPAC(40)                                    // Mensagem
rmens2=SPAC(40)                                    // Mensagem
rmens3=SPAC(40)                                    // Mensagem
rmens4=SPAC(40)                                    // Mensagem
rmens5=SPAC(40)                                    // Mensagem
rmens6=SPAC(40)                                    // Mensagem
rmens7=SPAC(40)                                    // Mensagem
rmens8=SPAC(40)                                    // Mensagem
rnnum=SPAC(10)                                     // N.N�mero
rpagin=1                                           // Pag.inicial
rpagfim=9999                                          // Pag.final
confirme=SPAC(1)                                   // Confirme

IF FILE('PRC87VAR.MEM')//.and.!so_um_reg
 REST FROM PRC87VAR ADDITIVE
ENDI
IF PCOU()=3
 mcodaux:=codigo+tipo+circ
 rcod1:=rcod2:=mcodaux
ELSEIF PCOU()=4
 rcod1:=rcod2:=mcodaux
ENDI

DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF .T. //!so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+20 GET  rtp;
                   PICT "9"
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

  @ l_s+06 ,c_s+41 GET  rreimp;
                   PICT "!";
                   VALI CRIT("rreimp$[SN ]~Necess�rio informar REIMPRIMIR?|Digite S ou N")
                   DEFAULT "[N]"
                   AJUDA "Digite S para imprimir todos os documentos|mesmo os que j� foram impressos anteriormente."

  @ l_s+07 ,c_s+45 GET  racum;
                   PICT "!";
                   VALI CRIT("racum$[SN ]~ACUMULAR? n�o aceit�vel|Digite S ou N")
                   DEFAULT "[ ]"
                   AJUDA "Digite S para acumular o valor|das cobran�as n�o pagas neste documento."

  @ l_s+08 ,c_s+18 GET  rtipo;
                   PICT "!!!";
                   VALI CRIT("!EMPT(rtipo)~Necess�rio informar TIPOS A IMPRIMIR");
                   WHEN "racum='S'"
                   DEFAULT "[123]"
                   AJUDA "Digite 1 para J�ia, 2 para cobran�as e 3 p/Periodo"
                   CMDF8 "MTAB([111-J�ia|222-p/Processos|333-Peri�dico|122-J�ia+Processos|133-J�ia+Per�odico|233-Processos+Peri�dicos|123-Todos],[TIPOS A IMPRIMIR])"

  @ l_s+08 ,c_s+32 GET  rregiao;
                   PICT "999";
                   VALI CRIT("PTAB(rregiao,'REGIAO',1).OR.rregiao='000'~REGIAO n�o aceit�vel|Digite zeros para listar todas as regioes")
                   DEFAULT "[000]"
                   AJUDA "Entre com a regi�o desejada|ou|Tecle F8 para consulta"
                   CMDF8 "VDBF(6,26,20,77,'REGIAO',{'codigo','regiao'},1,'codigo')"

  IF so_um_reg
   CLEAR GETS
  ENDI

  @ l_s+09 ,c_s+09 GET  rlocpgto
                   AJUDA "Informe o local de Pagamento que|ser� impresso no boleto banc�rio"

  @ l_s+10 ,c_s+09 GET  rmens1
                   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc,40),[])"
                   AJUDA "Entre com a primeira linha de mensagem|a ser impressa no boleto"

  @ l_s+11 ,c_s+09 GET  rmens2
		   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,SUBSTR(CIRCULAR->menscirc,41),[])"
                   AJUDA "Entre com a Segunda linha de mensagem|a ser impressa no boleto"

  @ l_s+12 ,c_s+09 GET  rmens3
                   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc1,40),[])"
                   AJUDA "Entre com a terceira linha de mensagem|a ser impressa no boleto"

  @ l_s+13 ,c_s+09 GET  rmens4
                   DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc2,40),[])"
                   AJUDA "Entre com a quarta linha de mensagem|a ser impressa no boleto"

  @ l_s+14 ,c_s+09 GET  rmens5
                   AJUDA "Entre com a quinta linha de mensagem|a ser impressa no boleto"

  @ l_s+15 ,c_s+09 GET  rmens6
                   AJUDA "Entre com a sexta linha de mensagem|a ser impressa no boleto"

  @ l_s+16 ,c_s+09 GET  rmens7
                   AJUDA "Entre com a s�tima linha de mensagem|a ser impressa no boleto"

  @ l_s+17 ,c_s+09 GET  rmens8
                   AJUDA "Entre com a �ltima linha de mensagem|a ser impressa no boleto"

  @ l_s+18 ,c_s+29 GET  rnnum;
                   PICT "9999999999";
                   VALI CRIT("!EMPT(rnnum)~Necess�rio informar N.N�MERO")
                   AJUDA "Informe o n�mero do boleto|Chamado pelo banco de Nosso N�mero"

  @ l_s+19 ,c_s+18 GET  rven_;
                   PICT "@D"
                   AJUDA "Data da Emiss�o da Circular.| Informe a data a considerar como inicial na emiss�o."

  @ l_s+20 ,c_s+28 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n�mero do primeiro recibo a imprimir."

  @ l_s+20 ,c_s+42 GET  rpagfim;
                   PICT "9999"
                   AJUDA "Informe o n�mero do �ltimo recibo a imprimir."

  @ l_s+21 ,c_s+30 GET  confirme;
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
 IF !USEARQ("BOLETOS",.t.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BOLETOS")                                 // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT

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
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 PTAB(codigo,"EMCARNE",2,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO GRUPOS->grupo+circ INTO CIRCULAR,;
          TO codigo+tipo+circ INTO CSTSEG,;
          TO codigo INTO EMCARNE,;
          TO EMCARNE->tip INTO TCARNES

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,43,11)          // nao quis configurar...
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
 lpp_024=LEFT(drvtapg,op_-1)+"024"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_024:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
IF !so_um_reg
 SAVE TO PRC87VAR ALL LIKE R*
ENDI
SET MARG TO 1                                      // ajusta a margem esquerda
op_2=2 //1
DO WHIL op_2=1 .AND. tps=1                         // teste de posicionamento
 msg="Testar Posicionamento|Emitir o Relat�rio|"+;
     "Cancelar a Opera��o"
 op_2=DBOX(msg,,,E_MENU,,"POSICIONAMENTO DO PAPEL")// menu de opcoes
 IF op_2=0 .OR. op_2=3                             // cancelou ou teclou ESC
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU
 ELSEIF op_2=2                                     // emite conteudos...
  EXIT
 ELSE                                              // testar posicionamento
  SET DEVI TO PRIN                                 // direciona para impressora
  IMPCTL(lpp_024)                                  // seta pagina com 24 linhas
  IMPCTL(drvpde8)                                  // ativa 8 lpp
  SET MARG TO 1                                    // ajusta a margem esquerda
  @ 001,005 SAY REPL("X",40)
  @ 002,005 SAY REPL("X",40)
  @ 002,055 SAY REPL("X",8)
  @ 006,000 SAY REPL("X",8)
  @ 006,012 SAY REPL("X",15)
  @ 006,042 SAY REPL("X",8)
  @ 008,053 SAY REPL("X",10)
  @ 011,004 SAY REPL("X",40)
  @ 012,004 SAY REPL("X",40)
  @ 013,004 SAY REPL("X",40)
  @ 014,004 SAY REPL("X",40)
  @ 015,004 SAY REPL("X",40)
  @ 016,004 SAY REPL("X",40)
  @ 017,004 SAY REPL("X",40)
  @ 020,002 SAY REPL("X",35)
  @ 020,038 SAY REPL("X",4)
  @ 021,002 SAY REPL("X",35)
  @ 021,038 SAY REPL("X",20)
  @ 022,002 SAY REPL("X",35)
  EJEC                                             // salta pagina no inicio
  SET MARG TO                                      // coloca margem esquerda = 0
  IMPCTL(drvtde8)                                  // ativa 6 lpp
  IMPCTL(lpp_066)                                  // seta pagina com 66 linhas
  SET DEVI TO SCRE                                 // se parametro maior que 0
 ENDI
ENDD
IF so_um_reg
 DBOX([SO UM REGISTRO])
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=30                                           // maximo de linhas no relatorio
IMPCTL(lpp_024)                                    // seta pagina com 24 linhas
IMPCTL(drvpde8)                                    // ativa 8 lpp
SET MARG TO 1                                      // ajusta a margem esquerda
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
M->racum+=[S]
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   SEEK M->mcodaux
  ELSE
   INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF M->rcod1>[000000]
    SEEK M->rcod1
   ENDI
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
    IF !(M->rregiao$[000,]+GRUPOS->regiao)
     SKIP
     LOOP
    ENDI
   IF M->rcod2>[000000].AND.codigo>M->rcod2
    GO BOTT
    SKIP
    LOOP
   ENDI
   IF (so_um_reg.AND.(TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->mcodaux)).OR.;
       R08701F9()
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

    IF EMPT(M->rven_).OR. (M->rven_ < DATE())
     DTAUXVC:=EMISSAO_
    ELSE
     DTAUXVC:=M->rven_
    ENDI
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY M->rlocpgto                       // Local de Pagamento
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY M->rmens1                         // Mens1
    @ cl,051 SAY TRAN(M->dtauxvc,"@D")               // Emissao
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,001 SAY LEFT(DTOC(DATE()),6)+RIGHT(DTOC(DATE()),2)  // data1
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->grupo+[ ]+GRUPOS->codigo+[ ]+tipo+[ ]+circ// Codigo
    IMPCTL(drvtenf)
    @ cl,036 SAY  data2
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,046 SAY TRAN(R08702F9(M->dtauxvc)+vlseg,"@E 999,999.99")// Valor Total
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens2                         // Mensagem 2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens3                         // Mensagem 3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens4                         // Mensagem 4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens5                         // Mensagem 5
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens6                         // Mensagem 6
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens7
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->rmens8
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY GRUPOS->nome                      // Nome
    @ cl,038 SAY TRAN(pg_-1,'9999')                  // n�mero da p�gina
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY GRUPOS->endereco                  // Endere�o
    @ cl,038 SAY GRUPOS->bairro                    // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY GRUPOS->cep+[ ]+ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf// Cidade

   SELE BOLETOS                                    // arquivo alvo do lancamento

   #ifdef COM_REDE
    BOL_CRIA_SEQ()
    SELE BOLETOS
    BOL_GERA_SEQ()
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    BOL_GERA_SEQ()
    APPE BLAN                                      // cria registro em branco
   #endi

   BOL_GRAVA_SEQ()
   SELE TAXAS                                      // inicializa registro em branco
   REPL BOLETOS->nnumero WITH R08705F9(),;
        BOLETOS->codigo WITH codigo,;
        BOLETOS->tipo WITH tipo,;
        BOLETOS->circ WITH circ,;
        BOLETOS->por WITH M->usuario,;
        BOLETOS->em_ WITH DATE()

   #ifdef COM_REDE
    BOLETOS->(DBUNLOCK())                          // libera o registro
   #endi

// Processamentos
   #ifdef COM_REDE
    IF stat < [2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI

    IF !EMPT(TAXAS->codlan).AND.TAXAS->tipo=[1]
     SELE EMCARNE
     DO WHILE !eof() .AND.codigo=TAXAS->codigo
      IF intlan=SUBSTR(TAXAS->codlan,5,8)
       REPBLO('EMCARNE->emissao_',{||DATE()})
       EXIT
      ENDI
      SKIP
     ENDDO
     SELE TAXAS
    ENDI

   #else
    IF stat < [2]
     REPL TAXAS->stat WITH [2]
    ENDI
    IF !EMPT(TAXAS->codlan).AND.TAXAS->tipo=[1]
     SELE EMCARNE
     DO WHILE !eof() .AND.codigo=TAXAS->codigo
      IF intlan=SUBSTR(TAXAS->codlan,5,8)
       REPL EMCARNE->emissao_ WITH DATE()
       EXIT
      ENDI
      SKIP
     ENDDO
     SELE TAXAS
    ENDI
   #endi

    sele taxas

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
IMPCTL(drvtde8)                                    // ativa 6 lpp
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(43)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU
