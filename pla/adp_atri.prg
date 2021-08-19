procedure adp_atri
/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: PresServ Inform tica - Limeira (019)452.6623
 \ Programa: ADP_ATRI.PRG
 \ Data....: 24-05-98
 \ Sistema.: Administradora - PLANO
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "adpbig.ch"    // inicializa constantes manifestas


/*
   A adicao das  definicoes dos campos (mascara, titulo, cmd esp, when/defa,
   critica, ajuda) dentro do vetor sistema e' feita atraves da funcao AADD(),
   isto previne erro "memory overbooked" do CA-Clipper, durante a compilacao,
   devido a linha ser muito extensa
*/

sistema[01]={;
            "Contratos",;                                   // opcao do menu
            "Contratos",;                                   // titulo do sistema
            {"codigo","situacao+codigo","grupo+cobrador+codigo","cobrador+grupo+codigo","nome"},;// chaves do arquivo
            {"Contrato","Ativos/Cancelados","Grupo/Cobrador","p/Cobrador","p/Nome"},;// titulo dos indices para consulta
            {"01","0301","022801","280201","04"},;          // ordem campos chaves
            "GRUPOS",;                                      // nome do DBF
            {"GRUPOS1","GRUPOS2","GRUPOS3","GRUPOS4","GRUPOS5"},;// nomes dos NTX
            {"ECOB","INSCRITS","TAXAS"},;                   // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,3,19,77},;                               // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de GERENTE"},;// condicao de exclusao de registros
            {"nivelop>1.and.!EMPT(M->usuario)","So altera este documento|o gerente de sistema (n¡vel 3)|e com nome definido."},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "GRU_02F9()",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB('',[ARQGRUP],1).AND.GRU_01F9()~CODIGO n„o aceit vel|N„o cadastrado na tabela de grupos",;
     /* help do campo */    "Entre com o n£mero do contrato";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(grupo,[ARQGRUP],1).AND.codigo<=ARQGRUP->final.AND.codigo>=ARQGRUP->inicio~CODIGO n„o aceit vel|N„o cadastrado na tabela de grupos",;
     /* help do campo */    "Informe um grupo valido para o contrato";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "9",;
     /* titulo        */    "Situa‡„o",;
     /* cmd especial  */    "MTAB([1=Ativo|2=Cancelado],[SITUA€ŽO])",;
     /* default       */    "[1]",;
     /* pre-validacao */    "",;
     /* validacao     */    "situacao $ [12345]~SITUA€ŽO n„o aceit vel",;
     /* help do campo */    "Digite 1 para ativo ou 2 para cancelado";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome).AND.GRU_05F9(nome)~Necess rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Nascto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de nascimento do titular";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "Est Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST CIVIL])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(estcivil$tbestciv)~Informe Estado Civil|ou|Tecle F8 para consulta em tabela",;
     /* help do campo */    "Digite o Estado Civil do Titular|ou|Tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VDV2(cpf).OR.EMPT(cpf)~CPF nÆo aceit vel",;
     /* help do campo */    "Informe o CIC (CPF) do titular";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "R.G.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do documento do titular";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "IIF(!EMPT(endereco),bskcepF9(endereco,bairro,cidade,1),[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Este endere‡o ser  utilizado na emissÆo das Taxas|para cobran‡a e em todas as telas de consulta.",;
     /* help do campo */    "Informe o Endere‡o para correspondˆncias.|Rua,n£mero,apto, blocl, etc...";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "IIF(!EMPT(bairro),bskcepF9(endereco,bairro,cidade,2),[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro ou regi„o do titular do contrato";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "IIF(!EMPT(cidade),bskcepF9(endereco,bairro,cidade,3),[])",;
     /* default       */    "M->p_cidade",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cidade)~Necess rio informar MUNICIPIO para cobran‡a do Titular.",;
     /* help do campo */    "Digite a Cidade para correspondˆncia.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR.EMPT(UF)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Qual ‚ o estado da federa‡„o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "bskcepF9(endereco,bairro,cidade,cep)",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP do Titular |com 08 digitos",;
     /* help do campo */    "Informe o CEP (8 digitos)|para facilitar a correspondˆncia";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@K!",;
     /* titulo        */    "Naturalidade",;
     /* cmd especial  */    "",;
     /* default       */    "M->p_cidade",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a naturalidade do titular";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Relig",;
     /* cmd especial  */    "__KEYBOARD([CATOLICO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a religi„o do titular";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o nome da pessoa para contato|";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero de telefone para|Contato com o contratante";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "TipCont",;
     /* cmd especial  */    "VDBF(6,20,20,77,'CLASSES',{'classcod','descricao','vljoia'},1,'classcod',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(tipcont,'CLASSES',1)~Informe a Classe deste contrato",;
     /* help do campo */    "Qual a categoria do Contrato?|Tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Vlcarne",;
     /* cmd especial  */    "VDBF(6,52,20,77,'TCARNES',{'tip','pari','vali','parf'},1,'tip',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Qual o c¢digo de classifica‡Æo do valor do contrato?|Tecle F8 para consultar tabela|Obs.|Ser  preenchido quando for lan‡ada a|venda do contrato.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "FormaPgto",;
     /* cmd especial  */    "",;
     /* default       */    "[03]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a forma de pagamento desejada|A Taxa de manuten‡Æo ser  emitida cada NN meses.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Seguro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Admiss„o",;
     /* cmd especial  */    "DATE()",;
     /* default       */    "DATE()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(admissao)~Necess rio informar DATA DE ADMISSŽO",;
     /* help do campo */    "Informe a data da Admiss„o neste contrato";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "T.Carˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "GRU_TCAR()",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de t‚rmino da Carˆncia";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@R 99/99",;
     /* titulo        */    "Saitxa",;
     /* cmd especial  */    "",;
     /* default       */    "GRU_STXA()",; //SUBSTR(DTOC(admissao+(CLASSES->nrparc*30)),4,2)+RIGHT(DTOC(admissao+(CLASSES->nrparc*30)),2)",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(CTOD('01/'+LEFT(saitxa,2)+'/'+RIGHT(saitxa,2))).OR.(nivelop=3.AND.saitxa=[9999])~Qual ser  o mˆs da primeira|cobranca autom tica deste contrato (MM/AA)",;
     /* help do campo */    "Informe o Mˆs a sair a 1¦ Taxa.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Dia Pgto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "diapgto<[31]~DIA PGTO. n„o aceit vel|Digite um dia entre 01 e 30|ou|deixe com 00 para data igual ao grupo",;
     /* help do campo */    "Informe o melhor dia para pagamento";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!!",;
     /* titulo        */    "Vendedor",;
     /* cmd especial  */    "VDBF(6,7,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade'},1,'cobrador')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(vendedor).OR.GRU_03F9()~VENDEDOR n„o existe na tabela",;
     /* help do campo */    "Informe o c¢digo do Vendedor|ou|Tecle F8 para consulta em arquivo";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Regi„o",;
     /* cmd especial  */    "VDBF(6,38,20,77,'REGIAO',{'codigo','regiao'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(regiao,'REGIAO',1).OR.EMPT(VAL(regiao))~REGIŽO n„o existe na tabela",;
     /* help do campo */    "Informe a regi„o ou tecle F8 para busca em tabela";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,30,20,77,'REGIAO',{'codigo','regiao','cobrador'},1,'cobrador')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "EMPT(cobrador).OR.GRU_04F9()~COBRADOR n„o existe na tabela",;
     /* help do campo */    "Digite o c¢digo do COBRADOR que|receber  as Taxas deste contrato,|Tecle F8 para consultar os cobradores.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@S60",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Renovar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Data final para renova‡Æo";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Funerais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(funerais<0)~FUNERAIS n„o aceit vel",;
     /* help do campo */    "N£mero de Funerais efetuados|para este processo";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Circ.Inicial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da 1¦ Circular|que saiu para este contrato.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Ult.Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(grupo+ultcirc,'CIRCULAR',1).OR.ultcirc=[000].or.nivelop==3~ULT.CIRCULAR n„o cadastrada em tabela",;
     /* help do campo */    "Entre com o £ltimo n£mero de circular|deste contrato.";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Qt.Circulares",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "999",;
     /* titulo        */    "Circ.Pagas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a quantidade de Circulares|pagas/retornadas deste contrato";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Titular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Part.Vivos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "Part.Falecidos",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "99",;
     /* titulo        */    "N§ Depend.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "Ult.Impress.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "@D",;
     /* titulo        */    "élt.alter.endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "UltEnd",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // GRUPOS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Situacao
     /* form mostrar  */    "LEFT(TRAN(IIF(situacao=[2],[CANCELADO],[         ]),[]),09)",;
     /* lin da formula*/    1,;
     /* col da formula*/    62;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Part.Vivos
     /* form mostrar  */    "LEFT(TRAN(particv,[99]),02)",;
     /* lin da formula*/    15,;
     /* col da formula*/    24;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Part.Falecidos
     /* form mostrar  */    "LEFT(TRAN(particf,[99]),02)",;
     /* lin da formula*/    15,;
     /* col da formula*/    38;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Nome do Cobrado
		 /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(cobrador,'COBRADOR',1),COBRADOR->nome,space(30)),[]),30)",;
		 /* lin da formula*/    13,;
		 /* col da formula*/    16;
												 };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Nome do Vendedr
		 /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(vendedor,'COBRADOR',1),COBRADOR->nome,space(30)),[]),30)",;
     /* lin da formula*/    11,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - grupo
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(grupo),grupo,[  ]),[]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    18;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Descri‡„o Reg
     /* form mostrar  */    "LEFT(TRAN(REGIAO->regiao,[]),30)",;
     /* lin da formula*/    12,;
     /* col da formula*/    16;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Est.Civil
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(estcivil),SUBS(tbestciv,AT(estcivil,tbestciv),11),[]),[]),11)",;
     /* lin da formula*/    4,;
     /* col da formula*/    13;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - N§ Depend.
     /* form mostrar  */    "LEFT(TRAN(nrdepend,[99]),02)",;
     /* lin da formula*/    15,;
     /* col da formula*/    54;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Ult.Impress.
		 /* form mostrar  */    "LEFT(TRAN(ultimp_,[@D]),10)+[ ]+por",;
		 /* lin da formula*/    16,;
		 /* col da formula*/    50;
												 };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - élt.alter.ender
		 /* form mostrar  */    "LEFT(TRAN(ender_,[@D]),10)",;
		 /* lin da formula*/    16,;
		 /* col da formula*/    17;
												 };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - UltEnd
     /* form mostrar  */    "LEFT(TRAN(ultend,[]),10)",;
     /* lin da formula*/    16,;
     /* col da formula*/    28;
												 };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Seguro
     /* form mostrar  */    "LEFT(TRAN(IIF(seguro>0,'SEGURO ('+str(seguro,2)+')',[   ]),[]),12)",;
     /* lin da formula*/    1,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Qt.Circulares
     /* form mostrar  */    "LEFT(TRAN(qtcircs,[999]),03)",;
     /* lin da formula*/    0,;
     /* col da formula*/    0;
                         };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - periodicidade
		 /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(tipcont,'CLASSES',1),ALLTRIM(CLASSES->descricao),[])+[ ]+SUBSTR(tbfpgto,VAL(formapgto)*13+1,13),[]),35)",;
		 /* lin da formula*/    9,;
		 /* col da formula*/    39;
												 };
)
AADD(sistema[01,O_FORMULA],{;          // GRUPOS - Idade
		 /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(nascto_),LEFT(DLAPSO(DATE(),nascto_),10),[          ]),[]),10)",;
		 /* lin da formula*/    3,;
		 /* col da formula*/    64;
												 };
)

