import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Program {
    private ArrayList<Function> functions= new ArrayList<>();
    private Function main;
    private File file;
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
    public void newFunction(String iden, String cabecera, List<String> sentencia){
        Function function= new Function(iden,cabecera,sentencia);
        functions.add(function);
    }

    public void addMain(String iden, String cabecera, List<String> sentencia){
        main=new Function(iden,cabecera,sentencia);
        functions.add(main);
    }

    public void title(String nombre){
        String s="<html> \n"+
                "<head> \n" +
                "<title>"+nombre+"</title>\n"+
                "</head>\n"+
                "<h1> Programa: "+nombre+"</h1>\n";
        pw.println(s);
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
