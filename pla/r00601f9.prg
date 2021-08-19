procedure r00601f9
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica-Limeira (019)452.6623
 \ Programa: R00601F9.PRG
 \ Data....: 14-12-95
 \ Sistema.: Administradora de Funer rias
 \ Funcao..: Processo direto no campo particv, arquivo GRUPOS
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas

   #ifdef COM_REDE
    IF PTAB(M->rgrupo+M->rcodigo,'GRUPOS',1)
     REPBLO('GRUPOS->situacao',[1])
     REPBLO('GRUPOS->admissao',admissao)
     REPBLO('GRUPOS->saitxa',saitxa)
     REPBLO('GRUPOS->cobrador',cobrador)
     REPBLO('GRUPOS->funerais',funerais)
     REPBLO('GRUPOS->vlcarne',vlcarne)
     REPBLO('GRUPOS->circinic',circinic)
     REPBLO('GRUPOS->ultcirc',ultcirc)
     REPBLO('GRUPOS->regiao',regiao)
     REPBLO('GRUPOS->qtcircs',qtcircs)
     REPBLO('GRUPOS->titular',titular)
     REPBLO('GRUPOS->nome',nome)
     REPBLO('GRUPOS->endereco',endereco)
     REPBLO('GRUPOS->bairro',bairro)
     REPBLO('GRUPOS->cidade',cidade)
     REPBLO('GRUPOS->cep',cep)
     REPBLO('GRUPOS->particv',0)
     REPBLO('GRUPOS->particf',particf)
    ENDI
   #else
    IF PTAB(M->rgrupo+M->rcodigo,'GRUPOS',1)
     REPL GRUPOS->situacao WITH [1]
     REPL GRUPOS->admissao WITH admissao
     REPL GRUPOS->saitxa WITH saitxa
     REPL GRUPOS->cobrador WITH cobrador
     REPL GRUPOS->funerais WITH funerais
     REPL GRUPOS->vlcarne WITH vlcarne
     REPL GRUPOS->circinic WITH circinic
     REPL GRUPOS->ultcirc WITH ultcirc
     REPL GRUPOS->regiao WITH regiao
     REPL GRUPOS->qtcircs WITH qtcircs
     REPL GRUPOS->titular WITH titular
     REPL GRUPOS->nome WITH nome
     REPL GRUPOS->endereco WITH endereco
     REPL GRUPOS->bairro WITH bairro
     REPL GRUPOS->cidade WITH cidade
     REPL GRUPOS->cep WITH cep
     REPL GRUPOS->particv WITH 0
     REPL GRUPOS->particf WITH particf
    ENDI
   #endi


RETU 0   // <- deve retornar um valor CARACTER

* \\ Final de R00601F9.PRG
