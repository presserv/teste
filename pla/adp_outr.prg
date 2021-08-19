procedure adp_outr
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADM_OUTR.PRG
 \ Data....: 23-07-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Define vari veis p£blicas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v2.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas


#ifdef COM_CALE
 PROC CALE      // Rotina para exibir calend rio

 /*
    Simplificando a estrutura CASE   (thank you Rick Spence!)
    tbc e' um vetor bidimensional que contem as teclas a serem testadas
    e suas respectivas acoes (dentro de "code blocks")
 */
 LOCAL cale_tela:=SAVESCREEN(0,0,MAXROW(),79), cor_atual:=SETCOLOR(),;
       col_dia, dia_1, lisu_:=6, cosu_:=58, liin_:=20, coin_:=79,;
       i_, cl_, vr_cale, m_e_s, a_n_o, ult_dia,;
       tbc:={;
              {K_DOWN, {||datac:=datac-30}},;
              {K_UP,   {||datac:=datac+30}},;
              {K_RIGHT,{||datac:=datac+365}},;
              {K_LEFT, {||datac:=datac-365}};
            }
 SETCOLOR(drvtitmsg)
 vr_cale=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_)      // posicao atual do calendario
 CAIXA(mold,lisu_,cosu_,liin_,coin_)                // monta tela de apresentacao
 SETCOLOR(drvcorenf)                                // do calendario
 @ lisu_+2,cosu_+1 SAY "Do 2a 3a 4a 5a 6a Sa"
 SETCOLOR(drvtitmsg)
 @ lisu_+ 9,cosu_+1 SAY REPL("Ä",coin_-cosu_-1)
 @ lisu_+10,cosu_+2 SAY " Incrementa o MES"        // montra teclas disponiveis
 @ lisu_+11,cosu_+2 SAY " Decrementa o MES"
 @ lisu_+12,cosu_+2 SAY CHR(26)+" Incrementa o ANO"
 @ lisu_+13,cosu_+2 SAY CHR(27)+" Decrementa o ANO"
 SETCOLOR(drvcormsg)
 DO WHIL .t.
  @ lisu_+1,cosu_+1 SAY PADL(TRIM(NMES(datac))+" - "+STR(YEAR(datac)),20)
  dia_1=DOW(datac-DAY(datac)+1)          // dia da semana do 1o. dia do mes
  cl_=lisu_+3
  @ cl_,cosu_+1 CLEAR TO liin_-6,coin_-1 // limpa area dos dias
  col_dia=1+cosu_+3*(dia_1-1)            // coluna inicai do 1o. dia do mes
  m_e_s=MONTH(datac)                     // mes
  a_n_o=YEAR(datac)                      // ano
  IF INT(m_e_s/2) = m_e_s/2              // acha ultimo dia do mes
   ult_dia=IF(m_e_s<8,IF(m_e_s=2,IF(INT(a_n_o/4)=a_n_o/4,29,28),30),31)
  ELSE
   ult_dia=IF(m_e_s<8,31,30)
  ENDI
  FOR i_=1 TO ult_dia                    // imprime os dias
   IF DAY(DATE())=i_                     // se for heje
    SETCOLOR(drvcorenf)                  // enfatiza
   ENDI
   @ cl_,col_dia SAY PADL(STR(i_,2),2)   // imprime o dia na tela
   SETCOLOR(drvcormsg)                   // retorna a cor normal
   col_dia+=3                            // proxima coluna
   IF dia_1/7=INT(dia_1/7)               // fim da tela do calendario
    cl_++ ; col_dia=cosu_+1              // passa para proxima linha
   ENDI
   dia_1++                               // proximo dia
  NEXT
  x=SETCURSOR(0)                         // apaga cursor, x=cursor atual

  #ifdef COM_MOUSE
   k=MOUSETECLA(lisu_+10,cosu_+2,liin_-1,cosu_+2)
  #else
   k=INKEY(0)                            // aguarda pressionar tecla
  #endi

  SETCURSOR(x)                           // volta tamanho original do cursor
  nm=ASCAN(tbc,{|ve_a| k=ve_a[1]})       // procura tecla dentro do vetor tbc (e' o CASE)
  IF nm!=0                               // achou!
   EVAL(tbc[nm,2])                       // portanto, executa a acao...
  ELSE
   IF k=K_ALT_F8                         // muda calendario de posicao
    MUDA_PJ(@lisu_,@cosu_,@liin_,@coin_,cale_tela,.t.)
    sinal_=" "
    PUBL &vr_cale.:=STR(lisu_,2)+STR(cosu_,2)
    SAVE TO (arqconf) ALL LIKE drv*      // salva as coordenadas em disco
   ELSE                                  // tecla sem acao, portanto,
    EXIT                                 // fora...
   ENDI
  ENDI
 ENDD
 RESTSCREEN(0,0,MAXROW(),79,cale_tela)   // restaura tela e
 SETCOLOR(cor_atual)                     // o esquema de cor

 #ifdef COM_MOUSE
  IF drvmouse                            // se o mouse esta' ativo
   DO WHIL MOUSEGET(0,0)!=0              // espera que os botoes sejam
   ENDD                                  // liberados (nao pressionados)
  ENDI
 #endi

 RETU
