procedure amexrx41
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: ADEXR041.PRG
 \ Data....: 03-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contrato SEFEX - Extrema
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}, so_um_reg, sit_dbf:=POINTER_DBF()
PARA  lin_menu, col_menu, imp_reg
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=11, l_i:=15, c_i:=66, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
so_um_reg=(PCOU()>2)
IF !so_um_reg                             // vai receber a variaveis?
 SETCOLOR(drvtittel)
 vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)    // pega posicao atual da tela
 CAIXA(mold,l_s,c_s,l_i,c_i)              // monta caixa da tela
 @ l_s,c_s+18 SAY " IMPRESSŽO CONTRATO "
 SETCOLOR(drvcortel)
 @ l_s+01,c_s+1 SAY " Imprimir os contratos do n§ :        at‚ o n§"
 @ l_s+02,c_s+1 SAY "          os lan‡ados entre..:           e"
 @ l_s+04,c_s+1 SAY "                   Reimpress„o?:"
 @ l_s+05,c_s+1 SAY "                    Confirme...:"
ENDI
rcodin=SPAC(6)                                     // Codigo
rcodfi=SPAC(6)                                     // Codigo
rlanc1_=CTOD('01/01/1998')                                   // Lan‡.Inic.
rlanc2_=CTOD('01/01/2000')                                   // Lan‡.Final
rreimp=[S] //PAC(1)                                     // Reimprimir?
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 IF !so_um_reg
	SET KEY K_ALT_F8 TO ROLATELA
	SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
	@ l_s+01 ,c_s+32 GET  rcodin;
									 PICT "999999";
									 VALI CRIT("PTAB(rcodin,'GRUPOS',1)~CODIGO n„o aceit vel")
									 AJUDA "Entre com o n£mero do |primeiro contrato a imprimir"
									 CMDF8 "VDBF(6,20,20,77,'GRUPOS',{'codigo','nome','admissao'},1,'codigo',[])"

	@ l_s+01 ,c_s+48 GET  rcodfi;
									 PICT "999999";
									 VALI CRIT("PTAB(rcodfi,'GRUPOS',1)~CODIGO n„o aceit vel")
									 AJUDA "Entre com o n£mero do |£ltimo contrato a imprimir"
									 CMDF8 "VDBF(6,20,20,77,'GRUPOS',{'codigo','nome','admissao'},1,'codigo',[])"
/*
	@ l_s+02 ,c_s+32 GET  rlanc1_;
									 PICT "@D";
									 VALI CRIT("!EMPT(Rlanc1_)~Deve ser informada uma data v lida.")
									 DEFAULT "DATE()"
									 AJUDA "Listar os contratos lan‡ados| a partir de qual data."

	@ l_s+02 ,c_s+45 GET  rlanc2_;
									 PICT "@D";
									 VALI CRIT("!EMPT(Rlanc2_)~Deve ser informada uma data v lida.")
									 DEFAULT "DATE()"
									 AJUDA "Listar os contratos lan‡ados| at‚ quel data."

	@ l_s+04 ,c_s+34 GET  rreimp;
									 PICT "!";
			 VALI CRIT("rreimp$[SN ]~Necess rio informar REIMPRIMIR?|Digite S ou N")
									 DEFAULT "[N]"
									 AJUDA "Digite S para imprimir| inclusive os j  impressos."
*/
	@ l_s+05 ,c_s+34 GET  confirme;
									 PICT "!";
									 VALI CRIT("confirme='S'~CONFIRME n„o aceit vel|Digite S ou tecle ESC para cancelar")
									 AJUDA "Digite S para imprimir o contrato|ou |Tecle ESC para cancelar"

	READ
	SET KEY K_ALT_F8 TO
	IF rola_t
	 ROLATELA(.f.)
   LOOP
  ENDI
  IF LASTKEY()=K_ESC                               // se quer cancelar
   RETU                                            // retorna
  ENDI
 ENDI

 #ifdef COM_REDE
  CLOSE GRUPOS
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
 arq_=drvporta                                     // porta de saida configurada
 IF !so_um_reg
  IF !opcoes_rel(lin_menu,col_menu,17,11)          // nao quis configurar...
   CLOS ALL                                        // fecha arquivos e
   LOOP                                            // volta ao menu
  ENDI

 #ifdef COM_REDE

  ELSE

   tps=lin_menu

 #endi

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

cpord="codigo+grau+STR(seq,02,00)"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
confirme=[S]
SELE GRUPOS
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
	msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
	DBOX(msg,,,,,"ERRO!")                            // avisa
	CLOSE ALL                                        // fecha todos arquivos abertos
	RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_018=LEFT(drvtapg,op_-1)+"051"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_018:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
