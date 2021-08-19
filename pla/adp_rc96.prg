procedure adp_rc96
 /*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ADP_R096.PRG
 \ Data....: 01-02-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Gerar FCC dos Boletos - C.E.F.
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "finbig.ch"    // inicializa constantes manifestas

LOCAL dele_atu
LOCAL linharet := ""
LOCAL nHandlex := 0
LOCAL nBytes  := 0
LOCAL nlinhas := 0
LOCAL nLenRarqret:=74
LOCAL qtbolbaix :=0

PARA  lin_menu, col_menu
nucop=1


titrel:=criterio:=cpord := ""                      // inicializa variaveis
titrel:=chv_rela:=chv_1:=chv_2 := ""
tps:=op_x:=ccop := 1

ferrorf=[bxerr.txt]
Rarqret:=SPACE(40)
rnrfcc:=[        ]
rblocksize:=rreadsize:=401
IF FILE('MR096VAR.MEM')
 REST FROM MR096VAR ADDITIVE
ENDI

msg="Informe o nome do arquivo retorno"
Rarqret=DBOX(msg,,,,,"ATEN€ŽO!",LEFT(Rarqret+SPACE(nLenRarqret),nLenRarqret),"@!")    // confirma a data
SAVE TO MR096VAR ALL LIKE R*

IF !FILE(Rarqret)
 DBOX("Arquivo N„o Encontrado")
 RETU
ELSEIF Rarqret=[MR096VAR.ERR]
 REST FROM MR096VAR.ERR ADDITIVE
 DBOX(mregerr,,,.t.,,[MR096VAR.ERR - Falhas detectadas])
 RETU
ENDI

#ifdef COM_REDE
 IF !USEARQ("BAIXAS",.t.,10,1)                      // se falhou a abertura do arq
        RETU                                             // volta ao menu anterior
 ENDI
#else
 USEARQ("BAIXAS")                                   // abre o dbf e seus indices
#endi

FOR i=1 TO FCOU()
 msg=FIEL(i)
 PRIV &msg.
NEXT
go bott

SAVE TO MR096VAR ALL LIKE R*

dele_atu:=SET(_SET_DELETED,.t.)                    // os excluidos nao servem...


msgt="PROCESSAMENTOS DA BAIXA|GERAR BAIXA DOS BOLETOS"
ALERTA()
op_=DBOX("Prosseguir|Cancelar opera‡„o",,,E_MENU,,msgt)
MSEQ:=0
IF op_=1
 #ifdef COM_REDE
  IF !USEARQ("LANCTOS",.t.,10,1)                      // se falhou a abertura do arq
   RETU                                             // volta ao menu anterior
  ENDI
 #else
  USEARQ("LANCTOS")                                   // abre o dbf e seus indices
 #endi
 cpord="documento"
 chv_rela:=chv_1:=chv_2 := ""
 tps:=op_x:=ccop := 1
 fil_ini="" //"EMPT(baixa_)"
 INDTMP()
 DBOX("Processando registros|.|",,,,NAO_APAGA,"AGUARDE!")
 dele_atu:=SET(_SET_DELETED,.t.)                   // os excluidos nao servem...
 rreadsize:=rblocksize
 linharet := SPACE( rreadsize )
 nHandlex := FOPEN( Rarqret )
 linharet := FGets( nHandlex, 1, rBlockSize)
 databx:=substr(linharet,rDtIni,rDtlen)
 linharet:=FGets( nHandlex, 1, rreadsize)
 mregerr=[ * * * Inicio * * * |] //Inicia a variavel de Mensagem contendo registros errados que nao serem baixados
 DO WHILE !EMPT(linharet).AND.FERROR()= 0
  nlinhas++
  bol_chk:=substr(linharet,rCkIni,rCklen)
  IF bol_chk# rbolchk
   linharet:=FGets( nHandlex, 1, rreadsize)
   loop
  ENDI
  IF rDtline=0
   databx:=substr(linharet,rDtIni,rDtlen)
   IF rDtType=0
    databx:=CTOD(TRAN(databx,[@R 99/99/9999]))
   ELSEIF rDtType=1
    databx:=cTOd(TRAN(databx,[@R 99/99/99]))
   ELSEIF rDtType=2
    databx:=ctod(right(databx,2)+[/]+substr(databx,5,2)+[/]+left(databx,4))
   ELSEIF rDtType=3
    databx:=ctod(right(databx,2)+[/]+substr(databx,5,2)+[/]+left(databx,2))
   ENDI
  ELSEIF rDtline==nlinhas
   IF rDtType=0
    databx:=CTOD(TRAN(databx,[@R 99/99/9999]))
   ELSEIF rDtType=1
    databx:=cTOd(TRAN(databx,[@R 99/99/99]))
   ELSEIF rDtType=2
    databx:=ctod(right(databx,2)+[/]+substr(databx,5,2)+[/]+left(databx,4))
   ELSEIF rDtType=3
    databx:=ctod(right(databx,2)+[/]+substr(databx,5,2)+[/]+left(databx,2))
   ENDI
  ENDI

  vlbolbx:=VAL(substr(linharet,rVlIni,rVllen))/100
  nnbolbx:=substr(linharet,rNnIni,rNnlen) //Numero do docto (SeuNumero)
  nrbolbx:=substr(linharet,rNrIni,rNrlen) //Numero do Banco (NossoNumero)

  nrbolvali:=substr(linharet,rValiBxIni,rValiBxLen) //Digito de validacao

  go top
  SEEK nnbolbx
  IF ! (nrbolvali$rbolvali) //Se nao contiver os caracteres de validacao.
   mregerr+=[Boleto: ]+ALLTRIM(nnbolbx)+[ Valor:]+STR(vlbolbx)+[  INVALIDO  ]+[|]
  ELSEIF EOF() //Nao encontrado, numero errado
   mregerr+=[Boleto: ]+ALLTRIM(nnbolbx)+[ Valor:]+STR(vlbolbx)+[ Nao encont.|]
  ELSEIF !EMPT(LANCTOS->vlrtotbaix) //J  baixado
   mregerr+=[Boleto: ]+ALLTRIM(nnbolbx)+[ Valor:]+STR(vlbolbx)+[ * Baixado *|]
  ELSE

   // Lanca a baixa
   SELE BAIXAS                                      // arquivo alvo do lancamento
   #ifdef COM_REDE
    DO WHIL .t.
     APPE BLAN                                     // tenta abri-lo
     IF NETERR()                                   // nao conseguiu
      DBOX(ms_uso,20)                              // avisa e
      LOOP                                         // tenta novamente
     ENDI
     EXIT                                          // ok. registro criado
    ENDD
   #else
    APPE BLAN                                      // cria registro em branco
   #endi

   REPL BAIXAS->numero WITH LANCTOS->numos,;
	BAIXAS->lancto_ WITH DATE(),;
	BAIXAS->por WITH M->rnrfcc,;
	BAIXAS->pagto_ WITH databx,;
	BAIXAS->vlpagdinh WITH vlbolbx,;
	BAIXAS->tipobaixa WITH [P],;
	BAIXAS->contabaixa WITH M->preceber,;
	BAIXAS->docbaixa WITH nrbolbx
   IF !EMPT(LANCTOS->contabaixa).AND.LANCTOS->contabaixa#M->preceber
    mregerr+=[Conta ]+ALLTRIM(LANCTOS->contabaixa)+[ do Lancamento ]+ALLTRIM(LANCTOS->numos)+;
	     [ foi refeita para ]+ALLTRIM(M->preceber)+[|]
   ENDI
   // Baixa o Lancamento
   REPL LANCTOS->vlrtotbaix WITH LANCTOS->vlrtotbaix+vlpagdinh+vlpagcheq
   IF op_menu=INCLUSAO
    lancto_=DATE()
   ELSE
    REPL lancto_ WITH DATE()
   ENDI
   REPL LANCTOS->tipobaixa WITH [E]
   REPL LANCTOS->baixa_ WITH pagto_
   REPL LANCTOS->contabaixa WITH contabaixa
   REPL LANCTOS->docbaixa WITH docbaixa
   qtbolbaix+=1
   SELE LANCTOS
  ENDI
  conterr=0
  do while conterr < 3
   linharet := SPACE( rreadsize )
   linharet:=FGets( nHandlex, 1, rreadsize)
   conterr++
   if !EMPT(linharet)//len(linharet)>=rreadsize
    conterr:=3
   endi
  endd
  SELE LANCTOS
 ENDD

 FCLOSE( nHandlex )

 IF !EMPT(mregerr)
  ALERTA(2)
  mregerr+=ALLTRIM(STR(qtbolbaix))+[ boletos baixados| * * * FIM * * * ]
  DBOX(mregerr,,,.t.,,[Boletos n„o baixados. Verifique manualmente!])
  SAVE TO mr096var.err ALL LIKE mregerr
 ENDI
 ALERTA(2)
ENDI
SELE BAIXAS                                       // salta pagina
SET RELA TO                                        // retira os relacionamentos
SET(_SET_DELETED,dele_atu)                         // os excluidos serao vistos
RETU

* \\ Final de ADP_R096.PRG

/***
*
*  Fileio.prg
*
*  Sample user-defined functions to process binary files
*
*  Copyright (c) 1993, Computer Associates International Inc.
*  All rights reserved.
*
*  NOTE: Compile with /a /m /n /w
*/

