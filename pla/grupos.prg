procedure grupos

/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: GRUPOS.PRG
 \ Data....: 18-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de contratos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"GRUPOS")
IF nivelop<sistema[op_sis,O_OUTROS,O_NIVEL]        // se usuario nao tem permissao,
 ALERTA()                                          // entao, beep, beep, beep
 DBOX(msg_auto,,,3)                                // lamentamos e
 RETU                                              // retornamos ao menu
ENDI

IF EMPT(M->usuario)        // se usuario nao tem identificacao (Nome),
 ALERTA()                                          // entao, beep, beep, beep
 DBOX([Falta Identificacao do usuario (Nome)|Atualize o cadastro de senhas],,,3)                                // lamentamos e
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
		 "Consulta Contratos|"+;
		 "Consulta Inscritos|"+;
		 "Consulta Taxas|"+;
     "Contratos e Taxas"
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
		GRU_INCL()                                     // neste arquivo chama prg de inclusao
	 ELSE                                            // caso contrario vamos avisar que
		ALERTA()                                       // ele nao tem permissao para isto
		DBOX(msg_auto,,,3)
	 ENDI

	CASE op_cad=02                                   // manuten��o
	 SET KEY K_F2 TO menu2gru()                      // habilita consulta em outros arquivos
	 SET KEY K_CTRL_P TO imp_r041
	 op_menu=ALTERACAO
	 cod_sos=7
	 EDIT()
	 SET KEY K_CTRL_P TO
	 SET KEY K_F2 TO                                 // habilita consulta em outros arquivos

	CASE op_cad=03                                   // consulta
	 SET KEY K_F2 TO menu2gru()                      // habilita consulta em outros arquivos
	 SET KEY K_CTRL_P TO imp_r041
	 op_menu=PROJECOES
	 cod_sos=8
	 EDITA(3,3,MAXROW()-2,77)
	 SET KEY K_CTRL_P TO
	 SET KEY K_F2 TO                                 // habilita consulta em outros arquivos

	CASE op_cad=04                                   // consulta inscritos
	 cod_sos=8
	 CTAINSC()

  CASE op_cad=05                                   // consulta taxas
   cod_sos=8
   CTXAS()

  CASE op_cad=06                                   // consulta taxas
   cod_sos=8
   CGTAX()

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
 CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RETU

PROC GRU_incl     // inclusao no arquivo GRUPOS
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
 SELE GRUPOS
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
 GRU_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/GRUPOS->(RECSIZE()))
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
 @ l_s+01 ,c_s+10 GET  codigo;
                  PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                  DEFINICAO 1

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE GRUPOS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
	IMPRELA()
  GRU_GETS()                                       // mostra conteudo do registro
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
 GRU_GET1(INCLUI)                                  // recebe campos
 SELE GRUPOS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo                                   // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   GRU_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE GRUPOS
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
 SUBNIVEL("ECOB")
 SUBNIVEL("INSCRITS")
 IF op_menu=INCLUSAO
	MENU2GRU()
 ENDI
 SUBNIVEL("TAXAS")

ENDD
GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC GRU_tela     // tela do arquivo GRUPOS
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
@ l_s+01,c_s+1 SAY " Codigo:                                         Situa��o:"
@ l_s+02,c_s+1 SAY "  ���������������������������� Dados Pessoais �������������������������"
@ l_s+03,c_s+1 SAY " Nome..:                                     Nasc.:"
@ l_s+04,c_s+1 SAY " ECivil:                  CIC:               RG...:"
@ l_s+05,c_s+1 SAY " Ender.:                                     Bairr:"
@ l_s+06,c_s+1 SAY " Cidade:                           UF.:      CEP..:"
@ l_s+07,c_s+1 SAY " Natur.:                           Relig:"
@ l_s+08,c_s+1 SAY " Contato                           Tel:"
@ l_s+09,c_s+1 SAY " Categor.:     Carn�:      F.Pgto:"
@ l_s+10,c_s+1 SAY " Admiss�o:             T.Car�ncia:              Sai Taxas.:"
@ l_s+11,c_s+1 SAY " Vendedor:                                      Dia Pgto..:"
@ l_s+12,c_s+1 SAY " Regi�o..:                                      Observa��o:"
@ l_s+13,c_s+1 SAY " Cobrador:                                      Renova��o.:"
@ l_s+14,c_s+1 SAY " Funerais:       Circ.Inic:       Ult.:        Emit:      Baix:"
@ l_s+15,c_s+1 SAY " Participantes: Vivos:    Falecidos:    Dependentes:"
@ l_s+16,c_s+1 SAY " Ult.Altera��o:         -               Lancto.:"
RETU

PROC GRU_gets     // mostra variaveis do arquivo GRUPOS
LOCAL getlist := {}, t_f7_
GRU_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB('',[ARQGRUP],1)
PTAB(TIPCONT,'CLASSES',1)
PTAB(REGIAO,'REGIAO',1)
PTAB(IIF(CLASSES->PRIOR=[S],M->MGRUPVIP,GRUPO)+ULTCIRC,'CIRCULAR',1)
CRIT("",,"2|3|6|9|10|11|12|13")
@ l_s+01 ,c_s+10 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+01 ,c_s+60 GET  situacao;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"1")

@ l_s+03 ,c_s+10 GET  nome;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]

@ l_s+03 ,c_s+53 GET  nascto_;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"16")

@ l_s+04 ,c_s+10 GET  estcivil;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"8")

@ l_s+04 ,c_s+31 GET  cpf;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+04 ,c_s+53 GET  rg;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

@ l_s+05 ,c_s+10 GET  endereco;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+05 ,c_s+53 GET  bairro;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+06 ,c_s+10 GET  cidade;
                 PICT sistema[op_sis,O_CAMPO,11,O_MASC]

