procedure adp_r093
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADP_E005.PRG
 \ Data....: 22-10-99
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Etiqueta CARTEIRINHAS - Petr�polis
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL lin_:={}, lin_CB, i_, ct_, dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=8, c_s:=14, l_i:=14, c_i:=68, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+17 SAY " ETIQUETA CONTRATOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Inicial:"
@ l_s+02,c_s+1 SAY " Final..:"
@ l_s+03,c_s+1 SAY " Inscrito:"
@ l_s+04,c_s+1 SAY " Valido at�:"
@ l_s+05,c_s+1 SAY "                Confirma?"
ecodini=SPAC(6)                                    // Codigo
ecodfin=SPAC(6)                                    // Codigo
contrinsc=SPAC(10)                                 // Inscrito
validade=CTOD('')                                  // Validade
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+11 GET  ecodini;
                  PICT "999999";
                  VALI CRIT("PTAB(ecodini,'GRUPOS',1)~CODIGO n�o existe na tabela")
                  AJUDA "Entre com o n�mero inicial do contrato |a emitir etiquetas"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"
                  MOSTRA {"LEFT(TRAN(IIF(PTAB(ecodini,'GRUPOS'),GRUPOS->nome,[]),[]),35)", 1 , 18 }

 @ l_s+02 ,c_s+11 GET  ecodfin;
                  PICT "999999";
                  VALI CRIT("ecodfin>=ecodini~CODIGO n�o existe na tabela")
                  DEFAULT "ecodini"
                  AJUDA "Entre com o n�mero do �ltimo contrato |a emitir etiquetas"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"
                  MOSTRA {"LEFT(TRAN(IIF(PTAB(ecodfin,'GRUPOS'),GRUPOS->nome,[]),[]),35)", 2 , 18 }

 @ l_s+03 ,c_s+12 GET  contrinsc;
                  PICT "@R 999999-9-!9";
                  VALI CRIT("PTAB(ALLTRIM(contrinsc),'INSCRITS',1).AND.LEN(ALLTRIM(contrinsc))>5~INSCRITO n�o existe na tabela");
                  WHEN "ecodini=ecodfin"
                  DEFAULT "ecodini"
                  AJUDA "Informe o c�digo do inscrito|Tecle F8 para tabela"
                  CMDF8 "VDBF(6,3,20,77,'INSCRITS',{'codigo','grau','seq','nome'},1,'kinscf9()')"

 @ l_s+04 ,c_s+14 GET  validade;
                  PICT "@D"
                  AJUDA "Informe a data final da validade da carteirinha"

 @ l_s+05 ,c_s+27 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme=[S]~CONFIRME n�o aceit�vel")
                  AJUDA "Digite S para confirmar|ou|Tecle ESC para cancelar"

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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(codigo,"INSCRITS",1,.t.)                     // abre arquivo p/ o relacionamento
 PTAB(cobrador,"COBRADOR",1,.t.)
 PTAB(tipcont,"CLASSES",1,.t.)
 SET RELA TO codigo INTO INSCRITS,;                // relacionamento dos arquivos
          TO tipcont INTO CLASSES,;                // relacionamento dos arquivos
          TO cobrador INTO COBRADOR
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF TYPE("drvdp_e005")="C"                         // conf da etq alterada?
  qtlin_=VAL(SUBS(drvdp_e005, 1,3))                // linhas da etiqueta
  qtcol_=VAL(SUBS(drvdp_e005, 4,3))                // largura da etiqueta
  qtcse_=VAL(SUBS(drvdp_e005, 7,3))                // espaco entre as carreiras
  qtcar_=VAL(SUBS(drvdp_e005,10,3))                // numero de carreiras
  qtreg_=SUBS(drvdp_e005,13)                       // qtde por registro
 ELSE                                              // se nao alterou pega
  qtlin_=6                                         // 'defaults` da qde linhas
  qtcol_=35                                        // largura da etiqueta
  qtcse_=1                                         // espaco entre as carreiras
  qtcar_=1                                         // numero de carreiras
  qtreg_="1"                                       // qtde por registro
 ENDI
 IF !opcoes_etq(lin_menu,col_menu,5,35,52)         // nao quis configurar...
  CLOS ALL                                         // fecha arquivos e
  LOOP                                             // volta ao menu
 ENDI
 lin_=ARRAY(qtlin_)                                // inicializa vetor de linhas
 lin_CB=ARRAY(qtlin_)
 IF tps=2                                          // se vai para arquivo/video
  arq_=ARQGER()                                    // entao pega nome do arquivo
  IF EMPTY(arq_)                                   // se cancelou ou nao informou
   LOOP                                            // retorna
  ENDI
 ELSE
  arq_=drvporta                                    // porta de saida configurada
 ENDI
 IF "4WIN"$UPPER(drvmarca)
   arq_:=drvdbf+"WIN"+ide_maq
   tps:=3
 ENDIF
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
IF !EMPTY(drvtapg)                                 // existe configuracao de tam pag?
 op_=AT("NNN",drvtapg)                             // se o codigo que altera
 IF op_=0                                          // o tamanho da pagina
  msg="Configura��o do tamanho da p�gina!"         // foi informado errado
  DBOX(msg,,,,,"ERRO!")                            // avisa
  CLOSE ALL                                        // fecha todos arquivos abertos
  RETU                                             // e cai fora...
 ENDI                                              // codigo para setar/resetar tam pag
 lpp_006=LEFT(drvtapg,op_-1)+"006"+SUBS(drvtapg,op_+3)
 lpp_066=LEFT(drvtapg,op_-1)+"066"+SUBS(drvtapg,op_+3)
