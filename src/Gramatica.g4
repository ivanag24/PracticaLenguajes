grammar Gramatica;
@parser::members{

    private Program program;

    public GramaticaParser(TokenStream input,String nom,String dir){
        super(input);
    	_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
        program= new Program(nom,dir);
        program.addFunction("Main");
    }
}
program: VOID variableFuncionesMainVoid[$VOID.text] {program.writeFile();}
        | tipo  IDENTIFIER diferenciaFuncionVariable[$tipo.type,$IDENTIFIER.text]{program.writeFile();}
        | DEFINE CONST_DEF_IDENTIFIER simpvalue {program.addCabecera("<div><span class=palres>"+$DEFINE.text
        +"</span><span class=ident>"+" <A name=\"PROGRAMA_PRINCIPAL:"+$CONST_DEF_IDENTIFIER.text+"\">"
        +$CONST_DEF_IDENTIFIER.text+"</A></span>"+" "+$simpvalue.val+"</div>\n");} varCteFuncionMain {program.writeFile();};
variableFuncionesMainVoid [String type] : IDENTIFIER diferenciaFuncionVariable[$type,$IDENTIFIER.text]
        | MAIN PARENTESIS_ABIERTO typedef1[$MAIN.text] PARENTESIS_CERRADO CORCHETE_ABIERTO
        code[$MAIN.text,1] {program.addCode($code.cod,$MAIN.text);
        program.addCabecera($MAIN.text,"<span class=palres>"+$type+"</span><span class=ident><A name=\"PROGRAMA_PRINCIPAL:Main\"> "
        +$MAIN.text+"</A></span> "+$PARENTESIS_ABIERTO.text +$typedef1.type+$PARENTESIS_CERRADO.text);}CORCHETE_CERRADO;
diferenciaFuncionVariable[String type, String fun]:  {program.addFunction($fun);} PARENTESIS_ABIERTO  typedef1[$fun]
        PARENTESIS_CERRADO CORCHETE_ABIERTO code[$fun,1] {program.addCode($code.cod,$fun);
        program.addCabecera($fun,"<span class=palres>"+$type +"</span><span class=ident><A name=\"FUNCIONES:"+$fun+"\">"
        +" "+$fun+"</A></span> "+$PARENTESIS_ABIERTO.text+$typedef1.type+$PARENTESIS_CERRADO.text);} CORCHETE_CERRADO funcionesMain
        | vardef1 {program.addCabecera("<div>"+$type+"<span class=ident> <A name=\"PROGRAMA_PRINCIPAL:"+$fun+"\">"
        +" "+$fun+"</A></span>"+" "+$vardef1.var+"</div>\n");} varCteFuncionMain;
funcionesMainVoid[String type]:   IDENTIFIER {program.addFunction($IDENTIFIER.text);} PARENTESIS_ABIERTO typedef1[$IDENTIFIER.text]
        PARENTESIS_CERRADO CORCHETE_ABIERTO code[$IDENTIFIER.text,1] {program.addCode($code.cod,$IDENTIFIER.text);
        program.addCabecera($IDENTIFIER.text,"<span class=palres>"+$type +"</span><span class=ident> <A name=\"FUNCIONES:"+$IDENTIFIER.text+"\">"
        +" "+$IDENTIFIER.text+"</A></span> " +$PARENTESIS_ABIERTO.text+$typedef1.type+$PARENTESIS_CERRADO.text);} CORCHETE_CERRADO funcionesMain
        | MAIN {program.addFunction($MAIN.text);} PARENTESIS_ABIERTO typedef1[$MAIN.text] PARENTESIS_CERRADO CORCHETE_ABIERTO
        code[$MAIN.text,1] CORCHETE_CERRADO {program.addCode($code.cod,$MAIN.text);
        program.addCabecera($MAIN.text,"<span class=palres>"+$type+"</span><span class=ident><A name=\"PROGRAMA_PRINCIPAL:Main\"> "
        +$MAIN.text+"</A></span> "+$PARENTESIS_ABIERTO.text +$typedef1.type+$PARENTESIS_CERRADO.text);};
