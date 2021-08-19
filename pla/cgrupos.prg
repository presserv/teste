procedure cgrupos
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: CGRUPOS.PRG
 \ Data....: 17-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de contratos cancelados
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"CGRUPOS")
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
 msg="Manuten‡„o|"+;                               // menu do subsistema
		 "Consulta|"+;
     "Imprimir"
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
  CASE op_cad=01                                   // manuten‡„o
   op_menu=ALTERACAO
   cod_sos=7
   EDIT()

  CASE op_cad=02                                   // consulta
   op_menu=PROJECOES
   cod_sos=8
   EDITA(3,3,MAXROW()-2,77)

  CASE op_cad=03                                   // consulta
   ADp_R076(5,18)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC CGR_incl     // inclusao no arquivo CGRUPOS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, tem_borda, criterio:="", cpord:=""
cond_incl_={||1=1}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 ALERTA(2)                                         // avisa o motivo
 DBOX("Arquivo para contratos Cancelados!!!",,,4,,"ATEN€ŽO, "+usuario)
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
DO WHIL cabem>0
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE CGRUPOS
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
 CGR_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/CGRUPOS->(RECSIZE()))
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
 @ l_s+01 ,c_s+16 GET  numero;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE CGRUPOS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->numero
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  IMPRELA()
  CGR_GETS()                                       // mostra conteudo do registro
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
 CGR_GET1(INCLUI)                                  // recebe campos
 SELE CGRUPOS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->numero                                   // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   CGR_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE CGRUPOS
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
 SUBNIVEL("COECOB")
 SUBNIVEL("CINSCRIT")
 SUBNIVEL("CTAXAS")
ENDD
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC CGR_tela     // tela do arquivo CGRUPOS
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
@ l_s+01,c_s+1 SAY " Cancelamento:         C¢digo:           Motivo:"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Reintegra‡„o:         Motivo:"
@ l_s+04,c_s+1 SAY " Sob C¢digo..:"
@ l_s+05,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+06,c_s+1 SAY "                                                 Situa‡„o:"
@ l_s+07,c_s+1 SAY "  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Dados Pessoais ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+08,c_s+1 SAY " Nome..:                                     Nasc.:"
@ l_s+09,c_s+1 SAY " ECivil:                  CIC:               RG...:"
@ l_s+10,c_s+1 SAY " Ender.:                                     Bairr:"
@ l_s+11,c_s+1 SAY " Cidade:                                           (        -          )"
@ l_s+12,c_s+1 SAY " Contato                                            Cad. em"
@ l_s+13,c_s+1 SAY " Categor.:                  Carnˆ:              FormaPgto.:"
@ l_s+14,c_s+1 SAY " Admiss„o:             T.Carˆncia:              Sai Taxas.:"
@ l_s+15,c_s+1 SAY " Vendedor:"
@ l_s+16,c_s+1 SAY " Regi„o..:                                      Observa‡„o:"
@ l_s+17,c_s+1 SAY " Cobrador:                                      Renova‡„o.:"
@ l_s+18,c_s+1 SAY " Funerais:       Circ.Inic:       Ult.:       Emit:      Baix:"
@ l_s+19,c_s+1 SAY " Participantes: Vivos:    Falecidos:    Dependentes:"
RETU

PROC CGR_gets     // mostra variaveis do arquivo CGRUPOS
LOCAL getlist := {}, t_f7_
CGR_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(NUMERO,'CANCELS',1)
PTAB('',[ARQGRUP],1)
PTAB(TIPCONT,'CLASSES',1)
PTAB(VENDEDOR,'COBRADOR',1)
PTAB(REGIAO,'REGIAO',1)
PTAB(COBRADOR,'COBRADOR',1)
PTAB(IIF(CLASSES->PRIOR=[S],M->MGRUPVIP,GRUPO)+ULTCIRC,'CIRCULAR',1)
CRIT("",,"2|3|5|8|9|10|11|12")
@ l_s+01 ,c_s+16 GET  numero;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+32 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]

