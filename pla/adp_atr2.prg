procedure adp_atr2
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform�tica - Limeira (019)452.6623
 \ Programa: ADP_ATR2.PRG
 \ Data....: 24-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas


sistema[24]={;
            "Processos da Circular",;                       // opcao do menu
            "Processos da Circular",;                       // titulo do sistema
            {"grupo+circ+processo","DTOS(dfal)","grupo+circ+DTOS(dfal)"},;// chaves do arquivo
            {"Grupo/Circular","p/Data","Grupo e Data"},;    // titulo dos indices para consulta
            {"010203","09","010209"},;                      // ordem campos chaves
            "CPRCIRC",;                                     // nome do DBF
            {"CPRCIRC1","CPRCIRC2","CPRCIRC3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"CIRCULAR->grupo","CIRCULAR->circ"},;          // campos de relacionamento
            {1,1,8,4,15,76,3,4},;                           // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(processo)~Necess�rio informar PROCESSO",;
     /* help do campo */    "Informe o n�mero do processo a incluir";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "!!",;
     /* titulo        */    "Categoria",;
     /* cmd especial  */    "MTAB([PL=Plano|PD=Plano c/Diferen�a|AF=Auxilio],[CATEGORIA])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "categ $ [PL|PD|AF]~CATEGORIA n�o aceit�vel",;
     /* help do campo */    "Preencha com:|PL para Plano,| PD p/Diferen�a ou |AX para Aux.Funeral";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "999999",;
     /* titulo        */    "Num",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(num).AND.PTAB(num,'GRUPOS',1)~NUM n�o existe na tabela",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@!",;
     /* titulo        */    "Fal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fal)~Necess�rio informar FAL",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@!",;
     /* titulo        */    "Ends",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@!",;
     /* titulo        */    "Cids",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(dfal)~Necess�rio informar DATA",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_CAMPO],{;            // CPRCIRC
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[24,O_FORMULA],{;          // CPRCIRC - Nome
     /* form mostrar  */    "LEFT(TRAN(INSCRITS->nome,[]),35)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    0;
                         };
)


sistema[25]={;
            "Funcion�rios",;                                // opcao do menu
            "Funcion�rios",;                                // titulo do sistema
            {"codigo"},;                                    // chaves do arquivo
            {"N�mero"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "FNCS",;                                        // nome do DBF
            {"FNCS1"},;                                     // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,8,15,73},;                               // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "",;
     /* titulo        */    "C�digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codigo)~Necess�rio informar C�DIGO",;
     /* help do campo */    "Informe um c�digo para o funcion�rio";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome do funcion�rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess�rio informar NOME DO FUNCION�RIO",;
     /* help do campo */    "Entre com o nome do funcion�rio autorizado a|assinar a declara��o de �bito no|Cart�rio de Registro C�vil";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Profiss�o",;
     /* cmd especial  */    "MTAB([ATENDENTE|COBRADOR|MOTORISTA|VENDEDOR],[PROFISS�O])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(profiss)~�sta informa��o � necess�rio para a Declara��o de �bito",;
     /* help do campo */    "Entre com a profiss�o do funcion�rio.";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Nacionalidade",;
     /* cmd especial  */    "",;
     /* default       */    "[BRASILEIRO]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nacional)~Necess�rio informar NACIONALIDADE",;
     /* help do campo */    "Entre com a nacionalidade";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "!!",;
     /* titulo        */    "Est.Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST.CIVIL])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "estciv $ tbestciv~EST.CIVIL n�o aceit�vel.|Tecle F8 para busca em tabela",;
     /* help do campo */    "Entre com o estado civil ou tecle F8";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@D",;
     /* titulo        */    "Idade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data de nascimento";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Endere�o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Este dado ser� utilizado na Declara��o de �bito",;
     /* help do campo */    "Informe o endere�o do funcion�rio";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com o bairro";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess�rio informar CIDADE",;
     /* help do campo */    "Entre com o nome do munic�pio";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf) .OR. EMPT(cpf)~CPF n�o aceit�vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "999.9",;
     /* titulo        */    "Percentual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "!(percent<0).AND.!(percent>100)~PERCENTUAL n�o aceit�vel",;
     /* help do campo */    "Informe o percentual de comiss�o|caso o vendedor n�o receba por n�mero de parcelas";
                         };
)
AADD(sistema[25,O_CAMPO],{;            // FNCS
     /* mascara       */    "@S35",;
     /* titulo        */    "Observa��o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[25,O_FORMULA],{;          // FNCS - estado civil
     /* form mostrar  */    "LEFT(TRAN(SUBS(tbestciv,AT(estciv,tbestciv),11),[]),15)",;
     /* lin da formula*/    3,;
     /* col da formula*/    15;
                         };
)


