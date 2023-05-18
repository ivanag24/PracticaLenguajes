grammar Gramatica;
@parser::members{

    private Program program;

    public GramaticaParser(TokenStream input,String nom,String dir){
        super(input);
    	_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
        program= new Program(nom,dir);
    }

    public void closeFile(){
        program.closeFile();
    }
}
program: VOID variableFuncionesMainVoid
        | tipo  IDENTIFIER diferenciaFuncionVariable
        | DEFINE CONST_DEF_IDENTIFIER simpvalue varCteFuncionMain;
variableFuncionesMainVoid: IDENTIFIER diferenciaFuncionVariable
        | MAIN PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO;
diferenciaFuncionVariable:PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO funcionesMain
        | vardef1 varCteFuncionMain;
funcionesMainVoid:   IDENTIFIER PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO funcionesMain
        | MAIN PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO ;//Main
funcionesMain:VOID funcionesMainVoid
        | tipo IDENTIFIER PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO funcionesMain;
varCteFuncionMain: VOID variableFuncionesMainVoid
        | tipo IDENTIFIER diferenciaFuncionVariable
        | DEFINE CONST_DEF_IDENTIFIER simpvalue varCteFuncionMain;
vardef1: IGUAL simpvalue PUNTO_COMA
        | PUNTO_COMA;
simpvalue returns [String val]: NUMERIC_INTEGER_CONST {$val=$NUMERIC_INTEGER_CONST.text;}
        | NUMERIC_REAL_CONST {$val=$NUMERIC_REAL_CONST.text;}
        | STRING_CONST {$val=$STRING_CONST.text;};
tipo returns [String type]:INTEGER {$type=$INTEGER.text;}
        | FLOAT {$type=$FLOAT.text;}
        | STRING {$type=$STRING.text;}
        |struct {$type=$struct.str;};
tbas returns [String type]: INTEGER {$type=$INTEGER.text;}
        | FLOAT {$type=$FLOAT.text;}
        | STRING {$type=$STRING.text;}
        | tvoid {$type=$tvoid.type;}
        |struct {$type=$struct.str;};
tvoid returns [String type]: VOID {$type="void";};
typedef1 : typedef2
        |;
typedef2 : tbas IDENTIFIER  typedef3 ;
typedef3: COMA typedef2
        |;
code returns [String cod]:  sent id1=code {$cod=$sent.se + $id1.cod;}
        | {$cod="";};
sent returns [String se] : IDENTIFIER sent1 PUNTO_COMA
        | CONST_DEF_IDENTIFIER PUNTO_COMA
        | tbas IDENTIFIER  vardef1
        |if
        |while
        |dowhile
        |for
        | return PUNTO_COMA;
sent1: IGUAL exp
        | subpparamlist ;
return returns [String re]: RETURN exp {$re=$RETURN.text + " "+$exp.ex;};
exp returns [String ex]: factor exp1 {$ex=$factor.fact+ " "+$exp1.ex;};
exp1 returns [String ex]: op exp {$ex=$op.o + " "+$exp.ex;}
        |{$ex="";};
op returns [String o]:MAS {$o=$MAS.text;}
        | MENOS {$o=$MENOS.text;}
        | MULTIPLICACION {$o=$MULTIPLICACION.text;}
        | DIV {$o=$DIV.text;}
        | MOD {$o=$MOD.text;};
factor returns [String fact]: simpvalue {$fact= $simpvalue.val;}
        | PARENTESIS_ABIERTO exp PARENTESIS_CERRADO {$fact= $PARENTESIS_ABIERTO.text+" "+$exp.ex+ " "+$PARENTESIS_CERRADO.text;}
        | funccall {$fact= $funccall.fun;};
funccall returns [String fun]:IDENTIFIER subpparamlist {$fun=$IDENTIFIER.text +" "+$subpparamlist.lista;}
        | CONST_DEF_IDENTIFIER {$fun=$CONST_DEF_IDENTIFIER.text;};
subpparamlist returns [String lista]: PARENTESIS_ABIERTO explist PARENTESIS_CERRADO
                                     {$lista=$PARENTESIS_ABIERTO.text +" "+$explist.exlista+" "+$PARENTESIS_CERRADO.text;}
        |{$lista="";};
explist returns [String exlista]: exp explist1 {$exlista= $exp.ex+ " "+$explist1.exlista;};
explist1 returns [String exlista]:COMA explist {$exlista= $COMA.text+ " "+$explist.exlista;}
        | {$exlista="";};

if returns [String i]: IF expcond CORCHETE_ABIERTO code CORCHETE_CERRADO else1
    {$i= $IF.text + $expcond.cond + $CORCHETE_ABIERTO.text +"\n\t"+$code.cod +"\n"+$CORCHETE_CERRADO.text+$else1.el;};
else1 returns [String el]:ELSE else2 {$el=$ELSE.text +" "+ $else2.el;}
        |{$el="";};
else2 returns [String el]:  CORCHETE_ABIERTO code CORCHETE_CERRADO {$el=$CORCHETE_ABIERTO.text +"\n\t"+$code.cod+"\n";}
	    |id=if {$el=$id.i;};
while returns [String whi]: WHILE PARENTESIS_ABIERTO expcond PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {$whi=$WHILE.text +$PARENTESIS_ABIERTO.text + " " +$expcond.cond + " " +$PARENTESIS_CERRADO.text+$CORCHETE_ABIERTO.text
         +"\n\t"+ $code.cod +"\n"+ $CORCHETE_CERRADO.text;};
