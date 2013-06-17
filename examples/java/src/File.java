import java.io.BufferedWriter;
import java.io.FileWriter;

public class File {

    public static void write(String content, String file) {
        try {
            FileWriter file_writer = new FileWriter(file);
            BufferedWriter out = new BufferedWriter(file_writer);
            out.write(content);
            out.close();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

}
