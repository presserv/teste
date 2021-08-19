procedure adp_atr1
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_ATR1.PRG
 \ Data....: 24-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas


sistema[10]={;
            "Boletos Emitidos",;                            // opcao do menu
            "Boletos Emitidos",;                            // titulo do sistema
            {"seq","nnumero","codigo+tipo+circ"},;          // chaves do arquivo
            {"Lan‡amento","Nosso N£mero","Circular"},;      // titulo dos indices para consulta
            {"01","02","030405"},;                          // ordem campos chaves
            "BOLETOS",;                                     // nome do DBF
            {"BOLETOS1","BOLETOS2","BOLETOS3"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,16,21,65,3,10},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "999999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "99999999999",;
     /* titulo        */    "N.N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nnumero)~Necess rio informar N.N£MERO",;
     /* help do campo */    "Informe o n£mero do boleto|Chamado pelo banco de Nosso N£mero";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "999999",;
     /* titulo        */    "Contrato",;
     /* cmd especial  */    "VDBF(6,25,20,77,'GRUPOS',{'codigo','grupo','nome'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1)~Necess rio informar CODIGO",;
     /* help do campo */    "Informe o n£mero do contrato deste boleto";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa p/Processo|3=Taxa Peri¢dica],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [123456789]~TIPO n„o aceit vel",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "999",;
     /* titulo        */    "N.Circ",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo+tipo+circ,'TAXAS',1)~Taxa n„o encontrada no cadastro de Taxas|Verifique",;
     /* help do campo */    "Informe o n£mero da cobran‡a";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // BOLETOS
     /* mascara       */    "@D",;
     /* titulo        */    "Em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[11]={;
            "Baixa Boletos",;                               // opcao do menu
            "Baixa Boletos (Francesinha)",;                 // titulo do sistema
            {"nrlote"},;                                    // chaves do arquivo
            {"Nr.Lote"},;                                   // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "LBXBOLET",;                                    // nome do DBF
            {"LBXBOLE1"},;                                  // nomes dos NTX
            {"BXBOLET"},;                                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,18,12,63},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "999999",;
     /* titulo        */    "Nr Lote",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nrlote)~Necess rio informar NR LOTE",;
     /* help do campo */    "Informe o n£mero do lote|ou a identifica‡„o da Francesinha";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()-1",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar EMISSŽO",;
     /* help do campo */    "Informe a data da emiss„o do lote";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "999999",;
     /* titulo        */    "N.FCC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total das Despesas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(totdesp<0)~VALOR n„o aceit vel|deve ser positivo",;
     /* help do campo */    "Informe o total das despesas|cobradas pelo banco";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total dos Cr‚ditos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(totcred<0)~VALOR n„o aceit vel",;
     /* help do campo */    "Informe o valor bruto dos|boletos baixados";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Liquido creditado",;
     /* cmd especial  */    "totcred-totdesp",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(totliq<0)~VALOR n„o aceit vel|Informe o valor liquido creditado.",;
     /* help do campo */    "Informe o valor liquido|creditado em conta";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@D",;
     /* titulo        */    "Em",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total das Despesas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // LBXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Total dos Cr‚ditos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_FORMULA],{;          // LBXBOLET - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // LBXBOLET - Em
     /* form mostrar  */    "LEFT(TRAN(em_,[@D]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // LBXBOLET - Titulo
     /* form mostrar  */    "LEFT(TRAN(IIF(nivelop=3,[Diferen‡a],[         ]),[]),10)",;
     /* lin da formula*/    3,;
     /* col da formula*/    34;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // LBXBOLET - Total das Despe
     /* form mostrar  */    "LEFT(TRAN(IIF(nivelop=3,TRAN(totdesp-ldesp,[@E 999,999.99]),[ ]),[]),10)",;
     /* lin da formula*/    4,;
     /* col da formula*/    34;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // LBXBOLET - Total dos Cr‚di
     /* form mostrar  */    "LEFT(TRAN(IIF(nivelop=3,TRAN(totcred-lcred,[@E 999,999.99]),[ ]),[]),10)",;
     /* lin da formula*/    5,;
     /* col da formula*/    34;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // LBXBOLET - N.FCC
     /* form mostrar  */    "LEFT(TRAN(nfcc,[]),06)",;
     /* lin da formula*/    2,;
     /* col da formula*/    26;
                         };
)


