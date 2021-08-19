procedure ccobran
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: CCOBRAN.PRG
 \ Data....: 22-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Consulta Emiss„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL t_, i_, col_cp, col_ti, cps_rela, cr_
PARA  lin_menu,col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=6, c_s:=16, l_i:=20, c_i:=67, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79),;
      prefixo_dbf:="CCO", op_sis:=EVAL(qualsis,"TAXAS")
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+15 SAY " IMPRESSŽO DE COBRAN€A "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Tipo da Cobran‡a:"
@ l_s+02,c_s+1 SAY " Grupo:     (      -       £ltima:             )"
@ l_s+04,c_s+1 SAY " Circulares a emitir: N§      at‚"
@ l_s+05,c_s+1 SAY " Cobran‡as com data entre:          e"
@ l_s+06,c_s+1 SAY " e n§ de contrato entre:        e"
@ l_s+08,c_s+1 SAY "         Reimprimir taxas j  impressas?"
@ l_s+09,c_s+1 SAY "     Acumular valor das cobran‡as vencidas?"
@ l_s+10,c_s+1 SAY "         Tipo das taxas a acumular :"
@ l_s+12,c_s+1 SAY "                   Confirme:"
rtp=SPAC(1)                                        // Tipo
rgrupo=SPAC(2)                                     // Grupo
rproxcirc=SPAC(3)                                  // N§Proxima Circ.
rultcirc=SPAC(3)                                   // N§Ultima Circ.
rem1_=CTOD('')                                     // Emiss„o
rem2_=CTOD('')                                     // Emiss„o
rcod1=SPAC(6)                                      // Contrato
rcod2=SPAC(6)                                      // Contrato
rreimp=SPAC(1)                                     // Reimprimir?
racum=SPAC(1)                                      // Acumular?
rtipo=SPAC(3)                                      // Tipos a imprimir
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+20 GET  rtp;
                  PICT "!";
                  VALI CRIT("rtp $ [123]~TIPO n„o aceit vel");
                  WHEN "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"
                  AJUDA "Qual o tipo de cobran‡a a imprimir neste impresso."
                  CMDF8 "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])"

 @ l_s+02 ,c_s+09 GET  rgrupo;
                  PICT "!!";
                  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(rgrupo)~GRUPO n„o existe na tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,33,20,77,'ARQGRUP',{'grup','inicio','final','ultcirc','emissao_','procpend'},1,'grup',[])"
                  MOSTRA {"LEFT(TRAN(ARQGRUP->inicio,[999999]),06)", 2 , 14 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->final,[999999]),06)", 2 , 21 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->ultcirc,[999]),03)", 2 , 36 }
                  MOSTRA {"LEFT(TRAN(ARQGRUP->emissao_,[@D]),08)", 2 , 40 }

 @ l_s+04 ,c_s+26 GET  rproxcirc;
                  PICT "999";
                  VALI CRIT("PTAB(rgrupo+rproxcirc,'CIRCULAR',1).OR.(1=1)~A Pr¢xima circular deve estar|lan‡ada em Tabela/Circulares")
                  DEFAULT "ARQGRUP->proxcirc"
                  AJUDA "Entre com o n£mero da pr¢xima circular"
                  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+04 ,c_s+35 GET  rultcirc;
                  PICT "999"
                  AJUDA "Entre com o n£mero da ultima circular"
                  CMDF8 "STRZERO(VAL(ARQGRUP->ultcirc)+1,3)"

 @ l_s+05 ,c_s+28 GET  rem1_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem1_)~Deve ser informada uma data v lida.")
                  DEFAULT "IIF(!(rproxcirc<[001]),CIRCULAR->emissao_,DATE())"
                  AJUDA "Data da Emiss„o da Circular.| Informe a data a considerar como inicial na emiss„o."

 @ l_s+05 ,c_s+39 GET  rem2_;
                  PICT "@D";
                  VALI CRIT("!EMPT(Rem2_)~Informe uma data v lida, deve ser posterior|a inicial")
                  DEFAULT "(DATE()+31)-DAY(DATE()+31)"
                  AJUDA "Imprimir a cobran‡a lan‡ada at‚ que data."

 @ l_s+06 ,c_s+26 GET  rcod1;
                  PICT "999999";
                  VALI CRIT("PTAB(rcod1,'GRUPOS',1).OR.rcod1='000000'~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                  DEFAULT "[000000]"
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+06 ,c_s+35 GET  rcod2;
                  PICT "999999";
                  VALI CRIT("PTAB(rcod2,'GRUPOS',1).OR.rcod2 >= rcod1~CODIGO n„o aceit vel|Digite zeros para listar todos os|contratos no intervalo")
                  DEFAULT "[000000]"
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+08 ,c_s+41 GET  rreimp;
                  PICT "!";
                  VALI CRIT("rreimp$[SN ]~Necess rio informar REIMPRIMIR?|Digite S ou N")
                  DEFAULT "[N]"
                  AJUDA "Digite S para imprimir todos os documentos|mesmo os que j  foram impressos anteriormente."

 @ l_s+09 ,c_s+45 GET  racum;
                  PICT "!";
                  VALI CRIT("racum$[SN ]~ACUMULAR? n„o aceit vel|Digite S ou N")
                  DEFAULT "[ ]"
                  AJUDA "Digite S para acumular o valor|das cobran‡as n„o pagas neste documento."

 @ l_s+10 ,c_s+38 GET  rtipo;
                  PICT "!!!";
                  VALI CRIT("!EMPT(rtipo)~Necess rio informar TIPOS A IMPRIMIR");
                  WHEN "racum='S'"
                  DEFAULT "[123]"
                  AJUDA "Digite 1 para J¢ia, 2 para cobran‡as e 3 p/Periodo"
                  CMDF8 "MTAB([111-J¢ia|222-p/Processos|333-Peri¢dico|122-J¢ia+Processos|133-J¢ia+Per¡odico|233-Processos+Peri¢dicos|123-Todos],[TIPOS A IMPRIMIR])"

 @ l_s+12 ,c_s+30 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'.AND.V87001F9()~CONFIRME n„o aceit vel")
                  AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"

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
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

PTAB(codigo,"GRUPOS",1,.t.)                        // abre arquivo p/ o relacionamento
PTAB(codigo+tipo+circ,"CSTSEG",3,.t.)
PTAB(GRUPOS->tipcont,"CLASSES",1,.t.)
PTAB(cobrador,"COBRADOR",1,.t.)
PTAB(GRUPOS->grupo,"ARQGRUP",1,.t.)
PTAB(GRUPOS->grupo+circ,"CIRCULAR",1,.t.)
SET RELA TO codigo INTO GRUPOS,;                   // relacionamento dos arquivos
         TO codigo+tipo+circ INTO CSTSEG,;
         TO GRUPOS->tipcont INTO CLASSES,;
         TO cobrador INTO COBRADOR,;
         TO GRUPOS->grupo INTO ARQGRUP,;
         TO GRUPOS->grupo+circ INTO CIRCULAR
col_cp={;                                          // conteudo das colunas
          "TRAN(IIF(R08701F9(),GRUPOS->grupo,[]),[!!])",;
          "codigo",;
          "TRAN(tipo+[-]+circ,[])",;
          "TRAN(GRUPOS->nome,[])",;
          "TRAN(GRUPOS->endereco,[])",;
          "TRAN(GRUPOS->bairro,[])",;
          "TRAN(GRUPOS->cidade,[])",;
          "TRAN(GRUPOS->cep,[@R 99999-999])",;
          "TRAN(GRUPOS->admissao,[@D])",;
          "TRAN(GRUPOS->funerais,[99])",;
          "TRAN(GRUPOS->circinic,[999])",;
          "TRAN(GRUPOS->ultcirc,[999])",;
          "emissao_",;
          "valor",;
          "TRAN(R08702F9()+vlseg,[@E 999,999.99])";
       }
col_ti={;                                          // titulo das colunas
          "Grupo",;
          "Codigo",;
          "Circular",;
          "Nome",;
          "Endere‡o",;
          "Bairro",;
          "Cidade",;
          "CEP",;
          "Admiss„o",;
          "Funerais",;
          "Circ.Inicial",;
          "Ult.Circular",;
          "Emissao",;
          "Valor",;
          "Val.Taxas";
       }
cr_="R08701F9()"                                   // filtro inicial
GO TOP                                             // vai p/ inicio do arquivo
FOR i_=1 TO LEN(sistema[op_sis,O_CPRELA])          // libera os campos invisiveis
 sistema[op_sis,O_CAMPO,i_,O_CRIT]="V"             // que fazem a ligacao dos DBFs
NEXT                                               // para serem vistos na consulta
cod_sos=8
EDITA(3,3,MAXROW()-2,77,"V",col_cp,col_ti,cr_)
FOR i_=1 TO LEN(sistema[op_sis,O_CPRELA])          // e retorna com o atributo
 sistema[op_sis,O_CAMPO,i_,O_CRIT]="I"             // de invisivel nos campos da
NEXT                                               // ligacao pai-filho
SELE TAXAS                                         // salta pagina
SET RELA TO                                        // retira os relacionamentos
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de CCOBRAN.PRG
