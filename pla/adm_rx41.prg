procedure adm_rx41
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: ADM_R041.PRG
 \ Data....: 22-06-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Impress„o Contrato
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=11, c_s:=19, l_i:=16, c_i:=58, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+10 SAY " IMPRESSŽO CONTRATO "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Codigo:"
@ l_s+04,c_s+1 SAY "                      Confirma ?"
rcodigo=SPAC(6)                                    // Codigo
confirme=SPAC(1)                                   // Confirme
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+01 ,c_s+10 GET  rcodigo;
                  PICT "999999";
                  VALI CRIT("PTAB(rcodigo,'GRUPOS',1)~CODIGO n„o aceit vel")
                  AJUDA "Entre com o n£mero do contrato a imprimir"
                  CMDF8 "VDBF(6,20,20,77,'GRUPOS',{'codigo','nome','admissao'},3,'codigo',[])"
                  MOSTRA {"LEFT(TRAN(GRUPOS->nome,[@!]),35)", 2 , 3 }
                  MOSTRA {"LEFT(TRAN(GRUPOS->endereco,[]),35)", 3 , 3 }

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
  CLOSE GRUPOS
  IF !USEARQ("GRUPOS",.f.,10,1)                    // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("GRUPOS")                                 // abre o dbf e seus indices
 #endi

 PTAB(codigo,"EMCARNE",1,.t.)                      // abre arquivo p/ o relacionamento
 PTAB(codigo,"ECOB",1,.t.)
 SET RELA TO codigo INTO EMCARNE,;                 // relacionamento dos arquivos
          TO codigo INTO ECOB
 titrel:=criterio:=cpord := ""                     // inicializa variaveis
 titrel:=chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 IF !opcoes_rel(lin_menu,col_menu,19,11)           // nao quis configurar...
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
 SET PRINTER TO (arq_)                             // redireciona saida
 EXIT
ENDD
criterio_=criterio                                 // salva criterio e ordenacao
cpord_=cpord                                       // definidos se huver
criterio=""

#ifdef COM_REDE
 IF !USEARQ("INSCRITS",.f.,10,1)                   // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("INSCRITS")                                // abre o dbf e seus indices
#endi

cpord="codigo"
INDTMP()
criterio=criterio_                                 // restabelece criterio e
cpord=cpord_                                       // ordenacao definidos
SELE GRUPOS
DBOX("[ESC] Interrompe",15,,,NAO_APAGA)
dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...
SET DEVI TO PRIN                                   // inicia a impressao
maxli=84                                           // maximo de linhas no relatorio
IMPCTL(drvpde8)                                    // ativa 8 lpp
IF tps=2
 IMPCTL("' '+CHR(8)")
