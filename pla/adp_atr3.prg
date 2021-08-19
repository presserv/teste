procedure adp_atr3
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform†tica - Limeira (019)452.6623
 \ Programa: ADP_ATR3.PRG
 \ Data....: 24-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas


sistema[34]={;
            "Entregues aos Cobradores",;                    // opcao do menu
            "Entregues aos cobradores",;                    // titulo do sistema
            {"STR(seq,06,00)","cob+codigo+circ","codigo+tipo+circ"},;// chaves do arquivo
            {"N£mero","Cobrador","Contrato"},;              // titulo dos indices para consulta
            {"01","060204","020304"},;                      // ordem campos chaves
            "TXENTR",;                                      // nome do DBF
            {"TXENTR1","TXENTR2","TXENTR3"},;               // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,3,19,77,3,8},;                           // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "999999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(codigo)~Necess†rio informar CODIGO",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [123678]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "999",;
     /* titulo        */    "Circ",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(circ).AND.TXE_01F9()~Necess†rio informar CIRCULAR",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "M->pvalor",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR nÑo aceit†vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "!!!",;
     /* titulo        */    "Cob",;
     /* cmd especial  */    "",;
     /* default       */    "M->pcob",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cob,'COBRADOR',1)~COBRADOR nÑo existe na tabela",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Màs Ref.",;
     /* cmd especial  */    "",;
     /* default       */    "M->mmesref",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(mesref)~Necess†rio informar MES REF.",;
     /* help do campo */    "Informe o màs a que se refere a cobranáa";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "@D",;
     /* titulo        */    "Pagto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "",;
     /* titulo        */    "F.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "@D",;
     /* titulo        */    "Baixa_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_CAMPO],{;            // TXENTR
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[34,O_FORMULA],{;          // TXENTR - Pagto.
     /* form mostrar  */    "LEFT(TRAN(pgto_,[@D]),08)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    42;
                         };
)
AADD(sistema[34,O_FORMULA],{;          // TXENTR - Valor pago
     /* form mostrar  */    "LEFT(TRAN(valorpg,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    51;
                         };
)
AADD(sistema[34,O_FORMULA],{;          // TXENTR - F.
     /* form mostrar  */    "LEFT(TRAN(forma,[]),01)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    62;
                         };
)
AADD(sistema[34,O_FORMULA],{;          // TXENTR - Baixa_
     /* form mostrar  */    "LEFT(TRAN(baixa_,[@D]),08)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    64;
                         };
)
AADD(sistema[34,O_FORMULA],{;          // TXENTR - Màs Ref.
     /* form mostrar  */    "LEFT(TRAN(mesref,[@R 99/99]),05)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    0;
                         };
)


