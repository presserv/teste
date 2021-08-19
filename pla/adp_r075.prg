procedure adp_r075
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R075.PRG
 \ Data....: 16-06-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Carnˆ Form.Branco
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=17, l_i:=12, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " EMISSŽO DE CARNES "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "  Emiss„o de.:          at‚.:"
@ l_s+02,c_s+1 SAY "  Contrato de:          at‚.:"
@ l_s+04,c_s+1 SAY "  Confirme..:"
rem1_=CTOD('')                                     // Emiss„o
rem2_=CTOD('')                                     // Emiss„o
rcod1=SPAC(6)                                      // Contrato
rcod2=SPAC(6)                                      // Contrato
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+16 GET  rem1_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem1_)~Informe uma data v lida p/ EMISSŽO | data de hoje ou posterior.")
                  DEFAULT "CTOD('01'+SUBSTR(DTOC(DATE()-30),3))"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

 @ l_s+01 ,c_s+31 GET  rem2_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem2_)~Informe uma data v lida, deve ser posterior|a inicial")
                  DEFAULT "rem1_+30"
                  AJUDA "Emitir as emitidas para que vencimento?"

 @ l_s+02 ,c_s+16 GET  rcod1;
                  PICT "999999";
                  VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+02 ,c_s+31 GET  rcod2;
                  PICT "999999";
                  VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+04 ,c_s+15 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n„o aceit vel|Digite S ou Tecle ESC")
                  AJUDA "Digite S para confirmar |ou|Tecle ESC para cancelar"

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
 PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
 PTAB(codigo,"MENSAG",1,.t.)
 PTAB(codigo,"EMCARNE",1,.t.)
 PTAB(EMCARNE->tip,"TCARNES",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->tipcont INTO CLASSES,;
          TO cobrador INTO COBRADOR,;
          TO codigo+tipo+circ INTO CSTSEG,;
          TO codigo INTO MENSAG,;
          TO codigo INTO EMCARNE,;
          TO EMCARNE->tip INTO TCARNES
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,17,11)           // nao quis configurar...
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
 lpp_022=LEFT(drvtapg,op_-1)+"022"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_022:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=20                                           // maximo de linhas no relatorio
IMPCTL(lpp_022)                                    // seta pagina com 22 linhas
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
   IF R06601F9()                                   // se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Eu,"
    @ cl,004 SAY COBRADOR->nome+' ('+cobrador+')'  // Cobrador
    IMPAC("representante aut“nomo,",cl,047)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "portador do CIC:"
    @ cl,017 SAY TRAN(COBRADOR->cpf,"@R 999.999.999-99")// CPF
    @ cl,032 SAY "e RG:"
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Recebi do Sr.:"
    @ cl,015 SAY GRUPOS->nome                      // Nome
    IF M->combarra=[S]
     CODBARRAS({{codigo+tipo+circ,4,13,59}},10,6)
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Endereco     :"
    @ cl,015 SAY GRUPOS->endereco                  // Endere‡o
    IF M->combarra=[S]
     CODBARRAS({{codigo+tipo+circ,4,13,59}},10,6)
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,015 SAY GRUPOS->bairro                    // Bairro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,015 SAY GRUPOS->cep+[ ]+ALLTRIM(GRUPOS->cidade)+[, ]+GRUPOS->uf// Cidade
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Contrato n§ :"
    IMPEXP(cl,015,GRUPOS->codigo,12)               // Codigo
    @ cl,030 SAY ALLTRIM(CLASSES->descricao)+[ ]+IIF(GRUPOS->formapgto<[05],SUBSTR(tbfpgto,(VAL(GRUPOS->formapgto)-1)*13+1,13),GRUPOS->formapgto)// definicao 1
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Parcela     :"
    @ cl,015 SAY tipo+[/]+circ+[ ]                 // compl.codigo 1
    IMPAC("A importƒncia de :  Contr :",cl,036)
    valororig=IIF(!CSTSEG->(EOF()),CSTSEG->vlorig,valor)// variavel temporaria
    @ cl,064 SAY TRAN(valororig,"@E 999,999.99")   // Valor Contribuicao
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "Vencimento  :"
    IMPCTL(drvpenf)
    @ cl,015 SAY TRAN(emissao_,"@D")               // Emissao
    IMPCTL(drvtenf)
    @ cl,056 SAY "Seguro:"
    @ cl,064 SAY TRAN(valor-valororig,"@E 999,999.99")// Valor Seguro
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPAC("Admiss„o    :",cl,000)
    @ cl,015 SAY TRAN(GRUPOS->admissao,"@D")       // Admiss„o
    @ cl,056 SAY "TOTAL.:"
    IF R06601F9()                                  // pode imprimir?
     IMPCTL(drvpenf)
     @ cl,064 SAY TRAN(valor,"@E 999,999.99")      // Valor Total
     IMPCTL(drvtenf)
    ENDI
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IMPAC("Referente a intermedia‡„o da venda do Plano de Assistˆncia Funeral da",cl,000)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY M->setup1                         // Ident1
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY ALLTRIM(M->p_cidade)+', ___ de ________________ de _____.'// Data
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,043 SAY REPL("_",30)
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,043 SAY COBRADOR->nome                    // Nome do Cobrador
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_RDP()                                        // imprime rodape' do relatorio
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
GRELA(17)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|CARNE FORM.BRANCO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE TAXAS                                        // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF R06601F9()                                    // se atender a condicao...

   #ifdef COM_REDE
    IF stat < [2]
     REPBLO('TAXAS->stat',{||[2]})
    ENDI
    IF VAL(circ)=TCARNES->parf
     REPBLO('EMCARNE->emissao_',{||DATE()})
    ENDI
   #else
    IF stat < [2]
     REPL TAXAS->stat WITH [2]
    ENDI
    IF VAL(circ)=TCARNES->parf
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

STATIC PROC REL_RDP                                // rodape'
@ 21,000 SAY "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
RETU 

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP()                                        // imprime rodape' do relatorio
 ENDI
 IMPCTL(drvpenf)
 IMPEXP(1,023,'R E C I B O',24)                    // recibo
 IMPCTL(drvtenf)
 cl=qt+1 ; pg_++
ENDI
RETU

* \\ Final de ADP_R075.PRG
