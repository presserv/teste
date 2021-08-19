

procedure adp_pdf
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: IndÃ‚Â£stria de Urnas Bignotto Ltda
 \ Programa: BPASTO->ADP_R087 -> ADP_RX87
 \ Data....: 29-10-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Cartinha -> Bom Pastor
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#define CRLF (Chr(13) + Chr(10))
#include "hbclass.ch"
#include "common.ch"
#define CRLF CHR(13)+CHR(10)
#xtranslate Default( <x>, <y> ) => IIF( <x> == NIL, <y>, <x> )
#include "hbclass.ch"

#include "adpbig.ch"    // inicializa constantes manifestas


LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF(),cFileName,nI:=1,nK:=1
PARA  lin_menu, col_menu, imp_reg, rcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=24, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)

nucop=1
PUBL vlaux:=0,vlout:=0,vlseg:=valororig:=0  // ComposiÃ¢â‚¬Â¡Ã¢â‚¬Å¾o do valor
PUBL lindeb:=[]  // Linha resumo dos dÃ¢â‚¬Å¡bitos (Tipo+circ ...)
publ detdeb[10] // Detalhamento dos dÃ¢â‚¬Å¡bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
PUBL ultprc:=[]  // Ultima cartinha montada, se for igual nÃ¢â‚¬Å¾o refaz...
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
 @ l_s,c_s+15 SAY " IMPRESSŽO DE COBRAN€A "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Tipo da Cobran‡a:"
 @ l_s+02,c_s+1 SAY " Grupo:     (      -       £ltima:             )"
 @ l_s+03,c_s+1 SAY " Circulares a emitir: N§      at‚"
 @ l_s+04,c_s+1 SAY " Cobran‡as com data entre:          e"
 @ l_s+05,c_s+1 SAY " e n§ de contrato entre:        e"
 @ l_s+06,c_s+1 SAY " Cobrador=                      "
 @ l_s+07,c_s+1 SAY "         Reimprimir taxas j  impressas?"
 @ l_s+08,c_s+1 SAY "     Acumular valor das cobran‡as vencidas?"
 @ l_s+09,c_s+1 SAY "         Tipo das taxas a acumular :"
 @ l_s+10,c_s+1 SAY "     Imprimir do recibo n§      at‚ o n§"
 @ l_s+11,c_s+1 SAY " Data Vencimento:"
 @ l_s+12,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Mensagens ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
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
rproxcirc=SPAC(3)                                  // NÃ‚Â§Proxima Circ.
rultcirc=SPAC(3)                                   // NÃ‚Â§Ultima Circ.
rem1_=CTOD('')                                     // EmissÃ¢â‚¬Å¾o
rem2_=CTOD('')                                     // EmissÃ¢â‚¬Å¾o
rven_=CTOD('')                                     // EmissÃ¢â‚¬Å¾o
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
                   AJUDA "Qual o tipo de cobran‡a a imprimir neste impresso."
                   CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"

  @ l_s+02 ,c_s+09 GET  rgrupo;
                   PICT "!!";
                   VALI CRIT("PTAB(rgrupo,[ARQGRUP]).OR.vrgrupo()~GRUPO n„o existe na tabela")
                   AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                   CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                   MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 14 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 21 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 36 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 40 }

  @ l_s+03 ,c_s+26 GET  rproxcirc;
                   PICT "999";
                   VALI CRIT("LTOC(PTAB(rgrupo+rproxcirc,'CIRCULAR',1))$[FT]~A Pr¢xima circular deve estar|lan‡ada em Tabela/Circulares")
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

  @ l_s+11 ,c_s+18 GET  rven_;
                   PICT "@D"
                   AJUDA "Data da Emiss„o da Circular.| Informe a data a considerar como inicial na emiss„o."

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
                   VALI CRIT("confirme$'SB2'.AND.V87001F9()~CONFIRME n„o aceit vel")
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
  IF !USEARQ("BOLETOS",.f.,10,3)                    // se falhou a abertura do arq
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

