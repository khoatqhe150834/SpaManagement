# QR Code Auto Check-In System Implementation

## Overview

This document outlines the implementation of a QR code-based automatic check-in system for spa appointments. The system allows customers to scan a QR code to automatically check in for their appointments.

## Architecture

### Components

1. **AutoCheckInController** - Handles QR code scan and check-in processing
2. **QRCodeController** - Generates and serves QR code images
3. **QRCodeGenerator** - Utility class for QR code generation
4. **CheckinDAO** - Database operations for check-ins
5. **Checkin Model** - Represents check-in records
6. **JSP Result Page** - Displays check-in results

### Database Schema

- **checkins table**: Stores check-in records
  - `checkin_id` (Primary Key)
  - `appointment_id` (Foreign Key to appointments)
  - `customer_id` (Foreign Key to customers)
  - `checkin_time` (Timestamp)
  - `status` (SUCCESS, FAILED, PENDING)
  - `notes` (Additional information)

## Implementation Details

### 1. QR Code Generation

```java
// Generate QR code for appointment
String qrPath = QRCodeGenerator.generateAndSaveAppointmentQR(appointmentId);

// Get check-in URL
String checkInUrl = QRCodeGenerator.generateCheckInUrl(appointmentId);
```

### 2. Auto Check-In Process

1. Customer scans QR code
2. QR code contains URL: `/spa/autocheckin?appointmentId={id}`
3. AutoCheckInController validates:
   - Appointment exists and is confirmed
   - Check-in time window (10 minutes before to 30 minutes after start time)
   - No previous check-in exists
4. Creates check-in record
5. Updates appointment status to "IN_PROGRESS"
6. Displays result page

### 3. Time Window Validation

- **Early Check-in**: 10 minutes before appointment start time
- **Late Check-in**: Up to 30 minutes after appointment start time
- **Outside Window**: Shows appropriate error message

### 4. Security Considerations

- Validates appointment ID format
- Checks appointment ownership and status
- Prevents duplicate check-ins
- Handles expired or invalid appointments

## API Endpoints

### Auto Check-In

- **URL**: `/spa/autocheckin`
- **Method**: GET
- **Parameters**: `appointmentId` (required)
- **Response**: Forwards to check-in result JSP

### QR Code Generation

- **Generate New**: `/spa/qr/generate/{appointmentId}`
- **Get Existing**: `/spa/qr/appointment/{appointmentId}`
- **Response**: PNG image of QR code

## Usage Examples

### 1. Generate QR Code for Appointment

```jsp
<!-- In appointment confirmation email or page -->
<img src="${pageContext.request.contextPath}/qr/appointment/${appointment.appointmentId}"
     alt="QR Code for Check-in"
     class="qr-code" />
```

### 2. Manual QR Code Generation

```java
// In admin panel or staff interface
try {
    String qrPath = QRCodeGenerator.generateAndSaveAppointmentQR(appointmentId);
    // QR code saved and ready to use
} catch (WriterException | IOException e) {
    // Handle error
}
```

### 3. Check-in URL

```
http://localhost:8080/spa/autocheckin?appointmentId=5
```

## File Structure

```
src/main/java/
├── controller/
│   ├── AutoCheckInController.java      # Main check-in logic
│   └── QRCodeController.java          # QR code generation/serving
├── dao/
│   └── CheckinDAO.java                 # Database operations
├── model/
│   └── Checkin.java                    # Check-in model
└── util/
    └── QRCodeGenerator.java            # QR code utilities

src/main/webapp/
├── WEB-INF/view/checkin/
│   └── checkin-result.jsp              # Check-in result page
└── assets/qr/                          # Generated QR code storage
```

## Error Handling

### Common Error Scenarios

1. **Invalid Appointment ID**: Shows error message
2. **Appointment Not Found**: Displays appropriate error
3. **Wrong Status**: Appointment not confirmed
4. **Time Window**: Too early or too late for check-in
5. **Already Checked In**: Prevents duplicate check-ins

### Error Messages (Vietnamese)

- "ID lịch hẹn không hợp lệ"
- "Không tìm thấy lịch hẹn"
- "Lịch hẹn chưa được xác nhận"
- "Bạn có thể check-in từ X phút nữa"
- "Đã quá thời gian check-in"
- "Lịch hẹn này đã được check-in trước đó"

## Integration Points

### Email Notifications

Include QR code in appointment confirmation emails:

```html
<img
  src="http://your-domain.com/spa/qr/appointment/{{appointment_id}}"
  alt="Scan to check-in"
/>
```

### Staff Interface

Display QR code in appointment management:

```jsp
<c:if test="${appointment.status eq 'CONFIRMED'}">
    <div class="qr-code-section">
        <h6>QR Code Check-in</h6>
        <img src="${pageContext.request.contextPath}/qr/appointment/${appointment.appointmentId}"
             alt="QR Code" class="img-fluid" style="max-width: 200px;" />
        <p><small>Khách hàng có thể quét mã này để check-in</small></p>
    </div>
</c:if>
```

## Testing

### Test Scenarios

1. **Valid Check-in**: Within time window, confirmed appointment
2. **Early Check-in**: Before 10-minute window
3. **Late Check-in**: After 30-minute window
4. **Invalid ID**: Non-existent appointment ID
5. **Wrong Status**: Cancelled or pending appointment
6. **Duplicate Check-in**: Already checked in

### Test Data

Use appointment ID 5 from the sample data:

- Status: CONFIRMED
- Customer: Nguyễn Thị Mai
- Start Time: 2025-06-05 14:00:00

## Deployment Considerations

### QR Code Storage

- QR codes stored in `/assets/qr/` directory
- File naming: `appointment_{id}_qr.png`
- Consider implementing cleanup for old QR codes

### Performance

- QR codes cached after generation
- HTTP caching headers for QR images (1 hour cache)
- Database indexes on appointment_id and customer_id

### Security

- Validate all input parameters
- Rate limiting for QR generation endpoints
- Monitor for suspicious check-in patterns

## Future Enhancements

1. **Mobile App Integration**: Native QR scanner
2. **Real-time Notifications**: WebSocket updates to staff
3. **Analytics**: Check-in time patterns and statistics
4. **Offline Support**: Downloadable QR codes
5. **Multi-language Support**: Localized error messages
6. **SMS Integration**: Send QR codes via SMS

## Dependencies

### Required Libraries

- ZXing (com.google.zxing) - QR code generation
- Jakarta Servlet API - Web framework
- MySQL Connector - Database connectivity
- JSTL - JSP Standard Tag Library

### Configuration

Update base URL in QRCodeGenerator.java for production:

```java
private static final String BASE_URL = "https://your-domain.com/spa/autocheckin";
```