#endi


#ifdef COM_MAQCALC
 PROC MAQCALC      // Apresenta "pop-calculadora"
 LOCAL tela_c:=SAVESCREEN(0,0,MAXROW(),79), cur_sor:=SETCURSOR(1),;
       getlist:={}, vr_calc, pg_up, pg_dn, tec_f3, tec_f4, tec_f9, tec_f8
 PRIV  sinal_:=" ", num_disp, fgpaste, cor_calc:=SETCOLOR(),;
       lisu_:=1, cosu_:=40, liin_:=9, coin_:=64, sinal_ant:=" "
 vr_calc=NOVAPOSI(@lisu_,@cosu_,@liin_,@coin_) // pega posicao atual da calculadora
 fgpaste=(!EMPT(READVAR()).AND.;   // ve se ha campo pendente (captura)
         LEFT(READVAR(),4)!="OPC_")
 SETKEY(K_F6,NIL)                  // evita recursividade
 pg_up =SETKEY(K_PGUP,NIL)         // desabilita PgUp,
 pg_dn =SETKEY(K_PGDN,NIL)         // PgDn,
 tec_f3=SETKEY(K_F3,NIL)           // F3,
 tec_f4=SETKEY(K_F4,NIL)           // F4,
 tec_f9=SETKEY(K_F9,NIL)           // F9 e move caixa ( ALT-F8 )
 tec_f8=SETKEY(K_ALT_F8,{||sinal_dig()})

 SETKEY(35 ,{||sinal_dig()})       // #   raiz quadrada
 SETKEY(36 ,{||sinal_dig()})       // $   inteiro/flutuante
 SETKEY(37 ,{||sinal_dig()})       // %   percentual
 SETKEY(42 ,{||sinal_dig()})       // *   multiplica
 SETKEY(43 ,{||sinal_dig()})       // +   soma
 SETKEY(45 ,{||sinal_dig()})       // -   subtrai
 SETKEY(47 ,{||sinal_dig()})       // /   divide
 SETKEY(61 ,{||sinal_dig()})       // =   total
 SETKEY(94 ,{||sinal_dig()})       // ^   exponencial
 SETKEY(99 ,{||sinal_dig()})       // c   limpa display
 SETKEY(67 ,{||sinal_dig()})       // C
 IF fgpaste
  SETKEY(82 ,{||sinal_dig()})      // R   captura resultado do display
  SETKEY(114,{||sinal_dig()})      // r
 ENDI
 SETCOLOR(drvcormsg)
 CAIXA(mold,lisu_,cosu_,liin_,coin_)
 @ lisu_+1,cosu_+2 SAY "ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»"
 @ lisu_+2,cosu_+2 SAY "³                   ³"
 @ lisu_+3,cosu_+2 SAY "³                   ³"
 @ lisu_+4,cosu_+2 SAY "ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼"
 @ lisu_+5,cosu_+2 SAY " 7 8 9 C     +  -  * "
 @ lisu_+6,cosu_+2 SAY " 4 5 6 .  =  /  %  ^ "
 @ lisu_+7,cosu_+2 SAY " 1 2 3 0     "+CHR(K_ESC)+"  #  $ "
 SETCOLOR(drvcorget)
 @ lisu_+8,cosu_+2 SAY IF(fgpaste,"R, resultado no campo","")
 SETCOLOR(drvcorget+","+drvcorget+",,,"+drvcorget)
 DO WHIL .t.
  gab=IF(fgint,"   999999999999999",;     // mascara
               "999999999999999.99")
  num_disp=0.00                           // numero no display
  @ lisu_+2,cosu_+3 SAY "="
  @ lisu_+2,cosu_+4 GET nu_calc PICT gab  // mostra total
  CLEAR GETS
  @ lisu_+3,cosu_+3 SAY sinal_ant
  @ lisu_+3,cosu_+4 GET num_disp PICT gab // capta operando
  READ
  DO CASE
   CASE LASTKEY()=K_ESC.OR.sinal_="R"     // finalizou
    IF fgpaste.AND.sinal_="R"
     KEYB ALLTRIM(TRAN(nu_calc,gab))      // joga resultado no campo
    ENDI
    EXIT                                  // e sai
   CASE sinal_="AF8"                      // muda calculadora de posicao
    MUDA_PJ(@lisu_,@cosu_,@liin_,@coin_,tela_c,.t.)
    sinal_=" "
    PUBL &vr_calc.:=STR(lisu_,2)+STR(cosu_,2)
    SAVE TO (arqconf) ALL LIKE drv*       // salva as coordenadas em disco
   CASE sinal_="$"                        // chaveou inteiro/decimal
    fgint=(!fgint); sinal_=" "
   CASE sinal_="C"                        // limpa display
    nu_calc=0; sinal_=" "
   CASE sinal_="#"                        // raiz quadrada
    IF !EMPTY(num_disp)                   // algum numero no display?
     IF sinal_ant="-"                     // op anterior=subtracao?
      nu_calc-=SQRT(num_disp)             // subtrai a raiz
     ELSE                                 // do display no resultado
      nu_calc+=SQRT(num_disp)             // senao, soma
     ENDI
    ELSE                                  // nao exite numero no
     nu_calc=SQRT(nu_calc)                // display, porisso
    ENDI                                  // calcula raiz do total
    sinal_=" "
   OTHERWISE
    DO CASE
     CASE sinal_ant="-"                   // subtrai
      nu_calc-=num_disp
     CASE sinal_ant="*"                   // multiplica
      nu_calc=nu_calc*num_disp
     CASE sinal_ant="/"                   // divide
      nu_calc=nu_calc/num_disp
     CASE sinal_ant="^"                   // eleva potencia
      nu_calc=nu_calc^num_disp
     CASE sinal_ant="%"                   // obtem percentual
      nu_calc=nu_calc/100*num_disp
     OTHERWISE                            // soma (+) ou sem operador
      nu_calc+=num_disp
   ENDC
  ENDC
  sinal_=IF(sinal_="="," ",sinal_)        // igual nao pode ser exibido
  sinal_ant=sinal_; sinal_=" "            // salva sinal digitado
 ENDD
 SETCOLOR(cor_calc)                       // volta com as cores anteriores
 SETCURSOR(cur_sor)                       // volta cursor com era antes
 SET KEY K_F6 TO maqcalc                  // reabilita calculadora (f6)
 SETKEY(35,NIL); SETKEY(36,NIL)           // desabilita as teclas
 SETKEY(37,NIL); SETKEY(42,NIL)           // utilizadas na operacao
 SETKEY(43,NIL); SETKEY(45,NIL)           // da calculadora
 SETKEY(47,NIL); SETKEY(67,NIL)
 SETKEY(94,NIL); SETKEY(99,NIL)
 SETKEY(82,NIL); SETKEY(114,NIL)
 SETKEY(61,NIL)
 SETKEY(K_PGUP,pg_up)                     // habilita teclas PgUp,
 SETKEY(K_PGDN,pg_dn)                     // PgDn,
 SETKEY(K_F3,tec_f3)                      // F3,
 SETKEY(K_F4,tec_f4)                      // F4,
 SETKEY(K_F9,tec_f9)                      // F9 e
 SETKEY(K_ALT_F8,tec_f8)                  // ALT-F8
 RESTSCREEN(0,0,MAXROW(),79,tela_c)       // restaura a tela
 RETU

 STATIC PROC SINAL_DIG  // Recebe sinal da calculadora
 sinal_=IF(LASTKEY()=K_ALT_F8,"AF8",;     // recebe sinal digitado e
        UPPER(CHR(LASTKEY())))            // forca saida do get com
 KEYB CHR(K_ENTER)                        // ENTER simulado
 RETU
