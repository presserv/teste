procedure adc_rx76
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADC_RX76.PRG
 \ Data....: 14-09-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Ficha de Acerto
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=15, l_i:=18, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " CONTRATOS & COBRAN€AS "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY " Contratos de:                  at‚:"
@ l_s+03,c_s+1 SAY " Vencimentos de:                at‚:"
@ l_s+04,c_s+1 SAY " Imprimir as cobran‡as j  pagas?"
@ l_s+05,c_s+1 SAY " Imprimir as cobran‡as vencidas?"
@ l_s+06,c_s+1 SAY " M¡nimo de pendentes a listar..:"
@ l_s+07,c_s+1 SAY "                     Confirme?"
codi=SPAC(6)                                       // Codigo
codf=SPAC(6)                                       // Codigo
veni_=CTOD('')                                     // Venc.Inicial
venf_=CTOD('')                                     // Venc.Final
pag=[N] //SPAC(1)                                        // Pagas?
pend=SPAC(1)                                       // Pendentes?
rpend=0                                            // Nrpend
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+22 GET  codi;
									PICT "999999";
									VALI CRIT("PTAB(codi,'GRUPOS',1).OR.VAL(codi)=0~Necess rio informar CODIGO existente")
									AJUDA "Informe o n£mero do contrato"
									CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+02 ,c_s+41 GET  codf;
									PICT "999999";
									VALI CRIT("(PTAB(codf,'GRUPOS',1).AND.codf>=codi).OR.VAL(codf)=0~Necess rio informar CODIGO existente")
									AJUDA "Informe o n£mero do contrato"
									CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+03 ,c_s+21 GET  veni_;
									PICT "@D"
									AJUDA "Informe o primeiro vencimento a considerar"

 @ l_s+03 ,c_s+40 GET  venf_;
									PICT "@D"
									AJUDA "Informe o £ltimo vencimento a considerar"

 @ l_s+04 ,c_s+34 GET  pag;
									PICT "!";
									VALI CRIT("pag$([SN])~PAGAS? n„o aceit vel|Digite S ou N")
									DEFAULT "[N]"
									AJUDA "Digite S para listar as cobran‡as pagas."

 @ l_s+05 ,c_s+34 GET  pend;
									PICT "!";
									VALI CRIT("pend$([SN])~PENDENTES? n„o aceit vel|Digite S ou N")
									DEFAULT "[S]"
									AJUDA "Digite S para listar as cobran‡as pendentes"

 @ l_s+06 ,c_s+34 GET  rpend;
									PICT "99";
									VALI CRIT("!(rpend<0)~NRPEND n„o aceit vel")
									DEFAULT "3"
									AJUDA "Informe o n£mero m¡nimo de taxas|pendentes para listar"

 @ l_s+07 ,c_s+32 GET  confirme;
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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(codigo,"ECOB",1,.t.)                         // abre arquivo p/ o relacionamento
 SET RELA TO codigo INTO ECOB                      // relacionamento dos arquivos

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,52,11)           // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
//criterio=criterio_                                 // restabelece criterio e
//cpord=cpord_                                       // ordenacao definidos

#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos

