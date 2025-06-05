package model;
import java.util.Date;
import java.util.UUID;

public class RememberMeToken {
    private int id;
    private String email;
    private String token;
    private String password; // Added password field
    private Date expiryDate;
    private Date createdAt;

    // Default constructor
    public RememberMeToken() {
    }

    // Constructor for creating a new token
    public RememberMeToken(String email, String password) {
        this.email = email;
        this.token = UUID.randomUUID().toString();
        this.password = password; // Store plain password (not recommended)
        this.createdAt = new Date();
        this.expiryDate = new Date(createdAt.getTime() + 30L * 24 * 60 * 60 * 1000); // 30 days
    }

    // Constructor for retrieving from database
    public RememberMeToken(int id, String email, String token, String password, Date expiryDate, Date createdAt) {
        this.id = id;
        this.email = email;
        this.token = token;
        this.password = password; // Retrieve password
        this.expiryDate = expiryDate;
        this.createdAt = createdAt;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    // Check if token is expired
    public boolean isExpired() {
        return new Date().after(expiryDate);
    }

    // toString for debugging
    @Override
    public String toString() {
        return "RememberMeToken{" +
               "id=" + id +
               ", email='" + email + '\'' +
               ", token='" + token + '\'' +
               ", password='[PROTECTED]'" + // Avoid logging password
               ", expiryDate=" + expiryDate +
               ", createdAt=" + createdAt +
               '}';
    }
}