funcionesMain:VOID funcionesMainVoid[$VOID.text]
        | tipo IDENTIFIER {program.addFunction($IDENTIFIER.text);} PARENTESIS_ABIERTO typedef1[$IDENTIFIER.text] PARENTESIS_CERRADO CORCHETE_ABIERTO
        code[$IDENTIFIER.text,1] CORCHETE_CERRADO {program.addCode($code.cod,$IDENTIFIER.text);
        program.addCabecera($IDENTIFIER.text,"<span class=palres>"+$tipo.type +"</span><span class=ident> <A name=\"FUNCIONES:"+$IDENTIFIER.text+"\">"
        +" "+$IDENTIFIER.text+"</A></span> "+$PARENTESIS_ABIERTO.text +$typedef1.type+$PARENTESIS_CERRADO.text);} funcionesMain;
varCteFuncionMain: VOID variableFuncionesMainVoid[$VOID.text]
        | tipo IDENTIFIER diferenciaFuncionVariable[$tipo.type,$IDENTIFIER.text]
        | DEFINE CONST_DEF_IDENTIFIER simpvalue
         {program.addCabecera("<div><span class=palres>"+$DEFINE.text+"</span><span class=ident>"+" <A name=\"PROGRAMA_PRINCIPAL:"
         +$CONST_DEF_IDENTIFIER.text+"\">"+$CONST_DEF_IDENTIFIER.text+"</A></span>"+" "+$simpvalue.val+"</div>\n");} varCteFuncionMain;
vardef1 returns [String var]: IGUAL simpvalue PUNTO_COMA {$var= $IGUAL.text + " <span class=cte>" + $simpvalue.val + "</span>" + $PUNTO_COMA.text;}
        | PUNTO_COMA{$var= $PUNTO_COMA.text;};
simpvalue returns [String val]: NUMERIC_INTEGER_CONST {$val="<span class=cte>"+$NUMERIC_INTEGER_CONST.text+"</span>";}
        | NUMERIC_REAL_CONST {$val="<span class=cte>"+$NUMERIC_REAL_CONST.text+"</span>";}
        | STRING_CONST {$val="<span class=cte>"+$STRING_CONST.text+"</span>";};
tipo returns [String type]:INTEGER {$type= "<span class=palres>" + $INTEGER.text + "</span>";}
        | FLOAT {$type= "<span class=palres>" + $FLOAT.text + "</span>";}
        | STRING {$type= "<span class=palres>" + $STRING.text + "</span>";}
        |struct {$type= $struct.str;};
tbas returns [String type]: INTEGER {$type= "<span class=palres>" + $INTEGER.text + " </span>";}
        | FLOAT {$type= "<span class=palres>" + $FLOAT.text + " </span>";}
        | STRING {$type= "<span class=palres>" + $STRING.text + " </span>";}
        | tvoid {$type= "<span class=palres>" + $tvoid.type + " </span>";}
        |struct {$type= $struct.str;};
tvoid returns [String type]: VOID {$type=$VOID.text;};
typedef1 [String fun] returns [String type]: typedef2[$fun] {$type=$typedef2.type;}
        |{$type="";};
typedef2 [String fun] returns [String type]: tbas IDENTIFIER {program.addParam($fun,$IDENTIFIER.text);} typedef3[$fun]
        {$type=$tbas.type + " <span class=ident> "+program.getNamePath($IDENTIFIER.text,$fun)+"</span> "+$typedef3.type;};
typedef3 [String fun] returns [String type]: COMA typedef2[$fun] {$type=$COMA.text + " "+$typedef2.type;}
        |{$type="";};
code [String fun, int nh] returns [String cod, int ns]:  sent[$fun,$nh] id1=code[$fun,$nh] {$cod=$sent.se + $id1.cod;}
        | {$cod="";};
