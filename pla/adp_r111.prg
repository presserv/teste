procedure adp_r111
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_R101.PRG
 \ Data....: 16-07-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Previs„o recebimento
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
@ l_s+01,c_s+1 SAY " At‚ dia.:"
@ l_s+02,c_s+1 SAY " Listar detalhes ?"
@ l_s+03,c_s+1 SAY "               Confirma?"
remiss_=CTOD('')                                   // Data final
confirme=SPAC(1)                                   // Confirme?
rdet=[S]                                   // Confirme?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+13 GET  remiss_;
									PICT "@D";
									VALI CRIT("!EMPT(Remiss_)~Informe uma data v lida p/ EMISSŽO")
									DEFAULT "DATE()+90-day(DATE()+90)"
									AJUDA "Informe a data final a considerar"

 @ l_s+02 ,c_s+26 GET  rdet;
									PICT "!";
									VALI CRIT("rdet$'SN'~Digite S para listar|ou| N para totalizar")
									AJUDA "Digite S listar os debitos|ou|N para totalizar"

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

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 SET RELA TO codigo INTO GRUPOS                    // relacionamento dos arquivos
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,56,11)           // nao quis configurar...
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
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
	INI_ARQ()                                        // acha 1o. reg valido do arquivo
	ccop++                                           // incrementa contador de copias
	qt001:=vl001:=0
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
	 IF valorpg>0           // se atender a condicao...
		SKIP
		LOOP                                           // pega proximo registro
	 ENDI
	 IF emissao_ > M->remiss_
		SKIP
		LOOP
	 ENDI
	 qt001++
	 vl001+=valor
	 IF M->rdet=[S]
		REL_CAB(1)                                       // soma cl/imprime cabecalho
		@ cl,000 SAY codigo                              // Codigo
		@ cl,007 SAY TRAN(GRUPOS->nome,"@!")             // Nome
		@ cl,043 SAY TRAN(GRUPOS->vendedor,"!!!")        // Vendedor
		@ cl,048 SAY TRAN(GRUPOS->regiao,"999")          // Regi„o
		@ cl,052 SAY LEFT(dtoc(emissao_),6)+RIGHT(dtoc(emissao_),2) // Regi„o
		@ cl,061 SAY tipo+[-]+circ                       // Circ
		@ cl,066 SAY TRAN(valor,"@E 999,999.99")         // Valor
	 ENDI
	 SKIP

	ENDD
	SKIP -1
	REL_CAB(1)                                       // soma cl/imprime cabecalho
	@ cl,031 SAY [Quantidade:]+str(qt001)                                   // Circ
	@ cl,066 SAY TRAN(vl001,"@E 999,999.99")         // Valor
	SKIP
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(56)                                          // grava variacao do relatorio
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
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
 @ 1,029 SAY titrel                                // t¡tulo a definir
 @ 1,070 SAY "ADP_R101"                            // c¢digo relat¢rio
 IMPAC("PREVISŽO RECEBIMENTO (at‚",2,000)
 @ 2,026 SAY TRAN(M->remiss_,"@D")                 // Data final
 @ 2,036 SAY ")"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 IMPAC("Codigo Nome                                Vend Reg  Circular      Valor",3,000)
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R101.PRG
