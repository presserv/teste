procedure arqgrup
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: ARQGRUP.PRG
 \ Data....: 28-10-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de grupos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"ARQGRUP")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI
cn:=fgrep :=.f.

#ifdef COM_LOCK
 IF LEN(pr_ok)>0                                   // se a protecao acusou
  ? pr_ok                                          // erro, avisa e
  QUIT                                             // encerra a aplicacao
 ENDI
#endi

t_fundo=SAVESCREEN(0,0,MAXROW(),79)                // salva tela do fundo
op_cad=1
DO WHIL op_cad!=0
 criterio=""
 RESTSCREEN(,0,MAXROW(),79,t_fundo)                // restaura tela do fundo
 cod_sos=5 ; cn=.f.
 CLEA TYPEAHEAD                                    // limpa o buffer do teclado
 fgrep=.f.
 SET KEY K_F3 TO                                   // retira das teclas F3 e F4 as
 SET KEY K_F4 TO                                   // funcoes de repeticao e confirmacao
 msg="Inclus�o|"+;                                 // menu do subsistema
     "Manuten��o|"+;
     "Consulta"
 op_cad=DBOX(msg,lin_menu,col_menu,E_MENU,NAO_APAGA,MAIUSC(sistema[op_sis,O_MENU]),,,op_cad)
 IF op_cad!=0                                      // se escolheu uma opcao
  Tela_fundo=SAVESCREEN(0,0,MAXROW(),79)           // salva a tela para ROLATELA()
  SELE A                                           // e abre o arquivo e seus indices

  #ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)    // se falhou a abertura do
    RETU                                           // arquivo volta ao menu anterior
   ENDI
  #else
   USEARQ(sistema[op_sis,O_ARQUI])
  #endi

  SET KEY K_F9 TO veoutros                         // habilita consulta em outros arquivos
 ENDI
 DO CASE
  CASE op_cad=01                                   // inclus�o
   op_menu=INCLUSAO
   IF AT("D",exrot[op_sis])=0                      // se usuario pode fazer inclusao
    ARQ_INCL()                                     // neste arquivo chama prg de inclusao
   ELSE                                            // caso contrario vamos avisar que
    ALERTA()                                       // ele nao tem permissao para isto
    DBOX(msg_auto,,,3)
   ENDI

  CASE op_cad=02                                   // manuten��o
   op_menu=ALTERACAO
   cod_sos=7
   EDIT()

  CASE op_cad=03                                   // consulta
   op_menu=PROJECOES
   cod_sos=8
   EDITA(5,07,MAXROW()-4,72)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC ARQ_incl     // inclusao no arquivo ARQGRUP
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
FOR i=1 TO FCOU()                                  // cria/declara privadas as
 msg=FIEL(i)                                       // variaveis de memoria com
 PRIV &msg.                                        // o mesmo nome dos campos
NEXT                                               // do arquivo
AFILL(rep,"")
t_f3_=SETKEY(K_F3,{||rep()})                       // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})                      // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE ARQGRUP
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo
 
 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF(fgrep.AND.!EMPT(rep[1]),rep[i],&msg.)
 NEXT
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 IMPRELA()
 ARQ_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/ARQGRUP->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA�O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUS�O INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA
 
 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+01 ,c_s+14 GET  grup;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE ARQGRUP
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->grup
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  IMPRELA()
  ARQ_GETS()                                       // mostra conteudo do registro
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar � inclus�o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J� EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 ARQ_GET1(INCLUI)                                  // recebe campos
 SELE ARQGRUP
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->grup                                     // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   ARQ_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE ARQGRUP
   UNLOCK                                          // libera o registro
   LOOP                                            // e recebe chave novamente
  ENDI
 #endi

 IF aprov_reg_                                     // se vai aproveitar reg excluido

  #ifdef COM_REDE
   BLOREG(0,.5)
  #endi

  RECA                                             // excluido, vamos recupera-lo
 ELSE                                              // caso contrario
  APPEND BLANK                                     // inclui reg em branco no dbf
 ENDI
 FOR i=1 TO FCOU()                                 // para cada campo,
  msg=FIEL(i)                                      // salva o conteudo
  rep[i]=M->&msg.                                  // para repetir
  REPL &msg. WITH rep[i]                           // enche o campo do arquivo
 NEXT

 #ifdef COM_REDE
  UNLOCK                                           // libera o registro e
  COMMIT                                           // forca gravacao
 #else
  IF RECC()-INT(RECC()/20)*20=0                    // a cada 20 registros
   COMMIT                                          // digitados forca gravacao
  ENDI
 #endi

 ult_reg=RECN()                                    // ultimo registro digitado
 SUBNIVEL("FCGRUPO")