sent [String fun, int nh] returns [String se] : IDENTIFIER sent1[$fun] PUNTO_COMA {$se="<div><span class=ident>"+program.getHRefPath($IDENTIFIER.text,$fun)+"</span> " +$sent1.se+ " "+$PUNTO_COMA.text+"</div>";}
        | CONST_DEF_IDENTIFIER {program.addParam($fun,$CONST_DEF_IDENTIFIER.text);} PUNTO_COMA {$se="<div><span class=ident>"+program.getHRefPath($CONST_DEF_IDENTIFIER.text,$fun)+"</span> "+$PUNTO_COMA.text+"</div>";}
        | tbas IDENTIFIER {program.addParam($fun,$IDENTIFIER.text);} vardef1 {$se="<div>"+$tbas.type+" <span class=ident> "+program.getNamePath($IDENTIFIER.text,$fun)+"</span> " +$vardef1.var+"</div>";}
        |id=if[$fun,$nh+1] {$se="<div>"+$id.i+"</div>";}
        |id1=while[$fun,$nh+1] {$se="<div>"+$id1.whi+"</div>";}
        |id2=dowhile[$fun,$nh+1] {$se="<div>"+$id2.dowhi+"</div>";}
        |id3=for[$fun,$nh+1] {$se="<div>"+$id3.fo+"</div>";}
        |id4=return[$fun] PUNTO_COMA {$se="<div>"+$id4.re + " " +$PUNTO_COMA.text+"</div>";};
sent1 [String fun]  returns [String se]: IGUAL exp[$fun] {$se=$IGUAL.text + " "+$exp.ex;}
        | subpparamlist[$fun] {$se=$subpparamlist.lista;} ;
return[String fun]  returns [String re]: RETURN exp[$fun] {$re="<span class=palres>"+$RETURN.text + "</span> "+$exp.ex;};
exp [String fun]  returns [String ex]: factor[$fun] exp1[$fun] {$ex=$factor.fact+ " "+$exp1.ex;};
exp1 [String fun]  returns [String ex]: op exp[$fun] {$ex=$op.o + " "+$exp.ex;}
        |{$ex="";};
op returns [String o]:MAS {$o=$MAS.text;}
        | MENOS {$o=$MENOS.text;}
        | MULTIPLICACION {$o=$MULTIPLICACION.text;}
        | DIV {$o=$DIV.text;}
        | MOD {$o=$MOD.text;};
factor [String fun] returns [String fact]: simpvalue {$fact= $simpvalue.val;}
        | PARENTESIS_ABIERTO exp[$fun] PARENTESIS_CERRADO {$fact= $PARENTESIS_ABIERTO.text+" "+$exp.ex+ " "+$PARENTESIS_CERRADO.text;}
        | funccall[$fun] {$fact= $funccall.funName;};
funccall [String fun] returns [String funName]:IDENTIFIER subpparamlist[$fun] {$funName="<span class=ident>"+program.getHRefPath($IDENTIFIER.text,$fun)+"</span> "+$subpparamlist.lista;}
        | CONST_DEF_IDENTIFIER subpparamlist[$fun]{$funName="<span class=ident>"+program.getHRefPath($CONST_DEF_IDENTIFIER.text,$fun)+"</span> "+$subpparamlist.lista;};
subpparamlist [String fun] returns [String lista]: PARENTESIS_ABIERTO explist[$fun] PARENTESIS_CERRADO
        {$lista=$PARENTESIS_ABIERTO.text +" "+$explist.exlista+" "+$PARENTESIS_CERRADO.text;}
        |{$lista="";};
explist [String fun] returns [String exlista]: exp[$fun] explist1[$fun] {$exlista= $exp.ex+ " "+$explist1.exlista;};
explist1 [String fun] returns [String exlista]:COMA explist[$fun] {$exlista= $COMA.text+ " "+$explist.exlista;}
        | {$exlista="";};