sistema[12]={;
            "Baixa de Boletos",;                            // opcao do menu
            "Baixa de Boletos (Francesinha)",;              // titulo do sistema
            {"nrlote+seq","nnumero"},;                      // chaves do arquivo
            {"Nr Lote","p/Nosso N£mero"},;                  // titulo dos indices para consulta
            {"0102","03"},;                                 // ordem campos chaves
            "BXBOLET",;                                     // nome do DBF
            {"BXBOLET1","BXBOLET2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"LBXBOLET->nrlote"},;                          // campos de relacionamento
            {1,1,10,10,22,71,3,9},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[12,O_CAMPO],{;            // BXBOLET
     /* mascara       */    "999999",;
     /* titulo        */    "Nr Lote",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // BXBOLET
     /* mascara       */    "99999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // BXBOLET
     /* mascara       */    "99999999999",;
     /* titulo        */    "N.N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nnumero)~Necess rio informar N.N£MERO",;
     /* help do campo */    "Informe o n£mero do boleto|Chamado pelo banco de Nosso N£mero";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // BXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // BXBOLET
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Vl.Despesas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(vldesp<0)~VALOR n„o aceit vel|Deve ser zeros ou positivo",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // BXBOLET
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_FORMULA],{;          // BXBOLET - Vl.Liquido
     /* form mostrar  */    "LEFT(TRAN(valor-vldesp,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    50;
                         };
)


sistema[13]={;
            "Taxas a processar",;                           // opcao do menu
            "Taxas a processar",;                           // titulo do sistema
            {"codigo+tipo+circ"},;                          // chaves do arquivo
            {"Contrato/Circular"},;                         // titulo dos indices para consulta
            {"010203"},;                                    // ordem campos chaves
            "TXPROC",;                                      // nome do DBF
            {"TXPROC1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,13,1,23,79,3,7},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {0,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,31,20,77,'GRUPOS',{'codigo','nome'},4,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1)~CODIGO n„o aceit vel|Tecle F8 para consulta",;
     /* help do campo */    "Entre com o n£mero do contrato|Tecle F8 para consulta";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia |2=Taxa |3=Carnˆ|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "tipo $ [1236789]~TIPO n„o aceit vel",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(circ)~Necess rio informar CIRCULAR v lida",;
     /* help do campo */    "Informe o n£mero da circular a consultar";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "@D",;
     /* titulo        */    "Emissao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar EMISSAO v lida",;
     /* help do campo */    "Data da Emiss„o da Circular|Mantido pela emissao do recibo";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "@D",;
     /* titulo        */    "Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de pagamento/Baixa";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "!(valorpg<0)~VALOR PAGO n„o aceit vel",;
     /* help do campo */    "Informe o valor pago/baixado";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,3,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade','telefone'},1,'cobrador',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1)~Problemas encontrados no arquivo Cobrador ou |Circular do grupo n„o cadastrada para|este cobrador.",;
     /* help do campo */    "Informe o Cobrador que recebeu este.";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "!",;
     /* titulo        */    "Forma",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "forma$[PR ]~FORMA n„o aceit vel",;
     /* help do campo */    "Esta lan‡amento foi Pago ou Cancelado|Deixe sem preencher se ainda em aberto";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "@D",;
     /* titulo        */    "Baixa_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "9",;
     /* titulo        */    "Status",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "!",;
     /* titulo        */    "AtP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "!",;
     /* titulo        */    "AtC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_CAMPO],{;            // TXPROC
     /* mascara       */    "!",;
     /* titulo        */    "AtR",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[13,O_FORMULA],{;          // TXPROC - Status
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(codigo+tipo+circ,'TAXAS',1),TAX_02F9(),[ ]),[]),08)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    66;
                         };
)
AADD(sistema[13,O_FORMULA],{;          // TXPROC - Por
     /* form mostrar  */    "LEFT(TRAN(LEFT(por,9),[]),09)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    56;
                         };
)
AADD(sistema[13,O_FORMULA],{;          // TXPROC - ATPCR
     /* form mostrar  */    "LEFT(TRAN(ATP+ATC+ATR,[!!!]),03)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    75;
                         };
)


