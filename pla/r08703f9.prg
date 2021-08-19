procedure r08703f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08703F9.PRG
 \ Data....: 21-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Montagem dos dados dos falecimentos da circular.
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

LOCAL reg_dbf:=POINTER_DBF()
IF ultprc = CIRCULAR->grupo+CIRCULAR->circ .OR. !(TAXAS->tipo='2')
 RETU []
ENDI
AFILL(DETPRC,[])
ultprc:=CIRCULAR->grupo+CIRCULAR->circ
PTAB(ultprc,[CPRCIRC],1)
SELE CPRCIRC
contx:=0
DO WHILE .NOT. EOF() .AND. contx<LEN(detprc).AND.ultprc=grupo+circ
 IF ARQGRUP->cpadmiss=[S].AND. GRUPOS->admissao>CPRCIRC->dfal
  SKIP
  LOOP
 ENDI
 contx+=1
/*
 // Bom Pastor
 detprc[contx]:=[  ]+CPRCIRC->num+[    ]+;
                TRAN(CPRCIRC->processo,'@R 99999/99/!!')+;
                [  ]+CPRCIRC->fal+[ ]+;
                CPRCIRC->ends+[     ]+LEFT(DTOC(CPRCIRC->dfal),6)+;
                right(DTOC(CPRCIRC->dfal),2)


 // Baldochi - Ribeir„o Preto
 detprc[contx]:=[CONTR.:]+CPRCIRC->num+[->Atendido: ]+CPRCIRC->fal+;
  [ em ]+DTOC(CPRCIRC->dfal)+[ ]+CPRCIRC->cids+[ Nr.Obito:]+CPRCIRC->processo

 // Geral - Padrao
 detprc[contx]:=CPRCIRC->num+[ ]+CPRCIRC->fal+[ ]+DTOC(CPRCIRC->dfal)+;
 [ ]+CPRCIRC->cids+[ ]+CPRCIRC->processo
*/
 // Brotas
 detprc[contx]:=TRAN(CPRCIRC->processo,'@R 99999/99/!!')+[  ]+;
                CPRCIRC->categ+[  ]+;
                CPRCIRC->fal+[ ]+;
                CPRCIRC->ends+[     ]+LEFT(DTOC(CPRCIRC->dfal),6)+;
                right(DTOC(CPRCIRC->dfal),2)
/*
 // Bracalente
 detprc[contx]:=CPRCIRC->num+[    ]+CPRCIRC->fal+[  ]+;
                LEFT(DTOC(CPRCIRC->dfal),6)+right(DTOC(CPRCIRC->dfal),2)
*/
 // Dois Corregos
 detprc[contx]:= CPRCIRC->num+[ ]+;
                 LEFT(DTOC(CPRCIRC->dfal),6)+right(DTOC(CPRCIRC->dfal),2)+;
                 [ ]+CPRCIRC->fal

 SKIP
ENDDO

POINTER_DBF(reg_dbf)

RETU []      // <- deve retornar um valor qualquer

* \\ Final de R08703F9.PRG
