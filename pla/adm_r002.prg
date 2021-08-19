procedure adm_r002
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R002.PRG
 \ Data....: 13-12-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Emiss„o de Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=8, l_i:=15, c_i:=66, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
IF nivelop < 3                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+25 SAY " RECIBOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Emiss„o.:            Mes.Ref.:        Valor:"
@ l_s+02,c_s+1 SAY " Mensagem:"
remissao_=CTOD('')                                 // Emiss„o
rmesref=SPAC(4)                                    // Mes.Ref.
recvalor=0                                         // Valor
recmensag=SPAC(60)                                 // Mensagem
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_)~Informe uma data v lida p/ EMISSŽO")
                  DEFAULT "DATE()"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

 @ l_s+01 ,c_s+33 GET  rmesref;
                  PICT "@R 99/99";
                  VALI CRIT("MMAA(rmesref)~Necess rio informar MES.REF.")
                  DEFAULT "SUBSTR(DTOC(remissao_),4,2)+RIGHT(DTOC(remissao_),2)"
                  AJUDA "Mˆs de referˆncia da cobran‡a"

 @ l_s+01 ,c_s+47 GET  recvalor;
                  PICT "@E 999,999.99";
                  VALI CRIT("recvalor>0~VALOR n„o aceit vel")
                  AJUDA "Este valor ser  para atualizar o arquivo de |Circulares caso n„o tenha sido preenchido."

 @ l_s+02 ,c_s+12 GET  recmensag;
                  PICT "@S45@!"
                  AJUDA "Entre com uma mensagem a ser impressa nos recibos|no caso de n„o existir uma na circular."

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
  IF !USEARQ("GRUPOS",.t.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(grupo,"ARQGRUP",1,.t.)                       // abre arquivo p/ o relacionamento
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(grupo+ARQGRUP->proxcirc,"CIRCULAR",1,.t.)
 PTAB(regiao,"REGIAO",1,.t.)
 PTAB(tipcont,"CLASSES",1,.t.)
 SET RELA TO grupo INTO ARQGRUP,;                  // relacionamento dos arquivos
          TO cobrador INTO COBRADOR,;
          TO grupo+ARQGRUP->proxcirc INTO CIRCULAR,;
          TO regiao INTO REGIAO,;
          TO tipcont INTO CLASSES
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="grupo+cobrador+codigo"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,21,11)           // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("CPRCIRC",.t.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CPRCIRC")                                 // abre o dbf e seus indices
#endi

