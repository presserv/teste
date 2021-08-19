procedure grcompl
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: GRCOMPL.PRG
 \ Data....: 13-09-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Tela complementar do subsistema de consulta contrato
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0d
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "admbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"GRUPOS")
IF nivelop<1                                       // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI
cn:=fgrep :=.f.
criterio=""
SELE A                                             // e abre o arquivo e seus indices

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)      // se falhou a abertura do
  RETU                                             // arquivo volta ao menu anterior
 ENDI
#else
 USEARQ(sistema[op_sis,O_ARQUI])
#endi

SET KEY K_F9 TO veoutros                           // habilita consulta em outros arquivos
IF AT("D",exrot[op_sis])=0                         // se usuario pode fazer inclusao
 GRC_INCL()                                        // neste arquivo chama prg de inclusao
ELSE                                               // caso contrario vamos avisar que
 ALERTA()                                          // ele nao tem permissao para isto
 DBOX(msg_auto,,,3)
ENDI
SET KEY K_F9 TO                                    // F9 nao mais consultara outros arquivos
CLOS ALL                                           // fecha todos arquivos abertos
RETU

PROC GRC_incl     // inclusao no arquivo GRUPOS
LOCAL getlist:={}, cabem:=1, ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=TEL_EXTRA, blk_grupos:=.t., tem_borda, criterio:="", cpord:=""
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
l_a=0
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE GRUPOS
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo
 
 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=&msg.
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 GRC_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA
 
 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+01 ,c_s+25 GET  codigo;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1
                  MOSTRA sistema[op_sis,O_FORMULA,13]

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 SELE GRUPOS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo
 IF !FOUND() .OR. DELE()                           // se nao encontrou ou esta
  ALERTA()                                         // excluido, avisa e volta
  DBOX("REGISTRO NAO ENCONTRADO OU EXCLUIDO",12,,1)// para receber nova chave
  LOOP
 ENDI

 #ifdef COM_REDE
  IF !BLOREG(3,.5)                                 // se nao conseguiu bloquear o
   LOOP                                            // registro, volta ao menu
  ENDI
 #endi

 FOR i=1 TO FCOU()                                 // inicializa variaveis
  msg=FIEL(i)                                      // de memoria com o mesmo
  M->&msg.=&msg.                                   // valor valor dos campos
 NEXT                                              // do arquivo
 SELE 0
 GRC_GET1()                                        // modificando o registro
 SELE GRUPOS
 IF LASTKEY()!=K_ESC                               // se nao cancelou modificacoes
  FOR i=1 TO FCOU()                                // para cada campo,
   msg=FIEL(i)                                     // salva o conteudo
   REPL &msg. WITH M->&msg.                        // da memoria no arquivo
  NEXT
 ENDI

 #ifdef COM_REDE
  UNLOCK                                           // libera registro
 #endi

ENDD
GO ult_reg                                         // para o ultimo reg digitado
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC GRC_tela     // tela do arquivo GRUPOS
tem_borda=.t.
l_s=4                                     // coordenadas da tela
c_s=17
l_i=22
c_i=68
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+17 SAY MAIUSC(" Consulta Contrato ")
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Grupo:      Contrato:"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY "                                     ³ Circulares"
@ l_s+04,c_s+1 SAY "                                     ³  Ini"
@ l_s+05,c_s+1 SAY "                           Reg.:     ³  £lt"
@ l_s+06,c_s+1 SAY "                                     ³  Qtd"
@ l_s+07,c_s+1 SAY " Admiss„o:           Sai Taxa:       ³"
@ l_s+08,c_s+1 SAY " Funerais:           Cobrador:       ³  Pend"
@ l_s+09,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+10,c_s+1 SAY "  Cir Emiss„o     Valor   Pago em     Valor"
RETU

PROC GRC_gets     // mostra variaveis do arquivo GRUPOS
LOCAL getlist := {}, t_f7_
GRC_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CRIT("",,"14|15|16|17|18|19|20|21|22|23|24|25")
@ l_s+01 ,c_s+25 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,01,O_CRIT],,"13")

@ l_s+01 ,c_s+09 GET  grupo;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

CLEAR GETS
RETU

PROC GRC_get1     // capta variaveis do arquivo GRUPOS
LOCAL getlist := {}, t_f7_
DO WHILE .t.
 rola_t=.f.
 memo24:="{F7}"
 t_f7_=SETKEY(K_F7,{||GRC_memo()})
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 CRIT("",,"14|15|16|17|18|19|20|21|22|23|24|25")
 @ l_s+01 ,c_s+09 GET  grupo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2

 READ
 SETKEY(K_F7,t_f7_)
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()!=K_ESC .AND. drvincl
  IF !CONFINCL()
   LOOP
  ENDI
 ENDI
 EXIT
ENDD
RETU

PROC GRC_MEMO
IF READVAR()="MEMO24"
 EDIMEMO("obs",sistema[op_sis,O_CAMPO,24,O_TITU],14,2,23,37)
ENDI
RETU

* \\ Final de GRCOMPL.PRG
