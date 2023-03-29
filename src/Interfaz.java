import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Interfaz extends JFrame implements ActionListener {
    private JButton boton;
    private JTextArea textArea;
    private JPanel panel;
    private String texto;

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
             //pasar a clase externa el código=> new OtraClase(textArea.getText())
        }
    }
}
