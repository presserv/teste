procedure r08701f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R08701F9.PRG
 \ Data....: 17-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Express„o de filtro do relat¢rio ADP_R087.PRG
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
donex:=.t. //V87001F9()
nrdonex=0
DO CASE
CASE valorpg>0 // J  paga, tchau!!!
 nrdonex=1
 donex:=.f.
CASE !(tipo=M->rtp) //N„o ‚ meu tipo!!!
 nrdonex=2
 donex:=.f.
CASE (stat>[1].AND.!(M->rreimp=[S])) // Ja foi impressa.
 nrdonex=3
 donex:=.f.
CASE !EMPT(M->rgrupo).AND.!(GRUPOS->grupo=M->rgrupo)// Quero s¢ o grupo!!
 nrdonex=4
 donex:=.f.
CASE !(GRUPOS->situacao=[1]) //Contrato esta cancelado...
 nrdonex=5
 donex:=.f.
CASE VAL(M->rproxcirc)>0.AND.(TAXAS->circ<M->rproxcirc)//Circular menor
 nrdonex=6
 donex:=.f.
CASE VAL(M->rultcirc)>0.AND.(TAXAS->circ>M->rultcirc)//Circular maior
 nrdonex=7
 donex:=.f.
CASE VAL(M->rcod1)>0.AND.TAXAS->codigo<M->rcod1
 nrdonex=8
 donex:=.f.
CASE VAL(M->rcod2)>0.AND.TAXAS->codigo>M->rcod2
 nrdonex=9
 donex:=.f.
CASE TAXAS->emissao_< M->rem1_.OR.TAXAS->emissao_>M->rem2_
 nrdonex=10
 donex:=.f.
OTHERWISE
 donex:=.t.
ENDCASE

RETU  M->donex     // <- deve retornar um valor L¢GICO

* \\ Final de R08701F9.PRG
