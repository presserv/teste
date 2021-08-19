procedure emcarne
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: EMCARNE.PRG
 \ Data....: 03-12-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador do subsistema de lan�amento/carn�s
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
PRIV dataux, diaaux
op_sis=EVAL(qualsis,"EMCARNE")
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
    EMC_INCL()                                     // neste arquivo chama prg de inclusao
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
   EDITA(5,06,MAXROW()-4,74)

 ENDC
 SET KEY K_F9 TO                                   // F9 nao mais consultara outros arquivos
// CLOS ALL                                          // fecha todos arquivos abertos
ENDD
RESTSCREEN(,0,MAXROW(),79,T_fundo)                // restaura tela do fundo
RETU

PROC EMC_incl     // inclusao no arquivo EMCARNE
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
 EMC_CRIA_SEQ()                                    // cria dbf de controle de cp sequenciais
 FOR i=1 TO FCOU()                                 // cria/declara privadas as
  msg="sq_"+FIEL(i)                                // variaveis de memoria com
  PRIV &msg.                                       // o mesmo nome dos campos
 NEXT                                              // do arquivo com estensao _seq
#endi

DO WHIL cabem>0
 cod_sos=6
 rola_t=.f.                                        // flag se quer rolar a tela
 SELE EMCARNE
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
 EMC_TELA()
 INFOSIS()                                         // exibe informacao no rodape' da tela
 DISPEND()
 EMC_GERA_SEQ()
 cabem=DISKSPACE(IF(LEN(drvdbf)<2.OR.drvdbf="\",0,ASC(drvdbf)-64))
 cabem=INT((cabem-2048)/EMCARNE->(RECSIZE()))
 IF cabem<1                                        // mais nenhum!!!
  ALERTA()
  msg="Verifique ESPA�O EM DISCO, "+usuario
  DBOX(msg,,,,,"INCLUS�O INTERROMPIDA!")           // vamos parar por aqui!
  EXIT
 ENDI
 SELE 0                                            // torna visiveis variaveis de memoria
 EMC_GET1(INCLUI)                                  // recebe campos
 SELE EMCARNE
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
 EMC_REL(ult_reg)                               // imprime relat apos inclusao
ENDD

#ifdef COM_REDE
 EMC_ANT_SEQ()                                     // restaura sequencial anterior
 SELE EMCARNE
#endi

GO ult_reg                                         // para o ultimo reg digitado
SETKEY(K_F3,t_f3_)                                 // restaura teclas de funcoes
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                            // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC EMC_REL(ult_reg)  // imprime relatorio apos inclusao
DO WHIL .t.
 msg_t="Impress�o de Carn�"
 SAVE SCREEN                     // salva a tela

 #ifdef COM_REDE
  tps=TP_SAIDA(,,.t.)            // escolhe a impressora
  IF LASTKEY()=K_ESC             // se teclou ESC
   EXIT                          // cai fora...
  ENDI
  IF tps=2 .OR. PREPIMP(msg_t)   // se nao vai para video conf impressora pronta
		rec_dbf2:=recno()
    rcod1:=rcod2:=codigo+TCARNES->tipcob
		SELE TAXAS
		ult_reg:=RECNO()               // imprime relatorio apos inclusao
	 IIF(M->p_recp=[S],ADM_RP38(tps,0,ult_reg,rcod1),ADP_R066(tps,0,ult_reg,rcod1))
//   ADP_R066(tps,0,ult_reg)
 #else
  IF PREPIMP(msg_t)              // confima preparacao da impressora
		rec_dbf2:=recno()
    rcod1:=rcod2:=codigo+TCARNES->tipcob
		SELE TAXAS
		ult_reg:=RECNO()               // imprime relatorio apos inclusao
	 IIF(M->p_recp=[S],ADM_RP38(0,0,ult_reg,rcod1),ADP_R066(0,0,ult_reg,rcod1))
//   ADP_R066(0,0,ult_reg)
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


#ifdef COM_REDE
 PROC EMC_ANT_SEQ(est_seq)     // restaura sequencial anterior
 SELE EMC_SEQ     // seleciona arquivo de controle de sequencial
 BLOARQ(0,.5)     // esta estacao foi a ultima a incluir?
 IF sq_atual_ == seq
  REPL seq WITH sq_seq
  REPL intlan WITH sq_intlan
 ENDI
 UNLOCK           // libera DBF para outros usuarios
 COMMIT           // atualiza cps sequenciais no disco
 RETU
#endi


PROC EMC_CRIA_SEQ   // cria dbf de controle de campos sequenciais
LOCAL dbfseq_:=drvdbf+"EMC_seq" // arq temporario
SELE 0                          // seleciona area vazia
IF !FILE(dbfseq_+".dbf")        // se o dbf nao existe
 DBCREATE(dbfseq_,{;            // vamos criar a sua estrutura
                    {"seq"       ,"C",  6, 0},;
                    {"intlan"    ,"C",  8, 0};
                  };
 )
ENDI
USEARQ(dbfseq_,.f.,,,.f.)       // abre arquivo de cps sequencial
IF RECC()=0                     // se o dbf foi criado agora
 BLOARQ(0,.5)                   // inclui um registro que tera
 APPEND BLANK                   // os ultomos cps sequenciais
 SELE EMCARNE
 IF RECC()>0                    // se o DBF nao estiver
  SET ORDER TO 0                // vazio, entao enche DBF seq
  GO BOTT                       // com o ultimo reg digitado
  REPL EMC_SEQ->seq WITH seq
  REPL EMC_SEQ->intlan WITH intlan
  SET ORDER TO 1                // retorna ao indice principal
 ENDI
 SELE EMC_SEQ                   // seleciona arq de sequencias
 UNLOCK                         // libera DBF para outros usuarios
 COMMIT                         // atualiza cps sequenciais no disco
ENDI
RETURN

PROC EMC_GERA_SEQ()

#ifdef COM_REDE
 LOCAL ar_:=SELEC()
#else
 LOCAL reg_:=RECNO(),ord_ind:=INDEXORD()
#endi


#ifdef COM_REDE
 SELE EMC_SEQ
 BLOARQ(0,.5)
 sq_seq=EMC_SEQ->seq
 sq_intlan=EMC_SEQ->intlan
#else
 SET ORDER TO 0
 GO BOTT
#endi

M->seq=LPAD(STR(VAL(seq)+1),06,[0])
M->intlan=LPAD(STR(VAL(intlan)+1),08,[0])

#ifdef COM_REDE
 EMC_GRAVA_SEQ()
 sq_atual_=EMC_SEQ->seq
 UNLOCK                                            // libera o registro
 COMMIT
 SELE (ar_)
#else
 DBSETORDER(ord_ind)
 GO reg_
#endi

RETU

PROC EMC_GRAVA_SEQ
REPL seq WITH M->seq
REPL intlan WITH M->intlan
RETU

PROC EMC_tela     // tela do arquivo EMCARNE
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
@ l_s+01,c_s+1 SAY "                    Filial:       (                   )"
@ l_s+02,c_s+1 SAY "��������������������������������������������������������"
@ l_s+03,c_s+1 SAY " Contrato..:"
@ l_s+05,c_s+1 SAY " Vendedor..:"
@ l_s+06,c_s+1 SAY " Tabela Tip:        Gerar    parcelas de"
@ l_s+07,c_s+1 SAY "                    com tipo   a cada"
@ l_s+08,c_s+1 SAY " Parcela de:     at�       Vencto:"
@ l_s+09,c_s+1 SAY "                                (   parcelas geradas)"
@ l_s+10,c_s+1 SAY " Emitido em:               Etiquetas em:"
RETU

PROC EMC_gets     // mostra variaveis do arquivo EMCARNE
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
EMC_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(CODIGO,'GRUPOS',1)
PTAB(VENDEDOR,'COBRADOR',1)
PTAB(GRUPOS->TIPCONT,'CLASSES',1)
PTAB(TIP,'TCARNES',1)
//CRIT("",,"6|13|14|15")
@ l_s+01 ,c_s+02 GET  seq;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+03 ,c_s+14 GET  codigo;
                 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT],,"1|2")