ELSE
 lpp_006:=lpp_066 :=""                             // nao ira mudara o tamanho da pag
ENDI
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET CONSOLE OFF                                    // desliga impressao no video
SET PRINT ON                                       // e envia para impressora
IMPCTL(lpp_006)                                    // seta pagina com 6 linhas
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  PTAB(M->ecodini,[GRUPOS])
  ccop++                                           // incrementa contador de copias
  IF !EMPT(M->contrinsc)
   PTAB(ALLTRIM(M->contrinsc),[INSCRITS])
   SELE INSCRITS
  ENDI
  DO WHIL !EOF()
   AFILL(lin_,""); ct_=0                           // inicializa lin_/contador de carreiras
   FOR i_=1 TO qtlin_
    lin_CB[i_]={}
   NEXT
   DO WHILE !EOF() .AND. ct_<qtcar_                // faz todas as carreiras
    #ifdef COM_TUTOR
     IF IN_KEY()=K_ESC                             // se quer cancelar
    #else
     IF INKEY()=K_ESC                              // se quer cancelar
    #endi
     IF canc()                                     // pede confirmacao
      BREAK                                        // confirmou...
     ENDI
    ENDI
    IF codigo > M->ecodfin
     GO BOTT
     SKIP
     LOOP
    ENDI
    IF !EMPT(M->contrinsc)
     IF !(CODIGO+GRAU+STR(SEQ,2)=ALLTRIM(M->contrinsc))
      SKIP
      LOOP
     ENDI
     IF VIVOFALEC=[F]
      SKIP
      LOOP
     ENDI
    ENDI

    IF codigo >= M->ecodini .AND.;
       codigo <= M->ecodfin .AND.;
       !EMPT(nome)                // se atender a condicao...
/*
   set devi to screen
   dbox(str(recno())+[|Cod]+codigo)
   set devi to prin
*/
     FOR t_=1 TO &qtreg_.                          // repete a mesma n vezes
      ct_++                                        // soma contador de carreiras
      lin_[1]+=&drvpenf.+TRAN(nome,"@!")+&drvtenf.+SPAC(qtcol_+qtcse_-35)
      lin_[2]+=&drvpenf.+codigo+&drvtenf.+"/"+;
IIF(!EMPT(M->contrinsc),INSCRITS->grau+[.]+STR(INSCRITS->seq,2),[    ])+"-"+TRAN(GRUPOS->grupo,"!!")+""+space(20)+SPAC(qtcol_+qtcse_-35)
      IF EMPT(M->validade)
       IF !EMPT(M->contrinsc)
        lin_[3]+="Validade "+TRAN(IIF(INSCRITS->tcarencia>DATE(),INSCRITS->tcarencia,DATE()),"@D")+" A "+TRAN(GRUPOS->renovar,"@D")+SPAC(qtcol_+qtcse_-32)
       ELSE
        lin_[3]+="Validade "+TRAN(IIF(GRUPOS->tcarencia>DATE(),GRUPOS->tcarencia,DATE()),"@D")+" A "+TRAN(GRUPOS->renovar,"@D")+SPAC(qtcol_+qtcse_-32)
       ENDI
      ELSE
       lin_[3]+="Validade "+TRAN(M->validade,"@D")+SPAC(qtcol_+qtcse_-19)
      ENDI
      lin_[5]+=REPL(" ",27)+SPAC(qtcol_+qtcse_-27)
      AADD(lin_CB[5],{CODIGO,4,6,25+(qtcol_+qtcse_)*(ct_-1)})
      IF ct_>=qtcar_                               // atingiu o numero de carreiras?
       ?? CHR(13)
       FOR i_=1 TO qtlin_                          // imprime linhas da etiqueta
        ?? lin_[i_]
        IF i_=05
         CODBARRAS(lin_CB[i_],10,6)
        ELSE
         IF EMPTY(drvtapg) .OR. i_<qtlin_
          ?
         ENDI
        ENDI
       NEXT
       IF !EMPTY(drvtapg)                          // existe configuracao de tam pag?
        EJEC                                       // salta pagina no inicio
       ENDI
       AFILL(lin_,""); ct_=0                       // inicializa lin_/contador de carreiras
       FOR i_=1 TO qtlin_
        lin_CB[i_]={}
       NEXT
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
     ?? lin_[i_]
     IF i_=05
      CODBARRAS(lin_CB[i_],10,6)
     ELSE
      IF EMPTY(drvtapg) .OR. i_<qtlin_
       ?
      ENDI
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
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET CONSOLE ON                                     // liga impressao em video
SET PRINT OFF                                      // e desliga a impresora
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
SET CONSOLE ON                                     // liga impressao em video
SET PRINT OFF                                      // e desliga a impresora
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

* \\ Final de ADP_E005.PRG

FUNC KINSCF9
RETU INSCRITS->codigo+INSCRITS->grau+STR(INSCRITS->seq,02,00)

* \\ Final de KINSCF9.PRG
