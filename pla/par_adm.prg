procedure par_adm
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: PAR_ADM.PRG
 \ Data....: 24-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de parƒmetros
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"PAR_ADM")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI

#ifdef COM_LOCK
 IF LEN(pr_ok)>0                                   // se a protecao acusou
  ? pr_ok                                          // erro, avisa e
  QUIT                                             // encerra a aplicacao
 ENDI
#endi

SELE A

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis,O_ARQUI],.t.,20,1,.f.)  // se falhou a abertura do
  RETU                                             // arquivo volta ao menu anterior
 ENDI
#else
 USEARQ(sistema[op_sis,O_ARQUI],,,,.f.)
#endi

SET KEY K_F9 TO veoutros                           // habilita consulta em outros arquivos
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
op_menu=ALTERACAO                                  // parametro e' como se fosse alteracao
cod_sos=54
rola_t=.f.                                         // flag se quer rolar a tela
SELE PAR_ADM
DISPBEGIN()                                        // monta tela na pagina de traz
PAR_TELA()
PAR_GETS()
INFOSIS()                                          // exibe informacao no rodape' da tela
DISPEND()
PAR_GET1(INCLUI)
SELE PAR_ADM
FOR i=1 TO FCOU()                                  // atualiza variaveis publicas
 msg=FIEL(i)                                       // do arquivo de parametros
 M->&msg.=&msg.
NEXT
SET KEY K_F9 TO                                    // desativa tecla F9 (veoutros)
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC PAR_tela     // tela do arquivo PAR_ADM
tem_borda=.t.
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
i=LEN(sistema[op_sis,O_MENS])/2
@ l_s,c_s-1+(c_i-c_s+1)/2-i SAY " "+MAIUSC(sistema[op_sis,O_MENS])+" "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Conta Recebto.:         Conta Pagto.:"
@ l_s+02,c_s+1 SAY " Hist.F.C.C....:"
@ l_s+03,c_s+1 SAY " Hist.Rec.Taxas:"
@ l_s+04,c_s+1 SAY " Hist.Rec.Carn.:"
@ l_s+05,c_s+1 SAY " Hist.Pagamento:"
@ l_s+06,c_s+1 SAY "       ÄÄÄÄÄÄÄÄÄÄ Dados do £ltimo lan‡amento ÄÄÄÄÄÄÄÄÄÄ"
@ l_s+07,c_s+1 SAY " Grupo.:    Filial:     C¢digo:        Inscr:    Seq:"
@ l_s+08,c_s+1 SAY "       ÄÄÄÄÄÄÄÄÄÄÄÄÄ Dados de uso interno ÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+09,c_s+1 SAY " Cancelamentos:           Reintegra‡”es:"
@ l_s+10,c_s+1 SAY " Recibo 2¦ Via:           Contr.        Tipo   Circ"
@ l_s+11,c_s+1 SAY " C¢digo de Grupo para controle VIP:"
@ l_s+12,c_s+1 SAY " Imprime recibo com c¢digo barra..?"
@ l_s+13,c_s+1 SAY " Os Inscritos est„o cadastrados...?"
@ l_s+14,c_s+1 SAY " Imprime recibo nos pgtos. da recep‡„o ?"
@ l_s+15,c_s+1 SAY " Cidade:"
@ l_s+16,c_s+1 SAY " Usar como padr„o recibos em formul rio branco?"
@ l_s+17,c_s+1 SAY "       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Dados da Empresa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+18,c_s+1 SAY "                                         CGC"
RETU

PROC PAR_gets     // mostra variaveis do arquivo PAR_ADM
LOCAL getlist := {}
PAR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(HISTRCFCC,'HISTORIC',1)
@ l_s+07 ,c_s+10 GET  pgrupo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+07 ,c_s+21 GET  p_filial;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+07 ,c_s+33 GET  pcontrato;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+07 ,c_s+47 GET  pgrau;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+07 ,c_s+55 GET  pseq;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+09 ,c_s+17 GET  nrcanc;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+09 ,c_s+42 GET  nrreint;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+01 ,c_s+18 GET  contarec;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+01 ,c_s+41 GET  contapag;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+02 ,c_s+18 GET  histrcfcc;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,13,O_CRIT],,"3")

@ l_s+03 ,c_s+18 GET  histrcrec;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,14,O_CRIT],,"2")

@ l_s+04 ,c_s+18 GET  histrccar;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,15,O_CRIT],,"4")

