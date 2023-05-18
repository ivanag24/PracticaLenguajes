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
program: VOID variableFuncionesMainVoid[$VOID.text]
        | tipo  IDENTIFIER diferenciaFuncionVariable[$tipo.type,$IDENTIFIER.text]
        | DEFINE CONST_DEF_IDENTIFIER simpvalue
          {program.addCabecera("<div><span class=palres>"+$DEFINE.text+"</span><span class=cte>"
          +$CONST_DEF_IDENTIFIER.text+"</span>"+$simpvalue.val+"</div>\n");} varCteFuncionMain;
variableFuncionesMainVoid [String type]: IDENTIFIER diferenciaFuncionVariable[$type,$IDENTIFIER.text]
        | MAIN PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {program.addMain($type+" "+$MAIN.text+$PARENTESIS_ABIERTO.text+$typedef1.type+$PARENTESIS_CERRADO.text,$code.cod);};
diferenciaFuncionVariable[String type, String iden]:PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {program.addFunction($iden,$type +" "+$iden+" "+$PARENTESIS_ABIERTO.text+$typedef1.type+$PARENTESIS_CERRADO.text,$code.cod);} funcionesMain
        | vardef1 {program.addCabecera("<div><span class=palres>"+$type+"</span><span class=ident>"
        +$iden+"</span>"+$vardef1.var+"</div>\n");} varCteFuncionMain;
funcionesMainVoid[String type]:   IDENTIFIER PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {program.addFunction($IDENTIFIER.text,$type +" "+$IDENTIFIER.text+" "+$PARENTESIS_ABIERTO.text
        +$typedef1.type+$PARENTESIS_CERRADO.text,$code.cod);} funcionesMain
        | MAIN PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {program.addMain($type+" "+$MAIN.text+$PARENTESIS_ABIERTO.text+$typedef1.type+$PARENTESIS_CERRADO.text,$code.cod);};
funcionesMain:VOID funcionesMainVoid[$VOID.text]
        | tipo IDENTIFIER PARENTESIS_ABIERTO typedef1 PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {program.addFunction($IDENTIFIER.text,$tipo.type +" "+$IDENTIFIER.text+" "+$PARENTESIS_ABIERTO.text
        +$typedef1.type+$PARENTESIS_CERRADO.text,$code.cod);} funcionesMain;
varCteFuncionMain: VOID variableFuncionesMainVoid[$VOID.text]
        | tipo IDENTIFIER diferenciaFuncionVariable[$tipo.type,$IDENTIFIER.text]
        | DEFINE CONST_DEF_IDENTIFIER simpvalue
         {program.addCabecera("<span class=palres>"+$DEFINE.text+"</span><span class=cte>"
                   +$CONST_DEF_IDENTIFIER.text+"</span>"+$simpvalue.val+"</div>\n");} varCteFuncionMain;
vardef1 returns [String var]: IGUAL simpvalue PUNTO_COMA {$var= $IGUAL.text + " <span class=ident>" + $simpvalue.val + "</span>" + $PUNTO_COMA.text;}
        | PUNTO_COMA{$var= $PUNTO_COMA.text;};
simpvalue returns [String val]: NUMERIC_INTEGER_CONST {$val= $NUMERIC_INTEGER_CONST.text;}
        | NUMERIC_REAL_CONST {$val= $NUMERIC_REAL_CONST.text;}
        | STRING_CONST {$val= $STRING_CONST.text;};
tipo returns [String type]:INTEGER {$type= "<span class=palres>" + $INTEGER.text + "</span>";}
        | FLOAT {$type= "<span class=palres>" + $FLOAT.text + "</span>";}
        | STRING {$type= "<span class=palres>" + $STRING.text + "</span>";}
        |struct {$type= $struct.str;};
tbas returns [String type]: INTEGER {$type= "<span class=palres>" + $INTEGER.text + "</span>";}
        | FLOAT {$type= "<span class=ident>" + $FLOAT.text + "</span>";}
        | STRING {$type= "<span class=ident>" + $STRING.text + "</span>";}
        | tvoid {$type= "<span class=ident>" + $tvoid.type + "</span>";}
        |struct {$type= $struct.str;};
tvoid returns [String type]: VOID {$type="void";};
typedef1 returns [String type]: typedef2 {$type= $typedef2.type;}
        |{$type="";};
typedef2 returns [String type]: tbas IDENTIFIER  typedef3 {$type= $tbas.type + " <span class=ident>" +  $IDENTIFIER.text+$typedef3.type + "</span>";};
typedef3 returns [String type]: COMA typedef2 {$type= $COMA.text + " " + $typedef2.type;}
        |{$type="";};
code returns [String cod]:  sent id1=code {$cod= $sent.se + $id1.cod;}
        | {$cod="";};
