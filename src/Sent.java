import java.util.ArrayList;
import java.util.List;

public class Sent {

    private ArrayList<String> palabras = new ArrayList<>();

    public void addWord(String s){
        palabras.add(s);
    }

    public List getPalabras(){
        return palabras;
    }
}