sistema[26]={;
            "Par�metro de Juros",;                          // opcao do menu
            "Par�metro de Juros",;                          // titulo do sistema
            {"tipo"},;                                      // chaves do arquivo
            {"Tipo"},;                                      // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "JUROS",;                                       // nome do DBF
            {"JUROS1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,17,17,66,4,5},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {3,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[26,O_CAMPO],{;            // JUROS
     /* mascara       */    "9",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J�ia |2=Taxa |3=Carn�|4=Acerto],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tipo)~TIPO n�o aceit�vel|Deve ser n�mero positivo",;
     /* help do campo */    "Qual o tipo de lan�amento";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // JUROS
     /* mascara       */    "99.99",;
     /* titulo        */    "Multa %",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "multa>=0~MULTA % n�o aceit�vel",;
     /* help do campo */    "Informe a porcentagem de multa";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // JUROS
     /* mascara       */    "999",;
     /* titulo        */    "Car�ncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "mltcaren>=0~CARENCIA n�o aceit�vel",;
     /* help do campo */    "Informe a car�ncia para a |aplica��o da multa|em dias.";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // JUROS
     /* mascara       */    "99.999",;
     /* titulo        */    "Juros %",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "juros>=0~JUROS % n�o aceit�vel|deve ser maior ou igual a zeros|(Juros Mensais)",;
     /* help do campo */    "Informe a porcentagem do Juros mensais";
                         };
)
AADD(sistema[26,O_CAMPO],{;            // JUROS
     /* mascara       */    "999",;
     /* titulo        */    "Car�ncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "jrscaren>=0~CARENCIA n�o aceit�vel|deve ser maior ou igual a zeros",;
     /* help do campo */    "Informe a car�ncia para a |aplica��o do juros|em dias.";
                         };
)


