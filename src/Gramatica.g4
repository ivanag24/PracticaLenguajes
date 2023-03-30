grammar Gramatica;

program : dcllist funlist sentlist;
dcllist : dcl dcllist
        |;
funlist :  funcdef funlist
        |;
sentlist: mainhead CORCHETE_ABIERTO code CORCHETE_CERRADO;
dcl : ctelist
    | varlist;
ctelist : DEFINE CONST_DEF_IDENTIFIER simpvalue ctelist1;
ctelist1: ctelist
        |;
simpvalue: NUMERIC_INTEGER_CONST
        | NUMERIC_REAL_CONST
        | STRING_CONST;
varlist : vardef PUNTO_COMA varlist1;
varlist1: varlist
        |;
vardef: tbas IDENTIFIER vardef1;
vardef1: '=' simpvalue
        |;
tbas :INTEGER
        | FLOAT
        | STRING
        | tvoid;
tvoid : VOID;
funcdef:  funchead CORCHETE_ABIERTO code CORCHETE_CERRADO;
funchead: tbas IDENTIFIER  PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO;
typedef1 : typedef2
        |;
typedef2 : tbas IDENTIFIER
        | ',' tbas IDENTIFIER typedef2;
mainhead : tvoid MAIN  PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO;
code : sent code
       |;
sent : asig PUNTO_COMA
        | funccall PUNTO_COMA
        | vardef PUNTO_COMA;
asig : IDENTIFIER IGUAL exp;
exp : factor exp1;
exp1:op exp
        | ;
op : MAS
        | MENOS
        | MULTIPLICACION
        | DIV
        | MOD;
factor : simpvalue
        | PARENTESIS_ABIERTO exp PARENTESIS_CERRADO
        | funccall;
funccall : IDENTIFIER subpparamlist
        | CONST_DEF_IDENTIFIER subpparamlist;
subpparamlist : PARENTESIS_ABIERTO explist PARENTESIS_CERRADO
        |;
explist : exp explist1;
explist1: COMA explist
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

