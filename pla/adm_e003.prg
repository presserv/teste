procedure adm_e003
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica-Limeira (019)452.6623
 \ Programa: ADM_E003.PRG
 \ Data....: 24-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Etiqueta Contratos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL lin_:={}, i_, ct_, dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=14, l_i:=14, c_i:=68, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+17 SAY " ETIQUETA CONTRATOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Inicial:"
@ l_s+02,c_s+1 SAY " Final..:"
@ l_s+03,c_s+1 SAY "                Confirma?"
ecodini=SPAC(6)                                    // Codigo
ecodfin=SPAC(6)                                    // Codigo
impdiapgto=2
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
                  MOSTRA {"LEFT(TRAN(IIF(PTAB(ecodini,'GRUPOS',3),GRUPOS->nome,[]),[]),35)", 1 , 18 }

 @ l_s+02 ,c_s+11 GET  ecodfin;
                  PICT "999999";
                  VALI CRIT("ecodfin>=ecodini~CODIGO n�o existe na tabela")
                  AJUDA "Entre com o n�mero do �ltimo contrato |a emitir etiquetas"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"
                  MOSTRA {"LEFT(TRAN(IIF(PTAB(ecodfin,'GRUPOS',3),GRUPOS->nome,[]),[]),35)", 2 , 18 }

 @ l_s+03 ,c_s+27 GET  confirme;
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
 IF [UNIPREV]$M->setup1
  impdiapgto:=1
  impdiapgto:=DBOX("Sim|N�o",,,E_MENU,,"Imprimir Vencimento")
 ENDI

 #ifdef COM_REDE
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF TYPE("drvdm_e003")="C"                         // conf da etq alterada?
  qtlin_=VAL(SUBS(drvdm_e003, 1,3))                // linhas da etiqueta
  qtcol_=VAL(SUBS(drvdm_e003, 4,3))                // largura da etiqueta
  qtcse_=VAL(SUBS(drvdm_e003, 7,3))                // espaco entre as carreiras
  qtcar_=VAL(SUBS(drvdm_e003,10,3))                // numero de carreiras
  qtreg_=SUBS(drvdm_e003,13)                       // qtde por registro
 ELSE                                              // se nao alterou pega
  qtlin_=6                                         // 'defaults` da qde linhas
  qtcol_=35                                        // largura da etiqueta
  qtcse_=1                                         // espaco entre as carreiras
  qtcar_=2                                         // numero de carreiras
  qtreg_="1"                                       // qtde por registro
 ENDI
 IF !opcoes_etq(lin_menu,col_menu,5,35,52)         // nao quis configurar...
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
set marg to
IMPCTL(lpp_006)                                    // seta pagina com 6 linhas
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  IF ecodini>[000000].AND.EMPT(cpord+criterio)
   SEEK ecodini
  ENDI
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF()
   AFILL(lin_,""); ct_=0                           // inicializa lin_/contador de carreiras
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
    IF ecodfin>[000000].AND.EMPT(cpord+criterio).AND.codigo>ECODFIN
     GO BOTT
     SKIP
     LOOP
    ENDI

    IF codigo>=M->ecodini.AND.codigo<=M->ecodfin.AND.!EMPT(nome)// se atender a condicao...
     FOR t_=1 TO &qtreg_.                          // repete a mesma n vezes
      ct_++                                        // soma contador de carreiras
      lin_[1]+=REPL(" ",22)+&drvpenf.+codigo+' '+grupo+&drvtenf.+SPAC(qtcol_+qtcse_-31)
      lin_[2]+=&drvpenf.+TRAN(nome,"@!")+&drvtenf.+SPAC(qtcol_+qtcse_-35)
      lin_[3]+=endereco+SPAC(qtcol_+qtcse_-35)
      lin_[4]+=bairro+SPAC(qtcol_+qtcse_-20)
      lin_[5]+=padr(ALLTRIM(cidade)+" "+TRAN(cep,"@R 99999-999"),35)+SPAC(qtcol_+qtcse_-35)
      IF impdiapgto=1
       lin_[6]+=LPAD([Vencimento: ]+GRUPOS->diapgto,30)+SPAC(qtcol_+qtcse_-30)
      ENDI
      IF ct_>=qtcar_                               // atingiu o numero de carreiras?
       ?? CHR(13)
       FOR i_=1 TO qtlin_                          // imprime linhas da etiqueta
        ?? lin_[i_]
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
     ?? lin_[i_]
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
IMPCTL(lpp_066)                                    // seta pagina com 66 linhas
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET CONSOLE ON                                     // liga impressao em video
SET PRINT OFF                                      // e desliga a impresora
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
SET CONSOLE ON                                     // liga impressao em video
SET PRINT OFF                                      // e desliga a impresora
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

* \\ Final de ADM_E003.PRG