@ l_s+05 ,c_s+14 GET  vendedor;
                 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT],,"4|5")

@ l_s+06 ,c_s+14 GET  tip;
                 PICT sistema[op_sis,O_CAMPO,04,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,04,O_CRIT],,"7|8|9|10|11")

@ l_s+08 ,c_s+14 GET  circ;
                 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
                 CRIT(sistema[op_sis,O_CAMPO,05,O_CRIT],,"12")

@ l_s+08 ,c_s+36 GET  vencto_;
                 PICT sistema[op_sis,O_CAMPO,06,O_MASC]

@ l_s+10 ,c_s+14 GET  emissao_;
                 PICT sistema[op_sis,O_CAMPO,07,O_MASC]

@ l_s+10 ,c_s+42 GET  etiqueta_;
                 PICT sistema[op_sis,O_CAMPO,08,O_MASC]

CLEAR GETS
RETU

PROC EMC_get1     // capta variaveis do arquivo EMCARNE
LOCAL getlist := {}, ord_, chv_, ar_get1:=ALIAS()
PRIV  blk_emcarne:=.t.
PARA tp_mov
IF tp_mov=INCLUI
 DO WHILE .t.
  rola_t=.f.
  SET KEY K_ALT_F8 TO ROLATELA
  SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
  @ l_s+01 ,c_s+02 GET seq;
                   PICT sistema[op_sis,O_CAMPO,01,O_MASC]
  CLEA GETS