#include "Common.ch"
#include "Fileio.ch"


/***
*
*  FGets( <nHandle>, [<nLines>], [<nLineLength>], [<cDelim>] ) --> cBuffer
*
*  Read one or more lines from a text file
*
*/
FUNCTION FGets( nHandle, nLines, nLineLength, cDelim )
   RETURN ( FReadLn( nHandle, nLines, nLineLength, cDelim ) )



/***
*
*  FPuts( <nHandle>, <cString>, [<nLength>], [<cDelim>] ) --> nBytes
*
*  Write a line to a text file
*
*/
FUNCTION FPuts( nHandle, cString, nLength, cDelim )
   RETURN ( FWriteLn( nHandle, cString, nLength, cDelim ) )



/***
*
*  DirEval( <cMask>, <bAction> ) --> aArray
*
*  Apply a code block to each file matching a skeleton
*
*/
FUNCTION DirEval( cMask, bAction )
   RETURN ( AEVAL( DIRECTORY( cMask ), bAction ) )



/***
*
*  FileTop( <nHandle> ) --> nPos
*
*  Position the file pointer to the first byte in a binary file and return
*  the new file position (i.e., 0).
*
*/
FUNCTION FileTop( nHandle )
   RETURN ( FSEEK( nHandle, 0 ) )