sent returns [String se] : IDENTIFIER sent1 PUNTO_COMA {$se= "<span class=ident>" + $IDENTIFIER.text + "</span>" + $sent1.se + $PUNTO_COMA.text;}
        | CONST_DEF_IDENTIFIER PUNTO_COMA {$se= "<span class=ident>" + $CONST_DEF_IDENTIFIER.text + "</span>" + $PUNTO_COMA.text;}
        | tbas IDENTIFIER vardef1 {$se= $tbas.type + " <span class=ident>" + $IDENTIFIER.text + "</span> " + $vardef1.var;}
        | id=if {$se=$id.i;}
        | id1=while {$se=$id1.whi;}
        | id2=dowhile {$se=$id2.dowhi;}
        | id3=for {$se=$id3.fo;}
        | id4=return PUNTO_COMA {$se= $id4.re + $PUNTO_COMA.text;};
sent1 returns [String se]: IGUAL exp {$se= $IGUAL.text + " " + $exp.ex;}
        | subpparamlist {$se= $subpparamlist.lista;} ;
return returns [String re]: RETURN exp {$re= $RETURN.text + " " + $exp.ex;};
exp returns [String ex]: factor exp1 {$ex= $factor.fact + " " + $exp1.ex;};
exp1 returns [String ex]: op exp {$ex= "<span class=palres>" + $op.o + "</span> "+$exp.ex;}
        |{$ex="";};
op returns [String o]:MAS {$o=$MAS.text;}
        | MENOS {$o=$MENOS.text;}
        | MULTIPLICACION {$o=$MULTIPLICACION.text;}
        | DIV {$o=$DIV.text;}
        | MOD {$o=$MOD.text;};
factor returns [String fact]: simpvalue {$fact= "<span class=cte>" + $simpvalue.val + "</span";}
        | PARENTESIS_ABIERTO exp PARENTESIS_CERRADO {$fact= $PARENTESIS_ABIERTO.text + $exp.ex + $PARENTESIS_CERRADO.text;}
        | funccall {$fact= $funccall.fun;};
funccall returns [String fun]:IDENTIFIER subpparamlist {$fun= "<span class=ident>" + $IDENTIFIER.text + "</span> "+ $subpparamlist.lista;}
        | CONST_DEF_IDENTIFIER {$fun="<span class=cte>" + $CONST_DEF_IDENTIFIER.text + "</span>";};
subpparamlist returns [String lista]: PARENTESIS_ABIERTO explist PARENTESIS_CERRADO
                                     {$lista=$PARENTESIS_ABIERTO.text + $explist.exlista + $PARENTESIS_CERRADO.text;}
        |{$lista="";};
explist returns [String exlista]: exp explist1 {$exlista= $exp.ex + " " + $explist1.exlista;};
explist1 returns [String exlista]:COMA explist {$exlista= $COMA.text + " " + $explist.exlista;}
        | {$exlista="";};

if returns [String i]: IF expcond CORCHETE_ABIERTO code CORCHETE_CERRADO else1
    {$i= "<span class=palres>" + $IF.text + "</span >" + $expcond.cond + " " + $CORCHETE_ABIERTO.text + "\n<div style=\"text-indent: 1cm\">" + $code.cod + "</div>\n" + $CORCHETE_CERRADO.text + $else1.el;};
else1 returns [String el]:ELSE else2 {$el="<span class=palres>" + $ELSE.text +"</span> "+ $else2.el;}
        |{$el="";};
else2 returns [String el]:  CORCHETE_ABIERTO code CORCHETE_CERRADO {$el=$CORCHETE_ABIERTO.text + "\n<div style=\"text-indent: 1cm\">" + $code.cod + "</div>\n" + $CORCHETE_CERRADO.text;}
	    |id=if {$el=$id.i;};
while returns [String whi]: WHILE PARENTESIS_ABIERTO expcond PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
        {$whi="<span class=palres>" + $WHILE.text + "</span >" + $PARENTESIS_ABIERTO.text + $expcond.cond + $PARENTESIS_CERRADO.text + $CORCHETE_ABIERTO.text
         + "\n<div style=\"text-indent: 1cm\">" + $code.cod + "</div>\n" + $CORCHETE_CERRADO.text;};
dowhile returns [String dowhi]: DO CORCHETE_ABIERTO code CORCHETE_CERRADO WHILE PARENTESIS_ABIERTO expcond PARENTESIS_CERRADO PUNTO_COMA
        {$dowhi="<span class=palres>" + $DO.text +"</span> "+$CORCHETE_ABIERTO.text + "\n<div style=\"text-indent: 1cm\">" + $code.cod + "</div>\n" + $CORCHETE_CERRADO.text + " <span class=palres>" +
         $WHILE.text +"</span> "+$PARENTESIS_ABIERTO.text + $expcond.cond +$PARENTESIS_CERRADO.text + $PUNTO_COMA.text;};
