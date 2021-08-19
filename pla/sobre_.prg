procedure sobre_
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: ABOUT.PRG
 \ Data....: 09-09-96
 \ Sistema.: Controle de Convˆnios
 \ Funcao..: Rotina avulsa (Sobre...)
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analistad
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

/*
   Nivelop = Nivel de acesso do usuario (1=operacao, 2=manutencao e
   3=gerencia)
*/
IF nivelop < 1          // se usuario nao tem
 ALERTA()               // permissao, avisa
 DBOX(msg_auto,,,3)     // e retorna
 RETU
ENDI
PARA  lin_menu, col_menu
PRIV  tem_borda:=.f., op_menu:=VAR_COMPL, l_s:=3, c_s:=14, l_i:=21, c_i:=60, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
nucop=1
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+02,c_s+1 SAY "         Sistema Funer rio VIP"
@ l_s+03,c_s+1 SAY "ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ"
@ l_s+04,c_s+1 SAY "    Gerenciador de Administradora PLANO"
@ l_s+05,c_s+1 SAY "    ADPBIG.EXE - Vers„o VIP 4.7 - 06/98"
@ l_s+11,c_s+1 SAY "         Desenvolvido e Mantido por:"
@ l_s+12,c_s+1 SAY "            PresServ Inform tica"
@ l_s+13,c_s+1 SAY "       (019) 452.6623 - Limeira, S.P."
@ l_s+14,c_s+1 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
@ l_s+15,c_s+1 SAY " Mem¢rias: (" + ALLTRIM(STR(MEMORY(0)))+" Char, "+;
                                   ALLTRIM(STR(MEMORY(1)))+" Block, "+;
                                   ALLTRIM(STR(MEMORY(2)))+" Run) "
@ l_s+18,c_s+1 SAY " Operador: " + M->usuario
INKEY(25)
RETU

* \\ Final de ABOUT.PRG