sistema[14]={;
            "Taxas a Imprimir",;                            // opcao do menu
            "Taxas a Imprimir",;                            // titulo do sistema
            {"codigo+tipo+circ"},;                          // chaves do arquivo
            {"Contrato e Circ."},;                          // titulo dos indices para consulta
            {"010203"},;                                    // ordem campos chaves
            "TX2VIA",;                                      // nome do DBF
            {"TX2VIA1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,13,19,71,3,8},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {0,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[14,O_CAMPO],{;            // TX2VIA
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1)~Necess rio informar CODIGO",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // TX2VIA
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnˆ|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [0123456789]~TIPO n„o aceit vel",;
     /* help do campo */    "Qual o tipo de Taxa a Emitir";
                         };
)
AADD(sistema[14,O_CAMPO],{;            // TX2VIA
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo+tipo+circ,'TAXAS',1).OR.PTAB(codigo+SUBSTR('678  123',VAL(tipo),1)+circ,[TAXAS],1)~N£mero inv lido|Taxa n„o existe em contas a receber",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[14,O_FORMULA],{;          // TX2VIA - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[@!]),35)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    17;
                         };
)
AADD(sistema[14,O_FORMULA],{;          // TX2VIA - paga
     /* form mostrar  */    "LEFT(TRAN(IIF(TAXAS->valorpg>0,[Paga],[    ]),[]),04)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    53;
                         };
)


