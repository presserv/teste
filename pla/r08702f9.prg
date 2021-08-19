procedure r08702f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08701F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valor Total do relat¢rio ADP_R087
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

 LOCAL reg_dbf1:=POINTER_DBF()
 PARA DATAVC
 cod:=codigo     // C¢digo da taxa a imprimir
 emx:=emissao_   // Emiss„o da taxa a ser impressa...
 keycst:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
 M->recvalor:=IIF(M->racum=[S],0,valor)
 vlseg:=vlcst:=vlout:=0
 M->contx:=0
 afill(detcst,[])
 IF PTAB(keycst,[CSTSEG],3,.t.)
	SELE CSTSEG
	DO WHILE ! EOF() .AND. keycst = contrato+tipo+circ
	 contx+=1
	 IF CONTX<11
		detcst[contx]:=&drvpcom+DTOC(CSTSEG->emissao_)+[ ]+;
		LEFT(CSTSEG->complement,30)+[ ]+;
		TRANSF(CSTSEG->QTDADE,"999")+;
		TRANSF(CSTSEG->valor,"@E 9,999.99")+&drvtcom
	 ENDI

	 IF "LOCACAO" $ UPPER(CSTSEG->complement)
		vlcst+=CSTSEG->valor  // Total de locacao

	 ELSEIF "AUXILIO"  $ UPPER(CSTSEG->complement)
		vlseg+=CSTSEG->valor  // Total de seguro

	 ELSE
		vlout+=CSTSEG->valor  // Outros custos adicionais
	 ENDI

	 SKIP
	ENDDO
	SELE TAXAS
 ENDI

 SELE TAXAS

 PTAB(cod,'TAXAS',1,.t.)

 M->contx:=0
 lindeb:=[]
 afill(detdeb,[])
 DO WHILE !EOF().AND.TAXAS->codigo=cod.AND.M->racum=[S]
	IF TAXAS->valorpg>0         // Somente taxas pendentes
	 SKIP
	 LOOP
	ENDI

// Ser„o consideradas vencidas as taxas anteriores a emiss„o da
// que ser  impressa.

	IF TAXAS->emissao_ <= emx .AND.TAXAS->tipo$M->rtipo // Somente taxas pendentes

// ·s Empresas que pedirem a corre‡Æo do valor acumulado, colocar
// um "S" a mais na vari vel de acumulos M->racum.
   IF M->racum=[SS]
	  M->recvalor+=ATUVALOR(taxas->tipo,TAXAS->valor,TAXAS->emissao_,IIF(PCOUNT()=0,emx,DATAVC))
   ELSE
	  M->recvalor+=TAXAS->valor
   ENDI
   keycst:=TAXAS->codigo+TAXAS->tipo+TAXAS->circ
	 IF PTAB(keycst,[CSTSEG],3)
    SELE CSTSEG
		DO WHILE ! EOF() .AND. keycst = contrato+tipo+circ
		 IF [AUXILIO]$UPPER(CSTSEG->complement)
      vlseg+=CSTSEG->valor
     ENDI
		 SKIP
    ENDDO
    SELE TAXAS
   ENDI

   IF TAXAS->emissao_ < emx // detalha somente as taxas atrasadas.
    contx+=1
    IF CONTX<11             // as ultimas 10 parcelas
	  	detdeb[contx]:=TAXAS->tipo+[ ]+TAXAS->circ+[ ]+;
                     DTOC(TAXAS->emissao_)
/*       LEFT(DTOC(TAXAS->emissao_),6)+RIGHT(DTOC(TAXAS->emissao_),2)
      +[ ]+;
	  	TRANSF(TAXAS->valor,"@E 9,999.99")+[ | ]
*/
    ENDI
		lindeb+=TAXAS->tipo+[-]+TAXAS->circ+[, ]//+DTOC(TAXAS->emissao_)
   ENDI
  ENDI
  SKIP
 ENDDO

 M->recvalor-=(M->vlseg+M->vlcst+M->vlout)
// dbox([recvalor ]+str(M->recvalor)+[|vlseg ]+str(M->vlseg)+[|vlcst ]+str(vlcst))

 POINTER_DBF(reg_dbf1)

RETU M->recvalor          // <- deve retornar um valor qualquer

* \\ Final de R08701F9.PRG