SET MARG TO 3                                      // ajusta a margem esquerda
IMPCTL(lpp_018)                                    // seta pagina com 18 linhas
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
	pg_=1; cl=999
	IF so_um_reg
	 GO imp_reg
	ELSE
	 INI_ARQ()                                       // acha 1o. reg valido do arquivo
	ENDI
	IF !EMPT(VAL(M->rcodin))
	 PTAB(M->rcodin,[GRUPOS],1)
	ENDI
	ccop++                                           // incrementa contador de copias
	DO WHIL !EOF().AND.(!so_um_reg.OR.imp_reg=RECN())
	 #ifdef COM_TUTOR
		IF IN_KEY()=K_ESC                              // se quer cancelar
	 #else
		IF INKEY()=K_ESC                               // se quer cancelar
	 #endi
		IF canc()                                      // pede confirmacao
		 BREAK                                         // confirmou...
		ENDI
	 ENDI
	 IF (R04101F9()) .OR. so_um_reg                  // se atender a condicao...
		confirme=[S]
    REL_CAB(8)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
		@ cl,065 SAY codigo                            // Codigo
		IMPCTL(drvtenf)
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,064 SAY TRAN(vendedor,"!!!")              // Vendedor
		@ cl,072 SAY TRAN(grupo,"!!")                  // Grupo
		REL_CAB(8)                                     // soma cl/imprime cabecalho
		IMPCTL(drvpenf)
		@ cl,007 SAY nome                              // Nome
		IMPCTL(drvtenf)
		@ cl,047 SAY TRAN(cpf,"@R 999.999.999-99")     // CPF
		@ cl,064 SAY TRAN(&drvpcom+rg+&drvtcom,"@!")   // R.G.
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,007 SAY endereco                          // Endere‡o
		@ cl,059 SAY bairro                            // Bairro
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,004 SAY TRAN(cep,"@R 99999-999")          // CEP
		@ cl,020 SAY cidade                            // Cidade
		@ cl,046 SAY TRAN(uf,"!!")                     // UF
		@ cl,059 SAY TRAN(telefone,"@!")               // Telefone
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,007 SAY IIF(PTAB(codigo+[R],'ECOB',1),ECOB->endereco,[ ])// outro endereco
		@ cl,043 SAY IIF(PTAB(codigo+[R],'ECOB',1),ECOB->bairro,[ ])// outro bairro
		REL_CAB(3)                                     // soma cl/imprime cabecalho
		@ cl,004 SAY TRAN(IIF(PTAB(codigo+[R],'ECOB',1),ECOB->cep,[ ]),"@R 99999-999")// Outro CEP
		@ cl,020 SAY IIF(PTAB(codigo+[R],'ECOB',1),ECOB->cidade,[ ])// outra cidade
		@ cl,048 SAY TRAN(IIF(PTAB(codigo+[R],'ECOB',1),ECOB->uf,[ ]),"!!")// Outro UF
		@ cl,059 SAY IIF(PTAB(codigo+[R],'ECOB',1),ECOB->telefone,[ ])// Outro Telefone
		REL_CAB(06)                                    // soma cl/imprime cabecalho
		@ cl,000 SAY "."
		@ cl,013 SAY CHR(27)+'3'+chr(15)              // Habilita 216/20
		REL_CAB(1)
		chv020=codigo
		SELE INSCRITS
		SEEK chv020
		IF FOUND()
		 IF cl+2>maxli                                 // se cabecalho do arq filho
			REL_CAB(0)                                   // nao cabe nesta pagina
		 ENDI                                          // salta para a proxima pagina
		 cl+=1                                         // soma contador de linha
		 CT_IN:=0
		 DO WHIL ! EOF() .AND. chv020=codigo //LEFT(&(INDEXKEY(0)),LEN(chv020))
			#ifdef COM_TUTOR
			 IF IN_KEY()=K_ESC                           // se quer cancelar
			#else
			 IF INKEY()=K_ESC                            // se quer cancelar
			#endi
			 IF canc()                                   // pede confirmacao
				BREAK                                      // confirmou...
			 ENDI
			ENDI
			IF grau>'0'                                  // se atender a condicao...
			 CT_IN++
			 IF CT_IN>5
				CT_IN=0
				CL--
			 ENDI

			 REL_CAB(3)                                  // soma cl/imprime cabecalho
			 @ cl,004 SAY nome                           // Nome
			 @ cl,059 SAY R04201F9()                     // qualif
			 @ cl,069 SAY TRAN(nascto_,"@D")             // tab2
			 SKIP                                        // pega proximo registro
			ELSE                                         // se nao atende condicao
			 SKIP                                        // pega proximo registro
			ENDI
		 ENDD
		 cl+=1                                         // soma contador de linha
		ENDI
		@ CL,000 SAY CHR(27)+[6]

		SELE GRUPOS                                    // volta ao arquivo pai
		SKIP                                           // pega proximo registro
		cl=999                                         // forca salto de pagina
	 ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
   IF !EMPT(VAL(M->rcodfi)).AND.codigo>M->rcodfi
    EXIT
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET MARG TO                                        // ajusta a margem esquerda
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(17)                                          // grava variacao do relatorio
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
IF so_um_reg
 POINTER_DBF(sit_dbf)
ENDI
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 cl=qt ; pg_++
ENDI
RETU

* \\ Final de ADM_R041.PRG
func r04101f9
DO CASE
CASE (codigo<M->rcodin.AND.!(M->rcodin='000000')) // Contrato menor que
 RETU .f.                                        // o pedido.
CASE (codigo>M->rcodfi.AND.!(M->rcodfi='000000')) // contrato maior.
 RETU .f.
CASE (GRUPOS->ender_<M->rlanc1_.AND.!EMPT(M->rlanc1_)) //Lan‡ado antes
 RETU .f.
CASE (GRUPOS->ender_>M->rlanc2_.AND.!EMPT(M->rlanc2_)) //Lan‡ado depois
 RETU .f.
CASE M->rreimp=[S] // Se j  foi impresso, imprimir novamente.
 RETU .t.
ENDCASE
RETU EMPT(GRUPOS->ultimp_)    //S¢ quero os n„o impressos

* \\ Final de R04101F9.PRG