SELE GRUPOS
DBOX("[ESC] Interrompe| | ",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
	INI_ARQ()                                        // acha 1o. reg valido do arquivo
	ccop++                                           // incrementa contador de copias
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
   SET DEVI TO SCRE                                // inicia a impressao
   @ 17,35 say codigo
   @ 18,35 say pg_
   SET DEVI TO PRIN                                // inicia a impressao
	 IF !(situacao = [1])
    SKIP
    LOOP
   ENDI
	 IF codigo < M->codi
    SKIP
    LOOP
   ENDI
   IF (M->codf>[000000].AND.codigo>M->codf)
    SKIP
    LOOP
   ENDI
	 IF M->rpend>R07601F9()
    SKIP
    LOOP
   ENDI    // se atender a condicao...
//	 IF codigo>=M->codi.AND.(M->codf=[000000].OR.codigo<=M->codf).AND.;
//			(M->rpend<=R07601F9())// se atender a condicao...
		REL_CAB(1)                                     // soma cl/imprime cabecalho
    IF ccop <= 2
		 IMPCTL(drvpenf)
    ENDI
		@ cl,000 SAY TRAN(codigo,"999999")            // Codigo
		@ cl,006 SAY "-"
		@ cl,007 SAY TRAN(grupo,"!!")                  // Grupo
		@ cl,010 SAY nome                              // Nome
    IF ccop <= 2
		 IMPCTL(drvTenf)
	   @ cl,046 SAY LEFT(ALLTRIM(telefone)+[/]+alltrim(contato),33)// Telefone
	   REL_CAB(2)                                     // soma cl/imprime cabecalho
	   @ cl,010 SAY TRAN(endereco,"@!")               // Endere‡o
	   REL_CAB(1)                                     // soma cl/imprime cabecalho
	   @ cl,010 SAY TRAN(ALLTRIM(bairro)+[ ]+ALLTRIM(cidade)+[, ]+uf+[ - CEP:]+TRAN(cep,"@R 99999-999"),"@!")// Cidade
	   subtt=0                                        // variavel temporaria
	   @ cl,067 SAY "Vend/Reg/Cob"
	   REL_CAB(1)                                     // soma cl/imprime cabecalho
		 IMPAC("Admiss„o:",cl,010)
		 @ cl,020 SAY TRAN(admissao,"@D")               // Admiss„o
		 @ cl,032 SAY "SaiTxa:"
		 @ cl,040 SAY TRAN(saitxa,"@R 99/99")           // Saitxa
		 @ cl,047 SAY "Dia Pgto:"
		 @ cl,057 SAY TRAN(diapgto,"99")                // Dia Pgto.
		 @ cl,068 SAY vendedor+[/]+regiao+[/]+cobrador  // Vend/Cob/Reg
		 IF !ECOB->(EOF())
		  SELE ECOB
		  REL_CAB(1)                                     // soma cl/imprime cabecalho
		  IF ECOB->tipo=[T]
		 	 @ cl,002 SAY [Endereco de trabalho]
		  ELSEIF ECOB->tipo=[R]
		 	 @ cl,002 SAY [Endereco de residencia]
		  ELSE
		 	 @ cl,002 SAY [Outro endereco  ]
		  ENDI
		  REL_CAB(1)                                     // soma cl/imprime cabecalho
		  @ cl,010 SAY TRAN(endereco,"@!")+[ ]+telefone  // Endere‡o
		  REL_CAB(1)                                     // soma cl/imprime cabecalho
		  @ cl,010 SAY TRAN(ALLTRIM(bairro)+[ ]+ALLTRIM(cidade)+[, ]+uf+[ - CEP:]+TRAN(cep,"@R 99999-999"),"@!")// Cidade
		  SELE GRUPOS
		 ENDI
	   chv088=codigo
	   SELE INSCRITS
	   SEEK chv088
	   IF FOUND()
		  cl+=2                                         // soma contador de linha
		  @ cl,002 SAY REPL("-",77)
		  cl+=1                                         // soma contador de linha
		  IMPAC("Inscritos no contrato                      Nascimento Observa‡„o",cl,002)
		  cl+=1                                         // soma contador de linha
//		 @ cl,002 SAY "=====  =================================== ========== ======================="
		  DO WHIL ! EOF() .AND. chv088=codigo //LEFT(&(INDEXKEY(0)),LEN(chv088))
		   #ifdef COM_TUTOR
		   IF IN_KEY()=K_ESC                            // se quer cancelar
		   #else
		   IF INKEY()=K_ESC                             // se quer cancelar
		   #endi
		    IF canc()                                    // pede confirmacao
		     BREAK                                       // confirmou...
		    ENDI
		   ENDI
		   REL_CAB(1)                                    // soma cl/imprime cabecalho
		   DO CASE
		    CASE grau=[1]
		     @ cl,002 SAY [Tit  ]                          // Inscr.
		    CASE grau=[2]
			   @ cl,002 SAY [Pai  ]                          // Inscr.
		    CASE grau=[3]
			   @ cl,002 SAY [Mae  ]                          // Inscr.
		    CASE grau=[4]
			   @ cl,002 SAY [Sogro]                          // Inscr.
		    CASE grau=[5]
			   @ cl,002 SAY [Sogra]                          // Inscr.
		    CASE grau=[6]
			   @ cl,002 SAY [Espos]                          // Inscr.
		    CASE grau=[7]
			   @ cl,002 SAY [Filh ]                          // Inscr.
		    CASE grau=[8]
			   @ cl,002 SAY [Depen]                          // Inscr.
		   ENDC
//		 @ cl,002 SAY grau+'-'+STR(seq,2)              // Inscr.
		   @ cl,009 SAY nome                             // Nome
		   @ cl,045 SAY TRAN(nascto_,"@D")               // Nascto
		   IF !EMPT(falecto_)
			  @ cl,054 SAY [Falecido em ]+TRAN(falecto_,"@D")              // Falecto.
//		  @ cl,063 SAY TRAN(tipo,"!!!")                 // Tipo
//		  @ cl,068 SAY TRAN(procnr,"@R 99999/99")       // N§Processo
		   ENDI
		   SKIP                                          // pega proximo registro
	    ENDD
	   ENDI
    ENDI ccop <= 2

	  SELE GRUPOS                                     // volta ao arquivo pai

		tot091004 := 0                                 // inicializa variaves de totais
		chv091=codigo
		SELE TAXAS
		SEEK chv091
		vlatras:=vlemdia:=0
		IF FOUND()
		 // Corrigir o valor antes de listar
		 DO WHILE !EOF().AND.TAXAS->codigo==GRUPOS->codigo
			IF EMPT(TAXAS->valorpg)
			 IF TAXAS->emissao_< DATE()
				vlatras+=ATUVALOR(tipo,valor,emissao_)
			 ELSE
				vlemdia+=TAXAS->valor
			 ENDI
			ENDI

			SKIP
		 ENDD
		 // De volta ao inicio
		 SELE TAXAS
		 SEEK chv091
     IF ccop <= 2
      IF cl+3>maxli                                 // se cabecalho do arq filho
		   REL_CAB(0)                                   // nao cabe nesta pagina
		  ENDI                                          // salta para a proxima pagina
		  cl+=2                                         // soma contador de linha
		  @ cl,002 SAY REPL("-",77)
		  cl+=1                                         // soma contador de linha
		  IMPAC("Cobran‡as do contrato ",cl,002)
		  cl+=1                                         // soma contador de linha
		  IMPAC("Circular Vencimento    Valor       Observa‡„o",cl,002)
		  IMPCTL(drvpenf)
		  @ cl,50 SAY [*Valor em atraso: ]+TRAN(vlatras,"@E 999,999.99")   // Valor
		  IMPCTL(drvtenf)
		  cl+=1                                         // soma contador de linha
		  qqu091=0                                      // contador de registros
		  DO WHIL ! EOF() .AND. chv091=codigo //LEFT(&(INDEXKEY(0)),LEN(chv091))
		  	#ifdef COM_TUTOR
		  	 IF IN_KEY()=K_ESC                           // se quer cancelar
		  	#else
		  	 IF INKEY()=K_ESC                            // se quer cancelar
		  	#endi
		  	 IF canc()                                   // pede confirmacao
		  		BREAK                                      // confirmou...
		  	 ENDI
		  	ENDI
			 IF R07701F9()                                // se atender a condicao...
			  REL_CAB(1)                                  // soma cl/imprime cabecalho
			 	IF TYPE("omt091001")!="C" .OR. omt091001!=tipo// imp se dif do anterior
			 	 omt091001=tipo                            // imp se dif do anterior
			 	ENDI
			  @ cl,002 SAY IIF(emissao_<DATE(),[*],[ ])
			  @ cl,003 SAY TRAN(tipo,"!")               // Tipo
			  @ cl,004 SAY "-"
			  @ cl,005 SAY TRAN(circ,"999")               // Circular
			  @ cl,011 SAY TRAN(emissao_,"@D")            // Emissao
        vlpend:=valor
        IF EMPT(valorpg)
         vlpend=ATUVALOR(tipo,valor,emissao_)
        ENDI
			  tot091004+=vlpend
			  @ cl,022 SAY TRAN(vlpend,"@E 999,999.99")   // Valor
			  vlpg=valorpg                                // variavel temporaria
			  subtt=subtt+vlpend-vlpg                     // variavel temporaria
//		  	 @ cl,033 SAY TRAN(subtt,"@E 999,999.99")    // Sub
			  IF !EMPT(valorpg)                             // pode imprimir?
			  	@ cl,044 SAY [pago em ]+dtoc(pgto_)        // Obs.
			  ENDI
			  IF (CL/2-INT(CL/2))=0
			  	@ cl,038 SAY REPL("- ",21)
			  ENDI

			  qqu091++                                    // soma contadores de registros
			  SKIP                                        // pega proximo registro
			 ELSE                                         // se nao atende condicao
			  SKIP                                        // pega proximo registro
			 ENDI
		  ENDD
     ENDI
     IF ccop <= 2
		  IF cl+3>maxli                                 // se cabecalho do arq filho
			 REL_CAB(0)                                   // nao cabe nesta pagina
		  ENDI                                          // salta para a proxima pagina
		  @ ++cl,022 SAY REPL('-',10)
		  @ ++cl,022 SAY TRAN(subtt,"@E 999,999.99")// total Valor
		  @ cl,003 SAY "*** Quantidade "+TRAN(qqu091,"999")
		  cl+=3                                    // soma cl/imprime cabecalho
		  @ cl,02 SAY [Data: ___ / ___ / ___]//
		  cl+=3
		  @ cl,002 SAY [Repres.:____________________________]
		  @ cl,038 SAY REPL("-",42)
		  cl++
		  @ cl,038 SAY [Contratante]


		  cl+=2                                         // soma contador de linha
     ELSE
		  @ cl,47 SAY TRAN(vlatras,"@E 9,999.99")   // Valor
		  @ cl,65 SAY TRAN(vlemdia,"@E 9,999.99")   // Valor
     ENDI
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    IF ccop <= 2
     cl=999                                         // forca salto de pagina
    ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(52)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPCTL(drvtcom)
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,071 SAY "ADC_RX76"                            // c¢digo relat¢rio
 IMPAC("FICHA DE ACERTOS",2,000)
 @ 2,024 SAY titrel                                // t¡tulo a definir
 @ 2,060 SAY NSEM(DATE())                          // dia da semana
 @ 2,069 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Contrato  Nome                                "+;
  IIF(ccop <= 2,"Telefone/ Contato","em atraso  em dia")
 @ 4,000 SAY REPL("-",79)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADC_RX76.PRG