sistema[27]={;
            "Hist�rico Padr�o",;                            // opcao do menu
            "Hist�rico Padr�o",;                            // titulo do sistema
            {"historico","codigo","codlan"},;               // chaves do arquivo
            {"Por C�digo","C�digo Estruturado","Cod.Lanc"},;// titulo dos indices para consulta
            {"01","06","08"},;                              // ordem campos chaves
            "HISTORIC",;                                    // nome do DBF
            {"HISTORI1","HISTORI2","HISTORI3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,4,21,77,3,10},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"origem=[ADM]","Registro utilizado por outro Sistema"},;// condicao de exclusao de registros
            {"origem=[ADM]","Registro mantido por outro sistema"},;// condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "999",;
     /* titulo        */    "Hist",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(HISTORICO)~Este � um campo de preenchimento obrigat�rio.",;
     /* help do campo */    "Entre com um c�digo para identificar| este hist�rico.";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "",;
     /* titulo        */    "Descri��o de Hist�rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "!EMPTY(historico)",;
     /* validacao     */    "!EMPT(DESCRICAO)~Informe uma DESCRI��O para este c�digo.",;
     /* help do campo */    "Entre com a identifica�ao do Hist�rico.|Ex.:Cheque, Dep�sito, Pgto de Duplic., etc...";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!",;
     /* titulo        */    "D/C",;
     /* cmd especial  */    "MTAB('D�bito|Cr�dito',[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "!EMPTY(historico)",;
     /* validacao     */    "EMPTY(TIPO).OR.tipo$[DC]~� necess�rio informar se TIPO � D�bito ou Cr�dito.|D p/Pagamentos e C para recebimentos.",;
     /* help do campo */    "Este hist�rico � um D�bito ou Cr�dito|Se for D�b., reduzir� no saldo da conta de|lan�amento e acrescido na de baixa.";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!!!",;
     /* titulo        */    "C/C",;
     /* cmd especial  */    "MTAB([ADMinistradora|FUNer�ria|CONvenio|ESToque|FINanceiro|VIAtura],[ORIGEM])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o prefixo do sistema que|gerou o lan�amento|O Centro de Custo";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!",;
     /* titulo        */    "R/D",;
     /* cmd especial  */    "MTAB([Receita|Despesa|Transfer�ncia],[R/D])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "recdesp $ [RDT]~Receita/Despesa n�o aceit�vel",;
     /* help do campo */    "� Receita ou Despesa";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "@!",;
     /* titulo        */    "C�digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o c�digo estruturado|para os lan�amentos com |este hist�rico.";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan�amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[27,O_CAMPO],{;            // HISTORIC
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan�amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[28]={;
            "Contratos Cancelados",;                        // opcao do menu
            "Contratos Cancelados",;                        // titulo do sistema
            {"numero","codigo","nome"},;                    // chaves do arquivo
            {"p/Numero","p/Contrato","Nome"},;              // titulo dos indices para consulta
            {"01","02","13"},;                              // ordem campos chaves
            "CGRUPOS",;                                     // nome do DBF
            {"CGRUPOS1","CGRUPOS2","CGRUPOS3"},;            // nomes dos NTX
            {"COECOB","CINSCRIT","CTAXAS"},;                // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,3,22,77},;                               // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop=3","Contrato Cancelado"},;                  // condicao de exclusao de registros
	    {"nivelop=3","Contrato Cancelado!!!"},;               // condicao de alteracao de registros
            {"nivelop=3","Contrato Cancelado"};                   // condicao de recupercao de registros
           }

AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999999",;
     /* titulo        */    "N�mero",;
     /* cmd especial  */    "CGR_02F9()",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(numero)~Necess�rio informar N�MERO",;
     /* help do campo */    "Informe o n�mero do cancelamento";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB('',[ARQGRUP],1).AND.GRU_01F9()~CODIGO n�o aceit�vel|N�o cadastrado na tabela de grupos",;
     /* help do campo */    "Entre com o n�mero do contrato";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "Grupo";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Motivo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([Falta pgto|Mudou|Ignorado|Desist�ncia],[MOTIVO])",;
     /* validacao     */    "!EMPT(motivo)~Necess�rio informar MOTIVO",;
     /* help do campo */    "Motivo do cancelamento|Tecle ESC para digitar";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Canclto_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "Data do Cancelamento";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cancpor)~Necess�rio informar Nome de quem cancelou",;
     /* help do campo */    "Nome do Usuario";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999999",;
     /* titulo        */    "N�mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "Numero da reintegracao";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Motreint",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "Motivo da reintegracao";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Reintem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "Data da reintegracao";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Reintpor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "Usuario que reintegrou";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@R !!/999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "Novo numero de contrato";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "9",;
     /* titulo        */    "Situa��o",;
     /* cmd especial  */    "MTAB([1=Ativo|2=Cancelado],[SITUA��O])",;
     /* default       */    "[1]",;
     /* pre-validacao */    "",;
     /* validacao     */    "situacao $ [12]~SITUA��O n�o aceit�vel",;
     /* help do campo */    "Digite 1 para ativo ou 2 para cancelado";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess�rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Nascto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de nascimento do titular";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "Est Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST CIVIL])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(estcivil$tbestciv)~Informe Estado Civil|ou|Tecle F8 para consulta em tabela",;
     /* help do campo */    "Digite o Estado Civil do Titular";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).OR.EMPT(cpf)~CPF n�o aceit�vel",;
     /* help do campo */    "Informe o CIC (CPF) do titular";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "R.G.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n�mero do documento do titular";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Endere�o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Necess�rio informar ENDERE�O do Titular",;
     /* help do campo */    "Informe o Endere�o para correspond�ncias.|Rua,n�mero,apto, blocl, etc...";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bairro)~Necess�rio informar BAIRRO do Titular",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess�rio informar MUNICIPIO para cobran�a do Titular.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR.EMPT(UF)~UNIDADE DA FEDERA��O inv�lida",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess�rio informar CEP do Titular |com 08 digitos",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n�mero de telefone para|Contato com o contratante";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "TipCont",;
     /* cmd especial  */    "VDBF(6,13,20,77,'CLASSES',('classcod','descricao','vljoia'),1,'classcod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(tipcont,'CLASSES',1)~Informe a Classe deste contrato",;
     /* help do campo */    "Qual a categoria do Contrato?|Tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Vlcarne",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "FormaPgto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a forma de pagamento desejada";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Seguro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Admiss�o",;
     /* cmd especial  */    "DATE()",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(admissao)~Necess�rio informar DATA DE ADMISS�O",;
     /* help do campo */    "Informe a data da Admiss�o neste contrato";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "T.Car�ncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Saitxa",;
     /* cmd especial  */    "",;
     /* default       */    "SUBSTR(DTOC(admissao+120),4,2)+RIGHT(DTOC(admissao+120),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(saitxa).AND.MMAA(saitxa) .or.nivelop==3~Necess�rio informar SAITXA (MM/AA)",;
     /* help do campo */    "Informe o M�s a sair a 1� Taxa.";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "!!!",;
     /* titulo        */    "Vendedor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(vendedor,'COBRADOR',1).OR.EMPT(vendedor)~VENDEDOR n�o existe na tabela",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Regi�o",;
     /* cmd especial  */    "VDBF(6,38,20,77,'REGIAO',{'codigo','regiao'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(regiao,'REGIAO',1).OR.EMPT(regiao)~REGI�O n�o existe na tabela",;
     /* help do campo */    "Informe a regi�o ou tecle F8 para busca em tabela";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,39,20,77,'REGIAO',{'regiao','cobrador'},2,'cobrador',[!EMPT(cobrador)])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1)~COBRADOR n�o existe na tabela",;
     /* help do campo */    "Digite o c�digo do COBRADOR que|receber� as Taxas deste contrato,|Tecle F8 para consultar os cobradores.";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Renovar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Data final para renova��o";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Funerais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(funerais<0)~FUNERAIS n�o aceit�vel",;
     /* help do campo */    "N�mero de Funerais efetuados|para este processo";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Circ.Inicial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "circinic <=ARQGRUP->ultcirc .or. nivelop==3~CIRC.INICIAL maior que a �ltima|emitida para este Grupo.",;
     /* help do campo */    "Informe o n�mero da 1� Circular|que saiu para este contrato.";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Ult.Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(IIF(CLASSES->prior=[S],M->mgrupvip,grupo)+ultcirc,'CIRCULAR',1).OR.ultcirc=[000].or.nivelop==3~Necess�rio informar ULT.CIRCULAR",;
     /* help do campo */    "Entre com o �ltimo n�mero de circular|deste contrato.";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Qt.Circulares",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Circulares|emitidas para este contrato.";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Circ.Pagas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Circulares|pagas/retornadas deste contrato";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Titular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Part.Vivos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Part.Falecidos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "N� Depend.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Ult.Impress.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "�lt.alter.endere�o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // CGRUPOS
     /* mascara       */    "",;
     /* titulo        */    "UltEnd",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@K!",;
     /* titulo        */    "Naturalidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Relig",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Situacao
     /* form mostrar  */    "LEFT(TRAN(IIF(situacao=[2],[CANCELADO],[         ]),[]),09)",;
     /* lin da formula*/    6,;
     /* col da formula*/    62;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Part.Vivos
     /* form mostrar  */    "LEFT(TRAN(particv,[99]),02)",;
     /* lin da formula*/    19,;
     /* col da formula*/    24;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Part.Falecidos
     /* form mostrar  */    "LEFT(TRAN(particf,[99]),02)",;
     /* lin da formula*/    19,;
     /* col da formula*/    38;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Nome do Cobrado
     /* form mostrar  */    "LEFT(TRAN(COBRADOR->nome,[]),30)",;
     /* lin da formula*/    17,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - grupo
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(grupo),grupo,[  ]),[]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    39;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Descri��o Reg
     /* form mostrar  */    "LEFT(TRAN(REGIAO->regiao,[]),30)",;
     /* lin da formula*/    16,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Est.Civil
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(estcivil),SUBS(tbestciv,AT(estcivil,tbestciv),11),[]),[]),11)",;
     /* lin da formula*/    9,;
     /* col da formula*/    13;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - N� Depend.
     /* form mostrar  */    "LEFT(TRAN(nrdepend,[99]),02)",;
     /* lin da formula*/    19,;
     /* col da formula*/    54;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Ult.Impress.
     /* form mostrar  */    "LEFT(TRAN(ultimp_,[@D]),10)",;
     /* lin da formula*/    12,;
     /* col da formula*/    62;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - �lt.alter.ender
     /* form mostrar  */    "LEFT(TRAN(ender_,[@D]),10)",;
     /* lin da formula*/    11,;
     /* col da formula*/    50;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - UltEnd
     /* form mostrar  */    "LEFT(TRAN(ultend,[]),10)",;
     /* lin da formula*/    11,;
     /* col da formula*/    62;
                         };
)
AADD(sistema[28,O_FORMULA],{;          // CGRUPOS - Seguro
     /* form mostrar  */    "LEFT(TRAN(IIF(seguro>0,'SEGURO ('+str(seguro,2)+')',[   ]),[]),12)",;
     /* lin da formula*/    6,;
     /* col da formula*/    29;
                         };
)