@ l_s+06 ,c_s+41 GET  uf;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+06 ,c_s+53 GET  cep;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+07 ,c_s+10 GET  natural;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+07 ,c_s+43 GET  relig;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

@ l_s+08 ,c_s+10 GET  contato;
                 PICT sistema[op_sis,O_CAMPO,16,O_MASC]

@ l_s+08 ,c_s+41 GET  telefone;
                 PICT sistema[op_sis,O_CAMPO,17,O_MASC]

@ l_s+09 ,c_s+12 GET  tipcont;
                 PICT sistema[op_sis,O_CAMPO,18,O_MASC]

@ l_s+09 ,c_s+23 GET  vlcarne

@ l_s+09 ,c_s+36 GET  formapgto;
                 PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,20,O_CRIT],,"15")

@ l_s+10 ,c_s+12 GET  admissao;
                 PICT sistema[op_sis,O_CAMPO,22,O_MASC]

@ l_s+10 ,c_s+36 GET  tcarencia;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+10 ,c_s+61 GET  saitxa;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

@ l_s+11 ,c_s+61 GET  diapgto;
                 PICT sistema[op_sis,O_CAMPO,25,O_MASC]

@ l_s+11 ,c_s+12 GET  vendedor;
                 PICT sistema[op_sis,O_CAMPO,26,O_MASC]

@ l_s+12 ,c_s+12 GET  regiao;
                 PICT sistema[op_sis,O_CAMPO,27,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,27,O_CRIT],,"7")

@ l_s+13 ,c_s+12 GET  cobrador;
                 PICT sistema[op_sis,O_CAMPO,28,O_MASC]

@ l_s+12 ,c_s+61 SAY "{M} "

@ l_s+13 ,c_s+61 GET  renovar;
                 PICT sistema[op_sis,O_CAMPO,30,O_MASC]

@ l_s+14 ,c_s+12 GET  funerais;
                 PICT sistema[op_sis,O_CAMPO,31,O_MASC]

@ l_s+14 ,c_s+29 GET  circinic;
                 PICT sistema[op_sis,O_CAMPO,32,O_MASC]

@ l_s+14 ,c_s+41 GET  ultcirc;
                 PICT sistema[op_sis,O_CAMPO,33,O_MASC]

@ l_s+14 ,c_s+54 GET  qtcircs;
                 PICT sistema[op_sis,O_CAMPO,34,O_MASC]

@ l_s+14 ,c_s+65 GET  qtcircpg;
                 PICT sistema[op_sis,O_CAMPO,35,O_MASC]

CRIT("",,"4|5")
CLEAR GETS
RETU

