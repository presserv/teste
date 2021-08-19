procedure amcarv33
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: AMCARV33.PRG
 \ Data....: 25-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Impress�o das Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=5, c_s:=16, l_i:=21, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
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
 @ l_s+12,c_s+1 SAY "  Juros:"
 @ l_s+13,c_s+1 SAY "  Banco:"
 @ l_s+14,c_s+1 SAY "  Imprimir do recibo n�      at� o n�"
 @ l_s+15,c_s+1 SAY "                   Confirme:"
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
rjuros=SPAC(10)                                    // Juros
rbanco=SPAC(30)                                    // Banco
rpagin=1                                           // Pag.inicial
rpagfim=9999                                          // Pag.final
confirme=SPAC(1)                                   // Confirme
IF FILE('MRV33VAR.MEM')
 REST FROM PRV33VAR ADDITIVE
ENDI
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+20 GET  rtp;
                   PICT "!";
                   VALI CRIT("rtp $ [123]~TIPO n�o aceit�vel");
                   WHEN "MTAB([1=J�ia |2=Taxa |3=Carn�],[TIPO])"
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

  @ l_s+12 ,c_s+10 GET  rjuros
                   DEFAULT "[     0,10]"
                   AJUDA "Informe o conte�do da linha de juros"

  @ l_s+13 ,c_s+10 GET  rbanco;
		   PICT "@S25@!"
                   DEFAULT "[BANESPA - 276-13-000588-4]"
                   AJUDA "Informe o Banco/Conta a constar no recibo."

  @ l_s+14 ,c_s+25 GET  rpagin;
                   PICT "9999"
                   AJUDA "Informe o n�mero do primeiro recibo a imprimir."

  @ l_s+14 ,c_s+39 GET  rpagfim;
                   PICT "9999"
                   AJUDA "Informe o n�mero do �ltimo recibo a imprimir."

  @ l_s+15 ,c_s+30 GET  confirme;
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
  IF !USEARQ("TAXAS",.F.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
 PTAB(GRUPOS->regiao,"REGIAO",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CPRCIRC",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->grupo INTO ARQGRUP,;
          TO GRUPOS->regiao INTO REGIAO,;
          TO GRUPOS->grupo+circ INTO CIRCULAR,;
	  TO GRUPOS->grupo+circ INTO CPRCIRC
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="cobrador+codigo+tipo+circ"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,48,11)          // nao quis configurar...
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
 lpp_033=LEFT(drvtapg,op_-1)+"033"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_033:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
SAVE TO MRV33VAR ALL LIKE R*
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=31                                           // maximo de linhas no relatorio
IMPCTL(lpp_033)                                    // seta pagina com 33 linhas
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
    IF (pg_<M->rpagin .OR.pg_>M->rpagfim).AND.!so_um_reg
     pg_++
     SKIP
     LOOP
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY R08703F9()                       // Montagem do dados
    @ cl,002 SAY M->setup1                         // Ident1 1
//    @ cl,057 SAY "|"
    @ cl,058 SAY LEFT(M->setup1,37)                // Ident1 2
//    @ cl,095 SAY "|"
    @ cl,096 SAY LEFT(M->setup1,37)                // Ident1 3
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|Pelo presente comunicamos a VS., de conformidade com as |"
    @ cl,058 SAY LEFT(M->setup2,37)                // Ident2 1
//    @ cl,095 SAY "|"
    @ cl,096 SAY LEFT(M->setup2,37)                // Ident2 2
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|clausulas  contatuais, os  Obitos abaixo discriminados. |"
    @ cl,058 SAY LEFT(M->setup3,37)                // Setup3
//    @ cl,095 SAY "|"
    @ cl,096 SAY LEFT(M->setup3,37)                // Setup3
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|Inscr.|  Data  | Nome do (a) falecido (a)               | PAGAMENTO   -   FUNERARIA           | PAGAMENTO   -   FUNERARIA           |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[01]                        // det01
//    @ cl,057 SAY "| Titular:"
    @ cl,067 SAY LEFT(GRUPOS->nome,28)             // Nome 1
//    @ cl,095 SAY "| Titular:"
    @ cl,105 SAY LEFT(GRUPOS->nome,28)             // Nome 2
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[02]                        // det02
//    @ cl,057 SAY "|"
    @ cl,060 SAY GRUPOS->endereco                  // Endere�o 1
//    @ cl,095 SAY "|"
    @ cl,098 SAY GRUPOS->endereco                  // Endere�o 2
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[03]                        // det03
//    @ cl,057 SAY "|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[04]                        // det04
//    @ cl,057 SAY "| Insc. | Grupo | Refer. | Vencimento | Insc. | Grupo | Refer. | Vencimento |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[05]                        // det05
//    @ cl,057 SAY "|"
    rcodigo=TAXAS->codigo                          // variavel temporaria
    @ cl,058 SAY TRAN(rcodigo,"999999")            // Codigo
//    @ cl,065 SAY "|"
    @ cl,068 SAY TRAN(GRUPOS->grupo,"!!")          // Grupo
//    @ cl,073 SAY "|"
    @ cl,075 SAY tipo+[-]+circ                     // Circular 1
//    @ cl,082 SAY "|"
    @ cl,085 SAY TRAN(emissao_,"@D")               // Emissao
//    @ cl,095 SAY "|"
    @ cl,096 SAY GRUPOS->codigo                    // Codigo
//    @ cl,103 SAY "|"
    @ cl,106 SAY GRUPOS->grupo                     // Grupo
//    @ cl,111 SAY "|"
    @ cl,113 SAY tipo+[-]+circ                     // Circular
//    @ cl,120 SAY "|"
    @ cl,123 SAY TRAN(emissao_,"@D")               // Emissao
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[06]                        // det06
//    @ cl,057 SAY "|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[07]                        // det07
//    @ cl,057 SAY "| APOS O VENCIMENTO COBRAR 0.33% AO   | APOS O VENCIMENTO COBRAR 0.33% AO   |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[08]                        // det08
//    @ cl,057 SAY "| DIA.                                | DIA                                 |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[09]                        // det09
//    @ cl,057 SAY "|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|"
    @ cl,001 SAY detprc[10]                        // det10
//    @ cl,057 SAY "| Valor r$  |  Multa r$  |  Total r$  | Valor r$  |  Multa r$  |  Total r$  |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------|"
    vlaux=R08702F9()                               // variavel temporaria
    @ cl,058 SAY TRAN(vlaux,"@E 999,999.99")       // Valor 2
//    @ cl,069 SAY "|            |            |"
    @ cl,096 SAY TRAN(vlaux,"@E 999,999.99")       // Valor
//    @ cl,107 SAY "|            |            |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|PAGAMENTO:"
    @ cl,012 SAY M->setup1                         // Ident1 4
//    @ cl,057 SAY "|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------| MENSAGEM:                           | MENSAGEM:                           |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|Titular:"
    @ cl,011 SAY GRUPOS->nome                      // Nome
//    @ cl,057 SAY "|"
    @ cl,059 SAY LEFT(CIRCULAR->menscirc,35)       // Mensagem 1
//    @ cl,095 SAY "|"
    @ cl,097 SAY LEFT(CIRCULAR->menscirc,35)       // Mensagem 2
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------|"
    @ cl,059 SAY CIRCULAR->menscirc1               // Mensagem 1a
//    @ cl,095 SAY "|"
    @ cl,097 SAY CIRCULAR->menscirc1               // Mensagem 2a
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|Insc.|Grupo|Refer.|Vencimento|Valor r$|Multa r$|Total r$|"
    @ cl,059 SAY CIRCULAR->menscirc2               // Mensagem 1b
//    @ cl,095 SAY "|"
    @ cl,097 SAY CIRCULAR->menscirc2               // Mensagem 2b
//    @ cl,133 SAY "|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY GRUPOS->codigo                    // Codigo
//    @ cl,006 SAY "|"
    @ cl,008 SAY GRUPOS->grupo                     // Grupo
//    @ cl,012 SAY "|"
    @ cl,013 SAY tipo+[ ]+circ                     // circ
//    @ cl,019 SAY "|"
    @ cl,020 SAY emissao_                          // Emissao
    @ cl,029 SAY TRAN(vlaux,"@E 999,999.99")       // Valor
//    @ cl,039 SAY "|        |        |"
    @ cl,059 SAY LEFT(M->detdeb,35)                // det tax
//    @ cl,095 SAY "|                                     |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------|"
    @ cl,059 SAY SUBSTR(detdeb,36,35)              // det tax1
//    @ cl,095 SAY "|                                     |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|        APOS O VENCIMENTO COBRAR 0.33% AO DIA           |                                     |"
//    @ cl,133 SAY "|"
    IF M->combarra=[S]
     CODBARRAS({{TAXAS->codigo+TAXAS->tipo+TAXAS->circ,1,13,112}},10,6)
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|--------------------------------------------------------|-------------------------------------|-------------------------------------|"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|Autenticacao Mecanica ( Contribuinte )                  | Autenticacao Mecanica (Compensacao) | Autenticacao Mecanica (Funeraria)   |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|                                                        |                                     |                                     |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|                                                        |                                     |                                     |"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
//    @ cl,000 SAY "|                                                        |                                     |                                     |"
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
GRELA(48)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT�RIO|IMPRESS�O DAS TAXAS"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
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
    IF STAT<[2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI
   #else
    IF STAT<[2]
     REPL TAXAS->stat WITH [2]
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
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
 @ 0,000 SAY "+------------------Circular de Cobranca------------------+-------------------------------------+-------------------------------------+"
 cl=qt ; pg_++
ENDI
RETU

* \\ Final de AMCARV33.PRG
