procedure adp_rx87
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind�stria de Urnas Bignotto Ltda
 \ Programa: BPASTO->ADP_R087 -> ADP_RX87
 \ Data....: 29-10-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Cartinha -> Bom Pastor
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#DEFINE dDataBase CTOD("07/10/1997")
#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg, rcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=24, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
PUBL vlaux:=0,vlout:=0,vlseg:=valororig:=0  // Composi��o do valor
PUBL lindeb:=[]  // Linha resumo dos d�bitos (Tipo+circ ...)
publ detdeb[10] // Detalhamento dos d�bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
PUBL ultprc:=[]  // Ultima cartinha montada, se for igual n�o refaz...
publ detprc[10] // Cartinha dos falecidos
afill(detprc,[])
publ contar:=.t., contx :=0

// Custos adicionais
PUBL vlcst:=0
publ detcst[10]
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
rcobr:=[  ]
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
rultcirc=SPAC(3)                                   // N�Ultima Circ.
rem1_=CTOD('')                                     // Emiss�o
rem2_=CTOD('')                                     // Emiss�o
rven_=CTOD('')                                     // Emiss�o
rregiao=[000]                                      // Tipos a imprimir
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
rcodempr:=[0317003000117151]
rcodempr:=[1932100060798]
IF FILE('PRB66VAR.MEM')
 REST FROM PRB66VAR ADDITIVE
