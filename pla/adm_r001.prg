procedure adm_r001
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_R001.PRG
 \ Data....: 12-08-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Inscritos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1

#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

PTAB(codigo,"GRUPOS",1,.t.)                        // abre arquivo p/ o relacionamento
SET RELA TO codigo INTO GRUPOS                     // relacionamento dos arquivos
titrel:=criterio := ""                             // inicializa variaveis
cpord="nome"
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1
IF !opcoes_rel(lin_menu,col_menu,56,11)            // nao quis configurar...
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
   IF vivofalec=[V]                                // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY nome                              // Nome
    @ cl,036 SAY TRAN(GRUPOS->grupo,"!!")          // Grupo
    IF TYPE("omt091003")!="C" .OR. omt091003!=codigo// imp se dif do anterior
     @ cl,039 SAY codigo                           // Contrato
     omt091003=codigo                              // imp se dif do anterior
    ENDI
    @ cl,045 SAY "-"
    @ cl,046 SAY SUBSTR([TitPaiMaeSgoSgaEspFilDep],(VAL(grau)-1)*3+1,3)// Inscr.
    @ cl,050 SAY nascto_                           // Nascto
    IF ehtitular=[S]                               // pode imprimir?
     @ cl,061 SAY [S]                              // Titular
    ENDI
    @ cl,066 SAY TRAN(procnr,"@R 99999/99")        // N§Processo
    @ cl,075 SAY TRAN(tipo,"!!!")                  // Tipo
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcom)                                    // retira comprimido
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(56)                                          // grava variacao do relatorio
SELE INSCRITS                                      // salta pagina
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
 @ 1,070 SAY "ADM_R001"                            // c¢digo relat¢rio
 @ 2,000 SAY "INSCRITOS"
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY titrel                                // t¡tulo a definir
 @ 4,000 SAY "Nome                                Contrato      Nascto   Titular"
 @ 5,000 SAY REPL("-",78)
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R001.PRG
