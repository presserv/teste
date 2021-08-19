#include "inkey.ch"
#include "setcurs.ch"
#include "dbinfo.ch"

* Esta rotina retorna apenas o caminho nÑo retornando o drive
Static Static11,Static13:= {},Static14:= "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%",Static15:= {"412321214","214321214","414321212","212341214","412341212","214341212","212321414","412321412","214321412","212341412","412123214","214123214","414123212", ;
   "212143214","412143212","214143212","212123414","412123412","214123412","212143412","412121234","214121234","414121232","212141234","412141232","214141232","212121434","412121432","214121432","212141432","432121214","234121214","434121212", ;
   "232141214","432141212","234141212","232121414","432121412","234121412","232141412","232323212","232321232","232123232","212323232",Nil},Static16:= "0123456789",Static17:= "212",Static18:= "12121",Static19:= {"1112212","1122112","1121122","1222212", ;
   "1211122","1221112","1212222","1222122","1221222","1112122"},Static20:= {"1211222","1221122","1122122","1211112","1122212","1222112","1111212","1121112","1112112","1121222"},Static21:= {"2221121","2211221","2212211","2111121","2122211","2112221", ;
   "2121111","2111211","2112111","2221211"},Static22:= {"AAAAAA","AABABB","AABBAB","AABBBA","ABAABB","ABBAAB","ABBBAA","ABABAB","ABABBA","ABBABA"},Static23:= {"22442","42224","24224","44222","22424","42422","24422","22244","42242","24242",Nil}, ;
   Static24:= {"11331","31113","13113","33111","11313","31311","13311","11133","31131","13131",Nil}

*---------------------
*---------------------
function nomeexe()
local drive,path,exe
drive:=hb_curdrive()
path:=curdir()
exe=upper(alltrim(getenv("CMDLINE")))  // nao funciona
if " "$exe
   exe=left(exe,at(" ",exe))
endif
if !(".EXE"$exe .or. ".COM"$exe)
   if file(exe+".COM")
      exe=exe+".COM"
   else
      exe=exe+".EXE"
   endif
