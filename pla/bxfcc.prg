procedure bxfcc
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: BXFCC.PRG
 \ Data....: 17-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de acerto pagos e trocas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"BXFCC")
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
 msg="Inclus„o|"+;                                 // menu do subsistema
     "Manuten‡„o|"+;
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
  CASE op_cad=01                                   // inclus„o
   op_menu=INCLUSAO
   IF AT("D",exrot[op_sis])=0                      // se usuario pode fazer inclusao
    BXF_INCL()                                     // neste arquivo chama prg de inclusao
   ELSE                                            // caso contrario vamos avisar que
    ALERTA()                                       // ele nao tem permissao para isto
    DBOX(msg_auto,,,3)
   ENDI

  CASE op_cad=02                                   // manuten‡„o
   op_menu=ALTERACAO
   cod_sos=7
   EDIT()

  CASE op_cad=03                                   // consulta
   op_menu=PROJECOES
   cod_sos=8
   EDITA(3,3,MAXROW()-2,77)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC BXF_incl     // inclusao no arquivo BXFCC
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),cond_incl_,dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 ALERTA(2)                                         // avisa o motivo
 DBOX("Mantido pelo sistema de Cobran‡a (ADCBIG)",,,4,,"ATEN€ŽO, "+usuario)
 RETU                                              // e retorna
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

#ifdef COM_REDE
 BXF_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE BXFCC
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
 BXF_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 BXF_GERA_SEQ()
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/BXFCC->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA
 
 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+01 ,c_s+17 GET  idfilial;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 @ l_s+02 ,c_s+17 GET  numero;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()

  #ifdef COM_REDE
   BXF_ANT_SEQ()                                   // decrementa sequencial
  #endi

  LOOP
 ENDI
 SELE BXFCC
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->idfilial+M->numero
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao

  #ifdef COM_REDE
   BXF_ANT_SEQ()                                   // decrementa sequencial
   SELE BXFCC
  #endi

  DISPBEGIN()
  IMPRELA()
  BXF_GETS()                                       // mostra conteudo do registro
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar … inclus„o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 BXF_GET1(INCLUI)                                  // recebe campos
 SELE BXFCC
 IF LASTKEY()=K_ESC                                // se cancelou

  #ifdef COM_REDE
   BXF_ANT_SEQ()                                   // decrementa sequencial
  #endi

  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->idfilial+M->numero                       // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   BXF_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE BXFCC
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
 SUBNIVEL("BXTXAS")
 SUBNIVEL("TROTXAS")
ENDD

#ifdef COM_REDE
 BXF_ANT_SEQ()                                     // restaura sequencial anterior
 SELE BXFCC
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU


#ifdef COM_REDE
 PROC BXF_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE BXF_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == numero
  REPL numero WITH sq_numero
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC BXF_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"BXF_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"numero"    ,"C",  6, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE BXFCC
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL BXF_SEQ->numero WITH numero
  REPL BXF_SEQ->intlan WITH intlan
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE BXF_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC BXF_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE BXF_SEQ
 BLOARQ(0,.5)
 sq_numero=BXF_SEQ->numero
 sq_intlan=BXF_SEQ->intlan
#else
 SET ORDER TO 0
 GO BOTT
#endi

M->numero=LPAD(STR(VAL(numero)+1),06,[0])
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 BXF_GRAVA_SEQ()
 sq_atual_=BXF_SEQ->numero
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC BXF_GRAVA_SEQ
REPL numero WITH M->numero
REPL intlan WITH M->intlan
RETU

PROC BXF_tela     // tela do arquivo BXFCC
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
@ l_s+01,c_s+1 SAY " C¢digo Filial:"
@ l_s+02,c_s+1 SAY " Numero FCC...:           em          por"
@ l_s+03,c_s+1 SAY " Cobrador.....:"
@ l_s+04,c_s+1 SAY " Despesas.....:             Data de Baixa:"
@ l_s+05,c_s+1 SAY "         Comiss„o   Qtde   Valor Rec.    Comiss„o"
@ l_s+06,c_s+1 SAY " Taxas.:       %"
@ l_s+07,c_s+1 SAY " Trocas:       %          *          *"
@ l_s+08,c_s+1 SAY " Carnˆs:       %"
@ l_s+09,c_s+1 SAY " Outros:       %"
@ l_s+10,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+11,c_s+1 SAY "                  Total:"
@ l_s+12,c_s+1 SAY "** A soma das Trocas n„o est  incluida no Total **"
RETU

