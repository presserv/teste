procedure amfarv33
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: AMGURV33.PRG
 \ Data....: 28-10-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Impress�o das Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=18, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+9 SAY " GRUPOS C/TAXAS A EMITIR "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Grupo..:      De:       -"
 @ l_s+02,c_s+1 SAY " �ltima Circular.:"
 @ l_s+03,c_s+1 SAY " Pr�xima Circular:"
 @ l_s+05,c_s+1 SAY " Valor p/atraso:  ap�s "
 @ l_s+06,c_s+1 SAY "                  ap�s "
 @ l_s+07,c_s+1 SAY "         Confirme:"
ENDI
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N�Proxima Circ.
ateh1=CTOD('')                                     // At�:
valor1=0                                           // Valor
ateh2=CTOD('')                                     // At�:
valor2=0                                           // Valor
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+11 GET  rgrupo;
                   PICT "!!";
                   VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).or.EMPT(rgrupo)~GRUPO n�o existe na tabela|Deixe sem preencher para imprimir de todos")
                   AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                   CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                   MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 1 , 20 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 1 , 27 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 20 }
                   MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 24 }

  @ l_s+03 ,c_s+20 GET  rproxcirc;
                   PICT "999";
                   VALI CRIT("rproxcirc=ARQGRUP->proxcirc.or.rproxcirc='000'~Circular n�o preparada para emiss�o|Deixe com zeros para imprimir todos os preparados")
                   DEFAULT "ARQGRUP->proxcirc"
                   AJUDA "Entre com o n�mero da pr�xima circular"
                   CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

  @ l_s+05 ,c_s+24 GET  ateh1;
                   PICT "@D"

  @ l_s+05 ,c_s+33 GET  valor1;
                   PICT "@E 999.99";
                   VALI CRIT("valor1>=0~VALOR n�o aceit�vel")

  @ l_s+06 ,c_s+24 GET  ateh2;
                   PICT "@D"

  @ l_s+06 ,c_s+33 GET  valor2;
		   PICT "@E 999.99";
                   VALI CRIT("valor2>=0~VALOR n�o aceit�vel")

  @ l_s+07 ,c_s+20 GET  confirme;
                   PICT "!";
                   VALI CRIT("confirme='S'~CONFIRME n�o aceit�vel")
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

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
 PTAB(GRUPOS->regiao,"REGIAO",1,.t.)
 PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->grupo INTO ARQGRUP,;
          TO GRUPOS->regiao INTO REGIAO,;
          TO GRUPOS->grupo+circ INTO CIRCULAR
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="cobrador+codigo+tipo+circ"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,45,11)          // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("CPRCIRC",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

cpord="grupo+circ+DTOS(dfal)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE TAXAS
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura��o do tamanho da p�gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_048=LEFT(drvtapg,op_-1)+"048"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_048:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=19                                           // maximo de linhas no relatorio
IMPCTL(lpp_048)                                    // seta pagina com 48 linhas
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
  ult_imp=0                                        // ultimo reg impresso
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
   IF (tipo=[2].AND.(EMPT(M->rgrupo).OR.GRUPOS->grupo=M->rgrupo).AND.(M->rproxcirc=[000].OR.ARQGRUP->proxcirc=M->rproxcirc)) .OR. so_um_reg// se atender a condicao...
    REL_CAB(1,.t.)                                 // soma cl/imprime cabecalho
    @ cl,000 SAY "."
    ult_imp=RECNO()                                // ultimo reg impresso
    chv071=GRUPOS->grupo+TAXAS->circ
    SELE CPRCIRC
    SEEK chv071
    IF FOUND()
     DO WHIL ! EOF() .AND. chv071=grupo+circ //LEFT(&(INDEXKEY(0)),LEN(chv071))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      IMPCTL(drvpc20)                              // comprime os dados
      @ cl,030 SAY CPRCIRC->num                    // Contrato
      @ cl,041 SAY CPRCIRC->processo               // Processo
      @ cl,054 SAY CPRCIRC->fal                    // Falecido
      @ cl,091 SAY TRAN(ALLTRIM(CPRCIRC->ends)+'-'+ALLTRIM(CPRCIRC->cids),"@!")// Ends
      @ cl,149 SAY TRAN(CPRCIRC->dfal,"@D")        // Data
      IMPCTL(drvtc20)                              // retira comprimido
      SKIP                                         // pega proximo registro
     ENDD
    ENDI
    SELE TAXAS                                     // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_RDP(.t.)                                     // imprime rodape' do relatorio
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
GRELA(45)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT�RIO|IMPRESS�O COBRAN�A"
ALERTA()
IF so_um_reg
 op_=1
ELSE
 op_=DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
ENDI
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
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
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

