/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_RV68.PRG
 \ Data....: 13-02-03
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Verso das Taxas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v4.0n
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL lin_:={}, cur_atual, i_, ct_, dele_atu, getlist:={}
PARA lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=6, c_s:=19, l_i:=14, c_i:=54, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
NumEtiq_=0
IF nivelop < 3                                     // se usuario nao tem
 DBOX("Emiss„o negada, "+usuario,20)               // permissao, avisa
 RETU                                              // e retorna
ENDI
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " VERSO DAS TAXAS "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY " Grupo :"
@ l_s+04,c_s+1 SAY "    Contrato     ³    Circular"
@ l_s+05,c_s+1 SAY " Inicial  Final  ³ Inicial  Final"
@ l_s+06,c_s+1 SAY "                 ³"
PRIV r_grupo:=SPAC(2)                              // Grupo
PRIV r_codini:=SPAC(6)                             // Codigo
PRIV r_codfin:=SPAC(6)                             // Codigo
PRIV r_circini:=SPAC(3)                            // Circular
PRIV r_circfin:=SPAC(3)                            // Circular
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+10 GET  r_grupo;
                  PICT "!!";
                  VALI CRIT("PTAB(r_grupo,[ARQGRUP],1).OR.EMPT(r_grupo)~GRUPO n„o existe na tabela")
                  AJUDA "Digite o grupo"
                  CMDF8 "VDBF(6,49,20,77,'ARQGRUP',{'grup','classe','inicio','final'},1,'grup',[])"

 @ l_s+06 ,c_s+02 GET  r_codini;
                  PICT "999999";
                  VALI CRIT("PTAB(r_codini,[GRUPOS],1).OR.EMPT(VAL(r_codini))~CODIGO n„o aceit vel|N„o cadastrado na tabela de grupos")
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','situacao','nome','cidade'},1,'codigo',[])"

 @ l_s+06 ,c_s+11 GET  r_codfin;
		  PICT "999999";
                  VALI CRIT("PTAB(r_codfin,[GRUPOS],1).OR.EMPT(VAL(r_codfin))~CODIGO n„o aceit vel|N„o cadastrado na tabela de grupos")
                  AJUDA "Entre com o n£mero do contrato"
		  CMDF8 "VDBF(6,3,20,77,'GRUPOS',{'codigo','grupo','situacao','nome','cidade'},1,'codigo',[])"

 @ l_s+06 ,c_s+20 GET  r_circini;
		  PICT "999"
                  AJUDA "Informe o n£mero da circular a consultar"

 @ l_s+06 ,c_s+29 GET  r_circfin;
                  PICT "999"
                  AJUDA "Informe o n£mero da circular a consultar"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI

 #ifdef COM_REDE
  IF !USEARQ("TAXAS",.f.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 PTAB(codigo,"GRUPOS",1,.t.)                       // abre arquivo p/ o relacionamento
 SET RELA TO codigo INTO GRUPOS                    // relacionamento dos arquivos
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="codigo+tipo+circ"
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF TYPE("drvdp_rv68")="C"                         // conf da etq alterada?
  qtlin_=VAL(SUBS(drvdp_rv68, 1,3))                // linhas da etiqueta
  qtcol_=VAL(SUBS(drvdp_rv68, 4,3))                // largura da etiqueta
  qtcse_=VAL(SUBS(drvdp_rv68, 7,3))                // espaco entre as carreiras
  qtcar_=VAL(SUBS(drvdp_rv68,10,3))                // numero de carreiras
  qtreg_=SUBS(drvdp_rv68,13)                       // qtde por registro
 ELSE                                              // se nao alterou pega
  qtlin_=11                                        // 'defaults` da qde linhas
  qtcol_=36                                        // largura da etiqueta
  qtcse_=1                                         // espaco entre as carreiras
  qtcar_=2                                         // numero de carreiras
  qtreg_="1"                                       // qtde por registro
 ENDI
 fil_ini=""
 IF !opcoes_etq(lin_menu,col_menu,11,36,52,fil_ini)// nao quis configurar...
  CLOS ALL                                         // fecha arquivos e
  LOOP                                             // volta ao menu
 ENDI
 lin_=ARRAY(qtlin_)                                // inicializa vetor de linhas
 IF tps=2                                          // se vai para arquivo/video
  arq_=ARQGER()                                    // entao pega nome do arquivo
  IF EMPTY(arq_)                                   // se cancelou ou nao informou
   LOOP                                            // retorna
  ENDI
 ELSE
  arq_=drvporta                                    // porta de saida configurada
 ENDI
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
cur_atual=SETCURSOR(0)
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura‡„o do tamanho da p gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_011=LEFT(drvtapg,op_-1)+LPAD(qtlin_,3,"0")+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_011:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
 AFILL(lin_,"")                                    // inicializa lin_/contador de carreiras
FOR i_=1 TO qtcar_                                 // lin de p/ teste de posicionamento
 lin_[1]+=PADR("Contrato    Circular               ³",qtcol_+qtcse_)
 lin_[2]+=PADR("(XXXXXX)     (XXX)                 ³",qtcol_+qtcse_)
 lin_[3]+=PADR("Titular:                           ³",qtcol_+qtcse_)
 lin_[4]+=PADR("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX³",qtcol_+qtcse_)
 lin_[5]+=PADR("                                   ³",qtcol_+qtcse_)
 lin_[6]+=PADR("CEP XXXXXXXXX                      ³",qtcol_+qtcse_)
 lin_[7]+=PADR("                                   ³",qtcol_+qtcse_)
 lin_[8]+=PADR("Responsavel ______________________ ³",qtcol_+qtcse_)
 lin_[9]+=PADR("                                   ³",qtcol_+qtcse_)
 lin_[10]+=PADR("Parentesco  ______________________ ³",qtcol_+qtcse_)
 lin_[11]+=PADR("ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´",qtcol_+qtcse_)
NEXT
op_2=1
DO WHIL op_2=1 .AND. tps=1                         // teste de posicionamento
 msg="Testar Posicionamento|Emitir a Etiqueta|"+;
     "Cancelar a Opera‡„o"
 op_2=DBOX(msg,,,E_MENU,,"EMISSŽO DE ETIQUETA")    // menu de opcoes
 IF op_2=0 .OR. op_2=3                             // cancelou ou teclou ESC
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU
 ELSEIF op_2=2                                     // emite conteudos...
  EXIT
 ELSE                                              // testar posicionamento
  SET CONSOLE OFF                                  // desliga impressao no video
  SET PRINT ON                                     // e envia para impressora
  IMPCTL(lpp_011)                                  // seta pagina com 11 linhas
  ///IMPCTL(lpp_066)
  ?? CHR(13)
  FOR i_=1 TO qtlin_
   ?? RTRIM(lin_[i_])                              // imprime 'X` para teste
   IF EMPTY(drvtapg) .OR. i_<qtlin_
    ?
   ENDI
  NEXT
  IF !EMPTY(drvtapg)                               // existe configuracao de tam pag?
   EJEC                                            // salta pagina no inicio
  ENDI
  IMPCTL(lpp_066)                                  // seta pagina com 66 linhas
  SET CONSOLE ON                                   // liga impressao em video
  SET PRINT OFF                                    // e desliga a impresora
 ENDI
ENDD
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
SET CONSOLE OFF                                    // desliga impressao no video
SET PRINT ON                                       // e envia para impressora
IMPCTL(lpp_011)                                    // seta pagina com 11 linhas
///IMPCTL(lpp_066)
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 NumEtiq_=0
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF EOF()
   EXIT
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF()
   AFILL(lin_,""); ct_=0                           // inicializa lin_/contador de carreiras
   DO WHILE !EOF() .AND. ct_<qtcar_                // faz todas as carreiras
    IF IN_KEY()=K_ESC                              // se quer cancelar
     IF canc()                                     // pede confirmacao
      BREAK                                        // confirmou...
     ENDI
    ENDI
    IF (EMPT(M->r_grupo).OR.GRUPOS->grupo=M->r_grupo).AND.(EMPT(VAL(M->r_codini)).OR.M->r_codini<=codigo).AND.(EMPT(VAL(M->r_codfin)).OR.M->r_codfin>=codigo).AND.;
       (EMPT(VAL(M->r_circini)).OR.M->r_circini<=circ).AND.(EMPT(VAL(M->r_circfin)).OR.M->r_circfin>=circ).AND.stat=[2]    // se atender a condicao...
     FOR t_=1 TO &qtreg_.                          // repete a mesma n vezes
      ct_++                                        // soma contador de carreiras
      lin_[1]+="Contrato    Circular               ³"+SPAC(qtcol_+qtcse_-36)
      lin_[2]+="("+TRAN(GRUPOS->codigo,"999999")+")     ("+TRAN(circ,"999")+")                 ³"+SPAC(qtcol_+qtcse_-36)
      lin_[3]+="Titular:                           ³"+SPAC(qtcol_+qtcse_-36)
      lin_[4]+=TRAN(LEFT(GRUPOS->nome,35),"@!")+"³"+SPAC(qtcol_+qtcse_-36)
      lin_[5]+="                                   ³"+SPAC(qtcol_+qtcse_-36)
      lin_[6]+="CEP "+TRAN(GRUPOS->cep,"@R 99999-999")+"                      ³"+SPAC(qtcol_+qtcse_-36)
      lin_[7]+="                                   ³"+SPAC(qtcol_+qtcse_-36)
      lin_[8]+="Responsavel ______________________ ³"+SPAC(qtcol_+qtcse_-36)
      lin_[9]+="                                   ³"+SPAC(qtcol_+qtcse_-36)
      lin_[10]+="Parentesco  ______________________ ³"+SPAC(qtcol_+qtcse_-36)
      lin_[11]+="ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"+SPAC(qtcol_+qtcse_-36)
      IF ct_>=qtcar_                               // atingiu o numero de carreiras?
       NumEtiq_+=1
       IF NumEtiq_>5
//	SET DEVI TO PRIN
//	IMPCTL(lpp_066)
	EJECT ///Forca q a impressora pule uma pagina
//	IMPCTL(lpp_011)
//	SET DEVI TO SCRE
	NumEtiq_=1
       ENDI
       ?? CHR(13)
       FOR i_=1 TO qtlin_                          // imprime linhas da etiqueta
	?? RTRIM(lin_[i_])
	IF EMPTY(drvtapg) .OR. i_<qtlin_
	 ?
	ENDI
       NEXT
       IF !EMPTY(drvtapg)                          // existe configuracao de tam pag?
	EJEC                                       // salta pagina no inicio
       ENDI
       AFILL(lin_,""); ct_=0                       // inicializa lin_/contador de carreiras
      ENDI
     NEXT
     SKIP                                          // pega proximo registro
    ELSE                                           // se nao atende condicao
     SKIP                                          // pega proximo registro
    ENDI
   ENDD                                            // eof ou encheu todas as carreiras
   IF ct_>0                                        // preenchido a carreira parcialmente
    ?? CHR(13)
    FOR i_=1 TO qtlin_                             // imprime linhas da etiqueta
     ?? RTRIM(lin_[i_])
     IF EMPTY(drvtapg) .OR. i_<qtlin_
      ?
     ENDI
    NEXT
    IF !EMPTY(drvtapg)                             // existe configuracao de tam pag?
     EJEC                                          // salta pagina no inicio
    ENDI
   ENDI
  ENDD
 ENDD ccop
 IF EMPTY(drvtapg)
  EJEC                                             // salta pagina no inicio
 ENDI
END SEQUENCE
SETCURSOR(cur_atual)
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET CONSOLE ON                                     // liga impressao em video
SET PRINT OFF                                      // e desliga a impresora
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI          // mostra o arquivo gravado
SET CONSOLE ON                                     // liga impressao em video
SET PRINT OFF                                      // e desliga a impresora
SELE TAXAS                                         // seleciona arquivo
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

* \\ Final de ADP_RV68.PRG
