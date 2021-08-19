procedure adm_outr
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

#include "admbig.ch"    // inicializa constantes manifestas


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

FUNCTION BARCODE
PARA vcod,SP_C
if pcount() = 0
 return ''
endif
vlin = 0
k_ESC = CHR(27)
vcop= 1
xcont= 0

do while (xcont < vcop)
 twdefsalto(8)
 twdefalt(8)
 twdefcode(twc25)
 @ PRow() + 1,  SP_C say Space(1)

 twdefalt(8)
 twimpcod(vcod)
 twdefsalto(8)
 @ PRow() + 1,  SP_C say Space(1)
 twdefalt(8)
 twimpcod(vcod)
 twdefsalto(8)
 @ PRow() + 1,  SP_C say Space(1)
 twdefalt(8)
 twimpcod(vcod)
 twdefsalto(12)
 @ PRow() + 1,  SP_C say Space(1)
 ***********
 ****************
 xcont=xcont+1
 @ PRow() + vlin,  5 say Space(1)
enddo
* @ PRow() + 1,  5 say Space(1)
* set device to screen
return ''
* EOF
********************

procedure twinic
public twean13, twean8, twupca, twupce, twc25, twc39
public twepson, twlaser
public twcode, twprinter, twlbarf, twlbarg, twaltura, twround, twsource, twmaxalt
public twnulo, twmaxround
twean13 = 1
twean8 = 2
twupca = 3
twupce = 4
twc25 = 5
twc39 = 6
twepson = 1
twlaser = 2

twcode = twean13
twprinter = twepson
twlbarf = 1
twlbarg = 3
twaltura = 8
twround = 12
twsource = ''
twmaxalt = 3000
twmaxround = 100
twnulo = chr (0)
return

procedure twdefcode
parameters twcodetype
do case
   case twcodetype = twean13 .or. twcodetype = twean8 .or. twcodetype = twupca .or. twcodetype = twupce .or. twcodetype = twc25 .or. twcodetype = twc39
      twcode = twcodetype
endcase
return

procedure twdefprint
parameters twprinttyp
do case
   case twprinttyp = twepson .or. twprinttyp = twlaser
      twprinter = twprinttyp
endcase
return

procedure twdeflbars
parameters twfina, twgrossa
if twfina < 1
   twfina = 1
endif
if twgrossa >= twfina
   twlbarg = twgrossa
   twlbarf = twfina
endif
return

procedure twdefalt
parameters twalt
twaltura = twalt
if twaltura > twmaxalt
   twaltura = twmaxalt
endif
return

procedure twdefround
parameters twroundval
twround = twroundval
if twround > twmaxround
   twround = twmaxround
endif
return

procedure twdefsalto
parameters twsalto
@ prow (), pcol () say chr (27) + 'A' + chr (twsalto)
return

function twhpaltura
parameters twalt
return chr (27) + '*c' + transform (twalt, '9999') + 'B'

function twhpavanco
parameters twavanco
return chr (27) + '*p+' + transform (twavanco, '9999') + 'X'

procedure twajusta
if twprinter = twlaser
   @ prow (), pcol () say chr (27) + '&f0S' + chr (27) + '*p-30Y'
endif
return

procedure twrecup
if twprinter = twlaser
   @ prow (), pcol () say chr (27) + '&f1S'
endif
return

function twhpretang
parameters twavanco
return chr (27) + '*c' + transform (twavanco, '9999') + 'a0P' + twhpavanco (twavanco)

function twcalcdig
parameters twsrc
twk = 0
for twi = len (twsrc) to 1 step -1
   twj = val (substr (twsrc, twi, 1))
   if mod (len (twsrc) - twi, 2) = 0
      twj = twj * 3
   endif
   twk = twk + twj
next
twk = mod (10 - mod (twk, 10), 10)
return chr (twk + 48)

function twvalidnum
parameters twsrc, twsrclen
if twsrclen = 0
   twsrclen = len (twsrc)
endif
twflag = .t.
do while len (twsrc) < twsrclen
   twsrc = '0' + twsrc
enddo
for twi = 1 to twsrclen
   twflag = twflag .and. at (substr (twsrc, twi, 1), '0123456789') > 0
next
if twflag
   twsource = twsrc
endif
return twflag

function twvalidc39
parameters twsrc
if substr (twsrc, 1, 1) = '*'
   twsrc = substr (twsrc, 2, len (twsrc))
endif
if substr (twsrc, len (twsrc), 1) = '*'
   twsrc = substr (twsrc, 1, len (twsrc) - 1)