PROC GRU_get1     // capta variaveis do arquivo GRUPOS
LOCAL getlist := {}, t_f7_
PRIV  blk_grupos:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  memo29:="{F7}"
  t_f7_=SETKEY(K_F7,{||GRU_memo()})
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3|6|9|10|11|12|13")
  if nivelop=3
   @ l_s+01 ,c_s+18 GET  grupo;
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                   DEFINICAO 2
  endi
  @ l_s+01 ,c_s+60 GET  situacao;
                   PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                   DEFINICAO 3
                   MOSTRA sistema[op_sis,O_FORMULA,1]

  @ l_s+03 ,c_s+10 GET  nome;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+03 ,c_s+53 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5
                   MOSTRA sistema[op_sis,O_FORMULA,16]

  @ l_s+04 ,c_s+10 GET  estcivil;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6
                   MOSTRA sistema[op_sis,O_FORMULA,8]

  @ l_s+04 ,c_s+31 GET  cpf;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+04 ,c_s+53 GET  rg;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+05 ,c_s+10 GET  endereco;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+05 ,c_s+53 GET  bairro;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+06 ,c_s+10 GET  cidade;
                   PICT sistema[op_sis,O_CAMPO,11,O_MASC]
                   DEFINICAO 11

  @ l_s+06 ,c_s+41 GET  uf;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+06 ,c_s+53 GET  cep;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13

  @ l_s+07 ,c_s+10 GET  natural;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+07 ,c_s+43 GET  relig;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15

  @ l_s+08 ,c_s+10 GET  contato;
                   PICT sistema[op_sis,O_CAMPO,16,O_MASC]
                   DEFINICAO 16

  @ l_s+08 ,c_s+41 GET  telefone;
                   PICT sistema[op_sis,O_CAMPO,17,O_MASC]
                   DEFINICAO 17

  @ l_s+09 ,c_s+12 GET  tipcont;
                   PICT sistema[op_sis,O_CAMPO,18,O_MASC]
                   DEFINICAO 18

  @ l_s+09 ,c_s+23 GET  vlcarne
                   DEFINICAO 19

  @ l_s+09 ,c_s+36 GET  formapgto;
                   PICT sistema[op_sis,O_CAMPO,20,O_MASC]
                   DEFINICAO 20
                   MOSTRA sistema[op_sis,O_FORMULA,15]

  @ l_s+10 ,c_s+12 GET  admissao;
                   PICT sistema[op_sis,O_CAMPO,22,O_MASC]
                   DEFINICAO 22

  @ l_s+10 ,c_s+36 GET  tcarencia;
                   PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                   DEFINICAO 23

  @ l_s+10 ,c_s+61 GET  saitxa;
                   PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                   DEFINICAO 24

  @ l_s+11 ,c_s+61 GET  diapgto;
                   PICT sistema[op_sis,O_CAMPO,25,O_MASC]
                   DEFINICAO 25

  @ l_s+11 ,c_s+12 GET  vendedor;
                   PICT sistema[op_sis,O_CAMPO,26,O_MASC]
                   DEFINICAO 26
									 MOSTRA sistema[op_sis,O_FORMULA,05]

	@ l_s+12 ,c_s+12 GET  regiao;
									 PICT sistema[op_sis,O_CAMPO,27,O_MASC]
									 DEFINICAO 27
									 MOSTRA sistema[op_sis,O_FORMULA,7]

	@ l_s+13 ,c_s+12 GET  cobrador;
									 PICT sistema[op_sis,O_CAMPO,28,O_MASC]
									 DEFINICAO 28
									 MOSTRA sistema[op_sis,O_FORMULA,04]

	@ l_s+12 ,c_s+61 GET  memo29;
                   PICT "@!"
                   DEFINICAO 29

  @ l_s+13 ,c_s+61 GET  renovar;
                   PICT sistema[op_sis,O_CAMPO,30,O_MASC]
                   DEFINICAO 30

  @ l_s+14 ,c_s+12 GET  funerais;
                   PICT sistema[op_sis,O_CAMPO,31,O_MASC]
                   DEFINICAO 31

  @ l_s+14 ,c_s+29 GET  circinic;
                   PICT sistema[op_sis,O_CAMPO,32,O_MASC]
                   DEFINICAO 32

  @ l_s+14 ,c_s+41 GET  ultcirc;
                   PICT sistema[op_sis,O_CAMPO,33,O_MASC]
                   DEFINICAO 33

  @ l_s+14 ,c_s+54 GET  qtcircs;
                   PICT sistema[op_sis,O_CAMPO,34,O_MASC]
                   DEFINICAO 34

  @ l_s+14 ,c_s+65 GET  qtcircpg;
                   PICT sistema[op_sis,O_CAMPO,35,O_MASC]
                   DEFINICAO 35

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
PTAB('',[ARQGRUP],1)
PTAB(TIPCONT,'CLASSES',1)
PTAB(REGIAO,'REGIAO',1)
PTAB(GRUPO+ULTCIRC,'CIRCULAR',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA

 #ifdef COM_REDE
  REPBLO('ARQGRUP->contrat',{||ARQGRUP->contrat - 1})
 #else
  REPL ARQGRUP->contrat WITH ARQGRUP->contrat - 1
 #endi

 INTREF(FORM_INVERSA)
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO

  #ifdef COM_REDE
   REPBLO('ARQGRUP->contrat',{||ARQGRUP->contrat + 1})
   IF op_menu=INCLUSAO
    ender_=DATE()
    ultend=M->usuario
    if empt(ultimp_)
     ultimp_=DATE()
     por=M->usuario
    endi
   ELSE
    REPL ender_ WITH DATE(),;
         ultend WITH M->usuario
    if empt(ultimp_)
     REPL ultimp_ WITH DATE(),;
          por WITH M->usuario
    endi
   ENDI
  #else
   REPL ARQGRUP->contrat WITH ARQGRUP->contrat + 1
   IF op_menu=INCLUSAO
    ender_=DATE()
    ultend=M->usuario
    if empt(ultimp_)
     ultimp_=DATE()
     por=M->usuario
    endi
   ELSE
    REPL ender_ WITH DATE(),;
         ultend WITH M->usuario
    if empt(ultimp_)
     REPL ultimp_ WITH DATE(),;
      por WITH M->usuario
    endi
   ENDI
  #endi

  IF op_menu!=INCLUSAO
   RECA
   INTREF(FORM_DIRETA)
  ENDI
 ENDI
ENDI
RETU

PROC GRU_MEMO
IF READVAR()="MEMO29"
 EDIMEMO("obs",sistema[op_sis,O_CAMPO,29,O_TITU],14,2,23,62)
ENDI
RETU

PROC ECO_incl     // inclusao no arquivo ECOB
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"ECOB")
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
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE ECOB
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
 ECO_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/ECOB->(RECSIZE()))
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
 SELE ECOB
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo+M->tipo
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  ECO_GETS()                                       // mostra conteudo do registro
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
 ECO_GET1(INCLUI)                                  // recebe campos
 SELE ECOB
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo+M->tipo                           // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   ECO_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE ECOB
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

PROC ECO_tela     // tela do arquivo ECOB
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
@ l_s+02,c_s+1 SAY " Endere�o:"
@ l_s+03,c_s+1 SAY " Bairro..:"
@ l_s+04,c_s+1 SAY " CEP.....:"
@ l_s+05,c_s+1 SAY " Cidade..:                            Est.:"
@ l_s+06,c_s+1 SAY " Telefone:"
@ l_s+07,c_s+1 SAY " Obs.....:"
RETU

PROC ECO_gets     // mostra variaveis do arquivo ECOB
LOCAL getlist := {}
ECO_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CRIT("",,"2")
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

@ l_s+07 ,c_s+12 GET  obs;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

CLEAR GETS
RETU

PROC ECO_get1     // capta variaveis do arquivo ECOB
LOCAL getlist := {}
PRIV  blk_ecob:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2")
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

  @ l_s+07 ,c_s+12 GET  obs;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
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
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (GRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"GRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu�do em:"+msg+"|*",,,,,"IMPOSS�VEL RECUPERAR!")
  ELSE
    IF op_menu=INCLUSAO
     data_=DATE()
    ELSE
     REPL data_ WITH DATE()
    ENDI
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

PROC INS_incl     // inclusao no arquivo INSCRITS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f3_, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:=""
op_sis=EVAL(qualsis,"INSCRITS")
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
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE INSCRITS
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
 INS_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/INSCRITS->(RECSIZE()))
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
 @ l_s+01 ,c_s+09 GET  grau;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2
                  MOSTRA sistema[op_sis,O_FORMULA,1]

 @ l_s+01 ,c_s+10 GET  seq;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                  DEFINICAO 3

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE INSCRITS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo+M->grau+STR(M->seq,02,00)
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  INS_GETS()                                       // mostra conteudo do registro
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
 INS_GET1(INCLUI)                                  // recebe campos
 SELE INSCRITS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo+M->grau+STR(M->seq,02,00)         // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   INS_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE INSCRITS
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

