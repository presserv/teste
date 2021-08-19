/****
*  Funcao: GETSYS do Clipper (manipula o GET/READ)
*  OBS...: Este c¢digo foi modificado pela GAS INFORMèTICA
*          para suportar as implementaáîes feitas nos
*          programas gerados pelo GAS-Pro v2.0
*
*          IMPORTANTE!!!
*          Se for necess†rio alterar este c¢digo, compilar
*          com as opáîes   /m/n/l
*  -------------------------------------------------------
*/

#include "getexit.ch"
#include "inkey.ch"
#include "error.ch"
#include "set.ch"

#define K_UNDO          K_CTRL_U

// definicoes para a variavel sistema
#define O_CAMPO   12    // atributos dos campos do subsistema
#define   O_MASC   1    // mascara do campo
#define   O_TITU   2    // titulo do campo
#define   O_CMD    3    // comando especial (f8)
#define   O_DEFA   4    // default para o campo
#define   O_WHEN   5    // clausula when (pre validacao)
#define   O_CRIT   6    // expressao de validacao (critica)
#define   O_HELP   7    // texto de ajuda on-line do campo

// estado das vari†veis para o READ ativo
STATIC format
STATIC updated := .f.
STATIC killread
STATIC bumptop
STATIC bumpbot
STATIC lastexit
STATIC lastpos
STATIC activeget
STATIC readprocname
STATIC readprocline

// formato do arranjo usado para preservar o estado das vari†veis
#define GSV_KILLREAD            1
#define GSV_BUMPTOP             2
#define GSV_BUMPBOT             3
#define GSV_LASTEXIT            4
#define GSV_LASTPOS             5
#define GSV_ACTIVEGET           6
#define GSV_READVAR             7
#define GSV_READPROCNAME        8
#define GSV_READPROCLINE        9

#define GSV_COUNT               9

/***
*       READMODAL()
*       READ MODAL padrÑo em um arranjo de GETS
*/
FUNC READMODAL(listget)

LOCAL get,t,tx,x,co
LOCAL pos, l_24
LOCAL savedgetsysvars
PRIV msg_24
drvmouse=IF(TYPE("drvmouse")!="L",.f.,drvmouse)
drvautohelp=IF(TYPE("drvautohelp")!="L",.f.,drvautohelp)
IF (ValType(Format)=="B")
 EVAL(Format)
ENDI
IF (EMPTY(listget))                   // compatibiliza com Summer 87
 SETPOS(MAXROW()-1, 0)
 RETURN (.F.)                         // NOTE
ENDI
savedgetsysvars:= cleargetsysvars()   // preserva status das vari†veis
readprocname:= PROCNAME(1)            // estas serÑo usadas nas SET KEYs
readprocline:= PROCLINE(1)
IF drvmouse
 x="MOUSEBOX"
 &x.(0,0,MAXROW(),79)
 li:=co:= 1; msg_24=""
 l_24=SAVESCREEN(MAXROW(),0,MAXROW(),79)
 FOR t=1 TO 80
  msg_24+=SUBS(l_24,2*t-1,1)
 NEXT
ENDI
pos:= SETTLE(listget, 0)
IF TYPE("novapos")<>"L" .OR. ! novapos
 novapos=.F.
ELSE
 x="MOUSEGET"
 &x.(@li,@co); pos=-1
ENDI
tentardenovo=novapos
WHILE (pos<>0)
 IF pos>0
  get:= listget[pos]                  // pega prox GET da lista e o coloca
  POSTACTIVEGET(get)                  // no GET ativo
  IF (VALTYPE(get:reader)=="B")       // le o GET
   EVAL(get:reader, get)              // usa bloco de leitura do usu†rio
  ELSE
   GETREADER(get)                     // usa o leitor padrÑo
  ENDI
 ELSE
  Pos=0
 ENDI
 IF novapos                           // move para o pr¢x GET, baseado
  FOR t=1 TO LEN(listget)             // na condiáÑo de sa°da
   x="MOUSEGET"
   &x.(@li,@co)
   IF listget[t]:row=Li
    IF co>=listget[t]:col .AND. ;
        co<=listget[t]:col+LEN(TRANSFORM(EVAL(listget[t]:BLOCK),listget[t]:picture))-1
     pos=t; tentardenovo=.f.
     JOGANOBUFF(" ")
     Q_TEC(0)
     FOR tx=1 TO pos-1
      IF listget[tx]:postblock!=NIL
       IF !EVAL(listget[tx]:postblock)
        pos=tx
        EXIT
       ENDI
      ENDI
     NEXT
     EXIT
    ENDI
   ENDI
  NEXT
 ELSE
  pos:= SETTLE(listget, pos)
 ENDI
 novapos=tentardenovo
