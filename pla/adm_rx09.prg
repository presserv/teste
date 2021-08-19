procedure adm_rx09
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_RX09.PRG
 \ Data....: 28-10-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Grupos & Proc.Pendentes
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=20, l_i:=13, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+9 SAY " GRUPOS C/TAXAS A EMITIR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Emiss„o:"
remissao_=CTOD('')                                 // Emiss„o
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+11 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_).AND.remissao_>=DATE()~Informe uma data v lida p/ EMISSŽO | data de hoje ou posterior.")
                  DEFAULT "CTOD('05'+SUBSTR(DTOC(DATE()+30),3))"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

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
  IF !USEARQ("ARQGRUP",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("ARQGRUP")                                // abre o dbf e seus indices
 #endi

 PTAB(grup+proxcirc,"CIRCULAR",1,.t.)              // abre arquivo p/ o relacionamento
 PTAB(classe,"CLASSES",1,.t.)
 SET RELA TO grup+proxcirc INTO CIRCULAR,;         // relacionamento dos arquivos
          TO classe INTO CLASSES
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="RIGHT(grup,1)+grup"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,12,11)           // nao quis configurar...
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
 IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("PRCESSOS",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("PRCESSOS")                                // abre o dbf e seus indices
#endi

cpord="grup+DTOS(dfal)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE ARQGRUP
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
hora_rel_=LEFT(TIME(),5)                           // hora de emissao do relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot026010:=tot026011:=tot026012 := 0             // inicializa variaves de totais
  qqu026=0                                         // contador de registros
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
   IF !(CLASSES->prior=[S])                        // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY grup                              // Grupo
    @ cl,004 SAY TRAN(classe,"99")                 // Classe
    @ cl,011 SAY inicio                            // Nr.Inicial
    @ cl,018 SAY final                             // Nr.Final
    @ cl,026 SAY TRAN(acumproc,"99")               // N§.Processos
    @ cl,031 SAY TRAN(periodic,"999")              // Periodicidade
    @ cl,038 SAY qtdremir                          // Remido
    @ cl,043 SAY TRAN(ultcirc,"999")               // Ultcirc
    @ cl,047 SAY TRAN(emissao_,"@D")               // Emissao
    tot026010+=procpend
    @ cl,059 SAY TRAN(procpend,"999")              // Processos
    tot026011+=contrat
    @ cl,067 SAY TRAN(contrat,"999")               // Contratos
    @ cl,071 SAY "/"
    tot026012+=partic
    @ cl,072 SAY TRAN(partic,"99999")              // Partic.
    qqu026++                                       // soma contadores de registros
    chv027=grup
    SELE PRCESSOS
    SEEK chv027
    IF FOUND()
     IF cl+4>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     cl+=2                                         // soma contador de linha
     @ cl,000 SAY "Processo  Circ Grp Contr Insc Falecido                            Data"
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "========= ==== === ===== ==== ============================================"
     DO WHIL ! EOF() .AND. chv027=grup //LEFT(&(INDEXKEY(0)),LEN(chv027))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
        BREAK                                      // confirmou...
       ENDI
      ENDI
      IF saiu<[001]                                // se atender a condicao...
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,000 SAY processo                       // Processo
       @ cl,010 SAY saiu                           // Circular
       @ cl,015 SAY grup                           // Grupo
       @ cl,019 SAY num                            // Contrato
       @ cl,025 SAY TRAN(grau,"9")                 // Inscr.
       @ cl,026 SAY "/"
       @ cl,027 SAY TRAN(seq,"99")                 // Seq
       @ cl,030 SAY fal                            // Falecido
       @ cl,066 SAY TRAN(dfal,"@D")                // Data
       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl,019 SAY TRAN(ends,"@!")                // Ends
       @ cl,059 SAY TRAN(cids,"@!")                // Cids
       SKIP                                        // pega proximo registro
      ELSE                                         // se nao atende condicao
       SKIP                                        // pega proximo registro
      ENDI
     ENDD
     cl+=3                                         // soma contador de linha
    ENDI
    SELE ARQGRUP                                   // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    IF !EOF()                                      // se nao atingiu o final do dbf
     REL_CAB(1)                                    // espacejamento duplo
    ENDI
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,059 SAY REPL('-',18)
  @ ++cl,059 SAY TRAN(tot026010,"999")             // total Processos
  @ cl,067 SAY TRAN(tot026011,"999")               // total Contratos
  @ cl,072 SAY TRAN(tot026012,"99999")             // total Partic.
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu026,"@E 999,999")
  REL_RDP()                                        // imprime rodape' do relatorio
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(12)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|GRUPOS & PROC.PENDENTES"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE ARQGRUP                                      // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF !(CLASSES->prior=[S])                         // se atender a condicao...

   #ifdef COM_REDE
    REPBLO('ARQGRUP->proxcirc',{||[000]})
    REPBLO('ARQGRUP->procpend',{||0})
   #else
    REPL ARQGRUP->proxcirc WITH [000]
    REPL ARQGRUP->procpend WITH 0
   #endi

   chv027=grup
   SELE PRCESSOS
   SEEK chv027
   IF FOUND()
    DO WHIL ! EOF() .AND. chv027=grup //LEFT(&(INDEXKEY(0)),LEN(chv027))
     IF saiu<[001]                                 // se atender a condicao...

      #ifdef COM_REDE
       REPBLO('ARQGRUP->procpend',{||ARQGRUP->procpend + 1})
      #else
       REPL ARQGRUP->procpend WITH ARQGRUP->procpend + 1
      #endi

      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
   ENDI
   SELE ARQGRUP                                    // volta ao arquivo pai
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE ARQGRUP                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_RDP                                // rodape'
IMPAC("Informar em Tabelas/Grupos o n£mero da pr¢xima Circular e cadastra-las em",64,000)
@ 65,000 SAY "Tabelas/Circulares"
RETU 

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP()                                        // imprime rodape' do relatorio
 ENDI
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,057 SAY NMES(DATE())                          // nome do mˆs
 @ 1,071 SAY "ADM_RX09"                            // c¢digo relat¢rio
 @ 2,000 SAY "GRUPOS P/RECIBO"
 @ 2,057 SAY NSEM(DATE())                          // dia da semana
 @ 2,065 SAY DTOC(DATE())                          // data do sistema
 @ 2,074 SAY hora_rel_                             // hora da emiss„o
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Gr Classe Inicial Final  Proc/Period Remir Ult Emissao  Proc.Pend Contr/Partic."
 @ 5,000 SAY REPL("-",79)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_RX09.PRG
