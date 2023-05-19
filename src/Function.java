public class Function {
    private String sentencias="";

    private String cabecera="";

    private String cabeceraHTML="";
    private String iden="";

    public Function(String iden,String cabeceraHTML, String sentencias) {
        this.iden=iden;
        this.cabeceraHTML=cabeceraHTML;
        String[] split = cabeceraHTML.split("<[^>]+>");
        for (String s:split) {
            cabecera=cabecera+s;
        }
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
}
