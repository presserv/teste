procedure adp_r076
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R076.PRG
 \ Data....: 12-05-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Contratos Cancelados
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
@ l_s,c_s+14 SAY " CANCELAMENTOS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Imprimir do n§ :        at‚ o n§"
@ l_s+04,c_s+1 SAY "                    Confirme...:"
rcodin=SPAC(6)                                     // Codigo
rcodfi=SPAC(6)                                     // Codigo
confirme=SPAC(1)                                   // Confirme
cnumero=SPAC(6)                                    // N£mero
cgrupo=SPAC(2)                                     // Grupo
ccodigo=SPAC(5)                                    // Codigo
cmotivo=SPAC(20)                                    // Motivo
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
	@ l_s+01 ,c_s+17 GET  rcodin;
									 PICT "999999";
									 VALI CRIT("PTAB(rcodin,'cGRUPOS',1)~CODIGO n„o aceit vel")
									 AJUDA "Entre com o n£mero do |primeiro cancelamento a imprimir"
									 CMDF8 "VDBF(6,20,20,77,'cGRUPOS',{'codigo','nome','admissao'},1,'numero',[])"

	@ l_s+01 ,c_s+32 GET  rcodfi;
									 PICT "999999";
									 VALI CRIT("PTAB(rcodfi,'cGRUPOS',1)~CODIGO n„o aceit vel")
									 AJUDA "Entre com o n£mero do |£ltimo cancelamento a imprimir"
									 CMDF8 "VDBF(6,20,20,77,'cGRUPOS',{'codigo','nome','admissao'},1,'numero',[])"

