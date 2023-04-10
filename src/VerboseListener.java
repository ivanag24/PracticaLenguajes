import org.antlr.v4.runtime.*;

import javax.swing.*;

public class VerboseListener extends BaseErrorListener{
    private JTextArea texto;
    public VerboseListener(JTextArea text){
        texto=text;
    }
    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            texto.append("Error léxico en la línea " + line + ":" + charPositionInLine + " - "+ msg+"\n");
    }
}


