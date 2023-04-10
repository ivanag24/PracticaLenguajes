import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.io.StringReader;

public class Interfaz extends JFrame implements ActionListener {
    private JButton boton;
    private JTextArea texto1;
    private JPanel panel;
    private JTextArea texto2;

    public Interfaz(){
        setContentPane(panel);
        setTitle("Compilar");
        setSize(750,500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        boton.addActionListener(this);
        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(e.getSource() == boton){
            texto2.setText("");
            String text= texto1.getText();
            StringReader reader = new StringReader(text);
            CharStream input ;
            try {
                input = CharStreams.fromReader(reader);
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
            GramaticaLexer lexico= new GramaticaLexer(input);
            lexico.removeErrorListeners();
            lexico.addErrorListener(new VerboseParser(texto2));
            CommonTokenStream tokens= new CommonTokenStream(lexico);
            GramaticaParser sintactico= new GramaticaParser(tokens);
            sintactico.removeErrorListeners();
            sintactico.addErrorListener(new VerboseParser(texto2));
            sintactico.program();
            if(!sintactico.getError()){
                JOptionPane.showMessageDialog(null, "Compilación completada", "Código correcto", JOptionPane.INFORMATION_MESSAGE);
            }
            else{
                JOptionPane.showMessageDialog(null, "Códigos con errores", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
}