endif
twflag = .t.
for twi = 1 to len (twsrc)
   twflag = twflag .and. at (upper (substr (twsrc, twi, 1)), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ- $/+%.') > 0
next
if twflag
   twsource = '*' + twsrc + '*'
endif
return twflag

function twvalid
parameters twsrc
twflag = .f.
twi = twcode
do case
   case twi = twean13
      twflag = twvalidnum (twsrc, 12)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twean8
      twflag = twvalidnum (twsrc, 7)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twupca
      twflag = twvalidnum (twsrc, 12)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twupce
      twflag = twvalidnum (twsrc, 7)
      if twflag
	 twsource = twsource + twcalcdig (twsource)
      endif
   case twcode = twc25
      twflag = twvalidnum (twsrc, 0)
      if twflag .and. mod (len (twsrc), 2) = 1
	 twsource = '0' + twsource
      endif
   case twcode = twc39
      twflag = twvalidc39 (twsrc)
endcase
return twflag

function twtam
parameters twsrc
twtamanho = 0
if twvalid (twsrc)
   do case
      case twcode = twean13
	 twtamanho = twlbarf * 95
      case twcode = twean8
	 twtamanho = twlbarf * 67
      case twcode = twupca
	 twtamanho = twlbarf * 95
      case twcode = twupce
	 twtamanho = twlbarf * 51
      case twcode = twc25
	 twtamanho = 6 * twlbarf + twlbarg + len (twsrc) * (3 * twlbarf + 2 * twlbarg)
      case twcode = twc39
	 twtamanho = (7 * twlbarf + 3 * twlbarg) * len (twsrc) - 1
      otherwise
	 twtamanho = 0
   endcase
endif
return twtamanho

function twtamr
parameters twsrc
twi = twtam (twsrc)
do while mod (twi, twround) != 0
   twi = twi + 1
enddo
return twi

function twtamchar
parameters twsrc
return int (twtamr (twsrc) / twround)

function tword39
parameters twchar
return at (upper (twchar), '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*')

procedure twimpean13
private twalt [8]
private twcodigo1 [10], twcodigo2 [10], twcodigo3 [10], twtab7a12 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo2 [1] = '0100111'
twcodigo2 [2] = '0110011'
twcodigo2 [3] = '0011011'
twcodigo2 [4] = '0100001'
twcodigo2 [5] = '0011101'
twcodigo2 [6] = '0111001'
twcodigo2 [7] = '0000101'
twcodigo2 [8] = '0010001'
twcodigo2 [9] = '0001001'
twcodigo2 [10] = '0010111'
twcodigo3 [1] = '1110010'
twcodigo3 [2] = '1100110'
twcodigo3 [3] = '1101100'
twcodigo3 [4] = '1000010'
twcodigo3 [5] = '1011100'
twcodigo3 [6] = '1001110'
twcodigo3 [7] = '1010000'
twcodigo3 [8] = '1000100'
twcodigo3 [9] = '1001000'
twcodigo3 [10] = '1110100'
twtab7a12 [1] = '111111'
twtab7a12 [2] = '221211'
twtab7a12 [3] = '212211'
twtab7a12 [4] = '122211'
twtab7a12 [5] = '221121'
twtab7a12 [6] = '211221'
twtab7a12 [7] = '112221'
twtab7a12 [8] = '212121'
twtab7a12 [9] = '122121'
twtab7a12 [10] = '121221'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO' + substr (twtab7a12 [twl], 8 - twi, 1)
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	 endif
      next
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO' + substr (twtab7a12 [twl], 8 - twi, 1)
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	 endif
      next
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpean8
private twalt [8]
private twcodigo1 [10], twcodigo3 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo3 [1] = '1110010'
twcodigo3 [2] = '1100110'
twcodigo3 [3] = '1101100'
twcodigo3 [4] = '1000010'
twcodigo3 [5] = '1011100'
twcodigo3 [6] = '1001110'
twcodigo3 [7] = '1010000'
twcodigo3 [8] = '1000100'
twcodigo3 [9] = '1001000'
twcodigo3 [10] = '1110100'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 1 to 8
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 4
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
	 if twi = 4
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	 endif
      next
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 1 to 8
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 4
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
	 if twi = 4
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	 endif
      next
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpupca
private twalt [8]
private twcodigo1 [10], twcodigo3 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo3 [1] = '1110010'
twcodigo3 [2] = '1100110'
twcodigo3 [3] = '1101100'
twcodigo3 [4] = '1000010'
twcodigo3 [5] = '1011100'
twcodigo3 [6] = '1001110'
twcodigo3 [7] = '1010000'
twcodigo3 [8] = '1000100'
twcodigo3 [9] = '1001000'
twcodigo3 [10] = '1110100'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	    @ prow (), pcol () say replicate (twchar, twlbarf)
	    @ prow (), pcol () say replicate (twnulo, twlbarf)
	 endif
      next
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 1, 1)) + 1
      for twi = 2 to 13
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    if twi <= 7
	       twm = 'TWCODIGO1'
	    else
	       twm = 'TWCODIGO3'
	    endif
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
	 if twi = 7
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	    @ prow (), pcol () say twhpretang (twlbarf)
	    @ prow (), pcol () say twhpavanco (twlbarf)
	 endif
      next
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpupce
private twalt [8]
private twcodigo1 [10], twcodigo2 [10], twtab2a7 [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo1 [1] = '0001101'
twcodigo1 [2] = '0011001'
twcodigo1 [3] = '0010011'
twcodigo1 [4] = '0111101'
twcodigo1 [5] = '0100011'
twcodigo1 [6] = '0110001'
twcodigo1 [7] = '0101111'
twcodigo1 [8] = '0111011'
twcodigo1 [9] = '0110111'
twcodigo1 [10] = '0001011'
twcodigo2 [1] = '0100111'
twcodigo2 [2] = '0110011'
twcodigo2 [3] = '0011011'
twcodigo2 [4] = '0100001'
twcodigo2 [5] = '0011101'
twcodigo2 [6] = '0111001'
twcodigo2 [7] = '0000101'
twcodigo2 [8] = '0010001'
twcodigo2 [9] = '0001001'
twcodigo2 [10] = '0010111'
twtab2a7 [1] = '222111'
twtab2a7 [2] = '221211'
twtab2a7 [3] = '221121'
twtab2a7 [4] = '221112'
twtab2a7 [5] = '212211'
twtab2a7 [6] = '211221'
twtab2a7 [7] = '211122'
twtab2a7 [8] = '212121'
twtab2a7 [9] = '212112'
twtab2a7 [10] = '211212'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      twl = val (substr (twsource, 8, 1)) + 1
      for twi = 2 to 7
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    twm = 'TWCODIGO' + substr (twtab2a7 [twl], twi - 1, 1)
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say replicate (twchar, twlbarf)
	    else
	       @ prow (), pcol () say replicate (twnulo, twlbarf)
	    endif
	 next
      next
      @ prow (), pcol () say replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf)
      twl = val (substr (twsource, 8, 1)) + 1
      for twi = 2 to 7
	 twj = val (substr (twsource, twi, 1)) + 1
	 for twk = 1 to 7
	    twm = 'TWCODIGO' + substr (twtab2a7 [twl], twi - 1, 1)
	    if substr (&twm [twj], twk, 1) = '1'
	       @ prow (), pcol () say twhpretang (twlbarf)
	    else
	       @ prow (), pcol () say twhpavanco (twlbarf)
	    endif
	 next
      next
      @ prow (), pcol () say twhpavanco (twlbarf) + twhpretang (twlbarf)
      @ prow (), pcol () say twhpavanco (twlbarf) + twhpretang (twlbarf)
      @ prow (), pcol () say twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpc25