if [String fun, int nh] returns [String i]: IF expcond[$fun] CORCHETE_ABIERTO code[$fun,$nh] CORCHETE_CERRADO else1[$fun,$nh]
        {$i= "<span class=palres>" + $IF.text + "</span >" + $expcond.cond+ "\n<div>"+$CORCHETE_ABIERTO.text
        +"</div>\n<div style=\"text-indent: "+$nh+"cm\">"+$code.cod +"\n</div>\n<div>"+$CORCHETE_CERRADO.text+"</div>\n"+$else1.el;};
else1 [String fun, int nh] returns [String el]:ELSE else2[$fun, $nh] {$el="<div><span class=palres>"+$ELSE.text +"</span>"+ $else2.el+"</div>\n";}
        |{$el="";};
else2 [String fun,int nh] returns [String el]:  CORCHETE_ABIERTO code[$fun,$nh] CORCHETE_CERRADO
        {$el="<div>"+$CORCHETE_ABIERTO.text+"</div>\n<div style=\"text-indent: "+$nh+"cm\">" +$code.cod+"\n</div>\n<div>"+$CORCHETE_CERRADO.text+"</div>\n";}
	    |id=if[$fun,$nh] {$el=" "+$id.i;};
while [String fun,int nh] returns [String whi]: WHILE PARENTESIS_ABIERTO expcond[$fun] PARENTESIS_CERRADO CORCHETE_ABIERTO code[$fun,$nh] CORCHETE_CERRADO
        {$whi="<span class=palres>"+$WHILE.text +"</span> "+$PARENTESIS_ABIERTO.text + " " +$expcond.cond + " " +$PARENTESIS_CERRADO.text
         + "\n<div>"+$CORCHETE_ABIERTO.text +"</div>\n<div style=\"text-indent: "+$nh+"cm\">"+$code.cod +"\n</div>\n<div>"+$CORCHETE_CERRADO.text+"</div>\n";};
dowhile [String fun,int nh] returns [String dowhi]: DO CORCHETE_ABIERTO code[$fun,$nh] CORCHETE_CERRADO WHILE PARENTESIS_ABIERTO expcond[$fun] PARENTESIS_CERRADO PUNTO_COMA
        {$dowhi="<span class=palres>"+$DO.text +" </span>"+"\n<div>"+$CORCHETE_ABIERTO.text +"</div>\n<div style=\"text-indent: "+$nh+"cm\">"
        +$code.cod +"\n</div>\n<div>"+$CORCHETE_CERRADO.text + "</div>\n<div><span class=palres>"+$WHILE.text +"</span> "+$PARENTESIS_ABIERTO.text
        +" "+$expcond.cond +" "+$PARENTESIS_CERRADO.text+$PUNTO_COMA.text+"</div>";};
for [String fun,int nh] returns [String fo]: FOR PARENTESIS_ABIERTO  for1[$fun,$nh] {$fo="<span class=palres>"+$FOR.text +"</span> "+$PARENTESIS_ABIERTO.text +" "+$for1.fo;};
for1 [String fun,int nh] returns [String fo]: vardef PUNTO_COMA expcond[$fun] PUNTO_COMA asig[$fun] PARENTESIS_CERRADO CORCHETE_ABIERTO code[$fun,$nh] CORCHETE_CERRADO
        {$fo=$vardef.var +$PUNTO_COMA.text + " "+ $expcond.cond +$PUNTO_COMA.text + " "+$asig.asi+$PARENTESIS_CERRADO.text
        +"\n<div>"+$CORCHETE_ABIERTO.text +"</div>\n<div style=\"text-indent: "+$nh+"cm\">"+$code.cod +"\n</div>\n<div>"+$CORCHETE_CERRADO.text + "</div>\n";}
        | asig[fun] PUNTO_COMA expcond[fun] PUNTO_COMA asig[fun] PARENTESIS_CERRADO CORCHETE_ABIERTO code[fun,nh] CORCHETE_CERRADO
        {$fo=$asig.asi+$PUNTO_COMA.text + " "+ $expcond.cond +$PUNTO_COMA.text +" "+$asig.asi +" "+ $PARENTESIS_CERRADO.text+
        "\n<div>"+$CORCHETE_ABIERTO.text +"</div>\n<div style=\"text-indent: "+$nh+"cm\">"+$code.cod +"\n</div>\n<div>"+$CORCHETE_CERRADO.text + "</div>\n";};