ENDI
rcodempr:=[1932100060798]
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
                   VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.(1=1)~A Pr�xima circular deve estar|lan�ada em Tabela/Circulares")
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

  @ l_s+06 ,c_s+30 GET rcobr; 
                   PICT "@!"

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
                   PICT "@S25"

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
                   VALI CRIT("confirme$'SB2'.AND.V87001F9()~CONFIRME n�o aceit�vel")
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
  IF !USEARQ("BOLETOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                             // volta ao menu anterior
  ENDI
 #else
  USEARQ("BOLETOS")                                 // abre o dbf e seus indices
 #endi
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  PRIV &msg.
 NEXT
 go bott
 M->rnnum:=nnumero

 #ifdef COM_REDE
	IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(rgrupo,[ARQGRUP],1)
 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
// PTAB(codigo,"EMCARNE",1,.t.)
// PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 IF M->confirme=[S]
//  SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
//          TO GRUPOS->tipcont INTO CLASSES,;
//          TO cobrador INTO COBRADOR,;
//          TO GRUPOS->grupo+circ INTO CIRCULAR
 ELSE
  PTAB(codigo+tipo,[TX2VIA],1,.t.)
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
  cpord=""
 endi
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1

 msgt:=[Imprimir somente carnes|iniciados em ]+SUBSTR(dtoc(rem1_),4)
 cod_sos=1
 // Incluido em 28/06 para facilitar a filtragem
 opcarn:=2

// Se as parcelas iniciais coincidirem, ser� perguntado se � somente o
// carne, se nao, respeitara a filtragem
// IF rproxcirc+rultcirc$[001012,013024] // em 01/07/2000 -> deixou de ser
  opcarn:=1                              // opcional, sempre ir� perguntar
//  opcarn=DBOX("Sim|N�o",,,E_MENU,,msgt)
// ENDI

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
 IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF
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
 lpp_026=LEFT(drvtapg,op_-1)+"270"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_026:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI

/*
txtini:=txtgruini:=txgrufin:=[]
arqx_:=[\INICIO.TXT]
txtini:=MEMOREAD([\INICIO.TXT]) // texto inicial
txtmei:=MEMOREAD([\MEIO.TXT])   // texto intermediario
txtfin:=MEMOREAD([\FIM.TXT])    // texto final
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
*/

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
 SAVE TO PRB66VAR ALL LIKE R*
ENDI

dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...

op_87=2 // Equiparar ao ADP_R087

rlaser:=([Laser]$drvmarca)
rlaser:=.T.
rcab1:=PADL(ALLTRIM(rcab1),65)
rcab2:=PADL(ALLTRIM(rcab2),65)
maxli=270                                           // maximo de linhas no relatorio

SET DEVI TO PRIN                                   // inicia a impressao
SET MARG TO 1                                      // ajusta a margem esquerda
/*
 IMPCTL(lpp_026)                                    // seta pagina com 26 linhas
 drvaux:="CHR(27)+[&l24D]"
 IMPCTL(drvaux)  // Inicia 24 linhas p/polegada

 drvpcomx:="CHR(27)+[&k2S]"  // Comprimido
 drvtcomx:="CHR(27)+[&k0S]"  // Normal
 IMPCTL(drvpcomx)  // Inicia 24 linhas p/polegada
*/
drvpcomx:="CHR(27)+[&k2S]"  // Comprimido
drvtcomx:="CHR(27)+[&k0S]"  // Normal

drvaux:="CHR(27)+[E]"
IMPCTL(drvaux)  // Reset da Impressora

drvaux:="CHR(27)+[&l2A]"  // Letter
drvaux:="CHR(27)+[&l3A]"  // Legal
drvaux:="CHR(27)+[&l26A]" // A4
IMPCTL(drvaux)  // Tamanho do Papel (legal)

drvaux:="CHR(27)+[&l0L]"    // Salto de Picote off
IMPCTL(drvaux)  // Inicia Salto de Picote off

OP_873:=2
IF op_873=1 // Se utiliza duplex
 drvaux:="CHR(27)+[&l1S]"
ELSE
 drvaux:="CHR(27)+[&l0S]"
ENDI
IMPCTL(drvaux)  // Com ou Sem duplex

drvaux:="CHR(27)+[&l24D]"                          // seta pagina com 26 linhas
IMPCTL(drvaux)  // Inicia 24 linhas p/polegada
IMPCTL(lpp_026)          

drvaux:="CHR(27)+[&l9E]"    // Numero de linhas Margem de top
IMPCTL(drvaux)  // Inicia margem de topo
drvaux:="CHR(27)+[&l268F]"  // Numero de linhas de texto
IMPCTL(drvaux)  // Inicia linhas de texto


IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
cttx2:=[]
temunica:=0
racumaux:=racum 
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  IF so_um_reg
   GO imp_reg
  ELSE
  // INI_ARQ()                                       // acha 1o. reg valido do arquivo
   IF (M->rcod1>[000000]).and.confirme=[S]
    seek IIF(EMPT(criterio),[],[T])+M->rcod1
    tam=6
    DO WHILE EOF()
     tam--
     SEEK IIF(EMPT(criterio),[],[T])+LEFT(M->rcod1,tam)
    ENDD
   ENDI
	ENDI
  ccop++                                           // incrementa contador de copias
  ultcod:=codcli:=[      ]
  dtvcunica:=ctod([ ])
  vl_tot_cli:=adddias:=0
  xcod:=[      ]
  okimptax:=.f.
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

   IF confirme#[S]
    DO WHILE .T.       // Looping incluido em 29/08/00 para ignorar as taxas
                       // digitadas em tx2via que nao existam em taxas.
     SELE TX2VIA
     IF EMPT(cttx2)        // Se primeira 2�Via do arquivo
      go top           // pega o primeiro lancamento em tx2via
      cttx2:=codigo+tipo+circ   // guarda a posicao no arquivo
     ELSE              // Senao,
      SEEK cttx2       // Vai para a posicao guardada
      SKIP             // Pula para o registro seguinte
     ENDI
     IF EOF() //cttx2 > reccount() // Se n�o houver mais 2�Via
      SELE TAXAS                   // Seleciona as taxas
      GO BOTT                      // Vai ao final do arquivo
      SKIP                         // For�a o EOF
      EXIT
      LOOP                         // Sai do loop
     ENDI
     cttx2:=codigo+tipo+circ  // Guarda o n�mero do registro
     rcodaux:=codigo+tipo+IIF(circ<[001],[],circ) // chave do reg.a imprimir
     SELE TAXAS
     SEEK M->rcodaux
     IF !EOF()
      EXIT
     ENDI
    ENDD

   ENDI

   DO WHILE !EOF().AND.(codigo+tipo+circ=M->rcodaux.OR.confirme=[S])
    SET DEVI TO SCRE                                // apresenta na tela
    @ 17,35 say codigo+tipo+circ
    SET DEVI TO PRIN                                // inicia a impressao
    IF rcod2>[000000].AND.codigo>rcod2
     GO BOTT
     SKIP
    ENDI
    IF rcod1>[000000].AND.codigo<rcod1
     SKIP
     LOOP
    ENDI

    // Se titulo ja pago ou ainda n�o aceito pelo banco
    IF valorpg>0
	 SKIP
     LOOP
    ENDI
	
	IF !(stat$[A].or.(M->rreimp=[S].and.stat=[2]))
	 skip
	 loop
	endi
    IF !EMPT(M->rcobr) .AND. !(TAXAS->cobrador=ALLTRIM(M->rcobr))
	 skip
	 loop
	endi

    sele grupos
    seek TAXAS->codigo
    sele classes
    seek GRUPOS->tipcont
    sele cobrador
    seek TAXAS->cobrador
    sele CIRCULAR
    seek GRUPOS->grupo+TAXAS->circ
    sele taxas
    // Se nao for o registro pedido
	 

	IF !RX8701F9(.t.) //((so_um_reg.and.codigo+tipo+circ=M->rcodaux).or.R08701F9())
     SKIP
     LOOP
    ENDI
	
	
    // Se nao for a pagina inicial solicitada
    IF (pg_ <M->rpagin).AND.!so_um_reg
     pg_++
     pg_++
     SKIP
     LOOP
    ENDI
    // Se ja passou a maior pagina solicitada
    IF (pg_>M->rpagfim).AND.!so_um_reg
     GO BOTT
     SKIP
     LOOP
    ENDI

   sele taxas

   //SET DEVI TO SCRE                                // apresenta na tela
   // @ 18,35 say pg_
   // SET DEVI TO PRIN                                // inicia a impressao

    IF codigo # ultcod   // Rotina para corrigir a data de vencimento
     adddias=0           // das parcelas cujo 1§vencimento esteja antes
     ultcod=codigo       // do solicitado.
	 racum:=racumaux
     IF emissao_ < M->rven_
      adddias = (M->rven_-emissao_)
     ENDI
    ENDI

    SELE BOLETOS                                    // arquivo alvo do lancamento
	set order to 3
    SEEK TAXAS->codigo+TAXAS->tipo+TAXAS->circ

   IF EOF()
     //
     SELE TAXAS
     SKIP
     LOOP
    ENDIF	
    DO WHILE !EOF().AND.codigo+tipo+circ=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
     M->rnnum=nnumero
     SKIP
    ENDD

    SELE TAXAS
    M->dtauxvc = emissao_+adddias

		valororig=R08702F9()                           // variavel temp.de valor

    vl_tot_cli+=valororig                          // Valor para parcela unica

 rcbarra:=M->rnnum      // Nosso n�mero (boletos->seq)
  
//    rcbarra+=DIGTVER10([09]+rcbarra)             // DV para o c�digo de barras
	cDGNN := DC_Mod11("237", 7, .F., "09"+M->rnnum)

    rcbarra:="09"+M->rnnum+cDGNN// DV p/Nosso N�mero (incluir cod.carteira 09)
    c_barra:=MONTA_BARRA(rcodempr,M->rnnum,valororig,M->dtauxvc)  // Cod.de Barra p/Banco


    rcbarra:=substr(rcbarra,3,len(rcbarra)+1) // (impressao sem a carteira)

		REL_CAB(00)                                    // soma cl/imprime cabecalho
		@ cl,000 SAY R08703F9()                       // Montagem dos dados
/*
    IMPCTL(drvpexp)
    @ cl,073 SAY c_barra [2]  // Linha digitavel
    IMPCTL(drvtexp)
*/
    IMPCTL(drvpexp)
    IMPCTL(drvTcomx)  // Finaliza 24 linhas p/polegada
    drvaux:="CHR(27)+[(s14H]" // (s14H  14 caracteres por polegada
    IMPCTL(drvaux)
    drvaux:="CHR(27)+[(s3B]" // (s2B Demi Bold
    IMPCTL(drvaux)
	cl+=4
    @ cl,052 SAY c_barra [2]  // Linha digitavel
    drvaux:="CHR(27)+[(s0B]" // (s0B Densidade normal
    IMPCTL(drvaux)
    IMPCTL(drvpcomx)  // Inicia 24 linhas p/polegada
    IMPCTL(drvtexp)


		REL_CAB(7)                                     // soma cl/imprime cabecalho
//    @ cl,028 SAY rcab1                 // Local de Pagamento
    @ cl,114 SAY DTOC(emissao_) // Vencimento

		REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY codigo+[-]+tipo+[-]+circ
		REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->setup1             // Cedente
    @ cl,112 SAY TRAN(rcodempr,[@R 9999-9/9999999-9])

		REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY DTOC(emissao_) // Vencimento
		REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY TRAN(DATE(),[@D])  // Data do documento
    @ cl,048 SAY codigo+[-]+tipo+[-]+circ
    @ cl,070 SAY [OU            N]  // Numero documento
    @ cl,097 SAY DATE()             // Data do processamento
    @ cl,112 SAY TRAN(rcbarra,[@R 99999999999-9]) // Nosso numero
		REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,005 SAY TRAN(rcodempr,[@R 9999-9.9999999-9])
		REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,050 SAY [CR ]
    @ cl,120 SAY TRAN(valororig,"@E 9,999.99")    // Valor 2
		REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY TRAN(rcbarra,[@R 99999999999-9]) // Nosso numero
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen1                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY TRAN(valororig,"@E 9,999.99")    // Valor 2
    @ cl,028 SAY M->rmen2                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen3                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen4                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen5                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen6                          // Nome
		REL_CAB(8)                                     // soma cl/imprime cabecalho
    @ cl,034 SAY GRUPOS->nome                  // Nome

		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY GRUPOS->endereco                      // Endere�o

		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY GRUPOS->bairro+[ ]+;                        // Bairro
      ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf+[  CEP: ]+;
      TRAN(GRUPOS->cep,"@R 99999-999")
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,100 say str(pg_-1,5)
    @ cl,108 SAY IIF(!EMPT(GRUPOS->cpf),[CPF: ]+TRAN(GRUPOS->cpf,[@R 999.999.999-99]),[ ])
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,30}},10,6)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,30}},10,6)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,30}},10,6)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
/*
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,28}},10,6)
*/

	 #ifdef COM_REDE
	  	IF stat $ "A"
	  	 REPBLO('TAXAS->stat',{||[2]})
	  	ENDI
	  #else
	  	IF stat $ "A"
	  	 REPL TAXAS->stat WITH [2]
	  	ENDI
	  #endi
	racum:=[N]
    IF cl > 200
	   cl=999                                         // forca salto de pagina
    ELSE
	   REL_CAB(12)                                     // soma cl/imprime cabecalho
    ENDI
    IF so_um_reg                             // vai receber a variaveis?
     EXIT
    ENDI
    SKIP
    IF (codigo+tipo+circ=M->rcodaux.AND.confirme#[S])
     LOOP
    ELSE
     EXIT
    ENDI
   ENDD
	ENDD
  IF temunica>0 // Parcela �nica ???
   recatu:=recno()
   GO (temunica)
   PTAB(codcli,[GRUPOS],1)
   vlunica:=vl_tot_cli-(vl_tot_cli*.15)
   impunica()
   temunica:=0
   GO (recatu)
   SKIP
   CODCLI:=codigo
   PTAB(codcli,[GRUPOS],1)
  ENDI
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
// IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
// ENDI
IF cl>maxli // .OR. qt=0                              // quebra de pagina
 cl=qt+0 ; pg_++
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

STATIC FUNC MONTA_BARRA(wparcodemp,cNossoNumero,wti1valtit,wvenc)
 

cCodBco:="237"
 // Monta Representa��o Num�rica do C�digo de Barras
       cFatorVenc := STRZERO( wvenc - dDataBase , 4 )
       cCpoLivre := "1932" + SUBSTR("009", 2, 2) + cNossoNumero + "0006079" + "0"
	 
      cC1RN := cCodBco + "9" + LEFT(cCpoLivre, 5)
      cC1RN := cC1RN + DC_Mod10(cCodBco, cC1RN)
      
      cC2RN := SUBSTR(cCpoLivre, 6, 10)
      cC2RN += DC_Mod10(cCodBco, cC2RN)
      
      cC3RN := SUBSTR(cCpoLivre, 16, 20)
      cC3RN += DC_Mod10(cCodBco, cC3RN)
      cC4RN :=cDGCB:= DC_Mod11( cCodBco, 9, .T., cCodBco +"9" + cFatorVenc + STRZERO( wti1valtit * 100, 10 ) + cCpoLivre )
      cC5RN :=cFatorVenc + STRZERO(wti1valtit * 100, 10)
      
      cRNCB := LEFT(cC1RN, 5) + "." + SUBSTR(cC1RN, 6) + " " + LEFT(cC2RN, 5) + "." +;
            SUBSTR(cC2RN, 6) + " " + LEFT(cC3RN, 5) + "." + SUBSTR(cC3RN, 6) + "  " + cC4RN + "  " + cC5RN
    

 wti2numcef:=val(cNossoNumero)
   ctcplivre:= "1932" + SUBSTR("009", 2, 2) + cNossoNumero + "0006079" + "0"

   ctcodbarra:= "2379" + ;
      strzero(wvenc-ctod([07/10/1997]),4)+;
      strzero(wti1valtit * 100, 10) + ;
      ctcplivre

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
/*
   ct1cabpart:= "237" + "9" + SubStr(ctcodbarra, 1, 5)
   ct1digpart:= Str(digtver10(ct1cabpart), 1)
   ct1cabpart:= SubStr(ct1cabpart, 1, 5) + "." + ;
         SubStr(ct1cabpart, 6, 5) + ct1digpart + "  "
   ct2cabpart:= SubStr(ctcodbarra, 6, 9)
   ct2digpart:= Str(digtver10(ct2cabpart), 1)
   ct2cabpart:= SubStr(ct2cabpart, 1, 5) + "." + ;
         SubStr(ct2cabpart, 6, 5) + ct2digpart + " "
   ct3cabpart:= SubStr(ctcodbarra, 16, 9)
   ct3digpart:= Str(digtver10(ct3cabpart), 1)
   ct3cabpart:= SubStr(ct3cabpart, 1, 5) + "." + ;
         SubStr(ct3cabpart, 6, 5) + ct3digpart + " "
   ct4cabpart:= digcodbar + " "
   ct5cabpart:= SubStr(ctcodbarra, 6, 4)+Strzero(wti1valtit * 100, 10)
   ctcabecalh:= ct1cabpart + ct2cabpart + ct3cabpart + ct4cabpart + ;
      ct5cabpart
RETU {ctcodbarra,ctcabecalh}
alert(cRNCB)
*/
RETURN {ctcodbarra,cRNCB}


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
   for i:= 13 to 1 step -1
      soma:= soma + Val(SubStr(Arg1, i, 1)) * fator++
      fator:= iif(fator = 7, 2, fator)
   next
   donex:=iif(11 - soma % 11 > 9,[P], str(11 - soma % 11,1))
   RETU arg1+ donex

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

STATIC FUNC IMPUNICA
    M->dtauxvc = dtvcunica+adddias

		vlunica:=vl_tot_cli-(vl_tot_cli*.15)

    rcbarra:=[82]+codigo+[00]                         // Nosso n�mero
    rcbarra+=STR(DIGTVER10(rcbarra),1)             // DV para o c�digo de barras
    c_barra:=MONTA_BARRA(rcodempr,rcbarra,vlunica)  // Cod.de Barra p/Banco

    rcbarra:=DG_COBSI([82]+TAXAS->codigo+[00])// DV p/Nosso N�mero


		REL_CAB(00)                                    // soma cl/imprime cabecalho
    IMPCTL(drvpexp)
    @ cl,073 SAY c_barra [2]  // Linha digitavel
    IMPCTL(drvtexp)

		REL_CAB(5)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY rcab1                 // Local de Pagamento
    @ cl,120 SAY DTOC(M->dtauxvc) // Vencimento

		REL_CAB(6)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY codigo+[ (UNICA)]
    @ cl,028 SAY M->setup1             // Cedente
    @ cl,110 SAY TRAN(rcodempr,[@R 9999-999.99999999-9])

		REL_CAB(7)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY DTOC(M->dtauxvc) // Vencimento
    @ cl,028 SAY TRAN(DATE(),[@D])  // Data do documento
    @ cl,045 SAY codigo+[ (UNICA)]
    @ cl,070 SAY [OU            N]  // Numero documento
    @ cl,096 SAY DATE()             // Data do processamento
    @ cl,118 SAY TRAN(rcbarra,[@R 9999999999-9]) // Nosso numero
		REL_CAB(5)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY TRAN(rcodempr,[@R 9999-999.99999999-9])
    @ cl,046 SAY [SR        R$]
    @ cl,120 SAY TRAN(vlunica,"@E 9,999.99")    // Valor 2
		REL_CAB(6)                                     // soma cl/imprime cabecalho
    @ cl,006 SAY TRAN(rcbarra,[@R 99999999999-9]) // Nosso numero
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen1                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY TRAN(vlunica,"@E 9,999.99")    // Valor 2
    @ cl,028 SAY M->rmen2                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen3                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen4                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen5                          // Nome
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY M->rmen6                          // Nome
		REL_CAB(10)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY GRUPOS->nome                  // Nome
    @ cl,108 SAY IIF(!EMPT(GRUPOS->cpf),[CPF: ]+TRAN(GRUPOS->cpf,[@R 999.999.999-99]),[ ])

		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY GRUPOS->endereco                      // Endere�o

		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,028 SAY GRUPOS->bairro+[ ]+;                        // Bairro
      ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf+[  CEP: ]+;
      TRAN(GRUPOS->cep,"@R 99999-999")
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,100 say str(pg_-1,5)
		REL_CAB(6)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,28}},10,6)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,28}},10,6)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ""
    CODBARRAS({{c_barra [1],4,40,28}},10,6)

   IF cl > 240
	  cl=999                                         // forca salto de pagina
   ELSE
		REL_CAB(13)                                     // soma cl/imprime cabecalho
   ENDI

