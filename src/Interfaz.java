import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import javax.swing.*;
import java.io.*;

public class Interfaz extends JFrame {
    private JPanel panel;
    private JTextArea areaTexto;

    public Interfaz() {
        setContentPane(panel);
        setTitle("Compilar");
        setSize(750, 500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setVisible(true);
        JFileChooser seleccionar = new JFileChooser();
        seleccionar.setCurrentDirectory(new File("."));
        seleccionar.setDialogTitle("Seleccione el archivo");
        seleccionar.setFileSelectionMode(JFileChooser.FILES_ONLY);
        seleccionar.setAcceptAllFileFilterUsed(false);
        if (seleccionar.showOpenDialog(panel) == JFileChooser.APPROVE_OPTION) {
            File archivo = seleccionar.getSelectedFile();
            try {
                CharStream input = CharStreams.fromFileName(archivo.getName());
                String userDirectory = System.getProperty("user.dir");
                GramaticaLexer lexico = new GramaticaLexer(input);
                lexico.removeErrorListeners();
                VerboseListener verboseListener = new VerboseListener(areaTexto);
                lexico.addErrorListener(verboseListener);
                CommonTokenStream tokens = new CommonTokenStream(lexico);
                GramaticaParser sintactico = new GramaticaParser(tokens,archivo.getName(),userDirectory);
                sintactico.removeErrorListeners();
                VerboseParser verboseParser = new VerboseParser(areaTexto);
                sintactico.addErrorListener(verboseParser);
                sintactico.setErrorHandler(new ReportError());
                sintactico.program();
                sintactico.closeFile();
                if (!verboseParser.getError() && !verboseListener.getError()) {
                    JOptionPane.showMessageDialog(null, "Compilación completada", "Código correcto", JOptionPane.INFORMATION_MESSAGE);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