END
RESTOREGETSYSVARS(savedgetsysvars)           // restaura o estado das vari†veis
SETPOS(MAXROW()-1, 0)                        // compatibiliza Summer 87
IF drvmouse
 x="MOUSEGET"
 DO WHIL &x.(0,0)!=0
 ENDD
 IF brw .AND. TYPE("br_w")="O"
  x="MOUSEBOX"
  &x.(br_w:ntop-1,br_w:nleft-1,br_w:nbottom+1,br_w:nright+1)  // define janela do mouse
 ENDI
ENDI
RETURN (Updated)


/***
*       GETREADER()
*       READ Modal padrÑo de um GET simples
*/
PROC GETREADER(get)
LOCAL press, pp, Tecl_p, ar_db:=ALIAS(), n_cp, qt_lin_hlp, lihlp, tela_hlp,;
      c_box, t_box, tmp_, vlr_defa:=.f., ncol,nrow
PRIV im_aj_at_:=0
IF TYPE("op_menu")!="N" .OR. op_menu=1 .OR.;// se op_menu nao existir ou
   op_menu=4 .OR. (TYPE("cex_com_vl")!="U" .AND. op_menu = 5)               // for inclusao ou tela
 get:setfocus()                             // complementar entao ativa o GET
 tmp_=READVAR()
 IF !EMPT(get:cargo) .AND. EMPT(&tmp_.)     // se o campo esta vazio e pode ter valor inicial
  tmp_=get:cargo
  IF VALTYPE(tmp_)="A" .AND. LEN(tmp_)>2    // se o valor definido no "cargo"
   IF !EMPT(tmp_[3]).AND.EMPT(get:original) // e' o valor inicial
    tmp_=EVAL(&("{||"+tmp_[3]+"}"))         // pega o default
    lihlp=LEN(get:buffer)
    IF get:picture=NIL .OR. AT("@K",get:picture)>0 .OR. AT("@S",get:picture)>0
     pp="@X"
    ELSE
     pp=get:picture
    ENDI
    get:buffer:=LEFT(TRAN(tmp_,pp)+SPAC(lihlp),lihlp)
    get:assign()
    updated:= .T.
    vlr_defa:=.t.
   ENDI
  ENDI
 ENDI
 get:killfocus()                            // desativa o GET