sistema[29]={;
            "Outros Endere�os",;                            // opcao do menu
            "Outros Endere�os",;                            // titulo do sistema
            {"numero+tipo"},;                               // chaves do arquivo
            {"Contrato"},;                                  // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "COECOB",;                                      // nome do DBF
            {"COECOB1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"CGRUPOS->numero"},;                           // campos de relacionamento
            {1,1,8,17,16,65},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "999999",;
     /* titulo        */    "N�mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([Resid�ncia|Trabalho|Outro],[TIPO])",;
     /* default       */    "[R]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [RTO]~TIPO n�o aceit�vel|Apenas endere�os de Resid�ncia e Trabalho.",;
     /* help do campo */    "Informe que tipo de Endere�o � este.|R=Resid�ncia, T=Trabalho";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Endere�o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Informe a localiza��o ou tecle ESC para cancelar",;
     /* help do campo */    "Informe o Endere�o|Rua,n�mero,apto, blocl, etc...";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bairro)~Necess�rio informar BAIRRO do Titular",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess�rio informar CEP do Titular.|(08 digitos)",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess�rio informar MUNICIPIO para cobran�a do Titular.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR. EMPT(uf)~UNIDADE DA FEDERA��O inv�lida",;
     /* help do campo */    "Informe o Estado.|Ex.: SP,RJ,GO,AM,...";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(telefone)~Necess�rio informar TELEFONE",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_CAMPO],{;            // COECOB
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[29,O_FORMULA],{;          // COECOB - Tipo
     /* form mostrar  */    "LEFT(TRAN(IIF(tipo=[R],[Resid�ncia],IIF(tipo=[T],[Trabalho],[Outro])),[]),12)",;
     /* lin da formula*/    1,;
     /* col da formula*/    15;
                         };
)


