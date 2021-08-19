procedure fech
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: FECH.PRG
 \ Data....: 15-07-96
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Gerenciador do subsistema de fechamento
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0d
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "admbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"FECH")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI
cn:=fgrep :=.f.
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
    FEC_INCL()                                     // neste arquivo chama prg de inclusao
   ELSE                                            // caso contrario vamos avisar que
    ALERTA()                                       // ele nao tem permissao para isto
    DBOX(msg_auto,,,3)
   ENDI

  CASE op_cad=02                                   // consulta
   op_menu=PROJECOES
   cod_sos=8
   EDITA(5,21,MAXROW()-4,58)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC FEC_incl     // inclusao no arquivo FECH
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
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
 FEC_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE FECH
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
 FEC_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 FEC_GERA_SEQ()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/FECH->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA€O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUSŽO INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 M->data_=date()
 M->horario=time()
 SELE 0                                            // torna visiveis variaveis de memoria
 FEC_GET1(INCLUI)                                  // recebe campos
 SELE FECH
 IF LASTKEY()=K_ESC                                // se cancelou
  cabem=0
  LOOP
 ENDI

 #ifdef COM_REDE
  BLOARQ(0,.5)                                     // bloquea o arquivo
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
ENDD

#ifdef COM_REDE
 FEC_ANT_SEQ()                                     // restaura sequencial anterior
 SELE FECH
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
 PROC FEC_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE FEC_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_=intlan
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC FEC_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"FEC_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE FECH
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL FEC_SEQ->intlan WITH intlan
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE FEC_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC FEC_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE FEC_SEQ
 BLOARQ(0,.5)
 sq_intlan=FEC_SEQ->intlan
#else
 SET ORDER TO 0
 GO BOTT
#endi

M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 FEC_GRAVA_SEQ()
 sq_atual_=FEC_SEQ->intlan
 UNLOCK
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC FEC_GRAVA_SEQ
REPL intlan WITH M->intlan
RETU

PROC FEC_tela     // tela do arquivo FECH
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
@ l_s+02,c_s+1 SAY " Data.....:              Hor rio..:"
@ l_s+03,c_s+1 SAY " Usu rio..:"
@ l_s+04,c_s+1 SAY " Caso seja confirmado, ser  incluido nova"
@ l_s+05,c_s+1 SAY " numera‡„o nos Recibos e Auxilio Funeral."
@ l_s+06,c_s+1 SAY "       Confirma???"
RETU

PROC FEC_gets     // mostra variaveis do arquivo FECH
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
FEC_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+02 ,c_s+13 GET  data_;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+02 ,c_s+37 GET  horario

@ l_s+03 ,c_s+13 GET  quem

@ l_s+06 ,c_s+20 GET  confirma;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

CLEAR GETS
RETU

PROC FEC_get1     // capta variaveis do arquivo FECH
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
PRIV  blk_fech:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+02 ,c_s+13 GET data_;
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
  @ l_s+02 ,c_s+37 GET horario
  CLEA GETS
  @ l_s+03 ,c_s+13 GET  quem
                   DEFINICAO 3

  @ l_s+06 ,c_s+20 GET  confirma;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

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
 TIRA_LANC("BXREC","FEC-"+intlan,.f.)
 TIRA_LANC("AFUNER","FEC-"+intlan,.f.)
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  ord_=LEN(sistema[EVAL(qualsis,"BXREC"),O_CHAVE])
  chv_="FEC-"+intlan+"-001"
  PTAB(chv_,"BXREC",ord_)
  FAZ_LANC("BXREC",chv_,.t.)
  REPL BXREC->ano WITH RIGHT(DTOC(DATE()),2),;
       BXREC->numero WITH '00000',;
       BXREC->emitido_ WITH DATE(),;
       BXREC->por WITH M->usuario

  #ifdef COM_REDE
   BXREC->(DBUNLOCK())                             // libera o registro
  #endi

  ord_=LEN(sistema[EVAL(qualsis,"AFUNER"),O_CHAVE])
  chv_="FEC-"+intlan+"-002"
  PTAB(chv_,"AFUNER",ord_)
  FAZ_LANC("AFUNER",chv_,.t.)
  REPL AFUNER->processo WITH '00000',;
       AFUNER->proc2 WITH RIGHT(DTOC(DATE()),2),;
       AFUNER->ocorr_ WITH DATE()

  #ifdef COM_REDE
   AFUNER->(DBUNLOCK())                            // libera o registro
  #endi

  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de FECH.PRG