sistema[15]={;
            "Categoria dos Planos",;                        // opcao do menu
            "Categoria dos Planos",;                        // titulo do sistema
            {"classcod"},;                                  // chaves do arquivo
            {"Classe"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "CLASSES",;                                     // nome do DBF
            {"CLASSES1"},;                                  // nomes dos NTX
            {"CLPRODS"},;                                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,12,21,68},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(classcod)~Necess rio informar C¢DIGO",;
     /* help do campo */    "Informe um c¢digo para esta categoria";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "@!",;
     /* titulo        */    "Descri‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descricao)~Informe uma descri‡„o deste tipo de contrato.",;
     /* help do campo */    "Informe o nome desta categoria. Ex.: POPULAR, ESPECIAL,...";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "999999",;
     /* titulo        */    "Contratos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero de contratos desta categoria|Para categoria VIP, desconsidere esta informa‡„o";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "!",;
     /* titulo        */    "Prior",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "prior$' SN'~Necess rio informar PRIORIDADE",;
     /* help do campo */    "Os contratos enquadrados nesta categoria|ter„o cobran‡as emitidas periodicamente,|independente de n§ de falecimentos do grupo?";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Valor da J¢ia",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VLjoia<0.00)~Valor da j¢ia deve ser positivo",;
     /* help do campo */    "Informe o valor da J¢ia do contrato";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "N§Parcelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vljoia>0",;
     /* validacao     */    "!(nrparc<0)~NR.Parcelas n„o aceit vel",;
     /* help do campo */    "A j¢ia pode ser parcelada em quantas vezes?";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "N§Parcelas",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "vljoia>0",;
     /* validacao     */    "!(parcger<1 .OR. parcger>nrparc)~NR.Parcelas a gerar n„o aceit vel|",;
     /* help do campo */    "Gerar a partir da parcela de J¢ia de n§...";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99999999.99",;
     /* titulo        */    "Valor Mensal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor a acumular na cobran‡a|das taxas de manuten‡„o para esta categoria|";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99999999.99",;
     /* titulo        */    "V.p/Dependente",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(VLdepend<0.00)~Valor mensal cobrado a mais por|dependente deve ser maior ou igual a zeros",;
     /* help do campo */    "Informe o valor a ser acrescido por dependente";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "99",;
     /* titulo        */    "V lidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(nrmesval<0)~Validade n„o aceit vel",;
     /* help do campo */    "Contratos v lidos por quantos meses?";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "!",;
     /* titulo        */    "RenVencto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "renvenc$[ SN]~RENVENCTO n„o aceit vel",;
     /* help do campo */    "Os contratos terÆo|renova‡Æo automatica no vencimento?";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "!",;
     /* titulo        */    "RenUso",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "renuso$[ SN]~RENUSO n„o aceit vel",;
     /* help do campo */    "Os contratos terÆo|renova‡Æo automatica quando|utilizarem os servi‡os de atendimento/Auxilio?";
                         };
)
AADD(sistema[15,O_CAMPO],{;            // CLASSES
     /* mascara       */    "@E 99,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[15,O_FORMULA],{;          // CLASSES - Valor
     /* form mostrar  */    "LEFT(TRAN(vltotal,[@E 99,999,999.99]),13)",;
     /* lin da formula*/    16,;
     /* col da formula*/    39;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // CLASSES - Valor da J¢ia
     /* form mostrar  */    "LEFT(TRAN((vljoia/vltotal)*100,[999.99]),06)",;
     /* lin da formula*/    9,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // CLASSES - Valor Mensal
     /* form mostrar  */    "LEFT(TRAN((vlmensal/vltotal)*100,[999.99]),06)",;
     /* lin da formula*/    11,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[15,O_FORMULA],{;          // CLASSES - V.p/Dependente
     /* form mostrar  */    "LEFT(TRAN((vldepend/vltotal)*100,[999.99]),06)",;
     /* lin da formula*/    12,;
     /* col da formula*/    33;
                         };
)


sistema[16]={;
            "Produtos p/Categoria",;                        // opcao do menu
            "Produtos p/Categoria",;                        // titulo do sistema
            {"classcod+codigo"},;                           // chaves do arquivo
            {"C¢digo"},;                                    // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "CLPRODS",;                                     // nome do DBF
            {"CLPRODS1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"CLASSES->classcod"},;                         // campos de relacionamento
            {1,1,8,21,15,68,3,4},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[16,O_CAMPO],{;            // CLPRODS
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // CLPRODS
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'PRODUTOS',1)~C¢digo do PRODUTO inv lido.",;
     /* help do campo */    "Informe o c¢digo do produto";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // CLPRODS
     /* mascara       */    "9999",;
     /* titulo        */    "Qtdade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtdade<0)~QUANTIDADE nÆo aceit vel",;
     /* help do campo */    "Informe a quantidade do produto";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // CLPRODS
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // CLPRODS
     /* mascara       */    "",;
     /* titulo        */    "Usu rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_CAMPO],{;            // CLPRODS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[16,O_FORMULA],{;          // CLPRODS - Descri‡Æo do pr
     /* form mostrar  */    "LEFT(TRAN(PRODUTOS->produto,[@!]),30)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    16;
                         };
)


sistema[17]={;
            "Grupos",;                                      // opcao do menu
            "Grupos",;                                      // titulo do sistema
            {"grup"},;                                      // chaves do arquivo
            {"Grupo"},;                                     // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "ARQGRUP",;                                     // nome do DBF
            {"ARQGRUP1"},;                                  // nomes dos NTX
            {"FCGRUPO"},;                                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,15,22,62},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(grup)~Necess rio informar GRUPO",;
     /* help do campo */    "Entre com o c¢digo do Grupo";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "99",;
     /* titulo        */    "Classe",;
     /* cmd especial  */    "VDBF(6,38,20,77,'CLASSES',{'classcod','descricao','contrat'},1,'classcod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(classe,'CLASSES',1)~CLASSE n„o existe na tabela",;
     /* help do campo */    "Informe a categoria dos planos deste grupo.|Para grupo VIP, digite 00";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Nr.Inicial",;
     /* cmd especial  */    "",;
     /* default       */    "IF(classe=[00],[000001],STRZERO(VAL(M->lastcodigo)+1,6))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Nr.Final",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(classe=[00],[999999],STRZERO(VAL(inicio)+CLASSES->contrat-1,6))",;
     /* pre-validacao */    "",;
     /* validacao     */    "VAL(final)>VAL(inicio)~NR.FINAL n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "99",;
     /* titulo        */    "N§.Processos",;
     /* cmd especial  */    "",;
     /* default       */    "INT((1+VAL(final)-VAL(inicio))/50)",;
     /* pre-validacao */    "!(CLASSES->prior=[S])",;
     /* validacao     */    "!(acumproc<0)~N§.PROCESSOS n„o aceit vel",;
     /* help do campo */    "Informe quantos processos s„o nescess rios|para se emitir recibos.";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "99",;
     /* titulo        */    "N§.Processos",;
     /* cmd especial  */    "",;
     /* default       */    "acumproc",;
     /* pre-validacao */    "!(CLASSES->prior=[S])",;
     /* validacao     */    "maxproc>=acumproc~N§.PROCESSOS n„o aceit vel|Informe o n£mero m ximo de processos |a se incluir na circular",;
     /* help do campo */    "Informe o n£mero m ximo de processos|para se emitir na cobran‡a.";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "!",;
     /* titulo        */    "Comp.AdmissXAtend.",;
     /* cmd especial  */    "",;
     /* default       */    "[S]",;
     /* pre-validacao */    "!(CLASSES->prior=[S])",;
     /* validacao     */    "cpadmiss$[SN]~Digite S ou N|S, n„o ser„o incluidos atendimentos|efetuados antes da admiss„o do contrato.",;
     /* help do campo */    "Se digitar S, n„o ser„o incluidos atendimentos|efetuados antes da admiss„o do contrato|quando da 1¦Cobran‡a.";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Periodicidade",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(CLASSES->prior=[S],30,INT((VAL(final)-VAL(inicio)+1)*90/500))",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(periodic<0)~PERIODICIDADE n„o aceit vel",;
     /* help do campo */    "Informe o intervalo m¡nimo em dias entre circulares.";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Remido",;
     /* cmd especial  */    "",;
     /* default       */    "acumproc*5",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtdremir<0)~REMIDO n„o aceit vel",;
     /* help do campo */    "Entre com o n§ de taxas nescess rias para que|o processo fique remido.";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "!",;
     /* titulo        */    "P/Atend.",;
     /* cmd especial  */    "",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "poratend$[SN]~Digite|S para deixar de ser remido na utiliza‡„o|ou|N para continuar remido.",;
     /* help do campo */    "Digite S para considerar uma quantidade|a ser paga por atendimento efetuado|ou N para considerar quantidade total.";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Ultcirc",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "@D",;
     /* titulo        */    "Emissao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "Processos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Contratos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999999",;
     /* titulo        */    "Partic.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[17,O_CAMPO],{;            // ARQGRUP
     /* mascara       */    "999",;
     /* titulo        */    "N§Proxima Circ.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "proxcirc>=ultcirc.OR.proxcirc=[000]~A Pr¢xima circular deve ser maior|ou igual a| £ltima emitida ou zeros p/ n„o emitir.",;
     /* help do campo */    "Entre com o n£mero da pr¢xima circular ou|zeros se n„o for emitir.";
                         };
)
AADD(sistema[17,O_FORMULA],{;          // ARQGRUP - Classe/Categor.
     /* form mostrar  */    "LEFT(TRAN(CLASSES->descricao,[]),25)",;
     /* lin da formula*/    2,;
     /* col da formula*/    17;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // ARQGRUP - Ultcirc
     /* form mostrar  */    "LEFT(TRAN(ultcirc,[999]),03)",;
     /* lin da formula*/    13,;
     /* col da formula*/    19;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // ARQGRUP - Emissao
     /* form mostrar  */    "LEFT(TRAN(emissao_,[@D]),10)",;
     /* lin da formula*/    13,;
     /* col da formula*/    33;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // ARQGRUP - Processos
     /* form mostrar  */    "LEFT(TRAN(procpend,[999]),03)",;
     /* lin da formula*/    15,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // ARQGRUP - Contratos
     /* form mostrar  */    "LEFT(TRAN(contrat,[999999]),06)",;
     /* lin da formula*/    14,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[17,O_FORMULA],{;          // ARQGRUP - Partic.
     /* form mostrar  */    "LEFT(TRAN(partic,[999999]),06)",;
     /* lin da formula*/    14,;
     /* col da formula*/    27;
                         };
)


sistema[18]={;
            "Cobran‡as",;                                   // opcao do menu
            "Cobran‡as",;                                   // titulo do sistema
            {"grup+mesref"},;                               // chaves do arquivo
            {"C¢digo/Cobrador"},;                           // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "FCGRUPO",;                                     // nome do DBF
            {"FCGRUPO1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"ARQGRUP->grup"},;                             // campos de relacionamento
            {1,1,15,3,23,77,2,6},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Mes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "MMAA(mesref).AND.!EMPT(mesref)~MES n„o aceit vel",;
     /* help do campo */    "Informe o mes da cobran‡a.";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "999999",;
     /* titulo        */    "Qtdemit",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "999999",;
     /* titulo        */    "Qtdbaixa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "999999",;
     /* titulo        */    "Qtdret",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_CAMPO],{;            // FCGRUPO
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Total Entregue
     /* form mostrar  */    "LEFT(TRAN(vlentr,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    13;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Total recebido
     /* form mostrar  */    "LEFT(TRAN(vlreceb,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    30;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Total retorno
     /* form mostrar  */    "LEFT(TRAN(vlretorn,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    47;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Qtdemit
     /* form mostrar  */    "LEFT(TRAN(qtdemit,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    7;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Qtdbaixa
     /* form mostrar  */    "LEFT(TRAN(qtdpaga,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    24;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Qtdret
     /* form mostrar  */    "LEFT(TRAN(qtdret,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    41;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Qtd.Pendente
     /* form mostrar  */    "LEFT(TRAN(qtdemit-qtdpaga-qtdret,[99999]),05)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    58;
                         };
)
AADD(sistema[18,O_FORMULA],{;          // FCGRUPO - Valor pend.
     /* form mostrar  */    "LEFT(TRAN(vlentr-vlreceb-vlretorn,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    63;
                         };
)


sistema[19]={;
            "Regi”es",;                                     // opcao do menu
            "Regi”es",;                                     // titulo do sistema
            {"codigo","regiao"},;                           // chaves do arquivo
            {"p/C¢digo","Nome"},;                           // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "REGIAO",;                                      // nome do DBF
            {"REGIAO1","REGIAO2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,14,15,67,3,4},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"1=3","Opera‡„o n„o permitida|Arquivo Mantido pela Administradora"},;// condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[19,O_CAMPO],{;            // REGIAO
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // REGIAO
     /* mascara       */    "",;
     /* titulo        */    "Descri‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(regiao)~Necess rio informar a REGIAO",;
     /* help do campo */    "Informe o nome do bairro, distrito ou regi„o";
                         };
)
AADD(sistema[19,O_CAMPO],{;            // REGIAO
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,11,20,77,'COBRADOR',{'cobrador','nome','cidade'},1,'cobrador')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1).OR.EMPT(cobrador)~Necess rio informar COBRADOR",;
     /* help do campo */    "Informe o c¢digo do cobrador.|F8 consulta em tabela.";
                         };
)