ENDI
IF (GETPREVALIDATE(get))                    // le o GET se condiáÑo WHEN satisfeita
 get:setfocus()                             // ativa o GET para leitura
 IF vlr_defa                                // se teve default, prepara para
  get:clear := .t.                          // apagar se tecla diferente de letra
 ENDI
 WHILE (get:exitstate==GE_NOEXIT)
  lihlp=0
  IF (get:typeout)
   get:exitstate:= GE_ENTER
  ENDI
  WHILE (get:exitstate==GE_NOEXIT)           // aplica toques atÇ a sa°da
   IF im_aj_at_<2
    IF drvautohelp .AND. !EMPT(get:cargo)
     tmp_=get:cargo
     IF !EMPT(tmp_[1])
      qt_lin_hlp=CONTA("|",tmp_[1])+1
      IF get:row+qt_lin_hlp+3>MAXROW()
       IF get:row-qt_lin_hlp-3>=0
        lihlp=get:row-qt_lin_hlp-3
       ENDI
      ELSE
       lihlp=get:row+1
      ENDI
      IF lihlp>0
       tela_hlp=SAVESCREEN(0,0,MAXROW(),79)
       c_box=drvcorbox; t_box=drvtitbox
       drvcorbox=drvcorhlp; drvtitbox=drvtithlp
       DBOX(tmp_[1],lihlp,get:col+2,,.f.)
       drvcorbox=c_box; drvtitbox=t_box
      ENDI
     ENDI
    ENDI
    IF im_aj_at_=1
     DISPEND()                              // apresenta tela de uma vez so
    ENDI
   ENDI
   im_aj_at_=3
   IF drvmouse
    x="MOUSECUR"
    &x.(.t.)
    x="MOUSETECLA"
    tecl_p=&x.()
    novapos=.f.
    IF tecl_p=-100
     novapos=.t.
     tecl_p=K_UP
    ENDI
    GETAPPLYKEY(get,tecl_p)
   ELSE
    GETAPPLYKEY(get,Q_TEC(0))
   ENDI
   IF LASTKEY()=K_ALT_F1
    im_aj_at_=1; drvautohelp=!drvautohelp
   ELSEIF LASTKEY()=K_F8 .AND. !EMPT(get:cargo)
    tmp_=get:cargo
    IF !EMPTY(tmp_[2])
     nrow:= ROW()
     ncol:= COL()
     JOGANOBUFF(" "); Q_TEC(0)
     get:assign()
     AJUSTA_PICT(get)
     tmp_=EVAL(&("{||"+tmp_[2]+"}"))          // executa comando especial...
     IF !EMPT(tmp_)
      IF get:picture=NIL .OR. AT("@K",get:picture)>0 .OR. AT("@S",get:picture)>0
       pp="@X"
      ELSE
       pp=get:picture
      ENDI
      get:buffer:=PADR(TRAN(tmp_,pp),LEN(get:buffer))
      get:assign()
      get:display()
      updated:= .T.
      IF !SET(_SET_CONFIRM)
       get:exitstate:=GE_ENTER
      ENDI
     ENDI
     SETPOS(nrow, ncol)
    ENDI
   ENDI
   IF get:exitstate!=GE_NOEXIT .OR. im_aj_at_=1
    IF im_aj_at_=1
     DISPBEGIN()                              // monta tela na pagina de traz
    ENDI
    IF lihlp>0
     RESTSCR(0,0,MAXROW(),79,tela_hlp)
    ENDI
    IF im_aj_at_=1 .AND. op_menu!=3 .AND. op_menu!=4
     x="INFOSIS"
     &x.(.t.)
     get:display()
    ENDI
   ENDI
  END
  IF get:exitstate != GE_UP .AND.;            // se nao esta voltando campo
     get:exitstate != GE_ESCAPE               // e nao pressionou ESC
   AJUSTA_PICT(get)
   IF (!GETPOSTVALIDATE(get))                 // nÑo permite sa°da se condiáÑo
    im_aj_at_=0                               // VALID nao estiver satisfeita
    get:exitstate:= GE_NOEXIT
   ELSE
    IF !EMPT(get:cargo)                       // pode ter formulas?
     tmp_=get:cargo
     IF VALTYPE(tmp_)="A" .AND. LEN(tmp_)>3   // se existe a subscricao 4
      IF !EMPT(tmp_[4])                       // e ela nao esta vazia
       pp="IMP_FORM"
       FOR i_=1 TO LEN(tmp_[4])               // mostra todas as formulas
        &pp.(tmp_[4,i_])                      // requisitadas
       NEXT
      ENDI
     ENDI
    ENDI
   ENDI
  ENDI

 END
 get:killfocus()                              // desativa o GET
END
RETURN

/***
*       AJUSTA_PICT()
*       Ajust com "0" ou " " a direita do campo se mascara "999" ou "###"
*
*       OBS: o GET precisa estar com o foco.
*/
PROC AJUSTA_PICT(get)
LOCA tmp_
IF get:type=="C" .AND. get:picture!=NIL    // se o campo for do tipo caracter
 tmp_=STRTRAN(get:picture,"@K")            // tira @K se existir (valor inicial)
 IF UPPER(LEFT(tmp_,2))="@S" .AND. AT(" ",tmp_)>0
  tmp_ = SUBS(tmp_,AT(" ",tmp_)+1)
 ENDI
 IF REPL("9",LEN(get:buffer))==tmp_        // e a mascara tudo "9" entao
  get:buffer:=LPAD(get:buffer,"0")         // coloca "0" a esquerda
  get:assign()
  get:display()                            // mostra como ficou
 ELSEIF REPL("#",LEN(get:buffer))==tmp_    // se mascara tudo "#" entao
  get:buffer:=LPAD(get:buffer)             // coloca " " a esquerda
  get:assign()
  get:display()                            // mostra como ficou
 ENDI
