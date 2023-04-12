import org.antlr.v4.runtime.*;

import javax.swing.*;

public class VerboseListener extends BaseErrorListener {
    JTextArea texto;
    private boolean error=false;
    public VerboseListener(JTextArea text){
        texto=text;
    }
    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        String[] aux=msg.split(" ");
        String s="Error lexico en la línea " + line + ":" + charPositionInLine + " - Token no reconocido: "+aux[4]+"\n";
        texto.append(s);
        error=true;
    }
    public boolean getError(){
        return error;
    }
}
