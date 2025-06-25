# VNPay Integration Guide - Spa Management System

## Overview

This document describes the VNPay online payment integration implemented in the Spa Management System. VNPay is a leading Vietnamese payment gateway that supports multiple payment methods including Internet Banking, QR Code, and ATM cards.

## Features Implemented

### ✅ **Payment Methods Supported**

- **Cash Payment**: Traditional payment at spa location
- **VNPay Online Payment**: Internet Banking, QR Code, ATM cards
  - Supports major Vietnamese banks: Vietcombank, Techcombank, BIDV, ACB, MBBank, etc.

### ✅ **Booking Flow Integration**

1. **Service Selection**: Customer selects spa services
2. **Time & Therapist Selection**: Customer chooses appointment time and preferred therapist
3. **Payment**: Customer can choose between cash or VNPay online payment
4. **Confirmation**: Booking confirmed with transaction details

### ✅ **Security Features**

- HMAC SHA512 signature verification
- Session-based transaction validation
- Secure parameter encoding
- Transaction timeout (15 minutes)

## Technical Implementation

### **New Files Created**

#### 1. `src/main/java/service/VNPayService.java`

- Core VNPay integration service
- Payment URL generation
- Signature verification
- Payment result processing
- Error message handling

#### 2. `src/main/resources/vnpay.properties`

- Configuration properties for VNPay settings
- Sandbox and production environment support
- Easy configuration management

#### 3. `VNPAY_INTEGRATION_GUIDE.md`

- This comprehensive documentation

### **Modified Files**

#### 1. `src/main/java/controller/BookingController.java`

- Added VNPay service injection
- New endpoints:
  - `POST /process-booking/vnpay-payment`: Initialize VNPay payment
  - `GET /process-booking/vnpay-return`: Handle VNPay callback
- Enhanced payment processing logic
- Improved booking session management

#### 2. `src/main/webapp/WEB-INF/view/customer/appointments/payment.jsp`

- Added VNPay payment option UI
- Enhanced booking summary with time/therapist details
- Improved JavaScript for payment method selection
- VNPay-specific payment processing

## API Endpoints

### **VNPay Payment Flow**

```
1. POST /process-booking/vnpay-payment
   - Initiates VNPay payment
   - Generates payment URL
   - Returns: {"success": true, "paymentUrl": "https://..."}

2. Customer redirected to VNPay portal
   - Completes payment on VNPay website
   - VNPay processes payment

3. GET /process-booking/vnpay-return
   - VNPay callback with payment result
   - Verifies signature and processes result
   - Creates booking appointments on success
   - Redirects to confirmation page
```

### **Enhanced Booking Session Persistence**

```
POST /process-booking/save-time-therapists
- Saves both time slot and therapist selections
- Updates booking session in database
- Validates all required data before proceeding
```

## Payment Information Flow

### **Data Passed to VNPay**

- **Order ID**: Unique identifier (sessionId_timestamp)
- **Amount**: Total booking amount in VND
- **Order Info**: Service names, therapist names, appointment date/time
- **Customer Info**: Customer name from session
- **Return URL**: Callback URL for payment result

### **Example Order Info Format**

```
"Thanh toan dich vu spa - Massage Thái (Linh Chi), Chăm sóc da mặt (Mai Anh) - Ngay: 2025-01-20 luc 14:30"
```

### **Payment Result Processing**

- Signature verification using HMAC SHA512
- Transaction amount validation
- Order ID matching
- Automatic appointment creation on success
- Booking session cleanup after completion

## Configuration

### **Sandbox Environment (Default)**

```properties
vnpay.tmn.code=DEMOV210
vnpay.hash.secret=LMVTNKCCKLBZKEXNFOPKJEJWDTAMQAYPAZFNAWDFXKKKCFQKWBKKRDYEVGPPUNSE
vnpay.pay.url=https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
```

### **Production Environment Setup**

