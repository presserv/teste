procedure adp_e004
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_E004.PRG
 \ Data....: 24-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Etiquetas de Cobran‡a
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL lin_:={}, i_, ct_, dele_atu
PARA  lin_menu, col_menu, imp_reg, rcodaux
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=2, c_s:=16, l_i:=24, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1

PUBL vlaux:=0,vlout:=0,vlseg:=valororig:=0  // Composi‡„o do valor
PUBL lindeb:=[]  // Linha resumo dos d‚bitos (Tipo+circ ...)
publ detdeb[10] // Detalhamento dos d‚bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
PUBL ultprc:=[]  // Ultima cartinha montada, se for igual n„o refaz...
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
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
rultcirc=SPAC(3)                                   // N§Ultima Circ.
rem1_=CTOD('')                                     // Emiss„o
rem2_=CTOD('')                                     // Emiss„o
rven_=CTOD('')                                     // Emiss„o
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
rcodempr:=[0317003000117151]
IF FILE('PR087VAR.MEM')
 REST FROM PR087VAR ADDITIVE
ENDI
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
                   VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.(1=1)~A Pr¢xima circular deve estar|lan‡ada em Tabela/Circulares")
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

  @ l_s+06 ,c_s+26 GET  rcobrad;
                   PICT "@!"
                   AJUDA "Entre com o cobrador a imprimir|Tecle F8 para consulta"
                   CMDF8 "VDBF(6,26,20,77,'COBRADOR',{'cobrador','nome'},1,'cobrador')"

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
/*
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
*/
  @ l_s+21 ,c_s+30 GET  confirme;
                   PICT "!";
                   VALI CRIT("confirme$'SB'.AND.V87001F9()~CONFIRME n„o aceit vel")
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
 IF M->confirme=[S]
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
  cpord=IIF(confirme=[S],"cobrador+codigo+tipo+circ","")
 endi
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
// arq_=drvporta                                     // porta de saida configurada
 EXIT
ENDD


/*
#ifdef COM_REDE
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

PTAB(grupo,"ARQGRUP",1,.t.)                        // abre arquivo p/ o relacionamento
PTAB(grupo+ARQGRUP->proxcirc,"CIRCULAR",1,.t.)
PTAB(tipcont,"CLASSES",1,.t.)
SET RELA TO grupo INTO ARQGRUP,;                   // relacionamento dos arquivos
         TO grupo+ARQGRUP->proxcirc INTO CIRCULAR,;
         TO tipcont INTO CLASSES
titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
*/


IF TYPE("drvdp_e004")="C"                          // conf da etq alterada?
 qtlin_=VAL(SUBS(drvdp_e004, 1,3))                 // linhas da etiqueta
 qtcol_=VAL(SUBS(drvdp_e004, 4,3))                 // largura da etiqueta
 qtcse_=VAL(SUBS(drvdp_e004, 7,3))                 // espaco entre as carreiras
 qtcar_=VAL(SUBS(drvdp_e004,10,3))                 // numero de carreiras
 qtreg_=SUBS(drvdp_e004,13)                        // qtde por registro
ELSE                                               // se nao alterou pega
 qtlin_=6                                          // 'defaults` da qde linhas
 qtcol_=35                                         // largura da etiqueta
 qtcse_=1                                          // espaco entre as carreiras
 qtcar_=2                                          // numero de carreiras
 qtreg_="1"                                        // qtde por registro
ENDI
IF !opcoes_etq(lin_menu,col_menu,5,35,52)          // nao quis configurar...
 CLOS ALL                                          // fecha arquivos e
 RETU                                              // volta ao menu
ENDI
lin_=ARRAY(qtlin_)                                 // inicializa vetor de linhas
IF tps=2                                           // se vai para arquivo/video
 arq_=ARQGER()                                     // entao pega nome do arquivo
 IF EMPTY(arq_)                                    // se cancelou ou nao informou
  RETU                                             // retorna
 ENDI
ELSE
 arq_=drvporta                                     // porta de saida configurada
ENDI
IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF

SET PRINTER TO (arq_)                              // redireciona saida
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_006=LEFT(drvtapg,op_-1)+"006"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_006:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
AFILL(lin_,"")                                     // inicializa vetor lin_[]
FOR i_=1 TO qtcar_                                 // lin de p/ teste de posicionamento
 lin_[1]+=PADR("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",qtcol_+qtcse_)
 lin_[2]+=PADR("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",qtcol_+qtcse_)
 lin_[3]+=PADR("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",qtcol_+qtcse_)
 lin_[4]+=PADR("XXXXXXXXXXXXXXXXXXXX",qtcol_+qtcse_)
 lin_[5]+=PADR("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",qtcol_+qtcse_)
