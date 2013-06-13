import java.io.IOException;
import java.net.URI;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.TreeMap;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

public class JavaClient extends WebSocketClient {

    private int id;
    private int messages;

    private TreeMap<Integer, Long> received_time;
    private TreeMap<Integer, Long> sent_time;

    public JavaClient(URI uri, int messages) {
        super(uri);
        id = -1;
        this.messages = messages;
        received_time = new TreeMap<Integer, Long>();
        sent_time = new TreeMap<Integer, Long>();
    }

    public static void main( String[] args ) {
        int messages = Integer.parseInt(args[1]);
        String url = "ws://localhost:"+args[0];

        try {

            JavaClient e = new JavaClient(URI.create(url), messages);
            Thread t = new Thread(e);
            t.start();
            Thread.sleep(1000);
            System.out.print("ENTER to spam "+messages+" messages: ");
            System.in.read();
            e.spam();
            t.join();

        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.exit(0);
    }

    public void onMessage( String message ) {
        if(id == -1) {
            id = Integer.parseInt(message);
        } else {
            received_time.put(Integer.parseInt(message), System.currentTimeMillis());
            if(received_time.size() == messages) {
                dump();
            }
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
        System.out.println( "Closed: " + code + " " + reason );
    }

    public void spam() {
        for(int i = 0; i < messages; i++) {
            sent_time.put(i, System.currentTimeMillis());
            send( "[[\"all\"],\""+i+"\"]" );
        }
    }

    public void dump() {
        System.out.print("Average: "+averageLatency());
    }

    private long averageLatency() {
        long result = 0;
        for(int i : received_time.keySet()) {
            result += (received_time.get(i) - sent_time.get(i));
        }
        return result/received_time.size();
    }

}
