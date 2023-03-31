grammar Gramatica;

program: VOID variableFuncionesMainVoid
        | tipo  IDENTIFIER diferenciaFuncionVariable
        | DEFINE CONST_DEF_IDENTIFIER simpvalue varCteFuncionMain;
variableFuncionesMainVoid: IDENTIFIER diferenciaFuncionVariable
        | MAIN PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO;
diferenciaFuncionVariable:PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO funcionesMain
        | vardef1 varCteFuncionMain;
funcionesMainVoid:   IDENTIFIER PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO funcionesMain
        | MAIN PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO ;
funcionesMain:VOID funcionesMainVoid
        | tipo IDENTIFIER PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO funcionesMain;
varCteFuncionMain: VOID variableFuncionesMainVoid
        | tipo IDENTIFIER diferenciaFuncionVariable
        | DEFINE CONST_DEF_IDENTIFIER simpvalue varCteFuncionMain;
vardef1: IGUAL simpvalue PUNTO_COMA
        | PUNTO_COMA;
simpvalue : NUMERIC_INTEGER_CONST
        | NUMERIC_REAL_CONST
        | STRING_CONST;
tipo:INTEGER
        | FLOAT
        | STRING ;
tbas : INTEGER
        | FLOAT
        | STRING
        | tvoid;
tvoid : VOID;
typedef1 : typedef2
        |;
typedef2 : tbas IDENTIFIER  typedef3 ;
typedef3: COMA typedef2
        |;
code :  sent code
        |;
sent : IDENTIFIER sent1 PUNTO_COMA
        | CONST_DEF_IDENTIFIER PUNTO_COMA
        | tbas IDENTIFIER  vardef1;
sent1: IGUAL exp
        | subpparamlist ;
exp : factor exp1;
exp1: op exp
        |;
op :MAS
        | MENOS
        | MULTIPLICACION
        | DIV
        | MOD;
factor : simpvalue
        | PARENTESIS_ABIERTO exp PARENTESIS_CERRADO
        | funccall;
funccall :IDENTIFIER subpparamlist
        | CONST_DEF_IDENTIFIER;
subpparamlist : PARENTESIS_ABIERTO explist PARENTESIS_CERRADO
        |;
explist : exp explist1;
explist1 :COMA explist
        |;

RESTO: [ \n\r\t]->skip;
COMENT_ONE_LINE:'/''/'EVERYTHING+'\n'->skip;
COMENT_MULTIPLE_LINE:'/''*'('*'NOTSLASH*|NOTASTERISK*'/'|NOTASTERISKSLASH)*'*''/'->skip;
DEFINE:'#define';
SALTO:'\n';
PUNTO_COMA:';';
COMA:',';
IGUAL:'=';
INTEGER:'integer';
FLOAT:'float';
STRING:'string';
VOID:'void';
MAIN:'Main';
MAS:'+';
MENOS:'-';
MULTIPLICACION:'*';
DIV:'DIV';
MOD:'MOD';
CORCHETE_ABIERTO:'{';
CORCHETE_CERRADO:'}';
PARENTESIS_ABIERTO:'(';
PARENTESIS_CERRADO:')';

IDENTIFIER:(GUION|LETRA_MIN)SIMBOLO_IDEN+;
CONST_DEF_IDENTIFIER:(GUION|LETRA_MAY)SIMBOLO_CONST+;
NUMERIC_INTEGER_CONST:SIGNO?NUMERO+;
NUMERIC_REAL_CONST:(DECIMAL | DECIMAL E SIGNO?NUMERO+);
STRING_CONST:('\''STRING_SIMPLE+ '\''| '"'STRING_DOBLE+ '"');


fragment DECIMAL:SIGNO?NUMERO*'.'NUMERO+;
fragment SIGNO:[+-];
fragment E:[eE];
fragment NUMERO: [0-9];
fragment GUION: '_';
fragment LETRA_MIN: [a-z];
fragment LETRA_MAY: [A-Z];
fragment SIMBOLO_IDEN: GUION | NUMERO | LETRA_MIN;
fragment SIMBOLO_CONST: GUION | NUMERO | LETRA_MAY;
fragment STRING_SIMPLE:~[']|'\\''\'';
fragment STRING_DOBLE:~["]|('\\''"');
fragment EVERYTHING: ~[\n];
fragment NOTSLASH: ~[/];
fragment NOTASTERISK: ~[*];
fragment NOTASTERISKSLASH: ~[*/];

