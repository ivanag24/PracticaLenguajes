grammar Gramatica;

program : dcllist funlist sentlist;
dcllist : dcl dcllist
        |;
funlist :  funcdef funlist
        |;
sentlist: mainhead '{' code '}';
dcl : ctelist
    | varlist;
ctelist : '#define' CONST_DEF_IDENTIFIER simpvalue
        | '#define' CONST_DEF_IDENTIFIER simpvalue ctelist;
simpvalue: NUMERIC_INTEGER_CONST
        | NUMERIC_REAL_CONST
        | STRING_CONST;
varlist : vardef ';'
        | vardef ';' varlist;
vardef: tbas IDENTIFIER
        | tbas IDENTIFIER '=' simpvalue;
tbas :'integer'
        | 'float'
        | 'string'
        | tvoid;
tvoid : 'void';
funcdef:  funchead '{' code '}';
funchead: tbas IDENTIFIER  '(' typedef1 ')';
typedef1 : typedef2
        |;
typedef2 : tbas IDENTIFIER
        | ',' tbas IDENTIFIER typedef2;
mainhead : tvoid 'Main'  '(' typedef1 ')';
code : sent code
       |;
sent : asig ';'
        | funccall ';'
        | vardef ';';
asig : IDENTIFIER '=' exp;
exp : factor op exp
        | factor;
op : '+'
        | '-'
        | '*'
        | 'DIV'
        | 'MOD';
factor : simpvalue
        | '(' exp ')'
        | funccall;
funccall : IDENTIFIER subpparamlist
        | CONST_DEF_IDENTIFIER subpparamlist;
subpparamlist : '(' explist ')'
        |;
explist : exp
        | exp ',' explist;


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
COMENT_ONE_LINE:'/''/'EVERYTHING+'\n';
COMENT_MULTIPLE_LINE:'/''*'('*'NOTSLASH*|NOTASTERISK*'/'|NOTASTERISKSLASH)*'*''/';

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