// Se as parcelas iniciais coincidirem, serÃ‚Â  perguntado se Ã¢â‚¬Å¡ somente o
// carne, se nao, respeitara a filtragem
// IF rproxcirc+rultcirc$[001012,013024] // em 01/07/2000 -> deixou de ser
  opcarn:=1                              // opcional, sempre irÃ‚Â  perguntar
  opcarn=DBOX("Sim|N„o",,,E_MENU,,msgt)
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
 //SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="ConfiguraÃ¢â‚¬Â¡Ã¢â‚¬Å¾o do tamanho da pÃ‚Â gina!"         // foi informado errado
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

//SET DEVI TO PRIN                                   // inicia a impressao
//SET MARG TO 1                                      // ajusta a margem esquerda
/*
 IMPCTL(lpp_026)                                    // seta pagina com 26 linhas
 drvaux:="CHR(27)+[&l24D]"
 IMPCTL(drvaux)  // Inicia 24 linhas p/polegada

 drvpcomx:="CHR(27)+[&k2S]"  // Comprimido
 drvtcomx:="CHR(27)+[&k0S]"  // Normal
 IMPCTL(drvpcomx)  // Inicia 24 linhas p/polegada
*/
drvpcomx:=drvpcom //"CHR(27)+[&k2S]"  // Comprimido
drvtcomx:=drvtcom //"CHR(27)+[&k0S]"  // Normal

drvaux:="CHR(27)+[@]"
//IMPCTL(drvaux)  // Reset da Impressora

drvaux:="CHR(27)+[&l2A]"  // Letter
drvaux:="CHR(27)+[&l3A]"  // Legal
drvaux:="CHR(27)+[&l26A]" // A4
//IMPCTL(drvaux)  // Tamanho do Papel (legal)

drvaux:="CHR(27)+[&l0L]"    // Salto de Picote off
//IMPCTL(drvaux)  // Inicia Salto de Picote off

drvaux:="CHR(27)+[&l3E]"    // Numero de linhas Margem de top
//IMPCTL(drvaux)  // Inicia margem de topo
drvaux:="CHR(27)+[&l268F]"  // Numero de linhas de texto
//IMPCTL(drvaux)  // Inicia linhas de texto

OP_873:=2
IF op_873=1 // Se utiliza duplex
 drvaux:="CHR(27)+[&l1S]"
ELSE
 drvaux:="CHR(27)+[&l0S]"
ENDI
//IMPCTL(drvaux)  // Com ou Sem duplex

drvaux:="CHR(27)+[0]"
//IMPCTL(lpp_026)                                    // seta pagina com 26 linhas
//IMPCTL(drvaux)  // Inicia 24 linhas p/polegada
//IMPCTL(drvpde8)
drvaux:="CHR(27)+'3'+chr(9)"              // Habilita 216/20
//IMPCTL(drvaux)  // Inicia 216/20 linhas p/polegada