PROC INS_tela     // tela do arquivo INSCRITS
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
@ l_s+01,c_s+1 SAY " Inscr:                                        (                       )"
@ l_s+02,c_s+1 SAY "������������������������������������������������������������������������"
@ l_s+03,c_s+1 SAY " Nome:                                     Nasc.:"
@ l_s+04,c_s+1 SAY " Est.Civil.:     Sexo.....:          T.Car�ncia.:"
@ l_s+05,c_s+1 SAY " Vivo/Falec:     Falecto..:            Tipo:      N� Processo:"
RETU

PROC INS_gets     // mostra variaveis do arquivo INSCRITS
LOCAL getlist := {}, tl_item_
INS_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CRIT("",,"2|3")
@ l_s+01 ,c_s+09 GET  grau;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1")

@ l_s+01 ,c_s+10 GET  seq;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]

@ l_s+03 ,c_s+08 GET  nome;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]

@ l_s+03 ,c_s+51 GET  nascto_;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,06,O_CRIT],,"4")

@ l_s+04 ,c_s+14 GET  estcivil

@ l_s+04 ,c_s+33 GET  sexo;
                 PICT sistema[op_sis,O_CAMPO,09,O_MASC]

@ l_s+04 ,c_s+51 GET  tcarencia;
                 PICT sistema[op_sis,O_CAMPO,10,O_MASC]

@ l_s+05 ,c_s+14 GET  vivofalec;
                 PICT sistema[op_sis,O_CAMPO,12,O_MASC]

@ l_s+05 ,c_s+29 GET  falecto_;
                 PICT sistema[op_sis,O_CAMPO,13,O_MASC]

@ l_s+05 ,c_s+46 GET  tipo;
                 PICT sistema[op_sis,O_CAMPO,14,O_MASC]

@ l_s+05 ,c_s+64 GET  procnr;
                 PICT sistema[op_sis,O_CAMPO,15,O_MASC]

CLEAR GETS
RETU

PROC INS_get1     // capta variaveis do arquivo INSCRITS
LOCAL getlist := {}, tl_item_
PRIV  blk_inscrits:=.t.
PARA tp_mov, excl_rela
excl_rela=IF(excl_rela=NIL,.f.,excl_rela)
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  CRIT("",,"2|3")
  @ l_s+03 ,c_s+08 GET  nome;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+03 ,c_s+51 GET  nascto_;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6
                   MOSTRA sistema[op_sis,O_FORMULA,4]

  @ l_s+04 ,c_s+14 GET  estcivil
                   DEFINICAO 7

  @ l_s+04 ,c_s+33 GET  sexo;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
                   DEFINICAO 9

  @ l_s+04 ,c_s+51 GET  tcarencia;
                   PICT sistema[op_sis,O_CAMPO,10,O_MASC]
                   DEFINICAO 10

  @ l_s+05 ,c_s+14 GET  vivofalec;
                   PICT sistema[op_sis,O_CAMPO,12,O_MASC]
                   DEFINICAO 12

  @ l_s+05 ,c_s+29 GET  falecto_;
                   PICT sistema[op_sis,O_CAMPO,13,O_MASC]
                   DEFINICAO 13

  @ l_s+05 ,c_s+46 GET  tipo;
                   PICT sistema[op_sis,O_CAMPO,14,O_MASC]
                   DEFINICAO 14

  @ l_s+05 ,c_s+64 GET  procnr;
                   PICT sistema[op_sis,O_CAMPO,15,O_MASC]
                   DEFINICAO 15

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
  REPL lancto_ WITH date()
  IF ehtitular=[S]
   REPBLO('GRUPOS->titular',{||[   ]})
  ENDI
  IF vivofalec=[F]
   REPBLO('GRUPOS->particf',{||GRUPOS->particf - 1})
  ELSE
   REPBLO('GRUPOS->particv',{||GRUPOS->particv - 1})
  ENDI
  IF grau=[8]
   REPBLO('GRUPOS->nrdepend',{||GRUPOS->nrdepend - 1})
  ENDI
  IF !excl_rela
   REPL flag_excl WITH '*'
  ENDI
 #else
  REPL lancto_ WITH date()
  IF ehtitular=[S]
   REPL GRUPOS->titular WITH [   ]
  ENDI
  IF vivofalec=[F]
   REPL GRUPOS->particf WITH GRUPOS->particf - 1
  ELSE
   REPL GRUPOS->particv WITH GRUPOS->particv - 1
  ENDI
  IF grau=[8]
   REPL GRUPOS->nrdepend WITH GRUPOS->nrdepend - 1
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
  IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (GRUPOS->(DELE()))
   msg="|"+sistema[EVAL(qualsis,"GRUPOS"),O_MENU]
   ALERTA(2)
   DBOX("Registro exclu�do em:"+msg+"|*",,,,,"IMPOSS�VEL RECUPERAR!")
  ELSE
    IF op_menu=INCLUSAO
     lancto_=date()
     por=M->usuario
    ELSE
     REPL lancto_ WITH date(),;
          por WITH M->usuario
    ENDI

   #ifdef COM_REDE
    IF ehtitular=[S]
     REPBLO('GRUPOS->titular',{||grau+STRZERO(seq,2)})
    ENDI
    IF vivofalec=[F]
     REPBLO('GRUPOS->particf',{||GRUPOS->particf + 1})
    ELSE
     REPBLO('GRUPOS->particv',{||GRUPOS->particv + 1})
    ENDI
    IF grau=[8]
     REPBLO('GRUPOS->nrdepend',{||GRUPOS->nrdepend + 1})
    ENDI
    IF !excl_rela
     IF op_menu=INCLUSAO
      flag_excl=' '
     ELSE
      REPL flag_excl WITH ' '
     ENDI
    ENDI
   #else
    IF op_menu=INCLUSAO
     lancto_=date()
     por=M->usuario
    ELSE
     REPL lancto_ WITH date(),;
          por WITH M->usuario
    ENDI
    IF ehtitular=[S]
     REPL GRUPOS->titular WITH grau+STRZERO(seq,2)
    ENDI
    IF vivofalec=[F]
     REPL GRUPOS->particf WITH GRUPOS->particf + 1
    ELSE
     REPL GRUPOS->particv WITH GRUPOS->particv + 1
    ENDI
    IF grau=[8]
     REPL GRUPOS->nrdepend WITH GRUPOS->nrdepend + 1
    ENDI
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

