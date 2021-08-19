procedure ctainsc
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: CTAINSC.PRG
 \ Data....: 18-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Consulta Inscritos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cps_rela
PRIV  prefixo_dbf:="CTA", op_sis:=EVAL(qualsis,"INSCRITS")
                                                   // arquivo a consultar
op_menu=PROJECOES                                  // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

PTAB(codigo,"GRUPOS",1,.t.)                        // abre arquivo p/ o relacionamento
SET RELA TO codigo INTO GRUPOS                     // relacionamento dos arquivos
col_cp={;                                          // conteudo das colunas
          "codigo",;
          "grau",;
          "seq",;
          "ehtitular",;
          "nome",;
          "nascto_",;
          "estcivil",;
          "interdito",;
          "sexo",;
          "tcarencia",;
          "vivofalec",;
          "falecto_",;
          "tipo",;
          "procnr";
       }
col_ti={;                                          // titulo das colunas
          "Codigo",;
          "Inscr.",;
          "Seq",;
          "Titular?",;
          "Nome",;
          "Nascto",;
          "Est Civil",;
          "Interdito",;
          "Sexo",;
          "T.Carˆncia",;
          "V/F",;
          "Falecto.",;
          "Tipo",;
          "N§Processo";
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
SELE INSCRITS                                      // salta pagina
SET RELA TO                                        // retira os relacionamentos
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CTAINSC.PRG