sistema[30]={;
            "Inscritos Cancelados",;                        // opcao do menu
            "Inscritos Cancelados",;                        // titulo do sistema
            {"numero+grau+STR(seq,02,00)","nome"},;         // chaves do arquivo
            {"Contrato","p/Nome"},;                         // titulo dos indices para consulta
            {"010304","06"},;                               // ordem campos chaves
            "CINSCRIT",;                                    // nome do DBF
            {"CINSCRI1","CINSCRI2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"CGRUPOS->numero"},;                           // campos de relacionamento
            {1,1,17,3,23,77},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Contrato Cancelado"},;                  // condicao de exclusao de registros
            {"1=3","Contrato Cancelado!!!"},;               // condicao de alteracao de registros
            {"1=3","Contrato Cancelado"};                   // condicao de recupercao de registros
           }

AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "999999",;
     /* titulo        */    "N�mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* default       */    "IIF(M->pgrau<[7],SUBSTR([234567],VAL(M->pgrau),1),M->pgrau)",;
     /* pre-validacao */    "",;
     /* validacao     */    "grau $ [12345678]~INSCR. n�o aceit�vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "INS_01F9()",;
     /* pre-validacao */    "grau>[6]",;
     /* validacao     */    "seq>0~SEQ n�o aceit�vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "!",;
     /* titulo        */    "Titular?",;
     /* cmd especial  */    "MTAB([Sim|N�o],[TITULAR?])",;
     /* default       */    "IIF(EMPT(GRUPOS->titular),[S],[N])",;
     /* pre-validacao */    "",;
     /* validacao     */    "ehtitular$[SN]~Digite S ou N...",;
     /* help do campo */    "Informe se � este inscrito o titular do contrato.";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess�rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "@D",;
     /* titulo        */    "Nascto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Data de Nascimento deste Inscrito";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "",;
     /* titulo        */    "Est Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST CIVIL])",;
     /* default       */    "IIF(grau<[7],[CA],[SO])",;
     /* pre-validacao */    "",;
     /* validacao     */    "(ESTCIVIL$tbestciv)~Necess�rio informar ESTADO CIVIL|ou tecle F8",;
     /* help do campo */    "Digite o Estado Civil do Falecido";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "!",;
     /* titulo        */    "Interdito",;
     /* cmd especial  */    "MTAB([Sim|N�o],[INTERDITO])",;
     /* default       */    "[N]",;
     /* pre-validacao */    "",;
     /* validacao     */    "interdito $ [SN]~INTERDITO n�o aceit�vel",;
     /* help do campo */    "Digite S se for interdiro (deficiente mental).";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "!",;
     /* titulo        */    "Sexo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "@D",;
     /* titulo        */    "T.Car�ncia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "@D",;
     /* titulo        */    "Lan�to.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "!",;
     /* titulo        */    "V/F",;
     /* cmd especial  */    "MTAB([Vivo|Falecido],[V/F])",;
     /* default       */    "[V]",;
     /* pre-validacao */    "",;
     /* validacao     */    "vivofalec$[VF]~Necess�rio informar VIVOFALEC",;
     /* help do campo */    "Vivo ou Falecido";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "@D",;
     /* titulo        */    "Falecto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data de falecimento";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "!!!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([Funeral|Auxilio],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "EMPTY(tipo).OR.UPPER(tipo) $ [FUN|AUX]~Necess�rio informar TIPO",;
     /* help do campo */    "Com Direitos (Funeral) ou com Auxilio.";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "@R 99999/99",;
     /* titulo        */    "N�Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n�mero do processo";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_CAMPO],{;            // CINSCRIT
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[30,O_FORMULA],{;          // CINSCRIT - graupart
     /* form mostrar  */    "LEFT(TRAN(SUBSTR([TitPaiMaeSgoSgaEspFilDep],(VAL(grau)-1)*3+1,3),[]),03)",;
     /* lin da formula*/    1,;
     /* col da formula*/    19;
                         };
)
AADD(sistema[30,O_FORMULA],{;          // CINSCRIT - Lan�to.
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    51;
                         };
)
AADD(sistema[30,O_FORMULA],{;          // CINSCRIT - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    60;
                         };
)
AADD(sistema[30,O_FORMULA],{;          // CINSCRIT - Codigo
     /* form mostrar  */    "LEFT(TRAN(codigo,[999999]),06)",;
     /* lin da formula*/    1,;
     /* col da formula*/    2;
                         };
)


