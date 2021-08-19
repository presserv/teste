procedure adp_r100
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_R100.PRG
 \ Data....: 14-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Comiss„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=17, l_i:=15, c_i:=66, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+16 SAY " COMISSŽO NA VENDA "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Relat¢rio de comiss„o sobre as parcelas"
@ l_s+02,c_s+1 SAY " pagas no per¡odo."
@ l_s+03,c_s+1 SAY " Per¡odo..: De:            At‚:"
@ l_s+04,c_s+1 SAY " Vendedor.:"
@ l_s+05,c_s+1 SAY " Anal¡tico:"
@ l_s+06,c_s+1 SAY " Confirme:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // At‚:
rvend=SPAC(3)                                      // Vendedor
ranalit=[S]                                        // Anal¡tico?
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+03 ,c_s+17 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+03 ,c_s+33 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess rio informar AT:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

 @ l_s+04 ,c_s+13 GET  rvend;
                  PICT "999";
                  VALI CRIT("PTAB(rvend,'COBRADOR',1).OR.rvend=[000]~VENDEDOR n„o existe na tabela")
                  AJUDA "Informe o c¢digo do Vendedor|ou|Tecle F8 para consulta em arquivo"
                  CMDF8 "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador')"
                  MOSTRA {"LEFT(TRAN(COBRADOR->nome,[]),30)", 4 , 17 }

 @ l_s+05 ,c_s+13 GET  ranalit;
                  PICT "!";
                  VALI CRIT("ranalit $ [SN]~ANAL¡TICO? n„o aceit vel")
                  DEFAULT "[N]"
                  AJUDA "Digite S para listar os detalhes|ou|N para somente totais"
                  CMDF8 "MTAB([Sim, liste os detalhes|N„o, apenas totalize],[ANAL¡TICO?])"

 @ l_s+06 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n„o aceit vel|Digite S ou Tecle ESC")
                  AJUDA "Digite S para confirmar |ou|Tecle ESC para cancelar"

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
 PTAB(GRUPOS->vendedor,"COBRADOR",1,.t.)
 PTAB(COBRADOR->cobrador,"PCBRAD",1,.t.)
 SET RELA TO codigo INTO GRUPOS,;                  // relacionamento dos arquivos
          TO GRUPOS->vendedor INTO COBRADOR,;
          TO COBRADOR->cobrador INTO PCBRAD
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="GRUPOS->vendedor+tipo+circ"
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
IMPCTL(drvpcom)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
	INI_ARQ()                                        // acha 1o. reg valido do arquivo
	ccop++                                           // incrementa contador de copias
	tot040005:=tot040007:=tot040010 := 0             // inicializa variaves de totais
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
	 IF pgto_>=M->rde.AND.pgto_<=M->rate.AND.(M->rvend$'000,'+GRUPOS->vendedor)// se atender a condicao...
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,040 SAY '[ '+COBRADOR->cobrador+' - '+COBRADOR->nome+' ]'+;
		'             [ Supervisor: '+COBRADOR->superv+' ]' // titulo da quebra
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		qb04001=GRUPOS->vendedor                       // campo para agrupar 1a quebra
		st04001005:=st04001007:=st04001010 := 0        // inicializa sub-totais
		qqu04001=0                                     // contador de registros
		DO WHIL !EOF() .AND. GRUPOS->vendedor=qb04001
		 #ifdef COM_TUTOR
			IF IN_KEY()=K_ESC                            // se quer cancelar
		 #else
			IF INKEY()=K_ESC                             // se quer cancelar
		 #endi
			IF canc()                                    // pede confirmacao
			 BREAK                                       // confirmou...
			ENDI
		 ENDI
		 IF pgto_>=M->rde.AND.pgto_<=M->rate.AND.(M->rvend$'000,'+GRUPOS->vendedor)// se atender a condicao...
			vltax=valor                                  // variavel temporaria
			pccob=IIF(PTAB(GRUPOS->vendedor+tipo+circ,[PCBRAD],1).AND.EMPT(PCBRAD->vlcomiss),PCBRAD->pcomiss,0)// variavel temporaria
			vlcob=IIF(PTAB(GRUPOS->vendedor+tipo+circ,[PCBRAD],1).AND.PCBRAD->vlcomiss>0,PCBRAD->vlcomiss,pccob*vltax/100)// variavel temporaria
			spv=COBRADOR->superv                         // variavel temporaria
			pcspv=IIF(PTAB(spv+tipo+circ,[PCBRAD],1).AND.EMPT(PCBRAD->vlcomiss),PCBRAD->pcomiss,0)// variavel temporaria
			vlsup=IIF(PTAB(spv+tipo+circ,[PCBRAD],1).AND.PCBRAD->vlcomiss>0,PCBRAD->vlcomiss,pcspv*valor/100)// variavel temporaria
			IF (vlsup+vlcob) > 0
			 st04001005+=vltax
			 tot040005+=vltax
			 st04001007+=vlcob
			 tot040007+=vlcob
			 st04001010+=vlsup
			 tot040010+=vlsup
			 IF M->ranalit=[S]
				REL_CAB(1)                                   // soma cl/imprime cabecalho
				@ cl,000 SAY TRAN(GRUPOS->codigo,"999999")   // Contr.
				@ cl,007 SAY TRAN(GRUPOS->nome,"@!")         // Nome
				@ cl,043 SAY tipo+[-]+circ                   // Parcela
				@ cl,051 SAY TRAN(pgto_,"@D")                // Pagto.
				@ cl,062 SAY TRAN(vltax,"@E 999,999.99")     // Valor
				@ cl,073 SAY TRAN(pccob,"999.9")             // Porc.
				@ cl,079 SAY TRAN(vlcob,"@E 999,999.99")     // Vl.Comiss.