ENDD
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC ARQ_tela     // tela do arquivo ARQGRUP
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
@ l_s+01,c_s+1 SAY " Grupo.....:"
@ l_s+02,c_s+1 SAY " Classe....:"
@ l_s+03,c_s+1 SAY " N�.Inicial:             N�.Final:"
@ l_s+04,c_s+1 SAY "����������������������������������������������"
@ l_s+05,c_s+1 SAY " Emitir recibos com no m�nimo      e no"
@ l_s+06,c_s+1 SAY "                    m�ximo      processos."
@ l_s+07,c_s+1 SAY " Comparar admiss�o & atendimento ?"
@ l_s+08,c_s+1 SAY " Intervalo minimo de     dias."
@ l_s+09,c_s+1 SAY "����������������������������������������������"
@ l_s+10,c_s+1 SAY " Os contratos estar�o remidos ap�s     taxas"
@ l_s+11,c_s+1 SAY " (por atendimento?  )"
@ l_s+12,c_s+1 SAY "����������������������������������������������"
@ l_s+13,c_s+1 SAY " Ultima circular:      Emiss�o:"
@ l_s+14,c_s+1 SAY "        contratos ativos,        participantes"
@ l_s+15,c_s+1 SAY " vivos e     processos pendentes."
@ l_s+16,c_s+1 SAY "����������������������������������������������"
@ l_s+17,c_s+1 SAY " Emitir circular n�"
RETU

PROC ARQ_gets     // mostra variaveis do arquivo ARQGRUP
LOCAL getlist := {}
ARQ_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CLASSE,'CLASSES',1)
CRIT("",,"2|3|4|5|6")
@ l_s+01 ,c_s+14 GET  grup;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+14 GET  classe;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1")

@ l_s+03 ,c_s+14 GET  inicio;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+03 ,c_s+36 GET  final;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+05 ,c_s+32 GET  acumproc;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+06 ,c_s+29 GET  maxproc;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+07 ,c_s+36 GET  cpadmiss;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+08 ,c_s+22 GET  periodic;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+10 ,c_s+36 GET  qtdremir;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+11 ,c_s+20 GET  poratend;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+17 ,c_s+21 GET  proxcirc;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

CLEAR GETS
RETU

PROC ARQ_get1     // capta variaveis do arquivo ARQGRUP
LOCAL getlist := {}
PRIV  blk_arqgrup:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3|4|5|6")
  @ l_s+02 ,c_s+14 GET  classe;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+03 ,c_s+14 GET  inicio;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+03 ,c_s+36 GET  final;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+05 ,c_s+32 GET  acumproc;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+06 ,c_s+29 GET  maxproc;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+07 ,c_s+36 GET  cpadmiss;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+08 ,c_s+22 GET  periodic;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+10 ,c_s+36 GET  qtdremir;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+11 ,c_s+20 GET  poratend;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+17 ,c_s+21 GET  proxcirc;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16

  READ
  SET KEY K_ALT_F8 TO
  IF rola_t
   ROLATELA()
   LOOP
  ENDI
  IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
   IF !CONFINCL()
    LOOP
   ENDI
  ENDI
  EXIT
 ENDD
ENDI
PTAB(CLASSE,'CLASSES',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 INTREF(FORM_INVERSA)
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
   IF M->lastcodigo<final
   PARAMETROS('lastcodigo',final)
   ENDI
  IF op_menu!=INCLUSAO
   RECA
   INTREF(FORM_DIRETA)
  ENDI
 ENDI
ENDI
RETU

PROC FCG_incl     // inclusao no arquivo FCGRUPO
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"FCGRUPO")
IF AT("D",exrot[op_sis])>0
 RETU
ENDI
FOR i=1 TO FCOU()                                  // cria/declara privadas as
 msg=FIEL(i)                                       // variaveis de memoria com
 PRIV &msg.                                        // o mesmo nome dos campos