#endi



/* Final de ADM_OUTR.PRG */
FUNC QMES
PARA INIC_1, FIM_1
IF PCOUNT() < 1     // Se nao passou data nenhuma,
 RETU MONTH(DATE()) // retorna o mˆs atual
ENDI
IF PCOUNT() = 1  // Se informado apenas uma data,
 fim_1 = DATE()
ENDI
IF TYPE([inic_1]) = [C]
 inic_1:=CTOD(inic_1)
ENDIF
IF TYPE([fim_1]) = [C]
 fim_1 = CTOD(fim_1)
ENDI
donex:=(YEAR(fim_1)-YEAR(inic_1))*12
donex+=MONTH(fim_1)-MONTH(inic_1)
IF DAY(fim_1) < DAY(inic_1)
 donex--
ENDI
RETU donex //INT((fim_1-inic_1)/30.44)

FUNC ATUVALOR
PARA P_TIPO,P_VALOR,P_DAT1,P_DAT2 // tipo da cobranca, valor e vencimento
IF PCOUNT() < 4
 P_DAT2:=DATE()
ENDI
// p_dat2++  //->Nao cobrar juros da data do pagamento. (11/01/2000)
v_add:=p_valor
IF p_dat1 < p_dat2                 // S¢ acerta os j  vencidos
 IF PTAB(p_tipo,'JUROS',1)         // S¢ acerta se houver na tabela de multa
  nrd:=(p_dat2 - p_dat1)           // Dias de atraso
	IF (nrd > JUROS->mltcaren)       // Se h  passou a carˆncia da multa...
	 v_add+=v_add * JUROS->multa/100 // Cobra multa
	ENDI
	IF (nrd > JUROS->jrscaren) // Se h  passou a carˆncia dos juros...
	 v_add+=p_valor * JUROS->juros / 30 * nrd /100  // Cobra juros
	ENDI
 ENDI
