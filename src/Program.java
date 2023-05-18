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
    public void addFunction(String iden, String cabecera, String sentencia){
        Function function= new Function(iden,cabecera,sentencia);
        functions.add(function);
    }

    public void addMain(String cabecera, String sentencia){
        main=new Function("Main",cabecera,sentencia);
        functions.add(main);
    }

    public void addCabecera(String global){
        globales=globales+global;
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
                "<title>"+nombre+"</title>\n"+
                "</head>\n"+
                "<h1> Programa: "+nombre+"</h1>\n";
        pw.println(s);
    }
    public void functions(){
        String s="<h2>Funciones</h2>\n";

    }

    public void write(String s){
        pw.append(s);
        pw.flush();
    }

    public void closeFile(){
        write("</html>");
        pw.close();
    }
}
