procedure adm_r035
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R035.PRG
 \ Data....: 15-02-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Taxas pendentes
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=14, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+16 SAY " TAXAS PENDENTES "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Cobrador.:"
@ l_s+03,c_s+1 SAY "               Confirma?"
rcobrador=SPAC(3)                                  // Cobrador
confirme=SPAC(1)                                   // Confirme?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+13 GET  rcobrador;
									PICT "!!!";
									VALI CRIT("PTAB(rcobrador,'COBRADOR',1).OR.EMPT(rcobrador)~COBRADOR n„o existe na tabela")
									AJUDA "Digite o c¢digo do COBRADOR que|receber  as Taxas deste contrato,|Tecle F8 para consultar os cobradores."
									CMDF8 "VDBF(6,49,20,77,'BAIRROS',{'bairro','cobrador'},1,'cobrador')"
									MOSTRA {"LEFT(TRAN(COBRADOR->nome,[]),30)", 1 , 16 }
									MOSTRA {"LEFT(TRAN(COBRADOR->endereco,[]),30)", 2 , 16 }

 @ l_s+03 ,c_s+26 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~Digite S para confirmar|ou|Tecle ESC para cancelar")
                  AJUDA "Digite S para confirmar|ou|Tecle ESC para cancelar"

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
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,47,11)           // nao quis configurar...
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
  tot081005:=tot081007 := 0                        // inicializa variaves de totais
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
   IF valorpg=0.AND.(EMPT(M->rcobrador).OR.cobrador=M->rcobrador)// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY codigo                            // Codig
    @ cl,007 SAY TRAN(tipo,"!")                    // Tipo
    @ cl,008 SAY TRAN(circ,"999")                  // Circ
    @ cl,012 SAY TRAN(emissao_,"@D")               // Emissao
    tot081005+=valor
    @ cl,021 SAY TRAN(valor,"@E 999,999.99")       // Valor
    @ cl,032 SAY IIF(PTAB(codigo,[GRUPOS],1),GRUPOS->nome+[ ]+GRUPOS->vendedor,[ ])

/*
    @ cl,032 SAY TRAN(pgto_,"@D")                  // Pagto.
    tot081007+=valorpg
    @ cl,041 SAY TRAN(valorpg,"@E 999,999.99")     // Valor pago
    @ cl,052 SAY forma                             // F
*/
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,021 SAY REPL('-',30)
  @ ++cl,021 SAY TRAN(tot081005,"@E 999,999.99")   // total Valor
//  @ cl,041 SAY TRAN(tot081007,"@E 999,999.99")     // total Valor pago
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(47)                                          // grava variacao do relatorio
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
 @ 1,070 SAY "ADM_R035"                            // c¢digo relat¢rio
 @ 2,000 SAY "TAXAS PENDENTES"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Codigo Circ Vencimento    Valor Nome"
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R035.PRG