@ l_s+01 ,c_s+50 GET  motivo

@ l_s+02 ,c_s+50 GET  canclto_;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+02 ,c_s+62 GET  cancpor

@ l_s+03 ,c_s+16 GET  reintnum;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+03 ,c_s+32 GET  motreint;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+04 ,c_s+53 GET  reintem_;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+04 ,c_s+62 GET  reintpor

@ l_s+04 ,c_s+16 GET  codreint;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+06 ,c_s+60 GET  situacao;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,12,O_CRIT],,"1")

@ l_s+08 ,c_s+10 GET  nome

@ l_s+08 ,c_s+53 GET  nascto_;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+09 ,c_s+10 GET  estcivil;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,15,O_CRIT],,"7")

@ l_s+09 ,c_s+31 GET  cpf;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+09 ,c_s+53 GET  rg;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+10 ,c_s+10 GET  endereco

@ l_s+10 ,c_s+53 GET  bairro

@ l_s+11 ,c_s+10 GET  cidade

@ l_s+11 ,c_s+36 GET  uf;
                 PICT sistema[op_sis,O_CAMPO,21,O_MASC]

@ l_s+11 ,c_s+39 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,22,O_MASC]

@ l_s+12 ,c_s+10 GET  contato;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+12 ,c_s+36 GET  telefone;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

@ l_s+13 ,c_s+12 GET  tipcont;
                 PICT sistema[op_sis,O_CAMPO,25,O_MASC]

@ l_s+13 ,c_s+36 GET  vlcarne

@ l_s+13 ,c_s+61 GET  formapgto;
                 PICT sistema[op_sis,O_CAMPO,27,O_MASC]

@ l_s+14 ,c_s+12 GET  admissao;
                 PICT sistema[op_sis,O_CAMPO,29,O_MASC]

@ l_s+14 ,c_s+36 GET  tcarencia;
                 PICT sistema[op_sis,O_CAMPO,30,O_MASC]

@ l_s+14 ,c_s+61 GET  saitxa;
                 PICT sistema[op_sis,O_CAMPO,31,O_MASC]

@ l_s+15 ,c_s+12 GET  vendedor;
                 PICT sistema[op_sis,O_CAMPO,32,O_MASC]

@ l_s+16 ,c_s+12 GET  regiao;
                 PICT sistema[op_sis,O_CAMPO,33,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,33,O_CRIT],,"6")

@ l_s+17 ,c_s+12 GET  cobrador;
                 PICT sistema[op_sis,O_CAMPO,34,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,34,O_CRIT],,"4")

@ l_s+16 ,c_s+61 SAY "{M} "

@ l_s+17 ,c_s+61 GET  renovar;
                 PICT sistema[op_sis,O_CAMPO,36,O_MASC]

@ l_s+18 ,c_s+12 GET  funerais;
                 PICT sistema[op_sis,O_CAMPO,37,O_MASC]

@ l_s+18 ,c_s+29 GET  circinic;
                 PICT sistema[op_sis,O_CAMPO,38,O_MASC]

@ l_s+18 ,c_s+41 GET  ultcirc;
                 PICT sistema[op_sis,O_CAMPO,39,O_MASC]

@ l_s+18 ,c_s+53 GET  qtcircs;
                 PICT sistema[op_sis,O_CAMPO,40,O_MASC]

@ l_s+18 ,c_s+64 GET  qtcircpg;
                 PICT sistema[op_sis,O_CAMPO,41,O_MASC]

CLEAR GETS
RETU

