procedure adp_ra87
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: ADP_R087.PRG
 \ Data....: 07-11-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Emiss�o Boleto Banc�rio
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=4, c_s:=16, l_i:=23, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+15 SAY " IMPRESS�O DE COBRAN�A "
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
@ l_s+10,c_s+1 SAY "      :"
@ l_s+11,c_s+1 SAY " Mens1:"
@ l_s+12,c_s+1 SAY " Mens2:"
@ l_s+13,c_s+1 SAY " Mens3:"
@ l_s+14,c_s+1 SAY " Mens4:"
@ l_s+15,c_s+1 SAY " Mens5:"
@ l_s+16,c_s+1 SAY " Mens6:"
@ l_s+17,c_s+1 SAY " Mens7:"
@ l_s+18,c_s+1 SAY "                   Confirme:"
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
locpgto='                                        ' // Local de Pagamento
mens1=  '                                        ' // Mensagem
mens2=  'APOS VENCIMENTO, COBRAR MULTA DE 10%    ' // Mensagem
mens3=  '                                        ' // Mensagem
mens4=  'MAIS JUROS DE 0,01% AO DIA.             ' // Mensagem
mens5=SPAC(40)                                     // Mensagem
mens6=SPAC(40)                                     // Mensagem
mens7=SPAC(40)                                     // Mensagem
mens8=SPAC(40)                                     // Mensagem
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+20 GET  rtp;
		  PICT "!";
		  VALI CRIT("rtp $ [123]~TIPO n�o aceit�vel");
		  WHEN "MTAB([1=J�ia |2=Taxa |3=Carn�],[TIPO])"
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

 @ l_s+09 ,c_s+09 GET  locpgto
                  AJUDA "Informe o local de Pagamento que|ser� impresso no boleto banc�rio"

 @ l_s+10 ,c_s+09 GET  mens1
		  DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc,40),[])"
                  AJUDA "Entre com a primeira linha de mensagem|a ser impressa no boleto"

 @ l_s+11 ,c_s+09 GET  mens2
                  DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,SUBSTR(CIRCULAR->menscirc,41),[])"
                  AJUDA "Entre com a Segunda linha de mensagem|a ser impressa no boleto"

 @ l_s+12 ,c_s+09 GET  mens3
                  DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc1,40),[])"
                  AJUDA "Entre com a terceira linha de mensagem|a ser impressa no boleto"

 @ l_s+13 ,c_s+09 GET  mens4
                  DEFAULT "IIF(rproxcirc=ARQGRUP->proxcirc,LEFT(CIRCULAR->menscirc2,40),[])"
                  AJUDA "Entre com a quarta linha de mensagem|a ser impressa no boleto"

 @ l_s+14 ,c_s+09 GET  mens5
                  AJUDA "Entre com a quinta linha de mensagem|a ser impressa no boleto"

 @ l_s+15 ,c_s+09 GET  mens6
                  AJUDA "Entre com a sexta linha de mensagem|a ser impressa no boleto"

 @ l_s+16 ,c_s+09 GET  mens7
                  AJUDA "Entre com a s�tima linha de mensagem|a ser impressa no boleto"

 @ l_s+17 ,c_s+09 GET  mens8
                  AJUDA "Entre com a �ltima linha de mensagem|a ser impressa no boleto"

 @ l_s+18 ,c_s+30 GET  confirme;
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
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 PTAB(codigo,"EMCARNE",1,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 PTAB(codigo+circ,"MENSAG",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO GRUPOS->grupo+circ INTO CIRCULAR,;
          TO codigo+tipo+circ INTO CSTSEG,;
	  TO codigo INTO EMCARNE,;
          TO EMCARNE->tip INTO TCARNES,;
          TO codigo+circ INTO MENSAG
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,44,11)           // nao quis configurar...
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
 lpp_024=LEFT(drvtapg,op_-1)+"024"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_024:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
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
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY M->locpgto                        // Local de Pagamento
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY M->mens1                          // Mens1
    @ cl,055 SAY TRAN(emissao_,"@D")               // Emissao
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(DATE(),"@D")                 // data1
    IMPCTL(drvpenf)
    @ cl,012 SAY GRUPOS->grupo+[ ]+GRUPOS->codigo+[ ]+tipo+[ ]+circ// Codigo
    IMPCTL(drvtenf)
    @ cl,032 SAY " "
//  @ cl,042 SAY TRAN(DATE(),"@D")                 // data2
    REL_CAB(2)                                     // soma cl/imprime cabecalho
//  @ cl,000 SAY "CVT: 7744.5 ESPEC.   R$"
    @ cl,053 SAY TRAN(R08702F9()+vlseg,"@E 999,999.99")// Valor Total
    REL_CAB(2)                                     // soma cl/imprime cabecalho
//    IF vlseg > 0     //Incluido para conceder desconto
//     @ cl,053 SAY TRAN(vlseg,"@E 999,999.99")// Valor Total
//    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->mens2                          // Mensagem 2
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->mens3                          // Mensagem 3
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->mens4                          // Mensagem 4
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY M->mens5                          // Mensagem 5
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY LEFT(IIF(!EMPT(MENSAG->mens1),MENSAG->mens1,M->mens6),40) // Mensagem 6
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY LEFT(IIF(!EMPT(MENSAG->mens2),MENSAG->mens2,M->mens7),40)// Mensagem 7
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,004 SAY LEFT(IIF(!EMPT(MENSAG->mens3),MENSAG->mens3,M->mens8),40)// Mensagem 8
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY GRUPOS->nome                      // Nome
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,002 SAY GRUPOS->endereco                  // Endere�o
    @ cl,038 SAY GRUPOS->bairro                    // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,009 SAY TRAN(GRUPOS->cep,"@R 99999-999")+[ ]+ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf// Cidade
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
GRELA(44)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT�RIO|EMISS�O BOLETO BANC�RIO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TAXAS                                        // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF R08701F9()                                    // se atender a condicao...

   #ifdef COM_REDE
    IF stat < [2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI
    IF TCARNES->parf=VAL(TAXAS->circ).AND.EMPT(EMCARNE->emissao_).AND.tipo$'16'
     REPBLO('EMCARNE->emissao_',{||DATE()})
    ENDI
   #else
    IF stat < [2]
     REPL TAXAS->stat WITH [2]
    ENDI
    IF TCARNES->parf=VAL(TAXAS->circ).AND.EMPT(EMCARNE->emissao_).AND.tipo$'16'
     REPL EMCARNE->emissao_ WITH DATE()
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
 cl=qt ; pg_++
ENDI
RETU

* \\ Final de ADP_R087.PRG