ENDI
RETU

/***
*       GETAPPLYKEY()
*       Aplica um toque IN_KEY() a um GET
*
*       OBS: o GET precisa estar com o foco.
*/
PROC GETAPPLYKEY(get, key)
LOCAL ckey
LOCAL bkeyblock
        // check for SET KEY first
IF ((bKeyBlock:= SETKEY(key))<>NIL)          // primeiro verifica se h† SET KEY
 GETDOSETKEY(bkeyBlock, get)
 RETURN
ENDI
DO CASE
 CASE (key==K_UP)
  get:exitstate:= GE_UP
 CASE (key==K_SH_TAB)
  get:exitstate:= GE_UP
 CASE (key==K_DOWN)
  get:exitState:= GE_DOWN
 CASE (key==K_TAB)
  get:exitstate:= GE_DOWN
 CASE (key==K_ENTER)
  get:exitstate:= GE_ENTER
 CASE (key==K_ESC)
  IF (SET(_SET_ESCAPE))
   get:undo()
   get:exitstate:= GE_ESCAPE
  ENDI
 CASE (key==K_PGUP)
  get:exitstate:= GE_WRITE
 CASE (key==K_PGDN)
  get:exitstate:= GE_WRITE
 CASe (key==K_CTRL_HOME)
  get:exitstate:= GE_TOP
  #ifdef CTRL_END_SPECIAL
   CASE (key == K_CTRL_END)                  // ^W/^END ambos vÑo ao £ltimo GET
    get:exitstate:= GE_BOTTOM
  #else
   CASE (key==K_CTRL_W)
    get:exitstate:= GE_WRITE                 // ^W/^END ambos terminam o READ (default)
  #endif
 CASE (key==K_INS)
  SET(_SET_INSERT, !SET(_SET_INSERT))
  SHOWSCOREBOARD()
 CASE (key==K_UNDO)
  get:undo()
 CASE (key==K_HOME)
  get:home()
 CASE (key==K_END)
  get:end()
 CASE (key==K_RIGHT)
  get:right()
 CASE (key==K_LEFT)
  get:left()
 CASE (key==K_CTRL_RIGHT)
  get:wordright()
 CASE (key==K_CTRL_LEFT)
  get:wordleft()
 CASE (key==K_BS)
  get:backspace()
 CASE (key==K_DEL)
  get:delete()
 CASE (key==K_CTRL_T)
  get:delwordright()
 CASE (key==K_CTRL_Y)
  get:delend()
 CASE (key==K_CTRL_BS)
  get:delwordleft()
 OTHERWISE
  IF (key>=32 .AND. key<=255)
   ckey:= CHR(key)
   IF (get:type=="N" .AND. (ckey=="." .OR. ckey==","))
    get:todecpos()
   ELSE
    IF (SET(_SET_INSERT))
     get:insert(ckey)
    ELSE
     get:overstrike(ckey)
    ENDI
    IF (get:typeout .AND. !SET(_SET_CONFIRM))
     IF (SET(_SET_BELL))
      ?? CHR(7)
     ENDI
     get:exitstate:= GE_ENTER
    ENDI
   ENDI
  ENDI
ENDC
RETURN


/***
*       GETPREVALIDATE()
*       Testa a condiáÑo de entrada (cl†usula WHEN) para um GET
*/
FUNC GETPREVALIDATE(get)
LOCAL saveupdated
LOCAL when:= .T.
IF (get:preblock<>NIL)
 saveupdated:= updated
 when:= EVAL(get:preblock, get)
 IF when!=NIL .AND. VALTYPE(when)!="L"
  IF EMPTY(when)
   when=.t.
  ELSE
   when:=&when
   IF VALTYPE(when)!="L"
    IF when!=NIL .AND. !EMPT(when)
     get:setfocus()
     IF get:picture=NIL .OR. AT("@K",get:picture)>0 .OR. AT("@S",get:picture)>0
      pp="@X"
     ELSE
      pp=get:picture
     ENDI
     get:buffer:=PADR(TRAN(when,pp),LEN(get:buffer))
     get:assign()
     updated:= .T.
     IF !SET(_SET_CONFIRM) .AND. LASTKEY()!=K_UP
      JOGANOBUFF(CHR(K_ENTER))
     ENDI
     get:killfocus()
    ENDI
    when=.t.
   ENDI
  ENDI
 ENDI
 IF !when                                // Zera valor do campo se nao atendido
  get:setfocus()
  get:home()
  get:delend()
  get:assign()
  updated:= .T.
  get:killfocus()
 ENDI
 get:display()
 killread=.f.
 SHOWSCOREBOARD()
 updated:= saveupdated
