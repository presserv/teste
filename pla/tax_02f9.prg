procedure tax_02f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: TAX_02F9.PRG
 \ Data....: 22-11-96
 \ Sistema.: Administradora - PLANO
 \ Funcao..: F¢rmula (Status) a mostrar na tela de TAXAS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

DO CASE
 CASE TAXAS->stat = [1]
  RETU [Gerada  ]
 CASE TAXAS->stat = [2]
  RETU [Impressa]
 CASE TAXAS->stat $ [3,E]
  RETU [Enviada ]
 CASE TAXAS->stat $ [4,R]
  RETU [Rejeitad]
 CASE TAXAS->stat $ [5,A]
  RETU [Aceita  ]
 CASE TAXAS->stat = [6]
  RETU IIF(EMPT(por),[BxRecep‡],por)
 CASE TAXAS->stat = [7]
  RETU IIF(EMPT(por),[BxBanco ],por)
 CASE TAXAS->stat = [8]
  RETU IIF(EMPT(por),[Bx FCC  ],por)
 CASE TAXAS->stat = [9]
  RETU IIF(EMPT(por),[Bx Plano],por)
 OTHERWISE
  RETU IIF(valorpg>0,por,[Pendente])
ENDC
RETU [        ]       // <- deve retornar um valor qualquer

* \\ Final de TAX_02F9.PRG
