procedure admnr041
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind�stria de Urnas Bignotto Ltda
 \ Programa: ADM_R041.PRG
 \ Data....: 19-07-96
 \ Sistema.: Administradora de Funer�rias
 \ Funcao..: Impress�o Contrato
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0d
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adPBig.ch"    // inicializa constantes manifestas

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
rcodigo=SPAC(5)                                    // Codigo
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+10 GET  rcodigo;
                  PICT "99999";
                  VALI CRIT("PTAB(rcodigo,'GRUPOS',3)~CODIGO n�o aceit�vel")
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
 SET RELA TO codigo INTO EMCARNE                   // relacionamento dos arquivos
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,13,11)           // nao quis configurar...
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

cpord="grupo+codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura��o do tamanho da p�gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_050=LEFT(drvtapg,op_-1)+"050"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_050:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
seek M->rcodigo
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
IMPCTL(lpp_050)                                    // seta pagina com 50 linhas
IMPCTL(drvpde8)                                    // ativa 8 lpp
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF()
   IF INKEY()=K_ESC                                // se quer cancelar
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF codigo==M->rcodigo                           // se atender a condicao...
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    IMPEXP(cl,038,TRAN(EMCARNE->vendedor,"!!"),4)  // Vendedor
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    IMPEXP(cl,059,TRAN(grupo,"!9"),4)              // Grupo
    IMPCTL(drvtenf)
    IMPCTL(drvpenf)
    IMPEXP(cl,065,TRAN(codigo,"99999"),10)         // Codigo
    IMPCTL(drvtenf)
    REL_CAB(6)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,008 SAY nome                              // Nome
    IMPCTL(drvtenf)
    @ cl,055 SAY TRAN(cpf,"@R 999.999.999-99")     // CPF
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY endereco                          // Endere�o
    @ cl,059 SAY bairro                            // Bairro
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY TRAN(cep,"@R 99999-999")          // CEP
    @ cl,022 SAY cidade                            // Cidade
    @ cl,059 SAY TRAN(fone,"@!")                   // Fone
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY TRAN(natural,"@!")                // Naturalidade
    @ cl,040 SAY TRAN(ufnat,"!!")                  // UF
    @ cl,062 SAY LEFT(DTOC(nacto_),2)+"   "+;
		 SUBSTR(DTOC(nacto_),4,2)+"   "+;
		 RIGHT(DTOC(nacto_),2)    // Nacimento
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,062 SAY LEFT(DTOC(casmto_),2)+"   "+;
		 SUBSTR(DTOC(casmto_),4,2)+"   "+;
		 RIGHT(DTOC(casmto_),2)            // Dt.Casam.
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,008 SAY TRAN(cidcasamto,"@!")             // Casado em
    @ cl,056 SAY TRAN(rg,"@!")                     // R.G.
    REL_CAB(12)                                    // soma cl/imprime cabecalho
    @ cl,000 SAY "."
    chv031=grupo+codigo
    SELE INSCRITS
    SEEK chv031
    IF FOUND()
     IF cl+2>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     ultgrau:=0
     DO WHIL ! EOF() .AND. chv031=grupo+codigo //LEFT(&(INDEXKEY(0)),LEN(chv031))
      IF INKEY()=K_ESC                             // se quer cancelar
       IF canc()                                   // pede confirmacao
	BREAK                                      // confirmou...
       ENDI
      ENDI
      IF grau>'1'                                  // se atender a condicao...
       IF grau="8"
	cl:=52
	ultgrau:=seq
       ELSE
	ultgrau:=VAL(grau)+seq-1
       ENDI
//       REL_CAB(1)                                  // soma cl/imprime cabecalho
       @ cl+ultgrau,016 SAY ALLTRIM(nome)+' ('+;
       SUBSTR([TitPaiMaeSgoSgaConFilDep],(VAL(grau)-1)*3+1,3)+')'+;
       CHR(27)+'A'+CHR(14)                         // Nome
       IF grau<'6'.and.vivofalec='V'               // pode imprimir?
	@ cl+ultgrau,059 SAY 'X'                           // tab1
       ENDI
       @ cl+ultgrau,072 SAY IIF(grau<'6'.AND.vivofalec='F',' X',IIF(!EMPT(nascto_),DTOC(nascto_),[ ]))// tab2
       SKIP                                        // pega proximo registro
      ELSE                                         // se nao atende condicao
       SKIP                                        // pega proximo registro
      ENDI
     ENDD
     cl+=ultgrau
     cl+=3                                         // soma contador de linha
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtde8)                                    // ativa 6 lpp
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)                // mostra o arquivo gravado
ENDI
GRELA(13)                                          // grava variacao do relatorio
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R041.PRG