STATIC PROC REL_RDP(volta_reg)                     // rodape'
LOCAL ar_:=ALIAS(), reg_atual
SELE TAXAS                                         // volta ao arquivo pai
reg_atual=RECNO()
IF volta_reg
 GO ult_imp                                        // ajusta reg p/ imp de campos no rodape'
ENDI
@ 21,008 SAY &drvtcom+CIRCULAR->menscirc            // Mensagem
@ 25,017 SAY TRAN(TAXAS->valor,"@E 999,999.99")    // Valor
@ 25,065 SAY TRAN(TAXAS->valor,"@E 999,999.99")    // Valor 2
IF !EMPT(M->valor1)                                // pode imprimir?
 @ 27,058 SAY [Ap�s ]+TRAN(M->ateh1,'@D')+[ ]+TRAN(M->valor1,'@E 999.99')// at�1:
ENDI
IF !EMPT(M->valor2)                                // pode imprimir?
 @ 28,058 SAY [Ap�s ]+TRAN(M->ateh2,'@D')+[ ]+TRAN(M->valor2,'@E 999.99')// at�2:
ENDI
@ 31,002 SAY TAXAS->circ+[     ]+DTOC(TAXAS->emissao_)+[     ]+STR(GRUPOS->funerais,2)// Circular 1
@ 31,038 SAY TAXAS->circ+[     ]+DTOC(TAXAS->emissao_)+[     ]+STR(GRUPOS->funerais,2)// Circular 2
@ 34,002 SAY GRUPOS->grupo +[        ]+TAXAS->codigo+[       ]+GRUPOS->cobrador// Grupo 1
@ 34,038 SAY GRUPOS->grupo +[        ]+TAXAS->codigo+[       ]+GRUPOS->cobrador// Grupo 2
@ 36,000 SAY GRUPOS->nome                          // Nome
@ 36,036 SAY GRUPOS->nome                          // Nome 2
@ 37,000 SAY GRUPOS->endereco                      // Endere�o
@ 37,036 SAY GRUPOS->endereco                      // Endere�o 2
@ 38,000 SAY GRUPOS->bairro                        // Bairro
@ 38,036 SAY GRUPOS->bairro                        // Bairro 2
@ 39,000 SAY GRUPOS->cidade+[ ] +GRUPOS->cep       // Cidade
@ 39,036 SAY GRUPOS->cidade+[ ] +GRUPOS->cep       // Cidade 2
@ 40,000 SAY [Inic:]+DTOC(GRUPOS->admissao)+[ Ult:]+GRUPOS->ultcirc+[ QtTx:]+STR(GRUPOS->qtcircs,3)// Inicio
@ 40,036 SAY [Inic:]+DTOC(GRUPOS->admissao)+[ Ult:]+GRUPOS->ultcirc+[ QtTx:]+STR(GRUPOS->qtcircs,3)// Inicio 2
@ 42,000 SAY ""
IF M->combarra=[S]
 CODBARRAS({{TAXAS->codigo+TAXAS->tipo+TAXAS->circ,4,13,18}},10,6)
ENDI
@ 43,000 SAY ""
IF M->combarra=[S]
 CODBARRAS({{TAXAS->codigo+TAXAS->tipo+TAXAS->circ,4,13,18}},10,6)
ENDI
IF volta_reg
 GO reg_atual                                      // retorna reg a posicao original
ENDI
SELE (ar_)
RETU 

STATIC PROC REL_CAB(qt, volta_reg)                 // cabecalho do relatorio
LOCAL ar_:=ALIAS()
volta_reg=IF(volta_reg=NIL,.f.,volta_reg)
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP(volta_reg)                               // imprime rodape' do relatorio
 ENDI
 SELE TAXAS                                        // volta ao arquivo pai
 @ 1,007 SAY GRUPOS->nome                          // Nome
 @ 1,058 SAY TRAN(TAXAS->codigo,"999999")          // Codigo
 @ 1,076 SAY TRAN(GRUPOS->grupo,"!!")              // Grupo
 IF !EMPT(M->valor1)                               // pode imprimir?
  @ 2,046 SAY [Ap�s ]+TRAN(M->ateh1,'@D')+[ ]+TRAN(M->valor1,'@E 999.99')// At�1:
 ENDI
 @ 3,029 SAY TRAN(TAXAS->valor,"@E 999,999.99")    // Valor
 IF !EMPT(M->valor2)                               // pode imprimir?
  @ 3,046 SAY [Ap�s ]+TRAN(M->ateh2,'@D')+[ ]+TRAN(M->valor2,'@E 999.99')// At�2:
 ENDI
 SELE (ar_)
 cl=qt+7 ; pg_++
ENDI
RETU

* \\ Final de AMGURV33.PRG