PROC BXF_gets     // mostra variaveis do arquivo BXFCC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
BXF_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(COBRADOR,'COBRADOR',1)
CRIT("",,"1|2|3|4|5|6|7|8")
@ l_s+01 ,c_s+17 GET  idfilial;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+17 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+03 ,c_s+17 GET  cobrador;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+03 ,c_s+20 GET  nomecobr;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+04 ,c_s+17 GET  despesas;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+04 ,c_s+44 GET  baixa_;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+06 ,c_s+11 GET  comtxa;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,09,O_CRIT],,"10")

@ l_s+07 ,c_s+11 GET  comtroc;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,10,O_CRIT],,"11")

@ l_s+08 ,c_s+11 GET  comcarn;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,11,O_CRIT],,"12")

@ l_s+09 ,c_s+11 GET  comoutr;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+09 ,c_s+20 GET  qtdoutr;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+09 ,c_s+28 GET  vloutr;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,14,O_CRIT],,"9|13|14")

@ l_s+01 ,c_s+45 GET  numop;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

CLEAR GETS
RETU

PROC BXF_get1     // capta variaveis do arquivo BXFCC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
PRIV  blk_bxfcc:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+45 GET numop;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
  CLEA GETS
  CRIT("",,"1|2|3|4|5|6|7|8")
  @ l_s+03 ,c_s+17 GET  cobrador;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+03 ,c_s+20 GET  nomecobr;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+04 ,c_s+17 GET  despesas;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+04 ,c_s+44 GET  baixa_;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+06 ,c_s+11 GET  comtxa;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9
                   MOSTRA sistema[op_sis,O_FORMULA,10]

  @ l_s+07 ,c_s+11 GET  comtroc;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10
                   MOSTRA sistema[op_sis,O_FORMULA,11]

  @ l_s+08 ,c_s+11 GET  comcarn;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11
                   MOSTRA sistema[op_sis,O_FORMULA,12]

  @ l_s+09 ,c_s+11 GET  comoutr;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+09 ,c_s+20 GET  qtdoutr;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13

  @ l_s+09 ,c_s+28 GET  vloutr;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14
                   MOSTRA sistema[op_sis,O_FORMULA,9]
                   MOSTRA sistema[op_sis,O_FORMULA,13]
                   MOSTRA sistema[op_sis,O_FORMULA,14]

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
 IF 1=3
  TIRA_LANC("HISTORIC","BXF-"+intlan,.f.)
 ENDI
 INTREF(FORM_INVERSA)
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF 1=3
   ord_=LEN(sistema[EVAL(qualsis,"HISTORIC"),O_CHAVE])
   chv_="BXF-"+intlan+"-001"
   PTAB(chv_,"HISTORIC",ord_)
   FAZ_LANC("HISTORIC",chv_,.t.)

   #ifdef COM_REDE
    HISTORIC->(DBUNLOCK())                         // libera o registro
   #endi

  ENDI
  IF op_menu!=INCLUSAO
   RECA
   INTREF(FORM_DIRETA)
  ENDI
 ENDI
ENDI
RETU

PROC BXT_incl     // inclusao no arquivo BXTXAS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 IF op_menu!=INCLUSAO                              // nao inclusao nao tem msg
  ALERTA(2)                                        // avisa o motivo
  DBOX("Mantido pelo sistema de Cobran‡a (ADCBIG)",,,4,,"ATEN€ŽO, "+usuario)
 ENDI
 RETU                                              // e retorna
ENDI
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"BXTXAS")
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
BXT_TELA()                                         // imp tela para inclusao
INFOSIS()                                          // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE BXTXAS
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
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/BXTXAS->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 BXT_GET1(INCLUI)                                  // recebe campos
 SELE BXTXAS
 IF LASTKEY()=K_ESC                                // se cancelou
  cabem=0
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
 #endi

 APPEND BLANK                                      // inclui reg em branco no dbf
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
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+07,l_max-1,c_s+12,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+17,l_max-1,c_s+17,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+19,l_max-1,c_s+21,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+27,l_max-1,c_s+36,1)
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

PROC BXT_tela     // tela do arquivo BXTXAS
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
@ l_s+01,c_s+1 SAY "      Codigo ³ Circular ³ Valor pago"
@ l_s+02,c_s+1 SAY "     ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY "             ³          ³"
@ l_s+04,c_s+1 SAY "             ³          ³"
@ l_s+05,c_s+1 SAY "             ³          ³"
@ l_s+06,c_s+1 SAY "             ³          ³"
@ l_s+07,c_s+1 SAY "             ³          ³"
@ l_s+08,c_s+1 SAY "             ³          ³"
RETU