sistema[02]={;
						"Outros Endere‡os",;                            // opcao do menu
						"Outros Endere‡os",;                            // titulo do sistema
						{"codigo+tipo"},;                               // chaves do arquivo
						{"Contrato"},;                                  // titulo dos indices para consulta
						{"0102"},;                                      // ordem campos chaves
						"ECOB",;                                        // nome do DBF
						{"ECOB1"},;                                     // nomes dos NTX
						{},;                                            // nome dos dbf's relacionados
						{"GRUPOS->codigo"},;                            // campos de relacionamento
						{1,1,8,17,16,65},;                              // num telas/tela atual/coordenadas
						{1,.t.},;                                       // nivel acesso/tp chave
						{},;                                            // campos do arquivo
						{},;                                            // formula mostradas
						{"",""},;                                       // condicao de exclusao de registros
						{"",""},;                                       // condicao de alteracao de registros
						{"",""};                                        // condicao de recupercao de registros
					 }

AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([Residˆncia|Trabalho|Outro|Co-Resp.],[TIPO])",;
     /* default       */    "[R]",;
     /* pre-validacao */    "MTAB([Residˆncia|Trabalho|Outro|Co-Resp.],[TIPO])",;
     /* validacao     */    "tipo $ [RTOC]~TIPO n„o aceit vel|Apenas endere‡os de Residˆncia e Trabalho.",;
     /* help do campo */    "Informe que tipo de Endere‡o ‚ este.|R=Residˆncia, T=Trabalho";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(endereco)~Informe a localiza‡„o ou tecle ESC para cancelar",;
     /* help do campo */    "Informe o Endere‡o|Rua,n£mero,apto, blocl, etc...";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite o Bairro|ou complemento| do endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o CEP para facilitar a localiza‡„o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade/Municipio";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf).OR. EMPT(uf)~UNIDADE DA FEDERA€ŽO inv lida",;
     /* help do campo */    "Informe o Estado.|Ex.: SP,RJ,GO,AM,...";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@!",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do telefone para contato";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@S20",;
     /* titulo        */    "Obs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // ECOB
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_FORMULA],{;          // ECOB - Tipo
     /* form mostrar  */    "LEFT(TRAN(IIF(tipo=[R],[Residˆncia],IIF(tipo=[T],[Trabalho],[Outro])),[]),12)",;
     /* lin da formula*/    1,;
     /* col da formula*/    15;
                         };
)
AADD(sistema[02,O_FORMULA],{;          // ECOB - Data
     /* form mostrar  */    "LEFT(TRAN(data_,[@D]),10)",;
     /* lin da formula*/    7,;
     /* col da formula*/    39;
                         };
)