PROC TAX_incl     // inclusao no arquivo TAXAS
LOCAL getlist:={}, cabem:=1, rep:=ARRAY(FCOU()), ult_reg:=RECN(),;
      ctl_r, ctl_c, t_f3_, t_f4_, l_max, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=INCLUSAO, op_sis, l_s, c_s, l_i, c_i, cod_sos, tem_borda, criterio:="", cpord:="", l_a
op_sis=EVAL(qualsis,"TAXAS")
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
TAX_TELA()                                         // imp tela para inclusao
INFOSIS()                                          // exibe informacao no rodape' da tela
l_a=Sistema[op_sis,O_TELA,O_SCROLL]
DISPEND()                                          // apresenta tela de uma vez so
DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE TAXAS
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
 cabem=INT((cabem-2048)/TAXAS->(RECSIZE()))
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
 @ l_s+l_a,c_s+01 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  DEFINICAO 2
                  MOSTRA sistema[op_sis,O_FORMULA,4]

 @ l_s+l_a,c_s+09 GET  circ;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                  DEFINICAO 3

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA()
  LOOP
 ENDI
 SELE TAXAS
 IF LASTKEY()=K_ESC                                // cancelou ou chave em branco
  cabem=0                                          // prepara saida da inclusao
  LOOP                                             // volta p/ menu de cadastramento
 ENDI
 SEEK M->codigo+M->tipo+M->circ
 aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)   // vai aproveitar o registro?
 IF FOUND() .AND. !aprov_reg_                      // pesquisou e achou!
  l_a=Sistema[op_sis,O_TELA,O_SCROLL]
  op_menu=ALTERACAO                                // seta flag de ateracao
  DISPBEGIN()
  TAX_GETS()                                       // mostra conteudo do registro
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
  TAX_TELA()
  INFOSIS()                                        // exibe informacao no rodape' da tela
  DISPEND()
  LOOP                                             // volta para inclusao
 ENDI
 SELE 0
 TAX_GET1(INCLUI)                                  // recebe campos
 SELE TAXAS
 IF LASTKEY()=K_ESC                                // se cancelou
  ALERTA()                                         // avisa que o registro
  DBOX("Registro n�o inclu�do!",18,,1)             // nao foi incluido, e volta
  LOOP
 ENDI

 #ifdef COM_REDE
  GO BOTT                                          // vamos bloquear o final do
  SKIP                                             // arq para que nehum outro
  BLOREG(0,.5)                                     // usuario possa incluir
  SEEK M->codigo+M->tipo+M->circ                   // se registro foi incluido
  aprov_reg_=(FOUND().AND.DELE().AND.!drvvisivel)  // vai aproveitar o registro?
  IF FOUND() .AND. !aprov_reg_                     // por outro usuario, entao
   BLOREG(0,.5)

   FOR i=1 TO FCOU()
    msg=FIEL(i)
    rep[i]=&msg.
    REPL &msg. WITH M->&msg.
   NEXT
   TAX_GET1(FORM_INVERSA)                          // executa formula inversa
   RECA
   FOR i=1 TO FCOU()
    msg=FIEL(i)
    REPL &msg. WITH rep[i]
   NEXT
   ALERTA(4)                                       // beep 4 vezes
   msg="Registro acabou de ser|inclu�do por outro usu�rio!"
   DBOX(msg,,,,,"ATEN��O!")                        // avisa
   SELE TAXAS
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
 IF EMPT(M->CODLAN)
  M->CODLAN:=[PI]+dtos(date())+left(time(),2)+;
             substr(time(),4,2)+M->usuario
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
// TAX_REL(ult_reg)                               // imprime relat apos inclusao
 l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
 IF l_s+l_a+1<l_max                                // se nao atingiu o fim da tela
  l_a++                                            // digita na proxima linha
 ELSE                                              // se nao rola a campos para cima
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+01,l_max-1,c_s+01,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+09,l_max-1,c_s+11,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+13,l_max-1,c_s+22,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+24,l_max-1,c_s+33,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+36,l_max-1,c_s+45,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+47,l_max-1,c_s+56,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+58,l_max-1,c_s+60,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+62,l_max-1,c_s+62,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+64,l_max-1,c_s+71,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+73,l_max-1,c_s+74,1)
  SCROLL(l_s+Sistema[op_sis,O_TELA,O_SCROLL],c_s+03,l_max-1,c_s+07,1)
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