NEXT                                               // do arquivo
AFILL(rep,"")
t_f3_=SETKEY(K_F3,{||rep()})                       // repeticao reg anterior
t_f4_=SETKEY(K_F4,{||conf()})                      // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})               // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
DISPBEGIN()                                        // monta tela na pagina de traz
IMPRELA()                                          // imp telas do pai
FCG_TELA()                                         // imp tela para inclusao
INFOSIS()                                          // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE FCGRUPO
 GO BOTT                                           // forca o
 SKIP                                              // final do arquivo
 
 /*
    cria variaveis de memoria identicas as de arquivo, para inclusao
    de registros
 */
 FOR i=1 TO FCOU()
  msg=FIEL(i)
  M->&msg.=IF(fgrep.AND.!EMPT(rep[1]),rep[i],&msg.)
 NEXT
 
 /*
    inicializa campos de relacionamentos do com os campos do arquivo
    superior (pai)
 */
 FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
  msg=FIEL(VAL(SUBS(sistema[op_sis,O_ORDEM,1],i*2-1,2)))
  M->&msg.=&(sistema[op_sis,O_CPRELA,i])
 NEXT
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/FCGRUPO->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA�O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUS�O INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA
 
 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+l_a,c_s+01 GET  mesref;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE FCGRUPO
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->grup+M->mesref
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  FCG_GETS()                                       // mostra conteudo do registro
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar � inclus�o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J� EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  DISPBEGIN()
  FCG_TELA()
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 FCG_GET1(INCLUI)                                  // recebe campos
 SELE FCGRUPO
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->grup+M->mesref                           // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   FCG_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE FCGRUPO
   UNLOCK                                          // libera o registro
   LOOP                                            // e recebe chave novamente
  ENDI
 #endi

 IF aprov_reg_                                     // se vai aproveitar reg excluido

  #ifdef COM_REDE
   BLOREG(0,.5)
  #endi

  RECA                                             // excluido, vamos recupera-lo
 ELSE                                              // caso contrario
  APPEND BLANK                                     // inclui reg em branco no dbf
 ENDI
 FOR i=1 TO FCOU()                                 // para cada campo,
  msg=FIEL(i)                                      // salva o conteudo
  rep[i]=M->&msg.                                  // para repetir
  REPL &msg. WITH rep[i]                           // enche o campo do arquivo
 NEXT

 #ifdef COM_REDE
  UNLOCK                                           // libera o registro e
  COMMIT                                           // forca gravacao
 #else
  IF RECC()-INT(RECC()/20)*20=0                    // a cada 20 registros
   COMMIT                                          // digitados forca gravacao
  ENDI
 #endi

 ult_reg=RECN()                                    // ultimo registro digitado
 l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
 IF l_s+l_a+1<l_max                                // se nao atingiu o fim da tela
  l_a++                                            // digita na proxima linha
 ELSE                                              // se nao rola a campos para cima
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+01,l_max-1,c_s+05,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+13,l_max-1,c_s+22,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+30,l_max-1,c_s+39,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+47,l_max-1,c_s+56,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+07,l_max-1,c_s+12,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+24,l_max-1,c_s+29,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+41,l_max-1,c_s+46,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+58,l_max-1,c_s+62,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+63,l_max-1,c_s+72,1)
 ENDI
ENDD
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC FCG_tela     // tela do arquivo FCGRUPO
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
@ l_s+01,c_s+1 SAY " Mes     Entregue          Recebido         Retornado       Pend�ncia"
RETU

PROC FCG_gets     // mostra variaveis do arquivo FCGRUPO
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
FCG_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 CRIT("",,"1|2|3|4|5|6|7|8")
 @ l_s+l_a,c_s+01 GET  mesref;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC FCG_get1     // capta variaveis do arquivo FCGRUPO
LOCAL getlist := {}
PRIV  blk_fcgrupo:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 IF TYPE("l_a")!="N"
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
 ENDI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"1|2|3|4|5|6|7|8")
  READ
  SET KEY K_ALT_F8 TO
  IF rola_t
   ROLATELA()
   LOOP
  ENDI
  IF LASTKEY()!=K_ESC .AND. drvincl .AND. op_menu=INCLUSAO
   IF !CONFINCL()
    LOOP
   ENDI
  ENDI
  EXIT
 ENDD
ENDI
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #else
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #endi

 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (ARQGRUP->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"ARQGRUP"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu�do em:"+msg+"|*",,,,,"IMPOSS�VEL RECUPERAR!")
  ELSE
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   IF op_menu!=INCLUSAO
    RECA
   ENDI
  ENDI
 ENDI
ENDI
RETU

* \\ Final de ARQGRUP.PRG