ENDI
IF (killread)
 when:= .F.
 get:exitstate:= GE_ESCAPE               // provoca sa°da READMODAL()
ELSEIF (!when)
 get:exitstate:= GE_WHEN                 // pula para pr¢ximo get
ELSE
 get:exitstate:= GE_NOEXIT               // prepara para ediáÑo
ENDI
RETURN (when)


/***
*       GETPOSTVALIDATE()
*       Testa condiáÑo de n sa°da (cl†usula VALID) para um GET
*
*       NOTA: datas inv†lidas sÑo rejeitadas com o buffer preservado
*/
FUNC GETPOSTVALIDATE(get)
LOCAL saveUpdated
LOCAL changed, valid:= .T.
IF (get:exitstate==GE_ESCAPE)
 RETURN (.T.)
ENDI
IF (get:baddate())
 get:home()
 DATEMSG()
 SHOWSCOREBOARD()
 RETURN (.F.)
ENDI
IF (get:changed)                         // se ocorreu ediáÑo, designa o
 get:assign()                            // novo valor para a vari†vel
 updated:= .T.
ENDI
get:reset()                              // reforma o buffer de ediáÑo,
                                         // cursor na posiáÑo inicial e mostra
IF (get:postblock<>NIL)                  // checa condiáÑo, se especificada
 saveupdated:= updated
 SETPOS(get:row, get:col+LEN(get:buffer))// compatibiliza Summer 87
 valid:= EVAL(get:postblock, get)
 SETPOS(get:row, get:col)                // reseta posiáÑo de compatibilidade
 SHOWSCOREBOARD()
 get:updatebuffer()
 updated:= saveupdated
 IF (killread)
  get:exitstate:= GE_ESCAPE              // provoca sa°da READMODAL()
  valid:= .t.
 ENDI
ENDI
RETURN (valid)


/***
*       GETDOSETKEY()
*       Processa SET KEY durante a ediáÑo
*/
PROC GETDOSETKEY(keyblock, get)
LOCAL saveupdated
IF (get:changed )                        // se ocorreu ediáÑo, designa variavel
 get:assign()
 updated:= .t.
ENDI
saveupdated:= updated
EVAL(keyblock, readprocname, readprocline, readvar())
SHOWSCOREBOARD()
get:updatebuffer()
updated:= saveupdated
killread=.F.                             // manutenáÑo EVANDRO
IF (killread)
 get:exitstate:= GE_ESCAPE               // provoca sa°da READMODAL()
ENDI
RETURN


/**************************
*
*       serviáos READ
*
*/


/***
*       SETTLE()
*
*       Retorna nova posiáÑo num arranjo de objetos GET, baseado em:
*
*               - posiáÑo atual
*               - ExitState do objeto GET na posiáÑo corrente
*
*       NOTA o retorno de um valor 0 indica tÇrmino do READ
*       NOTA exitState do antigo GET Ç transferido para o novo GET
*/
STATIC FUNC SETTLE(listget, pos)
LOCAL exitState
IF (pos==0)
 exitstate:= GE_DOWN
ELSE
 exitstate:= listget[pos]:exitstate
ENDI
IF (exitState==GE_ESCAPE .OR. exitState==GE_WRITE)
 RETURN (0)
ENDI
IF (exitstate<>GE_WHEN)
 LastPos := pos                          // reseta estado da informaáÑo
 BumpTop := .f.
 BumpBot := .f.
ELSE
 exitstate:= lastexit                    // re-usa ultimo exitstate, nao
ENDI                                     // altera a informaáÑo


/***
        *       move
*/
DO CASE
 CASE (exitstate==GE_UP)
  pos --
 CASE ( exitstate==GE_DOWN)
  pos ++
 CASE ( exitstate==GE_TOP)
  pos := 1
  bumptop:= .T.
  exitstate:= GE_DOWN
 CASE (exitstate==GE_BOTTOM)
  pos:= LEN(listget)
  bumpbot:= .T.
  exitstate:= GE_UP
 CASE (exitState==GE_ENTER)
  pos ++
