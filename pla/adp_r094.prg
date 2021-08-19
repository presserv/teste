procedure adp_r094
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R094.PRG
 \ Data....: 01-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Acerto de Nosso N£mero
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=17, l_i:=15, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+11 SAY " ACERTO DE NOSSO N£MERO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " N£mero inicial:"
@ l_s+03,c_s+1 SAY "   Novo N£mero de Boleto:"
@ l_s+04,c_s+1 SAY " Qtd.a corrigir:"
@ l_s+05,c_s+1 SAY "                Confirme.:"
numinic=SPAC(6)                                    // N£mero inicial
newnnum=SPAC(10)                                   // N£mero Corrigido
qtdade=0                                           // Qtdade
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+18 GET  numinic;
                  PICT "999999";
                  VALI CRIT("PTAB(numinic,'BOLETOS',1)~Boleto n„o cadastrado|Verifique")
                  AJUDA "Informe o n£mero do primeiro|boleto a corrigir"
                  CMDF8 "VDBF(6,12,20,77,'BOLETOS',{'seq','nnumero','codigo','tipo','circ','por','em_'},1,'seq',[])"
                  MOSTRA {"LEFT(TRAN(BOLETOS->codigo,[999999]),06)", 2 , 33 }
                  MOSTRA {"LEFT(TRAN(BOLETOS->nnumero,[9999999999]),10)", 2 , 22 }
                  MOSTRA {"LEFT(TRAN(BOLETOS->tipo,[!]),01)", 2 , 40 }
                  MOSTRA {"LEFT(TRAN(BOLETOS->circ,[999]),03)", 2 , 42 }
                  MOSTRA {"LEFT(TRAN(BOLETOS->por,[]),10)", 2 , 2 }
                  MOSTRA {"LEFT(TRAN(BOLETOS->em_,[@D]),08)", 2 , 13 }

 @ l_s+03 ,c_s+27 GET  newnnum;
                  PICT "9999999999";
                  VALI CRIT("!EMPT(newnnum)~Necess rio informar N£mero correto|")
                  AJUDA "Informe o n£mero correto do boleto"

 @ l_s+04 ,c_s+18 GET  qtdade;
                  PICT "99999";
                  VALI CRIT("qtdade>0~QTDADE n„o aceit vel")
                  AJUDA "Informe a quantidade de boletos a trocar"
                  CMDF8 "VDBF(6,36,20,77,'BOLETOS',{'seq','nnumero','codigo','tipo','circ'},1,'V09001F9()',[])"

 @ l_s+05 ,c_s+28 GET  confirme;
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
  CLOSE BOLETOS
  IF !USEARQ("BOLETOS",.t.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("BOLETOS")                                // abre o dbf e seus indices
 #endi

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,46,11)           // nao quis configurar...
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
  qqu068=0                                         // contador de registros
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
   IF seq>=M->numinic.and.val(seq)<VAL(M->numinic)+M->qtdade// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY TRAN(seq,"999999")                // Seq
    @ cl,007 SAY TRAN(codigo,"999999")             // Contrato
    @ cl,017 SAY TRAN(tipo,"!")                    // Tipo
    @ cl,019 SAY TRAN(circ,"999")                  // N.Circ
    @ cl,024 SAY nnumero       // N.N£mero
    @ cl,035 SAY STRZERO(VAL(M->newnnum)+(VAL(seq)-VAL(M->numinic)),10)// Novo n£mero
    qqu068++                                       // soma contadores de registros
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu068,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(46)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|ACERTO DE NOSSO N£MERO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE BOLETOS                                      // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF seq>=M->numinic.and.val(seq)<VAL(M->numinic)+M->qtdade// se atender a condicao...

   #ifdef COM_REDE
    REPBLO('BOLETOS->nnumero',{||(STRZERO(VAL(M->newnnum)+(VAL(seq)-VAL(M->numinic)),10))})
//    TRAN(VAL(M->newnnum)+(VAL(seq)-VAL(M->numinic)),[9999999999])})
   #else
    REPL BOLETOS->nnumero WITH (STRZERO(VAL(M->newnnum)+(VAL(seq)-VAL(M->numinic)),10))
//    TRAN(VAL(M->newnnum)+(VAL(seq)-VAL(M->numinic)),[9999999999])
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,070 SAY "ADP_R094"                            // c¢digo relat¢rio
 IMPAC("ACERTO DE NOSSO N£MERO",2,000)
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 IMPAC("Seq    Contrato  Circ.  N.N£mero   Novo n£mero",4,000)
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R094.PRG
