/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.email;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import lombok.Data;
/**
 *
 * @author quang
 */
public class OTPService {
    private static int OTP_LENGTH = 6;
    
    private static final int OTP_EXPIRY_MINUTES = 4;
    
    private static final SecureRandom secureRandom = new SecureRandom();
    
    private static final Map<String, OTPData> otpStore = new ConcurrentHashMap<>();
    
    
    
    @Data
    private static class OTPData {
        private final String otp;
        private final LocalDateTime expiryTime;
    }
    
    
    
    public String generateOTP(String email) {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTP_LENGTH; i++) {
            otp.append(secureRandom.nextInt(10));
            
        }
        
        String otpString = otp.toString();
        
        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(OTP_EXPIRY_MINUTES);
        otpStore.put(email, new OTPData(otpString, expiryTime));
        return otpString;
    }
    // generate OTP
    
    
    public boolean validateOTP(String email , String otp) {
        OTPData otpData = otpStore.get(email);
        
        if (otpData == null) {
            return false;
        }
        
        
        // check if otp is expired
        
        if (LocalDateTime.now().isAfter(otpData.getExpiryTime())) {
            otpStore.remove(email);
            return false;
        }
        
        // if otp is not expired
        boolean isValid = otpData.getOtp().equals(otp);
        
        if (isValid) {
            otpStore.remove(email);
        }
        
        return isValid;
        
      
    }
    
    
      public void removeOTP(String email) {
            otpStore.remove(email);
        }
}