ENDC


/***
        *       bounce
*/
IF(pos==0)
 IF (!readexit() .AND. !bumpbot)
  bumptop:= .T.
  pos:= lastpos
  exitstate:= GE_DOWN
 ENDI
ELSEIF (pos==LEN(listget)+1)
 IF (!readexit() .AND. exitstate<>GE_ENTER .AND. !bumptop)
  bumpbot:= .T.
  pos:= lastpos
  exitstate:= GE_UP
 ELSE
  pos:= 0
 ENDI
ENDI

lastexit:= exitstate                     // estado de saida do registro
IF (pos<>0 )
 listget[pos]:exitstate:= exitstate
ENDI
RETURN (pos)



/***
*       POSTACTIVEGET()
*       Pos ativa o GET para  READVAR(), GETACTIVE()
*/
STATIC proc POSTACTIVEGET(get)
GETACTIVE(get)
READVAR(GETREADVAR(get))
SHOWSCOREBOARD()
RETURN


/***
*       CLEARGETSYSVARS()
*       Salva e limpa o estado READ das vari†veis
*       Retorna arranjo dos valores salvos
*
*       NOTA: O status de 'updated' Ç apagado porÇm nÑo salvo (compat. Summer 87)
*/
STATIC func CLEARGETSYSVARS()
LOCAL saved[GSV_COUNT]
saved[GSV_KILLREAD]:= killread
killread:= .F.
saved[GSV_BUMPTOP]:= bumptop
bumptop:= .F.
saved[GSV_BUMPBOT]:= bumpbot
bumpbot:= .F.
saved[GSV_LASTEXIT]:= lastexit
lastexit:= 0
saved[GSV_LASTPOS]:= lastpos
lastpos:= 0
saved[GSV_ACTIVEGET]:= GETACTIVE(NIL)
saved[GSV_READVAR]:= READVAR("")
saved[GSV_READPROCNAME]:= readprocname
readprocname:= ""
saved[GSV_READPROCLINE]:= readprocline
readprocline:= 0
updated:= .F.
RETURN (saved)


/***
*   RESTOREGETSYSVARS()
*       Restaura o estado do READ das vari†veis do arranjo de valores salvos
*
*       NOTA: status do 'updated' nÑo Ç restaurado (compat. Summer 87)
*/
STATIC proc RESTOREGETSYSVARS(saved)
killread:= saved[GSV_KILLREAD]
bumptop:= saved[GSV_BUMPTOP]
bumpbot:= saved[GSV_BUMPBOT]
lastexit:= saved[GSV_LASTEXIT]
lastpos:= saved[GSV_LASTPOS]
GETACTIVE(saved[GSV_ACTIVEGET])
READVAR(saved[GSV_READVAR])
READPROCNAME:= saved[GSV_READPROCNAME]
READPROCLINE:= saved[GSV_READPROCLINE]
RETURN


/***
*       GETREADVAR()
*       seta o valor READVAR() a partir de um GET
*/
STATIC func GETREADVAR(get)
LOCAL name:= UPPER(get:name)

//#ifdef SUBSCRIPT_IN_READVAR
LOCAL i

/*
        * Os codigos a seguir incluem subscriáîes no nome retornado por
        * esta funáÑo, se a vari†vel GET for um elementro de arranjo
        *
        * Subscriáîes sÑo recuperadas da vari†vel de instÉncia get:subscript
        *
        * NOTA: incompativel com Summer 87
*/

IF (get:subscript<>NIL)
 FOR i:= 1 TO LEN(get:subscript)
  name+= "["+LTRIM(STR(get:subscript[i]))+"]"
 NEXT
ENDI

//#endif

RETURN (name)


/**************************
*
*       serviáos do sistema
*
*/



/***
*   __setformat()
*       serviáo SET FORMAT
*/
FUNC __SetFormat(b)
format:= IF(VALTYPE(b)=="B",b,NIL)
RETURN (NIL)


/***
*       __killread()
*   serviáo CLEAR GETS
*/
PROC __killread()
killread:= .T.
RETURN


/***
*       GETACTIVE()
*/
FUNC GETACTIVE(g)
LOCAL oldactive:= activeget
IF( PCOUNT()>0)
 activeget:= g