dowhile returns [String dowhi]: DO CORCHETE_ABIERTO code CORCHETE_CERRADO WHILE PARENTESIS_ABIERTO expcond PARENTESIS_CERRADO PUNTO_COMA
        {$dowhi=$DO.text +" "+$CORCHETE_ABIERTO.text +"\n\t"+ $code.cod +"\n"+$CORCHETE_CERRADO.text + " "+
         $WHILE.text +" "+$PARENTESIS_ABIERTO.text +" "+$expcond.cond +" "+$PARENTESIS_CERRADO.text+$PUNTO_COMA.text;};
for returns [String fo]: FOR PARENTESIS_ABIERTO  for1 {$fo=$FOR.text +" "+$PARENTESIS_ABIERTO.text +" "+$for1.fo;};
for1 returns [String fo]: vardef PUNTO_COMA expcond PUNTO_COMA asig PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
                        {$fo=$vardef.var +$PUNTO_COMA.text + " "+$expcond.cond +$PUNTO_COMA.text + " "+$asig.asi
                         +$PARENTESIS_CERRADO.text +$CORCHETE_ABIERTO.text + "\n\t"+$code.cod +"\t\n"+$CORCHETE_CERRADO.text;}
        | asig PUNTO_COMA expcond PUNTO_COMA asig PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
            {$fo=$asig.asi+$PUNTO_COMA.text + " "+ $expcond.cond +$PUNTO_COMA.text +" "+$asig.asi +" "+
            $PARENTESIS_CERRADO.text+$CORCHETE_ABIERTO.text +"\t\n"+$code.cod+"\n"+$CORCHETE_CERRADO.text;};
asig returns [String asi]: IDENTIFIER IGUAL exp {$asi= $IDENTIFIER.text + " " + $IGUAL.text + " " +$exp.ex+"\n";};
vardef returns [String var]: tbas IDENTIFIER vardef2 {$var=$tbas.type +" "+$IDENTIFIER.text+" "+$vardef2.var;};
vardef2 returns [String var]: IGUAL simpvalue {$var=$IGUAL.text+" "+$simpvalue.val;}
        | {$var="";};
expcond returns [String cond]:  factorcond expcond1 {$cond=$factorcond.fact +" "+ $expcond1.cond;};
expcond1 returns [String cond]: oplog expcond {$cond=$oplog.log +" "+$expcond.cond;}
        |{$cond="";};
oplog returns [String log]: OR {$log=$OR.text;}
        | AND {$log=$AND.text;};
factorcond returns [String fact]: simpvalue exp1 factorcond1 {$fact= $simpvalue.val +" "+$exp1.ex +" "+$factorcond1.fact;}
        | funccall exp1 factorcond1 {$fact= $funccall.fun +" "+$exp1.ex +" "+$factorcond1.fact;}
        | PARENTESIS_ABIERTO factorcond parentesis {$fact= $PARENTESIS_ABIERTO.text +" "+$factorcond.fact +" "+$parentesis.par;}
        | NOT factorcond {$fact= $NOT.text +" "+$factorcond.fact;};
factorcond1 returns [String fact]:opcomp exp {$fact= $opcomp.opc +" "+$exp.ex;}
        |;
parentesis returns [String par]: expcond1 PARENTESIS_CERRADO {$par=$expcond1.cond+$PARENTESIS_CERRADO.text;};
opcomp returns [String opc]: MENOR {$opc=$MENOR.text;}
        |MAYOR {$opc=$MAYOR.text;}
        | MENOR_IGUAL {$opc=$MENOR_IGUAL.text;}
        | MAYOR_IGUAL {$opc=$MAYOR_IGUAL.text;}
        | IGUALIGUAL {$opc=$IGUALIGUAL.text;};
struct returns [String str]: STRUCT CORCHETE_ABIERTO varlist CORCHETE_CERRADO
                            {$str=$STRUCT.text+$CORCHETE_ABIERTO.text+"\n\t";
                                 for(String s: $varlist.lista){
                                    $str=$str+"\t"+s;
                                 }
                                 $str=$str+"\n"+$CORCHETE_CERRADO.text;
                             };
varlist returns [List<String> lista]: {$lista= new ArrayList<String>();}vardef PUNTO_COMA varlist1
                                       {$lista.add($vardef.var+ $PUNTO_COMA.text +"\n");
                                       $lista.addAll($varlist1.lista);};
varlist1 returns [List<String> lista]: {$lista= new ArrayList<String>();} vardef PUNTO_COMA id1=varlist1
                                        {$lista.add($vardef.var+ $PUNTO_COMA.text +"\n");
                                         $lista.addAll($id1.lista);}
                                        | {$lista= new ArrayList<String>();};

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
IF:'if';
ELSE: 'else';
WHILE:'while';
DO:'do';
FOR:'for';
OR:'||';
AND:'&';
NOT:'!';
MAYOR:'>';
MENOR:'<';
IGUALIGUAL:'==';
MENOR_IGUAL:'<=';
MAYOR_IGUAL:'>=';
STRUCT:'struct';
RETURN: 'return';

IDENTIFIER:((GUION SIMBOLO_IDEN* (LETRA_MIN|NUMERO) SIMBOLO_IDEN*) | (LETRA_MIN SIMBOLO_IDEN*));
CONST_DEF_IDENTIFIER:((GUION SIMBOLO_CONST* (LETRA_MAY|NUMERO) SIMBOLO_CONST*) | (LETRA_MAY SIMBOLO_CONST*));
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

