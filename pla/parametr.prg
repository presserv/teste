procedure parametr
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform쟴ica-Limeira (019)452.6623
 \ Programa: PARAMETR.PRG
 \ Data....: 30-06-95
 \ Sistema.: Administradora de Funer쟲ias
 \ Funcao..: Gerenciador do subsistema de par긩etros do sistema
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v1.1 (DEPIN 22058-8)
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "admbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"PARAMETR")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI
SELE A

#ifdef COM_REDE
 IF !USEARQ(sistema[op_sis,O_ARQUI],.t.,20,1,.f.)  // se falhou a abertura do
  RETU                                             // arquivo volta ao menu anterior
 ENDI
#else
 USEARQ(sistema[op_sis,O_ARQUI],,,,.f.)
#endi

SET KEY K_F9 TO veoutros                           // habilita consulta em outros arquivos
t_f4_=SETKEY(K_F4,{||conf()})                      // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
op_menu=ALTERACAO                                  // parametro e' como se fosse alteracao
rola_t=.f.; cod_sos=6                              // flag se quer rolar a tela
SELE PARAMETR
DISPBEGIN()                                        // monta tela na pagina de traz
PAR_TELA()
PAR_GETS()
INFOSIS()                                         // exibe informacao no rodape' da tela
DISPEND()
PAR_GET1(0)
SELE PARAMETR
FOR i=1 TO FCOU()                                  // atualiza variaveis publicas
 msg=FIEL(i)                                       // do arquivo de parametros
 M->&msg.=&msg.
NEXT
SET KEY K_F9 TO                                    // desativa tecla F9 (veoutros)
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC PAR_tela     // tela do arquivo PARAMETR
tem_borda=.t.
SETCOLOR(drvtittel)
l_s=Sistema[op_sis,O_TELA,O_LS]           // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
i=LEN(sistema[op_sis,O_MENS])/2
@ l_s,c_s-1+(c_i-c_s+1)/2-i SAY " "+MAIUSC(sistema[op_sis,O_MENS])+" "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "컴컴컴컴컴 Dados do 즠timo lan놹mento 컴컴컴컴컴"
@ l_s+02,c_s+1 SAY " Grupo.:     C줰igo:        Inscr:    Seq:"
RETU

PROC PAR_gets     // mostra variaveis do arquivo PARAMETR
LOCAL getlist := {}
PAR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+02 ,c_s+10 GET  pgrupo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+22 GET  pcontrato;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+02 ,c_s+36 GET  pgrau;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+02 ,c_s+44 GET  pseq;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

CLEAR GETS
RETU

PROC PAR_get1     // capta variaveis do arquivo PARAMETR
LOCAL getlist := {}
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
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

* \\ Final de PARAMETR.PRG