1. Register with VNPay and obtain merchant credentials
2. Update `src/main/resources/vnpay.properties`:
   ```properties
   vnpay.tmn.code=YOUR_MERCHANT_CODE
   vnpay.hash.secret=YOUR_SECRET_KEY
   vnpay.pay.url=https://pay.vnpay.vn/vpcpay.html
   vnpay.environment=production
   ```

## Testing

### **Sandbox Test Data**

For testing VNPay payments in sandbox environment:

**Bank**: NCB  
**Card Number**: 9704198526191432198  
**Cardholder Name**: NGUYEN VAN A  
**Issue Date**: 07/15  
**OTP Password**: 123456

### **Test Flow**

1. Navigate to booking process
2. Select services, time, and therapist
3. Choose "Thanh toán online qua VNPay" payment method
4. Click "Thanh toán qua VNPay"
5. Complete payment on VNPay portal using test data
6. Verify successful return to confirmation page

## Error Handling

### **Payment Failures**

- Network errors: User-friendly error messages
- Invalid signatures: Security validation failures
- Payment rejections: Bank-specific error codes translated to Vietnamese
- Timeouts: 15-minute payment window with automatic expiry

### **Common Error Scenarios**

- `payment_failed`: Payment rejected by bank
- `verification_failed`: Security signature mismatch
- `system_error`: Technical issues during processing

## Security Considerations

### **Implemented Security Measures**

1. **HMAC SHA512 Signature**: All requests/responses verified
2. **Session Validation**: Order ID and amount matching
3. **Timeout Protection**: 15-minute payment window
4. **Parameter Encoding**: All data properly encoded
5. **IP Address Tracking**: Transaction logging with client IP

### **Production Security Recommendations**

1. Use HTTPS for all VNPay communications
2. Regularly rotate VNPay secret keys
3. Implement rate limiting for payment endpoints
4. Monitor transaction logs for suspicious activity
5. Set up proper error logging and alerting

## Logging and Monitoring

### **Key Log Points**

- Payment URL generation
- VNPay callback processing
- Signature verification results
- Transaction success/failure
- Booking session state changes

### **Sample Log Entries**

```
INFO: Generated VNPay URL for order: session123_1642683600000
INFO: VNPay payment successful: Transaction 14374093, Order session123_1642683600000
WARNING: VNPay payment verification failed for order: session123_1642683600000
```

## Maintenance and Support

### **Regular Maintenance Tasks**

1. Monitor VNPay transaction success rates
2. Update bank list in payment UI as needed
3. Review and update error message translations
4. Check VNPay API version compatibility
5. Update test credentials if sandbox changes

### **Support Procedures**

1. **Payment Issues**: Check transaction logs and VNPay portal
2. **Integration Issues**: Verify signature generation and API calls
3. **Booking Issues**: Validate booking session state and data integrity

## Performance Optimization

### **Implemented Optimizations**

1. **Efficient Signature Generation**: Optimized HMAC SHA512 implementation
2. **Minimal Payment Data**: Only essential information sent to VNPay
3. **Session Cleanup**: Automatic cleanup after successful payments
4. **Error Recovery**: Graceful handling of network timeouts

### **Monitoring Metrics**

- Payment completion rate
- Average payment processing time
- VNPay API response times
- Error rate by error type

## Future Enhancements

### **Potential Improvements**

1. **Multiple Payment Methods**: Add other Vietnamese payment gateways
2. **Recurring Payments**: Support for membership packages
3. **Partial Payments**: Split payments for expensive services
4. **Mobile Optimization**: Enhanced mobile payment experience
5. **Analytics Dashboard**: Payment method preference analysis

---

## Quick Start Checklist

- [ ] VNPay service credentials configured
- [ ] Test payments working with sandbox
- [ ] Production configuration ready
- [ ] Error handling tested
- [ ] Logging configured
- [ ] Security measures verified
- [ ] Documentation updated

For technical support or questions about this integration, please refer to the VNPay official documentation at: https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop
