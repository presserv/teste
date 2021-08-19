procedure emc_01f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: EMC_01F9.PRG
 \ Data....: 20-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Lan‡amento em TAXAS->valorpg, gerado por EMCARNE
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas
LOCAL vljoiaux:=0
IF arredondar=[N]
 vljoiaux:=TCARNES->vali/TCARNES->parf
ELSE
 IF nparc=1
  vljoiaux:= TCARNES->vali-(INT(TCARNES->vali/TCARNES->parf*10)/10)*(TCARNES->parf-1)
 ELSE
  vljoiaux:= INT(TCARNES->vali/TCARNES->parf*10)/10
 ENDIF
ENDIF
RETU vljoiaux       // <- deve retornar um valor NUMRICO

* \\ Final de EMC_01F9.PRG

