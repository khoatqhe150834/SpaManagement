# WebSocket Real-time Booking System Implementation Guide
## G1_SpaManagement System

### Table of Contents
1. [Overview](#overview)
2. [Database Integration](#database-integration)
3. [WebSocket Implementation](#websocket-implementation)
4. [Real-time Features](#real-time-features)
5. [Security Considerations](#security-considerations)
6. [Error Handling](#error-handling)
7. [Testing Strategy](#testing-strategy)
8. [Deployment Notes](#deployment-notes)

---

## 1. Overview

### Architecture Benefits
The WebSocket-based real-time booking system provides:
- **Instant Updates**: Live booking status changes across all connected clients
- **Enhanced UX**: Real-time availability updates without page refreshes
- **Efficient Communication**: Bidirectional, low-latency data exchange
- **Scalability**: Support for multiple concurrent users and roles

### System Architecture
```
┌─────────────────┐    WebSocket    ┌─────────────────┐    Database    ┌─────────────────┐
│   Client Apps   │ ←──────────────→ │  WebSocket      │ ←─────────────→ │   MySQL DB      │
│ (Browser/Mobile)│                 │  Server         │                │ (Bookings, etc) │
└─────────────────┘                 └─────────────────┘                └─────────────────┘
```

### Integration with Existing System
- Extends current Java servlet architecture
- Maintains session-based authentication
- Preserves two-step booking process (payment → scheduling)
- Compatible with existing user roles and permissions

---

## 2. Database Integration

### Core Tables Structure
Based on `src/main/java/sql/schema_data_main.sql`:

#### Bookings Table
```sql
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    payment_item_id INT NOT NULL,
    service_id INT NOT NULL,
    therapist_user_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    booking_status ENUM('SCHEDULED', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW'),
    booking_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### Payment Items Table
```sql
CREATE TABLE payment_items (
    payment_item_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    service_duration INT NOT NULL
);
```

### WebSocket Event Mapping

#### Database Operations → WebSocket Events
- **INSERT booking** → `BOOKING_CREATED` event
- **UPDATE booking_status** → `BOOKING_STATUS_CHANGED` event
- **UPDATE therapist schedule** → `THERAPIST_SCHEDULE_UPDATED` event
- **INSERT payment** → `PAYMENT_COMPLETED` event

---

## 3. WebSocket Implementation

### Server-side Java WebSocket Endpoint

#### WebSocket Configuration
```java
// src/main/java/websocket/BookingWebSocketEndpoint.java
package websocket;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.server.PathParam;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import com.google.gson.Gson;

@ServerEndpoint(
    value = "/websocket/booking/{userType}/{userId}",
    configurator = WebSocketSessionConfigurator.class
)
public class BookingWebSocketEndpoint {
    
    // Store active sessions by user type and ID
    private static final ConcurrentHashMap<String, Set<Session>> userSessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();
    
    @OnOpen
    public void onOpen(Session session, @PathParam("userType") String userType, 
                      @PathParam("userId") String userId) {
        // Validate session authentication
        HttpSession httpSession = (HttpSession) session.getUserProperties().get("httpSession");
        if (!isValidSession(httpSession, userType, userId)) {
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.VIOLATED_POLICY, "Unauthorized"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        
        String userKey = userType + "_" + userId;
        userSessions.computeIfAbsent(userKey, k -> new CopyOnWriteArraySet<>()).add(session);
        
        // Send initial connection confirmation
        sendMessage(session, new WebSocketMessage("CONNECTION_ESTABLISHED", 
            "Connected to real-time booking system", null));
    }
    
    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            WebSocketMessage wsMessage = gson.fromJson(message, WebSocketMessage.class);
            handleMessage(wsMessage, session);
        } catch (Exception e) {
            sendError(session, "Invalid message format");
        }
    }
    
    @OnClose
    public void onClose(Session session, @PathParam("userType") String userType, 
                       @PathParam("userId") String userId) {
        String userKey = userType + "_" + userId;
        Set<Session> sessions = userSessions.get(userKey);
        if (sessions != null) {
            sessions.remove(session);
            if (sessions.isEmpty()) {
                userSessions.remove(userKey);
            }
        }
    }
    
    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
        sendError(session, "WebSocket error occurred");
    }
}
```

#### Message Handler
```java
private void handleMessage(WebSocketMessage message, Session session) {
    switch (message.getType()) {
        case "SUBSCRIBE_BOOKING_UPDATES":
            subscribeToBookingUpdates(message, session);
            break;
        case "SUBSCRIBE_THERAPIST_SCHEDULE":
            subscribeToTherapistSchedule(message, session);
            break;
        case "REQUEST_AVAILABILITY":
            sendAvailabilityUpdate(message, session);
            break;
        default:
            sendError(session, "Unknown message type: " + message.getType());
    }
}
```

### Client-side JavaScript WebSocket Connection

#### WebSocket Client Implementation
```javascript
// src/main/webapp/js/websocket-booking-client.js
class BookingWebSocketClient {
    constructor(userType, userId) {
        this.userType = userType;
        this.userId = userId;
        this.socket = null;
        this.reconnectAttempts = 0;
        this.maxReconnectAttempts = 5;
        this.reconnectDelay = 1000;
        this.eventHandlers = new Map();
    }
    
    connect() {
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = `${protocol}//${window.location.host}${window.spaConfig.contextPath}/websocket/booking/${this.userType}/${this.userId}`;
        
        this.socket = new WebSocket(wsUrl);
        
        this.socket.onopen = (event) => {
            console.log('WebSocket connected');
            this.reconnectAttempts = 0;
            this.onConnectionEstablished();
        };
        
        this.socket.onmessage = (event) => {
            try {
                const message = JSON.parse(event.data);
                this.handleMessage(message);
            } catch (error) {
                console.error('Error parsing WebSocket message:', error);
            }
        };
        
        this.socket.onclose = (event) => {
            console.log('WebSocket disconnected:', event.code, event.reason);
            this.attemptReconnect();
        };
        
        this.socket.onerror = (error) => {
            console.error('WebSocket error:', error);
        };
    }
    
    sendMessage(type, data) {
        if (this.socket && this.socket.readyState === WebSocket.OPEN) {
            const message = {
                type: type,
                data: data,
                timestamp: new Date().toISOString()
            };
            this.socket.send(JSON.stringify(message));
        } else {
            console.warn('WebSocket not connected. Message not sent:', type);
        }
    }
    
    handleMessage(message) {
        const handler = this.eventHandlers.get(message.type);
        if (handler) {
            handler(message.data);
        } else {
            console.log('Unhandled WebSocket message:', message.type);
        }
    }
    
    // Event subscription methods
    onBookingStatusChanged(callback) {
        this.eventHandlers.set('BOOKING_STATUS_CHANGED', callback);
    }
    
    onAvailabilityUpdated(callback) {
        this.eventHandlers.set('AVAILABILITY_UPDATED', callback);
    }
    
    onTherapistScheduleUpdated(callback) {
        this.eventHandlers.set('THERAPIST_SCHEDULE_UPDATED', callback);
    }
}
```

### Message Format Specifications

#### WebSocket Message Schema
```json
{
  "type": "string",           // Message type identifier
  "data": "object",           // Message payload
  "timestamp": "string",      // ISO 8601 timestamp
  "userId": "string",         // Optional: target user ID
  "userType": "string"        // Optional: target user type
}
```

#### Sample Message Payloads

**Booking Status Change:**
```json
{
  "type": "BOOKING_STATUS_CHANGED",
  "data": {
    "bookingId": 123,
    "customerId": 456,
    "therapistId": 789,
    "oldStatus": "SCHEDULED",
    "newStatus": "CONFIRMED",
    "appointmentDate": "2024-01-15",
    "appointmentTime": "14:30:00",
    "serviceName": "Swedish Massage"
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Availability Update:**
```json
{
  "type": "AVAILABILITY_UPDATED",
  "data": {
    "serviceId": 5,
    "therapistId": 789,
    "date": "2024-01-15",
    "availableSlots": [
      {"time": "09:00:00", "duration": 60},
      {"time": "11:00:00", "duration": 60},
      {"time": "15:30:00", "duration": 90}
    ]
  },
  "timestamp": "2024-01-15T10:30:00Z"
}
```

---

## 4. Real-time Features

### Live Booking Availability Updates
- **Trigger**: When booking is created/cancelled
- **Recipients**: All users viewing booking calendar
- **Data**: Updated time slots and availability

### Real-time Booking Status Notifications
- **Status Flow**: SCHEDULED → CONFIRMED → IN_PROGRESS → COMPLETED
- **Recipients**: Customer, assigned therapist, managers
- **Notifications**: Status change alerts with details

### Therapist Schedule Updates
- **Trigger**: Schedule modifications, booking assignments
- **Recipients**: Therapist, managers, reception staff
- **Data**: Updated schedule with booking details

### Customer Booking Confirmations
- **Trigger**: Booking creation, status changes
- **Recipients**: Specific customer
- **Data**: Booking details, appointment information

---

## 5. Security Considerations

### Authentication Integration
```java
// WebSocket Session Configurator
public class WebSocketSessionConfigurator extends ServerEndpointConfig.Configurator {
    @Override
    public void modifyHandshake(ServerEndpointConfig config, 
                               HandshakeRequest request, 
                               HandshakeResponse response) {
        HttpSession httpSession = (HttpSession) request.getHttpSession();
        config.getUserProperties().put("httpSession", httpSession);
    }
}
```

### Authorization Checks
- Validate user session before WebSocket connection
- Verify user permissions for specific booking operations
- Implement role-based message filtering

### Session Management
- Link WebSocket sessions to HTTP sessions
- Handle session expiration gracefully
- Implement secure session validation

---

## 6. Error Handling

### Connection Failures
```javascript
attemptReconnect() {
    if (this.reconnectAttempts < this.maxReconnectAttempts) {
        setTimeout(() => {
            this.reconnectAttempts++;
            console.log(`Reconnection attempt ${this.reconnectAttempts}`);
            this.connect();
        }, this.reconnectDelay * Math.pow(2, this.reconnectAttempts));
    }
}
```

### Message Delivery Guarantees
- Implement message acknowledgment system
- Handle duplicate message detection
- Provide fallback to HTTP polling for critical updates

### Fallback Mechanisms
- Graceful degradation when WebSocket unavailable
- HTTP-based polling as backup
- User notification of connection status

---

## 7. Testing Strategy

### Unit Tests
```java
// Example WebSocket endpoint test
@Test
public void testBookingStatusUpdate() {
    // Mock WebSocket session
    Session mockSession = mock(Session.class);
    
    // Test message handling
    BookingWebSocketEndpoint endpoint = new BookingWebSocketEndpoint();
    WebSocketMessage message = new WebSocketMessage("BOOKING_STATUS_CHANGED", bookingData, null);
    
    endpoint.handleMessage(message, mockSession);
    
    // Verify message was processed correctly
    verify(mockSession).getAsyncRemote();
}
```

### Integration Tests
- Test WebSocket connection establishment
- Verify message broadcasting to multiple clients
- Test authentication and authorization flows

### Load Testing
- Simulate multiple concurrent WebSocket connections
- Test message throughput and latency
- Verify system stability under load

---

## 8. Deployment Notes

### Configuration Requirements
```xml
<!-- web.xml WebSocket configuration -->
<web-app>
    <context-param>
        <param-name>websocket.enabled</param-name>
        <param-value>true</param-value>
    </context-param>
</web-app>
```

### Performance Considerations
- Configure appropriate connection pool sizes
- Implement message queuing for high-traffic scenarios
- Monitor WebSocket connection metrics

### Production Deployment
- Enable WebSocket support in application server
- Configure load balancer for WebSocket sticky sessions
- Implement monitoring and logging for WebSocket connections

---

## Implementation Checklist

- [ ] Create WebSocket endpoint classes
- [ ] Implement client-side WebSocket manager
- [ ] Add database triggers for real-time events
- [ ] Integrate with existing authentication system
- [ ] Implement error handling and reconnection logic
- [ ] Add comprehensive testing suite
- [ ] Configure production deployment settings
- [ ] Monitor and optimize performance

---

*This documentation provides a complete foundation for implementing WebSocket-based real-time booking functionality in the G1_SpaManagement system while maintaining compatibility with the existing architecture and user experience.*
