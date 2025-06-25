package service;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

/**
 * VNPay Payment Integration Service
 * Based on VNPay API documentation and examples
 */
public class VNPayService {

  private static final Logger LOGGER = Logger.getLogger(VNPayService.class.getName());

  // VNPay Configuration (should be moved to properties file in production)
  private static final String VNP_VERSION = "2.1.0";
  private static final String VNP_COMMAND = "pay";
  private static final String VNP_ORDER_TYPE = "other";
  private static final String VNP_CURRENCY_CODE = "VND";
  private static final String VNP_LOCALE = "vn";

  // Sandbox configuration - replace with production values
  private static final String VNP_TMN_CODE = "DEMOV210"; // Test merchant code
  private static final String VNP_HASH_SECRET = "LMVTNKCCKLBZKEXNFOPKJEJWDTAMQAYPAZFNAWDFXKKKCFQKWBKKRDYEVGPPUNSE"; // Test
                                                                                                                    // secret
  private static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
  private static final String VNP_API_URL = "https://sandbox.vnpayment.vn/merchant_webapi";

  /**
   * Generate VNPay payment URL with booking information
   */
  public String generatePaymentUrl(String orderId, long amount, String orderInfo,
      String customerInfo, String returnUrl, String ipAddress) {
    try {
      Map<String, String> vnpParams = new TreeMap<>();

      vnpParams.put("vnp_Version", VNP_VERSION);
      vnpParams.put("vnp_Command", VNP_COMMAND);
      vnpParams.put("vnp_TmnCode", VNP_TMN_CODE);
      vnpParams.put("vnp_Amount", String.valueOf(amount * 100)); // VNPay expects amount in VND cents
      vnpParams.put("vnp_CurrCode", VNP_CURRENCY_CODE);
      vnpParams.put("vnp_TxnRef", orderId);
      vnpParams.put("vnp_OrderInfo", orderInfo);
      vnpParams.put("vnp_OrderType", VNP_ORDER_TYPE);
      vnpParams.put("vnp_Locale", VNP_LOCALE);
      vnpParams.put("vnp_ReturnUrl", returnUrl);
      vnpParams.put("vnp_IpAddr", ipAddress);

      // Add timestamp
      Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
      SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
      String vnpCreateDate = formatter.format(cld.getTime());
      vnpParams.put("vnp_CreateDate", vnpCreateDate);

      // Add expiry time (15 minutes from now)
      cld.add(Calendar.MINUTE, 15);
      String vnpExpireDate = formatter.format(cld.getTime());
      vnpParams.put("vnp_ExpireDate", vnpExpireDate);

      // Build query string
      StringBuilder query = new StringBuilder();
      for (Map.Entry<String, String> entry : vnpParams.entrySet()) {
        if (query.length() > 0) {
          query.append('&');
        }
        query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8.toString()));
        query.append('=');
        query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8.toString()));
      }

      // Generate signature
      String signData = query.toString();
      String signature = hmacSHA512(VNP_HASH_SECRET, signData);

      // Build final URL
      String paymentUrl = VNP_PAY_URL + "?" + query.toString() + "&vnp_SecureHash=" + signature;

      LOGGER.info("Generated VNPay URL: " + paymentUrl);
      return paymentUrl;

    } catch (Exception e) {
      LOGGER.severe("Error generating VNPay payment URL: " + e.getMessage());
      return null;
    }
  }

  /**
   * Verify VNPay callback signature
   */
  public boolean verifyPaymentCallback(Map<String, String> params) {
    try {
      String vnpSecureHash = params.get("vnp_SecureHash");
      if (vnpSecureHash == null) {
        return false;
      }

      // Remove hash from params for verification
      params.remove("vnp_SecureHash");
      params.remove("vnp_SecureHashType");

      // Sort parameters
      Map<String, String> sortedParams = new TreeMap<>(params);

      // Build query string
      StringBuilder query = new StringBuilder();
      for (Map.Entry<String, String> entry : sortedParams.entrySet()) {
        if (query.length() > 0) {
          query.append('&');
        }
        query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8.toString()));
        query.append('=');
        query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8.toString()));
      }

      // Generate signature
      String signData = query.toString();
      String computedHash = hmacSHA512(VNP_HASH_SECRET, signData);

      return computedHash.equals(vnpSecureHash);

    } catch (Exception e) {
      LOGGER.severe("Error verifying VNPay callback: " + e.getMessage());
      return false;
    }
  }

  /**
   * Process VNPay payment result
   */
  public PaymentResult processPaymentResult(Map<String, String> params) {
    PaymentResult result = new PaymentResult();

    try {
      // Verify signature first
      if (!verifyPaymentCallback(new HashMap<>(params))) {
        result.setSuccess(false);
        result.setMessage("Invalid signature");
        return result;
      }

      String responseCode = params.get("vnp_ResponseCode");
      String transactionNo = params.get("vnp_TransactionNo");
      String orderId = params.get("vnp_TxnRef");
      String amount = params.get("vnp_Amount");
      String bankCode = params.get("vnp_BankCode");
      String payDate = params.get("vnp_PayDate");

      // Check if payment was successful
      if ("00".equals(responseCode)) {
        result.setSuccess(true);
        result.setTransactionId(transactionNo);
        result.setOrderId(orderId);
        result.setAmount(Long.parseLong(amount) / 100); // Convert back from cents
        result.setBankCode(bankCode);
        result.setPaymentDate(payDate);
        result.setMessage("Payment successful");
      } else {
        result.setSuccess(false);
        result.setOrderId(orderId);
        result.setMessage(getErrorMessage(responseCode));
      }

    } catch (Exception e) {
      LOGGER.severe("Error processing VNPay payment result: " + e.getMessage());
      result.setSuccess(false);
      result.setMessage("Error processing payment");
    }

    return result;
  }

  /**
   * Generate HMAC SHA512 signature
   */
  private String hmacSHA512(String key, String data) {
    try {
      Mac hmac512 = Mac.getInstance("HmacSHA512");
      SecretKeySpec secretKey = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
      hmac512.init(secretKey);
      byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));

      StringBuilder sb = new StringBuilder();
      for (byte b : result) {
        sb.append(String.format("%02x", b));
      }
      return sb.toString();

    } catch (Exception e) {
      LOGGER.severe("Error generating HMAC SHA512: " + e.getMessage());
      return null;
    }
  }

  /**
   * Get error message from VNPay response code
   */
  private String getErrorMessage(String responseCode) {
    switch (responseCode) {
      case "07":
        return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
      case "09":
        return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.";
      case "10":
        return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
      case "11":
        return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán.";
      case "12":
        return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.";
      case "13":
        return "Giao dịch không thành công do Quý khách nhập sai mật khẩu xác thực giao dịch (OTP).";
      case "24":
        return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
      case "51":
        return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch.";
      case "65":
        return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày.";
      case "75":
        return "Ngân hàng thanh toán đang bảo trì.";
      case "79":
        return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định.";
      default:
        return "Giao dịch thất bại";
    }
  }

  /**
   * Inner class to represent payment result
   */
  public static class PaymentResult {
    private boolean success;
    private String message;
    private String transactionId;
    private String orderId;
    private long amount;
    private String bankCode;
    private String paymentDate;

    // Getters and setters
    public boolean isSuccess() {
      return success;
    }

    public void setSuccess(boolean success) {
      this.success = success;
    }

    public String getMessage() {
      return message;
    }

    public void setMessage(String message) {
      this.message = message;
    }

    public String getTransactionId() {
      return transactionId;
    }

    public void setTransactionId(String transactionId) {
      this.transactionId = transactionId;
    }

    public String getOrderId() {
      return orderId;
    }

    public void setOrderId(String orderId) {
      this.orderId = orderId;
    }

    public long getAmount() {
      return amount;
    }

    public void setAmount(long amount) {
      this.amount = amount;
    }

    public String getBankCode() {
      return bankCode;
    }

    public void setBankCode(String bankCode) {
      this.bankCode = bankCode;
    }

    public String getPaymentDate() {
      return paymentDate;
    }

    public void setPaymentDate(String paymentDate) {
      this.paymentDate = paymentDate;
    }
  }
}