/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Funer ria GULLO Ltda.
 \ Programa: ADM_PUBL.CH
 \ Data....: 21-04-95
 \ Sistema.: Controle de Processos da Funer ria.
 \ Funcao..: Define vari veis p£blicas
 \ Analista: Ademilson Pedro Bom
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
tbestciv   :=[SOlteiro   |CAsado     |VIuvo      |DEsquitado |OUtro      |IGnorado   |JUdici.sep.|COncens.sep]
tbestcivf  :=[SOlteira   |CAsada     |VIuva      |DEsquitada |OUtro      |IGnorado   |JUdici.sep.|COncens.sep]
tbsexo     :=[Masculino  |Feminino   |Ignorado   ]
tbgrauinstr:=[Nenhuma    |Fundamental|2§ grau    |Superior   |Ignorado   ]
tbtipgrau  :=[1-Titular|2-Pai|3-M„e|4-Sogro|5-Sogra|6-Conjuge|7-Filhos|8-Depend.|9-Outros.]
tbtipidade:=[ANos |MEses|DIas |HOras|MInut]
tbunid:=[UN=Unidade|CX=Caixa  |MT=Metro  |KG=Quilo  |LT=Litro ]
tbfpgto:=[             Mensal       Bimestral    Trimestral   Quadrimestral]+;
         [             Semestral                              ]+;
         [                                       Anual        ]
SET EPOCH TO 1940          // prepara datas para o terceiro milˆnio

#ifdef COM_CALE
 SET KEY K_F5 TO cale      // F5 ativa calendario
#endi

#ifdef COM_MAQCALC
 SET KEY K_F6 TO maqcalc   // F6 ativa calculadora
 nu_calc=0.00; fgint = .f.
#endi

* \\ Final de ADM_PUBL.CH
