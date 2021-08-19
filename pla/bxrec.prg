procedure bxrec
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: BXREC.PRG
 \ Data....: 28-10-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de recebimento de taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"BXREC")
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
 msg="Inclus�o|"+;
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
    BXR_INCL()                                     // neste arquivo chama prg de inclusao
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
   EDITA(3,3,MAXROW()-2,77)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC BXR_incl     // inclusao no arquivo BXREC
LOCAL getlist:={},cabem:=1,rep:=ARRAY(FCOU()),ult_reg:=RECN(),cond_incl_,dbfseq_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, sq_atual_, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 ALERTA(2)                                         // avisa o motivo
 DBOX("Mantido pela Recep��o",,,4,,"ATEN��O, "+usuario)
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
 BXR_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE BXREC
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
 BXR_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 BXR_GERA_SEQ()
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/BXREC->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA�O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUS�O INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 M->ano=LPAD(RIGHT(DTOC(DATE()),2),02,[0])
 SELE 0                                            // torna visiveis variaveis de memoria
 BXR_GET1(INCLUI)                                  // recebe campos
 SELE BXREC
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
ENDD

#ifdef COM_REDE
 BXR_ANT_SEQ()                                     // restaura sequencial anterior
 SELE BXREC
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
 PROC BXR_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE BXR_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == numero
  REPL numero WITH sq_numero
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC BXR_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"BXR_seq" // arq temporario
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
 SELE BXREC
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL BXR_SEQ->numero WITH numero
  REPL BXR_SEQ->intlan WITH intlan
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE BXR_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC BXR_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE BXR_SEQ
 BLOARQ(0,.5)
 sq_numero=BXR_SEQ->numero
 sq_intlan=BXR_SEQ->intlan
#else
 SET ORDER TO 0
 GO BOTT
#endi

M->numero=LPAD(STR(VAL(numero)+1),06,[0])
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 BXR_GRAVA_SEQ()
 sq_atual_=BXR_SEQ->numero
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC BXR_GRAVA_SEQ
REPL numero WITH M->numero
REPL intlan WITH M->intlan
RETU

PROC BXR_tela     // tela do arquivo BXREC
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
@ l_s+01,c_s+1 SAY " Numero:   -      -"
@ l_s+02,c_s+1 SAY " Contrato:"
@ l_s+03,c_s+1 SAY "��������������������������������������������������"
@ l_s+04,c_s+1 SAY "                                     � Circulares"
@ l_s+05,c_s+1 SAY "                                     �  Ini"
@ l_s+06,c_s+1 SAY "                           Reg.:     �  �lt"
@ l_s+07,c_s+1 SAY "                                     �  Qtd"
@ l_s+08,c_s+1 SAY " Admiss�o:           Sai Taxa:       �"
@ l_s+09,c_s+1 SAY " Funerais:           Cobrador:       �  Pend"
@ l_s+10,c_s+1 SAY "��������������������������������������������������"
@ l_s+11,c_s+1 SAY "    Cir Emiss�o     Valor   Pago em     Valor"
@ l_s+16,c_s+1 SAY "��������������������������������������������������"
@ l_s+17,c_s+1 SAY " Circular..:        Valor pago:"
@ l_s+18,c_s+1 SAY " Pago com..:             Troco:"
@ l_s+19,c_s+1 SAY "  emitida em          por"
RETU

PROC BXR_gets     // mostra variaveis do arquivo BXREC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
BXR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CODIGO,'GRUPOS',1)
CRIT("",,"18")
@ l_s+01 ,c_s+10 GET  ano;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+13 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+02 ,c_s+12 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1|2|3|4|5|6|7|8|9|10|11|12|13|14|17")

@ l_s+17 ,c_s+14 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+17 ,c_s+15 GET  circ;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+17 ,c_s+33 GET  valorpg;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+18 ,c_s+14 GET  valoraux;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,07,O_CRIT],,"16")

@ l_s+19 ,c_s+14 GET  emitido_;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+19 ,c_s+27 GET  por

@ l_s+19 ,c_s+44 GET  numop;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

CRIT("",,"15")
CLEAR GETS
RETU

PROC BXR_get1     // capta variaveis do arquivo BXREC
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
PRIV  blk_bxrec:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+10 GET ano;
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
  @ l_s+01 ,c_s+13 GET numero;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
  @ l_s+19 ,c_s+14 GET emitido_;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
  @ l_s+19 ,c_s+27 GET por
  @ l_s+19 ,c_s+44 GET numop;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
  CLEA GETS
  CRIT("",,"18")
  @ l_s+02 ,c_s+12 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3
                   MOSTRA sistema[op_sis,O_FORMULA,1]
                   MOSTRA sistema[op_sis,O_FORMULA,2]
                   MOSTRA sistema[op_sis,O_FORMULA,3]
                   MOSTRA sistema[op_sis,O_FORMULA,4]
                   MOSTRA sistema[op_sis,O_FORMULA,5]
                   MOSTRA sistema[op_sis,O_FORMULA,6]
                   MOSTRA sistema[op_sis,O_FORMULA,7]
                   MOSTRA sistema[op_sis,O_FORMULA,8]
                   MOSTRA sistema[op_sis,O_FORMULA,9]
                   MOSTRA sistema[op_sis,O_FORMULA,10]
                   MOSTRA sistema[op_sis,O_FORMULA,11]
                   MOSTRA sistema[op_sis,O_FORMULA,12]
                   MOSTRA sistema[op_sis,O_FORMULA,13]
                   MOSTRA sistema[op_sis,O_FORMULA,14]
                   MOSTRA sistema[op_sis,O_FORMULA,17]

  @ l_s+17 ,c_s+14 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+17 ,c_s+15 GET  circ;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+17 ,c_s+33 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+18 ,c_s+14 GET  valoraux;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7
                   MOSTRA sistema[op_sis,O_FORMULA,16]

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
PTAB(CODIGO,'GRUPOS',1)
PTAB(CODIGO,'TAXAS',1)
PTAB(CODIGO+TIPO+CIRC,'TAXAS',1)
RETU

* \\ Final de BXREC.PRG