sistema[35]={;
            "Recebimento de Taxas",;                        // opcao do menu
            "Recebimento de Taxas",;                        // titulo do sistema
            {"ano+numero","numop+ano+numero","codigo"},;             // chaves do arquivo
            {"p/ N£mero","p/O.P.","Contrato"},;                        // titulo dos indices para consulta
            {"0102","100102","03"},;                             // ordem campos chaves
            "BXREC",;                                       // nome do DBF
            {"BXREC1","BXREC2","BXREC3"},;                           // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,3,10,23,62},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Mantido pela RecepáÑo"},;               // condicao de exclusao de registros
            {"nivelop=3","Para alterar este documento|chame o gerente de sistema"},;// condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "99",;
     /* titulo        */    "Ano",;
     /* cmd especial  */    "",;
     /* default       */    "RIGHT(DTOC(DATE()),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1).AND.(PTAB(codigo,'TAXAS',1).OR.(1=1))~Contrato inv†lido |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "tipo $ [123678]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "PTAB(codigo,'TAXAS',1).AND.VDBF(6,23,20,77,'TAXAS',{'codigo','tipo','circ','emissao_','valor','pgto_','valorpg'},1,'circ')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo+tipo+circ,'TAXAS',1).AND.EMPT(TAXAS->valorpg)~Circular nÑo cadastrada|ou|Taxa j† baixada",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "BXR_02F9()",;
     /* pre-validacao */    "!EMPT(circ)",;
     /* validacao     */    "valorpg>0~VALOR PAGO nÑo aceit†vel|Digite o valor recebido",;
     /* help do campo */    "Informe o valor pago ou zeros se for retorno.";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Pago com...",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valoraux>=valorpg~VALOR INSUFICIENTE para quitar o dÇbito|A T E N Ä « O",;
     /* help do campo */    "Informe o valor pago";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "@D",;
     /* titulo        */    "Emitido em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "999999",;
     /* titulo        */    "Nß O.P.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "!9",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_CAMPO],{;            // BXREC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    4,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Circ 1 - 4
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(codigo,'TAXAS',1),BXR_01F9(),[]),[]),45)",;
     /* lin da formula*/    12,;
     /* col da formula*/    3;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Ult.Circular
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->ultcirc,[999]),03)",;
     /* lin da formula*/    6,;
     /* col da formula*/    46;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - SituaáÑo
     /* form mostrar  */    "LEFT(TRAN(IIF(GRUPOS->situacao='2',[CANCELADO],[         ])+[ - Grupo ]+GRUPOS->grupo,[]),22)",;
     /* lin da formula*/    2,;
     /* col da formula*/    23;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - AdmissÑo
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->admissao,[@D]),08)",;
     /* lin da formula*/    8,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Saitxa
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->saitxa,[@R 99/99]),05)",;
     /* lin da formula*/    8,;
     /* col da formula*/    32;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Cobrador
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->cobrador,[!!]),02)",;
     /* lin da formula*/    9,;
     /* col da formula*/    32;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Funerais
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->funerais,[99]),02)",;
     /* lin da formula*/    9,;
     /* col da formula*/    12;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Circ.Inicial
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->circinic,[999]),03)",;
     /* lin da formula*/    5,;
     /* col da formula*/    46;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Endereáo
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->endereco,[]),35)",;
     /* lin da formula*/    5,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Bairro
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->bairro,[]),25)",;
     /* lin da formula*/    6,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Cidade
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->cidade,[]),25)",;
     /* lin da formula*/    7,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - CEP
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->cep,[@R 99999-999]),09)",;
     /* lin da formula*/    7,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - RegiÑo
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->regiao,[999]),03)",;
     /* lin da formula*/    6,;
     /* col da formula*/    34;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - endereco
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(codigo,'ALENDER',1),[ENDEREÄO ALTERADO ]+DTOC(ALENDER->data_),[ ]),[]),27)",;
     /* lin da formula*/    1,;
     /* col da formula*/    23;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - troco
     /* form mostrar  */    "LEFT(TRAN(valoraux-valorpg,[@E 999,999.99]),11)",;
     /* lin da formula*/    18,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Qt.Circulares
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->qtcircs,[999]),03)",;
     /* lin da formula*/    7,;
     /* col da formula*/    46;
                         };
)
AADD(sistema[35,O_FORMULA],{;          // BXREC - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    20;
                         };
)


