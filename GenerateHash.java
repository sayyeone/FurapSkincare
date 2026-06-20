import org.mindrot.jbcrypt.BCrypt;

public class GenerateHash {
    public static void main(String[] args) {
        System.out.println(BCrypt.hashpw("admin123", BCrypt.gensalt()));
        System.out.println(BCrypt.hashpw("cust123", BCrypt.gensalt()));
    }
}