sistema[03]={;
            "Inscritos",;                                   // opcao do menu
            "Inscritos",;                                   // titulo do sistema
            {"codigo+grau+STR(seq,02,00)","nome"},;         // chaves do arquivo
            {"Contrato","p/Nome"},;                         // titulo dos indices para consulta
            {"010203","05"},;                               // ordem campos chaves
            "INSCRITS",;                                    // nome do DBF
            {"INSCRIT1","INSCRIT2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"GRUPOS->codigo"},;                            // campos de relacionamento
            {1,1,17,3,23,77},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* default       */    "IIF(M->pgrau<[7],SUBSTR([234567],VAL(M->pgrau),1),M->pgrau)",;
     /* pre-validacao */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* validacao     */    "grau $ [123456789]~INSCR. n„o aceit vel",;
     /* help do campo */    "Informe o grau de liga‡„o deste com o|titular do contrato|ou|tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "INS_01F9()",;
     /* pre-validacao */    "grau>[6]",;
     /* validacao     */    "seq>0~SEQ n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Titular?",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@!",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(grau=[1],GRUPOS->nome,[ ])",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nome)~Necess rio informar NOME",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "Nascto",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(grau=[1],GRUPOS->nascto_,ctod('  /  /  '))",;
     /* pre-validacao */    "",;
     /* validacao     */    "INS_02F9()~NASCTO n„o aceit vel",;
     /* help do campo */    "Informe a Data de Nascimento deste Inscrito";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "Est Civil",;
     /* cmd especial  */    "MTAB(tbestciv,[EST CIVIL])",;
     /* default       */    "IIF(grau<[7],[CA],[SO])",;
     /* pre-validacao */    "MTAB(tbestciv,[EST CIVIL])",;
     /* validacao     */    "(ESTCIVIL$tbestciv)~Necess rio informar ESTADO CIVIL|ou tecle F8",;
     /* help do campo */    "Digite o Estado Civil do Falecido";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Interdito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Sexo",;
     /* cmd especial  */    "",;
     /* default       */    "IIF(grau$[124],[M],IIF(grau$[356],[F],[ ]))",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Digite M ou F |(Masculino ou Feminino)";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "T.Carˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "INS_TCAR()",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "Lan‡to.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "V/F",;
     /* cmd especial  */    "MTAB([Vivo|Falecido],[V/F])",;
     /* default       */    "[V]",;
     /* pre-validacao */    "",;
     /* validacao     */    "vivofalec$[VF]~Necess rio informar VIVOFALEC",;
     /* help do campo */    "Vivo ou Falecido";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@D",;
     /* titulo        */    "Falecto.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Entre com a data de falecimento";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!!!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([Funeral|Auxilio],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Com Direitos (Funeral) ou com Auxilio.";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "@R 99999/99",;
     /* titulo        */    "N§Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "vivofalec==[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do processo";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // INSCRITS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_FORMULA],{;          // INSCRITS - graupart
     /* form mostrar  */    "LEFT(TRAN(SUBSTR([TitPaiMaeSgoSgaEspFilDep],(VAL(grau)-1)*3+1,3),[]),03)",;
     /* lin da formula*/    1,;
     /* col da formula*/    13;
                         };
)
AADD(sistema[03,O_FORMULA],{;          // INSCRITS - Lan‡to.
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    50;
                         };
)
AADD(sistema[03,O_FORMULA],{;          // INSCRITS - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    61;
                         };
)
AADD(sistema[03,O_FORMULA],{;          // INSCRITS - Idade
     /* form mostrar  */    "LEFT(TRAN(IIF(!EMPT(nascto_),LEFT(DLAPSO(DATE(),nascto_),12),[            ]),[]),12)",;
     /* lin da formula*/    3,;
     /* col da formula*/    62;
                         };
)


sistema[04]={;
            "Taxas",;                                       // opcao do menu
            "Cadastro de Taxas",;                           // titulo do sistema
            {"codigo+tipo+circ","tipo","DTOS(emissao_)","cobrador","codlan"},;// chaves do arquivo
            {"Contrato/Circular","Tipo de taxa","Emiss„o","Cobrador","Cod.Lanc"},;// titulo dos indices para consulta
            {"010203","02","04","08","15"},;          // ordem campos chaves
            "TAXAS",;                                       // nome do DBF
            {"TAXAS1","TAXAS2","TAXAS3","TAXAS4","TAXAS5"},;// nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {"GRUPOS->codigo"},;                            // campos de relacionamento
            {1,1,13,1,23,77,3,7},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de GERENTE"},;// condicao de exclusao de registros
            {"nivelop>1.and.!EMPT(M->usuario)","So altera este documento|o gerente de sistema (n¡vel 3)|e com nome definido."},;// condicao de alteracao de registros
            {"nivelop>1","Permitido apenas a usu rios cadastrados|com n¡vel de Manuten‡„o ou Maior"};// condicao de recupercao de registros
           }

AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "9",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia |2=Taxa |3=Carnˆ|6=J¢ia+Seguro|7=Taxa+Seguro|8=Carnˆ+Seguro],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [123456789].AND.(PTAB(codigo,'GRUPOS',1).AND.PTAB(GRUPOS->tipcont,'CLASSES',1).OR.(1=1))~TIPO n„o aceit vel",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(circ).AND.(tipo$[16].OR.PTAB(GRUPOS->grupo+circ,'CIRCULAR',1))~Necess rio informar CIRCULAR v lida",;
     /* help do campo */    "Informe o n£mero da circular a consultar";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Emissao",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar EMISSAO v lida",;
     /* help do campo */    "Data da Emiss„o da Circular|Mantido pela emissao do recibo";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de pagamento/Baixa";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@E 999,999.99",;
     /* titulo        */    "Valor pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(valorpg<0)~VALOR PAGO n„o aceit vel",;
     /* help do campo */    "Informe o valor pago/baixado";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!!!",;
     /* titulo        */    "Cobrador",;
     /* cmd especial  */    "VDBF(6,3,20,77,'COBRADOR',{'cobrador','funcao','nome','cidade','telefone'},1,'cobrador',[])",;
     /* default       */    "GRUPOS->cobrador",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cobrador,'COBRADOR',1).AND.(PTAB(cobrador+M->mmesref,'FCCOB',1).OR.1=1)~Problemas encontrados no arquivo Cobrador ou |Circular do grupo n„o cadastrada para|este cobrador.",;
     /* help do campo */    "Informe o Cobrador que recebeu este.";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Forma",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "forma$[PCR ]~FORMA n„o aceit vel",;
     /* help do campo */    "Esta lan‡amento foi Pago ou Cancelado|Deixe sem preencher se ainda em aberto";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@D",;
     /* titulo        */    "Baixa_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "9",;
     /* titulo        */    "Status",;
     /* cmd especial  */    "MTAB([1=Gerada|2=Impressa|6=Pg Recep‡„o|7=Bx.p/FCC|9=Bx.Plano],[STATUS])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "stat $ [12679]~STATUS n„o aceit vel",;
     /* help do campo */    "Informe a situa‡„o deste recibo|Tecle F8 para busca em tabela";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!",;
     /* titulo        */    "Flag",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // TAXAS
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[04,O_FORMULA],{;          // TAXAS - Status
     /* form mostrar  */    "LEFT(TRAN(TAX_02F9(),[]),10)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    64;
                         };
)
AADD(sistema[04,O_FORMULA],{;          // TAXAS - Por
     /* form mostrar  */    "LEFT(TRAN(LEFT(por,9),[]),09)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    0;
                         };
)
AADD(sistema[04,O_FORMULA],{;          // TAXAS - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    73;
                         };
)
AADD(sistema[04,O_FORMULA],{;          // TAXAS - Tipo
     /* form mostrar  */    "LEFT(TRAN(SUBSTR('J¢ia Taxa Carnˆ          J+SegT+SegC+Seg',(VAL(tipo)-1)*5+1,5),[]),05)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    3;
                         };
)