sistema[36]={;
            "Endereáos",;                                   // opcao do menu
            "Endereáos",;                                   // titulo do sistema
            {"codigo"},;                                    // chaves do arquivo
            {"p/Contrato"},;                                // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "ALENDER",;                                     // nome do DBF
            {"ALENDER1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,9,2,17,77},;                               // num telas/tela atual/coordenadas
            {0,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu†rios cadastrados|com n°vel de ManutenáÑo ou Maior"},;// condicao de exclusao de registros
            {"nivelop>1","Permitido apenas a usu†rios cadastrados|com n°vel de ManutenáÑo ou Maior"},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu†rios cadastrados|com n°vel de ManutenáÑo ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,31,20,77,'GRUPOS',{'codigo','nome'},4,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1).AND.ALE_01F9()~CODIGO nÑo aceit†vel|Tecle F8 para consulta",;
     /* help do campo */    "Entre com o n£mero do contrato|Tecle F8 para consulta";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Endereáo",;
     /* cmd especial  */    "",;
     /* default       */    "GRUPOS->endereco",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Necess†rio informar ENDEREÄO do Titular",;
     /* help do campo */    "Informe o Endereáo para correspondàncias.|Rua,n£mero,apto, blocl, etc...";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "GRUPOS->bairro",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(bairro)~Necess†rio informar BAIRRO do Titular",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "GRUPOS->cidade",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess†rio informar MUNICIPIO para cobranáa do Titular.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "GRUPOS->uf",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(uf)~Necess†rio informar Estado para cobranáa do Titular.",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "GRUPOS->cep",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess†rio informar CEP do Titular |com 08 digitos",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,39,20,77,'REGIAO',{'regiao','cobrador'},2,'cobrador',[!EMPT(cobrador)])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1)~COBRADOR nÑo existe na tabela",;
     /* help do campo */    "Digite o c¢digo do COBRADOR que|receber† as Taxas deste contrato,|Tecle F8 para consultar os cobradores.";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@D",;
     /* titulo        */    "Data_",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "M->usuario",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Endereáo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "",;
     /* titulo        */    "Dgrupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@D",;
     /* titulo        */    "Emitido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Data da emissÑo de solicitaáÑo do endereáo";
                         };
)
AADD(sistema[36,O_CAMPO],{;            // ALENDER
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[36,O_FORMULA],{;          // ALENDER - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    1,;
     /* col da formula*/    25;
                         };
)
AADD(sistema[36,O_FORMULA],{;          // ALENDER - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    22;
                         };
)


sistema[37]={;
            "Acerto Pagos e Trocas",;                       // opcao do menu
            "Acerto Pagos e Trocas",;                       // titulo do sistema
            {"idfilial+numero"},;                           // chaves do arquivo
            {"p/FCC"},;                                     // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "BXFCC",;                                       // nome do DBF
            {"BXFCC1"},;                                    // nomes dos NTX
            {"BXTXAS","TROTXAS"},;                          // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,3,16,16,71},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"},;// condicao de exclusao de registros
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"},;// condicao de alteracao de registros
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"};// condicao de recupercao de registros
           }

AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "!!",;
     /* titulo        */    "Id",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Identifique a filial|se houver.";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(numero)~Necess†rio informar NUMERO",;
     /* help do campo */    "Informe o n£mero da FCC";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@D",;
     /* titulo        */    "Lancto_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,22,20,77,'COBRADOR',{'cobrador','nome','telefone'},1,'cobrador')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1)~Necess†rio informar COBRADOR",;
     /* help do campo */    "Entre com o c¢digo do cobrador";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@!",;
     /* titulo        */    "Nome do Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "COBRADOR->nome",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nomecobr)~Necess†rio informar NOME DO COBRADOR",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Despesas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(despesas<0)~VALOR DAS DESPESAS nÑo aceit†vel",;
     /* help do campo */    "Informe o valor das despesas desta cobranáa.";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@D",;
     /* titulo        */    "Baixa",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(baixa_)~Necess†rio informar BAIXA",;
     /* help do campo */    "Informe a data da Baixa";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "999.9",;
     /* titulo        */    "%Comiss.Taxas",;
     /* cmd especial  */    "",;
     /* default       */    "COBRADOR->percent",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(comtxa<0).AND.!(comtxa>100)~ComissÑo das Taxas nÑo aceit†vel",;
     /* help do campo */    "Informe o percentual de comissÑo|sobre os recebimento de Taxas";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "999.9",;
     /* titulo        */    "%Comiss.Trocas",;
     /* cmd especial  */    "",;
     /* default       */    "COBRADOR->percent",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(comtroc<0).AND.!(comtroc>100)~ComissÑo das Trocas nÑo aceit†vel",;
     /* help do campo */    "Informe o percentual de comissÑo|sobre as Trocas";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "999.9",;
     /* titulo        */    "%Comiss.Carnàs",;
     /* cmd especial  */    "",;
     /* default       */    "COBRADOR->percent",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(comcarn<0).AND.!(comcarn>100)~ComissÑo dos Carnàs nÑo aceit†vel",;
     /* help do campo */    "Informe o percentual de comissÑo|sobre os recebimento de Carnàs";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "999.9",;
     /* titulo        */    "Percentual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(comoutr<0).AND.!(comoutr>100)~ComissÑo das Taxas nÑo aceit†vel",;
     /* help do campo */    "Informe o percentual de comissÑo|de outros recebimentos";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999",;
     /* titulo        */    "Qtdoutr",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtdoutr<0)~QTDOUTR nÑo aceit†vel",;
     /* help do campo */    "Informe o n£mero de documentos";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Vl.Outros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(vloutr<0)~VL.OUTROS nÑo aceit†vel",;
     /* help do campo */    "Informe o valor de outros recebimentos";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999",;
     /* titulo        */    "Parc Pag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor Taxas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999",;
     /* titulo        */    "Parc Troc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor Trocas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999",;
     /* titulo        */    "Parc Carn",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor Carnàs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Vlr.Baixado",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "",;
     /* titulo        */    "NrCCPagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "999999",;
     /* titulo        */    "Nß O.P.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_CAMPO],{;            // BXFCC
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - por
     /* form mostrar  */    "LEFT(TRAN(IIF(EMPT(por),M->usuario,por),[]),10)",;
     /* lin da formula*/    2,;
     /* col da formula*/    43;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - em
     /* form mostrar  */    "LEFT(TRAN(IIF(EMPT(lancto_),DATE(),lancto_),[@D]),08)",;
     /* lin da formula*/    2,;
     /* col da formula*/    30;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Parc Pag
     /* form mostrar  */    "LEFT(TRAN(parcpag,[99999]),05)",;
     /* lin da formula*/    6,;
     /* col da formula*/    20;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Parc Trocas
     /* form mostrar  */    "LEFT(TRAN(parctroc,[99999]),05)",;
     /* lin da formula*/    7,;
     /* col da formula*/    20;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Parc Carn
     /* form mostrar  */    "LEFT(TRAN(parccarn,[99999]),05)",;
     /* lin da formula*/    8,;
     /* col da formula*/    20;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Valor Taxas
     /* form mostrar  */    "LEFT(TRAN(vltaxas,[@E 999,999.99]),10)",;
     /* lin da formula*/    6,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Valor Trocas
     /* form mostrar  */    "LEFT(TRAN(vltrocas,[@E 999,999.99]),10)",;
     /* lin da formula*/    7,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Valor Carnàs
     /* form mostrar  */    "LEFT(TRAN(vlcarnes,[@E 999,999.99]),10)",;
     /* lin da formula*/    8,;
     /* col da formula*/    28;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - Valor Total
     /* form mostrar  */    "LEFT(TRAN(vltaxas+vlcarnes+vloutr,[@E 9,999,999.99]),12)",;
     /* lin da formula*/    11,;
     /* col da formula*/    26;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - % Taxas
     /* form mostrar  */    "LEFT(TRAN(vltaxas*comtxa/100,[@E 99,999.99]),09)",;
     /* lin da formula*/    6,;
     /* col da formula*/    42;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - % Trocas
     /* form mostrar  */    "LEFT(TRAN(vltrocas*comtroc/100,[@E 99,999.99]),09)",;
     /* lin da formula*/    7,;
     /* col da formula*/    42;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - % Carnàs
     /* form mostrar  */    "LEFT(TRAN(vlcarnes*comcarn/100,[@E 99,999.99]),09)",;
     /* lin da formula*/    8,;
     /* col da formula*/    42;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - % Outros
     /* form mostrar  */    "LEFT(TRAN(vloutr *comoutr/100,[@E 99,999.99]),09)",;
     /* lin da formula*/    9,;
     /* col da formula*/    42;
                         };
)
AADD(sistema[37,O_FORMULA],{;          // BXFCC - % Total
     /* form mostrar  */    "LEFT(TRAN((vltaxas*comtxa/100)+(vltrocas*comtroc/100)+(vlcarnes*comcarn/100)+(vloutr*comoutr/100),[@E 999,999.99]),10)",;
     /* lin da formula*/    11,;
     /* col da formula*/    41;
                         };
)


