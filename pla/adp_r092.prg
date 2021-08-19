procedure adp_r092
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R092.PRG
 \ Data....: 07-11-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Comiss„o
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=9, c_s:=20, l_i:=14, c_i:=61, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+16 SAY " COMISSŽO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Vendedor:"
@ l_s+03,c_s+1 SAY " Admiss„o: de:          at‚"
@ l_s+04,c_s+1 SAY " Confirme:"
rvend=SPAC(3)                                      // Vendedor
ateh1=CTOD('')                                     // At‚:
ateh2=CTOD('')                                     // At‚:
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+12 GET  rvend;
									PICT "!!!";
									VALI CRIT("PTAB(rvend,'COBRADOR',1).OR.EMPT(rvend)~VENDEDOR n„o existe na tabela")
                  AJUDA "Informe o c¢digo do Vendedor|ou|Tecle F8 para consulta em arquivo"
									CMDF8 "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador')"
									MOSTRA {"LEFT(TRAN(COBRADOR->nome,[]),30)", 2 , 9 }

 @ l_s+03 ,c_s+16 GET  ateh1;
                  PICT "@D"

 @ l_s+03 ,c_s+29 GET  ateh2;
                  PICT "@D"

 @ l_s+04 ,c_s+12 GET  confirme;
                  PICT "!";
		  VALI CRIT("confirme='S'~CONFIRME n„o aceit vel")
		  AJUDA "Digite S para confirmar|ou|tecle ESC para cancelar"

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
  IF !USEARQ("EMCARNE",.f.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("EMCARNE")                                // abre o dbf e seus indices
 #endi

 PTAB(vendedor,"COBRADOR",1,.t.)                   // abre arquivo p/ o relacionamento
 PTAB(codigo,"GRUPOS",1,.t.)
 PTAB(tip,"TCARNES",1,.t.)
 SET RELA TO vendedor INTO COBRADOR,;              // relacionamento dos arquivos
	  TO codigo INTO GRUPOS,;
	  TO tip INTO TCARNES
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="vendedor+codigo"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,72,11)           // nao quis configurar...
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
maxli=62                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  tot107006:=tot107007 := 0                        // inicializa variaves de totais
  qqu107=0                                         // contador de registros
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
   IF M->rvend$('  /'+vendedor).AND.M->ateh1<=GRUPOS->admissao.AND.M->ateh2>=GRUPOS->admissao// se atender a condicao...
    REL_CAB(2)                                     // soma cl/imprime cabecalho
		@ cl,000 SAY [Vendedor ]+vendedor+[ ]+COBRADOR->nome                       // titulo da quebra
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    qb10701=vendedor                               // campo para agrupar 1a quebra
    st10701006:=st10701007 := 0                    // inicializa sub-totais
    qqu10701=0                                     // contador de registros
    DO WHIL !EOF() .AND. vendedor=qb10701
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     IF M->rvend$('  '+vendedor).AND.M->ateh1<=GRUPOS->admissao.AND.M->ateh2>=GRUPOS->admissao// se atender a condicao...
      REL_CAB(1)                                   // soma cl/imprime cabecalho
      @ cl,000 SAY TRAN(codigo,"999999")           // Codigo
      @ cl,007 SAY TRAN(vendedor,"!!")             // Vendedor
      @ cl,016 SAY TRAN(tip,"@!")                  // Tipo
      @ cl,021 SAY TRAN(vencto_,"@D")              // Vencto
      @ cl,030 SAY TRAN(GRUPOS->admissao,"@D")     // Admiss„o
      st10701006+=TCARNES->vali
      tot107006+=TCARNES->vali
      @ cl,040 SAY TRAN(TCARNES->vali,"99999.99")  // Val.Total
      st10701007+=TCARNES->vali/TCARNES->parf
      tot107007+=TCARNES->vali/TCARNES->parf
      @ cl,049 SAY TRAN(TCARNES->vali/TCARNES->parf,"99999.99")// Parc.
      qqu10701++                                   // soma contadores de registros
      qqu107++                                     // soma contadores de registros
      SKIP                                         // pega proximo registro
     ELSE                                          // se nao atende condicao
      SKIP                                         // pega proximo registro
     ENDI
    ENDD
    IF cl+3>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    @ ++cl,040 SAY REPL('-',17)
    @ ++cl,040 SAY TRAN(st10701006,"99999.99")     // sub-tot Val.Total
    @ cl,049 SAY TRAN(st10701007,"99999.99")       // sub-tot Parc.
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "* Quantidade "+TRAN(qqu10701,"@E 999,999")
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
  IF cl+3>maxli                                    // se cabecalho do arq filho
   REL_CAB(0)                                      // nao cabe nesta pagina
  ENDI                                             // salta para a proxima pagina
  @ ++cl,040 SAY REPL('-',17)
  @ ++cl,040 SAY TRAN(tot107006,"99999.99")        // total Val.Total
  @ cl,049 SAY TRAN(tot107007,"99999.99")          // total Parc.
  REL_CAB(2)                                       // soma cl/imprime cabecalho
  @ cl,000 SAY "*** Quantidade total "+TRAN(qqu107,"@E 999,999")
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(72)                                          // grava variacao do relatorio
SELE EMCARNE                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,070 SAY "PAG"
 @ 0,074 SAY TRAN(pg_,'9999')                      // n£mero da p gina
 IMPAC(nsis,1,000)                                 // t¡tulo aplica‡„o
 @ 1,070 SAY "ADP_R092"                            // c¢digo relat¢rio
 IMPAC("COMISSŽO",2,000)
 @ 2,014 SAY titrel                                // t¡tulo a definir
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 IMPAC("Codigo Vendedor Tipo Vencto   Admiss„o Val.Total    Parc.",3,000)
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R092.PRG