sistema[20]={;
            "Cobradores/Vendedores",;                       // opcao do menu
            "Cobradores/Vendedores",;                       // titulo do sistema
            {"cobrador","nome"},;                           // chaves do arquivo
            {"C¢digo/Cobrador","Nome"},;                    // titulo dos indices para consulta
            {"01","03"},;                                   // ordem campos chaves
            "COBRADOR",;                                    // nome do DBF
            {"COBRADO1","COBRADO2"},;                       // nomes dos NTX
            {"PCBRAD","FCCOB"},;                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,16,66},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "COB_01F9()",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cobrador).AND.COB_02F9()~Necess rio informar COBRADOR",;
     /* help do campo */    "Informe um c¢digo para o cobrador.";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "!",;
     /* titulo        */    "Fun‡„o",;
     /* cmd especial  */    "MTAB([Cobrador|Vendedor|Lider|Supervisor|Outros],[FUN€ŽO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "funcao $ [CVLSO]~FUN€ŽO n„o aceit vel",;
     /* help do campo */    "Informe se ‚ um Cobrador ou Vendedor|";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Nome do Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME DO COBRADOR",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).OR.EMPT(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "@S35",;
     /* titulo        */    "Observa‡Æo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "999.9",;
     /* titulo        */    "Percentual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(percent<0).AND.!(percent>100)~PERCENTUAL n„o aceit vel",;
     /* help do campo */    "Informe o percentual de comiss„o";
                         };
)
AADD(sistema[20,O_CAMPO],{;            // COBRADOR
     /* mascara       */    "!!!",;
     /* titulo        */    "Supervisor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o c¢digo do SUPERVISOR deste cobrador";
                         };
)
AADD(sistema[20,O_FORMULA],{;          // COBRADOR - Fun‡„o
     /* form mostrar  */    "LEFT(TRAN(SUBSTR([Cobrador  |Vendedor  |Supervisor],AT(funcao,[Cobrador  |Vendedor  |Supervisor]),10),[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    35;
                         };
)