sistema[38]={;
            "Taxas Pagas",;                                 // opcao do menu
            "Taxas Pagas",;                                 // titulo do sistema
            {"idfilial+numero+seq","codigo+tipo+circ"},;    // chaves do arquivo
            {"p/N£mero","Contrato"},;                       // titulo dos indices para consulta
            {"010203","040506"},;                           // ordem campos chaves
            "BXTXAS",;                                      // nome do DBF
            {"BXTXAS1","BXTXAS2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"BXFCC->idfilial","BXFCC->numero"},;           // campos de relacionamento
            {1,1,12,4,21,45,3,6},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"},;// condicao de exclusao de registros
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"},;// condicao de alteracao de registros
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"};// condicao de recupercao de registros
           }

AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "!!",;
     /* titulo        */    "Id",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "99999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(seq)~Necess†rio informar SEQ",;
     /* help do campo */    "";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>[000000]~Necess†rio informar CODIGO",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [123678]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "circ>[000]~Necess†rio informar CIRCULAR",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "M->pvalor",;
     /* pre-validacao */    "",;
     /* validacao     */    "valorpg>0~VALOR PAGO nÑo aceit†vel",;
     /* help do campo */    "Informe o valor pago.";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "",;
     /* titulo        */    "ProcOk",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[38,O_CAMPO],{;            // BXTXAS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[39]={;
            "Taxas Trocadas",;                              // opcao do menu
            "Taxas Trocadas",;                              // titulo do sistema
            {"idfilial+numero+seq"},;                       // chaves do arquivo
            {"p/N£mero"},;                                  // titulo dos indices para consulta
            {"010203"},;                                    // ordem campos chaves
            "TROTXAS",;                                     // nome do DBF
            {"TROTXAS1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"BXFCC->idfilial","BXFCC->numero"},;           // campos de relacionamento
            {1,1,13,33,21,75,3,5},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"},;// condicao de exclusao de registros
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"},;// condicao de alteracao de registros
            {"1=3","Mantido pelo sistema de Cobranáa (ADCBIG)"};// condicao de recupercao de registros
           }

AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "!!",;
     /* titulo        */    "Id",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "999999",;
     /* titulo        */    "Numero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "99999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>[000000]~Necess†rio informar CODIGO",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [123678]~TIPO nÑo aceit†vel",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "circ >[000]~CIRCULAR nÑo aceit†vel",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "M->pvalor",;
     /* pre-validacao */    "",;
     /* validacao     */    "valorpg>0~VALOR PAGO nÑo aceit†vel",;
     /* help do campo */    "Informe o valor pago.";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "",;
     /* titulo        */    "ProcOk",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[39,O_CAMPO],{;            // TROTXAS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[40]={;
            "Mensagem p/Contrato",;                         // opcao do menu
            "Mensagem p/Contrato",;                         // titulo do sistema
            {"seq","codigo"},;                              // chaves do arquivo
            {"Sequencia","Contrato"},;                      // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "MENSAG",;                                      // nome do DBF
            {"MENSAG1","MENSAG2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,9,13,14,67},;                              // num telas/tela atual/coordenadas
            {0,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[40,O_CAMPO],{;            // MENSAG
     /* mascara       */    "999999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[40,O_CAMPO],{;            // MENSAG
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1)~Contrato cancelado |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[40,O_CAMPO],{;            // MENSAG
     /* mascara       */    "",;
     /* titulo        */    "Mens1",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(mens1)~Necess†rio informar a primeira linha de mensagen|Tecle ESC para cancelar.",;
     /* help do campo */    "Informe a mensagem a imprimir na cobranáa|Vocà tem tràs linhas com atÇ 80 caracteres.";
                         };
)
AADD(sistema[40,O_CAMPO],{;            // MENSAG
     /* mascara       */    "@D",;
     /* titulo        */    "Lanáamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[40,O_CAMPO],{;            // MENSAG
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[40,O_FORMULA],{;          // MENSAG - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    2,;
     /* col da formula*/    18;
                         };
)
AADD(sistema[40,O_FORMULA],{;          // MENSAG - Lanáamento
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),08)",;
     /* lin da formula*/    1,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[40,O_FORMULA],{;          // MENSAG - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    42;
                         };
)


sistema[41]={;
            "CEP",;                                         // opcao do menu
            "CEP",;                                         // titulo do sistema
            {"nome_log"},;           // chaves do arquivo
            {"Rua / Logradouro"},;        // titulo dos indices para consulta
            {"01"},;                              // ordem campos chaves
            "CEP",;                                         // nome do DBF
            {"CEP1"},;                        // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,4,14,78},;                               // num telas/tela atual/coordenadas
            {1,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "@!",;
     /* titulo        */    "Nome_log",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "@!",;
     /* titulo        */    "Local_log",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro_1",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro_2",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "",;
     /* titulo        */    "Cep5_log",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(UF_LOG)~UNIDADE DA FEDERAÄéO inv†lida",;
     /* help do campo */    "";
                         };
)
AADD(sistema[41,O_CAMPO],{;            // CEP
     /* mascara       */    "",;
     /* titulo        */    "Tipo_log",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)


sistema[42]={;
            "ParÉmetros",;                                  // opcao do menu
            "ParÉmetros do sistema",;                       // titulo do sistema
            {},;                                            // chaves do arquivo
            {},;                                            // titulo dos indices para consulta
            {},;                                            // ordem campos chaves
            "PAR_ADM",;                                     // nome do DBF
            {},;                                            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,8,23,71},;                               // num telas/tela atual/coordenadas
            {2,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o c¢digo da filial";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Verificar Pagas?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Repetir lanáamento?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Maior Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "000000",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Nrreint",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Conta Recepcao",;
     /* cmd especial  */    "",;
     /* default       */    "[RECEP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contarec)~Necess†rio informar CONTA RECEPCAO p/recebimentos",;
     /* help do campo */    "Informe a Conta que receber†|os lanáamentos da recepáÑo.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Conta Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "[RECEP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(contapag)~Necess†rio informar CONTA RECEPCAO p/Pagamentos",;
     /* help do campo */    "Informe a Conta que pagar†|os lanáamentos da recepáÑo.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrcfcc=[000].OR. PTAB(histrcfcc,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento de|recebimento de FCC.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrcrec=[000].OR. PTAB(histrcrec,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento|para taxas recebidas na RecepáÑo.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "histrccar=[000].OR. PTAB(histrccar,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico do lanáamento|para parcelas recebidas na RecepáÑo.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,24,20,77,'HISTORIC',{'historico','descricao','tipo'},1,'historico',[HISTORIC->origem$'ADM   '])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "histpg=[000].OR. PTAB(histpg,'HISTORIC',1)~HIST¢RICO nÑo existe na tabela",;
     /* help do campo */    "Informe o hist¢rico|para lanáamento de pagamentos.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99-999999",;
     /* titulo        */    "Nß Recibo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do recibo a imprimir.|no formato AA-NNNNNN|onde: AA=Ano, N=n£mero|ou deixe sem preencher";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo',[situacao=1])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(mcodigo,'GRUPOS',1).AND.PTAB(mcodigo,'TAXAS',1).OR.mcodigo=[00000]~C¢digo inv†lido ou sem Taxas pendentes",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnà|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnà+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "!(mcodigo=[00000])",;
     /* validacao     */    "mtipo $ [123678 ]~TIPO nÑo aceit†vel|Tecle F8 ou deixe sem preencher",;
     /* help do campo */    "Qual o tipo de lanáamento";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "VDBF(6,22,20,77,'TAXAS',{'codigo','circ','emissao_','valor','valorpg','forma'},1,'circ',[])",;
     /* default       */    "",;
     /* pre-validacao */    "!(mcodigo=[00000])",;
     /* validacao     */    "PTAB(mcodigo+mcirc,'TAXAS',1).AND.PTAB(GRUPOS->grupo+mcirc,'CIRCULAR',1).or.mcirc='000'~Necess†rio informar CIRCULAR existente",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!",;
     /* titulo        */    "Grup",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(mgrupvip).OR.PTAB(mgrupvip,'ARQGRUP',1)~GRUP nÑo existe na tabela",;
     /* help do campo */    "Entre com o c¢digo do Grupo que ser† utilizado|como controle dos contratos VIPs.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Combarra",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "combarra$'SN '~COMBARRA nÑo aceit†vel|Digite S ou N",;
     /* help do campo */    "Informe se os recibos devem ser impressos|com o c¢digo de barras";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Com Inscritos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "cinscr$'SN '~Digite S ou N",;
     /* help do campo */    "Informe se os Inscritos est∆o cadastrados|Se sim, ser† obrigat¢rio a identificaá∆o|dele em alguns procedimentos, como guias, processos,etc...";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Com Falecido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "comfalec$'SN '~Digite S para imprimir recibos com os|Falecidos da circular (prÇ-impresso)|ou N para folha branca",;
     /* help do campo */    "Informe se os recibos da recepá∆o|devem ser impressos com os|falecidos, se digitar N, ser† impresso em folha branca";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99999",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Ano",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Procimp",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Màs Ref.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Pnumfcc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@!",;
     /* titulo        */    "Munic°pio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(p_cidade)~Informe o nome do munic°pio|Ser† utilizado na impress∆o de alguns relat¢rios|como parte da data.",;
     /* help do campo */    "Entre com o nome do Munic°pio";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "!",;
     /* titulo        */    "Recibo PadrÑo",;
     /* cmd especial  */    "MTAB([S-Recibos em papÇl branco|N-Recibos prÇ-impressos],[RECIBO PADRéO])",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "(p_recp$[SN ])~RECIBO PADRéO nÑo aceit†vel|Digite S, N ou deixe sem preencher.",;
     /* help do campo */    "Digite S para utilizar o modelo|Padronizado de recibos (formul†rio branco)|ou N para recibos personalizados";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Ident1",;
     /* cmd especial  */    "",;
     /* default       */    "[Ind£stria de Urnas Bignotto Ltda]",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(setup1)~Digite o nome da Empresa|Ser† utilizado em relat¢rios",;
     /* help do campo */    "Informe o nome da Empresa";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VCGC(cgcsetup).or.EMPT(cgcsetup)~Necess†rio informar CGC",;
     /* help do campo */    "";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Ident2",;
     /* cmd especial  */    "Digite o endereáo,|ser† a 2¶ linha de cabeáalho|de alguns relat¢rios",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o endereáo.";
                         };
)
AADD(sistema[42,O_CAMPO],{;            // PAR_ADM
     /* mascara       */    "",;
     /* titulo        */    "Setup3",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a 3¶ linha de cabeáalho.|Ex.: Telefone, Fax, etc...";
                         };
)
AADD(sistema[42,O_FORMULA],{;          // PAR_ADM - Desc.Pgto.
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histpg,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    5,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[42,O_FORMULA],{;          // PAR_ADM - Desc.Recebto
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrcrec,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    3,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[42,O_FORMULA],{;          // PAR_ADM - Desc.Receb.FCC
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrcfcc,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    2,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[42,O_FORMULA],{;          // PAR_ADM - DescriáÑo de Hi
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(histrccar,'HISTORIC',1),HISTORIC->descricao,SPACE(40)),[]),40)",;
     /* lin da formula*/    4,;
     /* col da formula*/    22;
                         };
)


sistema[43]={;
            "Senhas",;                                      // opcao do menu
            "Usu†rios do sistema",;                         // titulo do sistema
            {"pass"},;                                      // chaves do arquivo
            {""},;                                          // titulo dos indices para consulta
            {"02"},;                                        // ordem dos campos chvs
            "ADPPW",;                                       // nome do DBF
            {ntxpw},;                                       // nome do NTX
            {},;                                            // nome dos DBF relacionados
            {},;                                            // campos de relacionamento
            {1,1,11,19,17,51},;                             // qde telas, tela atual, coordenadas
            {3,.t.},;                                       // nivel acesso/tp chave
            {},; // campos  { mascara, titulo, when, critica }
            {},;// fromula { mascara, titulo, formula, linha, coluna }
            {"",""},;      // condicao de exclusao de registros
            {"",""},;      // condicao de alteracao de registros
            {"",""};       // condicao de recuperacao de registros
           }

msg="DIGITE INICIAIS DAS ROTINAS CERCEADAS AO USUèRIO|"+;
    "P. Procura    F. Filtragem    D. DigitaáÑo     ˇ|"+;
    "M. Modifica   E. Exclui       R. Recupera      ˇ|"+;
    "V. Và global  N. Nova coluna  A. Apaga coluna  ˇ|"+;
    "I. Imprime    O. Ordena       Q. Quantifica    ˇ|"+;
    "L. Localiza   G. Global       C. Congela Colunas|"+;
    "T. Tamanho    J. nova Janela ˇX. eXporta       ˇ|"+;
    "Z. totaliZa                                    ˇ|"
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "",;
     /* titulo        */    "Pass",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@!",;
     /* titulo        */    "Usu†rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPTY(nome)~Necess†rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "9",;
     /* titulo        */    "Nivel",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([1. OperaáÑo ˇ|2. ManutenáÑo|3. Gerància ˇ],[N°VEL DE ACESSO])",;
     /* validacao     */    "nace$[123]~N°VEL DE ACESSO inv†lido",;
     /* help do campo */    "";
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Contratos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outros Endereáos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Inscritos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cancelamentos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Processos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Lanáamento/Carnàs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Tabela",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Custos Adicionais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Boletos Emitidos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Baixa Boletos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Baixa de Boletos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas a processar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas a Imprimir",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Categoria dos Planos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Produtos p/Categoria",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Grupos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cobranáas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Regiîes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cobradores/Vendedores",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Parcelas do Vendedor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Cobranáas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Circulares",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Processos da Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Funcion†rios",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "ParÉmetro de Juros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Hist¢rico PadrÑo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Contratos Cancelados",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Outros Endereáos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Inscritos Cancelados",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas Canceladas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Produtos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Filiais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Entregues aos Cobradores",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Recebimento de Taxas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Endereáos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Acerto Pagos e Trocas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas Pagas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Taxas Trocadas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "Mensagem p/Contrato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)
AADD(sistema[43,O_CAMPO],{;            // SENHAS
     /* mascara       */    "@A@!",;
     /* titulo        */    "ParÉmetros",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    msg;
                         };
)

* \\ Final de ADP_ATR3.PRG
