# WebSocket Booking Test System Documentation

## Overview
This comprehensive WebSocket-based test system validates real-time booking slot reservation functionality and prevents double-booking scenarios in the G1_SpaManagement spa system.

## System Components

### 1. WebSocketBookingTestController.java
**Location:** `src/main/java/controller/WebSocketBookingTestController.java`

**Purpose:** Servlet controller that handles the test page display

**Features:**
- Handles GET requests at `/test/websocket-booking`
- Authentication check for MANAGER/ADMIN roles only
- Generates sample time slots (9:00 AM - 6:00 PM in 30-minute intervals)
- Provides sample service data for booking context
- Follows existing controller patterns from the spa management system

**Key Methods:**
- `generateSampleTimeSlots()` - Creates 19 time slots for testing
- `formatTimeDisplay()` - Converts 24h to 12h format
- `generateSampleServices()` - Creates sample spa services if none exist

### 2. websocket-booking-test.jsp
**Location:** `src/main/webapp/WEB-INF/view/test/websocket-booking-test.jsp`

**Purpose:** User-friendly test interface with real-time slot visualization

**Visual Features:**
- **Green slots**: Available (clickable)
- **Red slots**: Unavailable/booked (disabled)
- **Yellow slots**: Selected by current user (pending confirmation)
- **Orange slots**: Just booked by another user (real-time update with animation)

**UI Components:**
- Time slot grid with responsive design
- User simulation controls
- Console logging area for WebSocket events
- Connection status indicator
- Legend for slot status colors
- Reset and multi-user simulation buttons

