procedure adm_r027
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADM_R027.PRG
 \ Data....: 26-04-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: N„o ter„o d‚bito gerado
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=20, l_i:=16, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
V87001F9()
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " DBITOS A GERAR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Emiss„o:"
@ l_s+02,c_s+1 SAY " Grupo..:      De:       -"
@ l_s+03,c_s+1 SAY " £ltima Circular.:"
@ l_s+04,c_s+1 SAY " Pr¢xima Circular:        Confirme:"
remissao_=CTOD('')                                 // Emiss„o
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
confirme=SPAC(1)                                   // Confirme
rnraux=0                                           // Nr.Auxiliar
rvlaux=0                                           // Valor
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+11 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_)~Informe uma data v lida p/ EMISSŽO | data de hoje ou posterior.")
                  DEFAULT "CTOD('05'+SUBSTR(DTOC(DATE()+30),3))"
                  AJUDA "Data da Emiss„o da Circular.| Para atualizar circulares se n„o preenchidas| com antecedˆncia."

 @ l_s+02 ,c_s+11 GET  rgrupo;
                  PICT "!!";
                  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1)~GRUPO n„o existe na tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                  MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 20 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 27 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 3 , 20 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),10)", 3 , 24 }

 @ l_s+04 ,c_s+20 GET  rproxcirc;
                  PICT "999";
                  VALI CRIT("rproxcirc>=ARQGRUP->ultcirc~A Pr¢xima circular deve ser maior|ou igual a £ltima emitida")
                  AJUDA "Entre com o n£mero da pr¢xima circular"
                  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+04 ,c_s+37 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'.AND.V03001F9()~CONFIRME n„o aceit vel")
                  AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"

 @ l_s+01 ,c_s+27 GET  rnraux;
                  PICT "99";
                  WHEN "1=3"
                  AJUDA "Este campo ‚ utilizado para controle do sistema"

 @ l_s+01 ,c_s+30 GET  rvlaux;
                  PICT "@E 999,999.99";
                  WHEN "1=3"
                  AJUDA "Este campo ‚ utilizado internamente pelo sistema"

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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

// PTAB(grupo,"ARQGRUP",1,.t.)                       // abre arquivo p/ o relacionamento
// PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(rgrupo+rproxcirc,"CIRCULAR",1,.t.)
// PTAB(regiao,"REGIAO",1,.t.)

 PTAB(tipcont,"CLASSES",1,.t.)
/*
 SET RELA TO grupo INTO ARQGRUP,;                  // relacionamento dos arquivos
          TO cobrador INTO COBRADOR,;
          TO grupo+ARQGRUP->proxcirc INTO CIRCULAR,;
          TO regiao INTO REGIAO,;
*/
 SET RELA TO tipcont INTO CLASSES
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,23,11)           // nao quis configurar...
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

PTAB(M->rgrupo,[ARQGRUP],1)
nini=ARQGRUP->inicio
nfin=ARQGRUP->final
ucir=ARQGRUP->ultcirc
nqtd=VAL(nfin) - VAL(nini) + 1
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
rvlaux:=1
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
IMPCTL(drvpcom)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  qqu039=0                                         // contador de registros
  qquremi:=qqucanc:=qquinex:=qqusait:=qtok:=0      // contador de registros
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
   IF codigo < nini
    SKIP
    LOOP
   ENDI
   IF codigo > nfin
    go bott          // For‡a a sa¡da...
    SKIP
    LOOP
   ENDI
   rv4401f9x:=RV4401F9() //Verifica motivo da nao geracao...
   IF !(ucir=M->rproxcirc) // Se a circular ainda nao foi gerada
    IF !EMPT(rv4401f9x)                            // se atender a condicao...
     REL_CAB(1)                                     // soma cl/imprime cabecalho
     @ cl,000 SAY grupo                             // Grupo
     @ cl,004 SAY codigo                            // Codigo
     @ cl,011 SAY LEFT(DTOC(admissao),6)+RIGHT(DTOC(admissao),2)  // Admiss„o
     @ cl,020 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
     @ cl,027 SAY TRAN(regiao,"999")                // Regi„o
     @ cl,031 SAY nome                              // Nome
     @ cl,067 SAY rv4401f9x                        // motivo
     @ cl,098 SAY TRAN(cobrador,"!!!")               // Cobrador
     DO CASE
     CASE rv4401f9x=[Can]
      qqucanc++
     CASE rv4401f9x=[Rem]
      qquremi++
     CASE rv4401f9x=[Sai]
      qqusait++
     ENDC
     qqu039++                                       // soma contadores de registros
     SKIP                                           // pega proximo registro
    ELSE                                            // se nao atende condicao
     qtok++
     SKIP                                           // pega proximo registro
    ENDI
   ELSE
    IF !(CLASSES->prior=[S]) // Impossivel verificar periodicos...
     IF !(PTAB(codigo+[2]+M->rproxcirc,[TAXAS],1).AND.TAXAS->valorpg=0)
      REL_CAB(1)                                     // soma cl/imprime cabecalho
      @ cl,000 SAY grupo                             // Grupo
      @ cl,004 SAY codigo                            // Codigo
      @ cl,011 SAY LEFT(DTOC(admissao),6)+RIGHT(DTOC(admissao),2)  // Admiss„o
      @ cl,020 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
      @ cl,027 SAY TRAN(regiao,"999")                // Regi„o
      @ cl,031 SAY nome                              // Nome
      @ cl,098 SAY TRAN(cobrador,"!!!")               // Cobrador
      qqu039++                                       // soma contadores de registros
      SKIP                                           // pega proximo registro
     ELSE                                            // se nao atende condicao
      qtok++
      SKIP                                           // pega proximo registro
     ENDI
    ENDI
   ENDI
  ENDD
  REL_CAB(1)                                     // soma cl/imprime cabecalho
  @ cl,000 SAY REPL("-",101)
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  qquinex:=nqtd-qtok-qqu039
  @ cl++,000 SAY " Quantidade: Remidos        "+TRAN(qquremi,"@E 999,999")
  @ cl++,000 SAY "             Cancelados     "+TRAN(qqucanc,"@E 999,999")
  @ cl++,000 SAY "             Inexistentes   "+TRAN(qquinex,"@E 999,999")
  @ cl++,000 SAY "             SaiTxa>Emissao "+TRAN(qqusait,"@E 999,999")
  qquoutr:=qqu039-qquremi-qqucanc-qqusait
  IF qquoutr>0
   @ cl++,000 SAY "             Outros         "+TRAN(qquoutr,"@E 999,999")
  ENDI
  @ cl++,000 SAY "*** Total do Grupo          "+TRAN(nqtd,"@E 999,999")
  @ cl++,000 SAY "    Nao Sai Taxas           "+TRAN(qqu039+qquinex,"@E 999,999")
  @ cl++,000 SAY "*** Emitidas c/Sucesso      "+TRAN(qtok,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtc20)                                    // retira comprimido
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(23)                                          // grava variacao do relatorio
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,089 SAY "PAG"
 @ 0,093 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,089 SAY "ADM_R027"                            // c¢digo relat¢rio
 IMPAC("NŽO SAI TAXAS -Circ:"+M->rproxcirc+[ de ]+DTOC(M->remissao_),2,000)
 @ 2,081 SAY NSEM(DATE())                          // dia da semana
 @ 2,089 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Grp/Codigo Admiss„o Saitxa Reg Nome                               motivo                     Cobrador",4,000)
 @ 5,000 SAY REPL("-",101)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R027.PRG