asig [String fun] returns [ String asi]: IDENTIFIER IGUAL exp[$fun] {$asi= "<span class=ident>"+program.getHRefPath($IDENTIFIER.text,$fun)+"</span> " + $IGUAL.text + " " +$exp.ex;};
vardef returns [String var]: tbas IDENTIFIER vardef2 {$var=$tbas.type +" <span class=ident>"+$IDENTIFIER.text + "</span> "+$vardef2.var;};
vardef2 returns [String var]: IGUAL simpvalue {$var=$IGUAL.text+" "+$simpvalue.val;}
        | {$var="";};
expcond [String fun]returns [String cond]:  factorcond[$fun] expcond1[$fun] {$cond=$factorcond.fact +" "+ $expcond1.cond;};
expcond1 [String fun] returns [String cond]: oplog expcond[$fun] {$cond=$oplog.log +" "+$expcond.cond;}
        |{$cond="";};
oplog returns [String log]: OR {$log="<span class=palres>"+$OR.text+"</span>";}
        | AND {$log="<span class=palres>"+$AND.text+"</span>";};
factorcond [String fun]returns [String fact]: simpvalue exp1[$fun] factorcond1[$fun] {$fact= $simpvalue.val +" "+$exp1.ex +" "+$factorcond1.fact;}
        | funccall[$fun] exp1[$fun] factorcond1[$fun] {$fact= $funccall.funName +" "+$exp1.ex +" "+$factorcond1.fact;}
        | PARENTESIS_ABIERTO factorcond[$fun] parentesis[$fun] {$fact= " "+$PARENTESIS_ABIERTO.text +" "+$factorcond.fact +" "+$parentesis.par;}
        | NOT factorcond[$fun] {$fact= $NOT.text +" "+$factorcond.fact;};
factorcond1 [String fun] returns [String fact]:opcomp exp[$fun] {$fact= $opcomp.opc +" "+$exp.ex;}
        |{$fact="";};
parentesis [String fun] returns [String par]: expcond1[$fun] PARENTESIS_CERRADO {$par=$expcond1.cond+$PARENTESIS_CERRADO.text;};
opcomp returns [String opc]: MENOR {$opc=$MENOR.text;}
        |MAYOR {$opc=$MAYOR.text;}
        | MENOR_IGUAL {$opc=$MENOR_IGUAL.text;}
        | MAYOR_IGUAL {$opc=$MAYOR_IGUAL.text;}
        | IGUALIGUAL {$opc=$IGUALIGUAL.text;};
struct returns [String str]: STRUCT CORCHETE_ABIERTO varlist CORCHETE_CERRADO
        {$str="<span class=palres>"+$STRUCT.text+"</span><div>"+$CORCHETE_ABIERTO.text+"</div>\n<div style=\"text-indent: 1cm\">"
        +$varlist.lista+"</div>\n<div>"+$CORCHETE_CERRADO.text+"</div>";};
varlist returns [String lista]: vardef PUNTO_COMA varlist1 {$lista="<div>" +$vardef.var+ "</div>\n"+ $varlist1.lista;};
varlist1 returns [String lista]: vardef PUNTO_COMA id1=varlist1
        {$lista="<div>"+$vardef.var+"</div>\n"+$id1.lista;}
        | {$lista= "";};

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
NUMERIC_REAL_CONST:(DECIMAL | (DECIMAL|NUMERIC_INTEGER_CONST) E SIGNO?NUMERO+);
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

