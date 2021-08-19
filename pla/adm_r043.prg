procedure adm_r043
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R043.PRG
 \ Data....: 12-02-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contratos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("GRUPOS",.f.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi

titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,50,11)            // nao quis configurar...
 CLOS ALL                                          // fecha arquivos e
 RETU                                              // volta ao menu
ENDI
IF tps=2                                           // se vai para arquivo/video
 arq_=ARQGER()                                     // entao pega nome do arquivo
 IF EMPTY(arq_)                                    // se cancelou ou nao informou
  RETU                                             // retorna
 ENDI
ELSE
 arq_=drvporta                                     // porta de saida configurada
ENDI
IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF

SET PRINTER TO (arq_)                              // redireciona saida
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=63                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
IMPCTL(drvpc20)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
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
   REL_CAB(2)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Contrato:"
   @ cl,010 SAY grupo                              // Grupo
   @ cl,013 SAY codigo                             // Codigo
   IMPAC("Situa‡„o:",cl,022)
   @ cl,032 SAY TRAN(situacao,"9")                 // Situa‡„o
   IMPAC("Admiss„o:",cl,035)
   @ cl,045 SAY TRAN(admissao,"@D")                // Admiss„o
   @ cl,055 SAY "SaiTxa:"
   @ cl,063 SAY TRAN(saitxa,"@R 99/99")            // Saitxa
   @ cl,070 SAY "Cobrador:"
	 @ cl,080 SAY TRAN(cobrador,"!!!")                // Cobrador
   @ cl,085 SAY "Funerais:"
   @ cl,095 SAY TRAN(funerais,"99")                // Funerais
   @ cl,099 SAY "Vl.Carne:"
   @ cl,109 SAY vlcarne                            // Vlcarne
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Circ.Inicial:"
   @ cl,014 SAY TRAN(circinic,"999")               // Circ.Inicial
   @ cl,022 SAY "UltCirc.:"
   @ cl,032 SAY TRAN(ultcirc,"999")                // Ult.Circular
   @ cl,037 SAY "Qt.Circ:"
   @ cl,046 SAY TRAN(qtcircs,"999")                // Qt.Circulares
   @ cl,051 SAY "Circ.Pagas:"
   @ cl,063 SAY TRAN(qtcircpg,"999")               // Circ.Pagas
   IMPAC("Regi„o:",cl,068)
   @ cl,076 SAY TRAN(regiao,"999")                 // Regi„o
   @ cl,081 SAY "Nome:"
   @ cl,087 SAY TRAN(nome,"@!")                    // Nome
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "End.:"
   @ cl,006 SAY endereco                           // Endere‡o
   @ cl,044 SAY "Bairro:"
   @ cl,052 SAY bairro                             // Bairro
   @ cl,079 SAY "Cidade:"
   @ cl,087 SAY cidade                             // Cidade
   @ cl,113 SAY TRAN(cep,"@R 99999-999")           // CEP
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Fone:"
   @ cl,006 SAY TRAN(telefone,"@!")                // Telefone
   @ cl,022 SAY "Nacimento:"
   @ cl,033 SAY TRAN(nascto_,"@D")                 // Nacimento
   SKIP                                            // pega proximo registro
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtc20)                                    // retira comprimido
SET MARG TO                                        // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(50)                                          // grava variacao do relatorio
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
 @ 1,070 SAY "ADM_R043"                            // c¢digo relat¢rio
 @ 2,000 SAY titrel                                // t¡tulo a definir
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "CONTRATOS"
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADM_R043.PRG