RETU .T.

STAT FUNC rX8701f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: RX8701F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Express�o de filtro do relat�rio ADP_R087.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
donex:=.t. //V87001F9()
nrdonex=0
DO CASE
CASE valorpg>0 // J� paga, tchau!!!
 nrdonex=1
 donex:=.f.
CASE (!(stat$[A2]) .AND. !(M->rreimp=[S])) //J� foi impressa !!!
 nrdonex=3
 donex:=.f.
CASE !(tipo=M->rtp) //N�o � meu tipo!!!
 nrdonex=2
 donex:=.f.
CASE !EMPT(M->rgrupo).AND.!(GRUPOS->grupo=M->rgrupo)// Quero s� o grupo!!
 nrdonex=4
 donex:=.f.
CASE !(GRUPOS->situacao=[1]) //Contrato esta cancelado...
 nrdonex=5
 donex:=.f.
CASE VAL(M->rproxcirc)>0.AND.(TAXAS->circ<M->rproxcirc)//Circular menor
 nrdonex=6
 donex:=.f.
CASE VAL(M->rultcirc)>0.AND.(TAXAS->circ>M->rultcirc)//Circular maior
 nrdonex=7
 donex:=.f.
CASE VAL(M->rcod1)>0.AND.TAXAS->codigo<M->rcod1
 nrdonex=8
 donex:=.f.
CASE VAL(M->rcod2)>0.AND.TAXAS->codigo>M->rcod2
 nrdonex=9
 donex:=.f.
CASE TAXAS->emissao_< M->rem1_.OR.TAXAS->emissao_>M->rem2_
 nrdonex=10
 donex:=.f.
OTHERWISE
 donex:=.t.
ENDCASE

RETU  M->donex     // <- deve retornar um valor L�GICO

* \\ Final de R08701F9.PRG