IF tps=2
// IMPCTL("' '+CHR(8)")
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
     IF EMPT(cttx2)        // Se primeira 2Ã‚Â¦Via do arquivo
      go top           // pega o primeiro lancamento em tx2via
      cttx2:=codigo+tipo+circ   // guarda a posicao no arquivo
     ELSE              // Senao,
      SEEK cttx2       // Vai para a posicao guardada
      SKIP             // Pula para o registro seguinte
     ENDI
     IF EOF() //cttx2 > reccount() // Se nÃƒâ€ o houver mais 2Ã‚Â¦Via
      SELE TAXAS                   // Seleciona as taxas
      GO BOTT                      // Vai ao final do arquivo
      SKIP                         // ForÃ¢â‚¬Â¡a o EOF
      EXIT
      LOOP                         // Sai do loop
     ENDI
     cttx2:=codigo+tipo+circ  // Guarda o nÃ‚Â£mero do registro
     rcodaux:=codigo+tipo+IIF(circ<[001],[],circ) // chave do reg.a imprimir
     SELE TAXAS
     SEEK M->rcodaux
     IF !EOF()
      EXIT
     ENDI
    ENDD

   ENDI

   DO WHILE !EOF().AND.(codigo+tipo+circ=M->rcodaux.OR.confirme=[S])
   // SET DEVI TO SCRE                                // apresenta na tela
    @ 17,35 say codigo+tipo+circ
   // SET DEVI TO PRIN                                // inicia a impressao
   
    IF rcod2>[000000].AND.codigo>rcod2
     GO BOTT
     SKIP
    ENDI
    IF rcod1>[000000].AND.codigo<rcod1
     SKIP
     LOOP
    ENDI

    // Se titulo ja pago ou ainda não aceito pelo banco 
    IF valorpg>0
	 SKIP
     LOOP
    ENDI
	
	IF !(stat$[A].or.(M->rreimp=[S].and.stat=[2]))

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
   IF !R08701F9(.t.) //((so_um_reg.and.codigo+tipo+circ=M->rcodaux).or.R08701F9())
	  
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
     adddias=0           // das parcelas cujo 1Ã‚Â§vencimento esteja antes
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

    rcbarra:=M->rnnum      // Nosso nÃ‚Â£mero (boletos->seq)

   oIni = TIniFile():New(Default(cFilename, 'bolpdf.ini'))
   oIni:WriteString("CAB", "Banco", "237")
   oIni:WriteString("CAB", "cImageLnk", "")
   oIni:WriteBool("CAB", "lBoleto", .T.)
   oIni:WriteBool("CAB", "lRemessa", .f.)
   oIni:WriteBool("CAB", "lAnsi", .T.)
   oIni:WriteBool("CAB", "lPrint", .t.)
   oIni:WriteBool("CAB", "lPreview", .t.)
   oIni:WriteBool("CAB", "lPromptPrint", .t.)
   oIni:WriteNumber("CAB", "nBolsPag", 3)
   oIni:WriteString("CAB", "Cedente", "SOUZA E POLANQUINI LTDA ME")
   oIni:WriteString("CAB", "CedenteCNPJ", "")
   oIni:WriteString("CAB", "cNumCC", "006079-8")
   oIni:WriteString("CAB", "cNumAgencia", "1932-1")
   oIni:WriteString("CAB", "cCarteira", "009")
   oIni:WriteString("CAB", "EspecieTit", "05")
   oIni:WriteString("CAB", "cTipoCob", "14")
   oIni:WriteNumber("CAB", "nMora", 0)
   oIni:WriteNumber("CAB", "nMulta", 0.10)
   oIni:WriteNumber("CAB", "nDiasProt", 0)
   oIni:WriteString("CAB", "cDir", "")
   oIni:WriteString("CAB", "cDirRemessa", "")
  
   cBol := "BOL" + LTRIM(STR(nI++))
   cNumDoc:=codigo+tipo+circ
 
   oIni:WriteString( cBol, "Sacado", GRUPOS->nome)
   oIni:WriteString( cBol, "Endereco", GRUPOS->endereco)
   oIni:WriteString(cBol, "Bairro", GRUPOS->bairro)
   oIni:WriteString( cBol, "Cidade", GRUPOS->cidade)
   oIni:WriteString( cBol, "Estado", GRUPOS->uf)
   oIni:WriteString( cBol, "CEP", GRUPOS->cep)
   oIni:WriteString( cBol, "CNPJ", GRUPOS->cpf)
   oIni:WriteString( cBol, "cNumDoc", cNumDoc)              // seu numero do documento
   oIni:WriteString( cBol, "cNossoNumero", M->rnnum)     // numero do banco
   oIni:WriteNumber( cBol, "nValor",TAXAS->valor)                // valor do boleto
   oIni:WriteDate( cBol, "DtVenc", TAXAS->emissao_)
   
	oIni:UpdateFile()

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
    IF cl > 240
	   cl=999                                         // forca salto de pagina
    ELSE
	   //REL_CAB(16)                                     // soma cl/imprime cabecalho
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
  
 ENDD ccop
 //EJEC                                              // salta pagina
END SEQUENCE
//IMPCTL(drvtcomx)                                    // retira comprimido
//SET MARG TO                                        // coloca margem esquerda = 0
//IMPCTL(drvpde8)
//IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
//SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
//SET DEVI TO SCRE                                   // direciona saida p/ video

IF tps=2                                           // se vai para arquivo/video
 //BROWSE_REL(arq_,2,3,MAXROW()-2,78)
 cpasta:= LEFT(hb_cmdargargv(), RAT(HB_OSpathseparator(), hb_cmdargargv()))
 carq :=cpasta+"hboleto.exe bolpdf.ini"
 Hb_run(carq)
cbolpdf:="bolpdf.ini"


if file(cbolpdf)
    run del &cbolpdf  
endif
ENDI                                               // mostra o arquivo gravado
//GRELA(63)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