ENDI
RETURN (oldactive)


/***
*       UPDATED()
*/
FUNC UPDATED()
RETURN (updated)


/***
*       readexit()
*/
FUNC readexit(lnew)
RETURN (SET(_SET_EXIT, lnew))


/***
*       READINSERT()
*/
FUNC READINSERT(lnew)
RETURN (SET(_SET_INSERT, lnew))



/**********************************
*
*       serviáos para compatibilidade
*
*/


// mostra coordenadas para o SCOREBOARD
#define SCORE_ROW              0
#define SCORE_COL              60


/***
*   SHOWSCOREBOARD()
*/
STATIC PROC showscoreboard()
LOCAL nrow, ncol
IF (SET(_SET_SCOREBOARD))
 nrow:= ROW()
 ncol:= COL()
 SETPOS(SCORE_ROW, SCORE_COL)
 DISPOUT(IF(SET(_SET_INSERT), "Ins", "   "))
 SETPOS(nrow, ncol)
ENDI
RETURN


/***
*       DATEMSG()
*/
STATIC proc DATEMSG()
LOCAL nrow, ncol
nrow:= ROW()
ncol:= COL()
ALERTA()
DBOX("Data incorreta!",21,,,,"ATENÄéO!")
SETPOS(nrow, ncol)
RETURN


/***
*   RANGECHECK()
*
*       NOTE: segundo parametro nÑo utilizado para compatibilizar v5.00
*/
FUNC RANGECHECK(get, junk, lo, hi)
LOCAL cmsg, nrow, ncol
LOCAL xvalue
IF (!get:changed)
 RETURN (.T.)
ENDI
xvalue:= get:varget()
IF (xvalue>=lo .AND. xvalue<=hi)
 RETURN (.T.)                                                                    // NOTE
ENDI

IF (SET(_SET_SCOREBOARD))
 cmsg:= "Limites: "+LTRIM(TRANSFORM(lo, "")) + ;
                  "-"+LTRIM(TRANSFORM(hi, ""))
 IF (LEN(cmsg)>MAXCOL())
  cmsg:=SUBSTR(cmsg, 1, MAXCOL())
 ENDI
 nrow:= ROW()
 ncol:= COL()
 SETPOS(SCORE_ROW, MIN(60, MAXCOL()-LEN(cmsg)))
 DISPOUT(cmsg)
 SETPOS(nrow, ncol)
 WHILE (NEXTKEY()==0)
 END

 SETPOS(SCORE_ROW, MIN(60, MAXCOL()-LEN(cmsg)))
 DispOut(SPACE(LEN(cmsg)))
 SETPOS(nrow, ncol)
ENDI
RETURN (.F.)

/***
*
*  ReadKill()
*
*/
FUNCTION ReadKill( lKill )

  LOCAL lSavKill := KillRead
//
//   IF ( PCOUNT() > 0 )
//      KillRead := lKill
//   ENDIF

RETURN ( lSavKill )

FUNC STORECARGO(msg_,get_,oq_)
IF EMPT(get_:cargo)
 get_:cargo:=ARRAY(4)
 get_:cargo[4]={}
ENDI
IF !EMPTY(msg_)
 IF oq_=4
  AADD(get_:cargo[oq_],msg_)
 ELSE
  get_:cargo[oq_]=msg_
 ENDI
ENDI
RETU

FUNC STOREALL(cp_,get_)
STORECARGO(sistema[op_sis,O_CAMPO,cp_,O_HELP],get_,1)
STORECARGO(sistema[op_sis,O_CAMPO,cp_,O_CMD],get_,2)
STORECARGO(sistema[op_sis,O_CAMPO,cp_,O_DEFA],get_,3)
IF !EMPT(sistema[op_sis,O_CAMPO,cp_,O_WHEN])
 get_:preblock:=&("{||"+CHR(34)+sistema[op_sis,O_CAMPO,cp_,O_WHEN]+CHR(34)+"}")
ENDI
IF !EMPT(sistema[op_sis,O_CAMPO,cp_,O_CRIT])
 get_:postblock:=&("{||CRIT("+CHR(34)+sistema[op_sis,O_CAMPO,cp_,O_CRIT]+CHR(34)+")}")
ENDI
RETU

// Final de GETSYS.PRG