PROC TAX_REL(ult_reg)  // imprime relatorio apos inclusao
DO WHIL .t.
 msg_t="IMPRESS�O DAS TAXAS"
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
  tps=TP_SAIDA(,,.t.)            // escolhe a impressora
  IF LASTKEY()=K_ESC             // se teclou ESC
   EXIT                          // cai fora...
  ENDI
  IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
		 IF tipo$'38'
			IIF(M->p_recp=[S],ADP_RP44(tps,0,ult_reg),ADP_R044(tps,0,ult_reg))
		 ENDI
		 IF tipo$'27'
			IIF(M->p_recp=[S],ADM_RP33(tps,0,ult_reg),ADM_RV33(tps,0,ult_reg))
		 ENDI
		 IF !(tipo$'2378')
			IIF(M->p_recp=[S],ADM_RP38(tps,0,ult_reg),ADP_R066(tps,0,ult_reg))
		 ENDI
 #else
	IF PREPIMP(msg_t)              // confima preparacao da impressora
		 IF tipo$'38'
			IIF(M->p_recp=[S],ADP_RP44(0,0,ult_reg),ADP_R044(0,0,ult_reg))
		 ENDI
		 IF tipo$'27'
			IIF(M->p_recp=[S],ADM_RP33(0,0,ult_reg),ADM_RV33(0,0,ult_reg))
		 ENDI
		 IF !(tipo$'2378')
			IIF(M->p_recp=[S],ADM_RP38(0,0,ult_reg),ADP_R066(0,0,ult_reg))
		 ENDI
 #endi

  REST SCREEN                    // restaura tela
  msg="Prosseguir|Outra c�pia"
  op_=1 //DBOX(msg,,,E_MENU,,msg_t)  // quer emitir outra copia?
  IF op_=2
   LOOP                          // nao quer...
  ENDI
 ENDI
 EXIT
ENDD
RETU

PROC TAX_tela     // tela do arquivo TAXAS
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
@ l_s+01,c_s+1 SAY "  Tip   N�  Emissao       Valor   � Pagto     Valor Pago Cb  F Status"
@ l_s+02,c_s+1 SAY "���������������������������������������������������������������������������"
@ l_s+03,c_s+1 SAY "                                  �"
@ l_s+04,c_s+1 SAY "                                  �"
@ l_s+05,c_s+1 SAY "                                  �"
@ l_s+06,c_s+1 SAY "                                  �"
@ l_s+07,c_s+1 SAY "                                  �"
@ l_s+08,c_s+1 SAY "                                  �"
@ l_s+09,c_s+1 SAY "                                  �"
RETU

PROC TAX_gets     // mostra variaveis do arquivo TAXAS
LOCAL getlist := {}, l_max, reg_atual:=RECNO()
PRIV  l_a:=Sistema[op_sis,O_TELA,O_SCROLL]
TAX_TELA()
l_max=l_s+Sistema[op_sis,O_TELA,O_SCROLL]+Sistema[op_sis,O_TELA,O_QTDE]
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE !EOF() .AND. l_s+l_a<l_max .AND.;
   &(INDEXKEY(0))=IF(EMPT(criterio),"","T")+chv_1
 CRIT("",,"1|3")
 @ l_s+l_a,c_s+01 GET  tipo;
                  PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                  CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"4")

 @ l_s+l_a,c_s+09 GET  circ;
                  PICT sistema[op_sis,O_CAMPO,03,O_MASC]

 @ l_s+l_a,c_s+13 GET  emissao_;
                  PICT sistema[op_sis,O_CAMPO,04,O_MASC]

 @ l_s+l_a,c_s+24 GET  valor;
                  PICT sistema[op_sis,O_CAMPO,05,O_MASC]

 @ l_s+l_a,c_s+36 GET  pgto_;
                  PICT sistema[op_sis,O_CAMPO,06,O_MASC]

 @ l_s+l_a,c_s+47 GET  valorpg;
                  PICT sistema[op_sis,O_CAMPO,07,O_MASC]

 @ l_s+l_a,c_s+58 GET  cobrador;
                  PICT sistema[op_sis,O_CAMPO,08,O_MASC]

 @ l_s+l_a,c_s+62 GET  forma;
                  PICT sistema[op_sis,O_CAMPO,09,O_MASC]

 SETCOLOR(drvcortel+","+drvcortel+",,,"+drvcortel)
 l_a++
 SKIP
ENDD
GO reg_atual
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
CLEAR GETS
RETU

