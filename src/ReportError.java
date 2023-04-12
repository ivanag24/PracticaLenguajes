import org.antlr.v4.runtime.*;


public class ReportError extends DefaultErrorStrategy {
    @Override
    public void reportInputMismatch(Parser recognizer, InputMismatchException  e) {
        String msg = "Se encontró: \""+e.getOffendingToken().getText()+"\". Se esperaba: "+e.getExpectedTokens().toString(recognizer.getVocabulary());
        recognizer.notifyErrorListeners(msg);
    }

    @Override
    public void reportMissingToken(Parser recognizer) {
        String[] aux = getMissingSymbol(recognizer).getText().split(" ");
        String[] aux2=aux[1].split(">");
        String msg = "Se esperaba un token " + aux2[0];
        recognizer.notifyErrorListeners(msg);
    }

    @Override
    public void reportNoViableAlternative (Parser recognizer, NoViableAltException e) throws RecognitionException {
        String msg = "Alternativa no viable: "+e.getOffendingToken().getText();
        recognizer.notifyErrorListeners(msg);
    }

    @Override
    public void reportUnwantedToken(Parser recognizer){
        String msg = "Entrada extraña: ";
        String[] aux = getMissingSymbol(recognizer).getText().split(" ");
        msg=msg+aux[2]+" Se esperaba: "+aux[4];
        recognizer.notifyErrorListeners(msg);
    }

}
