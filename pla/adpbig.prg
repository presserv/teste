
// *Acertos do arquivo principal
function main()
#include "hbgtinfo.ch"
#include "dbinfo.ch"
ntx:=""
drvautohelp:=.F.
Hb_GTInfo(HB_GTI_MOUSESTATUS, .F. )
setmode(25,80)
*--

REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_ES850C
REQUEST DESCEND, MTAB, VUF, VDV2, VCGC, NMES, VHORA, EXT
*--
// Vari�veis est�ticas utilizadas pela lib
Static11:= ""
Static13:= {}
Static14:= "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%"
Static15:= {"412321214","214321214","414321212","212341214","412341212","214341212","212321414","412321412","214321412","212341412","412123214","214123214","414123212", ;
"212143214","412143212","214143212","212123414","412123412","214123412","212143412","412121234","214121234","414121232","212141234","412141232","214141232","212121434", ;
"412121432","214121432","212141432","432121214","234121214","434121212", ;
"232141214","432141212","234141212","232121414","432121412","234121412","232141412","232323212","232321232","232123232","212323232",Nil}
Static16:= "0123456789"
Static17:= "212"
Static18:= "12121"
Static19:= {"1112212","1122112","1121122","1222212","1211122","1221112","1212222","1222122","1221222","1112122"}
Static20:= {"1211222","1221122","1122122","1211112","1122212","1222112","1111212","1121112","1112112","1121222"}
Static21:= {"2221121","2211221","2212211","2111121","2122211","2112221","2121111","2111211","2112111","2221211"}
Static22:= {"AAAAAA","AABABB","AABBAB","AABBBA","ABAABB","ABBAAB","ABBBAA","ABABAB","ABABBA","ABBABA"}
Static23:= {"22442","42224","24224","44222","22424","42422","24422","22244","42242","24242",Nil}
Static24:= {"11331","31113","13113","33111","11313","31311","13311","11133","31131","13131",Nil}
//	Hb_GTInfo(HB_GTI_MOUSESTATUS, .f. )  // mouse off
//	HB_SETCODEPAGE('ES850C')
//    HB_CDPSELECT('ES850C')
//	HB_LANGSELECT('PT')
*--
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADPBIG.PRG
 \ Data....: 24-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerenciador geral
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

// Rotina de validacao/bloqueio de data DTOS em substituicao ao hprot
// # include "bloqueio.ch"

#include "adpbig.ch"    // inicializa constantes manifestas
#include "MACHSIX.CH"

/*
   Funcoes chamadas dentro de macros
*/

REQUEST DESCEND, MTAB, VDV2, VUF, MMAA, DLAPSO, NMES, VCGC, LTOC

#include "ADP_PUBL.ch"  // contem variaveis publicas

******
PUBLIC aGauge
PUBLIC aGauge_alias:="     ", aGauge_count:=0
******
V0=SAVESCREEN(0,0,MAXROW(),79)
CLEA SCREEN

arredondar=LEFT(GETENV("ARREDONDA"),1)     // tenta variavel de ambiente
IF EMPT(arredondar)
 arredondar=[1] // Utilizado em EMC_01F9
ENDI
messaitaxa=LEFT(GETENV("SAITAXA"),2)       // tenta variavel de ambiente
IF EMPT(messaitaxa)
 messaitaxa=[0] // Utilizado em EMCARNE
ENDI

#ifdef COM_TUTOR
 PARAM arq_mac, acao_                        // recebe parametros
 acao_mac="D"                                // inicializa flag
 IF !EMPT(arq_mac) .AND. !EMPT(acao_)        // passou os dois paramentros
  acao_=UPPER(acao_)                         // acao em maiusculo
  IF SUBS(acao_,2,1)$'LGCA'.AND.LEN(acao_)=2 // acao e' valida?
   acao_=SUBS(acao_,2,1)                     // separa so a letra
   IF acao_ $ "LCA" .AND. !FILE(arq_mac)     // leitura, se o arq
    ALERTA(2)                                // nao existir vamos
    ? "Arquivo "+arq_mac+" n�o encontrado!"  // avisar e
    RETU                                     // voltar para os DOS
   ELSE
    IF acao_="G"                             // gravacao de tutorial
     IF FILE(arq_mac)                        // se o arq existir
      ALERTA(2)                              // pergunta se pode
      x="N"                                  // mata-lo...
      @ 10,20 SAY "Arquivo "+arq_mac+" j� existe sobrepor?" GET x PICT "!"
      READ
      CLEA SCREEN
      IF LASTKEY()=K_ESC .OR. x!="S"         // nao confirmou...
       ? "Execu��o interrompida!"            // da mensagem e
       RETU                                  // retorna para o DOS
      ENDI
      ERASE (arq_mac)                        // mata arq antigo
     ENDI
     handle_mac=FCREATE(arq_mac)             // cria um novo arq
    ELSE
     handle_mac=FOPEN(arq_mac,2)             // abre arq existente
		ENDI
    IF handle_mac=-1                         // se deu erro na abertura
     ? "N�o foi poss�vel utilizar "+arq_mac  // avisa e
     RETU                                    // retorna
    ENDI
    fat_mac=5                                // fator de tempo default
    acao_mac=acao_                           // seta a acao da macro
   END IF
  END IF
 ENDI
#endi

NAOPISCA()                   // habilita 256 cores (ega/vga)

/*
   rotina utilizando funcoes em assembly  para pegar o nome do programa
   que e  colocado pelo DOS no PSP (Program Segment Prefix) do programa
   que esta  sendo executado. O segmento do ambiente esta  no  endereco
   44/45 do segmento do PSP
*/
VAL_AX("6200")               // funcao 62h retorna segmento do PSP em BX
CALLINT("21")                // executa interrupt 21
x=VAL_BX()                   // pega o segmento do PSP
Sg=PEEK(x,44)+PEEK(x,45)*256 // calcula endereco do segmento de ambiente

/*
   Agora, procura no segmento de ambiente, por dois bytes ZERO seguidos.
   O nome do programa comeca 2 bytes apos os ZEROs
*/
x=0
DO WHIL .t.
 IF PEEK(Sg,x)=0             // este e o primeiro ZERO
  IF PEEK(Sg,x+1)=0          // se o proximo tambem for,
   x+=2                      // entao pula ambos
   EXIT                      // e sai
  ENDI
 ENDI
 x++                         // continua procurando