sistema[31]={;
            "Taxas Canceladas",;                            // opcao do menu
            "Taxas Canceladas",;                            // titulo do sistema
            {"numero+tipo+circ","tipo+circ"},;              // chaves do arquivo
            {"Contrato/Circular","Tipo de taxa"},;          // titulo dos indices para consulta
            {"010304","0304"},;                             // ordem campos chaves
            "CTAXAS",;                                      // nome do DBF
            {"CTAXAS1","CTAXAS2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"CGRUPOS->numero"},;                           // campos de relacionamento
            {1,1,13,2,23,78,3,7},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Contrato Cancelado"},;                  // condicao de exclusao de registros
            {"1=3","Contrato Cancelado"},;                  // condicao de alteracao de registros
            {"1=3","Contrato Cancelado"};                   // condicao de recupercao de registros
           }

AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "999999",;
     /* titulo        */    "N�mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J�ia|2=Taxa|3=Carn�|6=J�ia+Seguro|7=Taxa+Seguro|8=Carn�+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "tipo $ [123678]~TIPO n�o aceit�vel",;
     /* help do campo */    "Qual o tipo de lan�amento";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "ARQGRUP->ultcirc",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(circ).AND.circ<=ARQGRUP->ultcirc~Necess�rio informar CIRCULAR v�lida",;
     /* help do campo */    "Informe o n�mero da circular a consultar";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Emissao",;
     /* cmd especial  */    "",;
     /* default       */    "CIRCULAR->emissao_",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess�rio informar EMISSAO v�lida",;
     /* help do campo */    "Data da Emiss�o da Circular|Mantido pela emissao do recibo";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "@E 9,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "CIRCULAR->valor",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n�o aceit�vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de pagamento/Baixa";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "@E 9,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "!(valorpg<0)~VALOR PAGO n�o aceit�vel",;
     /* help do campo */    "Informe o valor pago/baixado";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador',[])",;
     /* default       */    "CGRUPOS->cobrador",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1).AND.((PTAB(CGRUPOS->grupo+circ,'CIRCULAR',1).AND.PTAB(cobrador+CIRCULAR->mesref,'FCCOB',1).or.1=1))~Problemas encontrados no arquivo Cobrador ou |Circular do grupo n�o cadastrada para|este cobrador.",;
     /* help do campo */    "Informe o Cobrador que recebeu este.";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Forma",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "forma$[PR ]~FORMA n�o aceit�vel",;
     /* help do campo */    "Esta lan�amento foi Pago ou Cancelado|Deixe sem preencher se ainda em aberto";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Baixa_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "9",;
     /* titulo        */    "Status",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_CAMPO],{;            // CTAXAS
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan�amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[31,O_FORMULA],{;          // CTAXAS - Status
     /* form mostrar  */    "LEFT(TRAN(stat,[9]),01)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    72;
                         };
)
AADD(sistema[31,O_FORMULA],{;          // CTAXAS - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    61;
                         };
)
AADD(sistema[31,O_FORMULA],{;          // CTAXAS - Codigo
     /* form mostrar  */    "LEFT(TRAN(codigo,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    1;
                         };
)