sistema[05]={;
            "Cancelamentos",;                               // opcao do menu
            "Cancelamentos",;                               // titulo do sistema
            {"cnumero","ccodigo"},;                         // chaves do arquivo
            {"p/N£mero","p/C¢digo"},;                       // titulo dos indices para consulta
            {"01","03"},;                                   // ordem campos chaves
            "CANCELS",;                                     // nome do DBF
            {"CANCELS1","CANCELS2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,8,2,19,79,3,8},;                           // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "999999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cnumero)~Necess rio informar N£MERO",;
     /* help do campo */    "";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo',[situacao!='2'])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(ccodigo,'GRUPOS',1).AND.CAD_04F9(op_menu)~CODIGO n„o aceit vel",;
     /* help do campo */    "Entre com o n£mero do contrato";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "!!",;
     /* titulo        */    "Grupo",;
     /* cmd especial  */    "VDBF(6,51,20,77,'ARQGRUP',{'grup','classe','inicio','final'},1,'grup',[])",;
     /* default       */    "GRUPOS->grupo",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(cgrupo,'ARQGRUP',1)~GRUPO n„o existe na tabela",;
     /* help do campo */    "Entre com o grupo ou |tecle F8 para consulta em tabela";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "",;
     /* titulo        */    "Motivo",;
     /* cmd especial  */    "MTAB([Falta pgto|Mudou|Sem cond financeiras|Insatisfeito c/convenio|Venda mal explicada|Endereco inexistente|Associado nao encotrado|Ignorado|Desistˆncia],[MOTIVO])",;
     /* default       */    "",;
     /* pre-validacao */    "MTAB([Falta pgto|Mudou|Sem cond financeiras|Insatisfeito c/convenio|Venda mal explicada|Endereco inexistente|Associado nao encotrado|Ignorado|Desistˆncia],[MOTIVO])",;
     /* validacao     */    "!EMPT(cmotivo)~Necess rio informar MOTIVO",;
     /* help do campo */    "Entre com a justificativa";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // CANCELS
     /* mascara       */    "@D",;
     /* titulo        */    "Procto_",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[05,O_FORMULA],{;          // CANCELS - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),25)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    42;
                         };
)
AADD(sistema[05,O_FORMULA],{;          // CANCELS - data
     /* form mostrar  */    "LEFT(DTOC(IIF(EMPT(lancto_),DATE(),lancto_)),6)+right(DTOC(IIF(EMPT(lancto_),DATE(),lancto_)),2)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    69;
                         };
)
AADD(sistema[05,O_FORMULA],{;          // CANCELS - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    {||l_a},;
     /* col da formula*/    8;
                         };
)


