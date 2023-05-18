import java.util.ArrayList;
import java.util.List;

public class Function {
    private ArrayList<String> sentencias= new ArrayList<>();

    private String cabecera="";
    private String iden="";

    public Function(String iden,String cabecera, List<String> sentencias) {
        this.iden=iden;
        this.cabecera=cabecera;
        for (String s:sentencias) {
            this.sentencias.add(s);
        }
    }


    public List getSentencias(){
        return sentencias;
    }

    public String getCabecera(){
        return cabecera;
    }
    public String getIden(){
        return iden;
    }
}
