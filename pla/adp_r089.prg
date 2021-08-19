procedure adp_r089
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R089.PRG
 \ Data....: 06-11-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contratos vagos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, lin_det:=[]
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=13, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " CONTRATOS VAGOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Grupo...:"
@ l_s+02,c_s+1 SAY " Confirme:"
rgrupo=SPAC(2)                                     // Grupo
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rgrupo
                  AJUDA "Informe o grupo a listar|tecle ENTER para listar todos"

 @ l_s+02 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~CONFIRME n„o aceit vel")
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
  IF !USEARQ("ARQGRUP",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("ARQGRUP")                                // abre o dbf e seus indices
 #endi

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="RIGHT(grup,1)+grup"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,69,11)           // nao quis configurar...
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
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

GO BOTT
finax :=VAL(codigo)

cpord="grup"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE ARQGRUP
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
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
   IF EMPT(M->rgrupo).OR.M->rgrupo=grup            // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(grup,"!!")                   // Grupo
    @ cl,006 SAY TRAN(classe,"99")                 // Classe
    @ cl,013 SAY TRAN(inicio,"999999")             // Nr.Inicial
    @ cl,024 SAY TRAN(final,"999999")              // Nr.Final
    @ cl,034 SAY TRAN(acumproc,"99")               // Min
    @ cl,038 SAY TRAN(maxproc,"99")                // Max
    @ cl,041 SAY TRAN(cpadmiss,"!")                // Adm?
    @ cl,050 SAY TRAN(periodic,"999")              // Period.
    @ cl,057 SAY TRAN(qtdremir,"999")              // Remido
    @ cl,061 SAY TRAN(poratend,"!")                // P/Atend.
    @ cl,070 SAY TRAN(proxcirc,"999")              // Prox.Circ
    chv105=[]
    iniax :=VAL(inicio)-1
    finax :=VAL(final)
    SELE GRUPOS
    SEEK chv105
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     IMPCTL(drvpcom)                               // comprime os dados
     cl+=1                                         // soma contador de linha
     IMPAC("Contratos inexistentes",cl,000)
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "====== ========"
     IMPCTL(drvtcom)                               // retira comprimido
     qqu105=0                                      // contador de registros
     DO WHIL M->iniax < M->finax
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
	      BREAK                                      // confirmou...
       ENDI
      ENDI
      M->iniax+=1
      M->codaux:=STRZERO(M->iniax,6)
      IF PTAB(M->codaux,"GRUPOS",1)
       LOOP
      ENDI
      lin_det+=M->codaux+[  ]
      IF LEN(lin_det)>110
       REL_CAB(1)                                   // soma cl/imprime cabecalho
       IMPCTL(drvpcom)                              // comprime os dados
       @ cl,000 SAY lin_det
       lin_det:=[]
       IMPCTL(drvtcom)                              // retira comprimido
      ENDI
      qqu105++                                     // soma contadores de registros
      SKIP                                         // pega proximo registro
     ENDD
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     @ cl,000 SAY lin_det
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     IMPCTL(drvpcom)                               // comprime os dados
     @ cl,000 SAY "*** Quantidade total Inexistentes."+TRAN(qqu105,"@E 999,999")
     IMPCTL(drvtcom)                               // retira comprimido
     cl+=2                                         // soma contador de linha
    ENDI
    SELE ARQGRUP                                   // volta ao arquivo pai
    chv105=[]
    iniax :=VAL(inicio)-1
    finax :=VAL(final)
    SELE GRUPOS
    SEEK chv105
    IF FOUND()
     IF cl+3>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     IMPCTL(drvpcom)                               // comprime os dados
     cl+=1                                         // soma contador de linha
     IMPAC("Contratos Cancelados",cl,000)
     cl+=1                                         // soma contador de linha
     @ cl,000 SAY "====== ========"
     IMPCTL(drvtcom)                               // retira comprimido
     qqu105=0                                      // contador de registros
     DO WHIL M->iniax < M->finax
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
	BREAK                                      // confirmou...
       ENDI
      ENDI
      M->iniax+=1
      M->codaux:=STRZERO(M->iniax,6)
      IF !PTAB(M->codaux,"GRUPOS",1)
       LOOP
      ENDI
      IF !(GRUPOS->situacao=[1])
       lin_det+=M->codaux+[-]+GRUPOS->situacao+[  ]
       IF LEN(lin_det)>110
	REL_CAB(1)                                   // soma cl/imprime cabecalho
	IMPCTL(drvpcom)                              // comprime os dados
	@ cl,000 SAY lin_det
	lin_det:=[]
	IMPCTL(drvtcom)                              // retira comprimido
       ENDI
       qqu105++                                     // soma contadores de registros
       SKIP                                         // pega proximo registro
      ENDI
     ENDD
     REL_CAB(1)                                   // soma cl/imprime cabecalho
     @ cl,000 SAY lin_det
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     IMPCTL(drvpcom)                               // comprime os dados
     @ cl,000 SAY "*** Quantidade Inativos "+TRAN(qqu105,"@E 999,999")
     IMPCTL(drvtcom)                               // retira comprimido
     cl+=2                                         // soma contador de linha
    ENDI
    SELE ARQGRUP                                   // volta ao arquivo pai
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(69)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,071 SAY "ADP_R089"                            // c¢digo relat¢rio
 @ 2,000 SAY "CONTRATOS VAGOS"
 @ 2,023 SAY titrel                                // t¡tulo a definir
 @ 2,063 SAY NSEM(DATE())                          // dia da semana
 @ 2,071 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Grupo Classe Nr.Inicial Nr.Final Min Max Adm? Period. Remido P/Atend. Prox.Circ"
 @ 4,000 SAY REPL("-",79)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R089.PRG