sistema[06]={;
            "Processos",;                                   // opcao do menu
            "Processos",;                                   // titulo do sistema
            {"processo+categ","grup+DTOS(dfal)","fal+DTOS(dfal)","DTOS(dfal)","codlan"},; // chaves do arquivo
            {"p/Processo","Grupo+Data","Falecido+Data","Data","Cod.Lanc"},;        // titulo dos indices para consulta
            {"0102","0413","1113","13","14"},;                          // ordem campos chaves
            "PRCESSOS",;                                    // nome do DBF
            {"PRCESSO1","PRCESSO2","PRCESSO3","PRCESSO4","PRCESSO5"},;            // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,5,14,19,68},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"EMPT(saiu)","J  emitido nas Taxas|Exclusao nao permitida"},;// condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@R 99999/99/!!",;
     /* titulo        */    "Processo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(processo)~Necess rio informar PROCESSO",;
     /* help do campo */    "Informe o n£mero do processo a incluir";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "!!",;
     /* titulo        */    "Categoria",;
     /* cmd especial  */    "MTAB([PL=Plano|PD=Plano c/Diferen‡a|AF=Auxilio],[CATEGORIA])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "categ $ [PL|PD|AF]~CATEGORIA n„o aceit vel",;
     /* help do campo */    "Preencha com:|PL para Plano,| PD p/Diferen‡a ou |AX para Aux.Funeral";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "",;
     /* titulo        */    "Saiu",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Preencha com o n£mero da circular|ou|deixe em branco se ainda n„o saiu em cobran‡a";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "!!",;
     /* titulo        */    "Grup",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(grup).AND.PTAB(grup,'ARQGRUP',1)~GRUP n„o existe na tabela",;
     /* help do campo */    "Pertence a qual grupo";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "999999",;
     /* titulo        */    "Num",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(num).AND.PTAB(num,'GRUPOS',1)~NUM n„o existe na tabela",;
     /* help do campo */    "Qual contrato";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "9",;
     /* titulo        */    "Inscr.",;
     /* cmd especial  */    "MTAB(M->TBTIPGRAU,[INSCR.])",;
     /* default       */    "IIF(M->pgrau<[7],SUBSTR([1234567],VAL(M->pgrau),1),M->pgrau)",;
     /* pre-validacao */    "",;
     /* validacao     */    "grau $ [12345678].and.(PTAB(num,'INSCRITS',1).or.1=1)~INSCR. n„o aceit vel",;
     /* help do campo */    "Qual o grau de parentesco|Tecle F8 para consulta";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "99",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "grau>'6'",;
     /* validacao     */    "",;
     /* help do campo */    "Que sequencia";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Seg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Nome do segurado/Contratante";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Ends",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Bais",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Cids",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Fal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(fal)~Necess rio informar FAL",;
     /* help do campo */    "Nome do falecido";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@!",;
     /* titulo        */    "Sep",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(sep)~Necess rio informar SEP",;
     /* help do campo */    "Sepultado em";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Data do falecimento";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // PRCESSOS
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_FORMULA],{;          // PRCESSOS - T.Carˆncia
     /* form mostrar  */    "LEFT(TRAN(IIF(INSCRITS->tcarencia>dfal,[Carˆncia do Inscrito],[]),[]),22)",;
     /* lin da formula*/    4,;
     /* col da formula*/    29;
                         };
)


