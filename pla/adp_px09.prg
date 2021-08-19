procedure adp_px09
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Grupo Bom Pastor
 \ Programa: ADP_P009.PRG
 \ Data....: 17-08-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Transferˆncia
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=15, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " TRANSFERENCIA "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Contrato de...:"
@ l_s+03,c_s+1 SAY " Contrato para.:"
@ l_s+04,c_s+1 SAY " Confirme?.....:"
rcodigo=SPAC(6)                                    // Contrato de:
rcodig2=SPAC(6)                                    // Contrato para:
confirme=SPAC(1)                                   // Confirme?
gru1=SPAC(2)                                       // Gru1
gru2=SPAC(2)                                       // Gru2
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+18 GET  rcodigo;
                  PICT "999999";
                  VALI CRIT("PTAB(rcodigo,'GRUPOS',1).and.V00901F9()~CONTRATO n„o existe em arquivo de tabela|tecle F8 para consulta")
                  AJUDA "Informe o n£mero do contrato|ou tecle F8 para consulta em arquivo"
                  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'codigo','nome','endereco','cidade'},1,'codigo',[])"
                  MOSTRA {"LEFT(TRAN(IIF(PTAB(rcodigo,[GRUPOS],1),GRUPOS->nome,SPACE(35)),[]),35)", 2 , 4 }

 @ l_s+03 ,c_s+18 GET  rcodig2;
                  PICT "999999";
                  VALI CRIT("!PTAB(rcodig2,'GRUPOS',1).and.!EMPT(V00902F9())~CONTRATO n„o existe em arquivo de tabela|Tecle F8 para consulta em tabela")
                  AJUDA "Informe o n£mero do contrato|ou tecle F8 para consulta em arquivo"
                  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'codigo','nome','endereco','cidade'},1,'codigo',[])"

 @ l_s+04 ,c_s+18 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme=[S]~CONFIRME? n„o aceit vel")
                  AJUDA "Digite S para confirmar ou|Tecle ESC para sair"

 @ l_s+05 ,c_s+35 GET  gru1;
                  WHEN "1=3"

 @ l_s+05 ,c_s+38 GET  gru2;
                  VALI CRIT("!EMPT(gru2)~Necess rio informar GRU2");
                  WHEN "1=3"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="TRANSFERENCIA"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...


 #ifdef COM_REDE
  CLOSE GRUPOS
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE GRUPOS                                       // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 seek M->rcodigo
 DO WHIL !EOF() .and.M->rcodigo=codigo
  IF codigo=M->rcodigo                             // se atender a condicao...
   gru1:=GRUPOS->grupo
   gru2:=V00902F9()

   #ifdef COM_REDE
    REPBLO('GRUPOS->codigo',{||M->rcodig2})
    REPBLO('GRUPOS->grupo',{||gru2})
   #else
    REPL GRUPOS->codigo WITH M->rcodig2
    REPL GRUPOS->grupo WITH gru2
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD

 #ifdef COM_REDE
  IF !USEARQ("ARQGRUP",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("ARQGRUP")                                // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
 CLOSE GRUPOS
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

/*
 SELE ARQGRUP                                      // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  IF recno()=1                                     // se atender a condicao...
*/
   SELE GRUPOS                                     // arquivo alvo do lancamento

   #ifdef COM_REDE
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    APPE BLAN                                      // cria registro em branco
   #endi

   SELE ARQGRUP                                    // inicializa registro em branco
   REPL GRUPOS->codigo WITH M->rcodigo,;
        GRUPOS->grupo WITH M->gru1,;
        GRUPOS->situacao WITH [2],;
        GRUPOS->nome WITH [Transferido para ]+M->rcodig2,;
        GRUPOS->em_ WITH DATE(),;
        GRUPOS->por WITH M->usuario

   #ifdef COM_REDE
    GRUPOS->(DBUNLOCK())                           // libera o registro
   #endi

/*
   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
  exit
 ENDD
*/

 #ifdef COM_REDE
  IF !USEARQ("INSCRITS",.f.,10,1)                  // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("INSCRITS")                               // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE INSCRITS                                     // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 SEEK M->rcodigo
 DO WHIL !EOF() .and.codigo=M->rcodigo
  IF codigo=M->rcodigo                             // se atender a condicao...

   #ifdef COM_REDE
    REPBLO('INSCRITS->codigo',{||M->rcodig2})
   #else
    REPL INSCRITS->codigo WITH M->rcodig2
   #endi

  ENDI
  go top
  SEEK M->rcodigo
 ENDD

 #ifdef COM_REDE
  IF !USEARQ("ECOB",.f.,10,1)                      // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("ECOB")                                   // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE ECOB                                         // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 SEEK M->rcodigo
 DO WHIL !EOF().and.codigo=M->rcodigo
  IF codigo=M->rcodigo                             // se atender a condicao...

   #ifdef COM_REDE
    REPBLO('ECOB->codigo',{||M->rcodig2})
   #else
    REPL ECOB->codigo WITH M->rcodig2
   #endi
  ENDI
  go top
  SEEK M->rcodigo

 ENDD

 #ifdef COM_REDE
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE TAXAS                                        // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 SEEK M->rcodigo
 DO WHIL !EOF() .and.codigo=M->rcodigo
  IF codigo=M->rcodigo                             // se atender a condicao...

   #ifdef COM_REDE
    REPBLO('TAXAS->codigo',{||M->rcodig2})
   #else
    REPL TAXAS->codigo WITH M->rcodig2
   #endi
  ENDI
  go top
  SEEK M->rcodigo
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de ADP_P009.PRG
