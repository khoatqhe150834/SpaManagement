package model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 *
 * @author quang
 */
public class EmailVerificationToken {

  private String userEmail;
  private String token; // Sẽ được tạo bởi generateToken()
  private LocalDateTime expiryDate;
  private static final int TOKEN_VALIDITY_HOURS = 24;
  private boolean isUsed;

  // Constructor: Có thể bạn muốn token được tạo ngay khi khởi tạo,
  // hoặc gọi generateToken() sau đó.
  // Ở đây, chúng ta sẽ để token được tạo thông qua phương thức riêng.

  // Constructor có thể bao gồm việc tạo token ngay lập tức
  // Constructor for new tokens
  public EmailVerificationToken(String userEmail) {
    this.userEmail = userEmail;
    this.token = generateToken();
    this.expiryDate = LocalDateTime.now().plusHours(TOKEN_VALIDITY_HOURS);
    isUsed = false;
  }

  // Constructor for existing tokens from database
  public EmailVerificationToken(String userEmail, String token, LocalDateTime expiryDate) {
    this.userEmail = userEmail;
    this.token = token;
    this.expiryDate = expiryDate;
  }

  // Generate a UUID token
  private String generateToken() {
    return UUID.randomUUID().toString();
  }

  // Getters
  public String getToken() {
    return token;
  }

  public boolean isIsUsed() {
    return isUsed;
  }

  public void setIsUsed(boolean isUsed) {
    this.isUsed = isUsed;
  }

  public String getUserEmail() {
    return userEmail;
  }

  public LocalDateTime getExpiryDate() {
    return this.expiryDate; // Return the stored expiry date
  }

  // Check if token is expired
  public boolean isExpired() {
    return LocalDateTime.now().isAfter(expiryDate);
  }

  // Validate token
  public boolean isValid(String providedToken) {
    return this.token.equals(providedToken) && !isExpired();
  }

}