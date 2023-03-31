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
    private JTextArea textArea;
    private JPanel panel;


    public Interfaz(){
        setContentPane(panel);
        setTitle("Compilar");
        setSize(500,500);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        boton.addActionListener(this);
        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if(e.getSource() == boton){
            String text=textArea.getText();
            StringReader reader = new StringReader(text);
            CharStream input = null;
            try {
                input = CharStreams.fromReader(reader);
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
            GramaticaLexer lexico= new GramaticaLexer(input);
            CommonTokenStream tokens= new CommonTokenStream(lexico);
            GramaticaParser sintactico= new GramaticaParser(tokens);
            sintactico.program();

        }
    }
}