ENDI
RETU (INT((v_add+0.005)*100)/100) // Retorna o valor total com o acrescimo

FUNC PENDENTES
PARA mcod,venf_
LOCAL reg_dbf:=POINTER_DBF(), ct_tx:=0
IF pcount()=0
 mcod = codigo
 venf_:=DATE()
ELSEIF PCOUNT()=1
 venf_:=DATE()
ENDI

PTAB(Mcod,[TAXAS],1,.T.)
SELE TAXAS

DO WHILE !EOF() .AND. TAXAS->codigo=Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0
	SKIP
	LOOP
 ENDI
 IF TAXAS->emissao_ <= IIF(EMPT(M->venf_),DATE(),M->venf_)
	ct_tx++
 ENDI
 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU ct_tx       // <- Quantidade pendente

FUNC ULTIMATAXA
PARA mcod,mtipo
LOCAL reg_dbf:=POINTER_DBF(), dt_tx:=ctod('  /  /  ')
IF pcount()=0
 mcod = codigo
 mtipo=[]
ELSEIF PCOUNT()=1
 mtipo=[  ]
ENDI

PTAB(Mcod,[TAXAS],1,.T.)
SELE TAXAS

DO WHILE !EOF() .AND. TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->emissao_ > dt_tx
	 dt_tx:=TAXAS->emissao_
 ENDI
 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU dt_tx       // <- deve retornar um valor L¢GICO

FUNC RELAC(explivre,arqaux,campo)
PTab(explivre,arqaux)
set rela to explivre into &arqaux
retu campo

FUNC QTNRDEP
PARA mcod,mtip
LOCAL reg_dbf:=POINTER_DBF(), ct_tx:=0
IF pcount()=0
 mcod = codigo
 mtip=[8]
ELSEIF PCOUNT()=1
 mtip=[8]
ENDI

PTAB(Mcod,[INSCRITS],1,.T.)
SELE INSCRITS

DO WHILE !EOF() .AND. INSCRITS->codigo=Mcod //.AND.ct_tx < M->rpend
 IF INSCRITS->grau $ mtip
	ct_tx++
 ENDI
 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU ct_tx       // <- deve retornar um valor L¢GICO

FUNC c_BARRA(wparcodemp,wnumcef,wti1valtit)
   wti2numcef:=val(wnumcef)
   ctcodbarra:= "1049" + ;
      strzero(wti1valtit * 100, 14) + ;
      SubStr(wnumcef, 1, 10) + SubStr(wparcodemp, 1, 15)
   soma:= 0
   fator:= 2
   for i:= 43 to 1 step -1
      soma:= soma + Val(SubStr(ctcodbarra, i, 1)) * fator++
      fator:= iif(fator = 10, 2, fator)
   next
   digcodbar:= Str(iif(11 - soma % 11 <= 1 .OR. 11 - soma % 11 > 9, ;
      1, 11 - soma % 11), 1)
