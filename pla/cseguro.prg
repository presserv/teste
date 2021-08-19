procedure cseguro
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: CSEGURO.PRG
 \ Data....: 08-08-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Seguros Ativos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti
PRIV  prefixo_dbf:="CSE", op_sis:=EVAL(qualsis,"GRSEGUR")
                                                   // arquivo a consultar
op_menu=PROJECOES                                  // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
 IF !USEARQ("GRSEGUR",.f.,10,1)                    // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRSEGUR")                                 // abre o dbf e seus indices
#endi

PTAB(codigoseg+nrseguro,"SINSCRIT",2,.t.)          // abre arquivo p/ o relacionamento
PTAB(tipo,"TSEGURO",1,.t.)
SET RELA TO codigoseg+nrseguro INTO SINSCRIT,;     // relacionamento dos arquivos
         TO tipo INTO TSEGURO
col_cp={;                                          // conteudo das colunas
          "nrseguro",;
          "apolice",;
          "tipo",;
          "contrato",;
          "aberseg_",;
          "TRAN((YEAR(DATE())-YEAR(aberseg_))*12+MONTH(DATE())-MONTH(aberseg_)+1,[99])",;
          "vencseg_",;
          "tcarencia",;
          "renovar",;
          "ulttipo",;
          "circ",;
          "emissao_",;
          "parcemit",;
          "codigoseg",;
          "TRAN(SINSCRIT->inscseg,[])",;
          "TRAN(SINSCRIT->documento,[@!])",;
          "TRAN(TSEGURO->cobertura,[99999999.99])",;
          "TRAN(TSEGURO->custmesemp,[999999.99])",;
          "TRAN(TSEGURO->custmescon,[999999.99])";
       }
col_ti={;                                          // titulo das colunas
          "N§Seguro",;
          "Ap¢lice",;
          "Tipo",;
          "Contrato",;
          "Abertura",;
          "Parc.",;
          "Vencimento",;
          "T.Carˆncia",;
          "Renovar",;
          "Tipo",;
          "Circular",;
          "£lt.Emiss„o",;
          "ParcEmit",;
          "Segurado",;
          "Nome do inscrito",;
          "Documento",;
          "Cobertura",;
          "Custo Empr.",;
          "Custo Contr.";
       }
GO TOP                                             // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti)
SELE GRSEGUR                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CSEGURO.PRG
