procedure adp_r101
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADP_R101.PRG
 \ Data....: 10-02-99
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Cartinha de Processos
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=4, l_i:=17, c_i:=77, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+26 SAY " CARTINHA DE PROCESSOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Grupo...:     Circular:"
@ l_s+02,c_s+1 SAY " Data....:"
@ l_s+03,c_s+1 SAY " Mensagem:"
@ l_s+09,c_s+1 SAY " Confirme:"
rgrupo=SPAC(2)                                     // Grupo
rcirc=SPAC(3)                                      // Circular
rdata=SPAC(45)                                     // Data
rmens1=SPAC(70)                                    // Mens1
rmens2=SPAC(70)                                    // Mens2
rmens3=SPAC(70)                                    // Mens3
rmens4=SPAC(70)                                    // Mens4
rmens5=SPAC(70)                                    // Mens5
IF FILE('PR101VAR.MEM')
 REST FROM PR101VAR ADDITIVE
ENDI
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rgrupo;
                  PICT "!!";
                  VALI CRIT("PTAB(rgrupo,'ARQGRUP',1).OR.EMPT(rgrupo)~GRUPO n�o existe na tabela|Informe um existente |ou|deixe sem preencher para listar todos")
                  AJUDA "Circular de qual grupo?"
                  CMDF8 "VDBF(6,54,20,77,'ARQGRUP',{'grup','inicio','final'},1,'grup',[])"

 @ l_s+01 ,c_s+26 GET  rcirc;
                  PICT "999";
                  VALI CRIT("PTAB(rgrupo+rcirc,'CIRCULAR',1).OR.rcirc=[000]~Necess�rio informar CIRCULAR v�lida")
                  AJUDA "Informe o n�mero da circular a listar"
                  CMDF8 "VDBF(6,40,20,77,'CIRCULAR',{'grupo','circ','emissao_','valor'},1,'grupo',[grupo=rgrupo])"
/*
 @ l_s+02 ,c_s+12 GET  rdata;
                  PICT "@!";
                  VALI CRIT("!EMPT(rdata)~Necess�rio informar DATA")
                  DEFAULT "RTRIM(M->p_cidade)+[, ]+NMES(MONTH(CIRCULAR->emissao_))+ [ de ]+LEFT(DTOS(CIRCULAR->emissao_),4)"
                  AJUDA "Informe a data do cabe�alho"
*/
 @ l_s+04 ,c_s+02 GET  rmens1;
                  PICT "@!"
                  AJUDA "Mensagem 1"
                  CMDF8 "Informe a linha 1/5 da cartinha"

 @ l_s+05 ,c_s+02 GET  rmens2;
                  PICT "@!"
                  AJUDA "Mensagem 2"
                  CMDF8 "Informe a linha 2/5 da cartinha"

 @ l_s+06 ,c_s+02 GET  rmens3;
                  PICT "@!"
                  AJUDA "Mensagem 3"
                  CMDF8 "Informe a linha 3/5 da cartinha"

 @ l_s+07 ,c_s+02 GET  rmens4;
                  PICT "@!"
                  AJUDA "Mensagem 4"
                  CMDF8 "Informe a linha 4/5 da cartinha"

 @ l_s+08 ,c_s+02 GET  rmens5;
                  PICT "@!"
                  AJUDA "Mensagem 5"
                  CMDF8 "Informe a linha 5/5 da cartinha"

 @ l_s+09 ,c_s+12 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme= 'S'~CONFIRME n�o aceit�vel|Digite S ou Tecle ESC")
                  AJUDA "Digite S para confirmar |ou|Tecle ESC para cancelar"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI

 SAVE TO PR101VAR ALL LIKE R*

 #ifdef COM_REDE
  IF !USEARQ("PRCESSOS",.f.,10,1)                  // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("PRCESSOS")                               // abre o dbf e seus indices
 #endi

 titrel:=criterio := ""                            // inicializa variaveis
 cpord="grup+saiu+DTOS(dfal)"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,73,11)           // nao quis configurar...
  CLOS ALL                                         // fecha arquivos e
  LOOP                                             // volta ao menu
 ENDI
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
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=63                                           // maximo de linhas no relatorio
SET MARG TO 1                                      // ajusta a margem esquerda
IMPCTL(drvpcom)                                    // comprime os dados
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  DO WHIL !EOF()
   #ifdef COM_TUTOR
    IF IN_KEY()=K_ESC                              // se quer cancelar
   #else
    IF INKEY()=K_ESC                               // se quer cancelar
   #endi
    IF canc()                                      // pede confirmacao
     BREAK                                         // confirmou...
    ENDI
   ENDI
   IF (EMPT(M->rgrupo).OR.grup=M->rgrupo).AND.(M->rcirc=[000].OR.saiu=M->rcirc)// se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    IF PTAB(grup+SAIU,'CIRCULAR',1)
     rdata=RTRIM(M->p_cidade)+[, ]+NMES(MONTH(CIRCULAR->emissao_))+ [ de ]+LEFT(DTOS(CIRCULAR->emissao_),4)
    ELSE
     rdata=RTRIM(M->p_cidade)+[, ]+NMES(MONTH(DATE()))+ [ de ]+LEFT(DTOS(DATE()),4)
    ENDI
    @ cl,000 SAY M->rdata+[ Grupo: ]+grup+[ Circ: ]+saiu// titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb11401=grup+saiu                              // campo para agrupar 1a quebra
    DO WHIL !EOF() .AND. grup+saiu=qb11401
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF .T. //(EMPT(M->rgrupo).OR.grup=M->rgrupo).AND.(EMPT(M->rcirc).OR.saiu=M->rcirc)// se atender a condicao...
      REL_CAB(2)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY "CONTRATO"
      @ cl,009 SAY TRAN(grup,"!!")                 // Grup
      @ cl,013 SAY TRAN(num,"999999")              // Num
      @ cl,021 SAY TRAN(seg,"@!")                  // Seg
      @ cl,057 SAY "(SEG)"
      @ cl,069 SAY TRAN(categ,"!!")                // Categoria
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,013 SAY TRAN(grau,"9")                  // Inscr.
      @ cl,015 SAY TRAN(seq,"99")                  // Seq
      @ cl,021 SAY TRAN(fal,"@!")                  // Fal
      @ cl,057 SAY "(FAL) Proc:"
      @ cl,069 SAY TRAN(processo,"@R 99999/99/!!") // Processo
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,021 SAY TRAN(ends,"@!")                 // Ends
      @ cl,062 SAY TRAN(cids,"@!")                 // Cids
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,021 SAY "Data Fal.:"
      @ cl,032 SAY TRAN(dfal,"@D")                 // Data
      @ cl,043 SAY TRAN(sep,"@!")                  // Sep
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtcom)                                    // retira comprimido
SET MARG TO                                        // coloca margem esquerda = 0
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(73)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPCTL(drvpenf)
 IMPAC(nemp,0,000)                                 // nome da empresa
 IMPCTL(drvtenf)
 @ 2,000 SAY TRAN(M->rmens1,"@!")                  // Mens1
 @ 3,000 SAY TRAN(M->rmens2,"@!")                  // Mens2
 @ 4,000 SAY TRAN(M->rmens3,"@!")                  // Mens3
 @ 5,000 SAY TRAN(M->rmens4,"@!")                  // Mens4
 @ 6,000 SAY TRAN(M->rmens5,"@!")                  // Mens5
 cl=qt+7 ; pg_++
ENDI
RETU

* \\ Final de ADP_R101.PRG