//  CRIT("",,"6|13|14|15")
	@ l_s+03 ,c_s+14 GET  codigo;
									 PICT sistema[op_sis,O_CAMPO,02,O_MASC]
									 DEFINICAO 2
									 MOSTRA sistema[op_sis,O_FORMULA,1]
									 MOSTRA sistema[op_sis,O_FORMULA,2]

	@ l_s+05 ,c_s+14 GET  vendedor;
									 PICT sistema[op_sis,O_CAMPO,03,O_MASC]
									 DEFINICAO 3
									 MOSTRA sistema[op_sis,O_FORMULA,4]
									 MOSTRA sistema[op_sis,O_FORMULA,5]

	@ l_s+06 ,c_s+14 GET  tip;
									 PICT sistema[op_sis,O_CAMPO,04,O_MASC]
									 DEFINICAO 4
									 MOSTRA sistema[op_sis,O_FORMULA,7]
									 MOSTRA sistema[op_sis,O_FORMULA,8]
									 MOSTRA sistema[op_sis,O_FORMULA,9]
									 MOSTRA sistema[op_sis,O_FORMULA,10]
									 MOSTRA sistema[op_sis,O_FORMULA,11]

	@ l_s+08 ,c_s+14 GET  circ;
									 PICT sistema[op_sis,O_CAMPO,05,O_MASC]
									 DEFINICAO 5
									 MOSTRA sistema[op_sis,O_FORMULA,12]

	@ l_s+08 ,c_s+36 GET  vencto_;
									 PICT sistema[op_sis,O_CAMPO,06,O_MASC]
									 DEFINICAO 6

	@ l_s+10 ,c_s+14 GET  emissao_;
			 PICT sistema[op_sis,O_CAMPO,07,O_MASC]
									 DEFINICAO 7

	@ l_s+10 ,c_s+42 GET  etiqueta_;
			 PICT sistema[op_sis,O_CAMPO,08,O_MASC]
			 DEFINICAO 8

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
PTAB(VENDEDOR,'COBRADOR',1)
PTAB(GRUPOS->TIPCONT,'CLASSES',1)
PTAB(TIP,'TCARNES',1)
PTAB(CODIGO+TCARNES->TIPCOB+CIRC,'TAXAS',1)
parok:=0
IF tp_mov=EXCLUI .OR. tp_mov=FORM_INVERSA
 TIRA_LANC("TAXAS","EMC-"+intlan)
 DELE
ELSEIF tp_mov=INCLUI .OR. tp_mov=RECUPERA .OR. tp_mov=FORM_DIRETA
 IF (op_menu=INCLUSAO .AND. LASTKEY()!=K_ESC) .OR. op_menu!=INCLUSAO
  IF !PTAB(codigo+TCARNES->tipcob+EMCARNE->circ,'TAXAS',1)
   ord_=LEN(sistema[EVAL(qualsis,"TAXAS"),O_CHAVE])
   FOR nparc=1 TO TCARNES->parf
    IF nparc<TCARNES->pari
     LOOP
    ENDI
    chv_="EMC-"+intlan+"-001-"+RIGHT(STR(1000+nparc),3)
    staux:=PTAB(chv_,"TAXAS",ord_)
    FAZ_LANC("TAXAS",chv_)

