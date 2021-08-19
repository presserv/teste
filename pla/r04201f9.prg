procedure r04201f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R04201F9.PRG
 \ Data....: 22-06-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: qualif do relat¢rio ADM_R042
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

DO CASE
CASE INSCRITS->grau = [1]
 RETU [Titular]
CASE INSCRITS->grau = [2]
 RETU [Pai]
CASE INSCRITS->grau = [3]
 RETU [Mae]
CASE INSCRITS->grau = [4]
 RETU [Sogro]
CASE INSCRITS->grau = [5]
 RETU [Sogra]
CASE INSCRITS->grau = [6]
 RETU [Conjuge]
CASE INSCRITS->grau = [7]
 RETU [Filho]
CASE INSCRITS->grau = [8]
 RETU [Depend.]
ENDC
RETU []    // <- deve retornar um valor qualquer

* \\ Final de R04201F9.PRG
