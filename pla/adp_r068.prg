procedure adp_r068
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R068.PRG
 \ Data....: 26-04-98
 \ Sistema.: Seguros
 \ Funcao..: Verificar Custos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=15, l_i:=15, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " VERIFICAR CUSTOS "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY "  Hist¢rico..:"
@ l_s+03,c_s+1 SAY "  Emiss„o de.:          at‚:"
rhist=SPAC(3)                                      // Hist¢rico
remiss_=CTOD('')                                   // Emiss„o
rem2_=CTOD('')                                     // Emiss„o
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+16 GET  rhist;
                  PICT "999";
                  VALI CRIT("rhist=[000].OR. PTAB(rhist,'HISTORIC',1)~HIST¢RICO n„o existe na tabela|Tecle F8 para consulta")
                  DEFAULT "M->histpg"
                  AJUDA "Informe o hist¢rico|a considerar"
                  CMDF8 "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico')"

 @ l_s+03 ,c_s+16 GET  remiss_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remiss_)~Informe uma data v lida p/ EMISSŽO")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data da cobran‡a de seguro gerada| a considerar"

 @ l_s+03 ,c_s+30 GET  rem2_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem2_)~Informe uma data v lida p/ EMISSŽO|final a considerar")
                  DEFAULT "DATE()"
                  AJUDA "Informe a £ltima data a considerar"

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
  IF !USEARQ("CSTSEG",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CSTSEG")                                 // abre o dbf e seus indices
 #endi

 PTAB(contrato,"GRUPOS",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(historic,"HISTORIC",1,.t.)
 SET RELA TO contrato INTO GRUPOS,;                // relacionamento dos arquivos
          TO historic INTO HISTORIC
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,2,11)            // nao quis configurar...
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
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot011006:=tot011007 := 0                        // inicializa variaves de totais
  qqu011=0                                         // contador de registros
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
   IF emissao_>=M->remiss_.AND.emissao_<=M->rem2_.AND.(M->rhist<[001].OR.historic=M->rhist)// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(emissao_,"@D")               // Emiss„o
    @ cl,009 SAY TRAN(hora,"99:99")                // Hora
    @ cl,015 SAY TRAN(historic,"999")              // Hist¢rico
    @ cl,019 SAY TRAN(contrato,"999999")           // Contrato
    @ cl,026 SAY TRAN(LEFT(complement,30),"@!")    // Complemento
    tot011006+=qtdade
    @ cl,057 SAY TRAN(qtdade,"99999")              // Qtdade
    tot011007+=valor
    @ cl,063 SAY TRAN(valor,"999999.99")           // Valor
    @ cl,074 SAY TRAN(tipo,"!")                    // Tipo
    @ cl,076 SAY TRAN(circ,"999")                  // Circ
    qqu011++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,057 SAY REPL('-',15)
  @ ++cl,057 SAY TRAN(tot011006,"99999")           // total Qtdade
  @ cl,063 SAY TRAN(tot011007,"999999.99")         // total Valor
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu011,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(2)                                           // grava variacao do relatorio
SELE CSTSEG                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,062 SAY "ADP_R068"                            // c¢digo relat¢rio
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,008 SAY "- VERIFICAR CUSTOS"
 @ 1,030 SAY titrel                                // t¡tulo a definir
 @ 1,062 SAY NSEM(DATE())                          // dia da semana
 @ 1,071 SAY DTOC(DATE())                          // data do sistema
 IF M->rhist>[000]                                 // pode imprimir?
  @ 2,000 SAY [Hist.:]+M->rhist+[ ]+HISTORIC->descricao// Hist¢rico
 ENDI
 @ 2,053 SAY "de:"
 @ 2,057 SAY TRAN(M->remiss_,"@D")                 // Emiss„o
 IMPAC("at‚:",2,066)
 @ 2,071 SAY TRAN(M->rem2_,"@D")                   // Emiss„o
 IMPAC("Emiss„o  Horas His Contr. Complemento                    Qtdade    Valor  Circ.",3,000)
 @ 4,000 SAY REPL("-",79)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R068.PRG
