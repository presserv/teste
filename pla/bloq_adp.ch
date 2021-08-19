/*
****************************
*** ROTINA PARA BLOQUEIO ***
****************************
Adicionar no arquivo principal (.PRG)
 ex: ADPBIG.PRG, ADRBIG.PRG, ADCBIG.PRG,FUNBIG.PRG, etc.
na linha 575 aprox.
   ***************************************
   nemp:=IIF(EMPT(setup1),nemp,setup1)
   ***************************************
   #include "bloq_adp.ch" //DTOS (D:\CLIPPER\INCLUDE)
   ***************************************
 Aonde era executada a rotina do PAR_SYS.DBF
PS: BLOQ_ADP = Para programas do PLANO
    BLOQ_FUN = Para programs do FUN (Funbig e EstoqueVelho(EstBig))
*/

//Verificar a data do arquivo transferido do espa�o ftp, essa atualiza��o tem prazo m�ximo de 90 dias
// caso n�o tenha sido atualizado j� a 90 dias, pede para que seja atualizado e sai fora.
// o objetivo disso � garantir que o arquivo de permissao seja sempre atualizado.
// ? [Verificando atualiza��es]
declare aarqret [adir("???bp.arj")]
declare adatret [adir("???bp.arj")]
adir([???bp.arj],aarqret,,adatret)
dtauxbin:=date()-90  // 90 dias � o limite para captura de atualiza��o do site
for ctfile=1 to len(aarqret)
 if upper(alltrim(aarqret [ctfile]))$"ADPBP.ARJ,FUNBP.ARJ,ADRBP.ARJ,FINBP.ARJ" // atualiza��es verificadas
  if ((adatret [ctfile]) > dtauxbin)
   dtauxbin:=adatret [ctfile]     // utilizamos a data dos arquivos zip transferidos mais atualizados
  endi
 endi
next ctfile
IF (dtauxbin<=(date()-90))
 declare aarqret [adir("???hb.7z")]
 declare adatret [adir("???hb.7z")]
 adir([???hb.7z],aarqret,,adatret)
 for ctfile=1 to len(aarqret)
  if upper(alltrim(aarqret [ctfile]))$"ADPHB.7Z,FUNHB.7Z,ADRHB.7Z,FINHB.7Z" // atualiza�oes verificadas
   if ((adatret [ctfile]) > dtauxbin)  
    dtauxbin:=adatret [ctfile]    //  utilizaremos a data do arquivo zip transferido mais atualizado
   endi
  endi
 next ctfile
ENDI
// ? [Data do �ltimo get ] + DTOC(dtauxbin)

IF (dtauxbin<=(date()-89))        // se n�o pegou arquivo do site nos �ltimos 90 dias, tchau!
 byebye([Atualiza��o necess�ria (7z/Arj)])  // informa e...
 retu 1
ENDI

   ****************************************
dbfsys=LEFT(drvdbf,3)+"..\PAR_PRS.SYS"  // deve ficar na pasta anterior a pasta de arquivos
IF !FILE(dbfsys)
 dbfsys=drvntx+"PAR_PRS.SYS"  // ou na pasta de indices 
 IF !FILE(dbfsys)
  dbfsys=drverr+"PAR_PRS.SYS" // ou na pasta de erros/senhas
  IF !FILE(dbfsys)
   dbfsys=[]
  ENDI
 ENDI
ENDI
IF EMPT(dbfsys)  // se nao encontrar o arquivo de parametros (PAR_PRS.SYS) em nenhuma das op��es
 byebye([Arquivos de Parametros Ausentes ou danificados (A)])  // informa e...
 RETU 1    // Sai 
ELSE
 SELE 0   // Sen�o, 
 USE (dbfsys)  // abre o arquivo de parametros
 hldias:=90    // inicialmente v�lido por 90 dias
 DO WHILE !EOF()
  IF !(DTOSVldTt(idxd))   // verifica se a data de cadastro � v�lida 
   byebye([Arquivos de Par�metros Ausentes ou danificados (D)])  // se n�o for....
   RETU 1   // sai fora 
  ELSEIF !(DTOSVldTt(idxm)) // verifica se a data de permiss�o � v�lida
   byebye([Arquivos de Par�metros Ausentes ou danificados (M)])  // se n�o for....
   RETU 1   //sai fora
  ELSE
   cond=ALLTRIM(filtro)                        // condicao de validacao
   IF (&cond.)                                 // se condicao nao satisfeita,
    IF DTOSVldChk(idxd,idxm)  // limite de execu��o default (primeira linha) 
     hldias:= MIN(hldias,(DTOSVldDt(idxm)-DTOSVldDt(idxd))) // 90 ou menos dias
	ENDI
   ENDI
  ENDIF
  SKIP
 ENDD
 //DBOX(str(hldias))
 
 // Se acabou o prazo de atualiza��o, byebye
 IF (hldias <= 0) // Prazo estourado
   MSG:="ATENCAO "+M->usuario+[|]+;
      "Erro cr?tico de sistema.|"+;
      "Entre em contato com a PresServ Inform?tica Ltda.-ME|"+;
      "pelos telefones (19)3452.3712 ou 99886.3225."
   DBOX(msg,,,25)
   RETU 1
 ELSE
   DtoSWelco(hldias)
 ENDI	
 USE
ENDI
****************************************