endif
return upper(drive+':\'+path+"\"+exe)

procedure setrhs
return .f.

procedure fileattrib
return 0

procedure impok
return .t.

procedure fontevga
return .t.

procedure fonetica
return ""

procedure conta
local i,quantos
quantos:=0
parameters oque,onde
for i=1 to len(onde)
   if substr(onde,i,len(oque))=oque
      quantos++
   end if
next
return quantos

procedure _conta
return


procedure ltoc(condicao)
if condicao
   return "T"
else
   return "F"
end if

procedure strseg
return 0

procedure string
return ""

procedure peek
return 0

procedure poke
return .t.

procedure ok_print(vlin)
if at('',vlin)>0 .or. at('',vlin)>0 .or.;
   at('',vlin)>0 .or. at('',vlin)>0 .or. at('',vlin)>0
   return .f.
else
   return .t.
endif

procedure callint
return .f.

function mkdir(vdiretorio) // falta
return .f. // dirmake(vdiretorio)==0

function rmdir(vdiretorio)
return dirremove(vdiretorio)

* procura a existencia de um diretorio
function chdir(vdiretorio)
return DirChange(vdiretorio)==0


procedure drive
return "AC"

procedure qdrive
return 2

procedure tamdisco
return 1000000 //DiskTotal()

procedure qualdir
return upper(LEFT(nomeexe(),RAT("\",nomeexe())))


function sepletra(string,espacos)
local resultado,i
resultado=""
for i=1 to len(string)
   resultado=resultado+substr(string,i,1)+space(espacos)
next
return resultado

procedure tamastr

procedure chdrive
return .f.

procedure hexa_dec

procedure alocamem

procedure qde_free

function vuf(estado)
if estado$"ACÚALÚAPÚAMÚBAÚCEÚDFÚESÚTOÚGOÚMAÚMTÚMSÚMGÚPAÚPBÚPRÚPEÚPIÚRNÚRSÚRJÚROÚRRÚSCÚSPÚSEÚEX"
   return .t.
else
   return .f.
end if

procedure rwrite

return .f.

procedure ronly
return .f.

procedure dosdata(xdata)
* Seta a data do sistema
LOCAL cmd
cmd:="DATE "+xdata
RUN (cmd)
return DTOC(DATE())=xdata

procedure f_error
return 0

procedure is_ferror
return .f.

procedure clr_ferror
return .f.

procedure set_ferror
return .f.

Function BWISEAND(xArg1,xArg2)
   Local xVar1,xVar2
   xVar2:= {0,0,0,0,0,0,0,0}
   If (ValType(xArg1) = "C")
      xVar1:= Asc(xArg1)
   Else
      xVar1:= xArg1
   EndIf
   If (xVar1 >= 128)
      xVar2[8]:= 1
      xVar1:= xVar1-128
   EndIf
   If (xVar1 >= 64)
      xVar2[7]:= 1
      xVar1:= xVar1-64
   EndIf
   If (xVar1 >= 32)
      xVar2[6]:= 1
      xVar1:= xVar1-32
   EndIf
   If (xVar1 >= 16)
      xVar2[5]:= 1
      xVar1:= xVar1-16
   EndIf
   If (xVar1 >= 8)
      xVar2[4]:= 1
      xVar1:= xVar1-8
   EndIf
   If (xVar1 >= 4)
      xVar2[3]:= 1
      xVar1:= xVar1-4
   EndIf
   If (xVar1 >= 2)
      xVar2[2]:= 1
      xVar1:= xVar1-2
   EndIf
   If (xVar1 >= 1)
      xVar2[1]:= 1
   EndIf
   Return xVar2[xArg2+1]

Function DTOM(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5
   If (ValType(xArg1) = "D")
      xVar1:= DToC(xArg1)
   Else
      xVar1:= xArg1
   EndIf
   s_e_p:= SubStr(xVar1,3,1)
   If (Asc(s_e_p) >= 48 .AND. Asc(s_e_p) <= 57)
      s_e_p:= ""
   EndIf
   xVar2:= Val(SubStr(xVar1,1,2))
   xVar3:= Val(SubStr(xVar1,3+Len(s_e_p),2))
   xVar4:= Val(SubStr(xVar1,5+2*Len(s_e_p)))
   xVar5:= xVar4*365+Int((xVar4-1)/4)+(xVar3-1)*28+Val(SubStr("000303060811131619212426",(xVar3-1)*2+1,2))+xVar2
   If (xVar3 > 2 .AND. xVar4%4 = 0)
      xVar5++
   EndIf
   Return xVar5*1440+Val(Left(xArg2,2))*60+Val(SubStr(xArg2,4,2))

Function IMPGRANDE(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6)
Return ""

Function EXTENSAO(xArg1)
Local xVar1
xVar1:= Upper(indexext())
xArg1:= IIf(xArg1 = Nil,.T.,xArg1)
If (!xArg1)
   If (xVar1 = ".NSX")  // de .CDX para .NSX
      xVar1:= ".SMT"    // de .FPT para .SMT
   Else
      xVar1:= ".DBT"
   EndIf
endIf
Return xVar1


Function IDATA(xArg1)
   Local xVar1,xVar2
   xArg1:= Trim(xArg1)
   xVar1:= Len(xArg1)
   If (xVar1 = 4)
      xVar2:= SubStr(xArg1,3,2)+SubStr(xArg1,1,2)
   Else
      If (xVar1 = 5)
         xVar2:= SubStr(xArg1,4,2)+SubStr(xArg1,3,1)+SubStr(xArg1,1,2)
      Else
         If (xVar1 = 6)
            If (Val(SubStr(xArg1,3,2)) > 12)
               xVar2:= SubStr(xArg1,3,4)+SubStr(xArg1,1,2)
            Else
               xVar2:= SubStr(xArg1,5,2)+SubStr(xArg1,3,2)+SubStr(xArg1,1,2)
            EndIf
         Else
            If (xVar1 = 7)
               xVar2:= SubStr(xArg1,4,4)+SubStr(xArg1,3,1)+SubStr(xArg1,1,2)
            Else
               If (xVar1 = 8)
                  If (Asc(SubStr(xArg1,3,1)) >= 48 .AND. Asc(SubStr(xArg1,3,1)) <= 57)
                     xVar2:= SubStr(xArg1,5,4)+SubStr(xArg1,3,2)+SubStr(xArg1,1,2)
                  Else
                     xVar2:= SubStr(xArg1,7,2)+SubStr(xArg1,3,1)+SubStr(xArg1,4,2)+SubStr(xArg1,3,1)+SubStr(xArg1,1,2)
                  EndIf
               Else
                  If (xVar1 = 10)
                     xVar2:= SubStr(xArg1,7,4)+SubStr(xArg1,3,1)+SubStr(xArg1,4,2)+SubStr(xArg1,3,1)+SubStr(xArg1,1,2)
                  Else
                     xVar2:= xArg1
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndIf
   Return xVar2

Function IMGPACK(xArg1)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10,xVar11,xVar12
   xVar5:= xArg1+".dbi"
   xVar6:= xArg1+".bak"
   If (!file(xVar5))
      Return Nil
   EndIf
   xVar1:= fopen(xVar5)
   xVar2:= fcreate(xVar6)
   xVar11:= .T.
   Goto Top
   Do While (!EOF())
      For xVar4:= 1 To FCount()
         If (sistema[op_sis][12][xVar4][1] = "IMG" .AND. !Empty((xVar10:= FieldName(xVar4),&xVar10)))
            xVar12:= ""
            xVar3:= Asc(SubStr(&xVar10,5,1))*2+bin2l(Left(&xVar10,4))
            fseek(xVar1,xVar3)
            buffer_pcx:= Space(5)
            xVar7:= fread(xVar1,@buffer_pcx,5)
            If (xVar7 == 5)
               If (Asc(right(buffer_pcx,1)) == 0)
                  xVar8:= bin2l(Left(buffer_pcx,4))
                  xVar3:= fseek(xVar2,0,1)
                  xVar9:= Int(xVar3/2)
                  xVar3:= xVar3-xVar9*2
                  xVar12:= l2bin(xVar3)+Chr(xVar9)+Chr(0)
                  fwrite(xVar2,buffer_pcx,5)
                  For xVar9:= 1 To Int(xVar8/10000)
                     buffer_pcx:= Space(10000)
                     xVar7:= fread(xVar1,@buffer_pcx,10000)
                     If (xVar7 # 10000)
                        xVar12:= ""
                        Exit
                     EndIf
                     fwrite(xVar2,buffer_pcx,xVar7)
                  Next
                  xVar9:= xVar8-Int(xVar8/10000)*10000
                  buffer_pcx:= Space(xVar9)
                  xVar7:= fread(xVar1,@buffer_pcx,xVar9)
                  fwrite(xVar2,buffer_pcx,xVar7)
                  xVar11:= .F.
               EndIf
            EndIf
            Replace &xVar10 With xVar12
         EndIf
      Next
      Skip
   EndDo
   fclose(xVar1)
   fclose(xVar2)
   If (xVar11)
      Erase (xVar5)
   Else
      Copy File (xVar6) To (xVar5)
   EndIf
   Erase (xVar6)
   Return Nil

Function IMGEXTRAI()  // nao tratada
RETU ''

Function IMGGRAVA(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4
   If (file(xArg1))
      xVar1:= fopen(xArg1,2)
   Else
      xVar1:= fcreate(xArg1)
   EndIf
   If (ferror() # 0)
      fclose(xVar1)
      Return "-1"
   EndIf
   fseek(xVar1,0,2)
   xVar3:= fseek(xVar1,0,1)
   xVar2:= fopen(xArg2)
   If (ferror() # 0)
      Return "-1"
   EndIf
   buffer_pcx:= Space(128)
   xVar4:= fread(xVar2,@buffer_pcx,128)
   If (xVar4 # 128 .AND. Asc(buffer_pcx) # 10 .AND. Asc(SubStr(buffer_pcx,3,1)) # 1)
      fclose(xVar1)
      fclose(xVar2)
      Return "-1"
   EndIf
   xVar4:= fseek(xVar2,0,2)
   fseek(xVar2,0)
   buffer_pcx:= l2bin(xVar4)+Chr(0)
   fwrite(xVar1,buffer_pcx,5)
   fseek(xVar2,0)
   xVar4:= 512
   Do While (xVar4 = 512)
      buffer_pcx:= Space(512)
      xVar4:= fread(xVar2,@buffer_pcx,512)
      fwrite(xVar1,buffer_pcx,xVar4)
   EndDo
   fclose(xVar1)
   fclose(xVar2)
   xVar4:= Int(xVar3/2)
   xVar3:= xVar3-xVar4*2
   Return l2bin(xVar3)+Chr(xVar4)+Chr(0)

Function CBEAN(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5
   xVar2:= "212"
   xVar3:= Len(xArg2)
   If (xArg1 == 1 .AND. !(xVar3 == 13))
      Return ""
   Else
      If (xArg1 == 2 .AND. !(xVar3 == 8))
         Return ""
      Else
         If (xArg1 == 3 .AND. !(xVar3 == 12))
            Return ""
         EndIf
      EndIf
   EndIf
   For xVar1:= 1 To xVar3
      If ((xVar4:= At(SubStr(xArg2,xVar1,1),Static16)) > 0)
         Do Case
         Case xArg1==1
            If (xVar1 == 1)
               xVar5:= Static22[xVar4]
            Else
               If (xVar1 <= 7)
                  If (SubStr(xVar5,xVar1-1,1) == "A")
                     xVar2:= xVar2+Static19[xVar4]
                  Else
                     xVar2:= xVar2+Static20[xVar4]
                  EndIf
               Else
                  If (xVar1 == 8)
                     xVar2:= xVar2+(Static18+Static21[xVar4])
                  Else
                     xVar2:= xVar2+Static21[xVar4]
                  EndIf
               EndIf
            EndIf
         Case xArg1==2
            If (xVar1 <= 4)
               xVar2:= xVar2+Static19[xVar4]
            Else
               If (xVar1 == 5)
                  xVar2:= xVar2+(Static18+Static21[xVar4])
               Else
                  xVar2:= xVar2+Static21[xVar4]
               EndIf
            EndIf
         Case xArg1==3
            If (xVar1 <= 6)
               xVar2:= xVar2+Static19[xVar4]
            Else
               If (xVar1 == 7)
                  xVar2:= xVar2+(Static18+Static21[xVar4])
               Else
                  xVar2:= xVar2+Static21[xVar4]
               EndIf
            EndIf
         EndCase
      EndIf
   Next
   xVar2:= xVar2+"212"
   Return LTrim(Str(xArg1))+xVar2

//-------------------------------------------------------------------
Function CB25INT(xArg1)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6
   
   xVar2:= ""
   If (!(Int(Len(Trim(xArg1))%2) == 0))
      xArg1:= "0"+xArg1
   EndIf
   xVar3:= Len(xArg1)
   For xVar1:= 1 To xVar3 Step 2
      xVar5:= SubStr(xArg1,xVar1,1)
      xVar6:= SubStr(xArg1,xVar1+1,1)
      For xVar4:= 1 To 5
         xVar2:= xVar2+(SubStr(Static23[At(xVar5,Static16)],xVar4,1)+SubStr(Static24[At(xVar6,Static16)],xVar4,1))
      Next
   Next
   Return LTrim(Str(5))+"2121"+xVar2+"4121"

Function CB39(xArg1)

   Local xVar1,xVar2,xVar3,xVar4
   xVar2:= ""
   xArg1:= "*"+Upper(xArg1)+"*"
   xVar3:= Len(xArg1)
   For xVar1:= 1 To xVar3
      If ((xVar4:= At(SubStr(xArg1,xVar1,1),Static14)) > 0)
         xVar2:= xVar2+(Static15[xVar4]+"1")
      EndIf
   Next
   Return LTrim(Str(4))+xVar2

Function CODBARRAS(xArg1,xArg2,xArg3)

   Local xVar1,xVar2:= "",xVar3:= .T.,xVar4:= "",xVar5,xVar6,xVar7,xVar8,xVar9
   If (xArg2 == Nil)
      xArg2:= 10
   EndIf
   If (xArg3 == Nil)
      xArg3:= 6
   EndIf
   xArg3:= IIf(xArg3 = 6,12,9)
   xVar6:= IIf(drvpadrao < "4",240,IIf(drvpadrao == "4",180,300))
   nmesq:= Set(25)+xArg1[1][4]
   If (xVar3 = montabar(1))
      col_ant:= 0
      For xVar1:= 1 To Len(xArg1)
         xVar9:= 0
         If (xArg1[xVar1][2] == 1)
            xVar4:= cbean(1,xArg1[xVar1][1])
         Else
            If (xArg1[xVar1][2] == 2)
               xVar4:= cbean(2,xArg1[xVar1][1])
            Else
               If (xArg1[xVar1][2] == 3)
                  xVar4:= cb39(xArg1[xVar1][1])
               Else
                  If (xArg1[xVar1][2] == 4)
                     xVar4:= cb25int(xArg1[xVar1][1])
                  Else
                     If (xArg1[xVar1][2] == 5)
                        xVar4:= cbean(3,xArg1[xVar1][1])
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         xVar5:= cbparc(xVar4,xArg1[xVar1][3],xArg2,xArg3,@xVar9)
         xVar2:= xVar2+xVar5
         If (xVar1 < Len(xArg1))
            xVar8:= xArg1[xVar1+1][4]-xArg1[xVar1][4]
            If (drvpadrao > "6")
               xVar2:= xVar2+(""+"&a+"+LTrim(Str(xVar8*720/xArg2-xVar9*10))+"H")
            Else
               If (drvpadrao = "4")
                  xVar2:= xVar2+Replicate(Chr(0)+Chr(0)+Chr(0),xVar8*xVar6/xArg2-Len(xVar5)/3)
               Else
                  If (drvpadrao $ "56")
                     xVar2:= xVar2+Replicate(Chr(0),xVar8*xVar6/xArg2-Len(xVar5)+4)
                  Else
                     xVar2:= xVar2+Replicate(Chr(0),xVar8*xVar6/xArg2-Len(xVar5))
                  EndIf
               EndIf
            EndIf
         EndIf
      Next
      If ((xVar3:= montabar(2,Chr(13)+Space(nmesq))) .AND. (xVar3:= codtudo(xVar2,nmesq,xArg2,xArg3,.F.)) .AND. xVar3)
         xVar3:= montabar(3)
      EndIf
      xVar7:= PRow()+1
      set_video:= Set(17,.F.)
      set_prn:= Set(23,.T.)
      For xVar1:= 1 To Len(Static13)
         ?? Static13[xVar1]
      Next
      If (drvpadrao > "6")
         ?
      EndIf
      Set Console (set_video)
      Set Printer (set_prn)
      setprc(xVar7,0)
   EndIf
   Return Nil

Function MAIUSC(xArg1)
   xArg1:= Upper(xArg1)
   For t:= 1 To 11
      xArg1:= strtran(xArg1,SubStr("á†ÖàÉäÇÑîÅ°",t,1),SubStr("ÄèAEAEêéôöI",t,1))
   Next
   Return xArg1

function paralela()
return .t.

function serial()
return .t.

function naopisca()
RETU NIL

Function NEXT_KEY
local x:= "POEHORA"
&x()
Return nextkey()

Function IN_KEY(xArg1)
   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10,xVar11,xVar12,xVar13,xVar14,xVar15,xVar16,xVar17,xVar18
   xVar1:= 0
   Private msg_mac:= ""
   acao_mac:= IIf(Type("acao_mac") = "C",acao_mac,"!")
   If (acao_mac $ "LCA")
      Clear Typeahead
      If (fat_mac == 0)
         xVar1:= inky(0)
      Else
         If (fat_mac > 0 .AND. fat_mac < 10)
            xVar1:= inky(fat_mac*0.054)
         EndIf
      EndIf
      comando_ma(xVar1)
      If (acao_mac $ "Gg")
         xVar1:= 0
      Else
         buffer_mac:= "  "
         If (fread(handle_mac,@buffer_mac,2) # 2)
            fclose(handle_mac)
            If (acao_mac = "C")
               acao_mac:= "G"
               handle_mac:= fopen(arq_mac,1)
               fseek(handle_mac,0,2)
            Else
               acao_mac:= "D"
            EndIf
         Else
            keyb_mac(buffer_mac)
            xVar1:= nextkey()
            xVar5:= IIf(xArg1 = Nil,inky(),inky(xArg1))
            If (xVar1 = -39 .AND. Type("drvcorbox") = "C")
               tmp_mac:= " "
               xVar5:= fread(handle_mac,@tmp_mac,1)
               tmp_mac:= Asc(tmp_mac)-1
               msg_mac:= ""
               For j:= 1 To 512
                  buffer_mac:= " "
                  xVar5:= fread(handle_mac,@buffer_mac,1)
                  If (xVar5 = 1 .AND. Asc(buffer_mac) # 0)
                     msg_mac:= msg_mac+buffer_mac
                  Else
                     Exit
                  EndIf
               Next
               xVar17:= Row()
               xVar18:= Col()
               Save Screen
               alerta(1)
               xVar3:= acao_mac
               acao_mac:= "D"
               xVar4:= mold
               mold:= Replicate("€",11)
               dbox(msg_mac,MaxRow()-3,Nil,tmp_mac)
               mold:= xVar4
               acao_mac:= xVar3
               Restore Screen
               @ xVar17,xVar18 Say ""
               xVar1:= IIf(LastKey() = 27,27,inky())
               comando_ma(xVar1)
               xVar1:= 0
            EndIf
         EndIf
      EndIf
   Else
      xVar1:= IIf(xArg1 = Nil,inky(),inky(xArg1))
      If (acao_mac $ "Gg")
         If (xVar1 == 10)
            alerta(1)
            acao_mac:= "D"
            fclose(handle_mac)
         Else
            If (xVar1 == 9)
               arq_i:= IIf("." $ arq_mac,Left(arq_mac,At(".",arq_mac)-1),arq_mac)+".$$$"
               If (file(arq_i))
                  pos_mac:= fseek(handle_mac,0,1)
                  handle_i:= fopen(arq_i,2)
                  xVar5:= 512
                  Do While (xVar5 = 512)
                     buffer_mac:= Space(512)
                     xVar5:= fread(handle_i,@buffer_mac,512)
                     fwrite(handle_mac,buffer_mac,xVar5)
                  EndDo
                  fclose(handle_mac)
                  fclose(handle_i)
                  Erase (arq_i)
                  handle_mac:= fopen(arq_mac,2)
                  fseek(handle_mac,pos_mac,0)
                  acao_mac:= "C"
               Else
                  acao_mac:= "G"
               EndIf
               xVar1:= 0
            Else
               fwrite(handle_mac,monta_buff(xVar1),2)
               If (xVar1 = -39 .AND. Type("drvcorbox") = "C")
                  xVar9:= SetKey(23,Nil)
                  xVar10:= SetKey(18,Nil)
                  xVar11:= SetKey(3,Nil)
                  xVar12:= SetKey(-6,Nil)
                  xVar13:= SetKey(-8,Nil)
                  xVar14:= SetKey(-7,Nil)
                  xVar15:= SetKey(19,Nil)
                  xVar16:= SetKey(4,Nil)
                  xVar3:= acao_mac
                  acao_mac:= "D"
                  xVar4:= mold
                  mold:= Replicate("€",11)
                  msg_mac:= ""
                  xVar7:= brw
                  brw:= .T.
                  xVar17:= Row()
                  xVar18:= Col()
                  xVar8:= setcursor(3)
                  xVar6:= Select()
                  Select 0
                  Do While (.T.)
                     edimemo("msg_mac","MENSAGEM A SER APRESENTADA AO USUèRIO",15,5,23,76)
                     If (Len(msg_mac) > 0 .AND. LastKey() # 27)
                        msg1:= ""
                        For xVar5:= 1 To mlcount(msg_mac,70)
                           msg1:= msg1+("|"+alltrim(memoline(msg_mac,70,xVar5)))
                        Next
                        msg1:= SubStr(msg1,2)
                        If (Len(msg1) > 512 .OR. mlcount(msg_mac) > 20)
                           alerta(2)
                           dbox("M†ximo de 512 caracteres ou 20 linhas!")
                           Loop
                        Else
                           xVar2:= dbox("Tempo de exposiáÑo",Nil,Nil,Nil,Nil,Nil,0,"99")
                           If (LastKey() == 27)
                              Loop
                           Else
                              msg1:= Chr(xVar2+1)+alltrim(msg1)+Chr(0)
                              If (fwrite(handle_mac,msg1) < Len(msg1))
                                 fclose(haldle_mac)
                                 Clear Screen
                                 readkill(.T.)
                                 getlist:= {}
                                 ? "Erro ao gravar mensagem na macro."
                                 Return
                              EndIf
                           EndIf
                        EndIf
                     EndIf
                     Exit
                  EndDo
                  Select (xVar6)
                  brw:= xVar7
                  mold:= xVar4
                  acao_mac:= xVar3
                  @ xVar17,xVar18 Say ""
                  setcursor(xVar8)
                  SetKey(23,xVar9)
                  SetKey(18,xVar10)
                  SetKey(3,xVar11)
                  SetKey(-6,xVar12)
                  SetKey(-8,xVar13)
                  SetKey(-7,xVar14)
                  SetKey(19,xVar15)
                  SetKey(4,xVar16)
               EndIf
            EndIf
         EndIf
      EndIf
   EndIf
   Return xVar1

//-------------------------------------------------------------------
Function INKY(xArg1)
   Local xVar1:= 0,xVar2,xVar3:= Seconds(),x
   Do While (.T.)
      xVar1:= InKey()
      x:= "POEHORA"
      &x()
      If (xArg1 = Nil .OR. xVar1 # 0)
         Exit
      Else
         If ((xVar2:= Seconds()-xVar3,xArg1 > 0 .AND. (xVar2 > xArg1 .OR. xVar2 < 0)))
            Exit
         EndIf
      EndIf
   EndDo

   Return xVar1

Procedure KEYB_MAC(xArg1)

//   poke(0,1050,30)
//   poke(0,1052,32)
//   poke(0,1054,Asc(xArg1))
//   poke(0,1055,Asc(SubStr(xArg1,2)))
   Return

Function MONTA_BUFF(xArg1)
   Local xVar1,xVar2
   If (xArg1 > 256)
      xVar1:= 0
      xVar2:= xArg1-256
   Else
      If (xArg1 > -1)
         xVar1:= xArg1
         xVar2:= 0
      Else
         If (xArg1 > -10)
            xVar1:= 0
            xVar2:= 59-xArg1
         Else
            If (xArg1 > -40)
               xVar1:= 0
               xVar2:= 74-xArg1
            Else
               xVar1:= 0
               xVar2:= 93-xArg1
            EndIf
         EndIf
      EndIf
   EndIf
   Return Chr(xVar1)+Chr(xVar2)

Procedure KEYBUFF(xArg1)

   If (IIf(Type("acao_mac") = "C",Upper(acao_mac) = "G" .OR. acao_mac = "D",.T.))
      Keyboard xArg1
   EndIf
   Return

Procedure POEHORA(xArg1,xArg2,xArg3)

   Local xVar1,xVar2,xVar3,xVar4
   If (Type("_ag_hora") = "C")
      If (Len(_ag_hora) == 0)
         _ag_hora:= "*"
         xVar4:= "ACAO_ALARME"
         &xVar4(.F.)
      Else
         If (_ag_hora # "*" .AND. Date() = _ag_data .AND. Left(Time(),5) >= _ag_hora)
            xVar4:= "ACAO_ALARME"
            &xVar4(.T.)
         EndIf
      EndIf
   EndIf
   If (xArg1 # Nil)
      xVar3:= .F.
      For xVar2:= 1 To Len(lin_h)
         If (lin_h[xVar2] = xArg1 .AND. col_h[xVar2] = xArg2)
            xVar3:= .T.
         EndIf
      Next
      If (!xVar3)
         AAdd(lin_h,xArg1)
         AAdd(col_h,xArg2)
         AAdd(for_h,xArg3)
         AAdd(tim_h,"")
      EndIf
   Else
      If (Type("lin_h") = "A" .AND. Len(lin_h) > 0)
         For xVar1:= 1 To Len(lin_h)
            If (tim_h[xVar1] # Left(Time(),for_h[xVar1]) .AND. (SubStr((xVar3:= SaveScreen(lin_h[xVar1],col_h[xVar1],lin_h[xVar1],col_h[xVar1]+for_h[xVar1]-1),xVar3),5,1) = ":" .OR. SubStr(xVar3,11,1) = ":"))
               tim_h[xVar1]:= Left(Time(),for_h[xVar1])
               For xVar2:= 0 To for_h[xVar1]-1
                  xVar4:= Asc(SubStr(xVar3,xVar2*2+1,1))
                  If (xVar4 >= 48 .AND. xVar4 <= 57)
                     xVar3:= Left(xVar3,xVar2*2)+SubStr(tim_h[xVar1],xVar2+1,1)+SubStr(xVar3,xVar2*2+2)
                  EndIf
               Next
               RestScreen(lin_h[xVar1],col_h[xVar1],lin_h[xVar1],col_h[xVar1]+for_h[xVar1]-1,xVar3)
            EndIf
         Next
      EndIf
   EndIf
   Return

Procedure RESTSCR(xArg1,xArg2,xArg3,xArg4,xArg5)

   Local xVar1,xVar2,xVar3,xVar4
   If (Type("lin_h") = "A" .AND. Len(lin_h) > 0)
      For xVar2:= 1 To Len(lin_h)
         If (!Empty(tim_h[xVar2]) .AND. xArg1 <= lin_h[xVar2] .AND. xArg3 >= lin_h[xVar2] .AND. xArg2 <= col_h[xVar2] .AND. xArg4 >= col_h[xVar2]+3 .AND. (SubStr((xVar3:= (xArg4-xArg2+1)*2,xVar4:= (lin_h[xVar2]-xArg1)*xVar3+1+(col_h[xVar2]-xArg2)*2, ;
               xArg5),xVar4+4) = ":" .OR. SubStr(xArg5,xVar4+10) = ":"))
            For xVar1:= 0 To for_h[xVar2]
               j:= Asc(SubStr(xArg5,xVar4+xVar1*2,1))
               If (j >= 48 .AND. j <= 57 .AND. !Empty(SubStr(tim_h[xVar2],xVar1+1,1)))
                  xArg5:= Left(xArg5,xVar4+xVar1*2-1)+SubStr(tim_h[xVar2],xVar1+1,1)+SubStr(xArg5,xVar4+xVar1*2+1)
               EndIf
            Next
         EndIf
      Next
   EndIf
   RestScreen(xArg1,xArg2,xArg3,xArg4,xArg5)
   Return

Function MUDA_PJ(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6)
   Local xVar1:= cod_sos,xVar2:= "help",xVar3,xVar4:= SetColor(drvcorenf),xVar5
   drvmouse:= IIf(Type("drvmouse") # "L",.F.,drvmouse)
   l1:= c1:= li:= co:= 0
   cod_sos:= 1
   xVar3:= IIf(xArg6,0,1)
   xVar5:= SaveScreen(xArg1+xVar3,xArg2+xVar3,xArg3,xArg4-xVar3)
   dispbegin()
   Do While (.T.)
      @ MaxRow(), 0 Say padc("Utilize as setas para posicionar a janela. ("+gcr+" aceita posiáÑo)",80)
      dispend()
      If (drvmouse)
         l1:= xArg1+Int((xArg3-xArg1)/2)
         c1:= xArg2+Int((xArg4-xArg2)/2)
         mousebox(xArg1,xArg2,xArg3,xArg4)
         mousecur(.T.)
         te_:= 0
         mouseset(l1,c1)
         Do While (te_ = 0)
            pp:= mouseget(@li,@co)
            te_:= nextkey()
            If (pp = 1 .AND. te_ = 0)
               y_:= li-l1
               x_:= co-c1
               If (y_ > 0)
                  joganobuff("")
               Else
                  If (y_ < 0)
                     joganobuff("")
                  EndIf
               EndIf
               If (x_ > 0)
                  joganobuff("")
               Else
                  If (x_ < 0)
                     joganobuff("")
                  EndIf
               EndIf
            Else
               If (pp == 2)
                  joganobuff("")
               EndIf
            EndIf
         EndDo
         mousecur(.F.)
      EndIf
      If (Type("acao_mac") = "C")
         x:= "IN_KEY"
         te_:= &x(0)
      Else
         te_:= InKey(0)
      EndIf
      dispbegin()
      restscr(0,0,MaxRow(),79,xArg5)
      If (te_ = 27 .OR. te_ = 13)
         mon_jan_mo(xArg1,xVar3,xArg2,xArg3,xArg4,xVar5)
         dispend()
         Exit
      Else
         If (te_ = 19 .AND. xArg2 > 0)
            xArg2:= xArg2-1
            xArg4:= xArg4-1
         Else
            If (te_ = 4 .AND. xArg4 < 79)
               xArg2:= xArg2+1
               xArg4:= xArg4+1
            Else
               If (te_ = 5 .AND. xArg1 > 0)
                  xArg1:= xArg1-1
                  xArg3:= xArg3-1
               Else
                  If (te_ = 24 .AND. xArg3 < MaxRow())
                     xArg1:= xArg1+1
                     xArg3:= xArg3+1
                  Else
                     If (te_ = 28)
                        &xVar2()
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
      mon_jan_mo(xArg1,xVar3,xArg2,xArg3,xArg4,xVar5)
   EndDo
   Do While (mouseget(0,0) # 0)
   EndDo
   Set Color To (xVar4)
   cod_sos:= xVar1
   Return Nil

Procedure MON_JAN_MO(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6)

   restscr(xArg1+xArg2,xArg3+xArg2,xArg4,xArg5-xArg2,xArg6)
   If (xArg3-1 >= 0 .AND. xArg4 < MaxRow())
      restscr(xArg1+1+xArg2,xArg3-1+xArg2,xArg4+1,xArg3-1+xArg2,Transform(SaveScreen(xArg1+1+xArg2,xArg3-1+xArg2,xArg4+1,xArg3-1+xArg2),Replicate("X",xArg4-xArg1+1+xArg2)))
      If (xArg3-2 >= 0)
         restscr(xArg1+1+xArg2,xArg3-2+xArg2,xArg4+1,xArg3-2+xArg2,Transform(SaveScreen(xArg1+1+xArg2,xArg3-2+xArg2,xArg4+1,xArg3-2+xArg2),Replicate("X",xArg4-xArg1+1+xArg2)))
      EndIf
      restscr(xArg4+1,xArg3+xArg2,xArg4+1,xArg5-2-xArg2,Transform(SaveScreen(xArg4+1,xArg3+xArg2,xArg4+1,xArg5-2+xArg2),Replicate("X",xArg5-xArg2-(xArg3+xArg2)-1)))
   EndIf
   Return

Function VDVCB(xArg1)
   Local xVar1,xVar2
   xVar1:= right(xArg1,1)
   xVar2:= Left(xArg1,Len(xArg1)-1)
   Return IIf(gdvcb(xVar2) = xVar1 .OR. Empty(xArg1),.T.,.F.)

Function GDVCB(xArg1)

   Local xVar1,xVar2,xVar3,xVar4
   xVar1:= xVar2:= xVar3:= 0
   xVar4:= Len(xArg1)
   For xVar1:= 1 To xVar4
      If (xVar1/2 = Int(xVar1/2))
         xVar3:= xVar3+Val(SubStr(xArg1,xVar1,1))
      Else
         xVar2:= xVar2+Val(SubStr(xArg1,xVar1,1))
      EndIf
   Next
   If (xVar4 == 7 .OR. xVar4 == 11)
      xVar2:= xVar2*3+xVar3
      xVar3:= Int((xVar2+9)/10)*10
      xVar4:= xVar3-xVar2
   Else
      xVar3:= xVar3*3+xVar2
      xVar2:= Int((xVar3+9)/10)*10
      xVar4:= xVar2-xVar3
   EndIf
   Return Str(xVar4,1)

Function INVCOR(xArg1)
   Return strtran(SubStr(xArg1,At("/",xArg1)+1),"*","+")+"/"+strtran(Left(xArg1,At("/",xArg1)-1),"+","*")

Function ERROMSG(xArg1)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10,xVar11,xVar12,xVar13,xVar14[38],xVar15,xVar16:= IIf(Type("drvcorenf") = "C",drvcorenf,"W+/R")
   Private dbf_err,ntx_err
   If (xArg1:gencode() == 5)
      Return 0
   EndIf
   If ((xArg1:gencode() == 40 .OR. xArg1:gencode() == 21 .AND. xArg1:oscode() == 32) .AND. xArg1:candefault())
      neterr(.T.)
      Return .F.
   EndIf
   Do While (dispcount() > 0)
      dispend()
   EndDo
   xVar14:= sets()
   Set Console On
   Set Alternate To
   Set Alternate Off
   Set Device To Screen
   Set Printer Off
   Set Printer To
   Set Exact Off
   xVar3:= IIf(ValType(xArg1:subsystem()) == "C",xArg1:subsystem(),"????")
   xVar3:= xVar3+("/"+IIf(ValType(xArg1:subcode()) == "N",LTrim(Str(xArg1:subcode())),"/????"))
   xVar2:= IIf(xArg1:severity() > 1,"ERRO!","AVISO!")+"|"+xVar3
   al_hora:= "*"
   If (!Empty(xArg1:oscode()))
      xVar2:= xVar2+("|ERRO DO DOS Nß "+LTrim(Str(xArg1:oscode())))
   EndIf
   If (!Empty(xArg1:filename()))
      xVar2:= xVar2+("|Arquivo: "+xArg1:filename())
   Else
      If (!Empty(xArg1:operation()))
         xVar2:= xVar2+("|Vari†vel/funáÑo: "+xArg1:operation())
      EndIf
   EndIf
   dbf_err:= IIf(Type("drverr") = "C",drverr,"\")+"ERROS"
   xVar6:= "478"
   xVar6:= xVar6+xVar6
   xVar9:= xVar10:= ""
   If (file(dbf_err+".DBF"))
      If (xArg1:oscode() == 4)
         Close Databases
         Select 1
         Close Format
      EndIf
      xVar13:= Select()
      Select 0
      If (!file(dbf_err+extensao()))
         xVar15:= SaveScreen(0,0,MaxRow(),79)
         dbox("Indexando arquivo de erros",Nil,Nil,Nil,.F.,"AGUARDE!",Nil,Nil,Nil,xVar16)
         Use (dbf_err) Shared
         Index On codi_erro To (dbf_err)
         restscr(0,0,MaxRow(),79,xVar15)
      Else
         Use (dbf_err) Shared Index (dbf_err)
      EndIf
      xVar3:= encript(xVar3,xVar6)
      Seek xVar3
      If (Found())
         Do While (!EOF() .AND. codi_erro = xVar3)
            xVar7:= decript(msg_erro,xVar6)
            If (decript(tpmsg_erro,xVar6) = "C")
               xVar9:= xVar9+(alltrim(xVar7)+"|")
            Else
               xVar10:= xVar10+(alltrim(xVar7)+"|")
            EndIf
            Skip
         EndDo
      Else
         xVar9:= xVar10:= "ERRO NéO IDENTIFICADO|"
      EndIf
      Close
      Select (xVar13)
   Else
      xVar9:= xVar10:= "Imposs°vel dar esta informaáÑo pois,|arquivo ERROS.DBF nÑo encontrado!|"
   EndIf
   xVar1:= 1
   xVar11:= ""
   Do While (!Empty(procname(xVar1)))
      xVar11:= xVar11+(padr(procname(xVar1),12)+"("+lpad(Str(procline(xVar1)),4,"0")+")|")
      xVar1++
   EndDo
   xVar4:= "|Poss°veis causas|SoluáÑo/coment†rios|Caminho (trace)|Cancelar operaáÑo"+IIf(xArg1:canretry(),"|Tentar novamente","")
   xVar5:= 0
   xVar15:= SaveScreen(0,0,MaxRow(),79)
   alerta()
   alerta()
   Do While (.T.)
      xVar5:= dbox(SubStr(xVar4,2),Nil,Nil,.T.,Nil,xVar2,Nil,Nil,Nil,xVar16)
      If (xVar5 = 0 .OR. xVar5 = 4)
         Close Databases
         Select 1
         Close Format
         readkill(.T.)
         getlist:= {}
         Break(xArg1)
      Else
         If (xVar5 == 1)
            dbox(xVar9+"*",Nil,Nil,Nil,Nil,"POSS°VEL CAUSA",Nil,Nil,Nil,xVar16)
         Else
            If (xVar5 == 2)
               dbox(xVar10+"*",Nil,Nil,Nil,Nil,"COMENTèRIOS/SOLUÄéO",Nil,Nil,Nil,xVar16)
            Else
               If (xVar5 == 3)
                  dbox(xVar11+"*",Nil,Nil,Nil,Nil,"CAMINHO",Nil,Nil,Nil,xVar16)
               Else
                  If (xVar5 = 5 .AND. xArg1:canretry())
                     sets(xVar14)
                     al_hora:= ""
                     Return .T.
                  Else
                     sets(xVar14)
                     al_hora:= ""
                     Return .F.
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndDo

Function SETS(xArg1)

   Local xVar1[38],xVar2
   If (xArg1 # Nil)
      For xVar2:= 1 To 38
         xVar1[xVar2]:= Set(xVar2,xArg1[xVar2])
      Next
   Else
      For xVar2:= 1 To 38
         xVar1[xVar2]:= Set(xVar2)
      Next
   EndIf
   Return xVar1

Function LRELA(xArg1,xArg2,xArg3)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6
   xArg3:= lpad(Str(xArg3,2),"0")
   xVar6:= 1
   If (!used())
      Return .F.
   EndIf
   xVar2:= drvdbf+"rl"+xArg3+"*."+arqgeral
   xVar5:= adir(xVar2)
   If (xVar5 > 0)
      xVar1:= SaveScreen(0,0,MaxRow(),79)
      dbox("AGUARDE!",9,Nil,Nil,.F.)
      Private l_arq[xVar5+1]
      adir(xVar2,l_arq)
      For i:= xVar5 To 1 Step -1
         xVar4:= drvdbf+l_arq[i]
         Restore From (xVar4) Additive
         l_arq[i+1]:= rl_aqcom+"≥"+l_arq[i]
      Next
      l_arq[1]:= "* ESPECIFICAR NOVO RELAT¢RIO *"
      volta_ac:= .T.
      restscr(0,0,MaxRow(),79,xVar1)
      Do While (volta_ac)
         cod_sos:= 48
         volta_ac:= .F.
         msg:= ""
         aeval(l_arq,{|_1| IIf(_1 # Nil,msg+="|"+alltrim(parse(_1,"≥")),"")})
         op_co:= dbox(SubStr(msg,2),xArg1,xArg2,.T.,Nil,"SELECIONE O RELAT¢RIO COM ,  e "+gcr+"|[DEL] APAGA O RELAT¢RIO DO CURSOR")
         If ((pos_:= rat("≥",l_arq[op_co]),volta_ac .AND. pos_ > 3))
            xVar4:= drvdbf+SubStr(l_arq[op_co],pos_+1)
            id_op:= alltrim(Upper(Left(l_arq[op_co],pos_-1)))
            alerta()
            op:= dbox("Cancelar a operaáÑo|Apagar opáÑo",8,Nil,.T.,Nil,"ATENÄéO!|Ø "+id_op+"Æ")
            If (op == 2)
               Erase (xVar4)
               adel(l_arq,op_co)
            EndIf
         EndIf
      EndDo
      Release All Like rl_*
      If (op_co > 1)
         xVar6:= 2
         op_:= l_arq[op_co]
         ti_:= parse(@op_,"≥")
         xVar3:= drvdbf+op_
         Restore From (xVar3) Additive
         cpord:= rl_cpord
         criterio:= rl_criteri
         titrel:= rl_titrel
         tps:= rl_tps
         nucop:= rl_nucop
      Else
         If (op_co == 0)
            xVar6:= 0
         EndIf
      EndIf
   EndIf
   Release All Like rl_*
   Return xVar6

Function GRELA(xArg1)

   xArg1:= lpad(Str(xArg1,2),"0")
   If (gr_rela .AND. !Empty(xArg1))
      rl_aqcom:= Left(titrel+Space(58),58)
      Do While (.T.)
         cod_sos:= 47
         hms:= Time()
         resaq:= xArg1+SubStr(hms,4,2)+right(hms,2)+"."+arqgeral
         aqrel:= drvdbf+"RL"+resaq
         If (!file("&aqrel."))
            Exit
         EndIf
      EndDo
      alerta(2)
      rl_aqcom:= dbox("Identifique-o para gravaáÑo, ou pressione [ESC]",Nil,Nil,Nil,Nil,"GRAVA RELAT¢RIO",rl_aqcom)
      If (LastKey() # 27 .AND. !Empty(rl_aqcom))
         rl_cpord:= cpord
         rl_criteri:= criterio
         rl_titrel:= titrel
         rl_tps:= tps
         rl_nucop:= nucop
         Save All Like rl_* To (aqrel)
      EndIf
   EndIf
   gr_rela:= .F.
   Return Nil

Function PARSE(xArg1,xArg2)

   Local xVar1,xVar2
   If (PCount() < 2)
      xArg2:= ","
   EndIf
   xVar2:= At(xArg2,xArg1)
   If (xVar2 > 0)
      xVar1:= Left(xArg1,xVar2-1)
      xArg1:= SubStr(xArg1,xVar2+Len(xArg2))
   Else
      xVar1:= xArg1
      xArg1:= ""
   EndIf
   Return xVar1

Function BLOREG(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4
   xArg1:= IIf(PCount() = 0,0,xArg1)
   xArg2:= IIf(PCount() < 2,1,xArg2)
   xVar1:= xArg1 = 0
   xVar2:= xArg1
   xVar3:= .F.
   xVar4:= nextkey()
   Do While (xArg1 >= 0 .AND. LastKey() # 27 .OR. xVar1)
      If (RLock())
         xVar3:= .T.
         Exit
      EndIf
      dbox("Tentando bloquear|"+IIf(xVar1,"(NéO","(ESC")+" cancela)",15,Nil,xArg2,Nil,"OUTRO USUèRIO ACESSANDO|O REGISTRO")
      xArg1:= xArg1-xArg2
   EndDo
   If (xVar4 == 0)
      Clear Typeahead
   EndIf
   Return xVar3

Function ALERTA(xArg1)

   Local xVar1,xVar2
   xArg1:= IIf(PCount() = 0,3,IIf(xArg1 > 20,20,xArg1))
   xVar2:= IIf(Type("drvsom") == "L",drvsom,.T.)
   If (xVar2)
      If (xArg1 == 99)
         tone(600,1)
         tone(300,1)
         tone(600,1)
         tone(300,1)
         tone(600,1)
         tone(300,1)
         tone(600,1)
         tone(300,1)
      Else
         For xVar1:= 1 To xArg1
            tone(xVar1*500,0.3)
         Next
      EndIf
   EndIf
   Return Nil

Function LEMANU(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4
   hind:= Left(xArg1,Len(xArg1)-3)+"INX"
   xVar4:= fopen(hind)
   If (ferror() == 0)
      xVar1:= Space(1920)
      fread(xVar4,@xVar1,1920)
      xVar1:= SubStr(xVar1,16*(xArg2-1)+1,16)
      xVar2:= Val(Left(xVar1,8))
      xVar3:= Val(right(xVar1,8))
      xVar1:= Space(xVar3)
      fclose(xVar4)
      xVar4:= fopen(xArg1)
      If (ferror() == 0)
         fseek(xVar4,xVar2)
         fread(xVar4,@xVar1,xVar3)
      EndIf
   Else
      xVar1:= ""
   EndIf
   fclose(xVar4)
   Return xVar1

function sgrafico  // deveria voltar se esta em modo grafico
return .f.

Function MUDAFONTE(xArg1)
Return ""

Func Mouse()  // verifica se tem mouse
Retu If( MPresent() , 1 , 0 )

Func MouseCur( Arg )  // mostra ou esconde o cursor do mouse
Arg := If( Arg = Nil , .f. , .t. )
If( Arg , MShow() , MHide() )
Retu Nil

Func MouseSet( Row , Col )  // posiciona o cursor


MSetPos( Row , Col )
Retu Nil

Func MouseBox( Arg1 , Arg2 , Arg3 , Arg4 )  // determina area de evento
Mou_Lin_S := Mou_Col_S := Mou_Lin_I := Mou_Col_I := 0
If Arg3 != MaxRow() .And. Arg4 != MaxCol()
 Mou_Lin_S := Arg1
 Mou_Col_S := Arg2
 Mou_Lin_I := Arg3
 Mou_Col_I := Arg4
ElseIf l_s != Nil .And. c_s != Nil .And. l_i != Nil .And. c_i != Nil
 Mou_Lin_S:=l_s
 Mou_Col_S:=c_s
 Mou_Lin_I:=l_i
 Mou_Col_I:=c_i
Endi
Retu Nil

Func MouseGet(Arg1,Arg2) // retorna botao esquerdo/direiro (enter/esc)
Loca nBotao:=0
If MLeftDown()
 nBotao:=1
ElseIf MRightDown()
 nBotao:=2
Endi
Retu (nBotao)

procedure mouserat
return



Function NARQ(xArg1)

   Local xVar1,xVar2,xVar3
   xArg1:= Trim(xArg1)
   xVar1:= "*+-,=?<>[]{};. "
   If (Empty(xArg1))
      Return .T.
   EndIf
   xVar2:= Asc(xArg1) < 65
   xVar3:= Asc(SubStr(xArg1,3,1)) < 65 .AND. SubStr(xArg1,2,1) = ":"
   For i:= 1 To Len(xVar1)
      If (SubStr(xVar1,i,1) $ xArg1)
         Return .F.
      EndIf
   Next
   Return IIf(xVar2 .OR. xVar3,.F.,.T.)


Function NSEM(xArg1)

   If (ValType(xArg1) = "D")
      xArg1:= DoW(xArg1)
   EndIf
   Return SubStr("DomingoSegundaTerca  Quarta Quinta Sexta  Sabado ",xArg1*7-6,7)

Function CAIXA(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6,xArg7)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7

   If (Len(xArg1) = 8 .OR. Len(xArg1) = 11)
      xArg1:= Left(xArg1,8)+" "
   Else
      If (Len(xArg1) > 9)
         xArg1:= Left(xArg1,8)+right(xArg1,1)
      EndIf
   EndIf
   @ xArg2,xArg3,xArg4,xArg5 Box xArg1
   If (IIf(xArg7 = Nil,.T.,xArg7) .AND. xArg3 >= 1 .AND. xArg4 < MaxRow())
      restscr(xArg2+1,xArg3-1,xArg4+1,xArg3-1,Transform(SaveScreen(xArg2+1,xArg3-1,xArg4+1,xArg3-1),Replicate("X",xArg4-xArg2+1)))
      If (xArg3 > 1)
         restscr(xArg2+1,xArg3-2,xArg4+1,xArg3-2,Transform(SaveScreen(xArg2+1,xArg3-2,xArg4+1,xArg3-2),Replicate("X",xArg4-xArg2+1)))
      EndIf
      restscr(xArg4+1,xArg3,xArg4+1,xArg5-2,Transform(SaveScreen(xArg4+1,xArg3,xArg4+1,xArg5-2),Replicate("X",xArg5-xArg3-1)))
   EndIf
   If (xArg6 # Nil .AND. drvsom)
      tone(xArg6,0.5)
   EndIf

   Return Nil

Function LPAD(xArg1,xArg2,xArg3)

   xArg1:= IIf(ValType(xArg1) = "N",Str(xArg1),xArg1)
   If (xArg2 = Nil)
      xArg2:= Len(xArg1)
      xArg3:= " "
   Else
      If (xArg3 = Nil)
         If (ValType(xArg2) = "C")
            xArg3:= xArg2
            xArg2:= Len(xArg1)
         Else
            xArg3:= " "
         EndIf
      EndIf
   EndIf
   Return padl(alltrim(xArg1),xArg2,xArg3)

Function DBOX(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6,xArg7,xArg8,xArg9,xArg10)

   Local xVar1,xVar2,xVar3,xVar4:= {},xVar5:= SetColor(),xVar6,xVar7,xVar8,xVar9:= 1,xVar10,xVar11:= .F.,xVar12,xVar13:= {},xVar14:= SaveScreen(0,0,MaxRow(),79),xVar15,xVar16,xVar17,xVar18:= Row(),xVar19:= Col(),xVar20:= SetKey(-37,Nil),xVar21:= ;
      Set(20),xVar22:= {},xVar23:= .F.,xVar24:= setcursor(0)
   Private l_msg:= {},l_opc:= {},ij,ca_m,cara_pesq:= "",cor_op:= xArg10,tit_op:= xArg10
   If (Type("pr_ok") = "C" .AND. Len(pr_ok) > 0)
      ? pr_ok
   Else
      drvmouse:= IIf(Type("drvmouse") # "L",.F.,drvmouse)
      If (drvmouse)
         x:= "MOUSEGET"
         Do While (&x(@xVar16,@xVar17) # 0)
         EndDo
      EndIf
      Set Device To Screen
      mold:= IIf(Type("mold") = "C",mold,"⁄ƒø≥Ÿƒ¿≥√ƒ¥")
      gcr:= IIf(Type("gcr") = "C",gcr,"<ENTER>")
      op_sis:= IIf(Type("op_sis") = "N",op_sis,1)
      xArg9:= IIf(xArg9 = Nil,1,xArg9)
      ca_m:= xArg7
      xArg4:= IIf(xArg4 = Nil,0,xArg4)
      xArg5:= IIf(xArg5 = Nil,.T.,xArg5)
      xVar8:= IIf(ValType(xArg4) = "L",xArg4 = .T.,.F.)
      epop_:= IIf(ValType(xArg4) = "L",xArg4 = .F.,.F.)
      xVar2:= xVar3:= 0
      If (ValType(xArg1) = "A")
         Do While (xVar3 < 4096 .AND. Len(xArg1) > xVar3)
            xVar3++
            If (ValType(xArg1[xVar3]) = "A")
               AAdd(l_msg,xArg1[xVar3][1])
            Else
               AAdd(l_msg,xArg1[xVar3])
            EndIf
            ij:= At("~",l_msg[xVar3])-1
            If (ij < 1)
               ij:= Len(l_msg[xVar3])
            EndIf
            xVar2:= IIf(ij > xVar2,ij,xVar2)
         EndDo
      Else
         Do While (xVar3 < 4096 .AND. Len(xArg1) > 0)
            AAdd(l_msg,parse(@xArg1,"|"))
            ij:= At("~",l_msg[Len(l_msg)])-1
            If (ij < 1)
               ij:= Len(l_msg[Len(l_msg)])
            EndIf
            xVar2:= IIf(ij > xVar2,ij,xVar2)
            xVar3++
         EndDo
      EndIf
      If ((xVar8 .OR. epop_) .AND. Len(l_msg) > 0)
         For ij:= 1 To Len(l_msg)
            If (At("~",l_msg[ij]) > 0)
               xVar6:= l_msg[ij]
               xVar7:= parse(@xVar6,"~")
               l_msg[ij]:= xVar7
               If (Val(xVar6) > 0)
                  AAdd(l_opc,Val(xVar6))
               Else
                  AAdd(l_opc,ij)
               EndIf
               xVar7:= parse(@xVar6,"~")
               AAdd(xVar22,xVar6)
               If (Len(xVar6) > 0)
                  xVar23:= .T.
               EndIf
            Else
               AAdd(l_opc,ij)
               AAdd(xVar22,"")
            EndIf
            If (l_opc[ij] = xArg9)
               xVar9:= ij
            EndIf
            If (At("Ù",l_msg[ij]) > 0)
               l_msg[ij]:= strtran(l_msg[ij],"Ù","~")
            EndIf
         Next
      EndIf
      If (xVar23)
         xVar2:= xVar2+7
      EndIf
      If (!epop_)
         If (xArg6 # Nil .AND. !Empty(xArg6) .AND. !epop_)
            xVar3++
            Do While (Len(xArg6) > 0)
               AAdd(xVar4,parse(@xArg6,"|"))
               ij:= Len(xVar4[Len(xVar4)])
               xVar2:= IIf(ij > xVar2,ij,xVar2)
               xVar3++
            EndDo
         EndIf
         xVar1:= IIf(ValType(xArg4) = "N" .AND. xArg5,IIf(xArg4 # 0,"","Pressione "+gcr),"")
         xVar2:= IIf(xVar2 < Len(xVar1),Len(xVar1)+2,xVar2+2)
         If (ca_m # Nil)
            tcam:= Len(Transform(ca_m,xArg8))
            xVar2:= IIf(xVar2 < tcam+4,tcam+4,xVar2)
         EndIf
         xVar3:= IIf(!Empty(xVar1) .OR. ca_m # Nil,xVar3+3,xVar3+1)
         If (xArg3 = Nil .OR. Empty(xArg3))
            xArg3:= Int((80-xVar2)/2)-1
         Else
            xArg3:= IIf(xArg3+xVar2+1 > 78,78-xVar2,xArg3)
         EndIf
         xVar3:= IIf(xVar3 > MaxRow()-1,MaxRow()-1,xVar3)
         If (xArg2 = Nil)
            xArg2:= Int((MaxRow()+1-xVar3)/2)-1
         Else
            xArg2:= IIf(xArg2+xVar3 > MaxRow()-1,MaxRow()-1-xVar3,xArg2)
         EndIf
      Else
         xArg3:= 0
         xVar2:= 78
         xVar3:= 0
      EndIf
      xVar12:= "drv"+alltrim(Str(Int(op_sis+(xArg2+MaxRow())*(xArg3+80)+25*((xArg2+MaxRow()+xVar3)*(xArg3+80+xVar2)))))
      If (Type(xVar12) = "C")
         xArg2:= Val(Left(&xVar12,2))
         xArg3:= Val(SubStr(&xVar12,3))
      EndIf
      If (cor_op = Nil)
         If (xVar8 .OR. epop_)
            cor_op:= drvcorget
            tit_op:= drvtitget
         Else
            If (ca_m # Nil)
               cor_op:= drvcormsg
               tit_op:= drvtitmsg
            Else
               If ((!Empty(xVar1) .OR. ValType(xArg4) = "N") .AND. xArg5)
                  cor_op:= drvcorenf
                  tit_op:= drvtitenf
               Else
                  cor_op:= drvcorbox
                  tit_op:= drvtitbox
               EndIf
            EndIf
         EndIf
      EndIf
      If (ca_m # Nil)
         cor_op:= cor_op+","+tit_op
      EndIf
      If (!epop_)
         For ij:= 1 To Len(l_msg)
            If (!(l_msg[ij] == "---"))
               If (Len(xVar22) > 0 .AND. Len(xVar22[ij]) > 0)
                  l_msg[ij]:= Left(l_msg[ij]+Space(xVar2),xVar2-2-Len(xVar22[ij]))+" "+xVar22[ij]
               EndIf
               If (!drvmenucen .AND. xVar8)
                  l_msg[ij]:= " "+Left(l_msg[ij]+Space(xVar2),xVar2-1)
               Else
                  l_msg[ij]:= padc(l_msg[ij],xVar2," ")
               EndIf
            EndIf
         Next
      EndIf
      Do While (.T.)
         rola_cx:= .F.
         If (!epop_)
            Set Color To (tit_op)
            caixa(mold,xArg2,xArg3,xArg2+xVar3,xArg3+xVar2+1)
            If (xArg6 # Nil .AND. Len(xVar4) > 0)
               For ij:= 1 To Len(xVar4)
                  @ xArg2+ij,xArg3+1 Say padc(xVar4[ij],xVar2)
               Next
               @ xArg2+ij,xArg3 Say SubStr(mold,9,1)+Replicate(SubStr(mold,10,1),xVar2)+SubStr(mold,11,1)
            EndIf
            xin:= IIf(xArg6 = Nil .OR. Len(xVar4) = 0,0,Len(xVar4)+1)
         Else
            xin:= 0
         EndIf
         If (drvmouse)
            x:= "MOUSEBOX"
            &x(xArg2,xArg3,xArg2+xVar3,xArg3+xVar2+1)
         EndIf
         Set Color To (cor_op)
         If (xVar8 .OR. epop_)
            acho_tela:= ""
            tec_ap:= .T.
            Do While tec_ap
               tec_ap:= .F.
               If xVar8
                  xVar9:= menuv(l_msg,l_opc,xVar9,xVar3-xin-1,xArg2+xin+1,xArg3+1,xVar2)
               Else
                  xVar9:= menuh(l_msg,l_opc,xVar9,xArg2)
               EndIf
            EndDo
         Else
            If (Len(l_msg) > 0)
               For ij:= 1 To Len(l_msg)
                  lin_:= xArg2+ij+xin
                  If (lin_ < xArg2+xVar3 .AND. lin_ < MaxRow())
                     @ lin_,xArg3+1 Say l_msg[ij]
                  EndIf
               Next
               xVar9:= alltrim(Str(lin_))+"|"+alltrim(Str(xArg3+(Len(l_msg[Len(l_msg)])-Len(Trim(l_msg[Len(l_msg)])))))
            Else
               lin_:= xArg2+xin
               ij:= 1
               xVar9:= alltrim(Str(lin_))+"|"+alltrim(Str(xArg3))
            EndIf
            If (ca_m # Nil)
               xVar10:= Int((xVar2-tcam)/2)
               @ xArg2+ij+xin+1,xArg3+xVar10 Say ">"+Space(tcam)+"<"
               If (xArg8 = Nil .OR. Empty(xArg8))
                  SetPos(xArg2+ij+xin+1,xArg3+xVar10+1)
                  AAdd(xVar13,__Get(Nil,"ca_m",Nil,Nil,Nil):display())
               Else
                  SetPos(xArg2+ij+xin+1,xArg3+xVar10+1)
                  AAdd(xVar13,__Get(Nil,"ca_m",xArg8,Nil,Nil):display())
               EndIf
               SetKey(-37,{|| (rola_cx:= .T.,joganobuff(Chr(13)))})
               setcursor(IIf(readinsert(),3,1))
               ReadModal(xVar13)
               xVar13:= {}
               xVar24:= setcursor(0)
               SetKey(-37,Nil)
               xVar9:= ca_m
            Else
               If ((!Empty(xVar1) .OR. ValType(xArg4) = "N") .AND. xArg5)
                  Set Color To (tit_op)
                  If (!Empty(xVar1))
                     @ xArg2+ij+xin,xArg3+1 Say padc("ÆØ",xVar2)
                     @ xArg2+ij+xin+1,xArg3+1 Say padc(xVar1,xVar2)
                  EndIf
                  If (drvmouse)
                     x:= "MOUSECUR"
                     &x(.T.)
                     tq:= ppp:= 0
                     i:= Seconds()+xArg4
                     Do While (tq = 0)
                        If (xArg4 > 0 .AND. Seconds() > i)
                           joganobuff(Chr(13))
                        EndIf
                        x:= "MOUSEGET"
                        pp:= &x(0,0)
                        x:= "POEHORA"
                        &x()
                        tq:= nextkey()
                        If (pp = 1 .AND. tq = 0)
                           ppp:= IIf(ppp = 0,Seconds(),ppp)
                           press:= Seconds() > ppp+0.5
                           If (press)
                              rola_cx:= .T.
                              joganobuff(Chr(13))
                           EndIf
                        Else
                           If (pp == 2)
                              joganobuff("")
                           Else
                              If (ppp > 0)
                                 joganobuff(Chr(13))
                              EndIf
                              ppp:= 0
                           EndIf
                        EndIf
                     EndDo
                     x:= "MOUSECUR"
                     &x(.F.)
                  EndIf
                  tq:= q_tec(xArg4)
                  If (tq == -37)
                     rola_cx:= .T.
                  Else
                     If ((xArg4 = 0 .OR. IIf(Type("acao_mac") = "C",!(acao_mac $ "DGg"),.F.)) .AND. LastKey() # 27 .AND. LastKey() # 13 .AND. LastKey() # 32 .AND. LastKey() # 9 .AND. LastKey() # 46)
                        joganobuff(Chr(LastKey()))
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
         If (rola_cx)
            muda_pj(@xArg2,@xArg3,xArg2+xVar3,xArg3+xVar2+1,xVar14,.T.)
            xVar11:= .T.
            Loop
         EndIf
         Exit
      EndDo
      If (xVar11 .AND. Type("arqconf") = "C")
         Public &xVar12:= Str(xArg2,2)+Str(xArg3,2)
         Save All Like drv* To (arqconf)
         Restore From (arqconf) Additive
      EndIf
      If (xArg5)
         restscr(0,0,MaxRow(),79,xVar14)
      EndIf
      Set Color To (xVar5)
      If (drvmouse)
         x:= "MOUSEGET"
         Do While (&x(0,0) # 0)
         EndDo
         x:= "MOUSEBOX"
         &x(0,0,MaxRow(),79)
         mouseset(xVar16,xVar17)
      EndIf
      SetKey(-37,xVar20)
      SetPos(xVar18,xVar19)
      Set(20,xVar21)
      setcursor(xVar24)
      Return xVar9
   EndIf

Procedure JOGANOBUFF(xArg1)

   If (Type("acao_mac") = "C")
      x:= "KEYBUFF"
      &x(xArg1)
   Else
      Keyboard xArg1
   EndIf
   Return

Function Q_TEC(xArg1)

   Local xVar1
   poehora()
   If (Type("acao_mac") = "C")
      x:= "IN_KEY"
      xVar1:= &x(xArg1)
   Else
      xVar1:= inky(xArg1)
   EndIf
   Return xVar1

Function NOVAPOSI(xArg1,xArg2,xArg3,xArg4)

   Local xVar1
   xVar1:= "drv"+alltrim(Str(Int(op_sis*80+(xArg1+MaxRow())*(xArg2+80)+25*((xArg3+MaxRow())*(xArg4+80)))))
   If (Type(xVar1) = "C")
      d_1:= xArg3-xArg1
      d_2:= xArg4-xArg2
      xArg1:= Val(Left(&xVar1,2))
      xArg2:= Val(SubStr(&xVar1,3))
      xArg3:= xArg1+d_1
      xArg4:= xArg2+d_2
   EndIf
   Return xVar1

Function REPBLO(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5
   xVar1:= alias()
   xVar3:= At("->",xArg1)
   xVar2:= IIf(xVar3 = 0,alias(),Left(xArg1,xVar3-1))
   xVar5:= "blk_"+xVar2
   If (Type(xVar5) # "L")
      Select (xVar2)
      bloreg(0,0.5)
      If (Empty(xVar1))
         Select 0
      Else
         Select (xVar1)
      EndIf
   EndIf
   xVar4:= IIf(ValType(xArg2) = "B",eval(xArg2),xArg2)
   Replace &xArg1 With xVar4
   If (Type(xVar5) # "L")
      Select (xVar2)
      Unlock
      If (Empty(xVar1))
         Select 0
      Else
         Select (xVar1)
      EndIf
   EndIf
   Return .T.

Function BLOARQ(xArg1,xArg2)

   Local xVar1,xVar2,xVar3
   xArg1:= IIf(PCount() = 0,0,xArg1)
   xArg2:= IIf(PCount() < 2,1,xArg2)
   xVar2:= xArg1
   xVar1:= xArg1 = 0
   xVar3:= .F.
   Do While (xArg1 >= 0 .OR. xVar1)
      If (FLock())
         xVar3:= .T.
         Exit
      EndIf
      dbox("Tentando bloquear|"+IIf(xVar1,"(NéO","(ESC")+" cancela)",15,Nil,xArg2,Nil,"OUTRO USUèRIO ACESSANDO|O ARQUIVO")
      xArg1:= xArg1-xArg2
   EndDo
   Clear Typeahead
   Return xVar3

Function EXT(xArg1,xArg2,xArg3,xArg4,xArg5)

   xmsing_:= SubStr("$SIG$Real                    ",6)
   xmplur_:= SubStr("$PLU$Reais                   ",6)
   xArg2:= IIf(PCount() < 2 .OR. xArg2 = Nil,80,xArg2)
   cruz_:= IIf(xArg3 = Nil,.T.,.F.)
   xArg4:= IIf(xArg4 = Nil .OR. Empty(xArg4),xmsing_,padr(xArg4,24))
   xArg5:= IIf(xArg5 = Nil .OR. Empty(xArg5),xmplur_,padr(xArg5,24))
   sexo_:= IIf(Upper(right(Trim(xArg4),1)) = "A","a","o")
   silaba:= "zen.tro.cen.nhe.tec.toc.vec.tor.zes.set.zoi.nov.ren.que.sen.ten.ven.vos.t"+sexo_+"s.tav.zad"
   xArg1:= Abs(IIf(cruz_,xArg1,Int(xArg1)))
   tx_:= "Duzent#s     Trezent#s    Quatrocent#s Quinhent#s   "
   tcnd:= tx_+"Seiscent#s   Setecent#s   Oitocent#s   Novecent#s   "
   tcnd:= strtran(tcnd,"#",sexo_)
   tx_:= "Dez          Onze         Doze         Treze        "
   tx_:= tx_+"Quatorze     Quinze       Dezesseis    Dezessete    "
   tn_:= tx_+"Dezoito      Dezenove     "
   tx_:= "Vinte        Trinta       Quarenta     Cinquenta    "
   tndd:= tx_+"Sessenta     Setenta      Oitenta      Noventa      "
   tx_:= "Zero         Um           Dois         Tres         "
   tx_:= tx_+"Quatro       Cinco        Seis         Sete         "
   tnuu:= tx_+"Oito         Nove         "
   eh_:= " e "
   nn_:= Str(Int(xArg1),15)
   x1_:= x2_:= x3_:= x4_:= x5_:= scnd:= cnd:= "Zero"
   ni_:= Int(xArg1)
   jc_:= SubStr(Str(xArg1-ni_,4,2),3,2)
   dc_:= Val(SubStr(jc_,1,1))
   uc_:= Val(SubStr(jc_,2,1))
   nj_:= IIf(dc_ = 1,"1","0")
   ndc_:= IIf(dc_ = 1,Trim(SubStr(tn_,(uc_+1)*13-12,13)),Trim(SubStr(tndd,(dc_-1)*13-12,13)))
   nuc_:= Trim(SubStr(tnuu,(uc_+1)*13-12,13))
   If (nj_ = "1" .OR. dc_ # 0 .AND. uc_ = 0)
      sec_:= ndc_
   Else
      If (dc_ = 0)
         sec_:= nuc_
      Else
         If (dc_ # 0 .AND. uc_ # 0)
            sec_:= ndc_+eh_+nuc_
         EndIf
      EndIf
   EndIf
   If (Val(jc_) > 1)
      ce_:= sec_+" Centavos"
   Else
      If (Val(jc_) = 1)
         ce_:= sec_+" Centavo"
      Else
         ce_:= ""
      EndIf
   EndIf
   l:= 15
   nv:= 5
   ind_ext_:= 0
   Do While (nv > 0)
      If (SubStr(nn_,l-ind_ext_-2,3) = "   ")
         nv:= 0
         Loop
      EndIf
      n:= Val(SubStr(nn_,l-ind_ext_-0,1))
      nd:= Val(SubStr(nn_,l-ind_ext_-1,1))
      nc:= Val(SubStr(nn_,l-ind_ext_-2,1))
      If (nc > 1)
         cnd:= Trim(SubStr(tcnd,(nc-1)*13-12,13))
      EndIf
      bhx:= "0"
      If (nd = 1)
         bhx:= "1"
         ndd:= Trim(SubStr(tn_,(n+1)*13-12,13))
      Else
         If (nd > 1)
            ndd:= Trim(SubStr(tndd,(nd-1)*13-12,13))
         EndIf
      EndIf
      nuu:= Trim(SubStr(tnuu,(n+1)*13-12,13))
      If (bhx = "1" .OR. nd # 0 .AND. n = 0)
         snd:= ndd
      Else
         If (nd = 0)
            snd:= nuu
         Else
            If (nd # 0 .AND. n # 0)
               snd:= ndd+eh_+nuu
            EndIf
         EndIf
      EndIf
      If (nc = 1)
         scnd:= IIf(nd = 0 .AND. n = 0,"Cem","Cento e "+snd)
      Else
         If (nc = 0)
            scnd:= snd
         Else
            If (nc > 1 .AND. (nd # 0 .OR. n # 0))
               scnd:= cnd+eh_+snd
            Else
               If (nc > 1 .AND. nd = 0 .AND. n = 0)
                  scnd:= cnd
               EndIf
            EndIf
         EndIf
      EndIf
      If (ind_ext_ < 3)
         x1_:= scnd
      Else
         If (ind_ext_ > 2 .AND. ind_ext_ < 6)
            x2_:= scnd
         Else
            If (ind_ext_ > 5 .AND. ind_ext_ < 9)
               x3_:= scnd
            Else
               If (ind_ext_ > 8 .AND. ind_ext_ < 12)
                  x4_:= scnd
               Else
                  If (ind_ext_ > 11 .AND. ind_ext_ < 15)
                     x5_:= scnd
                  Else
                     If (ind_ext_ > 15)
                        Return "NUMERO MAIOR QUE 1 TRILHAO"
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
      nv:= nv-1
      ind_ext_:= ind_ext_+3
   EndDo
   nx_:= " "
   If (xArg1 > 999999999999 .AND. x5_ # "Zero")
      nx_:= IIf(x5_ = "Um",nx_+"Um Trilhao ",nx_+x5_+" Trilhoes ")
   EndIf
   If (x4_ # "Zero")
      nx_:= IIf(x4_ = "Um",nx_+"Um Bilhao ",nx_+x4_+" Bilhoes ")
   EndIf
   If (x3_ # "Zero")
      nx_:= IIf(x3_ = "Um",nx_+"Um Milhao ",nx_+x3_+" Milhoes ")
   EndIf
   If (x2_ # "Zero")
      nx_:= nx_+x2_+" Mil "
   EndIf
   If (x1_ # "Zero")
      nx_:= nx_+x1_
   EndIf
   If (cruz_)
      de_:= IIf(x1_ = "Zero" .AND. x2_ = "Zero"," de ","")
      If (ni_ > 0)
         cz_:= IIf(Int(xArg1) > 1,alltrim(xArg5),alltrim(xArg4))
         ec_:= IIf(xArg1-ni_ > 0," e ","")
      Else
         ec_:= cz_:= de_:= ""
      EndIf
   Else
      de_:= cz_:= ec_:= ce_:= ""
   EndIf
   nx_:= IIf(sexo_ = "a" .AND. right(nx_,2) = "Um",nx_+sexo_,nx_)
   nx_:= IIf(sexo_ = "a" .AND. right(nx_,4) = "Dois",Left(nx_,Len(nx_)-3)+"uas",nx_)
   nx_:= IIf(cruz_,Trim(nx_+de_+" "+cz_+ec_+ce_),Trim(nx_))
   nx_:= LTrim(nx_)
   If (xArg2 < 40)
      Return nx_
   EndIf
   If (Len(nx_) <= xArg2)
      nx_:= padr(nx_,xArg2,"/")
      Return padr(nx_,3*xArg2," ")
   Else
      e1:= ""
      Do While (Len(nx_) > xArg2)
         f1:= Left(nx_,xArg2+1)
         ij:= right(f1,3)
         Do While (!(ij $ silaba) .AND. right(f1,1) # " ")
            f1:= Left(f1,Len(f1)-1)
            ij:= right(f1,3)
         EndDo
         f1:= IIf(ij $ silaba,Left(f1,Len(f1)-3),Left(f1,Len(f1)-1))
         nx_:= LTrim(SubStr(nx_,Len(f1)+1))
         f1:= IIf(ij $ silaba,f1+"-",f1)
         If (Len(e1) < xArg2)
            f1:= lpad(f1,xArg2,"/")
         Else
            If (Len(f1) < xArg2)
               f1:= strtran(f1," ","  ",1,xArg2-Len(f1))
            EndIf
         EndIf
         e1:= e1+f1
      EndDo
      e1:= e1+padr(nx_,xArg2,"/")
   EndIf
   Return padr(e1,3*xArg2," ")

Function VCGC(xArg1)

   If (Empty(xArg1))
      Return .T.
   EndIf
   xArg1:= Trim(xArg1)
   If (Len(xArg1) # 14)
      Return .F.
   EndIf
   dv1_f:= Val(SubStr(xArg1,13,1))
   dv2_f:= Val(SubStr(xArg1,14,1))
   num_:= SubStr(xArg1,1,12)
   dv1_c:= 0
   posi_:= 12
   mu_:= "543298765432"
   Do While (posi_ > 0)
      dv1_c:= dv1_c+Val(SubStr(num_,posi_,1))*Val(SubStr(mu_,posi_,1))
      posi_--
   EndDo
   rest_:= dv1_c-Int(dv1_c/11)*11
   dv1_c:= IIf(rest_ < 2,0,11-rest_)
   dv_:= SubStr(Str(dv1_c,1),1)
   num_:= num_+dv_
   dv2_c:= 0
   mu_:= "6"+mu_
   posi_:= 13
   Do While (posi_ > 0)
      dv2_c:= dv2_c+Val(SubStr(num_,posi_,1))*Val(SubStr(mu_,posi_,1))
      posi_--
   EndDo
   rest_:= dv2_c-Int(dv2_c/11)*11
   dv2_c:= IIf(rest_ < 2,0,11-rest_)
   Return dv1_c = dv1_f .AND. dv1_c = dv1_f .AND. dv2_c = dv2_f

Function PCOND(xArg1,xArg2,xArg3)

   Local xVar1,xVar2,xVar3,xVar4
   xVar1:= alias()
   xVar2:= PCount() > 2
   xVar3:= LTrim(Str(Select(xArg2)))
   If (Val(xVar3) == 0)
//      xArg2:= xArg2
      Select 0
     // usearq(xArg2)
      use xArg2
   Else
      Select (xVar3)
   EndIf
   If (xVar2)
      Skip IIf(EOF(),0,1)
      Locate For &xArg1 While RecNo() <= LastRec()
   Else
      Locate For &xArg1
   EndIf
   xVar4:= IIf(Found() .AND. !Deleted(),.T.,.F.)
   If (Empty(xVar1))
      Select 0
   Else
      Select (xVar1)
   EndIf
   Return xVar4

Function GDV2(xArg1)

   Local xVar1,xVar2
   xArg1:= Trim(xArg1)
   xVar1:= xArg1
   xVar2:= gdv1(xVar1)
   xVar1:= xVar1+xVar2
   Return xVar2+gdv1(xVar1)

Function VDV2(xArg1)

   Local xVar1,xVar2,xVar3,xVar4
   xArg1:= Trim(xArg1)
   xVar1:= IIf(Asc(SubStr(xArg1,Len(xArg1)-2,1)) < 48,.T.,.F.)
   xVar2:= IIf(xVar1,SubStr(xArg1,1,Len(xArg1)-3),SubStr(xArg1,1,Len(xArg1)-2))
   xVar3:= Val(SubStr(xArg1,Len(xArg1)-1,2))
   xVar4:= gdv1(xVar2)
   xVar2:= xVar2+xVar4
   xVar4:= xVar4+gdv1(xVar2)
   Return IIf(Val(xVar4) = xVar3 .OR. Empty(xArg1),.T.,.F.)

Function VDV1(xArg1)

   Local xVar1,xVar2,xVar3
   xArg1:= Trim(xArg1)
   xVar1:= IIf(Asc(SubStr(xArg1,Len(xArg1)-1,1)) < 48,.T.,.F.)
   xVar2:= IIf(xVar1,SubStr(xArg1,1,Len(xArg1)-2),SubStr(xArg1,1,Len(xArg1)-1))
   xVar3:= Val(SubStr(xArg1,Len(xArg1),1))
   Return IIf(Val(gdv1(xVar2)) = xVar3 .OR. Empty(xArg1),.T.,.F.)

Function GDV1(xArg1)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6
   xArg1:= Trim(xArg1)
   xVar1:= xArg1
   xVar2:= Len(xVar1)
   xVar5:= xVar6:= 0
   Do While (xVar6 < xVar2)
      xVar6++
      valo_:= Val(SubStr(xVar1,xVar2+1-xVar6,1))*(xVar6+1)
      xVar5:= xVar5+valo_
   EndDo
   xVar3:= xVar5%11
   dvc_:= IIf(xVar3 < 2,0,11-xVar3)
   Return LTrim(Str(dvc_,1))

Function DDMMAA(xArg1)

   Local xVar1,xVar2,xVar3,xVar4,xVar5
   If (Empty(xArg1) .OR. xArg1 = "  /  /  " .OR. xArg1 = "  /  /    ")
      Return .T.
   EndIf
   xArg1:= Trim(xArg1)
   xVar5:= Len(xArg1)
   If (xVar5 # 8 .AND. xVar5 # 6 .AND. xVar5 # 10)
      Return .F.
   EndIf
   xVar1:= Val(SubStr(xArg1,1,2))
   If (xVar5 = 6)
      xVar2:= Val(SubStr(xArg1,3,2))
   Else
      If (xVar5 = 8)
         If (Asc(SubStr(xArg1,3,1)) >= 48 .AND. Asc(SubStr(xArg1,3,1)) <= 57)
            xVar2:= Val(SubStr(xArg1,3,2))
         Else
            xVar2:= Val(SubStr(xArg1,4,2))
         EndIf
      Else
         If (xVar5 = 10)
            xVar2:= Val(SubStr(xArg1,4,2))
         Else
            xVar2:= 99
         EndIf
      EndIf
   EndIf
   xVar3:= Val(right(xArg1,2))
   If (Int(xVar2/2.0) = xVar2/2.0)
      xVar4:= IIf(xVar2 < 8,IIf(xVar2 = 2,IIf(Int(xVar3/4.0) = xVar3/4.0,29,28),30),31)
   Else
      xVar4:= IIf(xVar2 < 8,31,30)
   EndIf
   Return xVar1 > 0 .AND. xVar1 <= xVar4 .AND. xVar2 > 0 .AND. xVar2 < 13 .AND. xVar3 >= 0 .AND. xVar3 <= 99

//-------------------------------------------------------------------
Function MMAA(xArg1)

   Local xVar1,xVar2,xVar3
   If (Empty(xArg1) .OR. xArg1 = "  /  " .OR. xArg1 = "  /    ")
      Return .T.
   EndIf
   xArg1:= Trim(xArg1)
   xVar3:= Len(xArg1)
   If (xVar3 < 4 .OR. xVar3 > 7)
      Return .F.
   EndIf
   xVar1:= Val(SubStr(xArg1,1,2))
   xVar2:= Val(right(xArg1,2))
   Return xVar1 < 13 .AND. xVar1 > 0 .AND. xVar2 >= 0 .OR. xArg1 = Space(Len(xArg1))

Function DDMM(xArg1)

   Local xVar1,xVar2,xVar3,xVar4
   If (Empty(xArg1) .OR. xArg1 = "  /  ")
      Return .T.
   EndIf
   xArg1:= Trim(xArg1)
   If (Len(xArg1) # 5 .AND. Len(xArg1) # 4)
      Return .F.
   EndIf
   xVar1:= IIf(Len(Trim(xArg1)) = 4,3,4)
   xVar2:= Val(SubStr(xArg1,1,2))
   xVar3:= Val(SubStr(xArg1,xVar1,2))
   xVar4:= IIf(Int(xVar3/2.0) = xVar3/2.0,IIf(xVar3 < 8,IIf(xVar3 = 2,29,30),31),IIf(xVar3 < 8,31,30))
   Return xVar2 > 0 .AND. xVar2 <= xVar4 .AND. xVar3 > 0 .AND. xVar3 < 13 .OR. xArg1 = Space(Len(xArg1))

Function NMES(xArg1)

   If (ValType(xArg1) = "D")
      xArg1:= Month(xArg1)
   EndIf
   Return SubStr("Janeiro  FevereiroMarco    Abril    Maio     Junho    Julho    Agosto   Setembro Outubro  Novembro Dezembro ",xArg1*9-8,9)

Function CARDTYPE
return 3

procedure __pprj

Function TLAPSO(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5
   xVar5:= IIf(PCount() = 1,IIf(ValType(xArg1) == "N",hstring(xArg1),xArg1),elaptime(xArg1,xArg2))
   xVar5:= IIf(Len(xVar5) = 6,"00"+Transform(xVar5,"@R 99:99:99"),IIf(Len(xVar5) = 8,"00"+xVar5,xVar5))
   xVar2:= Val(Left(xVar5,4))
   xVar3:= Val(SubStr(xVar5,6,2))
   xVar4:= Val(right(xVar5,2))
   xVar1:= IIf(xVar2 > 0,Str(xVar2)+" hora"+IIf(xVar2 > 1,"s",""),"")+IIf(xVar4*xVar3*xVar2 # 0,", ","")+IIf(xVar4 # 0 .AND. xVar3 = 0 .AND. xVar2 # 0 .OR. xVar4 = 0 .AND. xVar3 # 0 .AND. xVar2 # 0," e ","")+IIf(xVar3 > 0,Str(xVar3,IIf(xVar3 > 9,2,1), ;
      0)+" minuto"+IIf(xVar3 > 1,"s","")+IIf(xVar4 > 0," e ",""),"")+IIf(xVar4 > 0,Str(xVar4,IIf(xVar4 > 9,2,1),0)+" segundo"+IIf(xVar4 > 1,"s",""),"")
   Return alltrim(xVar1)

//-------------------------------------------------------------------
Function HSTRING(xArg1)

   Return strzero(Int(xArg1/3600),4,0)+":"+strzero(Int(mod(xArg1/60,60)),2,0)+":"+strzero(Int(mod(xArg1,60)),2,0)

Function EDBF(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9
   If (ValType(xArg1) = "U")
      Return .F.
   EndIf
   xArg1:= IIf("." $ xArg1,xArg1,xArg1+".dbf")
   xVar9:= strtran(xArg1,".dbf",extensao(.F.))
   If (!rwrite(xArg1))
      Return .F.
   EndIf
   If (file(xVar9) .AND. !rwrite(xVar9))
      ronly(xArg1)
      Return .F.
   EndIf
   xVar2:= fopen(xArg1,2)
   xVar1:= Space(14)
   xVar3:= fread(xVar2,@xVar1,14)
   xVar4:= Asc(xVar1)
   xVar6:= Chr(0)+Chr(0)
   xVar5:= SubStr(xVar1,11,2)
   xVar7:= SubStr(xVar1,13,2)
   If (PCount() < 2)
      fclose(xVar2)
      If (!(xVar8:= (xVar4 == 3 .OR. xVar4 == 131) .AND. xVar7 = xVar6))
         ronly(xArg1)
         If (file(xVar9))
            ronly(xVar9)
         EndIf
      EndIf
      Return xVar8
   EndIf
   If (xArg2)
      If ((xVar4 == 3 .OR. xVar4 == 131) .AND. xVar5 == xVar6)
         xVar1:= stuff(xVar1,11,2,xVar7)
         xVar1:= stuff(xVar1,13,2,xVar6)
      EndIf
      If (xVar4 == 4 .OR. xVar4 == 132)
         xVar1:= stuff(xVar1,1,1,Chr(xVar4-1))
         xVar1:= stuff(xVar1,11,2,xVar7)
         xVar1:= stuff(xVar1,13,2,xVar6)
      EndIf
   Else
      If ((xVar1:= stuff(xVar1,1,1,Chr(xVar4+1)),(xVar4 == 3 .OR. xVar4 == 131) .AND. xVar5 # xVar6))
         xVar1:= stuff(xVar1,11,2,xVar6)
         xVar1:= stuff(xVar1,13,2,xVar5)
      EndIf
   EndIf
   fseek(xVar2,0,0)
   xVar3:= fwrite(xVar2,xVar1,14)
   fclose(xVar2)
   If (!xArg2)
      ronly(xArg1)
      If (file(xVar9))
         ronly(xVar9)
      EndIf
   EndIf
   Return .T.

//-------------------------------------------------------------------
Function PWORD(xArg1,xArg2,xArg3)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10,xVar11,xVar12:= .F.,xVar13:= {}
   If (ValType(xArg1) == "C")
      xVar5:= xArg1
   Else
      Set Confirm Off
      xVar5:= ""
      xVar11:= SaveScreen(xArg1,xArg2,xArg1,xArg2+6)
      Do While (Len(xVar5) < 6)
         xVar3:= " "
         xVar6:= SetColor("7/0,/0")
         SetPos(xArg1,xArg2+Len(xVar5))
         AAdd(xVar13,__Get({|_1| IIf(_1 == Nil,xVar3,xVar3:= _1)},"pwi","!",Nil,Nil):display())
         ReadModal(xVar13)
         xVar13:= {}
         Set Color To (xVar6)
         If (LastKey() = 13 .AND. Len(xVar5) > 0)
            Exit
         EndIf
         If (LastKey() = 27 .OR. LastKey() = 13)
            If (Empty(xVar5))
               xVar12:= .T.
               Exit
            Else
               xVar5:= ""
               restscr(xArg1,xArg2,xArg1,xArg2+6,xVar11)
               Loop
            EndIf
         EndIf
         xVar5:= xVar5+xVar3
         @ xArg1,xArg2+Len(xVar5)-1 Say "˛"
      EndDo
   EndIf
   Return IIf(xVar12,"",encript(padr(xVar5,6)))

//-------------------------------------------------------------------
Function DLAPSO(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6
   xVar6:= ""
   If (PCount() == 1)
      xArg1:= IIf(ValType(xArg1) == "N",xArg1,0)
   Else
      If (ValType(xArg1) == "C")
         xVar6:= SubStr(xArg1,3,1)
         If (Asc(xVar6) >= 48 .AND. Asc(xVar6) <= 57)
            xVar6:= ""
         EndIf
         xVar3:= SubStr(xArg1,1,2)
         xVar4:= SubStr(xArg1,3+Len(xVar6),2)
         xVar5:= SubStr(xArg1,5+2*Len(xVar6))
         d1_:= CToD(Transform(xVar3+xVar4+xVar5,"@R 99/99/9999"))
         xVar6:= SubStr(xArg2,3,1)
         If (Asc(xVar6) >= 48 .AND. Asc(xVar6) <= 57)
            xVar6:= ""
         EndIf
         xVar3:= SubStr(xArg2,1,2)
         xVar4:= SubStr(xArg2,3+Len(xVar6),2)
         xVar5:= SubStr(xArg2,5+2*Len(xVar6))
         d2_:= CToD(Transform(xVar3+xVar4+xVar5,"@R 99/99/9999"))
         xArg1:= d1_-d2_
      Else
         xArg1:= xArg1-xArg2
      EndIf
   EndIf
   xArg1:= Abs(xArg1)
   xVar1:= 0
   Do While (xArg1 >= 365)
      xArg1:= xArg1-365
      xVar1++
   EndDo
   xVar2:= xArg1/30.42
   Do While (xVar2 >= 10.0)
      xVar2:= xVar2-10.0
      xVar1++
   EndDo
   xArg1:= LTrim(Str(Int((xVar2-Int(xVar2))*30.42)))+" dia"
   xArg1:= xArg1+IIf(Val(xArg1) > 1,"s","")
   xVar2:= LTrim(Str(Int(xVar2)))+" mes"+IIf(Int(xVar2) > 1,"es","")
   xVar1:= LTrim(Str(xVar1))+" ano"+IIf(xVar1 > 1,"s","")
   cl_tp:= IIf(Val(xVar1) > 0,xVar1+IIf(Val(xVar2) # 0 .AND. Val(xArg1) # 0 .OR. Val(xVar2) = 0 .AND. Val(xArg1) = 0,", "," e "),"")+IIf(Val(xVar2) > 0,xVar2+IIf(Val(xArg1) > 0," e ",", "),"")+IIf(Val(xArg1) > 0,xArg1,"")
   Return IIf(right(cl_tp,1) = " ",Left(cl_tp,Len(cl_tp)-2),cl_tp)

Function VHORA(xArg1)

   Local xVar1
   xVar1:= IIf(Len(xArg1) = 4 .OR. Len(xArg1) = 6,3,4)
   Return Val(Left(xArg1,2)) < 24 .AND. Val(SubStr(xArg1,xVar1,2)) < 60 .AND. Val(right(xArg1,2)) < 60

Function MTAB(xArg1,xArg2,xArg3,xArg4)

   Local xVar1,xVar2,xVar3,xVar4,xVar5
   xVar3:= 1
   If (ValType(xArg1) = "A")
      xVar4:= xArg1
      xArg1:= ""
      For xVar5:= 1 To Len(xVar4)
         xArg1:= xArg1+"|"+xVar4[xVar5]
      Next
      xArg1:= SubStr(xArg1,2)
   EndIf
   vr_:= readvar()
   vvr_:= &vr_
   If (!Empty(vvr_))
      vvr_:= IIf(Type("vvr_") = "N",alltrim(Str(vvr_,10,0)),vvr_)
      If (Type("acao_mac") = "C")
         xVar4:= "KEYBUFF"
         &xVar4(vvr_)
      Else
         Keyboard vvr_
      EndIf
   EndIf
   xVar1:= dbox(xArg1,xArg3,xArg4,.T.,Nil,xArg2,Nil,Nil,xVar3)
   If (xVar1 > 0)
      For xVar5:= 1 To xVar1-1
         parse(@xArg1,"|")
      Next
      p:= At("|",xArg1)
      If (p > 0)
         xArg1:= Left(xArg1,p-1)
      EndIf
      xArg1:= alltrim(xArg1)
      If (Type("vvr_") = "N")
         xArg1:= alltrim(Str(Val(xArg1),10,0))
      Else
         t_vvr:= Len(vvr_)
         xArg1:= Left(xArg1+Space(t_vvr),t_vvr)
      EndIf
   Else
      xArg1:= ""
   EndIf
   Return xArg1

Function EDIMEMO(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6)

   Local xVar1:= SetColor(),xVar2:= SaveScreen(0,0,MaxRow(),79),xVar3:= .F.,xVar4,xVar5, xVar6_
   Private letras:= "aeioucAEIOUC",tbacento:= "†Ç°¢£áèê°¢£ÄÖäçï£áèê°¢£ÄÉàåìÅáéEIôöÄÑâiîÅáéEIôöÄ",acento:= "'`^~,",t_w,t_r,t_c,t_t,t_7,cod_sos:= 20, xGravou2
   If (Abs(xArg5-xArg3) < 2 .OR. Abs(xArg6-xArg4) < 15 .OR. LastKey() = 5 .AND. !brw)
      Return .T.
   EndIf
   xArg3:= IIf(xArg3 < 1,1,xArg3)
   xArg5:= IIf(xArg5 > MaxRow(),MaxRow(),xArg5)
   t_w:= SetKey(23,Nil)
   t_r:= SetKey(18,Nil)
   t_c:= SetKey(3,Nil)
   t_t:= SetKey(9,Nil)
   t_7:= SetKey(-6,{|| joganobuff("")})
   x:= 0
   For t:= 1 To Len(xArg1)
      x:= Asc(SubStr(xArg1,t,1))+t
   Next
   xVar4:= novaposi(@xArg3,@xArg4,@xArg5,@xArg6)
   xVar5:= SetKey(-37,Nil)
   Do While (.T.)
      rola_cx:= .F.
      Set Color To (drvcorget)
      caixa(mold,xArg3,xArg4,xArg5,xArg6,78)
      Set Color To ("GR+"+SubStr(drvcorget,At("/",drvcorget)))
      @ xArg3,xArg4+1 Say " "+xArg2+" "
      @ xArg5,xArg4+1 Say " F7=grava, ESC=abandona "
      Set Color To (drvcorget)
      init_count:= 1
      ret_val:= 0
      i_n_s:= sep_pala:= .T.
      deja_vu:= memo_modif:= ins_on:= scrl_on:= .F.
      If (Type("acao_mac") = "C" .AND. acao_mac $ "LCA")
         Keyboard Chr(19)
      EndIf

      xGravou:=.t.
      xVar6_:=&xArg1.
      xVar6_:=memoedit(xVar6_,xArg3+1,xArg4+1,xArg5-1,xArg6-1,.T.,"MFUNC")

      If xGravou
         If (!Empty(alias()))
            Replace &xArg1 With xVar6_
         Else
            &xArg1:= xVar6_
         Endif
      Endif

      SetKey(-37,Nil)
      If (rola_cx)
         muda_pj(@xArg3,@xArg4,@xArg5,@xArg6,xVar2,.T.)
         xVar3:= .T.
         Loop
      EndIf
      Exit
   EndDo
   If (xVar3 .AND. Type("arqconf") = "C")
      Public &xVar4:= Str(xArg3,2)+Str(xArg4,2)
      Save All Like drv* To (arqconf)
      Restore From (arqconf) Additive
   EndIf
   SetKey(-37,xVar5)
   Set Color To (xVar1)
   restscr(0,0,MaxRow(),79,xVar2)
   SetKey(23,t_w)
   SetKey(18,t_r)
   SetKey(3,t_c)
   SetKey(9,t_t)
   SetKey(-6,t_7)
   If (!brw)
      joganobuff("{F7}")
   EndIf
   Return Nil

Function MFUNC

   Parameters mode,line,col
   Private t_e_c_l_a:= LastKey()
   If (IIf(Type("acao_mac") = "C",acao_mac $ "Gg" .AND. t_e_c_l_a # -6,.F.))
      x:= "MONTA_BUFF"
      keyb_mac(&x(t_e_c_l_a))
      q_tec(0)
   EndIf
   ret_val:= 0
   If (mode = 3)
      If (init_count == 1)
         ins_mode:= readinsert()
         If (ins_on .AND. !ins_mode .OR. !ins_on .AND. ins_mode)
            ret_val:= 22
         Else
            init_count:= 2
         EndIf
      EndIf
      If (init_count == 2)
         If ((!scrl_on .AND. !i_n_s .OR. scrl_on .AND. i_n_s) .AND. !deja_vu)
            deja_vu:= .T.
            ret_val:= 35
         Else
            init_count:= 3
            deja_vu:= .F.
         EndIf
      EndIf
      If (init_count == 3)
         If (!sep_pala .AND. !deja_vu)
            deja_vu:= .T.
            ret_val:= 34
         Else
            init_count:= 4
            deja_vu:= .F.
         EndIf
      EndIf
      If (init_count == 4)
         ret_val:= 0
      EndIf
   Else
      If (mode = 0)
         p1:= At(Chr(t_e_c_l_a),acento)
         If (p1 > 0 .AND. IIf(Type("acao_mac") = "C",acao_mac = "D",.T.))
            t_c_:= q_tec(0)
            If (IIf(p1 = 5,t_c_ = 67 .OR. t_c_ = 99,Chr(t_c_) $ letras))
               If (p1 == 5)
                  car:= IIf(t_c_ = 67,"Ä","á")
               Else
                  p2:= At(Chr(t_c_),letras)
                  car:= SubStr(tbacento,p1*12-11+(p2-1),1)
               EndIf
               joganobuff(IIf(readinsert(),"","")+car)
            Else
               joganobuff(Chr(t_c_))
            EndIf
         EndIf
      Else
         t_e_c_l_a:= LastKey()
         If (mode == 2)
            memo_modif:= .T.
         EndIf
         If (t_e_c_l_a = -37)
            rola_cx:= .T.
            ret_val:= 23
         Else
            If (t_e_c_l_a = 23)
               If (!memo_modif)
               Else
                  ret_val:= 23
               EndIf
            Else
               If (t_e_c_l_a = 27)
                  If (!memo_modif)
                     xGravou:=.f.
                     ret_val:= 23
                  Else
                     op_mf:= dbox("Sim|NÑo",Nil,Nil,.T.,Nil,"ABANDONAR ALTERAÄéO")
                     If (op_mf == 1)
                        xGravou:=.f.
                        ret_val:= 23
                     Else
                        ret_val:= 32
                     EndIf
                  EndIf
               Else
                  If (t_e_c_l_a = -7 .AND. i_n_s)
                     sep_pala:= !sep_pala
                     ret_val:= 34
                  Else
                     If (t_e_c_l_a = -9)
                        scrl_on:= !scrl_on
                        ret_val:= 35
                     Else
                        If ((t_e_c_l_a = 279 .OR. t_e_c_l_a = 22) .AND. i_n_s)
                           ins_on:= !ins_on
                           ret_val:= 22
                        EndIf
                     EndIf
                  EndIf
               EndIf
            EndIf
         EndIf
      EndIf
   EndIf
   If (IIf(Type("acao_mac") = "C",acao_mac $ "LAC" .AND. t_e_c_l_a # -6,.F.))
      x:= "MONTA_BUFF"
      keyb_mac(&x(q_tec(0)))
   EndIf
   Return ret_val

Function CALCDATA(xArg1,xArg2)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6
   xVar6:= ""
   Set Date British
   If (Type("d_t") == "D")
      xVar1:= xArg1+xArg2
   Else
      xVar6:= SubStr(xArg1,3,1)
      If (Asc(xVar6) >= 48 .AND. Asc(xVar6) <= 57)
         xVar6:= ""
      EndIf
      xVar3:= SubStr(xArg1,1,2)
      xVar4:= SubStr(xArg1,3+Len(xVar6),2)
      xVar5:= SubStr(xArg1,5+2*Len(xVar6))
      d1_:= CToD(Transform(xVar3+xVar4+xVar5,"@R 99/99/9999"))
      d1_:= d1_+xArg2
      d1_:= DToS(d1_)
      xVar1:= SubStr(d1_,7,2)+xVar6+SubStr(d1_,5,2)+xVar6+right(SubStr(d1_,1,4),Len(xVar5))
   EndIf
   Return xVar1

Function IMPAC(xArg1,xArg2,xArg3,xArg4)

   Local xVar1:= "aeioucAEIOUC",xVar2:= "†Ç°¢£áèê°¢£ÄˇÖäçï£áèê°¢£ÄˇÑâˇîÅáéˇˇôöÄˇÉàåìÅáéˇˇôöÄ",xVar3:= "'`~^",xVar4,xVar5,xVar6,xVar7
   xVar6:= IIf(Type("tps") == "N",tps = 1,.T.)
   xVar6:= IIf(Type("drvpadrao") == "C",Val(drvpadrao) < 5 .AND. xVar6,xVar6)
   xArg4:= IIf(xArg3 = Nil,xArg2,xArg4)
   xArg4:= IIf(ValType(xArg4) = "L",xArg4,.F.)
   If (xArg4 .AND. At(" ",Trim(xArg1)) > 0 .AND. right(Trim(xArg1),1) # ".")
      xArg4:= Len(xArg1)
      xVar4:= " "
      xArg1:= Trim(xArg1)
      Do While (xArg4-Len(xArg1) > 0)
         xVar5:= xArg4-Len(xArg1)
         If (xVar5 > 0)
            xArg1:= strtran(xArg1,xVar4,xVar4+" ",1,xVar5)
         EndIf
      EndDo
   EndIf
   ts_:= Len(xArg1)
   If (xVar6)
      For xVar7:= 1 To Len(xArg1)
         xVar5:= At(SubStr(xArg1,xVar7,1),xVar2)
         If (xVar5 > 0)
            If (SubStr(xArg1,xVar7,1) $ "Äá")
               xVar4:= IIf(SubStr(xArg1,xVar7,1) = "Ä","C","c")+""+","
            Else
               xVar4:= SubStr(xVar1,xVar5%13,1)+""+SubStr(xVar3,Int(xVar5/13)+1,1)
            EndIf
            xArg1:= Left(xArg1,xVar7-1)+xVar4+SubStr(xArg1,xVar7+1)
            xVar7:= xVar7+2
         EndIf
      Next
   EndIf
   If (xArg3 # Nil)
      @ xArg2,xArg3 Say xArg1
      setprc(xArg2,xArg3+ts_+Set(25))
   EndIf
   Return xArg1

Static Function ACHAPOIN(xArg1,xArg2)

   Local xVar1,xVar2
   xVar2:= 2
   poin:= 1
   For xVar1:= 1 To Len(xArg1)
      If (xVar2+Len(xArg1[xVar1])+2 > 78)
         poin:= xVar1
         xVar2:= 2
      EndIf
      xVar2:= xVar2+(Len(xArg1[xVar1])+2)
      If (xVar1 = xArg2)
         Exit
      EndIf
   Next
   Return poin

Static Function MENUV(xArg1,xArg2,xArg3,xArg4,xArg5,xArg6,xArg7)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10,xVar11,xVar12,xVar13,xVar14,xVar15,xVar16,xVar17,xVar18
   xVar17:= .T.
   xVar13:= Len(xArg1)
   xArg3:= Int(IIf(xArg3 = Nil .OR. xArg3 < 1,1,IIf(xArg3 > xVar13,xVar13,xArg3)))
   xArg4:= IIf(xVar13 < xArg4,xVar13,xArg4)-1
   xVar1:= 0
   xVar2:= xArg5+1
   If (drvmouse)
      x:= "MOUSEBOX"
      &x(xArg5,xArg6,xArg5+xArg4,xArg6+xArg7-IIf(xVar13-1 = xArg4,1,0))
   EndIf
   If (xVar13-1 > xArg4)
      @ xArg5,xArg6+xArg7 Say ""
      @ xArg5+xArg4,xArg6+xArg7 Say ""
      For xVar3:= 1 To xArg4-1
         @ xArg5+xVar3,xArg6+xArg7 Say "±"
      Next
   EndIf
   xVar4:= ""
   xVar5:= Len(xVar4)+1
   If (xArg3 <= xArg4+1)
      xVar6:= 1
      xVar7:= xArg3
   Else
      xVar6:= xArg3-xArg4
      xVar7:= xArg4+1
   EndIf
   Do While (xArg1[xArg3] == "---")
      If (xVar7 <= xArg4)
         xArg3++
         xVar7++
      Else
         If (xArg3 < xVar13)
            xVar6++
            xArg3++
            xVar17:= .T.
         Else
            Exit
         EndIf
      EndIf
   EndDo
   xVar8:= xVar14:= xVar15:= ppp:= 0
   xVar16:= invcor(drvcorget)
   Do While (xVar8 # 13 .AND. xArg3 # 0)
      If (xVar17)
         xVar10:= xArg5
         For xVar9:= xVar6 To xVar6+xArg4
            Set Color To (tit_op)
            If (xArg1[xVar9] == "---")
               @ xVar10,xArg6-1 Say SubStr(mold,9,1)+Replicate(SubStr(mold,10,1),xArg7)
               If (xVar13-1 <= xArg4)
                  @ xVar10,xArg6+xArg7 Say SubStr(mold,11,1)
               EndIf
            Else
               @ xVar10,xArg6-1 Say SubStr(mold,8,1)
               If (xVar13-1 <= xArg4)
                  @ xVar10,xArg6+xArg7 Say SubStr(mold,4,1)
               EndIf
               If (xVar9 = xArg3)
                  Set Color To (xVar16)
               Else
                  Set Color To (cor_op)
               EndIf
               @ xVar10,xArg6 Say xArg1[xVar9]
               ki:= Left(LTrim(xArg1[xVar9]),Len(xVar4))
               If (Upper(ki) = xVar4 .AND. xVar9 = xArg3)
                  px:= Len(xArg1[xVar9])-Len(LTrim(xArg1[xVar9]))
                  Set Color To (drvcorenf)
                  @ xVar10,xArg6+px Say ki
               EndIf
            EndIf
            xVar10++
         Next
         Set Color To (cor_op)
         xVar17:= .F.
      EndIf
      If (xVar13 > xArg4+1)
         Set Color To (cor_op)
         @ xVar2,xArg6+xArg7 Say "±"
         xVar2:= xArg5+1+Int(xArg3/(xVar13/(xArg4-2)))
         @ xVar2,xArg6+xArg7 Say "€"
      EndIf
      If (drvmouse)
         x:= "MOUSECUR"
         &x(.T.)
         xVar8:= 0
         Do While (xVar8 = 0)
            xVar18:= xVar14
            x:= "MOUSEGET"
            pp:= &x(@xVar14,@xVar15)
            x:= "POEHORA"
            &x()
            xVar8:= nextkey()
            If (pp = 1 .AND. xVar8 = 0)
               ppp:= IIf(xVar18 # xVar14,0,ppp)
               press:= Seconds() > ppp+0.5
               If ((ppp = 0 .OR. press) .AND. xVar14 >= xArg5 .AND. xVar14 <= xArg5+xArg4 .AND. xVar15 >= xArg6 .AND. xVar15 <= xArg6+xArg7-IIf(xVar13-1 = xArg4,1,0))
                  If (xVar14 = xArg5 .AND. xVar15 = xArg6+xArg7)
                     joganobuff("")
                  Else
                     If (xVar14 = xArg5+xArg4 .AND. xVar15 = xArg6+xArg7)
                        joganobuff("")
                     Else
                        If (xVar15 = xArg6+xArg7)
                           joganobuff(Chr(IIf(xVar14 > xVar2,3,18)))
                        Else
                           xVar3:= xArg3
                           If (!(xArg1[xVar6+xVar14-xArg5] == "---"))
                              xArg3:= xVar6+xVar14-xArg5
                              xVar7:= xVar14-xArg5+1
                              If (ppp # 0)
                                 rola_cx:= .T.
                                 joganobuff(Chr(13))
                              Else
                                 If (xVar3 = xArg3)
                                    joganobuff(Chr(13))
                                 Else
                                    x:= "MOUSECUR"
                                    &x(.F.)
                                    @ xVar3+xArg5-xVar6,xArg6 Say xArg1[xVar3]
                                    Set Color To (xVar16)
                                    @ xArg3+xArg5-xVar6,xArg6 Say xArg1[xArg3]
                                    Set Color To (cor_op)
                                    x:= "MOUSECUR"
                                    &x(.T.)
                                 EndIf
                              EndIf
                           EndIf
                        EndIf
                     EndIf
                  EndIf
               EndIf
               ppp:= IIf(ppp = 0,Seconds(),ppp)
            Else
               If (pp == 2)
                  joganobuff("")
               Else
                  If (pp == 0)
                     ppp:= 0
                  EndIf
               EndIf
            EndIf
         EndDo
         x:= "MOUSECUR"
         &x(.F.)
      EndIf
      xVar8:= q_tec(0)
      If (xVar8 > 31 .AND. xVar8 < 127)
         xVar4:= xVar4+Upper(Chr(xVar8))
         Do While (.T.)
            For xVar9:= 1 To xVar13
               If ((xVar12:= Upper(Left((xVar11:= alltrim(xArg1[xVar9]),xVar11),xVar5)),xVar1:= xVar4 = xVar12,!(xArg1[xVar9] == "---") .AND. xVar1))
                  xArg3:= xVar9
                  xVar5++
                  xVar9:= 999
                  If (xArg3 <= xArg4+1)
                     xVar6:= 1
                     xVar7:= xArg3
                  Else
                     xVar6:= xArg3-xArg4
                     xVar7:= xArg4+1
                  EndIf
               EndIf
            Next
            If (xVar9 = xVar13+1 .AND. Len(xVar4) > 1)
               xVar4:= right(xVar4,1)
               xVar5:= 1
            Else
               Exit
            EndIf
         EndDo
         xVar17:= .T.
      Else
//        If ((eval(SetKey(xVar8)),SetKey(xVar8) # Nil .AND. drvmouse))
//           x:= "MOUSEBOX"
//           &x(xArg5,xArg6,xArg5+xArg4,xArg6+xArg7-IIf(xVar13-1 = xArg4,1,0))
//        EndIf
         If SetKey(xVar8)<>Nil
            EVAL(SetKey(xVar8))
         endi
         If (xVar8 == 27)
            xArg3:= 0
            Exit
         EndIf
         If (xVar8 == 7)
            volta_ac:= .T.
            Exit
         EndIf
         xVar4:= ""
         xVar5:= 1
         @ xArg3+xArg5-xVar6,xArg6 Say xArg1[xArg3]
         If (xVar8 == -30)
            drvautohelp:= !drvautohelp
         EndIf
         If (xVar8 == 24)
            Do While (.T.)
               If (xVar7 <= xArg4)
                  xArg3++
                  xVar7++
               Else
                  If (xArg3 < xVar13)
                     xVar6++
                     xArg3++
                     xVar17:= .T.
                  Else
                     xVar8:= IIf(Set(35),1,xVar8)
                  EndIf
               EndIf
               If (xVar8 # 24 .OR. !(xArg1[xArg3] == "---"))
                  Exit
               EndIf
            EndDo
         EndIf
         If (xVar8 == -37)
            rola_cx:= .T.
            xVar8:= 13
         EndIf
         If (xVar8 == 1)
            xVar7:= 1
            xVar6:= 1
            xArg3:= 1
            xVar17:= .T.
            Do While (xArg1[xArg3] == "---")
               If (xVar7 <= xArg4)
                  xArg3++
                  xVar7++
               Else
                  If (xArg3 < xVar13)
                     xVar6++
                     xArg3++
                     xVar17:= .T.
                  Else
                     Exit
                  EndIf
               EndIf
            EndDo
         EndIf
         If (xVar8 == 5)
            Do While (.T.)
               If (xVar7 > 1)
                  xArg3--
                  xVar7--
               Else
                  If (xArg3 > 1)
                     xVar6--
                     xArg3--
                     xVar17:= .T.
                  Else
                     xVar8:= IIf(Set(35),6,xVar8)
                  EndIf
               EndIf
               If (xVar8 # 5 .OR. !(xArg1[xArg3] == "---"))
                  Exit
               EndIf
            EndDo
         EndIf
         If (xVar8 == 6)
            xVar7:= xArg4+1
            xArg3:= xVar13
            xVar6:= xVar13-xArg4
            xVar17:= .T.
            Do While (xArg1[xArg3] == "---")
               If (xVar7 > 1)
                  xArg3--
                  xVar7--
               Else
                  If (xArg3 > 1)
                     xVar6--
                     xArg3--
                     xVar17:= .T.
                  Else
                     Exit
                  EndIf
               EndIf
            EndDo
         EndIf
         If (xVar8 == 3)
            xVar7:= xArg4+1
            xVar6:= xVar6+xArg4
            If (xVar6 > xVar13-xArg4)
               xVar6:= xVar13-xArg4
            EndIf
            xArg3:= xVar6+xVar7-1
            xVar17:= .T.
         EndIf
         If (xVar8 == 18)
            xVar7:= 1
            xVar6:= xVar6-xArg4
            If (xVar6 < 1)
               xVar6:= 1
            EndIf
            xArg3:= xVar6+xVar7-1
            xVar17:= .T.
         EndIf
         If (!xVar17)
            Set Color To (xVar16)
            @ xArg3+xArg5-xVar6,xArg6 Say xArg1[xArg3]
            Set Color To (cor_op)
         EndIf
      EndIf
   EndDo
   xVar4:= ""
   Return IIf(xArg3 > 0,xArg2[xArg3],0)

Static Function MENUH(xArg1,xArg2,xArg3,xArg4)

   Local xVar1,xVar2,xVar3:= "",xVar4:= 1,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10,xVar11:= 0,xVar12,xVar13,xVar14
   xVar10:= Len(xArg1)
   xArg3:= Int(IIf(xArg3 = Nil .OR. xArg3 < 1,1,IIf(xArg3 > xVar10,xVar10,xArg3)))
   For xVar2:= 1 To xVar10
      xVar11:= xVar11+(Len(xArg1[xVar2])+2)
   Next
   xVar5:= achapoin(xArg1,xArg3)
   xVar1:= 0
   If (drvmouse)
      x:= "MOUSEBOX"
      &x(xArg4,0,xArg4,79)
   EndIf
   xVar14:= invcor(drvcorget)
   Do While (xVar6 # 13 .AND. xArg3 # 0)
      @ xArg4, 0
      colj:= 2
      For xVar7:= xVar5 To xVar10
         If (colj+Len(xArg1[xVar7])+2 > 78)
            Exit
         EndIf
         If (xVar7 = xArg3)
            Set Color To (xVar14)
            colopsel:= colj
         Else
            Set Color To (cor_op)
         EndIf
         @ xArg4,colj Say xArg1[xVar7]
         If (Len(xVar3) > 0 .AND. xVar7 = xArg3 .AND. Upper((xVar8:= Left(xArg1[xVar7],Len(xVar3)),xVar8)) = xVar3)
            Set Color To (drvcorenf)
            @ xArg4,colj Say xVar8
         EndIf
         colj:= colj+(Len(xArg1[xVar7])+2)
         pofn:= xVar7
      Next
      Set Color To (cor_op)
      If (xVar11 > 78)
         @ xArg4, 0 Say ""
         @ xArg4,79 Say Chr(26)
      EndIf
      If (drvmouse)
         x:= "MOUSETECLA"
         xVar6:= &x(xArg4,0,xArg4,79)
         x:= "MOUSEGET"
         &x(@xVar12,@xVar13)
      Else
         xVar6:= q_tec(0)
      EndIf
      If (xVar6 > 31 .AND. xVar6 < 127)
         xVar3:= xVar3+Upper(Chr(xVar6))
         Do While (.T.)
            For xVar7:= 1 To xVar10
               xVar8:= xArg1[xVar7]
               xVar9:= Upper(Left(xVar8,xVar4))
               xVar1:= xVar3 = xVar9
               If (xVar1)
                  xArg3:= xVar7
                  xVar4++
                  xVar7:= 999
                  xVar5:= achapoin(xArg1,xArg3)
               EndIf
            Next
            If (xVar7 = xVar10+1 .AND. Len(xVar3) > 1)
               xVar3:= right(xVar3,1)
               xVar4:= 1
            Else
               Exit
            EndIf
         EndDo
      Else
         If (SetKey(xVar6) # Nil)
            eval(SetKey(xVar6))
         EndIf
         If (xVar6 == 27)
            xArg3:= 0
            Exit
         EndIf
         If (xVar6 # 13)
            xVar3:= ""
            xVar4:= 1
            @ xArg4,colopsel Say xArg1[xArg3]
         EndIf
         If (xVar6 == -100)
            colj:= 2
            For xVar2:= xVar5 To pofn
               If (xVar13 >= colj .AND. xVar13 <= colj+Len(xArg1[xVar2]))
                  If (xArg3 = xVar2)
                     xVar6:= 13
                  Else
                     xArg3:= xVar2
                  EndIf
                  Exit
               EndIf
               colj:= colj+(Len(xArg1[xVar2])+2)
            Next
         EndIf
         If (xVar6 = 24 .OR. xVar6 = 4)
            If (xArg3 < xVar10)
               xArg3++
               If (xArg3 > pofn)
                  xVar5:= achapoin(xArg1,xArg3)
               EndIf
            Else
               If (Set(35))
                  xVar6:= 1
               EndIf
            EndIf
         EndIf
         If (xVar6 == -30)
            drvautohelp:= !drvautohelp
         EndIf
         If (xVar6 == -37)
            rola_cx:= .T.
            xVar6:= 13
         EndIf
         If (xVar6 == 1)
            xVar5:= 1
            xArg3:= 1
         EndIf
         If (xVar6 = 5 .OR. xVar6 = 19)
            If (xArg3 > 1)
               xArg3--
               If (xArg3 < xVar5)
                  xVar5:= achapoin(xArg1,xArg3)
               EndIf
            Else
               If (Set(35))
                  xVar6:= 6
               EndIf
            EndIf
         EndIf
         If (xVar6 == 6)
            xArg3:= xVar10
            xVar5:= achapoin(xArg1,xArg3)
         EndIf
      EndIf
   EndDo
   xVar3:= ""
   Return IIf(xArg3 > 0,xArg2[xArg3],0)

Static Function DIVISORINT(xArg1,xArg2)

   Local xVar1,xVar2
   xVar2:= Int(xArg1/xArg2)
   xVar1:= xArg1/xArg2-xVar2
   If (xVar1 > 0)
      xVar2++
   EndIf
   Return xVar2*xArg2

Static Procedure COMANDO_MA(xArg1)

   Local xVar1,xVar2,xVar3,xVar4
   If (xArg1 > 47 .AND. xArg1 < 58)
      fat_mac:= xArg1-48
   Else
      If (xArg1 == 42)
         fat_mac:= 100
      Else
         If ((xArg1 = 46 .OR. xArg1 = 9) .AND. acao_mac = "C")
            If (xArg1 == 9)
               xVar2:= IIf("." $ arq_mac,Left(arq_mac,At(".",arq_mac)-1),arq_mac)+".$$$"
               If (file(xVar2))
                  Erase (xVar2)
               EndIf
               xVar4:= fseek(handle_mac,0,1)
               xVar3:= fcreate(xVar2)
               xVar1:= 512
               Do While (xVar1 = 512)
                  buffer_mac:= Space(512)
                  xVar1:= fread(handle_mac,@buffer_mac,512)
                  fwrite(xVar3,buffer_mac,xVar1)
               EndDo
               fclose(xVar3)
               fseek(handle_mac,xVar4,0)
               acao_mac:= "g"
            Else
               acao_mac:= "G"
            EndIf
            fwrite(handle_mac,"")
            fclose(handle_mac)
            handle_mac:= fopen(arq_mac,1)
            fseek(handle_mac,0,2)
            xArg1:= 0
         Else
            If (xArg1 == 27)
               acao_mac:= "D"
               fclose(handle_mac)
            EndIf
         EndIf
      EndIf
   EndIf
   Return

Static Function BARRACHEIA(xArg1,xArg2)

   Local xVar1
   xVar1:= ""
   If (drvpadrao == "1" .OR. drvpadrao == "2" .OR. drvpadrao == "3")
      xVar1:= Replicate("ˇ",Round(xArg1*(240/72),0))
   Else
      If (drvpadrao == "4")
         xVar1:= Replicate("ˇˇ¸",Round(xArg1*(180/72),0))
      Else
         If (drvpadrao == "5" .OR. drvpadrao == "6")
            xVar1:= Replicate("1",Round(300/72*xArg1,0))
         Else
            If (drvpadrao == "7" .OR. drvpadrao == "8")
               xVar1:= ""+"&f0S"+""+"&a-"+LTrim(Str(xArg2*10*0.75))+"V"+""+"*c"+LTrim(Str(xArg1*10))+"H"+""+"*c"+LTrim(Str(xArg2*10))+"V"+""+"*c0P"+""+"&f1S"+""+"&a+"+LTrim(Str(xArg1*10))+"H"
            EndIf
         EndIf
      EndIf
   EndIf
   Return xVar1

//-------------------------------------------------------------------

Static Function CBPARC(xArg1,xArg2,xArg3,xArg4,xArg5)

   Local xVar1,xVar2,xVar3,xVar4,xVar5,xVar6,xVar7,xVar8,xVar9,xVar10
   xVar2:= 0
   xVar10:= Val(SubStr(xArg1,1,1))
   xArg1:= SubStr(xArg1,2)
   xVar5:= Len(xArg1)
   For xVar3:= 1 To xVar5
      If (SubStr(xArg1,xVar3,1) == "1" .OR. SubStr(xArg1,xVar3,1) == "2")
         xVar2++
      Else
         Do Case
         Case xVar10==4
            xVar2:= xVar2+2.52
         Case xVar10==5
            xVar2:= xVar2+2.0
         EndCase
      EndIf
   Next
   xVar4:= IIf(xVar2 # 0,72/xArg3*xArg2/xVar2,0)
   xVar6:= barravazia(xVar4)
   xVar7:= barracheia(xVar4,xArg4)
   Do Case
   Case xVar10==4
      xVar8:= barravazia(xVar4*2.52)
      xVar9:= barracheia(xVar4*2.52,xArg4)
   Case xVar10==5
      xVar8:= barravazia(xVar4*2.0)
      xVar9:= barracheia(xVar4*2.0,xArg4)
   EndCase
   xVar1:= ""
   For xVar3:= 1 To xVar5
      If (SubStr(xArg1,xVar3,1) == "1")
         xVar1:= xVar1+xVar6
         xArg5:= xArg5+xVar4
      Else
         If (SubStr(xArg1,xVar3,1) == "2")
            xVar1:= xVar1+xVar7
            xArg5:= xArg5+xVar4
         Else
            If (SubStr(xArg1,xVar3,1) == "3")
               xVar1:= xVar1+xVar8
               xArg5:= xArg5+xVar4*IIf(xVar10 == 4,2.52,2)
            Else
               If (SubStr(xArg1,xVar3,1) == "4")
                  xVar1:= xVar1+xVar9
                  xArg5:= xArg5+xVar4*IIf(xVar10 == 4,2.52,2)
               EndIf
            EndIf
         EndIf
      EndIf
   Next
   Return xVar1

//-------------------------------------------------------------------
Static Function CVBINT(xArg1)

   Local xVar1,xVar2:= 0,xVar3:= Len(xArg1)
   For xVar1:= xVar3 To 1 Step -1
      If (SubStr(xArg1,xVar1,1) == "1")
         xVar2:= xVar2+2^(xVar3-xVar1)
      EndIf
   Next
   Return xVar2

//-------------------------------------------------------------------
Static Function BARRAVAZIA(xArg1)

   Local xVar1
   xVar1:= ""
   If (drvpadrao == "1" .OR. drvpadrao == "2" .OR. drvpadrao == "3")
      xVar1:= Replicate(Chr(0),Round(xArg1*(240/72),0))
   Else
      If (drvpadrao == "4")
         xVar1:= Replicate(Chr(0)+Chr(0)+Chr(0),Round(xArg1*(180/72),0))
      Else
         If (drvpadrao == "5" .OR. drvpadrao == "6")
            xVar1:= Replicate("0",Round(300/72*xArg1,0))
         Else
            If (drvpadrao == "7" .OR. drvpadrao == "8")
               xVar1:= ""+"&a+"+LTrim(Str(xArg1*10))+"H"
            EndIf
         EndIf
      EndIf
   EndIf
   Return xVar1

//-------------------------------------------------------------------
Static Function MONTABAR(xArg1,xArg2)

   Do Case
   Case xArg1==1
      Static13:= {}
      AAdd(Static13,"")
   Case xArg1==2
      If (Len(ATail(Static13))+Len(xArg2) < 50000.0)
         Static13[Len(Static13)]:= Static13[Len(Static13)]+xArg2
      Else
         AAdd(Static13,xArg2)
      EndIf
   Case xArg1==3
   EndCase
   Return .T.

//-------------------------------------------------------------------
Static Function CODTUDO(xArg1,xArg2,xArg3,xArg4,xArg5)

   Local xVar1:= "",xVar2,xVar3,xVar4,xVar5,xVar6:= .T.
   If (drvpadrao == "1" .OR. drvpadrao == "2" .OR. drvpadrao == "3")
      xVar6:= montabar(2, ;
         "UZ"+Chr(Len(xArg1)%256)+Chr(Int(Len(xArg1)/256))+xArg1+""+"J"+""+Chr(13)+Space(xArg2)+""+"Z"+Chr(Len(xArg1)%256)+Chr(Int(Len(xArg1)/256))+xArg1+""+"J"+Chr((xArg4-8)*3-1)+Chr(13)+Space(xArg2)+""+"Z"+Chr(Len(xArg1)%256)+Chr(Int(Len(xArg1)/256))+xArg1+""+"J"+""+Chr(13)+Space(xArg2)+""+"Z"+Chr(Len(xArg1)%256)+Chr(Int(Len(xArg1)/256))+xArg1+""+"J"+""+Chr(13)+""+"U"+Chr(0))
   Else
      If (drvpadrao == "4")
         If (xVar6:= montabar(2,"U*'"+Chr(Len(xArg1)/3%256)+Chr(Int(Len(xArg1)/3/256))+xArg1))
            If (xArg4 == 12)
               xVar6:= montabar(2,"J"+Chr(10)+Chr(13)+Space(xArg2)+""+"*"+"'"+Chr(Len(xArg1)/3%256)+Chr(Int(Len(xArg1)/3/256))+xArg1+""+"J"+""+Chr(13))
            Else
               xVar6:= montabar(2,Chr(13)+Chr(10))
            EndIf
            If (xVar6)
               xVar6:= montabar(2,"U"+Chr(0))
            EndIf
         EndIf
      Else
         If (drvpadrao == "5" .OR. drvpadrao == "6")
            xVar2:= divisorint(Len(xArg1),8)
            xArg1:= xArg1+Replicate("0",xVar2+Len(xArg1))
            For xVar4:= 1 To xVar2 Step 8
               xVar5:= SubStr(xArg1,xVar4,8)
               If (xVar5 == "00000000")
                  xVar1:= xVar1+Chr(0)
               Else
                  If (xVar5 == "11111111")
                     xVar1:= xVar1+"ˇ"
                  Else
                     xVar1:= xVar1+Chr(cvbint(SubStr(xArg1,xVar4,8)))
                  EndIf
               EndIf
            Next
            If (drvpadrao == "5")
               xVar1:= Replicate(Chr(0),Int(300/xArg3*xArg2/8))+xVar1
               xVar1:= "*b"+LTrim(Str(Len(xVar1)))+"W"+xVar1
            Else
               xVar1:= "*b"+LTrim(Str(Len(xVar1)))+"W"+xVar1
               xVar1:= "*b"+LTrim(Str(300/xArg3*xArg2))+"X"+xVar1
            EndIf
            xVar3:= Round(300/72*xArg4,0)
            If (xVar6:= montabar(2,"*t300R"+"&a-"+LTrim(Str(xArg4*10*0.75))+"V"+""+"*r0A"))
               For xVar4:= 1 To xVar3
                  If (!(xVar6:= montabar(2,xVar1)))
                     Exit
                  EndIf
               Next
               If (xVar6 .AND. (xVar6:= montabar(2,"*rB"+"&a-"+LTrim(Str(xArg4*10*0.25))+"V"+""+"&a"+LTrim(Str(xArg2))+"C")))
                  xVar6:= montabar(2,Chr(13)+Chr(10))
               EndIf
            EndIf
         Else
            If (drvpadrao == "7" .OR. drvpadrao == "8")
               If ((xVar6:= montabar(2,"*t300R"+"&f0S"+xArg1+""+"&f1S")) .AND. xArg5)
                  xVar6:= montabar(2,Chr(13)+Chr(10))
               EndIf
            Else
               xVar6:= montabar(2,Chr(13)+Chr(10))
            EndIf
         EndIf
      EndIf
   EndIf
   Return xVar6

Function __XRESTSCR

   If (Static11 # Nil)
      Restore Screen From Static11[3]
      SetPos(Static11[1],Static11[2])
   EndIf
   Static11:= Nil
   Return Nil

Function __XSAVESCR

   Static11:= {Row(),Col(),SaveScreen(0,0,MaxRow(),MaxCol())}
   Return Nil

//Function TSTRING(xArg1)
// Return strzero(Int(mod(xArg1/3600,24)),2,0)+":"+strzero(Int(mod(xArg1/60,60)),2,0)+":"+strzero(Int(mod(xArg1,60)),2,0)

FUNCTION VAL_AX
RETURN 0

FUNCTION VAL_BX
RETURN 0


function encript(frase)
frase:=CRIPTOGRAFA(frase,"teste", .T.)
return frase

function decript(frase)
frase:=CRIPTOGRAFA(frase,"teste", .F.)
return frase


Function CRIPTOGRAFA(Pstr, Psenha, Pencript)
LOCAL Tcript, Tx, Tascii
LOCAL Tlensenha
Tlensenha = Len(AllTrim(Psenha))
Tcript = ""
For Tx = 1 To Len(Pstr)
   If Pencript   // Criptografa
      Tascii = Asc(Subs(Pstr, Tx, 1)) + ;
                             Asc(Subs(Psenha, ((Tx + 77) % Tlensenha) + 1, 1))
   Else          // DesCriptografa
      Tascii = Asc(Subs(Pstr, Tx, 1)) - ;
                             Asc(Subs(Psenha, ((Tx + 77) % Tlensenha) + 1, 1))
   EndIf
   Tcript = Tcript + Chr(Tascii)
Next
Return(Tcript)

function odometer
IF !(ntx = aGauge_alias)
 aGauge_alias:=ntx
 aGauge_count:=0
 aGauge := GaugeNew( 13, 10, 15, 60, "W/B", "W+/B" )
 GaugeDisplay( aGauge )
ENDI
//nPercent:=(aGauge_count++/lastrec())
IF (ide_maq$aGauge_alias)
 GaugeUpdate( aGauge, (aGauge_count++/lastrec()) )
ELSE
 GaugeUpdate( aGauge, (recno()/lastrec()) )
ENDI
retu .t. 

function freetslice
retu .t.

/*
 * $Id: testgaug.prg 9198 2008-08-20 09:56:47Z vszakats $
 */

/* Testing Harbour's Gauge */

/***
*
*  Gauge.prg
*
*  Sample functions to create, display, and update a percentage completed
*  progress gauge.  This function can be used for creating user interface 
*  options such as a status bar to indicate the current status of a process.
*
*  Copyright (c) 1993, Computer Associates International Inc.
*  All rights reserved.
*
*  Note: Compile with /W /N options
*
*/

// Box array definitions
#define B_LEN           9
#define B_TOP           1
#define B_LEFT          2
#define B_BOTTOM        3
#define B_RIGHT         4
#define B_BACKCOLOR     5
#define B_BARCOLOR      6
#define B_DISPLAYNUM    7
#define B_BARCHAR       8
#define B_PERCENT       9

#define B_BOXLINES      "⁄ƒø≥Ÿƒ¿≥"


/***
*  GaugeNew( <nRowTop>, <nColumnTop>, <nRowBottom>, <nColumnBottom>, 
*     [<cBackgroundColor>], 
*     [<cGaugeColor>], 
*     [<cGaugeCharacter>] ) --> aGauge
*
*  Create a new gauge array
*
*/
FUNCTION GaugeNew( nTop, nLeft, nBottom, nRight, ;
                 cBackColor, cBarColor, cBarCharacter )

   LOCAL aHandle[ B_LEN ]     // Contains info about the gauge

   // Assign default values
   aHandle[ B_TOP ]        := nTop
   aHandle[ B_LEFT ]       := nLeft
   aHandle[ B_BOTTOM ]     := nBottom
   aHandle[ B_RIGHT ]      := nRight
   aHandle[ B_BACKCOLOR ]  := "W/N"
   aHandle[ B_BARCOLOR ]   := "W+/N"
   aHandle[ B_DISPLAYNUM ] := .T.
   aHandle[ B_BARCHAR ]    := CHR( 219 )
   aHandle[ B_PERCENT ]    := 0

   // Resolve parameters
   IF cBackColor <> NIL
      aHandle[ B_BACKCOLOR ] := cBackColor
   ENDIF

   IF cBarColor <> NIL
      aHandle[ B_BARCOLOR ] := cBarColor
   ENDIF

   IF cBarCharacter <> NIL
      aHandle[ B_BARCHAR ] := cBarCharacter
   ENDIF

   // OK, the defaults are set, now let's make sure it will fit on the
   // screen correctly
   IF aHandle[ B_RIGHT ] < aHandle[ B_LEFT ] + 4
      aHandle[ B_RIGHT ] := aHandle[ B_LEFT ] + 4
   ENDIF

   IF aHandle[ B_BOTTOM ] < aHandle[ B_TOP ] + 2
      aHandle[ B_BOTTOM ] := aHandle[ B_TOP ] + 2
   ENDIF

   // Determine if we can fit the bracketed number on top of the graph
   IF aHandle[ B_RIGHT ] < aHandle[ B_LEFT ] + 9
      aHandle[ B_DISPLAYNUM ] := .F.
   ENDIF

   RETURN( aHandle )



/***
*
*  GaugeDisplay( aGauge ) --> aGauge
*
*  Display a gauge array to the screen
*
*/
FUNCTION GaugeDisplay( aHandle )
   
   LOCAL nCenter   := ROUND( (aHandle[B_RIGHT] - aHandle[B_LEFT]) / 2, 0) + 1
   LOCAL cOldColor := SETCOLOR( aHandle[ B_BACKCOLOR ] )

   @ aHandle[ B_TOP ], aHandle[ B_LEFT ] CLEAR TO ;
     aHandle[ B_BOTTOM ], aHandle[ B_RIGHT ]

   @ aHandle[ B_TOP ], aHandle[ B_LEFT ], ;
     aHandle[ B_BOTTOM ], aHandle[ B_RIGHT ] BOX B_BOXLINES

   IF aHandle[ B_DISPLAYNUM ]
    IF .T. // !(TYPE(ntx) == "U" )
      @ aHandle[ B_TOP ], aHandle[ B_LEFT ]+3 SAY "[      ] "+ntx //DbOrderinfo( DBOI_FULLPATH,,INDEXORD() )
	ELSE
      @ aHandle[ B_TOP ], aHandle[ B_LEFT ]+3 SAY "[      ] "
	ENDI
   ENDIF

   SETCOLOR( cOldColor )

   // Draw bar to show current percent
   GaugeUpdate( aHandle, aHandle[ B_PERCENT ] )

   RETURN( aHandle )



/***
*
*  GaugeUpdate( aGauge, nPercent ) --> aGauge
*
*  Updates a gauge with a new progress value and redisplays the gauge 
*  to the screen to the screen
*
*/
FUNCTION GaugeUpdate( aHandle, nPercent )
   
   LOCAL nCenter   := ROUND( (aHandle[B_RIGHT] - aHandle[B_LEFT]) / 2, 0) + 1
   LOCAL cOldColor := SETCOLOR( aHandle[ B_BARCOLOR ] )
   LOCAL nBarRatio := (aHandle[ B_RIGHT ]) - (aHandle[ B_LEFT ] + 1)
   LOCAL nRow      := 0
   LOCAL nCols     := 0

   IF aHandle[ B_DISPLAYNUM ]
      @ aHandle[ B_TOP ], aHandle[ B_LEFT ]+5 SAY STR( nPercent * 100, 3 ) + "%"
   ENDIF

   IF nPercent > 1
      nPercent := 1
   ENDIF

   IF nPercent < 0
      nPercent := 0
   ENDIF

   nCols := ROUND( nPercent * nBarRatio, 0 )

   //@ aHandle[ B_TOP ] + 1, aHandle[ B_LEFT ] + 1 CLEAR TO ;
   //  aHandle[ B_BOTTOM ] - 1, aHandle[ B_RIGHT ] - 1

   FOR nRow := 1 TO (aHandle[ B_BOTTOM ] - aHandle[ B_TOP ] - 1)
      @ nRow + aHandle[ B_TOP ], aHandle[ B_LEFT ] + 1 SAY ;
        REPLICATE( aHandle[ B_BARCHAR ], nCols )
   NEXT

   SETCOLOR( cOldColor )

   RETURN( aHandle )