/***
*
*  FileBottom( <nHandle> ) --> nPos
*
*  Position the file pointer to the last byte in a binary file and return
*  the new file position
*
*/
FUNCTION FileBottom( nHandle )
   RETURN ( FSEEK( nHandle, 0, FS_END ) )



/***
*
*  FilePos( <nHandle> ) --> nPos
*
*  Report the current position of the file pointer in a binary file
*
*/
FUNCTION FilePos( nHandle )
   RETURN ( FSEEK( nHandle, 0, FS_RELATIVE ) )



/***
*
*  FileSize( <nHandle> ) --> nBytes
*
*  Return the size of a binary file
*
*/
FUNCTION FileSize( nHandle )
   
   LOCAL nCurrent
   LOCAL nLength

   // Get file position
   nCurrent := FilePos( nHandle )

   // Get file length
   nLength := FSEEK( nHandle, 0, FS_END )

   // Reset file position
   FSEEK( nHandle, nCurrent )

   RETURN ( nLength )



/***
*
*  FReadLn( <nHandle>, [<nLines>], [<nLineLength>], [<cDelim>] ) --> cLines
*
*  Read one or more lines from a text file
*
*  NOTES:
*     Line length includes delimiter, so max line read is
*     (nLineLength - LEN( cDelim ))
*
*     Return value includes delimiters, if delimiter was read
*
*     nLines defaults to 1, nLineLength to 80 and cDelim to CRLF
*
*     FERROR() must be checked to see if FReadLn() was successful
*
*     FReadLn() returns "" when EOF is reached
*
*/
FUNCTION FReadLn( nHandle, nLines, nLineLength, cDelim )
   
   LOCAL nCurPos        // Current position in file
   LOCAL nFileSize      // The size of the file
   LOCAL nChrsToRead    // Number of character to read
   LOCAL nChrsRead      // Number of characters actually read
   LOCAL cBuffer        // File read buffer
   LOCAL cLines         // Return value, the lines read
   LOCAL nCount         // Counts number of lines read
   LOCAL nEOLPos        // Position of EOL in cBuffer

   DEFAULT nLines      TO 1
   DEFAULT nLineLength TO 80
   DEFAULT cDelim      TO ( CHR(13) + CHR(10) )

   nCurPos   := FilePos( nHandle )
   nFileSize := FileSize( nHandle )

   // Make sure no attempt is made to read past EOF
   nChrsToRead := MIN( nLineLength, nFileSize - nCurPos )

   cLines  := ''
   nCount  := 1
   DO WHILE (( nCount <= nLines ) .AND. ( nChrsToRead != 0 ))
      
      cBuffer   := SPACE( nChrsToRead )
      nChrsRead := FREAD( nHandle, @cBuffer, nChrsToRead )

      // Check for error condition
      IF !(nChrsRead == nChrsToRead)
         // Error!
         // In order to stay conceptually compatible with the other
         // low-level file functions, force the user to check FERROR()
         // (which was set by the FREAD() above) to discover this fact
         //
         nChrsToRead := 0
      ENDIF

      nEOLPos := AT( cDelim, cBuffer )

      // Update buffer and current file position
      IF ( nEOLPos == 0 )
         cLines  += LEFT( cBuffer, nChrsRead )
         nCurPos += nChrsRead
      ELSE
         cLines  += LEFT( cBuffer, ( nEOLPos + LEN( cDelim ) ) - 1 )
         nCurPos += ( nEOLPos + LEN( cDelim ) ) - 1
         FSEEK( nHandle, nCurPos, FS_SET )
      ENDIF

      // Make sure we don't try to read past EOF
      IF (( nFileSize - nCurPos ) < nLineLength )
         nChrsToRead := ( nFileSize - nCurPos )
      ENDIF

      nCount++

   ENDDO

   RETURN ( cLines )