PROC BXT_gets     // mostra variaveis do arquivo BXTXAS
LOCAL getlist := {}, tl_item_, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
BXT_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 @ l_s+l_a,c_s+01 GET  seq;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+l_a,c_s+07 GET  codigo;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+l_a,c_s+17 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+l_a,c_s+19 GET  circ;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]

 @ l_s+l_a,c_s+27 GET  valorpg;
                  PICT sistema[op_sis,O_CAMPO,07,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC BXT_get1     // capta variaveis do arquivo BXTXAS
LOCAL getlist := {}, tl_item_
PRIV  blk_bxtxas:=.t.
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
  @ l_s+l_a,c_s+01 GET  seq;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+l_a,c_s+07 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+l_a,c_s+17 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+l_a,c_s+19 GET  circ;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+l_a,c_s+27 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

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
  IF !(tipo$'16')
   REPBLO('BXFCC->parcpag',{||BXFCC->parcpag - 1})
  ENDI
  IF !(tipo$'16')
   REPBLO('BXFCC->vltaxas',{||BXFCC->vltaxas -valorpg})
  ENDI
  IF (tipo$'16')
   REPBLO('BXFCC->parccarn',{||BXFCC->parccarn - 1})
  ENDI
  IF (tipo$'16')
   REPBLO('BXFCC->vlcarnes',{||BXFCC->vlcarnes -valorpg})
  ENDI
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #else
  IF !(tipo$'16')
   REPL BXFCC->parcpag WITH BXFCC->parcpag - 1
  ENDI
  IF !(tipo$'16')
   REPL BXFCC->vltaxas WITH BXFCC->vltaxas -valorpg
  ENDI
  IF (tipo$'16')
   REPL BXFCC->parccarn WITH BXFCC->parccarn - 1
  ENDI
  IF (tipo$'16')
   REPL BXFCC->vlcarnes WITH BXFCC->vlcarnes -valorpg
  ENDI
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #endi

 DELE
 IF op_menu!=PROJECOES
  REIMPTEL()
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (BXFCC->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"BXFCC"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE

   #ifdef COM_REDE
    IF !(tipo$'16')
     REPBLO('BXFCC->parcpag',{||BXFCC->parcpag + 1})
    ENDI
    IF !(tipo$'16')
     REPBLO('BXFCC->vltaxas',{||BXFCC->vltaxas +valorpg})
    ENDI
    IF (tipo$'16')
     REPBLO('BXFCC->parccarn',{||BXFCC->parccarn + 1})
    ENDI
    IF (tipo$'16')
     REPBLO('BXFCC->vlcarnes',{||BXFCC->vlcarnes +valorpg})
    ENDI
   PARAMETROS('pvalor',valorpg)
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #else
    IF !(tipo$'16')
     REPL BXFCC->parcpag WITH BXFCC->parcpag + 1
    ENDI
    IF !(tipo$'16')
     REPL BXFCC->vltaxas WITH BXFCC->vltaxas +valorpg
    ENDI
    IF (tipo$'16')
     REPL BXFCC->parccarn WITH BXFCC->parccarn + 1
    ENDI
    IF (tipo$'16')
     REPL BXFCC->vlcarnes WITH BXFCC->vlcarnes +valorpg
    ENDI
   PARAMETROS('pvalor',valorpg)
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #endi

   IF op_menu!=INCLUSAO
    RECA
   ENDI
   IF (tp_mov=INCLUI .OR. tp_mov=RECUPERA) .AND. op_menu!=PROJECOES
    REIMPTEL()
   ENDI
  ENDI
 ENDI
ENDI
RETU

PROC TRO_incl     // inclusao no arquivo TROTXAS
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),cond_incl_,dbfseq_,;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 IF op_menu!=INCLUSAO                              // nao inclusao nao tem msg
  ALERTA(2)                                        // avisa o motivo
  DBOX("Mantido pelo sistema de Cobran‡a (ADCBIG)",,,4,,"ATEN€ŽO, "+usuario)
 ENDI
 RETU                                              // e retorna
ENDI
PRIV op_menu:=INCLUSAO, sq_atual_, op_sis, l_s, c_s, l_i, c_i, cod_sos, chv_rela, chv_1, chv_2, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"TROTXAS")
IF AT("D",exrot[op_sis])>0
 RETU
