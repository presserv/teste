procedure ctxas
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: CTXAS.PRG
 \ Data....: 18-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Consulta Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cps_rela
PRIV  prefixo_dbf:="CTX", op_sis:=EVAL(qualsis,"TAXAS")
                                                   // arquivo a consultar
op_menu=PROJECOES                                  // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

PTAB(codigo,"GRUPOS",1,.t.)                        // abre arquivo p/ o relacionamento
SET RELA TO codigo INTO GRUPOS                     // relacionamento dos arquivos
col_cp={;                                          // conteudo das colunas
          "codigo",;
          "tipo",;
          "circ",;
          "emissao_",;
          "valor",;
          "pgto_",;
          "valorpg",;
          "cobrador",;
          "forma";
       }
col_ti={;                                          // titulo das colunas
          "Codigo",;
          "Tipo",;
          "Circular",;
          "Emissao",;
          "Valor",;
          "Pagamento",;
          "Valor pago",;
          "Cobrador",;
          "Forma";
       }
GO TOP                                             // vai p/ inicio do arquivo
FOR i_=1 TO LEN(sistema[op_sis,O_CPRELA])          // libera os campos invisiveis
 sistema[op_sis,O_CAMPO,i_,O_CRIT]="V"             // que fazem a ligacao dos DBFs
NEXT                                               // para serem vistos na consulta
cod_sos=8
EDITA(3,3,MAXROW()-2,77,"V",col_cp,col_ti)
FOR i_=1 TO LEN(sistema[op_sis,O_CPRELA])          // e retorna com o atributo
 sistema[op_sis,O_CAMPO,i_,O_CRIT]="I"             // de invisivel nos campos da
NEXT                                               // ligacao pai-filho
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CTXAS.PRG