sistema[21]={;
            "Parcelas do Vendedor",;                        // opcao do menu
            "Parcelas do Vendedor",;                        // titulo do sistema
            {"cobrador+tipo+circ"},;                        // chaves do arquivo
            {"C¢digo/Cobrador"},;                           // titulo dos indices para consulta
            {"010203"},;                                    // ordem campos chaves
            "PCBRAD",;                                      // nome do DBF
            {"PCBRAD1"},;                                   // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"COBRADOR->cobrador"},;                        // campos de relacionamento
            {1,1,15,13,22,67,3,4},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "9",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnˆ|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "circ>[000]~Necess rio informar CIRCULAR",;
     /* help do campo */    "N£mero da Circular|Mantido pela emissao de recibos";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "!",;
     /* titulo        */    "Seg",;
     /* cmd especial  */    "MTAB([Sim, pode ser lan‡ado a parcela do seguro|N„o, acumule o seguro para a pr¢xima taxa.],[SEG])",;
     /* default       */    "[N]",;
     /* pre-validacao */    "",;
     /* validacao     */    "seg $ [SN]~SEG n„o aceit vel",;
     /* help do campo */    "Inclui o valor do seguro nesta taxa?|Digite S se o cobrador/vendedor repassar|o valor do seguro p/a Empresa";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "999.99",;
     /* titulo        */    "Comiss„o %",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "pcomiss>=0.and.pcomiss<=100~COMISSŽO % n„o aceit vel",;
     /* help do campo */    "Informe a % de comiss„o|ou zeros para informar|um valor fixo";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "pcomiss=0",;
     /* validacao     */    "vlcomiss>=0~VALOR n„o aceit vel",;
     /* help do campo */    "Informe o valor fixo de comiss„o";
                         };
)
AADD(sistema[21,O_CAMPO],{;            // PCBRAD
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[22]={;
            "Cobran‡as",;                                   // opcao do menu
            "Cobran‡as",;                                   // titulo do sistema
            {"cobrador+mesref"},;                           // chaves do arquivo
            {"C¢digo/Cobrador"},;                           // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "FCCOB",;                                       // nome do DBF
            {"FCCOB1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"COBRADOR->cobrador"},;                        // campos de relacionamento
            {1,1,15,3,23,77,2,6},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Mes",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "MMAA(mesref).AND.!EMPT(mesref)~MES n„o aceit vel",;
     /* help do campo */    "Informe o mes da cobran‡a.";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "999999",;
     /* titulo        */    "Qtdemit",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "999999",;
     /* titulo        */    "Qtdbaixa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "999999",;
     /* titulo        */    "Qtdret",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_CAMPO],{;            // FCCOB
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Total Entregue
     /* form mostrar  */    "LEFT(TRAN(vlentr,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    13;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Total recebido
     /* form mostrar  */    "LEFT(TRAN(vlreceb,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    30;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Total retorno
     /* form mostrar  */    "LEFT(TRAN(vlretorn,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    47;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Qtdemit
     /* form mostrar  */    "LEFT(TRAN(qtdemit,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    7;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Qtdbaixa
     /* form mostrar  */    "LEFT(TRAN(qtdpaga,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    24;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Qtdret
     /* form mostrar  */    "LEFT(TRAN(qtdret,[999999]),06)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    41;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Qtd.Pendente
     /* form mostrar  */    "LEFT(TRAN(qtdemit-qtdpaga-qtdret,[99999]),05)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    58;
                         };
)
AADD(sistema[22,O_FORMULA],{;          // FCCOB - Valor pend.
     /* form mostrar  */    "LEFT(TRAN(vlentr-vlreceb-vlretorn,[@E 999,999.99]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    63;
                         };
)


sistema[23]={;
            "Circulares",;                                  // opcao do menu
            "Circulares",;                                  // titulo do sistema
            {"grupo+circ"},;                                // chaves do arquivo
            {"Grupo/Circular"},;                            // titulo dos indices para consulta
            {"0102"},;                                      // ordem campos chaves
            "CIRCULAR",;                                    // nome do DBF
            {"CIRCULA1"},;                                  // nomes dos NTX
            {"CPRCIRC"},;                                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,7,15,18,66},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(grupo,'ARQGRUP',1).and.PTAB(ARQGRUP->classe,'CLASSES',1)~GRUPO ou Classe lan‡ada no Grupo|n„o existe na tabela.",;
     /* help do campo */    "Informe o grupo";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "STRZERO(VAL(ARQGRUP->proxcirc),3)",;
     /* default       */    "STRZERO(VAL(ARQGRUP->proxcirc),3)",;
     /* pre-validacao */    "nivelop=3",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da CIRCULAR a emitir.";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "99",;
     /* titulo        */    "Procpend",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar EMISSŽO",;
     /* help do campo */    "Data da Emiss„o da Circular";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Mˆs Ref.",;
     /* cmd especial  */    "",;
     /* default       */    "SUBSTR(DTOC(emissao_),4,2)+RIGHT(DTOC(emissao_),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(mesref).OR.!EMPT(CTOD([01/]+TRAN(mesref,[@R 99/99])))~MES REF. n„o aceit vel",;
     /* help do campo */    "Entre com o mˆs de referˆncia desta circular.";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@S35",;
     /* titulo        */    "Mensagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com uma mensagem exclusiva … ‚sta circular.";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@S35",;
     /* titulo        */    "Mensagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com uma mensagem exclusiva … ‚sta circular.";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@S35",;
     /* titulo        */    "Mensagem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com uma mensagem exclusiva … ‚sta circular.";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999999",;
     /* titulo        */    "Emitidos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999999",;
     /* titulo        */    "Pagos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "999999",;
     /* titulo        */    "Cancelados",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@D",;
     /* titulo        */    "Lancamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "",;
     /* titulo        */    "Usu rio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_CAMPO],{;            // CIRCULAR
     /* mascara       */    "@D",;
     /* titulo        */    "Impress„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[23,O_FORMULA],{;          // CIRCULAR - Descri‡„o
     /* form mostrar  */    "LEFT(TRAN(IIF(CLASSES->prior=[S],[Valor por mˆs......:],IIF(ARQGRUP->maxproc>ARQGRUP->acumproc,[Valor p/atendimento:],[Valor da circular.:])),[]),18)",;
     /* lin da formula*/    3,;
     /* col da formula*/    2;
                         };
)

* \\ Final de ADP_ATR1.PRG
