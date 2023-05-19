import java.util.AbstractList;
import java.util.ArrayList;
import java.util.List;

public class Function {
    private String sentencias="";
    private String cabecera="";
    private List<String> parametros;
    private String cabeceraHTML="";
    private String iden="";

    public Function(String iden,String cabeceraHTML, String sentencias) {
        this.iden=iden;
        this.cabeceraHTML=cabeceraHTML;
        String[] split = cabeceraHTML.split("<[^>]+>");
        for (String s:split) {
            cabecera=cabecera+s;
        }
        parametros= new ArrayList<>();
        this.sentencias=sentencias;
    }

    public String getSentencias(){
        return sentencias;
    }
    public String getCabecera(){
        return cabecera;
    }
    public String getCabeceraHTML(){
        return cabeceraHTML;
    }
    public String getIden(){
        return iden;
    }
    public void setSentencias(String sentencia) {
        sentencias=sentencia;
    }
    public void addParam(String param){
        parametros.add(param);
    }

    public boolean containsParam(String name) {
        return parametros.contains(name);
    }


}
