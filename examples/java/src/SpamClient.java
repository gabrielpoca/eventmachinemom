import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.TreeMap;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

public class SpamClient extends WebSocketClient {

    private int id;
    private int messages;
    private TreeMap<Integer, Long> received_time;
    private TreeMap<Integer, Long> sent_time;

    public SpamClient(URI uri, int messages) {
        super(uri);
        id = -1;
        this.messages = messages;
        received_time = new TreeMap<Integer, Long>();
        sent_time = new TreeMap<Integer, Long>();
    }

    public void onMessage( String message ) {
        System.out.println(message);
        if(id == -1) {
            id = Integer.parseInt(message);
        } else {
            try {
                received_time.put(Integer.parseInt(message), System.currentTimeMillis());
            } catch (Exception e) {
                System.out.println("Failed: "+message);
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

    public void custom_message(String message) {
        send(message);
    }

    public void spam() {
        for(int i = 0; i < messages; i++) {
            sent_time.put(i, System.currentTimeMillis());
            send( "[[\"random\"],\""+i+"\"]" );
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

    public static void main( String[] args ) {
        int messages = 1000;
        String url = "ws://localhost:"+args[0];

        try {
            SpamClient e = new SpamClient(URI.create(url), messages);
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

}