PROC CGR_get1     // capta variaveis do arquivo CGRUPOS
LOCAL getlist := {}, t_f7_
PRIV  blk_cgrupos:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  memo35:="{F7}"
  t_f7_=SETKEY(K_F7,{||CGR_memo()})
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+02 ,c_s+50 GET canclto_;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
  @ l_s+03 ,c_s+16 GET reintnum;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
  @ l_s+03 ,c_s+32 GET motreint;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
  @ l_s+04 ,c_s+53 GET reintem_;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
  @ l_s+04 ,c_s+62 GET reintpor
  @ l_s+04 ,c_s+16 GET codreint;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
  CLEA GETS
  CRIT("",,"2|3|5|8|9|10|11|12")
  @ l_s+01 ,c_s+32 GET  codigo;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2

  @ l_s+01 ,c_s+50 GET  motivo
                   DEFINICAO 4

  @ l_s+01 ,c_s+62 GET  cancpor
                   DEFINICAO 6

  @ l_s+06 ,c_s+60 GET  situacao;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+08 ,c_s+10 GET  nome
                   DEFINICAO 13

  @ l_s+08 ,c_s+53 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+09 ,c_s+10 GET  estcivil;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15
                   MOSTRA sistema[op_sis,O_FORMULA,7]

  @ l_s+09 ,c_s+31 GET  cpf;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16

  @ l_s+09 ,c_s+53 GET  rg;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                   DEFINICAO 17

  @ l_s+10 ,c_s+10 GET  endereco
                   DEFINICAO 18

  @ l_s+10 ,c_s+53 GET  bairro
                   DEFINICAO 19

  @ l_s+11 ,c_s+10 GET  cidade
                   DEFINICAO 20

  @ l_s+11 ,c_s+36 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,21,O_MASC]
                   DEFINICAO 21

  @ l_s+11 ,c_s+39 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                   DEFINICAO 22

  @ l_s+12 ,c_s+10 GET  contato;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                   DEFINICAO 23

  @ l_s+12 ,c_s+36 GET  telefone;
                   PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                   DEFINICAO 24

  @ l_s+13 ,c_s+12 GET  tipcont;
                   PICT sistema[op_sis,O_CAMPO,25,O_MASC]
                   DEFINICAO 25

  @ l_s+13 ,c_s+36 GET  vlcarne
                   DEFINICAO 26

  @ l_s+13 ,c_s+61 GET  formapgto;
                   PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                   DEFINICAO 27

  @ l_s+14 ,c_s+12 GET  admissao;
                   PICT sistema[op_sis,O_CAMPO,29,O_MASC]
                   DEFINICAO 29

  @ l_s+14 ,c_s+36 GET  tcarencia;
                   PICT sistema[op_sis,O_CAMPO,30,O_MASC]
                   DEFINICAO 30

  @ l_s+14 ,c_s+61 GET  saitxa;
                   PICT sistema[op_sis,O_CAMPO,31,O_MASC]
                   DEFINICAO 31

  @ l_s+15 ,c_s+12 GET  vendedor;
                   PICT sistema[op_sis,O_CAMPO,32,O_MASC]
                   DEFINICAO 32

  @ l_s+16 ,c_s+12 GET  regiao;
                   PICT sistema[op_sis,O_CAMPO,33,O_MASC]
                   DEFINICAO 33
                   MOSTRA sistema[op_sis,O_FORMULA,6]

  @ l_s+17 ,c_s+12 GET  cobrador;
                   PICT sistema[op_sis,O_CAMPO,34,O_MASC]
                   DEFINICAO 34
                   MOSTRA sistema[op_sis,O_FORMULA,4]

  @ l_s+16 ,c_s+61 GET  memo35;
                   PICT "@!"
                   DEFINICAO 35

  @ l_s+17 ,c_s+61 GET  renovar;
                   PICT sistema[op_sis,O_CAMPO,36,O_MASC]
                   DEFINICAO 36

  @ l_s+18 ,c_s+12 GET  funerais;
                   PICT sistema[op_sis,O_CAMPO,37,O_MASC]
                   DEFINICAO 37

  @ l_s+18 ,c_s+29 GET  circinic;
                   PICT sistema[op_sis,O_CAMPO,38,O_MASC]
                   DEFINICAO 38

  @ l_s+18 ,c_s+41 GET  ultcirc;
                   PICT sistema[op_sis,O_CAMPO,39,O_MASC]
                   DEFINICAO 39

  @ l_s+18 ,c_s+53 GET  qtcircs;
                   PICT sistema[op_sis,O_CAMPO,40,O_MASC]
                   DEFINICAO 40

  @ l_s+18 ,c_s+64 GET  qtcircpg;
                   PICT sistema[op_sis,O_CAMPO,41,O_MASC]
                   DEFINICAO 41

  READ
  SETKEY(K_F7,t_f7_)
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
 INTREF(FORM_INVERSA)
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF op_menu!=INCLUSAO
  RECA
  INTREF(FORM_DIRETA)
 ENDI
