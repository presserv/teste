procedure adc_rn76
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADC_R076.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora -CR�D/COBRAN�A
 \ Funcao..: Contratos & Cobran�as
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adPbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=10, c_s:=15, l_i:=18, c_i:=65, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+14 SAY " CONTRATOS & COBRAN�AS "
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY " Contratos de:                  at�:"
@ l_s+03,c_s+1 SAY " Vencimentos de:                at�:"
@ l_s+04,c_s+1 SAY " Imprimir as cobran�as j� pagas?"
@ l_s+05,c_s+1 SAY " Imprimir as cobran�as vencidas?"
@ l_s+06,c_s+1 SAY " M�ximo de pendentes a listar..:"
@ l_s+07,c_s+1 SAY "                     Confirme?"
codi=SPAC(6)                                       // Codigo
codf=SPAC(6)                                       // Codigo
veni_=CTOD('')                                     // Venc.Inicial
venf_=CTOD('')                                     // Venc.Final
pag=SPAC(1)                                        // Pagas?
pend=SPAC(1)                                       // Pendentes?
rpend=0                                            // Nrpend
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+22 GET  codi;
                  PICT "999999";
                  VALI CRIT("PTAB(codi,'GRUPOS',1).OR.VAL(codi)=0~Necess�rio informar CODIGO existente")
                  AJUDA "Informe o n�mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"

 @ l_s+02 ,c_s+41 GET  codf;
                  PICT "999999";
		  VALI CRIT("(PTAB(codf,'GRUPOS',1).AND.codf>=codi).OR.VAL(codf)=0~Necess�rio informar CODIGO existente")
                  AJUDA "Informe o n�mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')"
/*
 @ l_s+03 ,c_s+21 GET  veni_;
                  PICT "@D"
                  AJUDA "Informe o primeiro vencimento a considerar"
*/
 @ l_s+03 ,c_s+40 GET  venf_;
                  PICT "@D";
                  VALI CRIT("!EMPT(venf_)~Informe a �ltima data a considerar")
                  AJUDA "Informe o �ltimo vencimento a considerar"
/*
 @ l_s+04 ,c_s+34 GET  pag;
                  PICT "!";
                  VALI CRIT("pag$([SN])~PAGAS? n�o aceit�vel|Digite S ou N")
                  DEFAULT "[N]"
                  AJUDA "Digite S para listar as cobran�as pagas."

 @ l_s+05 ,c_s+34 GET  pend;
                  PICT "!";
                  VALI CRIT("pend$([SN])~PENDENTES? n�o aceit�vel|Digite S ou N")
                  DEFAULT "[S]"
                  AJUDA "Digite S para listar as cobran�as pendentes"
*/
 @ l_s+06 ,c_s+34 GET  rpend;
                  PICT "99";
                  VALI CRIT("!(rpend<0)~NRPEND n�o aceit�vel")
                  DEFAULT "3"
                  AJUDA "Informe o n�mero m�nimo de taxas|pendentes para listar"

 @ l_s+07 ,c_s+32 GET  confirme;
                  PICT "!";
                  VALI CRIT("confirme='S'~CONFIRME n�o aceit�vel")
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
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,46,11)           // nao quis configurar...
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
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("TAXAS",.f.,10,1)                      // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TAXAS")                                   // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
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
   IF codigo>=M->codi.AND.(M->codf=[000000].OR.codigo<=M->codf)
    nrauxpend:=RN7601F9()
    IF (M->rpend>=nrauxpend)// se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpcom)                                // comprime os dados
		 @ cl,000 SAY TRAN(codigo,"999999")            // Codigo
    @ cl,006 SAY "-"
    @ cl,007 SAY TRAN(grupo,"!!")                  // Grupo
    @ cl,010 SAY nome                              // Nome
    @ cl,046 SAY LEFT(ALLTRIM(endereco)+[- ]+ALLTRIM(bairro)+[- ]+;
                 ALLTRIM(cidade),53)
    @ cl,100 SAY telefone                          // Telefone
    @ cl,115 say str(nrauxpend,3)
		IMPCTL(drvtcom)                                // retira comprimido
    endi
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(46)                                          // grava variacao do relatorio
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 IMPCTL(drvpcom)                                   // comprime os dados
 IMPAC(nemp,0,000)                                 // nome da empresa
 @ 0,071 SAY "PAG"
 @ 0,075 SAY TRAN(pg_,'9999')                      // n�mero da p�gina
 IMPAC(nsis,1,000)                                 // t�tulo aplica��o
 @ 1,071 SAY "ADC_R076"                            // c�digo relat�rio
 IMPAC("CONTRATOS EM DIA ATE: "+DTOC(M->venf_),2,000)
 @ 2,024 SAY titrel                                // t�tulo a definir
 @ 2,063 SAY NSEM(DATE())                          // dia da semana
 @ 2,071 SAY DTOC(DATE())                          // data do sistema
 @ 4,000 SAY "Contrato  Nome                                Endereco/Telefone"
 @ 5,000 SAY REPL("-",79)
 IMPCTL(drvtcom)                                   // retira comprimido
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADC_R076.PRG

/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: R07601F9.PRG
 \ Data....: 23-05-98
 \ Sistema.: Administradora -CR�D/COBRAN�A
 \ Funcao..: Condi��o de impress�o do campo Codigo, arquivo ADC_R076
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

stat func rn7601f9

LOCAL reg_dbf:=POINTER_DBF(), ct_tx:=0

PTAB(codigo,[TAXAS],1,.T.)
SELE TAXAS

impok:=.t. //EMPT(M->veni_)  //Imprimir se n�o pedir data inicial

DO WHILE !EOF() .AND. TAXAS->codigo=GRUPOS->codigo //.AND.ct_tx < M->rpend
 IF TAXAS->valorpg>0
	SKIP
	LOOP
 ENDI
 IF TAXAS->emissao_ <= M->venf_
	ct_tx++
	impok:=.t.   // S� vamos imprimir se existir uma
 ENDI
 SKIP
ENDDO

//ct_tx:=IIF(impok,ct_tx,0)  // Se n�o � para imprimir, vamos desconsiderar
													 // a contagem efetuada.
POINTER_DBF(reg_dbf)

RETU ct_tx       // <- deve retornar um valor L�GICO

* \\ Final de R07601F9.PRG