for returns [String fo]: FOR PARENTESIS_ABIERTO  for1 {$fo="<span class=palres>" + $FOR.text + "</span> "+ $PARENTESIS_ABIERTO.text + $for1.fo;};
for1 returns [String fo]: vardef PUNTO_COMA expcond PUNTO_COMA asig PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
                        {$fo=$vardef.var +$PUNTO_COMA.text + " "+ $expcond.cond +$PUNTO_COMA.text + " "+$asig.asi
                         + $PARENTESIS_CERRADO.text + " " + $CORCHETE_ABIERTO.text + "\n<div style=\"text-indent: 1cm\">" + $code.cod + "</div>\n" + $CORCHETE_CERRADO.text;}
        | asig PUNTO_COMA expcond PUNTO_COMA asig PARENTESIS_CERRADO CORCHETE_ABIERTO code CORCHETE_CERRADO
            {$fo=$asig.asi + $PUNTO_COMA.text + " " + $expcond.cond + $PUNTO_COMA.text + " " + $asig.asi+
            $PARENTESIS_CERRADO.text + " " + $CORCHETE_ABIERTO.text + "\n<div style=\"text-indent: 1cm\">" + $code.cod + "</div>\n" + $CORCHETE_CERRADO.text;};
asig returns [String asi]: IDENTIFIER IGUAL exp {$asi= "<span class=ident>" + $IDENTIFIER.text + "</span " + $IGUAL.text + " " +$exp.ex;};
vardef returns [String var]: tbas IDENTIFIER vardef2 {$var= $tbas.type + " <span class=ident>" + $IDENTIFIER.text + "</span> "+ $vardef2.var;};
vardef2 returns [String var]: IGUAL simpvalue {$var=$IGUAL.text + "<span class=cte>" + $simpvalue.val + "</span>";}
        | {$var="";};
expcond returns [String cond]:  factorcond expcond1 {$cond=$factorcond.fact +" "+ $expcond1.cond;};
expcond1 returns [String cond]: oplog expcond {$cond="<span class=palres>" + $oplog.log +"</span> "+$expcond.cond;}
        |{$cond="";};
oplog returns [String log]: OR {$log=$OR.text;}
        | AND {$log=$AND.text;};
factorcond returns [String fact]: simpvalue exp1 factorcond1 {$fact= "<span class=cte>" + $simpvalue.val + "</span> " + $exp1.ex + " " + $factorcond1.fact;}
        | funccall exp1 factorcond1 {$fact= $funccall.fun + " " +$exp1.ex + " " + $factorcond1.fact;}
        | PARENTESIS_ABIERTO factorcond parentesis {$fact= $PARENTESIS_ABIERTO.text + $factorcond.fact + $parentesis.par;}
        | NOT factorcond {$fact= "<span class=palres>" + $NOT.text +"</span> "+$factorcond.fact;};
factorcond1 returns [String fact]:opcomp exp {$fact= "<span class=palres>" + $opcomp.opc +"</span> "+$exp.ex;}
        |{$fact="";};
parentesis returns [String par]: expcond1 PARENTESIS_CERRADO {$par=$expcond1.cond + $PARENTESIS_CERRADO.text;};
opcomp returns [String opc]: MENOR {$opc=$MENOR.text;}
        |MAYOR {$opc=$MAYOR.text;}
        | MENOR_IGUAL {$opc=$MENOR_IGUAL.text;}
        | MAYOR_IGUAL {$opc=$MAYOR_IGUAL.text;}
        | IGUALIGUAL {$opc=$IGUALIGUAL.text;};
struct returns [String str]: STRUCT CORCHETE_ABIERTO varlist CORCHETE_CERRADO
                            {$str= "<span class=palres>" + $STRUCT.text + "</span>" + $CORCHETE_ABIERTO.text + "\n<div style=\"text-indent: 1cm\">";
                                 for(String s: $varlist.lista){
                                    $str=$str + s + "\n";
                                 }
                                 $str=$str + "</div>" + $CORCHETE_CERRADO.text;
                             };
varlist returns [List<String> lista]: {$lista= new ArrayList<String>();}vardef PUNTO_COMA varlist1
                                       {$lista.add($vardef.var+ $PUNTO_COMA.text);
                                       $lista.addAll($varlist1.lista);};
varlist1 returns [List<String> lista]: {$lista= new ArrayList<String>();} vardef PUNTO_COMA id1=varlist1
                                        {$lista.add($vardef.var+ $PUNTO_COMA.text);
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