PROC TAX_get1     // capta variaveis do arquivo TAXAS
LOCAL getlist := {}
PRIV  blk_taxas:=.t.
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
  CRIT("",,"1|3")
  @ l_s+l_a,c_s+13 GET  emissao_;
                   PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                   DEFINICAO 4

  @ l_s+l_a,c_s+24 GET  valor;
                   PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                   DEFINICAO 5

  @ l_s+l_a,c_s+36 GET  pgto_;
                   PICT sistema[op_sis,O_CAMPO,06,O_MASC]
                   DEFINICAO 6

  @ l_s+l_a,c_s+47 GET  valorpg;
                   PICT sistema[op_sis,O_CAMPO,07,O_MASC]
                   DEFINICAO 7

  @ l_s+l_a,c_s+58 GET  cobrador;
                   PICT sistema[op_sis,O_CAMPO,08,O_MASC]
                   DEFINICAO 8

  @ l_s+l_a,c_s+62 GET  forma;
                   PICT sistema[op_sis,O_CAMPO,09,O_MASC]
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
PTAB(CODIGO,'GRUPOS',1)
PTAB(GRUPOS->TIPCONT,'CLASSES',1)
PTAB(GRUPOS->GRUPO+CIRC,'CIRCULAR',1)
PTAB(COBRADOR,'COBRADOR',1)
PTAB(COBRADOR+M->MMESREF,'FCCOB',1)
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 IF (!EMPTY(codlan) .AND. tp_mov=EXCLUI).AND.1=3
/*
  ALERTA()       // existe registro validado aqui!
  msg="Registro de Lan�amento"
  DBOX(msg,,,,,"IMPOSS�VEL EXCLUIR!")
*/
 ELSE

  #ifdef COM_REDE
   IF !tipo='1'
    REPBLO('GRUPOS->qtcircs',{||GRUPOS->qtcircs - 1})
    IF valorpg>0
     REPBLO('GRUPOS->qtcircpg',{||GRUPOS->qtcircpg - 1})
    ENDI
   ENDI
   IF !excl_rela
    REPL flag_excl WITH '*'
   ENDI
  #else
   IF !tipo='1'
    REPL GRUPOS->qtcircs WITH GRUPOS->qtcircs - 1
    IF valorpg>0
     REPL GRUPOS->qtcircpg WITH GRUPOS->qtcircpg - 1
    ENDI
   ENDI
   IF !excl_rela
    REPL flag_excl WITH '*'
   ENDI
  #endi

	DELE
 ENDI
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF (!EMPTY(codlan) .AND. tp_mov=RECUPERA).AND.1=3
   ALERTA()      // existe registro validado aqui!
   msg="Registro de Lan�amento"
	 DBOX(msg,,,,,"IMPOSS�VEL RECUPERAR!")
  ELSE
   IF tp_mov=RECUPERA .AND. op_menu!=INCLUSAO .AND. (GRUPOS->(DELE()))
    msg="|"+sistema[EVAL(qualsis,"GRUPOS"),O_MENU]
    ALERTA(2)
    DBOX("Registro exclu�do em:"+msg+"|*",,,,,"IMPOSS�VEL RECUPERAR!")
   ELSE

    #ifdef COM_REDE
     IF !tipo='1'
      REPBLO('GRUPOS->qtcircs',{||GRUPOS->qtcircs + 1})
      IF valorpg>0
       REPBLO('GRUPOS->qtcircpg',{||GRUPOS->qtcircpg + 1})
      ENDI
     ENDI
     IF !tipo='1'.AND.circ>GRUPOS->ultcirc.and.circ#[999]
      REPBLO('GRUPOS->ultcirc',{||circ})
     ENDI
     IF !excl_rela
      IF op_menu=INCLUSAO
       flag_excl=' '
      ELSE
       REPL flag_excl WITH ' '
      ENDI
     ENDI
     IF TAXAS->stat< [6].AND.TAXAS->valorpg>0
      REPBLO('TAXAS->stat',{||[9]})
      REPBLO('TAXAS->por',{||M->usuario})
     ENDI
     IF EMPT(TAXAS->codlan)
      REPBLO('TAXAS->codlan',{||[PL]+dtos(date())+left(time(),2)+substr(time(),4,2)+M->usuario})
     ENDI
     IF (TAXAS->stat=[R])
      REPBLO('TAXAS->stat',{||[1]})
     ENDI

    #else
     IF !tipo='1'
      REPL GRUPOS->qtcircs WITH GRUPOS->qtcircs + 1
      IF valorpg>0
       REPL GRUPOS->qtcircpg WITH GRUPOS->qtcircpg + 1
      ENDI
     ENDI
     IF !tipo='1'.AND.circ>GRUPOS->ultcirc.and.circ#[999]
      REPL GRUPOS->ultcirc WITH circ
     ENDI
     IF !excl_rela
      IF op_menu=INCLUSAO
       flag_excl=' '
      ELSE
       REPL flag_excl WITH ' '
      ENDI
		 ENDI
     IF stat< [6].AND.valorpg>0
      REPL TAXAS->stat WITH [9], TAXAS->por WITH M->usuario
     ENDI
     IF EMPT(TAXAS->codlan)
      REPL TAXAS->codlan WITH [PL]+dtos(date())+left(time(),2)+;
                              substr(time(),4,2)+M->usuario
     ENDI
     IF (TAXAS->stat=[R])
      REPL TAXAS->stat WITH [1]
     ENDI

		#endi

    IF op_menu!=INCLUSAO
		 RECA
    ENDI
   ENDI
  ENDI
 ENDI
ENDI
RETU

* \\ Final de GRUPOS.PRG

FUNC menu2gru
opc_gru=1
v04gru=SAVESCREEN(0,0,MAXROW(),79)
DO WHIL opc_gru!=0
 cod_sos=4
 RESTSCREEN(0,0,MAXROW(),79,v04gru)
 menugru:="Gerar J�ia (tip=1)|"+;
					"Imprimir J�ia|"+;
					"Gerar Carn� (tip=3)|"+;
					"Imprimir Carn�|"+;
					"Imprimir Contrato"

 opc_gru=DBOX(menugru,5,42,E_MENU,NAO_APAGA,"Contrato",,,opc_gru++)

 DO CASE
 CASE opc_gru=5     // impress�o contrato
	IMP_R041()
 CASE opc_gru=1     // Gerar carne
	sit_antcar:=POINTER_DBF()
	sele grupos
	ult_reg:=recno()
	SET CURS ON
  EMCARNE(0,0,ult_reg)  //Gera parcelas tipo 1
	SET CURS OFF
	POINTER_DBF(sit_antcar)
  opc_gru=2
 CASE opc_gru=2     // impress�o Joia tipo '1'
	sit_antcar:=POINTER_DBF()
	sele grupos
	ult_cod:=codigo
  IF PTAB(ult_cod+[1],[TAXAS],1)
	 rtodas=[N]                                     // Todas?
	 rcod1:=rcod2:=ult_cod                          // Contrato
	 IMP_R066()
  ENDI
	POINTER_DBF(sit_antcar)
  opc_gru=3
 CASE opc_gru=3     // Gerar taxas funcao contida em EMCARNE.PRG
	sit_antcar:=POINTER_DBF()
	sele grupos
	ult_reg:=recno()
	SET CURS ON
  adp_pn07(0,0,codigo)  //Gera parcelas tipo 3
	SET CURS OFF
	POINTER_DBF(sit_antcar)
  opc_gru=4
 CASE opc_gru=4     // impress�o Carne tipo=3
	sit_antcar:=POINTER_DBF()
	sele grupos
	ult_cod:=codigo
  IF PTAB(ult_cod+[3],[TAXAS],1)
	 rtodas=[N]                                     // Todas?
	 rcod1:=rcod2:=ult_cod                          // Contrato
	 IMP_R044()
  ENDI
	POINTER_DBF(sit_antcar)
  opc_gru=5
 ENDC
