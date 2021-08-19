procedure seg_p010
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: SEG_P010.PRG
 \ Data....: 26-04-98
 \ Sistema.: Seguros
 \ Funcao..: Eliminar C. Adicionais
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
PARA  lin_menu, col_menu
nucop=1
cod_sos=1
msgt="ELIMINAR C. ADICIONAIS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  IF !USEARQ("CSTSEG",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CSTSEG")                                 // abre o dbf e seus indices
 #endi

 PTAB(contrato+tipo+circ,"TAXAS",1,.t.)            // abre arquivo p/ o relacionamento
 SET RELA TO contrato+tipo+circ INTO TAXAS         // relacionamento dos arquivos
 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE CSTSEG                                       // salta pagina
 SET RELA TO                                       // retira os relacionamentos
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de SEG_P010.PRG