NEXT
op_2=1
DO WHIL op_2=1 .AND. tps=1                         // teste de posicionamento
 msg="Testar Posicionamento|Emitir a Etiqueta|"+;
     "Cancelar a Opera‡„o"
 op_2=DBOX(msg,,,E_MENU,,"EMISSŽO DE ETIQUETA")    // menu de opcoes
 IF op_2=0 .OR. op_2=3                             // cancelou ou teclou ESC
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU
 ELSEIF op_2=2                                     // emite conteudos...
  EXIT
 ELSE                                              // testar posicionamento
  SET CONSOLE OFF                                  // desliga impressao no video
  SET PRINT ON                                     // e envia para impressora
  IMPCTL(lpp_006)                                  // seta pagina com 6 linhas
  ?? CHR(13)
  FOR i_=1 TO qtlin_
   ?? lin_[i_]                                     // imprime 'X` para teste
   IF EMPTY(drvtapg) .OR. i_<qtlin_
    ?
   ENDI
  NEXT
  IF !EMPTY(drvtapg)                               // existe configuracao de tam pag?
   EJEC                                            // salta pagina no inicio
  ENDI
  IMPCTL(lpp_066)                                  // seta pagina com 66 linhas
  SET CONSOLE ON                                   // liga impressao em video
  SET PRINT OFF                                    // e desliga a impresora
 ENDI
ENDD
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET CONSOLE OFF                                    // desliga impressao no video
SET PRINT ON                                       // e envia para impressora
IMPCTL(lpp_006)                                    // seta pagina com 6 linhas
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

   IF !EMPT(M->rcobrad).and.confirme=[S]
    seek IIF(EMPT(criterio),[],[T])+M->rcobrad
   ENDI

	ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF().AND.(!so_um_reg.OR. codigo+tipo+circ=M->rcodaux)
   AFILL(lin_,""); ct_=0                           // inicializa lin_/contador de carreiras
   DO WHILE !EOF() .AND. ct_<qtcar_                // faz todas as carreiras
    #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                             // se quer cancelar
    #else
    IF INKEY()=K_ESC                              // se quer cancelar
    #endi
     IF canc()                                     // pede confirmacao
      BREAK                                        // confirmou...
     ENDI
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

    FOR t_=1 TO &qtreg_.                          // repete a mesma n vezes
     ct_++                                        // soma contador de carreiras
     lin_[1]+=PADR(GRUPOS->grupo +[ ]+codigo+[    ]+cobrador,35)+SPAC(qtcol_+qtcse_-35)
     lin_[2]+=GRUPOS->nome+SPAC(qtcol_+qtcse_-35)
     lin_[3]+=GRUPOS->endereco+SPAC(qtcol_+qtcse_-35)
     lin_[4]+=GRUPOS->bairro+SPAC(qtcol_+qtcse_-20)
     lin_[5]+=TRAN(GRUPOS->cep,[@R 99999-999])+[ ]+PADR(ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf,25)+SPAC(qtcol_+qtcse_-35)
     IF ct_>=qtcar_                               // atingiu o numero de carreiras?
      ?? CHR(13)
      FOR i_=1 TO qtlin_                          // imprime linhas da etiqueta
       ?? lin_[i_]
       IF EMPTY(drvtapg) .OR. i_<qtlin_
        ?
       ENDI
      NEXT
      IF !EMPTY(drvtapg)                          // existe configuracao de tam pag?
       EJEC                                       // salta pagina no inicio
      ENDI
      AFILL(lin_,""); ct_=0                       // inicializa lin_/contador de carreiras
     ENDI
    NEXT
    pg_++
    pg_++

    SKIP                                          // pega proximo registro
   ENDD                                            // eof ou encheu todas as carreiras

   IF ct_>0                                        // preenchido a carreira parcialmente
    ?? CHR(13)
    FOR i_=1 TO qtlin_                             // imprime linhas da etiqueta
     ?? lin_[i_]
     IF EMPTY(drvtapg) .OR. i_<qtlin_
      ?
     ENDI
    NEXT
    IF !EMPTY(drvtapg)                             // existe configuracao de tam pag?
     EJEC                                          // salta pagina no inicio
    ENDI
   ENDI

  ENDD
 ENDD ccop
 IF EMPTY(drvtapg)
  EJEC                                             // salta pagina no inicio
 ENDI
END SEQUENCE
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
//SET CONSOLE ON                                     // liga impressao em video
//SET PRINT OFF                                      // e desliga a impresora
SET DEVI TO SCRE                                   // direciona saida p/ video

IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
//SET CONSOLE ON                                     // liga impressao em video
//SET PRINT OFF                                      // e desliga a impresora
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

* \\ Final de ADP_E004.PRG
STAT FUNC SR08701F9
donex:=.t.
DO CASE
CASE valorpg>0 // J  paga, tchau!!!
 donex:=.f.
CASE !(tipo=M->rtp) //N„o ‚ meu tipo!!!
 donex:=.f.
CASE (stat>[1].AND.!(M->rreimp=[S])) //J  foi impressa !!!
 donex:=.f.
CASE !EMPT(M->rgrupo).AND.!(GRUPOS->grupo=M->rgrupo)// Quero s¢ o grupo!!
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

RETU  M->donex     // <- deve retornar um valor L¢GICO