ENDD
RESTSCREEN(0,0,MAXROW(),79,v04gru)


PROC IMP_R041  // imprime relatorio apos inclusao
ult_reg:=RECNO()
rmodelo=[ ]

DO WHIL .t.
 msg_t="IMPRESS�O DO CONTRATO"
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
	tps=TP_SAIDA(,,.t.)            // escolhe a impressora
	IF LASTKEY()=K_ESC             // se teclou ESC
	 EXIT                          // cai fora...
	ENDI
	IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
	 ADM_R041(tps,0,ult_reg)
	ENDI
 #else
	IF PREPIMP(msg_t)              // confima preparacao da impressora
	 ADM_R041(0,0,ult_reg)
	ENDI
 #endi

	REST SCREEN                    // restaura tela
	msg="Prosseguir|Outra c�pia"
	op_=1 //DBOX(msg,,,E_MENU,,msg_t)  // quer emitir outra copia?
	IF op_=2
	 LOOP                          // nao quer...
	ENDI
 EXIT
ENDD

RETU

PROC IMP_R066
ult_reg:=RECNO()

DO WHIL .t.
 msg_t="IMPRESS�O DO CARNE Tipo=1"
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
	tps=TP_SAIDA(,,.t.)            // escolhe a impressora
	IF LASTKEY()=K_ESC             // se teclou ESC
	 EXIT                          // cai fora...
	ENDI
	IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
   IF p_recp==[S]
    ADM_RP38(tps,0,ult_reg,ult_cod+[1])
   ELSE
	  ADP_R066(tps,0,ult_reg,ult_cod+[1])
   ENDI
	ENDI
 #else
	IF PREPIMP(msg_t)              // confima preparacao da impressora
   IF p_recp==[S]
    ADM_RP38(0,0,ult_reg,ult_cod+[1])
   ELSE
	  ADP_R066(0,0,ult_reg,ult_cod+[1])
   ENDI
	ENDI
 #endi

 REST SCREEN                    // restaura tela
 EXIT
ENDD
RETU

PROC IMP_R044
ult_reg:=RECNO()

DO WHIL .t.
 msg_t="IMPRESS�O DO CARNE tipo=3"
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
	tps=TP_SAIDA(,,.t.)            // escolhe a impressora
	IF LASTKEY()=K_ESC             // se teclou ESC
	 EXIT                          // cai fora...
	ENDI
	IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
   IF p_recp==[S]
	  ADP_RP44(tps,0,ult_reg,ult_cod+[3])
   ELSE
    ADP_R044(tps,0,ult_reg,ult_cod+[3])
   ENDI
	ENDI
 #else
	IF PREPIMP(msg_t)              // confima preparacao da impressora
   IF p_recp==[S]
	  ADP_RP44(0,0,ult_reg,ult_cod+[3])
   ELSE
    ADP_R044(0,0,ult_reg,ult_cod+[3])
   ENDI
	ENDI
 #endi

 REST SCREEN                    // restaura tela
 EXIT
ENDD

FUNC GRU_05F9(nomx)
donex:=pointer_dbf()
IF PTAB(ALLTRIM(nomx),[INSCRITS],2)
 ALERTA()
 DBOX([ATENCAO ]+M->usuario+[|Ja existe inscrito com nome de:|]+INSCRITS->nome+[  (]+INSCRITS->codigo+[)])
ENDI
IF PTAB(ALLTRIM(nomx),[CGRUPOS],3)
 ALERTA()
 DBOX([ATENCAO ]+M->usuario+[|Ja existe CONTRATO CANCELADO de:|]+CGRUPOS->nome+[  (]+CGRUPOS->numero+[)])
ENDI
pointer_dbf(donex)
RETU .T.

FUNC GRU_STXA
     IF messaitaxa=[0]      // Nao acertar sai taxa
      // Se nao foi definido no ambiente, nao faz nada.
      dataux:=[    ]
     ELSEIF messaitaxa=[F] // Acumular Forma Pgto a ult. vencto.
      diaaux:=SUBSTR(DTOC(admissao-DAY(admissao)+1+(31*VAL(formapgto))),4)
      dataux:=LEFT(diaaux,2)+RIGHT(M->diaaux,2)
     ELSE                   // Acumular VAL(messaitaxa) a ult. vencto.
      diaaux:=SUBSTR(DTOC(admissao-DAY(admissao)+1+(31*VAL(M->messaitaxa))),4)
      dataux:=LEFT(diaaux,2)+RIGHT(M->diaaux,2)
     ENDI
RETU M->dataux

FUNC GRU_TCAR
diastcar=LEFT(GETENV("TCARENCIA"),1)       // tenta variavel de ambiente
IF EMPT(diastcar)
 diastcar=[0] // Utilizado no DEFAULT de TCarencia
ENDI
RETU (admissao+VAL(diastcar))

FUNC INS_TCAR
diastcar=LEFT(GETENV("TCARENCIA"),1)       // tenta variavel de ambiente
IF EMPT(diastcar)
 diastcar=[0] // Utilizado no DEFAULT de TCarencia
ENDI
RETU (IIF(GRUPOS->tcarencia> DATE(),GRUPOS->tcarencia,DATE()+VAL(diastcar)))