ENDI
BEGIN SEQUENCE
 DO WHIL ccop<=nucop                               // imprime qde copias pedida
  pg_=1; cl=999
  INI_ARQ()                                        // acha 1o. reg valido do arquivo
  ccop++                                           // incrementa contador de copias
  seek M->rcodigo
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
   IF codigo==M->rcodigo                           // se atender a condicao...
    REL_CAB(1)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,059 SAY codigo                            // Codigo
    IMPCTL(drvtenf)
    REL_CAB(5)                                     // soma cl/imprime cabecalho
    IMPCTL(drvpenf)
    @ cl,014 SAY nome                              // Nome
    IMPCTL(drvtenf)
    REL_CAB(4)                                     // soma cl/imprime cabecalho
    @ cl,020 SAY TRAN(nascto_,"@D")                // Nascto
    @ cl,030 SAY TRAN([ ],"@!")                    // Naturalidade
    @ cl,062 SAY TRAN(uf,"!!")                     // UF
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,013 SAY TRAN(rg,"@!")                     // R.G.
    @ cl,040 SAY TRAN(cpf,"@R 999.999.999-99")     // CPF
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,010 SAY endereco                          // Endere‡o
    @ cl,048 SAY bairro                            // Bairro
    REL_CAB(2)                                     // soma cl/imprime cabecalho
    @ cl,010 SAY LEFT(ALLTRIM(cidade)+[ ]+cep,30)  // Cidade
    @ cl,045 SAY TRAN(telefone,"@!")               // Telefone
    @ cl,061 SAY LOWER(IIF(!EMPT(estcivil),SUBS(tbestciv,AT(estcivil,tbestciv),11),[]))// Est Civil
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,010 SAY TRAN(contato,"@!")                // Contato
//    @ cl,035 SAY TRAN(telefone,"@!")               // Telefone
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,010 SAY IIF(PTAB(codigo,'ECOB',1),ECOB->endereco,[ ])// outro endereco
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,010 SAY IIF(PTAB(codigo,'ECOB',1),ALLTRIM(ECOB->cidade)+' '+ECOB->cep,[ ])// outra cidade
    @ cl,040 SAY IIF(PTAB(codigo,'ECOB',1),ECOB->bairro,[ ])// outro bairro
    REL_CAB(3)                                     // soma cl/imprime cabecalho
    @ cl,000 SAY "."
    chv032=codigo
    SELE INSCRITS
    SEEK chv032
    IF FOUND()
     IF cl+2>maxli                                 // se cabecalho do arq filho
      REL_CAB(0)                                   // nao cabe nesta pagina
     ENDI                                          // salta para a proxima pagina
     DO WHIL ! EOF() .AND. chv032=codigo //LEFT(&(INDEXKEY(0)),LEN(chv032))
      #ifdef COM_TUTOR
       IF IN_KEY()=K_ESC                           // se quer cancelar
      #else
       IF INKEY()=K_ESC                            // se quer cancelar
      #endi
       IF canc()                                   // pede confirmacao
	BREAK                                      // confirmou...
       ENDI
      ENDI
      IF grau>'1'                                  // se atender a condicao...
       REL_CAB(2)                                  // soma cl/imprime cabecalho
       @ cl,010 SAY R04201F9()                     // qualif
       @ cl,018 SAY nome                           // Nome
       @ cl,056 SAY TRAN(nascto_,"@D")             // tab2
       @ cl,065 SAY vivofalec                      // tab1
       SKIP                                        // pega proximo registro
      ELSE                                         // se nao atende condicao
       SKIP                                        // pega proximo registro
      ENDI
     ENDD
     cl+=1                                         // soma contador de linha
    ENDI
    SELE GRUPOS                                    // volta ao arquivo pai
    SKIP                                           // pega proximo registro
    cl=999                                         // forca salto de pagina
   ELSE                                            // se nao atende condicao
    SKIP                                           // pega proximo registro
   ENDI
  ENDD
 ENDD ccop
 EJEC                                              // salta pagina
END SEQUENCE
IMPCTL(drvtde8)                                    // ativa 6 lpp
SET PRINTER TO (drvporta)                          // fecha arquivo gerado (se houver)
SET DEVI TO SCRE                                   // direciona saida p/ video
IF tps=2                                           // se vai para arquivo/video
 BROWSE_REL(arq_,2,3,MAXROW()-2,78)
ENDI                                               // mostra o arquivo gravado
GRELA(19)                                          // grava variacao do relatorio
msgt="PROCESSAMENTOS DO RELAT¢RIO|IMPRESSŽO CONTRATO"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 SELE GRUPOS                                       // processamentos apos emissao
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF()
  IF codigo==M->rcodigo                            // se atender a condicao...

   #ifdef COM_REDE
    IF DATE()>ultimp_
     REPBLO('GRUPOS->ultimp_',{||DATE()})
    ENDI
   #else
    IF DATE()>ultimp_
     REPL GRUPOS->ultimp_ WITH DATE()
    ENDI
   #endi

   SKIP                                            // pega proximo registro
  ELSE                                             // se nao atende condicao
   SKIP                                            // pega proximo registro
  ENDI
 ENDD
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
SELE GRUPOS                                        // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

STATIC PROC REL_CAB(qt)                            // cabecalho do relatorio
IF qt>0                                            // se parametro maior que 0
 cl=cl+qt                                          // soma no contador de linhas
ENDI
IF cl>maxli .OR. qt=0                              // quebra de pagina
 cl=qt+5 ; pg_++
ENDI
RETU

* \\ Final de ADM_R041.PRG
