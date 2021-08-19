/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: ADM_R041.PRG
 \ Data....: 03-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contrato Baldochi - Rib.Preto
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
rlanc2_=CTOD('01/05/2002')                                   // Lan‡.Final
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
maxli=51                                           // maximo de linhas no relatorio
poerdp=.t.
SET MARG TO 1                                      // ajusta a margem esquerda
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
    rel_cab(1)
		chv031=codigo
		SELE INSCRITS
		SEEK chv031
		IF FOUND()
		 IF cl+2>maxli                                 // se cabecalho do arq filho
			REL_CAB(0)                                   // nao cabe nesta pagina
		 ENDI                                          // salta para a proxima pagina
		 DO WHIL ! EOF() .AND. chv031=codigo //LEFT(&(INDEXKEY(0)),LEN(chv031))
			#ifdef COM_TUTOR
			 IF IN_KEY()=K_ESC                           // se quer cancelar
			#else
			 IF INKEY()=K_ESC                            // se quer cancelar
			#endi
			 IF canc()                                   // pede confirmacao
				BREAK                                      // confirmou...
			 ENDI
			ENDI
			IF grau>[1]
			 IF confirme=[S]
				DO CASE
				 CASE grau=[2]
					cl:=23
				 CASE grau=[3]
					cl:=25
				 CASE grau=[4]
					cl:=26
				 CASE grau=[5]
					cl:=27
				 CASE grau=[6]
					cl:=30
				 CASE grau=[7].AND.!(confirme=[S7])
					confirme:=[S7]
					cl:=32
				 CASE grau=[8]
					confirme:=[N]
					cl:=48
				ENDCASE
			 ENDI
       IF STR(cl,2)$[35,38,41,44,47,49,53,56,59]
 			  REL_CAB(1)                                  // soma cl/imprime cabecalho
       ENDI
			 REL_CAB(1)                                  // soma cl/imprime cabecalho
//     @ cl,001 SAY str(cl,4)
			 @ cl,013 SAY nome                           // Nome

			 IF grau<[6]                                 // pode imprimir?
        @ cl,054 SAY DTOC(nascto_)
        @ cl,067 SAY estcivil
        @ cl,073 SAY vivofalec
       ELSE
        @ cl,059 SAY DTOC(nascto_)
        @ cl,071 SAY estcivil
			 ENDI
       poerdp=.t.
       SKIP                                        // pega proximo registro
			ELSE                                         // se nao atende condicao
			 SKIP                                        // pega proximo registro
			ENDI
		 ENDD
		 cl+=3                                         // soma contador de linha
		ENDI
		SELE GRUPOS                                    // volta ao arquivo pai
//    IF so_um_reg
     rel_rdp()
//    ENDI
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

STATIC PROC REL_RDP                                // rodape'
if poerdp
 if cl<51
  @ 51,006 SAY MEMOLINE(GRUPOS->obs,60,3)
  @ 52,006 SAY MEMOLINE(GRUPOS->obs,60,4)
 endi
 @ 57,005 SAY GRUPOS->cidade + [             ]+;
          LEFT(DTOC(GRUPOS->admissao),2)+[    ]+;
          NMES(GRUPOS->admissao)+[         ]+;
          RIGHT(DTOC(GRUPOS->admissao),4)
 @ 60,013 SAY GRUPOS->nome
 @ 60,053 SAY GRUPOS->cpf
 poerdp=.f.
endi
RETU



STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina

 IF pg_>1
  REL_RDP()                                        // imprime rodape' do relatorio
 ENDI
 poerdp=.t.
		cl:=1 //REL_CAB(1)                                     // soma cl/imprime cabecalho


    IMPCTL(drvpenf)
    IMPEXP(2,016,codigo+[ ]+GRUPOS->grupo,12)                       // Codigo
    IMPEXP(2,065,GRUPOS->grupo,2)                       // Codigo
    IMPCTL(drvtenf)
    ult_imp=RECNO()                                // ultimo reg impresso
    @ 4,010 SAY GRUPOS->nome                              // Nome
    @ 4,065 SAY TRAN(GRUPOS->nascto_,"@D")

    @ 6,010 SAY LEFT(TRAN(IIF(!EMPT(GRUPOS->estcivil),SUBS(tbestciv,AT(GRUPOS->estcivil,tbestciv),11),[]),[@!]),11)
    @ 6,029 SAY TRAN(GRUPOS->cpf,"@R 999.999.999-99")     // CPF
    @ 6,053 SAY TRAN(GRUPOS->rg,"@!")     // RG

		@ 7,010 SAY GRUPOS->endereco                          // Endere‡o
		@ 7,056 SAY LEFT(TRAN(GRUPOS->bairro,"@!"),20)               // Telefone

    @ 9,010 SAY GRUPOS->cidade
    @ 9,047 SAY GRUPOS->uf
    @ 9,066 SAY TRAN(GRUPOS->cep,[@R 99999-999])

		@ 11,014 SAY GRUPOS->natural                           // Naturalidade
    @ 11,057 SAY GRUPOS->relig

		@ 12,010 SAY GRUPOS->contato                           // Naturalidade
	  @ 12,051 SAY TRAN(GRUPOS->telefone,"@!")               // Telefone

    @ 14,013 SAY GRUPOS->tipcont
    @ 14,022 SAY GRUPOS->vlcarne
    @ 14,033 SAY GRUPOS->diapgto
    IF PTAB(GRUPOS->vendedor,[COBRADOR],1)
     @ 14,045 SAY COBRADOR->nome
    ENDI

    IMPMEMO(GRUPOS->obs,60,1,15,010,.f.)         // Obs Prod (memo)

		IF PTAB(GRUPOS->codigo,[ECOB],1)
     IF ECOB->tipo = [R]
      @ 17,027 SAY [R]
      @ 17,045 SAY [Residencia]
     ELSEIF ECOB->tipo=[T]
      @ 17,032 SAY [T]
      @ 17,045 SAY [Trabalho]
     ELSE
      @ 17,037 SAY [O]
      @ 17,045 SAY [Outro]
     ENDI

		 @ 18,010 SAY TRAN(ECOB->endereco,"@!")           // Bairro Res
		 @ 18,050 SAY TRAN(ECOB->bairro,"@!")           // Bairro Res
		 @ 20,010 SAY TRAN(ECOB->cidade,"@!")           // Cidade Res
		 @ 20,050 SAY TRAN(ECOB->uf,"!!")               // UF Res
     @ 20,058 SAY ECOB->telefone
		ENDI
    cl=qt+19 ; pg_++
		IF confirme=[N]
     @ 022,006 SAY [Continuacao...]
		 cl:=34
    ENDI
ENDI

RETU

* \\ Final de ADM_R041.PRG
static proc r04101f9
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