ENDI
chv_rela=""
FOR i=1 TO LEN(sistema[op_sis,O_CPRELA])
 chv_rela+="+"+TRANSCAMPO(.f.,sistema[op_sis,O_CPRELA,i],i)
NEXT
chv_rela=IF(LEN(chv_rela)>2,SUBS(chv_rela,2),"")
PEGACHV2()
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

#ifdef COM_REDE
 TRO_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DISPBEGIN()                                        // monta tela na pagina de traz
IMPRELA()                                          // imp telas do pai
TRO_TELA()                                         // imp tela para inclusao
INFOSIS()                                          // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE TROTXAS
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
 TRO_GERA_SEQ()
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/TROTXAS->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 TRO_GET1(INCLUI)                                  // recebe campos
 SELE TROTXAS
 IF LASTKEY()=K_ESC                                // se cancelou
  cabem=0
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
 #endi

 APPEND BLANK                                      // inclui reg em branco no dbf
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
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+02,l_max-1,c_s+06,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+08,l_max-1,c_s+13,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+18,l_max-1,c_s+18,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+20,l_max-1,c_s+22,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+28,l_max-1,c_s+37,1)
 ENDI
ENDD

#ifdef COM_REDE
 TRO_ANT_SEQ()                                     // restaura sequencial anterior
 SELE TROTXAS
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU


#ifdef COM_REDE
 PROC TRO_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE TRO_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == seq
  REPL seq WITH sq_seq
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC TRO_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"TRO_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"seq"       ,"C",  5, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE TROTXAS
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL TRO_SEQ->seq WITH seq
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE TRO_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC TRO_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi

FIM_ARQ()
M->seq=LPAD(STR(VAL(seq)+1),05,[0])
RETU

PROC TRO_GRAVA_SEQ
REPL seq WITH M->seq
RETU

PROC TRO_tela     // tela do arquivo TROTXAS
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
@ l_s+01,c_s+1 SAY "       Codigo ³ Circular ³     Valor"
@ l_s+02,c_s+1 SAY "      ÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY "              ³          ³"
@ l_s+04,c_s+1 SAY "              ³          ³"
@ l_s+05,c_s+1 SAY "              ³          ³"
@ l_s+06,c_s+1 SAY "              ³          ³"
@ l_s+07,c_s+1 SAY "              ³          ³"
RETU

PROC TRO_gets     // mostra variaveis do arquivo TROTXAS
LOCAL getlist := {}, tl_item_, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
TRO_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 @ l_s+l_a,c_s+02 GET  seq;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+l_a,c_s+08 GET  codigo;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+l_a,c_s+18 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+l_a,c_s+20 GET  circ;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]

 @ l_s+l_a,c_s+28 GET  valorpg;
                  PICT sistema[op_sis,O_CAMPO,07,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC TRO_get1     // capta variaveis do arquivo TROTXAS
LOCAL getlist := {}, tl_item_
PRIV  blk_trotxas:=.t.
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
  @ l_s+l_a,c_s+02 GET seq;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
  CLEA GETS
  @ l_s+l_a,c_s+08 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+l_a,c_s+18 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+l_a,c_s+20 GET  circ;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+l_a,c_s+28 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

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
  REPBLO('BXFCC->parctroc',{||BXFCC->parctroc - 1})
  REPBLO('BXFCC->vltrocas',{||BXFCC->vltrocas -valorpg})
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #else
  REPL BXFCC->parctroc WITH BXFCC->parctroc - 1
  REPL BXFCC->vltrocas WITH BXFCC->vltrocas -valorpg
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #endi

 DELE
 IF op_menu!=PROJECOES
  REIMPTEL()
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (BXFCC->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"BXFCC"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
  ELSE

   #ifdef COM_REDE
    REPBLO('BXFCC->parctroc',{||BXFCC->parctroc + 1})
    REPBLO('BXFCC->vltrocas',{||BXFCC->vltrocas +valorpg})
   PARAMETROS('pvalor',valorpg)
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #else
    REPL BXFCC->parctroc WITH BXFCC->parctroc + 1
    REPL BXFCC->vltrocas WITH BXFCC->vltrocas +valorpg
   PARAMETROS('pvalor',valorpg)
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #endi

   IF op_menu!=INCLUSAO
    RECA
   ENDI
   IF (tp_mov=INCLUI .OR. tp_mov=RECUPERA) .AND. op_menu!=PROJECOES
    REIMPTEL()
   ENDI
  ENDI
 ENDI
ENDI
RETU

* \\ Final de BXFCC.PRG