private twalt [8]
private twcodigo [10]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo [1] = '00110'
twcodigo [2] = '10001'
twcodigo [3] = '01001'
twcodigo [4] = '11000'
twcodigo [5] = '00101'
twcodigo [6] = '10100'
twcodigo [7] = '01100'
twcodigo [8] = '00011'
twcodigo [9] = '10010'
twcodigo [10] = '01010'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      @ prow (), pcol () say replicate (twchar, twlbarf) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf) + replicate (twnulo, twlbarf)
      for twi = 1 to len (twsource) / 2
	 twk = val (substr (twsource, twi * 2 - 1, 1)) + 1
	 twl = val (substr (twsource, twi * 2, 1)) + 1
	 for twj = 1 to 5
	    if substr (twcodigo [twk], twj, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if substr (twcodigo [twl], twj, 1) = '1'
	       twn = twlbarg
	    else
	       twn = twlbarf
	    endif
	    @ prow (), pcol () say replicate (twchar, twm) + replicate (twnulo, twn)
	 next
      next
      @ prow (), pcol () say replicate (twchar, twlbarg) + replicate (twnulo, twlbarf) + replicate (twchar, twlbarf)
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      @ prow (), pcol () say twhpretang (twlbarf) + twhpavanco (twlbarf) + twhpretang (twlbarf) + twhpavanco (twlbarf)
      for twi = 1 to int (len (twsource) / 2)
	 twk = val (substr (twsource, twi * 2 - 1, 1)) + 1
	 twl = val (substr (twsource, twi * 2, 1)) + 1
	 for twj = 1 to 5
	    if substr (twcodigo [twk], twj, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if substr (twcodigo [twl], twj, 1) = '1'
	       twn = twlbarg
	    else
	       twn = twlbarf
	    endif
	    @ prow (), pcol () say twhpretang (twm) + twhpavanco (twn)
	 next
      next
      @ prow (), pcol () say twhpretang (twlbarg) + twhpavanco (twlbarf) + twhpretang (twlbarf)
endcase
return

procedure twimpc39
private twalt [8]
private twcodigo [44]
twalt [1] = chr (255)
twalt [2] = chr (128)
twalt [3] = chr (192)
twalt [4] = chr (224)
twalt [5] = chr (240)
twalt [6] = chr (248)
twalt [7] = chr (252)
twalt [8] = chr (254)
twcodigo [1] = '000110100'
twcodigo [2] = '100100001'
twcodigo [3] = '001100001'
twcodigo [4] = '101100000'
twcodigo [5] = '000110001'
twcodigo [6] = '100110000'
twcodigo [7] = '001110000'
twcodigo [8] = '000100101'
twcodigo [9] = '100100100'
twcodigo [10] = '001100100'
twcodigo [11] = '100001001'
twcodigo [12] = '001001001'
twcodigo [13] = '101001000'
twcodigo [14] = '000011001'
twcodigo [15] = '100011000'
twcodigo [16] = '001011000'
twcodigo [17] = '000001101'
twcodigo [18] = '100001100'
twcodigo [19] = '001001100'
twcodigo [20] = '000011100'
twcodigo [21] = '100000011'
twcodigo [22] = '001000011'
twcodigo [23] = '101000010'
twcodigo [24] = '000010011'
twcodigo [25] = '100010010'
twcodigo [26] = '001010010'
twcodigo [27] = '000000111'
twcodigo [28] = '100000110'
twcodigo [29] = '001000110'
twcodigo [30] = '000010110'
twcodigo [31] = '110000001'
twcodigo [32] = '011000001'
twcodigo [33] = '111000000'
twcodigo [34] = '010010001'
twcodigo [35] = '110010000'
twcodigo [36] = '011010000'
twcodigo [37] = '010000101'
twcodigo [38] = '110000100'
twcodigo [39] = '011000100'
twcodigo [40] = '010101000'
twcodigo [41] = '010100010'
twcodigo [42] = '010001010'
twcodigo [43] = '000101010'
twcodigo [44] = '010010100'
do case
   case twprinter = twepson
      twsize = twtamr (twsource)
      twchar = twalt [mod (twaltura, 8) + 1]
      @ prow (), pcol () say chr (27) + 'L' + chr (mod (twsize, 256)) + chr (int (twsize / 256))
      for twi = 1 to len (twsource)
	 twj = tword39 (substr (twsource, twi, 1))
	 for twk = 1 to 9
	    if substr (twcodigo [twj], twk, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if mod (twk, 2) = 1
	       @ prow (), pcol () say replicate (twchar, twm)
	    else
	       @ prow (), pcol () say replicate (twnulo, twm)
	    endif
	 next
	 @ prow (), pcol () say replicate (twnulo, twlbarf)
      next
      @ prow (), pcol () say replicate (twnulo, twsize - twtam (twsource))
   case twprinter = twlaser
      @ prow (), pcol () say twhpaltura (twaltura)
      for twi = 1 to len (twsource)
	 twj = tword39 (substr (twsource, twi, 1))
	 for twk = 1 to 9
	    if substr (twcodigo [twj], twk, 1) = '1'
	       twm = twlbarg
	    else
	       twm = twlbarf
	    endif
	    if mod (twk, 2) = 1
	       @ prow (), pcol () say twhpretang (twm)
	    else
	       @ prow (), pcol () say twhpavanco (twm)
	    endif
	 next
	 @ prow (), pcol () say twhpavanco (twlbarf)
      next
endcase
return

procedure twimpcod
parameters twsrc
if twvalid (twsrc)
   twajusta ()
   do case
      case twcode = twean13
	 do twimpean13
      case twcode = twean8
	 do twimpean8
      case twcode = twupca
	 do twimpupca
      case twcode = twupce
	 do twimpupce
      case twcode = twc25
	 do twimpc25
      case twcode = twc39
	 do twimpc39
   endcase
   twrecup ()
endif
return

* \\ Final de R01801F9.PRG
* \\ Final de ADM_OUTR.PRG
