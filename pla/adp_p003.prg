procedure adp_p003
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_P003.PRG
 \ Data....: 14-05-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Proc.Transferˆncias
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu, getlist:={}
PARA  lin_menu, col_menu
PRIV  tem_borda:=.t., op_menu:=VAR_COMPL, l_s:=6, c_s:=16, l_i:=17, c_i:=63, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)               // monta caixa da tela
@ l_s,c_s+15 SAY " GERAR P/ FILIAIS "
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY " Transferir para as filiais as Taxas emitidas"
@ l_s+02,c_s+1 SAY " ou baixadas a partir de que data?:"
@ l_s+04,c_s+1 SAY " Efetivar no Plano as Taxas baixadas atrav‚s"
@ l_s+05,c_s+1 SAY " da Recep‡„o?   (desobriga baixa p/FCC)"
@ l_s+07,c_s+1 SAY " Efetivar no Plano as Taxas baixadas por"
@ l_s+08,c_s+1 SAY " FCC (Cobran‡a)?"
@ l_s+10,c_s+1 SAY "                   Confirme?:"
inicio_=CTOD('')                                   // Inicio
bxrec=SPAC(1)                                      // Baixar pagas na Recep‡„o?
bxcob=SPAC(1)                                      // Baixar pagas por FCC?
confirme=SPAC(1)                                   // Confirme?
DO WHILE .t.
 rola_t=.f.
 cod_sos=56
 SET KEY K_ALT_F8 TO ROLATELA
 SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
 @ l_s+02 ,c_s+37 GET  inicio_;
                  PICT "@D";
                  VALI CRIT("!EMPT(inicio_).AND.inicio_<=DATE()~Necess rio informar INICIO")
                  AJUDA "Informe a data inicial a considerar|Gerar movimento a partir de que data?"

 @ l_s+05 ,c_s+15 GET  bxrec;
                  PICT "!";
                  VALI CRIT("bxrec$'SN'~BAIXAR PAGAS NA RECEP€ŽO? |se S, ser„o consideradas quitadas as|Taxas pagas na Recep‡„o.")
                  DEFAULT "[N]"
                  AJUDA "Digite S para quitar as pagas na Recep‡„o|Ou N para considerar apenas as|baixadas por FCC."

 @ l_s+08 ,c_s+18 GET  bxcob;
                  PICT "!";
                  VALI CRIT("bxcob$'SN'~BAIXAR PAGAS POR FCC?|se S, ser„o quitadas as|Taxas baixadas por FCC.")
                  DEFAULT "[S]"
                  AJUDA "Digite S para quitar as pagas por FCC|Ou N para n„o baixar."

 @ l_s+10 ,c_s+31 GET  confirme;
                  PICT "!";
		  VALI CRIT("confirme=[S]~CONFIRME? n„o aceit vel|Digite S para confirmar ou|Tecle ESC para cancelar")
		  AJUDA "Digite S para confirmar ou |Tecle ESC para cancelar"

 READ
 SET KEY K_ALT_F8 TO
 IF rola_t
  ROLATELA(.f.)
  LOOP
 ENDI
 IF LASTKEY()=K_ESC                                // se quer cancelar
  RETU                                             // retorna
 ENDI
 EXIT
ENDD
cod_sos=1
msgt="PROC.TRANSFERENCIAS"
ALERTA()
op_=1 //DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
IF op_=1
 DBOX("Processando registros",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...

 #ifdef COM_REDE
  IF !USEARQ("TAXAS",.t.,10,1)                     // se falhou a abertura do arq
   RETU                                            // volta ao menu anterior
  ENDI
 #else
  USEARQ("TAXAS")                                  // abre o dbf e seus indices
 #endi

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""

#ifdef COM_REDE
 IF !USEARQ("TXPROC",.t.,10,1)                     // se falhou a abertura do arq
  RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("TXPROC")                                  // abre o dbf e seus indices
#endi

 SELE TAXAS			       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
  IF (emissao_ < M->inicio_) .AND. (baixa_ < M->inicio_)
   SKIP
   LOOP
  ENDI

  IF !PTAB(codigo+tipo+circ,'TXPROC',1)
   PTAB(codigo+SUBSTR([678  123],VAL(tipo),1)+circ,'TXPROC',1)
  ENDI

  IF TXPROC->(EOF()).AND.;
   ((emissao_>=M->inicio_.AND.stat<'5').OR.(baixa_>=M->inicio_.AND.stat=[9]))
   SELE TXPROC                                     // arquivo alvo do lancamento

   APPE BLAN                                      // cria registro em branco

   SELE TAXAS                                      // inicializa registro em branco
   REPL TXPROC->codigo WITH codigo,;
	TXPROC->tipo WITH tipo,;
	TXPROC->circ WITH circ,;
	TXPROC->emissao_ WITH emissao_,;
	TXPROC->valor WITH valor,;
	TXPROC->pgto_ WITH pgto_,;
	TXPROC->valorpg WITH valorpg,;
	TXPROC->cobrador WITH cobrador,;
	TXPROC->forma WITH forma,;
	TXPROC->baixa_ WITH baixa_,;
	TXPROC->por WITH por,;
	TXPROC->stat WITH stat,;
	TXPROC->filial WITH filial


  ENDI
  SKIP                                             // pega proximo registro
 ENDD
 SELE TAXAS                                        // salta pagina
 GO TOP
 SELE TXPROC
 GO TOP

 criterio:=cpord := ""                             // inicializa variaveis
 chv_rela:=chv_1:=chv_2 := ""
 SELE TXPROC                                       // processamentos apos emissao
 go top
 skip -1
 odometer(reccount(),18,15)
 // CTREG:=RECCOUNT()
 INI_ARQ()                                         // acha 1o. reg valido do arquivo
 DO WHIL !EOF().and.odometer()
   IF !PTAB(codigo+tipo+circ,'TAXAS',1)
    PTAB(codigo+SUBSTR([678  123],VAL(tipo),1)+circ,'TAXAS',1)
   ENDI


   IF !TAXAS->(EOF()).AND.TAXAS->stat <= stat
    REPL TAXAS->pgto_ WITH pgto_,;
     TAXAS->valorpg WITH valorpg,;
     TAXAS->cobrador WITH cobrador,;
     TAXAS->forma WITH forma,;
     TAXAS->baixa_ WITH baixa_,;
     TAXAS->por WITH por,;
     TAXAS->filial WITH filial
    REPL TXPROC->atp WITH 'X',;
     TAXAS->stat WITH IIF(bxrec=[S].and.stat=[6],[9],IIF(bxcob=[S].and.stat=[7],[9],stat))
   ENDI

  SKIP                                             // pega proximo registro
 ENDD
 SELE TXPROC                                       // salta pagina
 SET RELA TO                                       // retira os relacionamentos
 SET(_SET_DELETED,dele_atu)                        // os excluidos serao vistos
 ALERTA(2)
 DBOX("Processo terminado com sucesso!",,,,,msgt)
ENDI
CLOSE ALL                                          // fecha todos os arquivos e
RETU                                               // volta para o menu anterior

* \\ Final de ADP_P003.PRG