// Rotina incluida para corrigir os vencimentos em datas invalidas (30/02)

    diaaux:=LEFT(DTOC(vencto_),3)+SUBSTR(DTOC(vencto_-DAY(vencto_)+1+(31*(nparc-1)*VAL(TCARNES->formapgto))),4)
    dataux:=CTOD(M->diaaux)
    DO WHILE EMPT(M->dataux)
     diaaux:=STR(VAL(LEFT(diaaux,2))-1,2)+SUBSTR(diaaux,3)
     dataux:=CTOD(M->diaaux)
    ENDD


    REPL TAXAS->codigo WITH codigo,;
         TAXAS->tipo WITH TCARNES->tipcob,;
         TAXAS->flag_excl WITH [ ],;
         TAXAS->circ WITH RIGHT('00'+ALLTRIM(STR(nparc-1+VAL(circ))),3)
    IF TAXAS->stat=[ ]
     REPL TAXAS->stat WITH [1]
    ENDI
    IF TAXAS->valorpg=0
	   REPL TAXAS->emissao_ WITH M->dataux,;
          TAXAS->cobrador WITH COBRADOR->cobrador,;
	        TAXAS->valor WITH EMC_01F9(),;
          TAXAS->por WITH M->usuario
    ENDI

    parok+=1

    SELE TAXAS                                     // arquivo alvo do lancamento

    TAX_GET1(FORM_DIRETA)                          // faz processo do arq do lancamento

    #ifdef COM_REDE
     UNLOCK                                        // libera o registro
    #endi
    IF nparc=TCARNES->parf
     IF messaitaxa=[0]      // Nao acertar sai taxa
      // Se nao foi definido no ambiente, nao faz nada.
     ELSEIF messaitaxa=[F] // Acumular Forma Pgto a ult. vencto.
      diaaux:=SUBSTR(DTOC(M->dataux-DAY(M->dataux)+1+(31*VAL(GRUPOS->formapgto))),4)
      dataux:=LEFT(diaaux,2)+RIGHT(M->diaaux,2)
      REPBLO('GRUPOS->saitxa',{||M->dataux})
     ELSE                   // Acumular VAL(messaitaxa) a ult. vencto.
      diaaux:=SUBSTR(DTOC(M->dataux-DAY(M->dataux)+1+(31*VAL(M->messaitaxa))),4)
      dataux:=LEFT(diaaux,2)+RIGHT(M->diaaux,2)
      REPBLO('GRUPOS->saitxa',{||M->dataux})
     ENDI
    ENDI

    IF EMPT(ar_get1)                               // retorna para area original
     SELE 0
    ELSE
     SELE (ar_get1)
    ENDI
   NEXT

  ENDI
   IF EMPT(por)
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
  IF op_menu!=INCLUSAO
   RECA
  ENDI
 ENDI
ENDI
RETU

* \\ Final de EMCARNE.PRG
func adp_pn07
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADP_P007.PRG
 \ Data....: 28-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerar carn� do contrato
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

//#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu, imp_reg
so_um_reg=(PCOU()>2)
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=10, l_i:=12, c_i:=51, tela_fp007:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " LAN�AMENTO DE PARCELAS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "    Contrato:"
@ l_s+02,c_s+1 SAY "    Gerar    parcelas de"
@ l_s+03,c_s+1 SAY "    e "
@ l_s+04,c_s+1 SAY "    vencimento a partir de"
IF so_um_reg
 rcodigo=imp_reg
ELSE
 rcodigo=SPAC(6)                                    // Codigo
ENDI
parcf=0                                            // Parcf
vlparc=0                                           // Vlparc
rtipo=[3] //SPAC(1)                                      // Tipo
rcirc=SPAC(3)                                      // Circular
vini_=CTOD('')                                     // Vencimento
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+15 GET  rcodigo;
                  PICT "999999";
									VALI CRIT("PTAB(rcodigo,[GRUPOS],1)~Contrato cancelado |ou inexistente")
									AJUDA "Informe o n�mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 IF so_um_reg
  clear gets
 ENDI

 @ l_s+02 ,c_s+11 GET  parcf;
									PICT "99";
                  VALI CRIT("parcf>0~PARCF n�o aceit�vel")

 @ l_s+02 ,c_s+26 GET  vlparc;
                  PICT "99999999.99";
                  VALI CRIT("vlparc>0~VLPARC n�o aceit�vel")
