procedure fin_rc97
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica -Limeira (019)452.6623
 \ Programa: FIN_RC97.PRG
 \ Data....: 03-07-02
 \ Sistema.: Controle de Financeiro
 \ Funcao..: Exporta Lancamentos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "finbig.ch"    // inicializa constantes manifestas

LOCAL linhaexp := ""
LOCAL nHandlex := 0
LOCAL nBytes  := 501
LOCAL nlinhas := 0
LOCAL nLenRarqexp:=74
Rarqexp := SPACE(nLenRarqexp)
PRIV dele_atu, cur_atual, getlist:={}
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=6, c_s:=7, l_i:=17, c_i:=75, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+24 SAY " EXPORTA LANCAMENTOS "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY "                     Exporta‡„o de lan‡amento"
@ l_s+03,c_s+1 SAY "   Digite o intervalo de lan‡amentos para exportar para arquivo"
@ l_s+04,c_s+1 SAY "                 do BB Cobran‡a do Banco do Brasil"
@ l_s+05,c_s+1 SAY " Lan‡amento."
@ l_s+06,c_s+1 SAY "   De:"
@ l_s+07,c_s+1 SAY "  At‚:"
@ l_s+08,c_s+1 SAY "        Condi‡„o extra para que o lan‡amento seja exportado"
PRIV m_lancini:=SPAC(7)                            // Do lan‡amento
PRIV m_lancfin:=SPAC(7)                            // Ate lancto
PRIV m_cond:=SPAC(200)                             // Condic„o
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+06 ,c_s+08 GET  m_lancini;
		  PICT "9999999";
		  VALI CRIT("!EMPT(m_lancini).AND.PTAB(m_lancini,[LANCTOS],1)~LAN€AMENTO n„o existe na tabela")
		  AJUDA "Digite o numero do lanctamento"
		  CMDF8 "VDBF(6,3,20,77,'LANCTOS',{'numos','lancto_','tipolanc','cliente','contalanct','documento','vencto_','historico','origem','complement','valortotal','debcred'},1,'numos',[])"
		  MOSTRA {"LEFT(TRAN(IIF(!EMPT(M->m_lancini),LANCTOS->documento,[oo]),[@!]),15)", 6 , 20 }
		  MOSTRA {"LEFT(TRAN(IIF(!EMPT(M->m_lancfin),LANCTOS->documento,[oo]),[@!]),15)", 7 , 20 }

 @ l_s+07 ,c_s+08 GET  m_lancfin;
		  PICT "9999999";
		  VALI CRIT("!EMPT(m_lancfin).AND.PTAB(m_lancfin,[LANCTOS],1)~LANCTO n„o existe na tabela")
		  AJUDA "Digite o numero do lancamento final"
		  CMDF8 "VDBF(6,3,20,77,'LANCTOS',{'numos','lancto_','tipolanc','cliente','contalanct','documento','vencto_','historico','origem','complement','valortotal','debcred'},1,'numos',[])"
 m_cond:=[TIPOLANC="2".AND.VLRTOTBAIXA=0]+SPACE(61)
 @ l_s+09 ,c_s+04 GET  m_cond;
		  PICT "@S61@!"
		  AJUDA "Digite alguma condi‡„o para exportar o lancamento|ou deixe em branco para n„o haver condi‡„o"
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
M->m_cond=IIF(EMPT(M->m_cond),[1=1],M->m_cond)
cur_atual=SETCURSOR(0)
cod_sos=1

rblocksize:=rreadsize:=501
IF FILE('MRC97VAR.MEM')
 REST FROM MRC97VAR ADDITIVE
ENDI
msg="Informe o nome do arquivo a exportar"
Rarqexp=DBOX(msg,,,,,"ATEN€ŽO!",LEFT(Rarqexp+SPACE(nLenRarqexp),nLenRarqexp),"@!")    // confirma a data
Rarqexp=ALLTRIM(Rarqexp)
IF EMPT(Rarqexp)
 DBOX([Nome de arquivo invalido])
 RETU 1
ENDI
SAVE TO MRC97VAR ALL LIKE Rarqexp

