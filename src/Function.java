public class Function {
    private String sentencias="";

    private String cabecera="";
    private String iden="";

    public Function(String iden,String cabecera, String sentencias) {
        this.iden=iden;
        this.cabecera=cabecera;
        this.sentencias=sentencias;
    }


    public String getSentencias(){
        return sentencias;
    }

    public String getCabecera(){
        return cabecera;
    }
    public String getIden(){
        return iden;
    }
}