cpord="grupo+DTOS(dfal)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
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
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  ult_imp=0                                        // ultimo reg impresso
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
   IF ARQGRUP->proxcirc>[000].AND.EMPT(R00201F9()).AND. !CLASSES->prior=[S]// se atender a condicao...
    REL_CAB(1,.t.)                                 // soma cl/imprime cabecalho
    @ cl,000 SAY [.]                               // teste
    ult_imp=RECNO()                                // ultimo reg impresso
    chv039=grupo
    SELE CPRCIRC
    SEEK chv039
    IF FOUND()
     DO WHIL ! EOF() .AND. chv039=LEFT(&(INDEXKEY(0)),LEN(chv039))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      IF circ==CIRCULAR->circ                      // se atender a condicao...
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       IMPCTL(drvpc20)                             // comprime os dados
       @ cl,033 SAY num                            // Contrato
       @ cl,041 SAY TRAN(processo,"@R 99999/99/!!")// Processo
       @ cl,054 SAY fal                            // Falecido
       @ cl,092 SAY TRAN(ALLTRIM(ends)+'-'+ALLTRIM(cids),"@!")// Ends
       @ cl,151 SAY TRAN(dfal,"@D")                // Data
       IMPCTL(drvtc20)                             // retira comprimido
       SKIP                                        // pega proximo registro
      ELSE                                         // se nao atende condicao
       SKIP                                        // pega proximo registro
      ENDI
     ENDD
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
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
GRELA(21)                                          // grava variacao do relatorio

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.t.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("COBRADOR",.t.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("COBRADOR")                                // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("FCCOB",.t.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("FCCOB")                                   // abre o dbf e seus indices
#endi


#ifdef COM_REDE
 IF !USEARQ("TXACONTR",.t.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TXACONTR")                                // abre o dbf e seus indices
#endi

msgt="PROCESSAMENTOS DO RELAT¢RIO|EMISSŽO DE TAXAS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE GRUPOS                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF ARQGRUP->proxcirc>[000].AND.EMPT(R00201F9()).AND. !CLASSES->prior=[S]// se atender a condicao...
   IF !PTAB(codigo+[2]+CIRCULAR->circ,'TAXAS',1)
    SELE TAXAS                                     // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     APPE BLAN                                     // cria registro em branco
    #endi

    SELE GRUPOS                                    // inicializa registro em branco
    REPL TAXAS->codigo WITH codigo,;
         TAXAS->tipo WITH [2],;
         TAXAS->circ WITH CIRCULAR->circ,;
         TAXAS->emissao_ WITH IIF(EMPT(CIRCULAR->emissao_),M->remissao_,CIRCULAR->emissao_),;
         TAXAS->valor WITH IIF(EMPT(CIRCULAR->valor),M->recvalor,CIRCULAR->valor),;
         TAXAS->cobrador WITH cobrador
    SELE TAXAS                                     // arquivo alvo do lancamento
    TAX_GET1(FORM_DIRETA)                          // faz processo do arq do lancamento

    #ifdef COM_REDE
     UNLOCK                                        // libera o registro
    #endi

    SELE GRUPOS                                    // arquivo origem do processamento
   ENDI
   IF COBRADOR->(EOF())
    SELE COBRADOR                                  // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     APPE BLAN                                     // cria registro em branco
    #endi

    SELE GRUPOS                                    // inicializa registro em branco
    REPL COBRADOR->cobrador WITH cobrador,;
         COBRADOR->nome WITH [COBRADOR NAO CADASTRADO]

    #ifdef COM_REDE
     COBRADOR->(DBUNLOCK())                        // libera o registro
    #endi

   ENDI
   IF !PTAB(cobrador+CIRCULAR->mesref,'FCCOB',1)
    SELE FCCOB                                     // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     APPE BLAN                                     // cria registro em branco
    #endi

    SELE GRUPOS                                    // inicializa registro em branco
    REPL FCCOB->cobrador WITH cobrador,;
         FCCOB->mesref WITH IIF(EMPT(CIRCULAR->mesref),M->rmesref,CIRCULAR->mesref)

    #ifdef COM_REDE
     FCCOB->(DBUNLOCK())                           // libera o registro
    #endi

   ENDI
   IF !PTAB(codigo,'TXACONTR',1)
    SELE TXACONTR                                  // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                    // tenta abri-lo
      IF NETERR()                                  // nao conseguiu
       DBOX(ms_uso,20)                             // avisa e
       LOOP                                        // tenta novamente
      ENDI
      EXIT                                         // ok. registro criado
     ENDD
    #else
     APPE BLAN                                     // cria registro em branco
    #endi

    SELE GRUPOS                                    // inicializa registro em branco
    REPL TXACONTR->codigo WITH codigo

    #ifdef COM_REDE
     TXACONTR->(DBUNLOCK())                        // libera o registro
    #endi

   ENDI

   #ifdef COM_REDE
    IF EMPT(CIRCULAR->mesref)
     REPBLO('CIRCULAR->mesref',{||M->rmesref})
    ENDI
    IF PTAB(codigo+CIRCULAR->circ,'TAXAS',1)
     REPBLO('TAXAS->emissao_',{||IIF(EMPT(CIRCULAR->emissao_),M->remissao_,CIRCULAR->emissao_)})
    ENDI
    IF PTAB(codigo+CIRCULAR->circ,'TAXAS',1)
     REPBLO('TAXAS->valor',{||IIF(EMPT(CIRCULAR->valor),M->recvalor,CIRCULAR->valor)})
    ENDI
    IF PTAB(codigo+CIRCULAR->circ,'TAXAS',1)
     REPBLO('TAXAS->cobrador',{||cobrador})
    ENDI
    REPBLO('TAXAS->stat',{||[2]})
    IF circinic='000'
     REPBLO('GRUPOS->circinic',{||CIRCULAR->circ})
    ENDI
   #else
    IF EMPT(CIRCULAR->mesref)
     REPL CIRCULAR->mesref WITH M->rmesref
    ENDI
    IF PTAB(codigo+CIRCULAR->circ,'TAXAS',1)
     REPL TAXAS->emissao_ WITH IIF(EMPT(CIRCULAR->emissao_),M->remissao_,CIRCULAR->emissao_)
    ENDI
    IF PTAB(codigo+CIRCULAR->circ,'TAXAS',1)
     REPL TAXAS->valor WITH IIF(EMPT(CIRCULAR->valor),M->recvalor,CIRCULAR->valor)
    ENDI
    IF PTAB(codigo+CIRCULAR->circ,'TAXAS',1)
     REPL TAXAS->cobrador WITH cobrador
    ENDI
    REPL TAXAS->stat WITH [2]
    IF circinic='000'
     REPL GRUPOS->circinic WITH CIRCULAR->circ
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
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_RDP(volta_reg)                     // rodape'
LOCAL ar_:=ALIAS(), reg_atual
SELE GRUPOS                                        // volta ao arquivo pai
reg_atual=RECNO()
IF volta_reg
 GO ult_imp                                        // ajusta reg p/ imp de campos no rodape'
ENDI
@ 21,009 SAY CHR(18)+IIF(EMPT(CIRCULAR->menscirc),M->recmensag,CIRCULAR->menscirc)// Mensagem
@ 25,018 SAY TRAN(IIF(EMPT(CIRCULAR->valor),M->recvalor,CIRCULAR->valor),"@E 999,999.99")// Valor 1
@ 25,064 SAY TRAN(IIF(EMPT(CIRCULAR->valor),M->recvalor,CIRCULAR->valor),"@E 999,999.99")// Valor 2
@ 28,021 SAY SPACE(7)   //M->nrauxrec              // N§ Recibo
@ 28,066 SAY SPACE(7) //M->nrauxrec                // N§ Recibo 2
@ 31,003 SAY CIRCULAR->circ+[     ]+DTOC(CIRCULAR->emissao_)+[     ]+STR(funerais,2)// Circular 1
@ 31,040 SAY CIRCULAR->circ+[     ]+DTOC(CIRCULAR->emissao_)+[     ]+STR(funerais,2)// Circular 2
@ 34,003 SAY grupo +[        ]+codigo+[       ]+cobrador// Grupo 1
@ 34,040 SAY grupo +[        ]+codigo+[       ]+cobrador// Grupo 2
@ 36,001 SAY nome                                  // Nome
@ 36,038 SAY nome                                  // Nome 2
@ 37,001 SAY endereco                              // Endere‡o
@ 37,038 SAY endereco                              // Endere‡o 2
@ 38,001 SAY bairro                                // Bairro
@ 38,038 SAY bairro                                // Bairro 2
@ 39,001 SAY LEFT(ALLTRIM(cidade)+cep,35)          // Cidade
@ 39,038 SAY LEFT(ALLTRIM(cidade)+cep,35)          // Cidade 2
@ 40,001 SAY [Inic:]+DTOC(admissao)+[ Ult:]+ultcirc+[ QtTx:]+STR(qtcircs,3)// Inicio
@ 40,038 SAY [Inic:]+DTOC(admissao)+[ Ult:]+ultcirc+[ QtTx:]+STR(qtcircs,3)// Inicio 2
@ 42,000 SAY ""
IF M->combarra=[S]
 CODBARRAS({{codigo+'1'+CIRCULAR->circ,4,13,6}},10,6)
ENDI
@ 43,000 SAY ""
IF M->combarra=[S]
 CODBARRAS({{codigo+'1'+CIRCULAR->circ,4,13,6}},10,6)
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
 SELE GRUPOS                                       // volta ao arquivo pai
 @ 1,008 SAY nome                                  // Nome
 @ 1,058 SAY codigo                                // Codigo
 @ 1,075 SAY grupo+IIF(EMPT(R00201F9()),[],[])     // Grupo
 @ 3,030 SAY TRAN(IIF(EMPT(CIRCULAR->valor),M->recvalor,CIRCULAR->valor),"@E 999,999.99")// Valor 0
 SELE (ar_)
 cl=qt+6 ; pg_++
ENDI
RETU

* \\ Final de ADM_R002.PRG
