procedure ambarx41
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: AMBAR041.PRG
 \ Data....: 07-06-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contrato Baldochi
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=19, l_i:=16, c_i:=58, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " IMPRESS�O CONTRATO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Codigo:"
@ l_s+04,c_s+1 SAY "                      Confirma ?"
rcodigo=SPAC(6)                                    // Codigo
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+10 GET  rcodigo;
                  PICT "999999";
                  VALI CRIT("PTAB(rcodigo,'GRUPOS',1)~CODIGO n�o aceit�vel")
                  AJUDA "Entre com o n�mero do contrato a imprimir"
                  CMDF8 "VDBF(6,20,20,77,'GRUPOS',{'codigo','nome','admissao'},3,'codigo',[])"
                  MOSTRA {"LEFT(TRAN(GRUPOS->nome,[@!]),35)", 2 , 3 }
                  MOSTRA {"LEFT(TRAN(GRUPOS->endereco,[]),35)", 3 , 3 }

 @ l_s+04 ,c_s+34 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~CONFIRME n�o aceit�vel|Digite S ou tecle ESC para cancelar")
                  AJUDA "Digite S para imprimir o contrato|ou |Tecle ESC para cancelar"

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

 PTAB(codigo,"EMCARNE",1,.t.)                      // abre arquivo p/ o relacionamento
 PTAB(codigo,"INSCRITS",1,.t.)
 PTAB(codigo,"ECOB",1,.t.)
 SET RELA TO codigo INTO EMCARNE,;                 // relacionamento dos arquivos
          TO codigo INTO INSCRITS,;
          TO codigo INTO ECOB
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,11,11)           // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

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
ENDRAUX:=.F.
SELE GRUPOS
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=150                                           // maximo de linhas no relatorio
IMPCTL(drvpde8)                                    // ativa 8 lpp
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
	INI_ARQ()                                        // acha 1o. reg valido do arquivo
	SEEK M->rcodigo
	ccop++                                           // incrementa contador de copias
  ult_imp=0                                        // ultimo reg impresso
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
   IF codigo==M->rcodigo                           // se atender a condicao...
    REL_CAB(6,.t.)                                 // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    IMPEXP(cl,016,codigo,12)                       // Codigo
    IMPCTL(drvtenf)
    IMPEXP(cl,029,TRAN(grupo,"!!"),4)              // Grupo
    ult_imp=RECNO()                                // ultimo reg impresso
    REL_CAB(8)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,021 SAY nome                              // Nome
    IMPCTL(drvtenf)
    @ cl,059 SAY TRAN(cpf,"@R 999.999.999-99")     // CPF
    REL_CAB(4)                                     // soma cl/imprime cabecalho
		ENDRAUX:=PTAB(GRUPOS->codigo+[R],[ECOB],1)
		IF endraux
		 @ cl,021 SAY TRAN(ECOB->endereco,"@!")// Endere�o Res
		 @ cl,059 SAY TRAN(ECOB->telefone,"@!")         // Telefone Res
		ENDI
		REL_CAB(4)                                     // soma cl/imprime cabecalho
		IF endraux
		 @ cl,010 SAY TRAN(ECOB->bairro,"@!")           // Bairro Res
		 @ cl,046 SAY TRAN(ECOB->cidade,"@!")           // Cidade Res
		 @ cl,072 SAY TRAN(ECOB->uf,"!!")               // UF Res
		ENDI
		REL_CAB(4)                                     // soma cl/imprime cabecalho
		IF endraux
		 @ cl,023 SAY endereco                          // Endere�o
		 @ cl,059 SAY TRAN(telefone,"@!")               // Telefone
		ENDI
		REL_CAB(4)                                     // soma cl/imprime cabecalho
		@ cl,014 SAY natural                           // Naturalidade
		@ cl,051 SAY TRAN(nascto_,"@D")                // Nascto
		REL_CAB(4)                                     // soma cl/imprime cabecalho
		@ cl,059 SAY IIF(!EMPT(estcivil),SUBS(tbestciv,AT(estcivil,tbestciv),11),[])// Est Civil
		REL_CAB(8)                                     // soma cl/imprime cabecalho
		IF PTAB(GRUPOS->codigo+[T],[ECOB],1)
		 @ cl,012 SAY TRAN(ECOB->endereco,"@!")// Endere�o Trab
		 @ cl,059 SAY TRAN(ECOB->telefone,"@!")         // Telefone Trab
		ENDI
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY "."
		REL_CAB(5)                                     // soma cl/imprime cabecalho
    @ cl,045 SAY TRAN(relig,"@!")                  // Relig
    REL_CAB(12)                                    // soma cl/imprime cabecalho
		@ cl,000 SAY "."
		chv024=codigo
		SELE INSCRITS
		SEEK chv024
		IF FOUND()
		 IF cl+2>maxli                                 // se cabecalho do arq filho
			REL_CAB(0)                                   // nao cabe nesta pagina
		 ENDI
		 IMPINSAUX:=[]                                 // salta para a proxima pagina
		 DO WHIL ! EOF() .AND. chv024=codigo //LEFT(&(INDEXKEY(0)),LEN(chv024))
			#ifdef COM_TUTOR
			 IF IN_KEY()=K_ESC                           // se quer cancelar
			#else
			 IF INKEY()=K_ESC                            // se quer cancelar
			#endi
			 IF canc()                                   // pede confirmacao
				BREAK                                      // confirmou...
			 ENDI
			ENDI
			DO CASE
			CASE grau=[2]
			 cl:=65
			CASE grau=[3]
			 cl:=69
			CASE grau=[4]
			 cl:=73
			CASE grau=[5]
			 cl:=77
			CASE grau=[6]
			 cl:=95
			CASE grau=[7].and.!([7]$IMPINSAUX)
			 cl:=99
			 IMPINSAUX+=[7]
			CASE grau=[8].and.!([8]$IMPINSAUX)
			 cl:=137
			 IMPINSAUX+=[8]
			ENDCASE

			IF grau>'1'                                  // se atender a condicao...
			 REL_CAB(3)                                  // soma cl/imprime cabecalho
			 @ cl,025 SAY nome+[   ] +IIF(grau>'5',dtoc(nascto_),[])                          // Nome
			 IF grau<'6'.and.vivofalec='V'               // pode imprimir?
				@ cl,063 SAY 'X'                           // tab1
			 ENDI
			 @ cl,075 SAY IIF(grau<'6'.AND.vivofalec='F',' X',IIF(!EMPT(nascto_),DTOC(nascto_),[ ]))// tab2
			 SKIP                                        // pega proximo registro
			ELSE                                         // se nao atende condicao
			 SKIP                                        // pega proximo registro
			ENDI
		 ENDD
		 cl+=1                                         // soma contador de linha
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  REL_RDP(.t.)                                     // imprime rodape' do relatorio
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtde8)                                    // ativa 6 lpp
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(11)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT�RIO|CONTRATO BALDOCHI"
ALERTA()
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_RDP(volta_reg)                     // rodape'
LOCAL ar_:=ALIAS(), reg_atual
SELE GRUPOS                                        // volta ao arquivo pai
reg_atual=RECNO()
IF volta_reg
 GO ult_imp                                        // ajusta reg p/ imp de campos no rodape'
ENDI
@ 85,001 SAY CHR(27)+'2'                           // desabilita 216/21
IF volta_reg
 GO reg_atual                                      // retorna reg a posicao original
ENDI
SELE (ar_)
RETU 

STATIC PROC REL_CAB(qt, volta_reg)                 // cabecalho do relatorio
LOCAL ar_:=ALIAS()
volta_reg=IF(volta_reg=NIL,.f.,volta_reg)
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IF pg_>1
  REL_RDP(volta_reg)                               // imprime rodape' do relatorio
 ENDI
 SELE GRUPOS                                       // volta ao arquivo pai
 @ 0,000 SAY CHR(27)+'3'+chr(15)                   // habilita 216
 SELE (ar_)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de AMBAR041.PRG