sistema[07]={;
            "Lan‡amento/Carnˆs",;                           // opcao do menu
            "Lan‡amento/Carnˆs",;                           // titulo do sistema
            {"seq","codigo"},;                              // chaves do arquivo
            {"N£mero","Contrato"},;                         // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "EMCARNE",;                                     // nome do DBF
            {"EMCARNE1","EMCARNE2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,7,13,19,70},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "999999",;
     /* titulo        */    "Seq",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "999999",;
     /* titulo        */    "Codigo",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},3,'codigo')",;
     /* default       */    "EMC_02F9()",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(codigo,'GRUPOS',1).AND.!(GRUPOS->situacao=[2])~Contrato inexistente|ou |Cancelado.|Verifique",;
     /* help do campo */    "Informe o n£mero do contrato|a gerar a cobran‡a";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "!!!",;
     /* titulo        */    "Vendedor",;
     /* cmd especial  */    "VDBF(6,11,20,77,'COBRADOR',{'cobrador','nome','cidade'},1,'cobrador',[])",;
     /* default       */    "GRUPOS->vendedor",;
     /* pre-validacao */    "",;
		 /* validacao     */    "GRU_03F9().AND.(PTAB(GRUPOS->tipcont,'CLASSES',1).OR.1=1)~Informe o Vendedor|ou|Tecle F8 para consulta",;
     /* help do campo */    "Informe o c¢digo do vendedor|ou|Cobrador desta taxa";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "VDBF(6,43,20,77,'TCARNES',{'tip','tipcob','formapgto','pari','parf','vali'},1,'tip',[])",;
     /* default       */    "GRUPOS->vlcarne",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(tip,'TCARNES',1)~TIPO n„o existe na tabela|Tecle F8 para consultar em tabela",;
     /* help do campo */    "Informe o tipo de tabela de venda|a utilizar na gera‡„o desta cobran‡a";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "999",;
     /* titulo        */    "Circular",;
     /* cmd especial  */    "",;
     /* default       */    "[001]",;
     /* pre-validacao */    "",;
     /* validacao     */    "(circ>[000]).AND.!PTAB(codigo+TCARNES->tipcob+circ,'TAXAS',1)~CIRCULAR j  cadastrada|ou|com n£mero inv lido.",;
     /* help do campo */    "Informe o n£mero da primeira parcela a gerar";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "@D",;
     /* titulo        */    "Vencto",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencto_)~Necess rio informar VENCTO",;
     /* help do campo */    "Entre com a data do vencimento da 1¦Parcela";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data em que foi emitido o carnˆ|para emiti-lo, deixe sem preencher";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "@D",;
     /* titulo        */    "Etiqueta",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a data de emiss„o das etiquetas|para emitir, deixe sem preencher";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "@!",;
     /* titulo        */    "Filial",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "@D",;
     /* titulo        */    "Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "",;
     /* titulo        */    "Por",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "99",;
     /* titulo        */    "PFim",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // EMCARNE
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Nome
     /* form mostrar  */    "LEFT(TRAN(GRUPOS->nome,[]),35)",;
     /* lin da formula*/    3,;
     /* col da formula*/    21;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - TAXAS OK
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(codigo,[TAXAS],1),[TAXAS EXISTENTES],[ ]),[]),16)",;
     /* lin da formula*/    4,;
     /* col da formula*/    3;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Nome do Vendedo
     /* form mostrar  */    "LEFT(TRAN(IIF(PTAB(vendedor,'COBRADOR',1),COBRADOR->nome,[ ]),[]),30)",;
     /* lin da formula*/    5,;
     /* col da formula*/    21;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - PIni
     /* form mostrar  */    "LEFT(TRAN(left(CLASSES->classcod+' '+CLASSES->descricao,30),[]),30)",;
     /* lin da formula*/    4,;
     /* col da formula*/    21;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Filial
     /* form mostrar  */    "LEFT(TRAN(filial,[@!]),02)",;
     /* lin da formula*/    1,;
     /* col da formula*/    29;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Tipo
     /* form mostrar  */    "LEFT(TRAN(TCARNES->tipcob,[!]),01)",;
     /* lin da formula*/    7,;
     /* col da formula*/    30;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - FormaPgto
     /* form mostrar  */    "LEFT(TRAN(IIF(TCARNES->formapgto=[01],[01 mes.],TCARNES->formapgto+[ meses.]),[]),08)",;
     /* lin da formula*/    7,;
     /* col da formula*/    39;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - PFim
     /* form mostrar  */    "LEFT(TRAN(TCARNES->parf,[99]),02)",;
     /* lin da formula*/    6,;
     /* col da formula*/    27;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Val.Inic.
     /* form mostrar  */    "LEFT(TRAN(TCARNES->vali/TCARNES->parf,[99999.99]),08)",;
     /* lin da formula*/    6,;
     /* col da formula*/    42;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - obs
     /* form mostrar  */    "LEFT(TRAN(IIF(TCARNES->pari=2,[N„o gerar a primeira parcela],IIF(TCARNES->pari>2,[N„o gerar as ]+str(TCARNES->pari-1,1)+[ primeiras parcelas],[ ])),[]),30)",;
     /* lin da formula*/    9,;
     /* col da formula*/    2;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - nr.final
     /* form mostrar  */    "LEFT(TRAN(RIGHT('000'+ALLTRIM(STR(VAL(circ)-1+TCARNES->parf)),3),[999]),03)",;
     /* lin da formula*/    8,;
     /* col da formula*/    22;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Lan‡amento
     /* form mostrar  */    "LEFT(TRAN(lancto_,[@D]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    34;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - Por
     /* form mostrar  */    "LEFT(TRAN(por,[]),10)",;
     /* lin da formula*/    1,;
     /* col da formula*/    45;
                         };
)
AADD(sistema[07,O_FORMULA],{;          // EMCARNE - PFim
     /* form mostrar  */    "LEFT(TRAN(parok,[99]),02)",;
     /* lin da formula*/    9,;
     /* col da formula*/    34;
                         };
)