/***
*
*  FileEval( <nHandle>, [<nLineLength>], [<cDelim>], ;
*            <bBlock>, 
*            [<bForCondition>], 
*            [<bWhileCondition>],
*            [<nNextLines>],
*            [<nLine>],
*            [<lRest>] )   --> NIL
*
*  Apply a code block to lines in a binary file using DBEVAL() as a model.
*  If the intent is to modify the file, the output must be written to a
*  temporary file and copied over the original when done.
*
*  NOTES:
*     <bBlock>, <bForCondition> and <bWhileCondition> are passed a
*     line of the file
*
*     The defaults for nLineLength and cDelim are the same as those
*     for FReadLn()
*
*     The default for the rest of the parameters is that same as for
*     DBEVAL().
*
*     Any past EOF requests (nLine > last line in file, etc.) are ignored
*     and no error is generated.  The file pointer will be left at EOF.
*
*     Check FERROR() to see if it was successful
*
*/
PROCEDURE FileEval( nHandle, nLineLength, cDelim, bBlock, bFor, bWhile, ;
                    nNextLines, nLine, lRest )

   LOCAL cLine          // Contains current line being acted on
   LOCAL lEOF := .F.    // EOF status
   LOCAL nPrevPos       // Previous file position

   DEFAULT bWhile TO {|| .T. }
   DEFAULT bFor   TO {|| .T. }

   // lRest == .T. means stay where I am.  Anything else means start from
   // the top of the file
   IF ! ( ( VALTYPE(lRest) == 'L' ) .AND. ( lRest == .T. ) )
      FileTop( nHandle )
   ENDIF

   BEGIN SEQUENCE
      
      IF nLine != NIL

         // Process only that one record
         nNextLines := 1

         FileTop( nHandle )

         IF nLine > 1
            cLine := FReadLn( nHandle, 1, nLineLength, cDelim )
            IF FERROR() != 0
               BREAK    // An error occurred, jump out of the SEQUENCE
            ENDIF

            // If cLine is a null string, we're at end of file
            lEOF := ( cLine == "" )
            nLine--
         ENDIF

         // Move to that record (nLine will equal 1 when we are there)
         DO WHILE ( ! lEOF  ) .AND. (nLine > 1)
            cLine := FReadLn( nHandle, 1, nLineLength, cDelim )
            IF FERROR() != 0
               BREAK          // NOTE: will break out of SEQUENCE
            ENDIF

            lEOF := ( cLine == "" )
            nLine--
         ENDDO

      ENDIF

      // Save starting position
      nPrevPos := FilePos( nHandle)

      // If there is more to read from here, get the first line for
      // comparison and potential processing 
      IF ( ! lEOF ) .AND. (nNextLines == NIL .OR. nNextLines > 0)
         cLine := FReadLn( nHandle, 1, nLineLength, cDelim )
         IF FERROR() != 0
            BREAK             // NOTE
         ENDIF

         lEOF := ( cLine == "" )
      ENDIF

      DO WHILE ( ! lEOF ) .AND. EVAL( bWhile, cLine )      ;
               .AND. (nNextLines == NIL .OR. nNextLines > 0)

         IF EVAL( bFor, cLine )
            EVAL( bBlock, cLine )
         ENDIF

         // Save start of line
         nPrevPos := FilePos( nHandle )

         // Read next line
         cLine    := FReadLn( nHandle, 1, nLineLength, cDelim )
         IF FERROR() != 0
            BREAK
         ENDIF

         lEOF := ( cLine == "" )

         IF nNextLines != NIL
            nNextLines--
         ENDIF

      ENDDO

      // If the reason for ending was that I ran past the WHILE or the number
      // of lines specified, back up to the beginning of the line that failed
      // so that there is no gap in processing
      //
      IF ( ! EVAL( bWhile, cLine ) ) .OR. ;
         ( (nNextLines != NIL) .AND. (nNextLines == 0) )

         FSEEK( nHandle, nPrevPos, FS_SET )

      ENDIF

   END SEQUENCE

   RETURN



/***
*
*  FEof( <nHandle> ) --> lBoundary
*
*  Determine if the current file pointer position is the last
*  byte in the file
*
*/
FUNCTION FEof( nHandle )
   RETURN ( IF( FileSize( nHandle ) == FilePos( nHandle ), .T., .F. ))



/***
*
*  FWriteLn( <nHandle>, <cString>, [<nLength>], [<cDelim>] ) --> nBytes
*
*  Write a line to a text file at the current file pointer position.
*  
*  NOTES:
*     Check FERROR() for the error
*
*     nLength defaults to length of entire string + delim, cDelim
*     defaults to CHR(13) + CHR(10)
*
*     Return value includes length of delimiter
*
*/
FUNCTION FWriteLn( nHandle, cString, nLength, cDelim )

   IF cDelim == NIL
      cString += CHR(13) + CHR(10)
   ELSE
      cString += cDelim
   ENDIF

   RETURN ( FWRITE( nHandle, cString, nLength ) )