/*
 @ l_s+01 ,c_s+10 GET  cnumero;
                  PICT "999999";
                  VALI CRIT("!EMPT(cnumero)~Necess rio informar N£MERO")
                  DEFAULT "STRZERO(M->nrcanc+1,6)"

 @ l_s+02 ,c_s+10 GET  cgrupo;
                  PICT "!9";
                  VALI CRIT("PTAB(cgrupo,'ARQGRUP',1)~GRUPO n„o existe na tabela")
                  AJUDA "Entre com o grupo ou |tecle F8 para consulta em tabela"
                  CMDF8 "VDBF(6,51,20,77,'ARQGRUP',{'grup','classe','inicio','final'},1,'grup',[])"

 @ l_s+02 ,c_s+24 GET  ccodigo;
                  PICT "99999";
                  VALI CRIT("PTAB(cgrupo+ccodigo,'GRUPOS',1)~CODIGO n„o aceit vel")
                  AJUDA "Entre com o n£mero do contrato"
                  CMDF8 "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo',[situacao!=[2]])"
                  MOSTRA {"LEFT(TRAN(GRUPOS->nome,[]),35)", 3 , 5 }

 @ l_s+04 ,c_s+10 GET  cmotivo;
                  PICT "@!";
                  VALI CRIT("cmotivo$[FMID]~Necess rio informar MOTIVO");
                  WHEN "MTAB([Falta pgto|Mudou|Ignorado|Desistˆncia],[MOTIVO])"
                  AJUDA "Entre com a justificativa"
                  CMDF8 "MTAB([Falta pgto|Mudou|Ignorado|Desistˆncia],[MOTIVO])"

*/
	@ l_s+04 ,c_s+34 GET  confirme;
									 PICT "!";
									 VALI CRIT("confirme='S'~CONFIRME n„o aceit vel|Digite S ou tecle ESC para cancelar")
									 AJUDA "Digite S para imprimir o contrato|ou |Tecle ESC para cancelar"

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
  IF !USEARQ("CGRUPOS",.t.,10,1)                   // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("CGRUPOS")                                // abre o dbf e seus indices
 #endi

 PTAB(grupo,"ARQGRUP",1,.t.)                       // abre arquivo p/ o relacionamento
 SET RELA TO grupo INTO ARQGRUP                    // relacionamento dos arquivos
 titrel:=criterio := ""                            // inicializa variaveis
 cpord="codigo"
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,62,11)           // nao quis configurar...
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
 IF !USEARQ("COECOB",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("COECOB")                                  // abre o dbf e seus indices
#endi

cpord="numero"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("CINSCRIT",.t.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CINSCRIT")                                // abre o dbf e seus indices
#endi

cpord="numero"
INDTMP()

#ifdef COM_REDE
 IF !USEARQ("CTAXAS",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("CTAXAS")                                  // abre o dbf e seus indices
#endi

cpord="numero"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE CGRUPOS
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=63                                           // maximo de linhas no relatorio
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
	IF !EMPT(VAL(M->rcodin))
	 PTAB(M->rcodin,[GRUPOS],1)
	ENDI
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
   IF numero<M->rcodin.OR.numero>rcodfi
    SKIP
    LOOP
   ENDI
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Cancelamento n§.:"
   @ cl,018 SAY TRAN(numero,"999999")              // N£mero Canc.
   @ cl,025 SAY TRAN(canclto_,"@D")                // Canclto_
   @ cl,036 SAY motivo                             // Motivo Canc.
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   IMPAC("Reintegra‡„o n§.:",cl,000)
   @ cl,018 SAY TRAN(reintnum,"999999")            // N£mero Reint.
   @ cl,025 SAY TRAN(motreint,"@!")                // Motreint
   @ cl,056 SAY TRAN(reintem_,"@D")                // Reintem
   @ cl,065 SAY TRAN(codreint,"@R !!/99999")       // Codigo Reint.
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Codigo:"
   @ cl,008 SAY TRAN(codigo,"999999")              // Codigo
   @ cl,015 SAY TRAN(grupo,"!!")                   // Grupo
   IMPAC("Situa‡„o:",cl,018)
   @ cl,028 SAY TRAN(situacao,"9")                 // Situa‡„o
   @ cl,031 SAY "Nome:"
   @ cl,037 SAY nome                               // Nome
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Nascto:"
   @ cl,008 SAY TRAN(nascto_,"@D")                 // Nascto
   @ cl,018 SAY "E.Civil.:"
   @ cl,028 SAY TRAN(estcivil,"!!")                // Est Civil
   @ cl,031 SAY "CPF.:"
   @ cl,037 SAY TRAN(cpf,"@R 999.999.999-99")      // CPF
   @ cl,053 SAY "R.G.:"
   @ cl,059 SAY TRAN(rg,"@!")                      // R.G.
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   IMPAC("Endere‡o:",cl,000)
   @ cl,010 SAY endereco                           // Endere‡o
   @ cl,046 SAY "Bairro:"
   @ cl,056 SAY bairro                             // Bairro
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Cidade..:"
   @ cl,010 SAY cidade                             // Cidade
   @ cl,037 SAY "CEP:"
   @ cl,042 SAY TRAN(cep,"@R 99999-999")           // CEP
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Contato.:"
   @ cl,010 SAY TRAN(contato,"@!")                 // Contato
   @ cl,037 SAY "TipCont.:"
   @ cl,047 SAY TRAN(tipcont,"99")                 // TipCont
   @ cl,051 SAY "Vlcarne:"
   @ cl,060 SAY vlcarne                            // Vlcarne
   @ cl,065 SAY "FormaPgto:"
   @ cl,076 SAY TRAN(formapgto,"99")               // FormaPgto
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   IMPAC("Admiss„o:",cl,000)
   @ cl,010 SAY TRAN(admissao,"@D")                // Admiss„o
   IMPAC("Carˆncia:",cl,020)
   @ cl,030 SAY TRAN(tcarencia,"@D")               // T.Carˆncia
   @ cl,039 SAY "SaiTxa:"
   @ cl,047 SAY TRAN(saitxa,"@R 99/99")            // Saitxa
   @ cl,054 SAY "Vend/Reg/Cob:"
   @ cl,068 SAY TRAN(vendedor,"!!")                // Vendedor
   @ cl,070 SAY "/"
   @ cl,071 SAY TRAN(regiao,"999")                 // Regi„o
   @ cl,074 SAY "/"
	 @ cl,075 SAY TRAN(cobrador,"!!!")                // Cobrador
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Obs.....:"
   IMPMEMO(obs,35,1,cl,010,.f.)                    // Obs (memo)
   @ cl,046 SAY "Renovar.:"
   @ cl,056 SAY TRAN(renovar,"@D")                 // Renovar
   qli_m=MLCOUNT(obs,35)-1                         // quantas linhas a imprimir?
   li_m=0
   DO WHIL .t.                                     // imprime linhas do memo
    li_m++
    IF li_m>qli_m                                  // fim do memo
     EXIT
    ENDI
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPMEMO(obs,35,1+li_m,cl,010,.f.)              // imprime...
    #ifdef COM_TUTOR
     IF IN_KEY()=K_ESC                             // se quer cancelar
    #else
     IF INKEY()=K_ESC                              // se quer cancelar
    #endi
     IF canc()                                     // pede confirmacao
      BREAK                                        // confirmou...
     ENDI
    ENDI
   ENDD
   REL_CAB(1)                                      // soma cl/imprime cabecalho
   @ cl,000 SAY "Funerais:"
   @ cl,010 SAY TRAN(funerais,"99")                // Funerais
   @ cl,014 SAY "Circulares:- Inicial:"
   @ cl,036 SAY TRAN(circinic,"999")               // Circ.Inicial
   @ cl,041 SAY "Ultima:"
   @ cl,049 SAY TRAN(ultcirc,"999")                // Ult.Circular
   @ cl,054 SAY "Emitdas:"
   @ cl,063 SAY TRAN(qtcircs,"999")                // Qt.Circulares
   @ cl,068 SAY "Pagas:"
   @ cl,075 SAY TRAN(qtcircpg,"999")               // Circ.Pagas
   chv096=numero
   SELE COECOB
   SEEK chv096
   IF FOUND()
    IF cl+4>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    cl+=1                                          // soma contador de linha
    IMPAC("Tipo Endere‡o                            Bairro",cl,000)
    cl+=1                                          // soma contador de linha
    @ cl,005 SAY "CEP       Cidade                    UF Telefone       Obs"
    cl+=1                                          // soma contador de linha
    @ cl,000 SAY "==== =================================== ================================="
    DO WHIL ! EOF() .AND. chv096=LEFT(&(INDEXKEY(0)),LEN(chv096))
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,000 SAY TRAN(tipo,"!")                   // Tipo
     @ cl,005 SAY TRAN(endereco,"@!")              // Endere‡o
     @ cl,041 SAY TRAN(bairro,"@!")                // Bairro
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,005 SAY TRAN(cep,"@R 99999-999")         // CEP
     @ cl,015 SAY TRAN(cidade,"@!")                // Cidade
     @ cl,041 SAY TRAN(uf,"!!")                    // UF
     @ cl,044 SAY TRAN(telefone,"@!")              // Telefone
     @ cl,059 SAY obs                              // Obs
     SKIP                                          // pega proximo registro
    ENDD
    cl+=3                                          // soma contador de linha
   ENDI
   SELE CGRUPOS                                    // volta ao arquivo pai
   chv096=numero
   SELE CINSCRIT
   SEEK chv096
   IF FOUND()
    IF cl+2>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    cl+=1                                          // soma contador de linha
    @ cl,000 SAY "INSCRITOS"
    DO WHIL ! EOF() .AND. chv096=LEFT(&(INDEXKEY(0)),LEN(chv096))
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,000 SAY REPL("-",78)
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,000 SAY "Inscr.:"
     @ cl,008 SAY TRAN(grau,"9")                   // Inscr.
     @ cl,010 SAY "Seq.:"
     @ cl,016 SAY TRAN(seq,"99")                   // Seq
     @ cl,020 SAY "Titular.?:"
     @ cl,031 SAY TRAN(ehtitular,"!")              // Titular?
     @ cl,035 SAY "Nome.:"
     @ cl,042 SAY nome                             // Nome
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,000 SAY "Nascto:"
     @ cl,008 SAY TRAN(nascto_,"@D")               // Nascto
     @ cl,020 SAY "Est.Civil:"
     @ cl,031 SAY estcivil                         // Est Civil
     @ cl,035 SAY "Interdito:"
     @ cl,046 SAY TRAN(interdito,"!")              // Interdito
     @ cl,049 SAY "Sexo:"
     @ cl,055 SAY TRAN(sexo,"!")                   // Sexo
     IMPAC("Carˆncia:",cl,058)
     @ cl,068 SAY TRAN(tcarencia,"@D")             // T.Carˆncia
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,000 SAY "V/F...:"
     @ cl,008 SAY TRAN(vivofalec,"!")              // V/F
     @ cl,011 SAY "Falecto:"
     @ cl,020 SAY TRAN(falecto_,"@D")              // Falecto.
     @ cl,031 SAY "Tipo:"
     @ cl,037 SAY TRAN(tipo,"!!!")                 // Tipo
     @ cl,043 SAY "N§Processo:"
     @ cl,055 SAY TRAN(procnr,"@R 99999/99")       // N§Processo
     SKIP                                          // pega proximo registro
    ENDD
    cl+=2                                          // soma contador de linha
   ENDI
   SELE CGRUPOS                                    // volta ao arquivo pai
   chv096=numero
   SELE CTAXAS
   SEEK chv096
   IF FOUND()
    IF cl+3>maxli                                  // se cabecalho do arq filho
     REL_CAB(0)                                    // nao cabe nesta pagina
    ENDI                                           // salta para a proxima pagina
    cl+=1                                          // soma contador de linha
    @ cl,000 SAY "Tipo Circ Emissao       Valor Pagamento Valor pago Cob Forma"
    cl+=1                                          // soma contador de linha
    @ cl,000 SAY "==== ==== ======== ========== ========= ========== === ====="
    DO WHIL ! EOF() .AND. chv096=LEFT(&(INDEXKEY(0)),LEN(chv096))
     #ifdef COM_TUTOR
      IF IN_KEY()=K_ESC                            // se quer cancelar
     #else
      IF INKEY()=K_ESC                             // se quer cancelar
     #endi
      IF canc()                                    // pede confirmacao
       BREAK                                       // confirmou...
      ENDI
     ENDI
     REL_CAB(1)                                    // soma cl/imprime cabecalho
     @ cl,000 SAY TRAN(tipo,"!")                   // Tipo
     @ cl,005 SAY TRAN(circ,"999")                 // Circ
     @ cl,010 SAY TRAN(emissao_,"@D")              // Emissao
     @ cl,019 SAY TRAN(valor,"@E 999,999.99")      // Valor
     @ cl,030 SAY TRAN(pgto_,"@D")                 // Pagamento
     @ cl,040 SAY TRAN(valorpg,"@E 999,999.99")    // Valor pago
		 @ cl,051 SAY TRAN(cobrador,"!!!")              // Cob
     @ cl,055 SAY TRAN(forma,"!")                  // Forma
     SKIP                                          // pega proximo registro
    ENDD
    cl+=3                                          // soma contador de linha
   ENDI

   SELE CGRUPOS                                    // volta ao arquivo pai
   SKIP                                            // pega proximo registro
  ENDD
 ENDD ccop
END SEQUENCE
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(62)                                          // grava variacao do relatorio
SELE CTAXAS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SELE CGRUPOS                                       // salta pagina
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
 @ 1,070 SAY "ADP_R076"                            // c¢digo relat¢rio
 @ 2,000 SAY titrel                                // t¡tulo a definir
 @ 2,062 SAY NSEM(DATE())                          // dia da semana
 IMPCTL(drvpenf)
 @ 2,070 SAY DTOC(DATE())                          // data do sistema
 IMPCTL(drvtenf)
 @ 3,000 SAY "CONTRATOS CANCELADOS"
 @ 4,000 SAY REPL("-",78)
 cl=qt+4 ; pg_++
ENDI
RETU

* \\ Final de ADP_R076.PRG