/*
 @ l_s+03 ,c_s+14 GET  rtipo;
                  PICT "!";
                  VALI CRIT("!EMPT(rtipo)~TIPO n�o aceit�vel")
                  AJUDA "Qual o tipo de lan�amento"
                  CMDF8 "MTAB([1=J�ia |2=Taxa |3=Carn�|4=Acerto|6=J�ia+Seguro|7=Taxa+Seguro|8=Carn�+Seguro],[TIPO])"

 @ l_s+03 ,c_s+32 GET  rcirc;
                  PICT "999";
                  VALI CRIT("!EMPT(rcirc)~Necess�rio informar n�mero de CIRCULAR v�lida")
									AJUDA "Informe o n�mero da circular inicial a gerar"
*/
 @ l_s+04 ,c_s+28 GET  vini_;
									PICT "@D";
									VALI CRIT("!EMPT(vini_)~Necess�rio informar Data v�lida")
									AJUDA "Data da Vencimento Circular|Mantido pela emissao do recibo"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
	ROLATELA(.f.)
	LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
	RESTSCREEN(,0,MAXROW(),79,tela_fp007)                // restaura tela do fundo
	RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="GERAR CARNE DO CONTRATO"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera��o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
//  CLOSE GRUPOS
	IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
	 RETU                                            // volta ao menu anterior
	ENDI
 #else
	USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
	RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

 PTAB(M->rcodigo,[GRUPOS],1)
 mforma:=MAX(VAL(GRUPOS->formapgto),1)

 IF !PTAB(rcodigo+rtipo,[TAXAS],1)
  rcirc=[001]
 ELSE
  SELE TAXAS
  DO WHILE !EOF() .AND.codigo+tipo=rcodigo+rtipo
   rcirc:=circ
   vini_:=emissao_
   SKIP
  ENDD
  rcirc:=RIGHT('00'+ALLTRIM(STR(VAL(rcirc)+1)),3)
  vini_:=P00801F9(vini_,M->mforma+1)
 ENDI
// dbox(forma)
 SELE GRUPOS                                       // processamentos apos emissao
 DO WHIL !EOF()
  FOR nparc=1 TO parcf
   nrcircax:=RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3)
   SELE TAXAS
   SEEK GRUPOS->codigo+rtipo+nrcircax
   IF EOF()
    SELE TAXAS                                      // arquivo alvo do lancamento

    #ifdef COM_REDE
     DO WHIL .t.
      APPE BLAN                                     // tenta abri-lo
      IF NETERR()                                   // nao conseguiu
       DBOX(ms_uso,20)                              // avisa e
       LOOP                                         // tenta novamente
      ENDI
      EXIT                                          // ok. registro criado
     ENDD
    #else
     APPE BLAN                                      // cria registro em branco
    #endi

    SELE GRUPOS                                     // inicializa registro em branco
    REPL TAXAS->codigo WITH codigo,;
	       TAXAS->stat    WITH [1],;
	       TAXAS->tipo WITH rtipo,;
	       TAXAS->circ WITH RIGHT('00'+ALLTRIM(STR(nparc+VAL(rcirc)-1)),3),;
         TAXAS->codlan WITH [PG]+dtos(date())+left(time(),2)+;
             substr(time(),4,2)+M->usuario

   ENDI
   IF TAXAS->valorpg=0
                            //P00801F9(vini_,nparc),;
    REPL TAXAS->emissao_ WITH P00801F9(vini_,(nparc-1)*M->mforma+1),;
	       TAXAS->valor    WITH M->vlparc,;
	       TAXAS->cobrador WITH cobrador,;
         TAXAS->forma    WITH [ ]

    #ifdef COM_REDE
     TAXAS->(DBUNLOCK())                            // libera o registro
    #endi
   ENDI
   SELE GRUPOS
  NEXT
	exit
 ENDD
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
// ALERTA(2)
// DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
//CLOSE ALL                                          // fecha todos os arquivos e
RESTSCREEN(,0,MAXROW(),79,tela_fp007)                // restaura tela do fundo
RETU                                               // volta para o menu anterior

* \\ Final de ADP_P007.PRG
