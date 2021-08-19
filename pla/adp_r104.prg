procedure adp_r104
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_R104.PRG
 \ Data....: 07-10-99
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Verificar SaiTxa
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=7, c_s:=20, l_i:=14, c_i:=62, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+12 SAY " VERIFICAR SAITXA "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY "  Informe a quantidade de meses entre o"
@ l_s+03,c_s+1 SAY "  vencimento da £ltima parcela de carnˆ"
@ l_s+04,c_s+1 SAY "         e a primeira cobran‡a."
@ l_s+05,c_s+1 SAY " Prazo (meses):"
rprazo=0                                           // Prazo (meses)
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+05 ,c_s+17 GET  rprazo;
                  PICT "99"
                  DEFAULT "3"
                  AJUDA "Informe o nr.de meses entre a £ltima|parcela e o primeiro d‚bito mensal"

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

 PTAB(codigo,"TAXAS",1,.t.)                        // abre arquivo p/ o relacionamento
// SET RELA TO codigo INTO TAXAS                     // relacionamento dos arquivos
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,27,11)           // nao quis configurar...
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
DBOX("[ESC] Interrompe|  |",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=62                                           // maximo de linhas no relatorio
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
   SET DEVI TO SCRE                                // inicia a impressao
   @ 17,35 say codigo
   SET DEVI TO PRIN                                // inicia a impressao
   IF SITUACAO#[1]
    SKIP
    LOOP
   ENDI

   ault_=ULT_TAXA(codigo+[1])                         // variavel temporaria
   ult_=ault_[1]
   crcx = ault_[2]

   SELE GRUPOS
   stxok=substr(dtoc(ult_+31*rprazo-day(ult_)),4)
   stxat=substr(dtoc(ctod([01/]+left(saitxa,2)+[/]+right(saitxa,2))),4)
   IF stxok = stxat
    SKIP
    LOOP
   ENDI
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY TRAN(codigo,"999999")              // Codigo
   @ cl,007 SAY TRAN(nome,"@!")                    // Nome
   @ cl,043 SAY TRAN(TAXAS->emissao_,"@D")         // 1.Vencto
   @ cl,054 SAY TRAN(ult_,"@D")                    // Venc.Ult.Parc.
   @ cl,065 SAY TRAN(saitxa,"@R 99/99")            // Saitxa
   @ cl,072 SAY stxok+[ ]+crcx                              // SaiTxaOk
   SKIP                                            // pega proximo registro
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(27)                                          // grava variacao do relatorio
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,071 SAY "ADP_R104"                            // c¢digo relat¢rio
 @ 2,000 SAY "VERIFICAR SAITXA"
 @ 2,020 SAY titrel                                // t¡tulo a definir
 @ 2,061 SAY NSEM(DATE())                          // dia da semana
 @ 2,069 SAY DTOC(DATE())                          // data do sistema
 @ 3,000 SAY "Codigo Nome                                1.Vencto   Venc.Ult. Saitxa SaiTxaOk"
 @ 4,000 SAY REPL("-",79)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R104.PRG
STATIC FUNC ULT_TAXA
PARA mcod,mtipo
LOCAL dt_tx:=ctod('  /  /  '), crc_x:=[   ]
IF pcount()=0
 mcod = codigo
 mtipo=[]
ELSEIF PCOUNT()=1
 mtipo=[  ]
ENDI

SELE TAXAS
SEEK mcod

DO WHILE !EOF() .AND. TAXAS->codigo+TAXAS->tipo+TAXAS->circ=M->Mcod //.AND.ct_tx < M->rpend
 IF TAXAS->emissao_ > dt_tx
	 dt_tx:=TAXAS->emissao_
   crc_x:=TAXAS->circ
 ENDI
 SKIP
ENDDO

RETU {dt_tx,crc_x}       // <- deve retornar um valor L¢GICO
