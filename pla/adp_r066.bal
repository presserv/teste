/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Ind£stria de Urnas Bignotto Ltda
 \ Programa: ADP_RF87.PRG
 \ Data....: 01-03-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Emiss„o Unibanco
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "ADPbig.ch"    // inicializa constantes manifestas
PARA  lin_menu, col_menu, imp_reg, mcodaux
IF PCOU()=4
 ADP_R087(lin_menu, col_menu, imp_reg, mcodaux)
ELSEIF PCOU()=3
 ADP_R087(lin_menu, col_menu, imp_reg)
ELSE
 ADP_R087(lin_menu, col_menu)
ENDI
RETU