retu (SubStr(ctcodbarra, 1, 4) + digcodbar + ;
      SubStr(ctcodbarra, 5, 39))


PROC calc_idx
chave_=DTOS(DATE())+STRZERO(SECONDS(),5)
RETU (chave_+GDV1(chave_)+M->usuario)

/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform?tica - Limeira (19)3452.3712
 \ Programa: ADPBIG.PRG
 \ Data....: 03-08-2020
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Validação/habilitação de funcionamento do sistema
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: desenvolvido manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  DTOSVldChk : valida DV e compara as datas de cadastro e permissão do filtro (par_prs.dbf)
  DTOSVldTt(v_idx) : faz a validação da data codificada com seu DV
  DTOSVldDt(v_idx) : Retorna a data montada (AH03)=2020-08-03 -> retorna 03/08/2020
  byebye(done) : Apresenta uma janela padrão para a saída forçada do sistema
  DtoSWelco(vlnrdays): Apresenta mensagem quando for necessário atualizar (15 dias)
*/
function DTOSVldChk(m_idxd,m_idxm)
done_chk:=.T.
 /* m_idxd = data da geração na Presserv
    formato:  AMDDttnn
     A = contador de Ano iniciado em 2020 (2020=A, 2021=B, 2023=C
     M = Mes  (A=Jan, B=Fev, C=Mar, D=Abr,...)
     DD = Dia (01 a 31)
     tt = soma dos conteúdos AMDD (Ex.: 29/07/2020 = AG29 = tt=1+7+29 = 37
     nn = numero inteiro de 08 a 18 (será utilizado no dvcheq do m_idxm) 	 
  m_idxm = data limite de execução
     A = contador de Ano iniciado em 2020 (2020=A, 2021=B, 2023=C
     M = Mes  (A=Jan, B=Fev, C=Mar, D=Abr,...)
     DD = Dia (01 a 31)
     tt = soma dos conteúdos AMDD (Ex.: 29/07/2020 = AG29 = tt=1+7+29 = 37
     nn = DD + m_idxd->nn (validação do registro) 	  
 */
 m_idxd:=upper(m_idxd) 
 m_idxm:=upper(m_idxm) 
 done_chk:=DtosVldTt(m_idxd)  // verifica DV da primeira data 
 If (done_chk) 
  done_chk:=DtosVldTt(m_idxm)  // verifica DV da segunda data 
  if (done_chk)
   // data da liberação do uso tem que ser válida e data não pode ser futura
   done_chk:=!EMPT(DTOSVldDt(m_idxd)).AND. (DATE()>=DTOSVldDt(m_idxd))
   // data limite tem que ser válida
   done_chk:=done_chk.AND.!EMPT(DTOSVldDt(m_idxm))
   done_chk:=done_chk.AND.(DATE()<=DTOSVldDt(m_idxm))
  endi
 endif
 retu (done_chk)

 function DTOSVldTt(v_idx)  // retorna se dv da data é válido
  retu (StrZero(val(substr(v_idx,3,2))+(ASC(substr(v_idx,2,1))-64)+(ASC(substr(v_idx,1,1))-64),2)=;
   substr(v_idx,5,2))  // verifica DV da primeira data 

 function DTOSVldDt(v_idx)  // retorna a data montada
  retu CTOD(substr(v_idx,3,2)+; //dia [01-31]
            "/"+STRZERO(ASC(substr(v_idx,2,1))-64,2)+; // mes [A-L]
            "/20"+STRZERO(ASC(substr(v_idx,1))-45,2))  // ano (2020=A...)

 function byebye(done)
  MSG:="ATENCAO "+M->usuario+[|]+;
  done+"|"+;
  "Entre em contato com a PresServ Inform?tica Ltda.-ME|"+;
  "pelos telefones (19)3452.3712 ou 99886.3225."
  DBOX(msg,,,25)
 RETU 1

 function DtoSWelco(vlnrdays)
 IF vlnrdays <= 15
  MSG:="Seu PRAZO de utiliza‡„o est  se ESGOTANDO!!!|"+; 
			"Atualize seu Sistema ou entre em contato com a PresServ Inform tica|"+;
			"para sua Atualiza‡„o. Telefones (19)99886-3225 ou 3452.3712."
  DBOX(msg,,,15)
 ENDIF
 ultdtsave1:=dtoc(date())+netname()
 SAVE TO FUNBIG.SYS ALL LIKE ultdt*
retu .T.