msgp="EXPORTA LANCAMENTOS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgp)
IF op_=1
 POE_GAUGE("Processando registros","AGUARDE!","Feitos:")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  CLOSE LANCTOS
  IF !USEARQ("LANCTOS",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("LANCTOS")                                // abre o dbf e seus indices
 #endi

 PTAB(cliente,"CLIENTES",2,.t.)                    // abre arquivo p/ o relacionamento
 SET RELA TO cliente INTO CLIENTES                 // relacionamento dos arquivos
 cpord="numos"
 criterio="(EMPT(M->m_lancini).OR.M->m_lancini<=numos).AND.(EMPT(M->m_lancfin).OR.M->m_lancfin>=numos).AND.(EMPT(M->m_cond).OR.1=1)" //&(M->m_cond)=.t.)"
 chv_rela:=chv_1:=chv_2 := ""
 INDTMP()
 SELE LANCTOS                                      // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo

 linhaexp := [000271767602000117APARECIDO VALENTIM OSTI ME]+ZEROS(456)
 nHandlex := FCREATE( Rarqexp, FC_NORMAL )
 IF FWRITEln(nHandlex,linhaexp,nBytes)<nBytes.OR.FERROR() != 0
  DBOX([Erro na escrita do arquivo:]+Rarqexp+[|O processo ser  cancelado.])
  RETU 1
 ENDI
 nlinhas+=1
 DO WHIL !EOF().AND.POE_GAUGE()
  IF (EMPT(M->m_lancini).OR.M->m_lancini<=numos).AND.(EMPT(M->m_lancfin).OR.M->m_lancfin>=numos).AND.(EMPT(M->m_cond).OR.&(M->m_cond)=.t.)// se atender a condicao...
   linhaexp=[]
   nlinhas+=1
   IF !EMPT(linhaexp)
    DBOX([Erro de escrita em variavel na memoria. Tente novamente.])
    RETU 1
    linhaexp:=""
   ENDI
//   linhaexp=[0107191800000]+numos+SPACE(3+20+25)+[DM   ]+;
   linhaexp=[0107191811019]+LEFT(documento,10)+ZEROS(20)+SPACE(25)+[DM   ]+;
   RIGHT(DTOS(lancto_),2)+SUBST(DTOS(lancto_),5,2)+LEFT(DTOS(lancto_),4)+;
   RIGHT(DTOS(vencto_),2)+SUBST(DTOS(vencto_),5,2)+LEFT(DTOS(vencto_),4)+;
   RIGHT([0000000000000]+LEFT(ALLTRIM(STR(valortotal,13,2)),LEN(ALLTRIM(STR(valortotal,13,2)))-3)+;
   RIGHT(ALLTRIM(STR(valortotal,13,2)),2),13)+[09   0000000000000N0000000000000]+;
   SPACE(8+13+13+2+40+40+2+14+37)+[S]+IIF(CLIENTES->tipopess=[J],[02],[01])+;
   IIF(CLIENTES->tipopess=[J],CLIENTES->ncgc,LEFT(ALLTRIM(CLIENTES->cpf)+SPACE(14),14))+;
   LEFT(IIF(EMPT(cliente),CLIENTES->nome,cliente),37)+;
   LEFT(IIF(EMPT(CLIENTES->endereco2),CLIENTES->endereco,CLIENTES->endereco2),37)+;
   IIF(EMPT(CLIENTES->endereco2),CLIENTES->cep,CLIENTES->cep2)+;
   LEFT(IIF(EMPT(CLIENTES->endereco2),CLIENTES->cidade,CLIENTES->cidade2),15)+;
   IIF(EMPT(CLIENTES->endereco2),CLIENTES->uf,CLIENTES->uf2)+;
   ZEROS(61)+[01]+ZEROS(18)

   IF FWRITEln(nHandlex,linhaexp,nBytes)<nBytes.OR.FERROR() != 0
    DBOX([Erro na escrita do arquivo:]+Rarqexp+[|O processo ser  cancelado.])
    RETU 1
   ENDI

   #ifdef COM_REDE
    IF 1=3
     REPBLO('CLIENTES->numconta',{||CLIENTES->numconta})
    ENDI
   #else
    IF 1=3
     REPL CLIENTES->numconta WITH CLIENTES->numconta
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 linhaexp=[]
 linhaexp := [99]+RIGHT([000000]+ALLTRIM(STR(nlinhas-1)),6)+SPACE(492)
 IF FWRITEln(nHandlex,linhaexp,nBytes)<nBytes.OR.FERROR() != 0
  DBOX([Erro na escrita do arquivo:]+Rarqexp+[|O processo ser  cancelado.])
  RETU 1
 ENDI
 nlinhas+=1

 FCLOSE(nHandlex)
 DBOX(Rarqexp+[|Numero de registros exportados: ]+STR(nlinhas-2)+;// Desconta Cabecalho e rodape como registro exportado
	      [|Numero de linhas escritas: ]+STR(nlinhas)+[|]+;// Mostra registro exportado e cabecalho e rodape.
	      [Processo terminado com sucesso!],,,,,msgp)
 SELE LANCTOS                                      // seleciona arquivo
 SET RELA TO                                       // retira os relacionamentos
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgp)
ENDI
SETCURSOR(cur_atual)
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de FIN_RC97.PRG


FUNCTION FWriteLn( nHandle, cString, nLength, cDelim )

   IF cDelim == NIL
      cString += CHR(13) + CHR(10)
   ELSE
      cString += cDelim
   ENDIF

   RETURN ( FWRITE( nHandle, cString, nLength ) )