ENDI
RETU

PROC CGR_MEMO
IF READVAR()="MEMO35"
 EDIMEMO("obs",sistema[op_sis,O_CAMPO,35,O_TITU],4,2,13,37)
ENDI
RETU

PROC COE_incl     // inclusao no arquivo COECOB
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"COECOB")
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
DO WHIL cabem>0
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE COECOB
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
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 COE_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/COECOB->(RECSIZE()))
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
 @ l_s+01 ,c_s+12 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2
                  MOSTRA sistema[op_sis,O_FORMULA,1]

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE COECOB
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->numero+M->tipo
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  COE_GETS()                                       // mostra conteudo do registro
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
 COE_GET1(INCLUI)                                  // recebe campos
 SELE COECOB
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->numero+M->tipo                           // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   COE_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE COECOB
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
ENDD
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC COE_tela     // tela do arquivo COECOB
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
@ l_s+01,c_s+1 SAY " Tipo....:"
@ l_s+02,c_s+1 SAY " Endere‡o:"
@ l_s+03,c_s+1 SAY " Bairro..:"
@ l_s+04,c_s+1 SAY " CEP.....:"
@ l_s+05,c_s+1 SAY " Cidade..:                            Est.:"
@ l_s+06,c_s+1 SAY " Telefone:"
@ l_s+07,c_s+1 SAY " Obs.....:"
RETU

PROC COE_gets     // mostra variaveis do arquivo COECOB
LOCAL getlist := {}
COE_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
@ l_s+01 ,c_s+12 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1")

@ l_s+02 ,c_s+12 GET  endereco;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+03 ,c_s+12 GET  bairro;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+04 ,c_s+12 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+05 ,c_s+12 GET  cidade;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+05 ,c_s+45 GET  uf;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+06 ,c_s+12 GET  telefone;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+07 ,c_s+12 GET  obs

CLEAR GETS
RETU

PROC COE_get1     // capta variaveis do arquivo COECOB
LOCAL getlist := {}
PRIV  blk_coecob:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+02 ,c_s+12 GET  endereco;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3

  @ l_s+03 ,c_s+12 GET  bairro;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+04 ,c_s+12 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+05 ,c_s+12 GET  cidade;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+05 ,c_s+45 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+06 ,c_s+12 GET  telefone;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+07 ,c_s+12 GET  obs
                   DEFINICAO 9

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
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (CGRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"CGRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
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

PROC CIN_incl     // inclusao no arquivo CINSCRIT
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 IF op_menu!=INCLUSAO                              // nao inclusao nao tem msg
  ALERTA(2)                                        // avisa o motivo
  DBOX("Contrato Cancelado!!!",,,4,,"ATEN€ŽO, "+usuario)
 ENDI
 RETU                                              // e retorna
ENDI
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"CINSCRIT")
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
DO WHIL cabem>0
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE CINSCRIT
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
 DISPBEGIN()                                       // apresenta a tela de uma vez so
 CIN_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 IF !EVAL(cond_incl_)
  EXIT
 ENDI
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/CINSCRIT->(RECSIZE()))
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
 @ l_s+01 ,c_s+17 GET  grau;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                  DEFINICAO 3
                  MOSTRA sistema[op_sis,O_FORMULA,1]

 @ l_s+01 ,c_s+29 GET  seq;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                  DEFINICAO 4

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE CINSCRIT
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->numero+M->grau+STR(M->seq,02,00)
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  CIN_GETS()                                       // mostra conteudo do registro
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
 CIN_GET1(INCLUI)                                  // recebe campos
 SELE CINSCRIT
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->numero+M->grau+STR(M->seq,02,00)         // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   CIN_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE CINSCRIT
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
ENDD
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC CIN_tela     // tela do arquivo CINSCRIT
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
@ l_s+01,c_s+1 SAY "         Inscr:        Seq:       titular?:     (                   )"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY " Nome......:                                      Nascimento.:"
@ l_s+04,c_s+1 SAY " Est.Civil.:     Interdito:            Sexo:      T.Carˆncia.:"
@ l_s+05,c_s+1 SAY " Vivo/Falec:     Falecto..:            Tipo:      N§ Processo:"
RETU

