procedure adp_r099
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADP_R099.PRG
 \ Data....: 14-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: èrea X Vendedor
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
@ l_s,c_s+16 SAY " èREA POR VENDEDOR "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Per°odo..: De:            AtÇ:"
@ l_s+02,c_s+1 SAY " RegiÑo...:"
@ l_s+03,c_s+1 SAY " Vendedor.:"
@ l_s+04,c_s+1 SAY " Anal°tico:"
@ l_s+05,c_s+1 SAY " Confirme:"
rde=CTOD('')                                       // De:
rate=CTOD('')                                      // AtÇ:
rregiao=SPAC(3)                                    // RegiÑo
rvend=SPAC(3)                                      // Vendedor
ranalit=[S]                                        // Anal°tico?
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+17 GET  rde;
                  PICT "@D";
                  VALI CRIT("!EMPT(rde)~Necess†rio informar a data inicial a considerar")
                  DEFAULT "DATE()-DAY(DATE())+1"
                  AJUDA "Informe a data inicial a considerar"

 @ l_s+01 ,c_s+33 GET  rate;
                  PICT "@D";
                  VALI CRIT("!EMPT(rate)~Necess†rio informar ATê:")
                  DEFAULT "DATE()"
                  AJUDA "Informe a data final a considerar"

 @ l_s+02 ,c_s+13 GET  rregiao;
                  PICT "999";
                  VALI CRIT("PTAB(rregiao,'REGIAO',1).OR.EMPT(VAL(rregiao))~REGIéO nÑo existe na tabela")
                  AJUDA "Informe a regiÑo ou tecle F8 para busca em tabela"
                  CMDF8 "VDBF(6,38,20,77,'REGIAO',{'codigo','regiao'},1,'codigo')"
                  MOSTRA {"LEFT(TRAN(REGIAO->regiao,[]),30)", 2 , 17 }

 @ l_s+03 ,c_s+13 GET  rvend;
                  PICT "999";
                  VALI CRIT("PTAB(rvend,'COBRADOR',1).OR.rvend=[000]~VENDEDOR nÑo existe na tabela")
                  AJUDA "Informe o c¢digo do Vendedor|ou|Tecle F8 para consulta em arquivo"
                  CMDF8 "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador')"
                  MOSTRA {"LEFT(TRAN(COBRADOR->nome,[]),30)", 3 , 17 }

 @ l_s+04 ,c_s+13 GET  ranalit;
                  PICT "!";
                  VALI CRIT("ranalit $ [SN]~ANAL°TICO? nÑo aceit†vel")
                  DEFAULT "[N]"
                  AJUDA "Digite S para listar os detalhes|ou|N para somente totais"
                  CMDF8 "MTAB([Sim, liste os detalhes|NÑo, apenas totalize],[ANAL°TICO?])"

 @ l_s+05 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME nÑo aceit†vel|Digite S ou Tecle ESC")
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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(vendedor,"COBRADOR",1,.t.)                   // abre arquivo p/ o relacionamento
 PTAB(regiao,"REGIAO",1,.t.)
 PTAB(codigo,"TAXAS",1,.t.)
 SET RELA TO vendedor INTO COBRADOR,;              // relacionamento dos arquivos
          TO regiao INTO REGIAO,;
          TO codigo INTO TAXAS
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="regiao+vendedor"
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
	qqu039=0                                         // contador de registros
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
	 IF admissao>=M->rde.AND.admissao<=M->rate.AND.(M->rregiao$'000,'+regiao).AND.(M->rvend$'000,'+vendedor)// se atender a condicao...
		REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,020 SAY &drvpexp.+'[ '+regiao+' - '+REGIAO->regiao+' ]'+&drvtexp.// titulo da quebra
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY REPL("-",115)

		qb03901=regiao                                 // campo para agrupar 1a quebra
		qqu03901=0                                     // contador de registros
		DO WHIL !EOF() .AND. regiao=qb03901
		 #ifdef COM_TUTOR
			IF IN_KEY()=K_ESC                            // se quer cancelar
		 #else
			IF INKEY()=K_ESC                             // se quer cancelar
		 #endi
			IF canc()                                    // pede confirmacao
			 BREAK                                       // confirmou...
			ENDI
		 ENDI
		 IF admissao>=M->rde.AND.admissao<=M->rate.AND.(M->rregiao$'000,'+regiao).AND.(M->rvend$'000,'+vendedor)// se atender a condicao...
			REL_CAB(1)                                   // soma cl/imprime cabecalho
			@ cl,000 SAY '[ '+vendedor+'-'+COBRADOR->nome+' ]'// titulo da quebra
