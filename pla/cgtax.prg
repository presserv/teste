procedure cgtax
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: CGTAX.PRG
 \ Data....: 30-12-99
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contratos e Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=16, l_i:=13, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CGT", op_sis:=EVAL(qualsis,"GRUPOS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+16 SAY " CONTRATOS E TAXAS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Relacionamento:"
relacx=SPAC(60)                                    // Relacionamento
flag_excl=SPAC(1)                                  // Flag
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+18 GET  relacx;
                  PICT "@!S30"
                  DEFAULT "[CODIGO]"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI
 EXIT
ENDD
op_menu=PROJECOES                                  // flag consulta e faz projecoes
SELE 0

#ifdef COM_REDE
 IF !USEARQ("GRUPOS",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("GRUPOS")                                  // abre o dbf e seus indices
#endi
IF EMPT(relacx)
 PTAB(codigo,"TAXAS",1,.t.)                         // abre arquivo p/ o relacionamento
 SET RELA TO codigo INTO TAXAS                      // relacionamento dos arquivos
ELSE
 PTAB(codigo,"TAXAS",1,.t.)                         // abre arquivo p/ o relacionamento
 SET RELA TO &relacx INTO TAXAS                      // relacionamento dos arquivos
ENDI
col_cp={;                                          // conteudo das colunas
          "codigo",;
          "situacao",;
          "nome",;
          "endereco",;
          "bairro",;
          "cidade",;
          "uf",;
          "cep",;
          "tipcont",;
          "vlcarne",;
          "formapgto",;
          "admissao",;
          "saitxa",;
          "diapgto",;
          "vendedor",;
          "regiao",;
          "cobrador",;
          "TRAN(TAXAS->tipo,[9])",;
          "TRAN(TAXAS->circ,[999])",;
          "TRAN(TAXAS->emissao_,[@D])",;
          "TRAN(TAXAS->valor,[@E 999,999.99])",;
          "TRAN(TAXAS->pgto_,[@D])",;
          "TRAN(TAXAS->valorpg,[@E 999,999.99])";
       }
col_ti={;                                          // titulo das colunas
          "Codigo",;
          "Situa‡„o",;
          "Nome",;
          "Endere‡o",;
          "Bairro",;
          "Cidade",;
          "UF",;
          "CEP",;
          "TipCont",;
          "Vlcarne",;
          "FormaPgto",;
          "Admiss„o",;
          "Saitxa",;
          "Dia Pgto.",;
          "Vendedor",;
          "Regi„o",;
          "Cobrador",;
          "Tipo",;
          "Circular",;
          "Emissao",;
          "Valor",;
          "Pagamento",;
          "Valor pago";
       }
GO TOP                                             // vai p/ inicio do arquivo
cod_sos=8
EDITA(3,3,MAXROW()-2,77,.t.,col_cp,col_ti)
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CGTAX.PRG