PROC CIN_gets     // mostra variaveis do arquivo CINSCRIT
LOCAL getlist := {}, tl_item_
CIN_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CRIT("",,"2|3|4")
@ l_s+01 ,c_s+17 GET  grau;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1")

@ l_s+01 ,c_s+29 GET  seq;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+01 ,c_s+46 GET  ehtitular;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+03 ,c_s+14 GET  nome

@ l_s+03 ,c_s+64 GET  nascto_;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+04 ,c_s+14 GET  estcivil

@ l_s+04 ,c_s+29 GET  interdito;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+04 ,c_s+46 GET  sexo;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+04 ,c_s+64 GET  tcarencia;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+05 ,c_s+14 GET  vivofalec;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+05 ,c_s+29 GET  falecto_;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+05 ,c_s+46 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+05 ,c_s+64 GET  procnr;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

CLEAR GETS
RETU

PROC CIN_get1     // capta variaveis do arquivo CINSCRIT
LOCAL getlist := {}, tl_item_
PRIV  blk_cinscrit:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3|4")
  @ l_s+01 ,c_s+46 GET  ehtitular;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+03 ,c_s+14 GET  nome
                   DEFINICAO 6

  @ l_s+03 ,c_s+64 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+04 ,c_s+14 GET  estcivil
                   DEFINICAO 8

  @ l_s+04 ,c_s+29 GET  interdito;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+04 ,c_s+46 GET  sexo;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+04 ,c_s+64 GET  tcarencia;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11

  @ l_s+05 ,c_s+14 GET  vivofalec;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13

  @ l_s+05 ,c_s+29 GET  falecto_;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+05 ,c_s+46 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15

  @ l_s+05 ,c_s+64 GET  procnr;
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
 IF op_menu!=PROJECOES
  REIMPTEL()
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (CGRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"CGRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
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
   IF (tp_mov=INCLUI .OR. tp_mov=RECUPERA) .AND. op_menu!=PROJECOES
    REIMPTEL()
   ENDI
  ENDI
 ENDI
ENDI
RETU

PROC CTA_incl     // inclusao no arquivo CTAXAS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(), cond_incl_,;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
cond_incl_={||1=3}                                 // condicao de inclusao de registros
IF !EVAL(cond_incl_)                               // se nao pode incluir
 IF op_menu!=INCLUSAO                              // nao inclusao nao tem msg
  ALERTA(2)                                        // avisa o motivo
  DBOX("Contrato Cancelado",,,4,,"ATEN€ŽO, "+usuario)
 ENDI
 RETU                                              // e retorna
ENDI
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"CTAXAS")
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
CTA_TELA()                                         // imp tela para inclusao
INFOSIS()                                          // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE CTAXAS
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
 cabem=INT((cabem-2048)/CTAXAS->(RECSIZE()))
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
 @ l_s+l_a,c_s+08 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                  DEFINICAO 3

 @ l_s+l_a,c_s+12 GET  circ;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                  DEFINICAO 4

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE CTAXAS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->numero+M->tipo+M->circ
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  CTA_GETS()                                       // mostra conteudo do registro
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
  CTA_TELA()
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 CTA_GET1(INCLUI)                                  // recebe campos
 SELE CTAXAS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n„o inclu¡do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->numero+M->tipo+M->circ                   // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   CTA_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu¡do por outro usu rio!"
   DBOX(msg,,,,,"ATEN€ŽO!")                        // avisa
   SELE CTAXAS
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
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+08,l_max-1,c_s+08,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+12,l_max-1,c_s+14,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+16,l_max-1,c_s+25,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+25,l_max-1,c_s+34,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+36,l_max-1,c_s+45,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+45,l_max-1,c_s+54,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+56,l_max-1,c_s+58,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+59,l_max-1,c_s+59,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+72,l_max-1,c_s+72,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+61,l_max-1,c_s+70,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+01,l_max-1,c_s+06,1)
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