@ l_s+05 ,c_s+18 GET  histpg;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,16,O_CRIT],,"1")

@ l_s+10 ,c_s+17 GET  nrauxrec;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+10 ,c_s+34 GET  mcodigo;
                 PICT sistema[op_sis,O_CAMPO,18,O_MASC]

@ l_s+10 ,c_s+46 GET  mtipo;
                 PICT sistema[op_sis,O_CAMPO,19,O_MASC]

@ l_s+10 ,c_s+53 GET  mcirc;
                 PICT sistema[op_sis,O_CAMPO,20,O_MASC]

@ l_s+11 ,c_s+37 GET  mgrupvip;
                 PICT sistema[op_sis,O_CAMPO,21,O_MASC]

@ l_s+12 ,c_s+37 GET  combarra;
                 PICT sistema[op_sis,O_CAMPO,22,O_MASC]

@ l_s+13 ,c_s+37 GET  cinscr;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+14 ,c_s+43 GET  comfalec;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

@ l_s+15 ,c_s+10 GET  p_cidade;
                 PICT sistema[op_sis,O_CAMPO,34,O_MASC]

@ l_s+16 ,c_s+49 GET  p_recp;
                 PICT sistema[op_sis,O_CAMPO,35,O_MASC]

@ l_s+18 ,c_s+01 GET  setup1

@ l_s+18 ,c_s+45 GET  cgcsetup;
                 PICT sistema[op_sis,O_CAMPO,37,O_MASC]

@ l_s+19 ,c_s+09 GET  setup2

@ l_s+20 ,c_s+09 GET  setup3

CLEAR GETS
RETU

PROC PAR_get1     // capta variaveis do arquivo PAR_ADM
LOCAL getlist := {}
PRIV  blk_par_adm:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+07 ,c_s+21 GET  p_filial;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2

  @ l_s+01 ,c_s+18 GET  contarec;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11

  @ l_s+01 ,c_s+41 GET  contapag;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+02 ,c_s+18 GET  histrcfcc;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13
                   MOSTRA sistema[op_sis,O_FORMULA,3]

  @ l_s+03 ,c_s+18 GET  histrcrec;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14
                   MOSTRA sistema[op_sis,O_FORMULA,2]

  @ l_s+04 ,c_s+18 GET  histrccar;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15
                   MOSTRA sistema[op_sis,O_FORMULA,4]

  @ l_s+05 ,c_s+18 GET  histpg;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+10 ,c_s+17 GET  nrauxrec;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                   DEFINICAO 17

  @ l_s+10 ,c_s+34 GET  mcodigo;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                   DEFINICAO 18

  @ l_s+10 ,c_s+46 GET  mtipo;
                   PICT sistema[op_sis,O_CAMPO,19,O_MASC]
                   DEFINICAO 19

  @ l_s+10 ,c_s+53 GET  mcirc;
                   PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                   DEFINICAO 20

  @ l_s+11 ,c_s+37 GET  mgrupvip;
                   PICT sistema[op_sis,O_CAMPO,21,O_MASC]
                   DEFINICAO 21

  @ l_s+12 ,c_s+37 GET  combarra;
                   PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                   DEFINICAO 22

  @ l_s+13 ,c_s+37 GET  cinscr;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                   DEFINICAO 23

  @ l_s+14 ,c_s+43 GET  comfalec;
                   PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                   DEFINICAO 24

  @ l_s+15 ,c_s+10 GET  p_cidade;
                   PICT sistema[op_sis,O_CAMPO,34,O_MASC]
                   DEFINICAO 34

  @ l_s+16 ,c_s+49 GET  p_recp;
                   PICT sistema[op_sis,O_CAMPO,35,O_MASC]
                   DEFINICAO 35

  @ l_s+18 ,c_s+01 GET  setup1
                   DEFINICAO 36

  @ l_s+18 ,c_s+45 GET  cgcsetup;
                   PICT sistema[op_sis,O_CAMPO,37,O_MASC]
                   DEFINICAO 37

  @ l_s+19 ,c_s+09 GET  setup2
                   DEFINICAO 38

  @ l_s+20 ,c_s+09 GET  setup3
                   DEFINICAO 39

  READ
  SET KEY K_ALT_F8 TO
  IF rola_t
   ROLATELA()
   LOOP
  ENDI
  EXIT
 ENDD
ENDI
RETU

* \\ Final de PAR_ADM.PRG