sistema[08]={;
            "Tabela",;                                      // opcao do menu
            "Tabela",;                                      // titulo do sistema
            {"tip","STR(parf,02,00)+tipcob+STR(vali,08,02)"},;// chaves do arquivo
            {"p/C¢digo","Parcelas"},;                       // titulo dos indices para consulta
            {"01","060205"},;                               // ordem campos chaves
            "TCARNES",;                                     // nome do DBF
            {"TCARNES1","TCARNES2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,17,16,63},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "99",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia |2=Taxa |3=Carnˆ],[TIPO])",;
     /* default       */    "[1]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipcob $ [123456789]~TIPO n„o aceit vel",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "99",;
     /* titulo        */    "FormaPgto",;
     /* cmd especial  */    "",;
     /* default       */    "[01]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a forma de pagamento desejada|A Taxa de manuten‡„o ser  emitida cada NN meses.";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "9",;
     /* titulo        */    "PIni",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "pari>0~PINI n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da primeira|parcela a lan‡ar.";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "99999.99",;
     /* titulo        */    "Val.Inic.",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(vali<0)~VAL.INIC. n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "99",;
     /* titulo        */    "PFim",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "parf>=pari~PFIM n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TCARNES
     /* mascara       */    "9",;
     /* titulo        */    "PMeio",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[09]={;
            "Custos Adicionais",;                           // opcao do menu
            "Custos Adicionais",;                           // titulo do sistema
            {"DTOS(emissao_)","historic+contrato","contrato+tipo+circ","circ+contrato"},;// chaves do arquivo
            {"Ocorrencia","Hist¢rico","Contrato","N§Cobran‡a"},;// titulo dos indices para consulta
            {"01","0405","050910","1005"},;                 // ordem campos chaves
            "CSTSEG",;                                      // nome do DBF
            {"CSTSEG1","CSTSEG2","CSTSEG3","CSTSEG4"},;     // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,13,66},;                              // num telas/tela atual/coordenadas
            {1,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {},;                                            // formula mostradas
            {"",""},;                                       // condicao de exclusao de registros
            {"",""},;                                       // condicao de alteracao de registros
            {"",""};                                        // condicao de recupercao de registros
           }

AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "DATE()",;
     /* default       */    "date()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao_)~Necess rio informar DATA DE EMISSAO v lida",;
     /* help do campo */    "Informe a data da gera‡„o desta cobran‡a";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "99:99",;
     /* titulo        */    "Hora",;
     /* cmd especial  */    "",;
     /* default       */    "TIME()",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(hora)~Necess rio informar HORA",;
     /* help do campo */    "Informe a hora|Se necess rio";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "",;
     /* titulo        */    "Quem",;
     /* cmd especial  */    "",;
     /* default       */    "M->usuario",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(historic,'HISTORIC',1)~Este ‚ um campo de preenchimento obrigat¢rio.|Tecle F8 para busca em tabela",;
     /* help do campo */    "Entre com um c¢digo para identificar| a cobran‡a";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999999",;
     /* titulo        */    "Contrato",;
     /* cmd especial  */    "VDBF(6,26,20,77,'GRUPOS',{'grupo','codigo','nome'},1,'codigo')",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(contrato,'GRUPOS',1)~Contrato inv lido |ou inexistente",;
     /* help do campo */    "Informe o n£mero do contrato";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(complement)~Entre com uma informa‡„o que diferencie este|lan‡amento de outros com mesmo hist¢rico.",;
     /* help do campo */    "Informe algo para identificar esta cobran‡a";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "99999",;
     /* titulo        */    "Qtdade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(qtdade<0)~Informe uma quantidade v lida (>=0)",;
     /* help do campo */    "";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!(valor=0)~VALOR n„o aceit vel|Deve ser diferente de zeros",;
     /* help do campo */    "Informe o valor do servi‡o";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "9",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([1=J¢ia|2=Taxa|3=Carnˆ],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Qual o tipo de lan‡amento";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // CSTSEG
     /* mascara       */    "999",;
     /* titulo        */    "Circ",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "(PTAB(contrato+tipo+circ,'TAXAS',1).AND.TAXAS->valorpg=0).or.circ<[001]~Taxa n„o cadastrada,|ou,| j  paga.",;
     /* help do campo */    "Informe o n£mero da circular a consultar";
                         };
)

* \\ Final de ADP_ATRI.PRG