PROC CTA_tela     // tela do arquivo CTAXAS
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
@ l_s+01,c_s+1 SAY "      Tip  N§  Emissao      Valor ³ Pagto   Valor Pago Cb F por       Stat"
@ l_s+02,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+03,c_s+1 SAY "                                  ³"
@ l_s+04,c_s+1 SAY "                                  ³"
@ l_s+05,c_s+1 SAY "                                  ³"
@ l_s+06,c_s+1 SAY "                                  ³"
@ l_s+07,c_s+1 SAY "                                  ³"
@ l_s+08,c_s+1 SAY "                                  ³"
@ l_s+09,c_s+1 SAY "                                  ³"
RETU

PROC CTA_gets     // mostra variaveis do arquivo CTAXAS
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
CTA_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 CRIT("",,"1|2|3")
 @ l_s+l_a,c_s+08 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+l_a,c_s+12 GET  circ;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+l_a,c_s+16 GET  emissao_;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+l_a,c_s+26 GET  valor;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]

 @ l_s+l_a,c_s+36 GET  pgto_;
                  PICT sistema[op_sis,O_CAMPO,07,O_MASC]

 @ l_s+l_a,c_s+46 GET  valorpg;
                  PICT sistema[op_sis,O_CAMPO,08,O_MASC]

 @ l_s+l_a,c_s+56 GET  cobrador;
                  PICT sistema[op_sis,O_CAMPO,09,O_MASC]

 @ l_s+l_a,c_s+59 GET  forma;
                  PICT sistema[op_sis,O_CAMPO,10,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC CTA_get1     // capta variaveis do arquivo CTAXAS
LOCAL getlist := {}
PRIV  blk_ctaxas:=.t.
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
  CRIT("",,"1|2|3")
  @ l_s+l_a,c_s+16 GET  emissao_;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+l_a,c_s+25 GET  valor;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+l_a,c_s+36 GET  pgto_;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+l_a,c_s+45 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+l_a,c_s+56 GET  cobrador;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+l_a,c_s+59 GET  forma;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

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
PTAB(COBRADOR,'COBRADOR',1)
PTAB(CGRUPOS->GRUPO+CIRC,'CIRCULAR',1)
PTAB(COBRADOR+CIRCULAR->MESREF,'FCCOB',1)
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
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (CGRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"CGRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu¡do em:"+msg+"|*",,,,,"IMPOSS¡VEL RECUPERAR!")
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

* \\ Final de CGRUPOS.PRG

FUNC CGR_02F9()

SELE CGRUPOS
GO BOTT
rcodin:=sTRzero(VAL(numero)+1,6,0)
//POINTER_DBF(reg_dbf)

RETU M->rcodin       // <- deve retornar um valor qualquer