//				@ cl,090 SAY TRAN(spv,"999")                 // Spv.
				@ cl,095 SAY TRAN(pcspv,"999.9")             // %Sup.
				@ cl,101 SAY TRAN(vlsup,"@E 999,999.99")     // Vl.Sup.
			 ENDI
			 qqu04001++                                   // soma contadores de registros
			 qqu040++                                     // soma contadores de registros
			ENDI
			SKIP                                         // pega proximo registro
		 ELSE                                          // se nao atende condicao
			SKIP                                         // pega proximo registro
		 ENDI
		ENDD
		IF cl+3>maxli                                  // se cabecalho do arq filho
		 REL_CAB(0)                                    // nao cabe nesta pagina
		ENDI                                           // salta para a proxima pagina
		IF M->ranalit=[S]
		 @ ++cl,062 SAY REPL('-',49)
		 cl++
		ENDI
		@ cl,000 SAY "* Quantidade "+TRAN(qqu04001,"@E 999,999")
		@ cl,062 SAY TRAN(st04001005,"@E 999,999.99")// sub-tot Valor
		@ cl,079 SAY TRAN(st04001007,"@E 999,999.99")  // sub-tot Vl.Comiss.
		@ cl,101 SAY TRAN(st04001010,"@E 999,999.99")  // sub-tot Vl.Sup.
//		REL_CAB(1)                                     // soma cl/imprime cabecalho
	 ELSE                                            // se nao atende condicao
		SKIP                                           // pega proximo registro
	 ENDI
	ENDD
	IF cl+3>maxli                                    // se cabecalho do arq filho
	 REL_CAB(0)                                      // nao cabe nesta pagina
	ENDI                                             // salta para a proxima pagina
	REL_CAB(2)
	@ ++cl,062 SAY REPL('-',49)
	@ ++cl,000 SAY "*** Quantidade total "+TRAN(qqu040,"@E 999,999")
	@ cl,062 SAY TRAN(tot040005,"@E 999,999.99")   // total Valor
	@ cl,079 SAY TRAN(tot040007,"@E 999,999.99")     // total Vl.Comiss.
	@ cl,101 SAY TRAN(tot040010,"@E 999,999.99")     // total Vl.Sup.
//	REL_CAB(2)                                       // soma cl/imprime cabecalho
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcom)                                    // retira comprimido
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(24)                                          // grava variacao do relatorio
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
 @ 0,057 SAY titrel                                // t¡tulo a definir
 @ 0,103 SAY "PAG"
 @ 0,107 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,103 SAY "ADP_R100"                            // c¢digo relat¢rio
 IMPAC("COMISSŽO       De:",2,000)
 @ 2,019 SAY TRAN(M->rde,"@D")                     // De:
 IMPAC("At‚:",2,031)
 @ 2,036 SAY TRAN(M->rate,"@D")                    // At‚:
 @ 2,095 SAY NSEM(DATE())                          // dia da semana
 @ 2,103 SAY DTOC(DATE())                          // data do sistema
 @ 3,076 SAY "Vendedor              Supervisor"
 @ 4,000 SAY "Contr. Nome                                Parcela Pagto.          Valor   %   Vl.Comiss.        %   Vl.Comiss."
 @ 5,000 SAY REPL("-",111)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADP_R100.PRG
