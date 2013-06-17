import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.TreeMap;

public class InteractiveClient extends WebSocketClient {

    private int id;

    public InteractiveClient(URI uri) {
        super(uri);
        id = -1;
    }

    public void onMessage( String message ) {
        if(id == -1) {
            id = Integer.parseInt(message);
            send( "[[\"subscribe\",\"persistent\"],\"random\"]" );
        } else {
            System.out.println(message);
        }
    }

    public void onError( Exception ex ) {
        System.out.println( "Error: " );
        ex.printStackTrace();
    }

    public void onOpen( ServerHandshake handshake ) {
        System.out.println("onopen");
    }

    public void onClose( int code, String reason, boolean remote ) {
        System.out.println( "closed: " + code + " " + reason );
    }

    public void send_message( String message ) {
        send(message);
    }


    public static void main( String[] args ) {
        String url = "ws://localhost:"+args[0];
        try {
            InteractiveClient e = new InteractiveClient(URI.create(url));
            Thread t = new Thread(e);
            t.start();
            Thread.sleep(1000);

            String CurLine = "";
            System.out.println("Enter a message to send (type 'quit' to exit): ");
            InputStreamReader converter = new InputStreamReader(System.in);
            BufferedReader in = new BufferedReader(converter);
            while (!(CurLine.equals("quit"))){
                CurLine = in.readLine();
                if (!(CurLine.equals("quit"))){
                    e.send_message(CurLine);
                }
            }

            t.join();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