**Styling:**
- Uses spa theme colors (primary: #D4AF37)
- Bootstrap 5 integration
- Smooth animations and transitions
- Vietnamese language labels

### 3. websocket-booking-test.js
**Location:** `src/main/webapp/js/websocket-booking-test.js`

**Purpose:** WebSocket client-side implementation

**Key Features:**
- **WebSocket Connection Management**: Auto-reconnect with exponential backoff
- **Real-time Slot Updates**: Immediate UI updates when slots are selected/booked
- **Double-booking Prevention**: Only one user can book each slot
- **User Simulation**: Test multiple users booking simultaneously
- **Console Logging**: Comprehensive event logging for debugging

**Message Format:**
```json
{
  "action": "book_slot",
  "timeSlot": "10:00",
  "slotId": "slot_1000",
  "userId": "user123",
  "userName": "Test User",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

**WebSocket Actions:**
- `connect` - User connection
- `select_slot` - Temporary slot selection (30-second hold)
- `book_slot` - Confirm booking
- `release_slot` - Release held slot
- `reset_test` - Clear all bookings

### 4. BookingWebSocketEndpoint.java
**Location:** `src/main/java/websocket/BookingWebSocketEndpoint.java`

**Purpose:** Server-side WebSocket endpoint for real-time communication

**Key Features:**
- **Session Management**: Tracks all connected users
- **Slot Reservation Logic**: Prevents double-booking with atomic operations
- **Temporary Selections**: 30-second hold on selected slots
- **Broadcasting**: Real-time updates to all connected clients
- **Auto-cleanup**: Releases slots when users disconnect

**Data Structures:**
- `sessions` - All connected WebSocket sessions
- `sessionUsers` - User info for each session
- `slotReservations` - Confirmed bookings (slotId → UserInfo)
- `slotSelections` - Temporary selections (slotId → UserInfo)

**Message Handling:**
- Validates user authentication
- Checks slot availability before booking
- Broadcasts updates to all connected clients
- Handles connection/disconnection events

### 5. WebSocketConfig.java
**Location:** `src/main/java/config/WebSocketConfig.java`

**Purpose:** Enables WebSocket support in the application

**Configuration:**
- Implements `ServerApplicationConfig`
- Enables annotation-based WebSocket endpoints
- Scans for `@ServerEndpoint` annotated classes

## Test Scenarios

### 1. Basic Slot Selection
1. User clicks available slot (green)
2. Slot immediately turns yellow (selected)
3. Other users see slot as unavailable
4. After 3 seconds, booking is auto-confirmed
5. Slot turns red (booked) for all users

### 2. Double-booking Prevention
1. User A selects a slot
2. User B tries to select the same slot
3. User B receives error message
4. Only User A can confirm the booking
5. Slot becomes unavailable to all others

### 3. Multi-user Simulation
1. Click "Mô phỏng nhiều user" button
2. System simulates 3 users trying to book same slot
3. Only first user succeeds
4. Others receive "slot unavailable" messages
5. Console shows all attempts and results

### 4. Connection Management
1. WebSocket disconnection is detected
2. System attempts auto-reconnect (max 5 attempts)
3. User's held slots are released on disconnect
4. Other users are notified of disconnection

### 5. Test Reset
1. Manager/Admin clicks "Reset Test"
2. All slot reservations are cleared
3. All slots return to available (green) state
4. All connected users receive reset notification

## Technical Implementation

### WebSocket URL
```
ws://localhost:8080/G1_SpaManagement/booking-websocket
```

### Authentication & Authorization
- Only MANAGER and ADMIN roles can access test page
- Added to AuthorizationFilter: `/test/websocket-booking`
- Session-based authentication check in controller

### Database Integration
- Uses existing ServiceDAO for service data
- No persistent storage for test bookings
- In-memory slot management for testing purposes

### Error Handling
- WebSocket connection failures with auto-reconnect
- Slot booking conflicts with user-friendly messages
- Session timeout handling
- Comprehensive logging for debugging

## Usage Instructions

### 1. Access the Test System
1. Login as MANAGER or ADMIN user
2. Navigate to: `http://localhost:8080/G1_SpaManagement/test/websocket-booking`
3. Verify WebSocket connection (green indicator)

### 2. Test Single User Booking
1. Click any green time slot
2. Watch slot turn yellow (selected)
3. Wait 3 seconds for auto-confirmation
4. Slot turns red (booked)

### 3. Test Multi-user Scenario
1. Open multiple browser tabs/windows
2. Login as different users in each tab
3. Try to book the same slot simultaneously
4. Observe real-time updates across all tabs

### 4. Monitor WebSocket Events
1. Watch console log for real-time events
2. Monitor connection status indicator
3. Use browser developer tools for WebSocket debugging

### 5. Reset Test Environment
1. Click "Reset Test" button
2. All slots return to available state
3. Start new test scenarios

## Integration with Existing System

### Database Schema Compatibility
- Uses existing `services` table for service data
- Compatible with `bookings` table structure
- No modifications to existing database schema

### Authentication Integration
- Uses existing User model and session management
- Integrates with AuthorizationFilter
- Maintains role-based access control

### Styling Consistency
- Uses spa management system color scheme
- Consistent with existing JSP header/footer structure
- Bootstrap 5 integration matches existing pages

## Setup Instructions

### 1. WebSocket Dependency Configuration
The WebSocket functionality requires proper server support. Ensure your application server (Tomcat, GlassFish, etc.) supports Jakarta WebSocket API 2.1.0+.

### 2. Compilation Requirements
If you encounter WebSocket compilation issues:

1. **For Development/Testing**: The test page will work without WebSocket (shows connection error)
2. **For Full Functionality**: Ensure WebSocket API is available at runtime
3. **Server Configuration**: Deploy to a Jakarta EE compatible server

### 3. Alternative Testing Approach
If WebSocket is not available:
1. The test page will still load and show the UI
2. Slot selection will work locally (no real-time sync)
3. Console will show WebSocket connection errors
4. Use this for UI/UX testing

## Troubleshooting

### WebSocket Connection Issues
1. **Server Support**: Ensure server supports Jakarta WebSocket API
2. **URL Path**: Verify `/booking-websocket` endpoint is accessible
3. **Browser Console**: Check for connection errors
4. **Authentication**: Ensure proper user authentication
5. **Firewall**: Check if WebSocket connections are blocked

### Slot Booking Problems
1. Verify user authentication
2. Check slot availability in console log
3. Monitor WebSocket message flow
4. Reset test environment if needed

### Performance Considerations
- Maximum 50 concurrent WebSocket connections
- 30-second timeout for slot selections
- Automatic cleanup of disconnected users
- In-memory storage for test data only

## Future Enhancements

### Potential Improvements
1. **Database Persistence**: Store test results for analysis
2. **Load Testing**: Support for hundreds of concurrent users
3. **Advanced Scheduling**: Integration with real booking system
4. **Analytics Dashboard**: Booking pattern analysis
5. **Mobile Support**: Touch-friendly interface for tablets

### Integration Opportunities
1. **Real Booking System**: Connect to actual booking workflow
2. **Payment Integration**: Test payment processing with bookings
3. **Notification System**: Email/SMS confirmations
4. **Calendar Integration**: Sync with external calendar systems

## Conclusion

This WebSocket booking test system provides a comprehensive testing environment for real-time booking functionality. It successfully demonstrates:

- ✅ Real-time slot reservation
- ✅ Double-booking prevention
- ✅ Multi-user synchronization
- ✅ Connection management
- ✅ User-friendly interface
- ✅ Comprehensive logging
- ✅ Integration with existing authentication

The system is ready for production testing and can be extended for actual booking implementation in the spa management system.
