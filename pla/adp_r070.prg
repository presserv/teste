procedure adp_r070
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADP_R070.PRG
 \ Data....: 26-04-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: DÇbitos a Gerar
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=20, l_i:=21, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+13 SAY " DêBITOS A GERAR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "  Este relat¢rio apresenta a lista de"
@ l_s+02,c_s+1 SAY " todos os contratos que terÑo dÇbitos."
@ l_s+03,c_s+1 SAY "  << Obs.: Cadastre a circular >>"
@ l_s+04,c_s+1 SAY "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ"
@ l_s+05,c_s+1 SAY " EmissÑo:"
@ l_s+06,c_s+1 SAY " Grupo..:      De:       -"
@ l_s+07,c_s+1 SAY " £ltima Circular.:"
@ l_s+08,c_s+1 SAY " Pr¢xima Circular:"
@ l_s+10,c_s+1 SAY "    Confirme:"
remissao_=CTOD('')                                 // EmissÑo
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // NßProxima Circ.
rvlaux=0                                           // Valor
rnraux=0                                           // Nr.Auxiliar
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+05 ,c_s+11 GET  remissao_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Remissao_)~Informe uma data v†lida p/ EMISSéO | data de hoje ou posterior.")
                  DEFAULT "CTOD('05'+SUBSTR(DTOC(DATE()+30),3))"
                  AJUDA "Data da EmissÑo da Circular.| Para atualizar circulares se nÑo preenchidas| com antecedància."

 @ l_s+06 ,c_s+11 GET  rgrupo;
                  PICT "!!";
                  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).AND.PTAB(ARQGRUP->classe,'CLASSES',1)~GRUPO nÑo existe na tabela|ou|Categoria do grupo nÑo existe em tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                  MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 6 , 20 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 6 , 27 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 7 , 20 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 7 , 24 }
                  MOSTRA {"LEFT(TRAN(IIF(CLASSES->prior=[S],[Valor por màs......:],IIF(ARQGRUP->maxproc>ARQGRUP->acumproc,[Valor p/atendimento:],[Valor da circular.:])),[]),20)", 9 , 2 }

 @ l_s+08 ,c_s+20 GET  rproxcirc;
                  PICT "999";
                  VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).or.!EMPT(rproxcirc)~Para a emissÑo deste relat¢rio|a circular deve ser prÇviamente cadastrada")
                  AJUDA "Entre com o n£mero da pr¢xima circular|J† deve ter sido cadastrada em|Tabela-Circulares"
                  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+09 ,c_s+24 GET  rvlaux;
                  PICT "@E 999,999.99";
                  WHEN "v87001f9()"
                  DEFAULT "CIRCULAR->valor"
                  AJUDA "Informe o valor a cobrar"

 @ l_s+09 ,c_s+35 GET  rnraux;
                  PICT "99";
                  WHEN "1=3"
                  AJUDA "Este campo Ç utilizado para controle do sistema"

 @ l_s+10 ,c_s+15 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'.AND.V03001F9()~CONFIRME nÑo aceit†vel")
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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(tipcont,"CLASSES",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(grupo,"ARQGRUP",1,.t.)
 SET RELA TO tipcont INTO CLASSES,;                // relacionamento dos arquivos
          TO grupo INTO ARQGRUP
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,24,11)           // nao quis configurar...
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
  tot040011 := 0                                   // inicializa variaves de totais
  qqu040=0                                         // contador de registros
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
   IF grupo=M->rgrupo.AND.EMPT(rv4401f9())         // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(codigo,"999999")            // Codigo
    @ cl,007 SAY nome //+R08704F9()               // Nome
    @ cl,043 SAY TRAN(tipcont,"99")                // TC
    @ cl,046 SAY TRAN(formapgto,"99")              // FP
    @ cl,049 SAY TRAN(admissao,"@D")               // AdmissÑo
    @ cl,060 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
    @ cl,067 SAY TRAN(regiao,"999")                // Reg
		@ cl,072 SAY TRAN(cobrador,"!!!")               // Cob
    @ cl,076 SAY TRAN(funerais,"99")               // Fun
    @ cl,079 SAY TRAN(ultcirc,"999")               // Ult.

    vlaux01f9:=VAL_01F9()
    tot040011+=vlaux01f9
    @ cl,083 SAY TRAN(vlaux01f9,"99999999.99")    // Valor

    qqu040++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,083 SAY REPL('-',11)
  @ ++cl,083 SAY TRAN(tot040011,"99999999.99")     // total Valor
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu040,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(24)                                          // grava variacao do relatorio
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
 @ 0,084 SAY "PAG"
 @ 0,088 SAY TRAN(pg_,'9999')                      // n£mero da p†gina
 IMPAC(nsis,1,000)                                 // t°tulo aplicaáÑo
 @ 1,084 SAY "ADP_R070"                            // c¢digo relat¢rio
 IMPAC("GERA TAXAS C/RELAT¢RIO - EmissÑo",2,000)
 @ 2,033 SAY TRAN(M->remissao_,"@D")               // EmissÑo
 @ 2,045 SAY "Grupo"
 @ 2,051 SAY TRAN(M->rgrupo,"!!")                  // Grupo
 @ 2,054 SAY "Circ."
 @ 2,059 SAY TRAN(M->rproxcirc,"999")              // NßProxima Circ.
 @ 2,076 SAY NSEM(DATE())                          // dia da semana
 @ 2,084 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t°tulo a definir
 IMPAC("Contr. Nome                                TC FP AdmissÑo   Saitxa Reg Cob Fun Ult.  Valor",4,000)
 @ 5,000 SAY REPL("-",94)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R070.PRG
