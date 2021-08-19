procedure v87001f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: V87001F9.PRG
 \ Data....: 21-09-97
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Valida‡„o da variavel CONFIRME, relatorio ADM_R038
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

// Preparados em R08701F9()
PUBL vlaux:=0,vlout:=0,vlseg:=valororig:=0  // Composi‡„o do valor
PUBL lindeb:=[]  // Linha resumo dos d‚bitos (Tipo+circ ...)
publ detdeb[10] // Detalhamento dos d‚bitos tipo+circ+vencto+valor...
afill(detdeb,[])

// Preparados em R08703F9()
PUBL ultprc:=[]  // Ultima cartinha montada, se for igual n„o refaz...
publ detprc[10] // Cartinha dos falecidos
afill(detprc,[])
publ contar:=.t., contx :=0

// Custos adicionais
PUBL vlcst:=0
publ detcst[10]
afill(detcst,[])

RETU .t.       // <- deve retornar um valor L¢GICO

* \\ Final de V87001F9.PRG
