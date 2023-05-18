import org.antlr.v4.runtime.*;

import javax.swing.*;

public class VerboseParser extends BaseErrorListener{
    private final JTextArea texto;
    private boolean error=false;
    public VerboseParser(JTextArea text){
        texto=text;
    }
    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        String s="Error sintáctico en la línea " + line + ":" + charPositionInLine + " - "+msg+"\n";
        texto.append(s);
        error=true;
    }
    public boolean getError(){
        return error;
    }
}


