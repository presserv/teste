procedure cancels
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: CANCELS.PRG
 \ Data....: 22-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de cancelamentos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"CANCELS")
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
 msg="Inclus„o|"+;
		 "Manuten‡„o|"+;
		 "Consulta|"+;
     "Processa"
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
    CAN_INCL()                                     // neste arquivo chama prg de inclusao
   ELSE                                            // caso contrario vamos avisar que
    ALERTA()                                       // ele nao tem permissao para isto
    DBOX(msg_auto,,,3)
   ENDI

	CASE op_cad=02                                   // manuten‡„o
	 SET KEY K_CTRL_P TO imp_r041
	 op_menu=ALTERACAO
	 cod_sos=7
	 EDIT()
	 SET KEY K_CTRL_P TO

  CASE op_cad=03                                   // consulta
   op_menu=PROJECOES
   cod_sos=8
   EDITA(5,26,MAXROW()-4,54)

  CASE op_cad=04                                   // consulta
   ADM_R032(5,18)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC CAN_incl     // inclusao no arquivo CANCELS
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:="", l_a
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
 CAN_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DISPBEGIN()                                        // monta tela na pagina de traz
CAN_TELA()                                         // imp tela para inclusao
INFOSIS()                                          // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE CANCELS
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
 CAN_GERA_SEQ()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/CANCELS->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 SET KEY K_ALT_F8 TO ROLATELA
 
 /*
    recebe chaves do arquivo de indice basico
 */
 @ l_s+l_a,c_s+01 GET  cnumero;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()

  #ifdef COM_REDE
   CAN_ANT_SEQ()                                   // decrementa sequencial
  #endi

  LOOP
 ENDI
 SELE CANCELS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->cnumero
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
  op_menu=ALTERACAO                                // seta flag de ateracao

  #ifdef COM_REDE
   CAN_ANT_SEQ()                                   // decrementa sequencial
   SELE CANCELS
  #endi

  DISPBEGIN()
  CAN_GETS()                                       // mostra conteudo do registro
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  ALERTA()
  msg="Consultar/alterar|Retornar … inclus„o"      // pergunta se deseja
  op_=DBOX(msg,,,E_MENU,,"REGISTRO J EXISTE")     // alterar o registro
  IF op_ =1                                        // caso afirmativo
   EDIT()                                          // deixa alterar
  ENDI
  op_menu=INCLUSAO
  DISPBEGIN()
  CAN_TELA()
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 CAN_GET1(INCLUI)                                  // recebe campos
 SELE CANCELS
 IF LASTKEY()=K_ESC                                // se cancelou

  #ifdef COM_REDE
   CAN_ANT_SEQ()                                   // decrementa sequencial
  #endi

  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->cnumero                                  // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   CAN_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€O!")                        // avisa
   SELE CANCELS
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
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+01,l_max-1,c_s+06,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+11,l_max-1,c_s+16,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+17,l_max-1,c_s+18,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+20,l_max-1,c_s+39,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+41,l_max-1,c_s+67,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+69,l_max-1,c_s+76,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+08,l_max-1,c_s+09,1)
 ENDI
ENDD

#ifdef COM_REDE
 CAN_ANT_SEQ()                                     // restaura sequencial anterior
 SELE CANCELS
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
 PROC CAN_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE CAN_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == cnumero
  REPL cnumero WITH sq_cnumero
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC CAN_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"CAN_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"cnumero"   ,"C",  6, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE CANCELS
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL CAN_SEQ->cnumero WITH cnumero
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE CAN_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC CAN_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE CAN_SEQ
 BLOARQ(0,.5)
 sq_cnumero=CAN_SEQ->cnumero
#else
 SET ORDER TO 0
 GO BOTT
#endi

M->cnumero=LPAD(STR(VAL(cnumero)+1),06,[0])

#ifdef COM_REDE
 CAN_GRAVA_SEQ()
 sq_atual_=CAN_SEQ->cnumero
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC CAN_GRAVA_SEQ
REPL cnumero WITH M->cnumero
RETU

PROC CAN_tela     // tela do arquivo CANCELS
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
@ l_s+01,c_s+1 SAY " N£mero   Contrato Motivo"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
RETU

PROC CAN_gets     // mostra variaveis do arquivo CANCELS
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
CAN_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max
 PTAB(CCODIGO,'GRUPOS',1)
 CRIT("",,"2|3")
 @ l_s+l_a,c_s+01 GET  cnumero;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]

 @ l_s+l_a,c_s+11 GET  ccodigo;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                  CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1")

 @ l_s+l_a,c_s+17 GET  cgrupo;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+l_a,c_s+20 GET  cmotivo;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC CAN_get1     // capta variaveis do arquivo CANCELS
LOCAL getlist := {}
PRIV  blk_cancels:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 IF TYPE("l_a")!="N"
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
 ENDI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3")
  @ l_s+l_a,c_s+11 GET  ccodigo;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+l_a,c_s+17 GET  cgrupo;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+l_a,c_s+20 GET  cmotivo;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

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
PTAB(CCODIGO,'GRUPOS',1)
PTAB(CGRUPO,'ARQGRUP',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
   IF EMPT(lancto_)
    IF op_menu=INCLUSAO
     lancto_=DATE()
    ELSE
     REPL lancto_ WITH DATE()
    ENDI
   ENDI
   IF EMPT(por)
    IF op_menu=INCLUSAO
     por=M->usuario
    ELSE
     REPL por WITH M->usuario
    ENDI
   ENDI
   IF EMPT(filial)
    IF op_menu=INCLUSAO
     filial=M->p_filial
    ELSE
     REPL filial WITH M->p_filial
    ENDI
   ENDI
  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de CANCELS.PRG
