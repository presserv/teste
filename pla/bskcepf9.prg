procedure bskcepf9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: BSKCEPF9.PRG
 \ Data....: 14-11-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Fun‡„o F8 do campo CIDADE, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
#include "MACHSIX.CH"
PARA _endereco, _bairro, _cidade, PCOUNTX
LOCAL reg_dbf:=POINTER_DBF()
LOCAL cSearch := []
//PCOUNTX:=PCOUNT()
pponto:=AT([.],_endereco)
if pponto>0
 _endereco:=SUBSTR(_endereco,pponto+1)
endi
pvirgu:=AT([,],_endereco)
if pvirgu>0
 _endereco:=LEFT(_endereco,pvirgu-1)
endi
aux_:=[]
IF !EMPT(_endereco) //PCOUNTX>0
// cSearch:=["]+ALLTRIM(_endereco)+["$nome_log]
 cSearch:=[nome_log="]+ALLTRIM(_endereco)+["]
ENDI
/*
IF !EMPT(_bairro) //PCOUNTX>1
 cSearch+=[.AND."]+ALLTRIM(_bairro)+["$bairro_1]
ENDI
*/
IF !EMPT(_cidade) //PCOUNTX>2
// cSearch+=[.AND."]+ALLTRIM(_cidade)+["$local_log]
 cSearch+=[.AND.local_log="]+ALLTRIM(_cidade)+["]
ENDI
PTAB([],[CEP])

SELE CEP
set filter to &cSearch
//................................................get level of optimization
nOpti := m6_IsFilter()
/*
do case
case nOpti == OPT_NONE
   cRank := "None"
case nOpti == OPT_FULL
   cRank := "Full"
case nOpti == OPT_PARTIAL
   cRank := "Part"
endcase
dbox(cRank)
*/
M->aux_:=VDBF(6,3,20,77,'CEP',{'nome_log','bairro_1','local_log','cep8_log'},1,'rbskcep(PCOUNTX)')
IF !EMPT(M->aux_)
 inkey()
 keyboard CHR(01)+ALLTRIM(M->aux_)
ENDI
POINTER_DBF(reg_dbf)

RETU [] //M->aux_      // <- deve retornar um valor qualquer

FUNC rbskcep
PARA PCOUNTX
IF PCOUNTX=1
 M->endereco:=PADR(ALLTRIM(tipo_log)+[.]+ALLTRIM(nome_log)+[,],35)
 M->bairro:=LEFT(bairro_1,20)
 M->cidade:=LEFT(local_log,25)
 M->uf:=uf_log
 M->cep:=cep8_log
 RETU M->endereco
ENDI
IF PCOUNTX=2
 M->bairro:=LEFT(bairro_1,20)
 M->cidade:=LEFT(local_log,25)
 M->uf:=uf_log
 M->cep:=cep8_log
 retu m->bairro
ENDI
IF PCOUNTX=3
 M->cidade:=LEFT(local_log,25)
 M->uf:=uf_log
 M->cep:=cep8_log
 retu m->cidade
ENDI
RETU cep8_log

* \\ Final de BSKCEPF9.PRG