ENDD
direxe=""
IF PEEK(Sg,x)=1              // se este byte = 1, entao
 x+=2                        // o nome comeca aqui e vai
 DO WHIL PEEK(Sg,x)>0        // at� encontrar outro 0
	direxe+=CHR(PEEK(Sg,x))    // pega mais uma letra do nome
  x++
 ENDD
ENDI
direxe=UPPER(LEFT(direxe,RAT("\",direxe)))
arq_sos=direxe+"ADPBIG.SOS"  // nome do arquivo de ajuda
SET CENTURY ON               // datas com informa��o do s�culo DD/MM/AAAA
SETCANCEL(.f.)               // desativa ALT-C/BREAK
SET DATE BRIT                // datas no formato 'britasileiro`
SET EXAC OFF                 // comparacoes parciais habilitadas
SET SCOREBOARD OFF           // habilita uso da linha 0
SET WRAP ON                  // habilita rolagem de menus
SET KEY K_ALT_F2  TO doscom  // ALT-F2 ativa DOS-SHELL
SETKEY(K_INS,{||;            // muda tamanho do cursor quando inserindo
              IF(READINSERT(),SETCURSOR(1),SETCURSOR(3)),;
              READINSERT(!READINSERT());
             };
)


/*
   inicializa variaveis publicas
*/
msg:=cpord:=criterio:=chv_rela:=chv_1:=chv_2:=vr_memo := ""
op_sis:=cod_sos:=nucop:=op_posi:=op_menu :=1
nss=42
exrot:=AFILL(ARRAY(nss),""); usuario=""
datac=DATE()
nao_mostra:=l_s:=c_s:=c_i:=l_i := 0
tem_borda:=drvexcl:=drvvisivel := .t.
v_out:=gr_rela:=ve_outros:=cn:=fgrep:=drvmouse :=.f.
tem_t:=fgconf:=drvconf:=brw:=drvincl :=.f.
gcr=CHR(17)+CHR(217); nivelop=3
drvcara=CHR(250); mold="�Ŀ������Ĵ"
drvmenucen=.f.; drvfonte=3
drvporta="LPT1"
drvcortna="W/N*"; drvtittna="BG+/N*"
nemp="PresServ Inform�tica - Limeira (019)452.6623"
nsis="Administradora - PLANO"

#ifdef COM_MOUSE
 drvmouse=(MOUSE()>0)                   // verifica e inicializa mouse

 #ifdef COM_TUTOR
  IF acao_mac!="D"
   drvmouse=.f.
  ENDI
 #endi

 drvratH=8; drvratV=16                  // default da sensibilidade do mouse
 tpo_mouse=0
#endi

#ifdef COM_REDE
 ms_uso="Arquivo sendo acessado|COM EXCLUSIVIDADE"
#endi

#ifdef COM_LOCK
 pr_ok=__PPRJ(arq_sos,"��������������������")
 IF LEN(pr_ok)>0
  CLEAR
  ? pr_ok
  RETU
 ENDI
#endi

arqgeral="ADP"

#ifdef COM_REDE

 #undef COM_PROTECAO

 drvtempo=25
 ide_maq=RIGHT(ALLTRIM(NETNAME()),4)    // tenta pegar nome da estacao
 IF EMPTY(ide_maq)                      // se netname() retornou nulo,
  ide_maq=LEFT(GETENV("ESTACAO"),4)     // tenta variavel de ambiente ESTACAO
 ENDI

 /*
    Se rede, e se NETNAME() do Clipper ou ESTACAO retornam "", pede ao usuario
    a identificacao da estacao para gravar arquivos de configuracoes
    especificos para cada usuario da rede
 */
 IF EMPTY(ide_maq)                 // CA-Clipper nao reconheceu nome da estacao
  cod_sos=49                       // nem existe variavel ambiental,
  msgt="IDENTIFICA��O DA ESTA��O"  // entao, vamos solicitar ao usuario
  SET KEY K_F1 TO                  // desativa help
  ide_maq=DBOX("Nome da esta��o",,,,,msgt,SPAC(4),"@!",,"W+/N")
  SET KEY K_F1 TO help             // habilita F1 (help)
  IF LASTKEY()=K_ESC .OR.;         // desistiu...
     EMPTY(ide_maq)                // ou nao informou
   RESTSCREEN(0,0,MAXROW(),79,v0)  // restaura tela
   SETPOS(MAXROW()-1,1)            // cursor na penultima linha, coluna 1
   RETU                            // e volta ao DOS
  ENDI
 ENDI
 ide_maq="_"+ALLTRIM(ide_maq)
#else
 ide_maq="_temp"                   // nome do arquivo de configuracoes
#endi

ntxpw=direxe+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
arqconf=direxe+arqgeral+;          // nome do arquivo de configuracoes
        ide_maq+".sys"
IF FILE(arqconf)
 REST FROM (arqconf) ADDI          // restaura configuracoes gravadas
******
ntxpw=drverr+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
******

 #ifdef COM_MOUSE
  IF drvmouse
   drvmouse=(MOUSE()>0)            // verifica e inicializa mouse
   MOUSERAT(drvratH,drvratV)       // ajusta sensibilidade do mouse
  ENDI
 #else
  drvmouse=.f.
 #endi

 ******
 ntxpw=drverr+arqgeral+"PW"
 dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
 ******


ELSE

 /*
    cria variaveis default de cores, codigos de impressao, etc...
 */
 drvmarca := "Padr�o IBM"                     // nome da configuracao/marca impressora
 drvprn =1                                    // configuracao atual
 drvpadrao="1"                                // padrao da impressora
 drvtapg="CHR(27)+'C'+CHR(NNN)"               // tamanho da pagina
 drvpcom="CHR(15)"                            // ativa comprimido (17,5 cpp)
 drvtcom="CHR(18)"                            // desativa comprimido (17,5 cpp)
 drvpc20="CHR(30)+'5'"                        // ativa comprimido (20 cpp)
 drvtc20="CHR(30)+'0'"                        // desativa comprimido (20 cpp)
 drvpeli="CHR(30)+'2'"                        // ativa elite
 drvteli="CHR(30)+'0'"                        // desativa elite
 drvpenf="CHR(27)+'E'"                        // ativa enfatizado
 drvtenf="CHR(27)+'F'"                        // desativa enfatizado
 drvpexp="CHR(27)+'W'+CHR(1)"                 // ativa expansao
 drvtexp="CHR(27)+'W'+CHR(0)"                 // desativa expansao
 drvpde8="CHR(27)+'0'"                        // ativa 8 lpp
 drvtde8="CHR(27)+'2'"                        // desativa 8 lpp
 drvland=""                                   // ativa landscape (paisagem)
 drvport=""                                   // ativa portrait (retrato)
 drvsom=.f.                                   // tipo de saida/efeitos sonoro
 drvautohelp=.f.                              // ajuda automatica em campos
 drvdbf:=drvntx:=drverr := PADR(QUALDIR(),23) // diretorio dos dbf's, ntx's e erros.dbf
 drvcorpad="W+/BG"  ; drvcorbox="W+/B"        // cores default
 drvcormsg="W+/W"   ; drvcorenf="W+/R"
 drvcorget="GR+/N*" ; drvcortel="W+/B"
 drvcorhlp="BG+/B"  ; drvcortna="W/N*"
 drvtitpad="GR+/BG" ; drvtitbox="GR+/B"       // cores dos titulos default
 drvtitmsg="GR+/W"  ; drvtitenf="GR+/R"
 drvtitget="R+/N*"  ; drvtittel="GR+/B"
 drvtithlp="GR+/B"  ; drvtittna="BG+/N*"
 CBC1()
 ALERTA()
 cod_sos=2
 IF !PEGADIR(.t.)                  // se nao informou diretorios de trabalho
  RESTSCREEN(0,0,MAXROW(),79,v0)   // restaura tela
  SETPOS(MAXROW()-1,1)             // cursor na penultima linha, coluna 1
  RETU                             // de volta ao DOS
 ENDI

 ******
 ntxpw=drverr+arqgeral+"PW"
 dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
 ******

 /*
    cria arquivo de senha e o inicializa com o primeiro usuario
 */
 IF !FILE(dbfpw)                    // nao encontrou arquivo de senhas,
******
ntxpw=drverr+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                 // nomes dos arquivos de senhas
******
  DBCREATE(dbfpw,{;                 // entao, cria estrutura
                  {"pass"       ,"C", 6,0},;
                  {"nome"       ,"C",15,0},;
                  {"nace"       ,"C", 1,0},;
                  {"exgrupos"   ,"C",20,0},;
                  {"execob"     ,"C",20,0},;
                  {"exinscrits" ,"C",20,0},;
                  {"extaxas"    ,"C",20,0},;
                  {"excancels"  ,"C",20,0},;
                  {"exprcessos" ,"C",20,0},;
                  {"exemcarne"  ,"C",20,0},;
                  {"extcarnes"  ,"C",20,0},;
                  {"excstseg"   ,"C",20,0},;
                  {"exboletos"  ,"C",20,0},;
                  {"exlbxbolet" ,"C",20,0},;
                  {"exbxbolet"  ,"C",20,0},;
                  {"extxproc"   ,"C",20,0},;
                  {"extx2via"   ,"C",20,0},;
                  {"exclasses"  ,"C",20,0},;
                  {"exclprods"  ,"C",20,0},;
                  {"exarqgrup"  ,"C",20,0},;
                  {"exfcgrupo"  ,"C",20,0},;
                  {"exregiao"   ,"C",20,0},;
                  {"excobrador" ,"C",20,0},;
                  {"expcbrad"   ,"C",20,0},;
                  {"exfccob"    ,"C",20,0},;
                  {"excircular" ,"C",20,0},;
                  {"excprcirc"  ,"C",20,0},;
                  {"exfncs"     ,"C",20,0},;
                  {"exjuros"    ,"C",20,0},;
                  {"exhistoric" ,"C",20,0},;
                  {"excgrupos"  ,"C",20,0},;
                  {"excoecob"   ,"C",20,0},;
                  {"excinscrit" ,"C",20,0},;
                  {"exctaxas"   ,"C",20,0},;
                  {"exprodutos" ,"C",20,0},;
                  {"extfiliais" ,"C",20,0},;
                  {"extxentr"   ,"C",20,0},;
                  {"exbxrec"    ,"C",20,0},;
                  {"exalender"  ,"C",20,0},;
                  {"exbxfcc"    ,"C",20,0},;
                  {"exbxtxas"   ,"C",20,0},;
                  {"extrotxas"  ,"C",20,0},;
                  {"exmensag"   ,"C",20,0},;
                  {"excep"      ,"C",20,0},;
                  {"expar_adm"  ,"C",20,0};
                 };
  )

  #ifdef COM_REDE
   USEARQ(dbfpw,.t.,20,1,.f.)       // tenta abrir senhas, exclusivo
  #else
   USE (dbfpw)                      // abre arquivo de senhas
  #endi

  INDE ON pass TO (ntxpw)           // indexa pela password
  APPE BLAN                         // credencia usuario ficticio (1o. acesso)
  senha=PWORD(arqgeral)             // com senha = tres primeiras letras
  REPL nome WITH ENCRIPT(SPAC(15)),;
       pass WITH senha, nace WITH ENCRIPT("3")
  USE
 ENDI
ENDI

#ifdef COM_TUTOR
 IF acao_mac!="D"
  drvmouse=.f.
 ENDI
#endi

arq_prn=drverr+"PRINTERS.DBF"            // nome dbf de "drivers" da prn
IF !FILE(arq_prn)                        // se o arquivo de "drivers"
 DBCREATE(arq_prn,{;                     // de impressoras nao existir
                   {"marca" ,"C",15,0},;  // entao vamos cria-lo
                   {"porta" ,"C", 4,0},;
                   {"padrao","C", 1,0},;
                   {"tapg"  ,"C",40,0},;
                   {"pcom"  ,"C",40,0},;
                   {"tcom"  ,"C",40,0},;
                   {"pc20"  ,"C",40,0},;
                   {"tc20"  ,"C",40,0},;
                   {"peli"  ,"C",40,0},;
                   {"teli"  ,"C",40,0},;
                   {"penf"  ,"C",40,0},;
                   {"tenf"  ,"C",40,0},;
                   {"pexp"  ,"C",40,0},;
                   {"texp"  ,"C",40,0},;
                   {"pde8"  ,"C",40,0},;
                   {"tde8"  ,"C",40,0},;
                   {"land"  ,"C",40,0},;
                   {"port"  ,"C",40,0};
                  };
 )

 #ifdef COM_REDE
  USEARQ(arq_prn,.t.,20,1,.f.)      // tenta abrir configuracoes, exclusivo
 #else
  USE (arq_prn)                     // abre arquivo de configuracoes
 #endi

 APPE BLAN                          // inclui uma configuracao
 REPL marca  WITH drvmarca,;        // marca da impressora
      porta  WITH drvporta,;        // porta de saida
      padrao WITH drvpadrao,;       // padrao da impressora
      tapg   WITH drvtapg,;         // tamanho da pagina
      pcom   WITH drvpcom,;         // ativa comprimido (17,5 cpp)
      tcom   WITH drvtcom,;         // desativa comprimido (17,5 cpp)
      pc20   WITH drvpc20,;         // ativa comprimido (20 cpp)
      tc20   WITH drvtc20,;         // desativa comprimido (20 cpp)
      peli   WITH drvpeli,;         // ativa elite
      teli   WITH drvteli,;         // desativa elite
      penf   WITH drvpenf,;         // ativa enfatizado
      tenf   WITH drvtenf,;         // desativa enfatizado
      pexp   WITH drvpexp,;         // ativa expansao
      texp   WITH drvtexp,;         // desativa expansao
      pde8   WITH drvpde8,;         // ativa 8 lpp
      tde8   WITH drvtde8,;         // desativa 8 lpp
      land   WITH drvland,;         // ativa landscape
      port   WITH drvport           // ativa portrait
 USE
ENDI
MUDAFONTE(drvfonte)                 // troca a fonte de caracteres
corcampo=drvtittel                  // cor "unselected"
SETCOLOR(drvcorpad+","+drvcorget+",,,"+corcampo)
SET(_SET_DELETED,!drvvisivel)       // visibilidade dos reg excluidos
CBC1()

/*
   se informado drive A para criar arquivo, previne preparo do disquete
*/
IF ASC(drvdbf)=65.OR.ASC(drvntx)=65 // informou drive A
 ALERTA()
 cod_sos=1
 op_a=DBOX("Disco pronto|Cancelar a opera��o",,,E_MENU,,"DISCO DE DADOS EM "+LEFT(drvdbf,1))
 IF op_a!=1
  RESTSCREEN(0,0,MAXROW(),79,v0)    // restaura tela
  SETPOS(MAXROW()-1,1)              // cursor na penultima linha, coluna 1
  RETU
 ENDI
ENDI
AFILL(sistema:=ARRAY(nss+1),{})     // enche sistema[] com vetores nulos
ADP_ATRI()                          // enche sistema[] com atributos dos arquivos
ADP_ATR1()
ADP_ATR2()
ADP_ATR3()

/*
   verifica qual subscricao do vetor SISTEMA corresponde ao arquivo
   aberto na area selecionada
*/
qualsis={|db_f|db_:=db_f,ASCAN(sistema,{|si|si[O_ARQUI]==db_})}

#ifdef COM_PROTECAO

 /*
    protege arquivo de dados contra acesso dBase e muda para "read-only"
    vamos comentar este "code block" ...
 */
 protdbf={|fg|pt:=fg,;                             // torna a flag visivel no proximo "code block"
           tel_p:=SAVESCREEN(0,0,MAXROW(),79),;    // salva a tela
           DBOX("Um momento!",,,,NAO_APAGA),;      // mensagem ao usuario
           AEVAL(sistema,{|sis|;                   // executa o "code block" para cada
                           EDBF(drvdbf+;           // um dos arquivos do vetor sistema
                                sis[O_ARQUI],pt);  // (se pt, desprotege; senao, protege)
                         };
           ),;
           RESTSCREEN(0,0,MAXROW(),79,tel_p);      // restaura a tela
         }
#endi

IF !FILE(dbfpw)                                    // se nao existir arquivo de
 ALERTA()                                          // senhas, avisa
 DBOX("Arquivo de senhas ausente!",,,2)
 RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura a tela
 SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
 RETU                                              // retorna ao DOS
ENDI

#ifdef COM_REDE
 IF ! USEARQ(dbfpw,.f.,20,1,.f.)                   // falhou abertura modo compartilhado,
  RESTSCREEN(0,0,MAXROW(),79,v0)                   // restaura tela
  SETPOS(MAXROW()-1,1)                             // cursor na penultima linha, coluna 1
  RETU                                             // retorna ao DOS
 ENDI
#else
 EDBF(dbfpw,.t.)                                   // desprotege arquivo de
 USE (dbfpw)                                       // senhas e o utiliza
#endi

IF !FILE(ntxpw+".ntx")                             // se nao ha indice,
 INDE ON pass TO (ntxpw) EVAL odometer()           // cria o arquivo indice
ENDI
SET INDE TO (ntxpw)
IF ASC(nace)>48 .AND. ASC(nace)<52                 // previne erro

 #ifdef COM_REDE
  IF !BLOARQ(3,.5)                                 // se nao conseguiu bloquear o arquivo,
   RESTSCREEN(0,0,MAXROW(),79,v0)                  // restaura tela
   SETPOS(MAXROW()-1,1)                            // cursor na penultima linha, coluna 1
   RETU                                            // retorna ao DOS
  ENDI
 #endi

 REPL ALL nace WITH ENCRIPT(nace),;                // manipulacao das senhas
          nome WITH ENCRIPT(nome)                  // criptografando o nivel e nome

 #ifdef COM_REDE
  UNLOCK                                           // libera arquivo
 #endi

ENDI
cod_sos=15
COLORSELECT(COR_GET)
v1=SAVESCREEN(0,0,MAXROW(),79)
CAIXA(mold,10,22,14,58,440)
@ 11,30 SAY "INFORME A SUA SENHA"                  // monta janela para
@ 12,35 SAY "�      �"                             // solicitar a entrada
@ 13,26 SAY "ESC para recome�ar/finalizar"         // da senha de acesso
cp_=1
DO WHIL .t.
 COLORSELECT(COR_GET)
 senha=PADR(PWORD(12,36),6)                        // recebe a senha do usuario
 COLORSELECT(COR_PADRAO)
 SEEK senha                                        // ve se esta' credenciado
 IF FOUND()                                        // OK!
  usuario=TRIM(DECRIPT(nome))                      // nome do usuario
  senhatu=senha                                    // sua senha
  nivelop=VAL(DECRIPT(nace))                       // seu nivel
  FOR t=1 TO nss                                   // exrot[] contera' as
   msg=sistema[t,O_ARQUI]                          // rotinas nao acessadas
   exrot[t]=ex&msg.                                // de cada subsistema
  NEXT
  IF nivelop>0.AND.nivelop<4                       // de 1 a 3...
   DBOX("Bom trabalho, "+usuario,13,45,2)          // boas vindas!
   EXIT                                            // use e abuse...
  ENDI
 ELSE
  IF cp_<2 .AND. !EMPTY(senha)                     // epa! senha invalida
   cp_++                                           // vamos dar outra chance
   ALERTA()                                        // estamos avisando!
   DBOX("Senha inv�lida!",,,1)
   COLORSELECT(COR_GET)
   @ 12,36 SAY SPAC(6)
  ELSE                                             // errou duas vezes!
   IF !EMPTY(senha)                                // se informou senha errada
    ALERTA()                                       // pode ser um E.T.
    DBOX("Usu�rio n�o autorizado!",,,2)
   ENDI

   #ifndef COM_REDE
    EDBF(dbfpw,.f.)                                // protege o arquivo de senhas
   #endi

   #ifdef COM_PROTECAO
    EVAL(protdbf,.f.)                              // protege DBF
   #endi

   RESTSCREEN(0,0,MAXROW(),79,v0)                  // restaura tela,
   SETPOS(MAXROW()-1,1)                            // cursor na penultima linha, coluna 1
   MUDAFONTE(0)                                    // retorna com a fonte normal
   RETU                                            // e tchau!
  ENDI
 ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                     // restaura tela
USE                                                // fecha o arquivo de senhas

#ifdef COM_PROTECAO
 EVAL(protdbf,.t.)                                 // desprotege DBFs
#endi

msg_auto="Opera��o n�o autorizada, "+usuario
IF !CRIADBF()                                      // se DBF nao criado,

 #ifdef COM_PROTECAO
  EVAL(protdbf,.f.)                                // protege DBF
 #endi

 RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela
 SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
 RETU                                              // volta ao DOS
ENDI
SET CONF (drvconf)                                 // ajusta SET CONFIRM
cod_sos=1
/*
ALERTA(1)
msg="Atualize a data de hoje"
datac=DBOX(msg,,,,,"ATEN��O!",datac,"99/99/9999")    // confirma a data
IF UPDATED()                                       // se modificou sugestao,
 set cent off
 DOSDATA(DTOC(datac))                              // vamos atualizar o DOS
 set cent on
ENDI
*/
dbfparam=drvdbf+"PAR_ADM"
SELE A

#ifdef COM_REDE
 USEARQ(dbfparam,.t.,,,.f.)
#else
 USE (dbfparam)
#endi


/*
   cria variaveis de memoria publicas identicas as de arquivo,
   para serem usadas por toda a aplicacao
*/
FOR i=1 TO FCOU()
 msg=FIEL(i)
 M->&msg.=&msg.
NEXT
USE
****************************************
   ***************************************
   nemp:=IIF(EMPT(setup1),nemp,setup1)
   ***************************************
#include "bloq_adp.ch" //DTOS (D:\CLIPPER\INCLUDE) ou pasta local
   ***************************************
****************************************
CBC1()
//DBOX("Usu�rio: "+M->usuario,22,53,,NAO_APAGA)   // Identifica��o do usuario
//CBC1()
opc_01=1
v01=SAVESCREEN(0,0,MAXROW(),79)
DO WHIL opc_01!=0
 cod_sos=3
 RESTSCREEN(0,0,MAXROW(),79,v01)
 menu01="Lan�amentos|"+;
        "Vendas|"+;
        "Cobran�a|"+;
        "Relat�rios|"+;
        "Tabelas|"+;
        "Apoio"
 opc_01=DBOX(menu01,0,,E_POPMENU,NAO_APAGA,,,,opc_01)
 BEGIN SEQUENCE
  DO CASE
   CASE opc_01=0      // retornar ao DOS
    CLEA GETS
    CLOS ALL
    ALERTA()
    msgt="ENCERRAMENTO"
    msg ="Finalizar opera��es|N�o finalizar"
    cod_sos=1
    op_=DBOX(msg,,,E_MENU,,msgt,,,1)
    IF op_=1
     MUDAFONTE(0)
    ELSE
     opc_01=1
    ENDI

   CASE opc_01=1     // lan�amentos
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Contratos|"+;
            "Cancelamentos|"+;
            "Reintegra��o|"+;
            "Processos"
     msgt="LAN�AMENTOS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,2,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // contratos
       GRUPOS(3,10)

      CASE opc_02=2     // cancelamentos
       CANCELS(4,10)
/*
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Cancelamentos|"+;
               "Proc.Cancelamentos"
        msgt="CANCELAMENTOS"
        opc_03=DBOX(menu03,3,10,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // cancelamentos
          CANCELS(5,18)

         CASE opc_03=2     // proc.cancelamentos
          ADM_R032(5,18)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD
*/
      CASE opc_02=3     // reintegra��o
       ADM_R006(3,10)

      CASE opc_02=4     // processos
       PRCESSOS(3,10)

     ENDC
     CLEA GETS
     CLOS ALL
		ENDD

   CASE opc_01=2     // vendas
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Gerar carn� do contrato|"+;
            "Lan�amento/Carn�s|"+;
	    "Emiss�o Carn�|"+;
	    "Etiqueta p/Carn�s|"+;
			"Impress�o Contrato|"+;
	    "Tabela|"+;
	    "Relat�rios"
     msgt="VENDAS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,15,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // gerar carn� do contrato
       ADP_P007(3,23)

      CASE opc_02=2     // lan�amento/carn�s
       EMCARNE(3,23)


      CASE opc_02=3     // emiss�o carn�
       IF p_recp==[S]
        ADM_RP38(3,23)
       ELSE
        ADP_R066(3,23)
       ENDI

      CASE opc_02=4     // etiqueta p/carn�s
       ADM_E002(3,23)

      CASE opc_02=5     // impress�o contrato 1
       ADM_R041(3,23)

      CASE opc_02=6     // tabela
       TCARNES(3,23)

      CASE opc_02=7     // relat�rios
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
			 DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Contratos sem Carn�s|"+;
               "Vendas (Vend. X �rea)|"+;
               "Vendas (�rea X Vend.)|"+;
               "Comiss�o|"+;
               "Cancelamento X Vend.|"+;
               "Vendas por Bairro"
        msgt="RELAT�RIOS"
        opc_03=DBOX(menu03,3,23,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // contratos sem carn�s
          ADP_RX85(5,31)

				 CASE opc_03=2     // vendas (vend. x �rea)
          ADP_R098(5,31)

         CASE opc_03=3     // vendas (�rea x vend.)
          ADP_R099(5,31)

         CASE opc_03=4     // comiss�o
          ADP_R100(5,31)

         CASE opc_03=5     // Cancelamentos p/Vendedor
          ADP_Rx98(5,31)

         CASE opc_03=6     // Vendas por Bairro
          ADP_R103(5,31)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=3     // cobran�a
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Relatorios anteriores|"+;
            "Gera��o dos d�bitos|"+;
            "Consulta D�bitos gerados|"+;
            "Custos adicionais|"+;
						"Impress�o da Cobran�a|"+;
						"Relat�rios posteriores|"+;
						"Boleto Banc�rio|"+;
						"Gerar contr.Cobradores|"+;
						"Baixar Pagos p/FCC|"+;
						"Proc.Transfer�ncias|"+;
						"Taxas a processar"
		 msgt="COBRAN�A"
		 ROLAPOP(1)
		 opc_02=DBOX(menu02,1,23,E_MENU,NAO_APAGA,msgt,,,opc_02)
		 ROLAPOP()
		 DO CASE
			CASE opc_02=1     // relatorios anteriores
			 opc_03=1
			 v03=SAVESCREEN(0,0,MAXROW(),79)
			 DO WHIL opc_03!=0
				cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Cobran�a por Rateio|"+;
               "N�o ter�o d�bito gerado|"+;
               "D�bitos a Gerar|"+;
               "SaiTxa a verficar"
        msgt="RELATORIOS ANTERIORES"
        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // cobran�a por rateio
          opc_04=1
          v04=SAVESCREEN(0,0,MAXROW(),79)
          DO WHIL opc_04!=0
           cod_sos=4
           RESTSCREEN(0,0,MAXROW(),79,v04)
           menu04="Grupos & Proc.Pendentes|"+;
                  "Grupos Prontos p/Emitir"
           msgt="COBRAN�A POR RATEIO"
           opc_04=DBOX(menu04,5,39,E_MENU,NAO_APAGA,msgt,,,opc_04)
           DO CASE
            CASE opc_04=1     // grupos & proc.pendentes
             ADM_RX09(7,47)

            CASE opc_04=2     // grupos prontos p/emitir
             ADM_R009(7,47)

           ENDC
           CLEA GETS
           CLOS ALL
          ENDD

         CASE opc_03=2     // n�o ter�o d�bito gerado
          ADM_R027(5,39)

         CASE opc_03=3     // d�bitos a gerar
          ADP_R070(5,39)

         CASE opc_03=4     // SaiTxas a verificar
          ADP_R104(5,39)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

      CASE opc_02=2     // gera��o dos d�bitos
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
				cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="D�bitos do m�s|"+;
               "D�bitos do Per�odo"
        msgt="GERA��O DOS D�BITOS"
        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // d�bitos do m�s
          ADP_P001(5,39)

         CASE opc_03=2     // d�bitos do per�odo
          ADP_PX07(5,39)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

      CASE opc_02=3     // consulta d�bitos gerados
       CCOBRAN(3,31)

      CASE opc_02=4     // custos adicionais
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Custos Adicionais|"+;
               "Verificar Custos|"+;
               "Lan�ar Custos nas Taxas|"+;
               "Gerar Taxa c/Adicional|"+;
							 "Eliminar C. Adicionais"
				msgt="CUSTOS ADICIONAIS"
        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // custos adicionais
          CSTSEG(5,39)

         CASE opc_03=2     // verificar custos
          ADP_R068(5,39)

         CASE opc_03=3     // lan�ar custos nas taxas
          ADP_R069(5,39)

         CASE opc_03=4     // gerar taxa c/adicional
					ADP_RX88(5,39)

         CASE opc_03=5     // eliminar c. adicionais
          SEG_P010(5,39)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

      CASE opc_02=5     // impress�o da cobran�a
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Modelo por Rateio|"+;
               "Modelo Per�odico"
        msgt="IMPRESSAO DE COBRANCA"
        opc_03=DBOX(menu03,5,39,E_MENU,NAO_APAGA,msgt,,,opc_03)
				DO CASE
				 CASE opc_03=1     // modelo por rateio
          IF p_recp==[S]
				   ADM_RP33(7,47)
          ELSE
           ADM_RV33(7,47)
          ENDI

				 CASE opc_03=2     // modelo per�odico
          IF p_recp==[S]
					 ADP_RP44(7,47)
          ELSE
           ADP_R044(7,47)
          ENDI

				ENDC
			  CLEA GETS
				CLOS ALL
			 ENDD

			CASE opc_02=6     // relat�rios posteriores
			 opc_03=1
			 v03=SAVESCREEN(0,0,MAXROW(),79)
			 DO WHIL opc_03!=0
				cod_sos=4
				RESTSCREEN(0,0,MAXROW(),79,v03)
				menu03="Etiquetas de Cobran�a|"+;
							 "Verso de Taxas|"+;
							 "Resumo Taxas Emitidas"
        msgt="RELAT�RIOS POSTERIORES"
        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // etiquetas de cobran�a
          ADP_E004(5,39)

         CASE opc_03=2     // verso de taxas
          ADP_RV68(5,39)

         CASE opc_03=3     // resumo taxas emitidas
          ADM_R010(5,39)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

      CASE opc_02=7     // boleto banc�rio
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Impress�o|"+;
               "Impress�o modelo NOVO|"+;
			   "Impress�o PDF|"+;
               "Boletos Emitidos|"+;
               "Acerto de Nosso N�mero|"+;
               "Baixa Boletos|"+;
               "Gerar FCC dos Boletos|"+;
               "Apagar Boletos p/ FCC"
        msgt="BOLETO BANC�RIO"
        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // impress�o
          ADP_R087(5,39)

         CASE opc_03=2     // impress�o
          ADP_RX87(5,39)
		  
		 CASE opc_03=3     // boletos emitidos
          adp_pdf(5,39)  

         CASE opc_03=4     // boletos emitidos
          BOLETOS(5,39)

         CASE opc_03=5     // acerto de nosso n�mero
          ADP_R094(5,39)

         CASE opc_03=6     // baixa boletos
          LBXBOLET(5,39)

         CASE opc_03=7     // gerar fcc dos boletos
          ADP_R096(5,39)

         CASE opc_03=8     // apagar boletos p/ fcc
          ADP_R095(5,39)

        ENDC
        CLEA GETS
//        CLOS ALL
       ENDD

      CASE opc_02=8     // gerar contr.cobradores
       ADP_R067(3,31)

      CASE opc_02=9     // baixar pagos p/fcc
       ADP_R045(3,31)

      CASE opc_02=10     // proc.transfer�ncias
       ADP_P003(3,31)

      CASE opc_02=11     // taxas a processar
       TXPROC(3,31)

     ENDC
     CLEA GETS
//     CLOS ALL
    ENDD

   CASE opc_01=4     // relat�rios
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Contratos & Cobran�as|"+;
            "2� Via das Taxas|"+;
            "Resumo p/Circular|"+;
            "Taxas pendentes|"+;
            "Pagas por Per�odo|"+;
            "Etiqueta Contratos|"+;
            "Contratos|"+;
            "Inscritos|"+;
            "Acerto c/Vendedor|"+;
            "Titular & Dependentes|"+;
            "Contratos Cancelados|"+;
            "Contratos vagos|"+;
            "Comiss�o|"+;
						"Ficha de Acertos|"+;
						"Etiqueta Carteirinha|"+;
						"Resumo mensal|"+;
            "Contratos&Cobrancas(2)"
     msgt="RELAT�RIOS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,33,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // contratos & cobran�as
       ADC_R076(3,41)

      CASE opc_02=2     // 2� via das taxas
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Uma a uma|"+;
               "V�rias de 1 s� vez"
        msgt="2� VIA DAS TAXAS"
        opc_03=DBOX(menu03,3,41,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // uma a uma
          ADP_RX44(5,49)

         CASE opc_03=2     // v�rias de 1 s� vez
          opc_04=1
          v04=SAVESCREEN(0,0,MAXROW(),79)
          DO WHIL opc_04!=0
           cod_sos=4
           RESTSCREEN(0,0,MAXROW(),79,v04)
           menu04="Taxas a Imprimir|"+;
                  "Impress�o 2�Via"
					 msgt="V�RIAS DE 1 S� VEZ"
           opc_04=DBOX(menu04,5,49,E_MENU,NAO_APAGA,msgt,,,opc_04)
           DO CASE
            CASE opc_04=1     // taxas a imprimir
             TX2VIA(7,57)

            CASE opc_04=2     // impress�o 2�via
             ADC_R066(7,57)

           ENDC
           CLEA GETS
           CLOS ALL
          ENDD

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

      CASE opc_02=3     // resumo p/circular
       ADM_R016(3,41)

      CASE opc_02=4     // taxas pendentes
       ADM_R035(3,41)

      CASE opc_02=5     // pagas por per�odo
       ADM_R037(3,41)

      CASE opc_02=6     // etiqueta contratos
       ADM_E003(3,41)

      CASE opc_02=7     // contratos
			 ADM_R043(3,41)

			CASE opc_02=8     // inscritos
			 ADM_R001(3,41)

			CASE opc_02=9     // acerto c/vendedor
			 ADC_R067(3,41)

			CASE opc_02=10     // titular & dependentes
			 ADP_R073(3,41)

			CASE opc_02=11     // contratos cancelados
			 ADP_R076(3,41)

			CASE opc_02=12     // contratos vagos
			 ADP_R089(3,41)

			CASE opc_02=13     // comiss�o
			 ADP_R092(3,41)

			CASE opc_02=14     // Ficha de acertos
			 ADc_Rx76(3,41)

			CASE opc_02=15     // export.txt p/etiquetas
			 ADP_R093(3,41)

			CASE opc_02=16     // resumo mensal
			 ADP_RR01(3,41)

			CASE opc_02=17     // Contratos & Cobrancas (listagem)
			 ADC_RN76(3,41)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=5     // tabelas
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     cod_sos=4
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Categoria dos Planos|"+;
            "Grupos|"+;
            "Regi�es|"+;
            "Cobradores/Vendedores|"+;
            "Circulares|"+;
            "Funcion�rios|"+;
            "Par�metro de Juros|"+;
            "Hist�rico Padr�o|"+;
            "Contratos Cancelados|"+;
            "Tabelas Secund�rias"
     msgt="TABELAS"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,45,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // categoria dos planos
       CLASSES(3,53)

      CASE opc_02=2     // grupos
       ARQGRUP(3,53)

      CASE opc_02=3     // regi�es
       REGIAO(3,53)

      CASE opc_02=4     // cobradores/vendedores
       COBRADOR(3,53)

      CASE opc_02=5     // circulares
       CIRCULAR(3,53)

      CASE opc_02=6     // funcion�rios
       FNCS(3,53)

      CASE opc_02=7     // par�metro de juros
       JUROS(3,53)

      CASE opc_02=8     // hist�rico padr�o
       HISTORIC(3,53)

      CASE opc_02=9     // contratos cancelados
       CGRUPOS(3,53)

      CASE opc_02=10     // tabelas secund�rias
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=4
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="Produtos|"+;
               "Filiais|"+;
               "Entregues aos Cobradores|"+;
               "Recebimento de Taxas|"+;
               "Endere�os|"+;
               "Acerto Pagos e Trocas|"+;
               "Mensagem p/Contrato"
        msgt="TABELAS SECUND�RIAS"
        opc_03=DBOX(menu03,3,53,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // produtos
          PRODUTOS(5,61)

         CASE opc_03=2     // filiais
          TFILIAIS(5,61)

         CASE opc_03=3     // entregues aos cobradores
          TXENTR(5,61)

         CASE opc_03=4     // recebimento de taxas
          BXREC(5,61)

         CASE opc_03=5     // endere�os
          ALENDER(5,61)

         CASE opc_03=6     // acerto pagos e trocas
          BXFCC(5,61)

         CASE opc_03=7     // mensagem p/contrato
          MENSAG(5,61)

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

   CASE opc_01=6     // apoio
    opc_02=1
    v02=SAVESCREEN(0,0,MAXROW(),79)
    DO WHIL opc_02!=0
     op_menu=PROJECOES
     cod_sos=9
     RESTSCREEN(0,0,MAXROW(),79,v02)
     menu02="Par�metros|"+;
            "V� relat�rio gravado|"+;
            "Backup|"+;
            "Restaura backup|"+;
            "Reconstr�i �ndices|"+;
            "Elimina reg apagados|"+;
            "Configura ambiente|"+;
            "Plano de senhas|"+;
            "Sobre..."
     msgt="APOIO"
     ROLAPOP(1)
     opc_02=DBOX(menu02,1,54,E_MENU,NAO_APAGA,msgt,,,opc_02)
     ROLAPOP()
     DO CASE
      CASE opc_02=1     // par�metros
       IF nivelop=3
        PAR_ADM(3,62)
       ENDI

      CASE opc_02=2     // v� relat�rio gravado
       VE_REL()

      CASE opc_02=3     // backup
       GBAK()

      CASE opc_02=4     // restaura backup
       IF nivelop=3
        RBAK()
       ENDI

      CASE opc_02=5     // reconstr�i �ndices
       cod_sos=39
       RCLA()

      CASE opc_02=6     // elimina reg apagados
       cod_sos=40
       COMPACTA()

      CASE opc_02=7     // configura ambiente
       opc_03=1
       v03=SAVESCREEN(0,0,MAXROW(),79)
       DO WHIL opc_03!=0
        cod_sos=41
        RESTSCREEN(0,0,MAXROW(),79,v03)
        menu03="� Diret�rio de trabalho|"+;
               "� Marca da impressora��|"+;
               "� Pano de fundo��������|"+;
               "� Fontes de caracteres�|"+;
               "� Esquemas de cores����|"+;
               IF(drvconf,"� ","� ")+"Confirma em campos���|"+;
               IF(drvexcl,"� ","� ")+"Confirma exclus�es���|"+;
               IF(drvincl,"� ","� ")+"Confirma inclus�es���|"+;
               IF(drvvisivel,"� ","� ")+"Excluidos vis�veis���|"+;
               IF(drvsom,"� ","� ")+"Efeitos sonoros������|"+;
               IF(drvautohelp,"� ","� ")+"Ajuda de campo ativa�|"+;
               IF(drvmouse,"� ","� ")+"Liga/desliga mouse���|"+;
               "� Sensibilidade mouse��"
        msgt="CONFIGURA AMBIENTE"
        opc_03=DBOX(menu03,3,62,E_MENU,NAO_APAGA,msgt,,,opc_03)
        DO CASE
         CASE opc_03=1     // diret�rio de trabalho
          cod_sos=2
          PEGADIR(.f.)

         CASE opc_03=2     // marca da impressora
          CONFPRN()

         CASE opc_03=3     // pano de fundo
          cod_sos=43; msg=""                       // menu de caracteres para fundo
          FOR t=1 TO 255                           // enche msg com as opcoes
           IF t!=124                               // exceto o '|` que e o
            msg+="|"+STR(t,3)+" - "+CHR(t)         // caracter separador das
           ENDI                                    // opcoes da DBOX(
          NEXT
          t=ASC(drvcara)-IF(ASC(drvcara)>123,1,0)
          op_x=DBOX(SUBS(msg,2),,70,E_MENU,,"FUNDO",,,t)
          IF op_x!=0                               // escolhido um caracter
           op_x+=IF(op_x>123,1,0)                  // desconta o '|`
           IF drvcara!=CHR(op_x)                   // se caracter
            drvcara=CHR(op_x)                      // diferente do atual
            SAVE TO (arqconf) ALL LIKE drv*        // grava configuracoes,
            CBC1()                                 // monta tela principal e
            v01=SAVESCREEN(0,0,MAXROW(),79)        // salva para o break
            BREAK                                  // que foi configurado
           ENDI
          ENDI

         CASE opc_03=4     // fontes de caracteres
          op_x=1; cod_sos=53
          msgf=MUDAFONTE(999)
          DO WHILE op_x!=0 .AND.LEN(msgf)>0
           msgf=STRTRAN(msgf,CHR(251)," ")
           msgf=LEFT(msgf,13*drvfonte)+CHR(251)+SUBS(msgf,13*drvfonte+2)
           op_x=DBOX(msgf,05,70,E_MENU,,"FONTES",,,drvfonte+1)
           IF op_x>0
            drvfonte=op_x-1
            MUDAFONTE(drvfonte)
           ENDI
          ENDD

         CASE opc_03=5     // esquemas de cores
          CONFCORES()

         CASE opc_03=6     // confirma em campos
          drvconf=!drvconf
          SET(_SET_CONFIRM,drvconf)

         CASE opc_03=7     // confirma exclus�es
          drvexcl=!drvexcl

         CASE opc_03=8     // confirma inclus�es
          drvincl=!drvincl

         CASE opc_03=9     // excluidos vis�veis
          drvvisivel=!drvvisivel
          SET(_SET_DELETED,!drvvisivel)

         CASE opc_03=10     // efeitos sonoros
          drvsom=!drvsom

         CASE opc_03=11     // ajuda de campo ativa
          drvautohelp=!drvautohelp

         CASE opc_03=12     // liga/desliga mouse
          IF MOUSE()>0
           drvmouse=!drvmouse
          ENDI

          #ifdef COM_TUTOR
           IF acao_mac!="D"
            drvmouse=.f.
           ENDI
          #endi

         CASE opc_03=13     // sensibilidade mouse
          cod_sos=45
          AJMOUSE()

        ENDC
        CLEA GETS
        CLOS ALL
       ENDD
       SAVE TO (arqconf) ALL LIKE drv*             // diferente do atual

      CASE opc_02=8     // plano de senhas
       cod_sos=17
       MASENHA(1,62)
      CASE opc_02=9     // sobre...
       cod_sos=1
       SOBRE_(3,62)

     ENDC
     CLEA GETS
     CLOS ALL
    ENDD

  ENDC
 END
 CLEA GETS
 CLOS ALL
ENDD

#ifndef COM_REDE
 EDBF(dbfpw,.f.)                                   // protege arquivo senhas
#endi

#ifdef COM_PROTECAO
 EVAL(protdbf,.f.)                                 // protege DBF
#endi

#ifdef COM_TUTOR
 IF acao_mac!="D"
  FCLOSE(handle_mac)
  acao_mac="D"
 END IF
#endi

RESTSCREEN(0,0,MAXROW(),79,v0)                     // s'imbora
SETPOS(MAXROW()-1,1)                               // e cursor na penultima linha, coluna 1
RETU                                               // volta ao DOS

 * \\ Final de ADPBIG.PRG
