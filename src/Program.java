import java.io.*;
import java.util.ArrayList;

public class Program {
    private final ArrayList<Function> functions= new ArrayList<>();
    private Function main;
    private String globales="";
    private final File file;
    FileWriter fw ;
    PrintWriter pw;

    public Program(String nombre,String dir){
        file= new File(dir,nombre+".html");
        try {
            fw= new FileWriter(file);
            pw = new PrintWriter(fw);
            title(nombre);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    public void addFunction(String iden){
        if(iden.equals("Main")){
            main = new Function(iden);
        }else {
            Function function = new Function(iden);
            functions.add(function);
        }
    }


    public void addCode(String sentencia,String fun){
        Function f=getFunction(fun);
        f.setSentencias(sentencia);
    }

    public void addCabecera(String fun, String cabecera){
        Function f = getFunction(fun);
        f.setCabeceraHTML(cabecera);
    }

    public void addCabecera(String global){
        globales=globales+global;
    }

    public void addParam(String name,String fun){
        Function f=getFunction(fun);
        f.addParam(name);
    }

    public String getHRefPath(String name,String fun){
        Function f = getFunction(fun);
        if(f == null){
            return name;
        }
        System.out.println(f.getIden());
        if (f.containsParam(name)){
            if(f.getIden().equals("Main")){
                return "<A href=\"#PROGRAMA_PRINCIPAL:"+f.getIden()+":"+name+"\">"+name+"</A>";
            }
            else{
                return "<A href=\"#FUNCIONES:"+f.getIden()+":"+name+"\">"+name+"</A>";
            }
        }
        else if (functions.contains(f)){
            return "<A href=\"#FUNCIONES:"+name+"\">"+name+"</A>";
        }
        else{
            return "<A href=\"#PROGRAMA_PRINCIPAL:"+name+"\">"+name+"</A>";
        }
    }

    public String getNamePath(String name,String fun){
        Function f = getFunction(fun);
        if(f == null){
            return name;
        }
        if (f.containsParam(name)){
            if(f.getIden().equals("Main")){
                return "<A name=\"PROGRAMA_PRINCIPAL:"+f.getIden()+":"+name+"\">"+name+"</A>";
            }
            else{
                return "<A name=\"FUNCIONES:"+f.getIden()+":"+name+"\">"+name+"</A>";
            }
        }
        else if (functions.contains(f)){
            return "<A name=\"FUNCIONES:"+name+"\">"+name+"</A>";
        }
        else{
            return "<A name=\"PROGRAMA_PRINCIPAL:"+name+"\">"+name+"</A>";
        }
    }

    public Function getFunction(String name){
        if(name.equals("Main")){
            return main;
        }
        else{
            for (Function f: functions) {
                if (f.getIden().equals(name)){
                   return f;
                }
            }
            return null;
        }
    }

    public void title(String nombre){
        String s="<html> \n"+
                "<head> \n" +
                "<style> \n"+
                    ".cte {\n"+
                        "color: limegreen;}\n"+
                    ".palres {\n"+
                        "color: black;\n"+
                        "font-weight: bold;}\n"+
                    ".ident {\n"+
                        "color: blue;}\n"+
                "</style>\n"+
                "<A name=\"Inicio\"><title>"+nombre+"</A></title>\n"+
                "</head>\n"+
                "<body>\n"+
                "<h1> Programa: "+nombre+"</h1>\n";
        pw.println(s);
    }
    public void functions(){
        String s="<h2>Funciones</h2>\n"+
                "<ul>\n"+
                "<A href=\"#Main\"><li>Programa Principal</li></A>\n";
        if(!functions.isEmpty()) {
            for (Function f : functions) {
                s=s+"<A href=\"#"+f.getIden()+"\"><li>"+f.getCabecera()+"</li></A>\n";
            }
        }
        s=s+"</ul>\n<hr/>";
        write(s);
    }
    public void writeFunctions(){
        String s="";
        for (Function f: functions) {
            s = "<div>" + f.getCabeceraHTML() + "</div>\n" +
                    "<div>{</div>\n" +
                    "<div style=\"text-indent:1cm\">\n" + f.getSentencias() + "\n" +
                    "</div>\n" +
                    "<div>}</div>\n" +
                    "<div><A href=\"#"+f.getIden()+"\">Inicio de la funcion</A> <A href=\"#Inicio\">Inicio del programa principal</A></div>\n" +
                    "<hr/>";
            write(s);
        }
    }
    public void writeMain(){
        String s="<A name=\"Main\"><h2>Programa principal</h2></A>\n"+globales+
                "<br>"+
                "<div>"+main.getCabeceraHTML()+"</div>\n"+
                "<div>{</div>\n"+
                "<div style=\"text-indent:1cm\">\n"+main.getSentencias()+"\n"+
                "</div>\n"+
                "<div>}</div>\n"+
                "<div><A href=\"#Main\">Inicio del programa principal</A> <A href=\"#Inicio\">Inicio del programa principal</A></div>\n"+
                "<hr/>";
        write(s);
    }
    public void writeFile(){
        functions();
        if(!functions.isEmpty()){
            writeFunctions();
        }
        writeMain();
        closeFile();
    }
    public void write(String s){
        pw.append(s);
        pw.flush();
    }

    public void closeFile(){
        write("</body>\n</html>");
        pw.close();
    }
}