//			REL_CAB(1)                                   // soma cl/imprime cabecalho
			qb03902=regiao+vendedor                      // campo para agrupar 1a quebra
			qqu03902=0                                   // contador de registros
			DO WHIL !EOF() .AND. regiao=qb03901 .AND. regiao+vendedor=qb03902
			 #ifdef COM_TUTOR
				IF IN_KEY()=K_ESC                          // se quer cancelar
			 #else
				IF INKEY()=K_ESC                           // se quer cancelar
			 #endi
				IF canc()                                  // pede confirmacao
				 BREAK                                     // confirmou...
				ENDI
			 ENDI
			 IF admissao>=M->rde.AND.admissao<=M->rate.AND.(M->rregiao$'000,'+regiao).AND.(M->rvend$'000,'+vendedor)// se atender a condicao...
				IF M->ranalit=[S]
				 REL_CAB(1)                                 // soma cl/imprime cabecalho
				 @ cl,000 SAY TRAN(codigo,"999999")         // Contr.
				 @ cl,007 SAY TRAN(nome,"@!")               // Nome
				 @ cl,043 SAY TRAN(endereco,"@!")           // Endereáo
				 @ cl,079 SAY TRAN(cidade,"@!")             // Cidade
				 @ cl,105 SAY TRAN(admissao,"@D")           // AdmissÑo
				ENDI
				qqu03901++                                 // soma contadores de registros
				qqu03902++                                 // soma contadores de registros
				qqu039++                                   // soma contadores de registros
				SKIP                                       // pega proximo registro
			 ELSE                                        // se nao atende condicao
				SKIP                                       // pega proximo registro
			 ENDI
			ENDD
//			REL_CAB(1)                                   // soma cl/imprime cabecalho
			@ cl,117 SAY "* Total: "+TRAN(qqu03902,"@E 999,999")
		 ELSE                                          // se nao atende condicao
			SKIP                                         // pega proximo registro
		 ENDI
		ENDD
		REL_CAB(1)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY "* Quantidade "+TRAN(qqu03901,"@E 999,999")
		@ ++cl,000 SAY REPL("-",115)
	 ELSE                                            // se nao atende condicao
		SKIP                                           // pega proximo registro
	 ENDI
	ENDD
	REL_CAB(2)                                       // soma cl/imprime cabecalho
	@ cl,000 SAY "*** Quantidade total "+TRAN(qqu039,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcom)                                    // retira comprimido
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
 @ 0,055 SAY titrel                                // t°tulo a definir
 @ 0,107 SAY "PAG"
 @ 0,111 SAY TRAN(pg_,'9999')                      // n£mero da p†gina
 IMPAC(nsis,1,000)                                 // t°tulo aplicaáÑo
 @ 1,107 SAY "ADP_R099"                            // c¢digo relat¢rio
 IMPAC("VENDEDOR X èREA",2,000)
 @ 2,099 SAY NSEM(DATE())                          // dia da semana
 @ 2,107 SAY DTOC(DATE())                          // data do sistema
 IMPAC("Contr. Nome                                Endereáo                            Cidade                    AdmissÑo",3,000)
 @ 4,000 SAY REPL("-",115)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R099.PRG