sistema[32]={;
            "Produtos",;                                    // opcao do menu
            "Cadastro de produtos",;                        // titulo do sistema
            {"codigo","produto"},;                          // chaves do arquivo
            {"C�digo","Nome do produto"},;                  // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "PRODUTOS",;                                    // nome do DBF
            {"PRODUTO1","PRODUTO2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,6,15,71},;                               // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Mantido pelo sistema de Estoque"},;     // condicao de exclusao de registros
            {"1=3","Mantido pelo sistema de Estoque"},;     // condicao de alteracao de registros
            {"1=3","Mantido pelo sistema de Estoque"};      // condicao de recupercao de registros
           }

AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "9999",;
     /* titulo        */    "C�digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codigo)~Necess�rio informar C�DIGO",;
     /* help do campo */    "Informe o c�digo do produto";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "@!",;
     /* titulo        */    "Descri��o do produto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(produto)~Necess�rio informar DESCRI��O DO PRODUTO",;
     /* help do campo */    "Informe a descri��o do produto";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "@!",;
     /* titulo        */    "Unid",;
     /* cmd especial  */    "",;
     /* default       */    "'UN'",;
     /* pre-validacao */    "MTAB(tbunid,[UNID])",;
     /* validacao     */    "unid $ [UN|CX|MT|KG|LT]~Unidade n�o aceit�vel",;
     /* help do campo */    "Informe a unidade do produto";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "@S35",;
     /* titulo        */    "Refer�ncia t�cnica",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com as especifica��es t�cnicas";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "999999",;
     /* titulo        */    "Qde Est",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qd_est<0)~QDE EST n�o aceit�vel",;
     /* help do campo */    "Informe a quantidade em estoque";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "9999",;
     /* titulo        */    "Qde min",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(Qd_min<0)~QDE MIN n�o aceit�vel",;
     /* help do campo */    "Informe a quantidade m�nima para o produto";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "999999999.99",;
     /* titulo        */    "Preco custo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "preco_cus>0~PRECO CUSTO n�o aceit�vel",;
     /* help do campo */    "Informe o pre�o de custo do produto";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss�o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data correspondete ao custo fornecido";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "999999999.99",;
     /* titulo        */    "Pre�o venda",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(preco_ven<0)~PRE�O de VENDA n�o aceit�vel",;
     /* help do campo */    "Informe o pre�o de Venda do produto";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "@D",;
     /* titulo        */    "Data Venda",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(venda_)~Necess�rio informar DATA VENDA",;
     /* help do campo */    "Informe a data da �ltima atualiza��o|do pre�o de venda";
                         };
)
AADD(sistema[32,O_CAMPO],{;            // PRODUTOS
     /* mascara       */    "@D",;
     /* titulo        */    "Data atualiz",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[32,O_FORMULA],{;          // PRODUTOS - Decodif unidade
     /* form mostrar  */    "LEFT(TRAN(SUBS(tbunid,AT(unid,tbunid)+3,7),[]),07)",;
     /* lin da formula*/    3,;
     /* col da formula*/    27;
                         };
)
AADD(sistema[32,O_FORMULA],{;          // PRODUTOS - lucro
     /* form mostrar  */    "LEFT(TRAN(IIF(preco_ven>0,((preco_ven/preco_cus)-1)*100,0),[@R 9999.99]),07)",;
     /* lin da formula*/    7,;
     /* col da formula*/    24;
                         };
)


sistema[33]={;
            "Filiais",;                                     // opcao do menu
            "Filiais",;                                     // titulo do sistema
            {"codigo"},;                                    // chaves do arquivo
            {"C�digo"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "TFILIAIS",;                                    // nome do DBF
            {"TFILIAI1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,8,16,74},;                               // num telas/tela atual/coordenadas
            {0,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "C�digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codigo)~Necess�rio informar C�DIGO",;
     /* help do campo */    "Informe o c�digo da filial";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "",;
     /* titulo        */    "Abreviatura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(abrev)~Necess�rio informar ABREVIATURA",;
     /* help do campo */    "D� um nome abreviado para a filial|Ser� utilizada para identifica��o nas telas";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess�rio informar NOME",;
     /* help do campo */    "Entre com o nome da filial";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Endereco",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@S35",;
     /* titulo        */    "Ref",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe um ponto de refer�ncia|para facilitar a localiza��o";
                         };
)
AADD(sistema[33,O_CAMPO],{;            // TFILIAIS
     /* mascara       */    "@!",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contato)~Necess�rio informar CONTATO",;
     /* help do campo */    "Qual a pessoa que responde por �sta filial?";
                         };
)

* \\ Final de ADP_ATR2.PRG
