package websocket;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * WebSocket endpoint for real-time booking slot management
 * Handles real-time communication for booking slot reservations
 * and prevents double-booking scenarios
 * 
 * @author SpaManagement
 */
@ServerEndpoint("/booking-websocket")
public class BookingWebSocketEndpoint {
    
    private static final Logger LOGGER = Logger.getLogger(BookingWebSocketEndpoint.class.getName());
    private static final Gson gson = new Gson();
    
    // Store all connected sessions
    private static final Set<Session> sessions = Collections.newSetFromMap(new ConcurrentHashMap<>());
    
    // Store user information for each session
    private static final Map<Session, UserInfo> sessionUsers = new ConcurrentHashMap<>();
    
    // Store slot reservations (slotId -> UserInfo)
    private static final Map<String, UserInfo> slotReservations = new ConcurrentHashMap<>();
    
    // Store temporary slot selections (slotId -> UserInfo) - for 30 second holds
    private static final Map<String, UserInfo> slotSelections = new ConcurrentHashMap<>();
    
    @OnOpen
    public void onOpen(Session session) {
        sessions.add(session);
        LOGGER.log(Level.INFO, "WebSocket connection opened: {0}", session.getId());
        
        // Send welcome message
        sendToSession(session, createMessage("system", "connected", 
            "Kết nối WebSocket thành công", null));
    }
    
    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject jsonMessage = JsonParser.parseString(message).getAsJsonObject();
            String action = jsonMessage.get("action").getAsString();
            
            LOGGER.log(Level.INFO, "Received message: {0} from session: {1}", 
                      new Object[]{action, session.getId()});
            
            switch (action) {
                case "connect":
                    handleConnect(jsonMessage, session);
                    break;
                case "select_slot":
                    handleSelectSlot(jsonMessage, session);
                    break;
                case "book_slot":
                    handleBookSlot(jsonMessage, session);
                    break;
                case "release_slot":
                    handleReleaseSlot(jsonMessage, session);
                    break;
                case "reset_test":
                    handleResetTest(jsonMessage, session);
                    break;
                default:
                    LOGGER.log(Level.WARNING, "Unknown action: {0}", action);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing message", e);
            sendToSession(session, createMessage("error", "message_error", 
                "Lỗi xử lý tin nhắn: " + e.getMessage(), null));
        }
    }
    
    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
        
        // Get user info before removing
        UserInfo userInfo = sessionUsers.remove(session);
        
        if (userInfo != null) {
            // Release any slots held by this user
            releaseUserSlots(userInfo.userId);
            
            // Notify other users about disconnection
            broadcastToOthers(session, createMessage("user_disconnected", "disconnect", 
                userInfo.userName + " đã ngắt kết nối", userInfo));
        }
        
        LOGGER.log(Level.INFO, "WebSocket connection closed: {0}", session.getId());
    }
    
    @OnError
    public void onError(Session session, Throwable throwable) {
        LOGGER.log(Level.SEVERE, "WebSocket error for session: " + session.getId(), throwable);
        
        try {
            sendToSession(session, createMessage("error", "connection_error", 
                "Lỗi kết nối WebSocket", null));
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending error message", e);
        }
    }
    
    private void handleConnect(JsonObject message, Session session) {
        String userId = message.get("userId").getAsString();
        String userName = message.get("userName").getAsString();
        
        UserInfo userInfo = new UserInfo(userId, userName);
        sessionUsers.put(session, userInfo);
        
        // Send current slot status to new user
        sendSlotStatus(session);
        
        // Notify other users about new connection
        broadcastToOthers(session, createMessage("user_connected", "connect", 
            userName + " đã kết nối", userInfo));
        
        LOGGER.log(Level.INFO, "User connected: {0} ({1})", new Object[]{userName, userId});
    }
    
    private void handleSelectSlot(JsonObject message, Session session) {
        String slotId = message.get("slotId").getAsString();
        String timeSlot = message.get("timeSlot").getAsString();
        UserInfo userInfo = sessionUsers.get(session);
        
        if (userInfo == null) {
            sendToSession(session, createMessage("error", "auth_error", 
                "Người dùng chưa xác thực", null));
            return;
        }
        
        // Check if slot is already booked or selected by another user
        if (slotReservations.containsKey(slotId)) {
            sendToSession(session, createMessage("error", "slot_unavailable", 
                "Slot đã được đặt bởi người khác", null));
            return;
        }
        
        if (slotSelections.containsKey(slotId)) {
            UserInfo currentSelector = slotSelections.get(slotId);
            if (!currentSelector.userId.equals(userInfo.userId)) {
                sendToSession(session, createMessage("error", "slot_selecting", 
                    "Slot đang được chọn bởi " + currentSelector.userName, null));
                return;
            }
        }
        
        // Mark slot as selected by this user
        slotSelections.put(slotId, userInfo);
        
        // Broadcast slot selection to all users
        Map<String, Object> data = new HashMap<>();
        data.put("slotId", slotId);
        data.put("timeSlot", timeSlot);
        data.put("userId", userInfo.userId);
        data.put("userName", userInfo.userName);
        
        broadcastToAll(createMessage("slot_selected", "select", 
            userInfo.userName + " đang chọn slot " + timeSlot, data));
        
        // Auto-release selection after 30 seconds if not confirmed
        scheduleSlotRelease(slotId, userInfo, 30000);
        
        LOGGER.log(Level.INFO, "Slot selected: {0} by {1}", new Object[]{slotId, userInfo.userName});
    }
    
    private void handleBookSlot(JsonObject message, Session session) {
        String slotId = message.get("slotId").getAsString();
        String timeSlot = message.get("timeSlot").getAsString();
        UserInfo userInfo = sessionUsers.get(session);
        
        if (userInfo == null) {
            sendToSession(session, createMessage("error", "auth_error", 
                "Người dùng chưa xác thực", null));
            return;
        }
        
        // Check if user has selected this slot
        UserInfo selector = slotSelections.get(slotId);
        if (selector == null || !selector.userId.equals(userInfo.userId)) {
            sendToSession(session, createMessage("error", "slot_not_selected", 
                "Bạn chưa chọn slot này", null));
            return;
        }
        
        // Check if slot is already booked (double-check)
        if (slotReservations.containsKey(slotId)) {
            sendToSession(session, createMessage("error", "slot_already_booked", 
                "Slot đã được đặt bởi người khác", null));
            return;
        }
        
        // Book the slot
        slotReservations.put(slotId, userInfo);
        slotSelections.remove(slotId);
        
        // Broadcast booking confirmation to all users
        Map<String, Object> data = new HashMap<>();
        data.put("slotId", slotId);
        data.put("timeSlot", timeSlot);
        data.put("userId", userInfo.userId);
        data.put("userName", userInfo.userName);
        
        broadcastToAll(createMessage("slot_booked", "book", 
            userInfo.userName + " đã đặt slot " + timeSlot, data));
        
        LOGGER.log(Level.INFO, "Slot booked: {0} by {1}", new Object[]{slotId, userInfo.userName});
    }
    
    private void handleReleaseSlot(JsonObject message, Session session) {
        String slotId = message.get("slotId").getAsString();
        String timeSlot = message.get("timeSlot").getAsString();
        UserInfo userInfo = sessionUsers.get(session);
        
        if (userInfo == null) return;
        
        // Remove from both selections and reservations
        slotSelections.remove(slotId);
        slotReservations.remove(slotId);
        
        // Broadcast slot release to all users
        Map<String, Object> data = new HashMap<>();
        data.put("slotId", slotId);
        data.put("timeSlot", timeSlot);
        
        broadcastToAll(createMessage("slot_released", "release", 
            "Slot " + timeSlot + " đã được giải phóng", data));
        
        LOGGER.log(Level.INFO, "Slot released: {0}", slotId);
    }
    
    private void handleResetTest(JsonObject message, Session session) {
        UserInfo userInfo = sessionUsers.get(session);
        
        if (userInfo == null) return;
        
        // Clear all reservations and selections
        slotReservations.clear();
        slotSelections.clear();
        
        // Broadcast reset to all users
        broadcastToAll(createMessage("test_reset", "reset", 
            "Test đã được reset bởi " + userInfo.userName, null));
        
        LOGGER.log(Level.INFO, "Test reset by: {0}", userInfo.userName);
    }
    
    private void sendSlotStatus(Session session) {
        Map<String, Object> statusData = new HashMap<>();
        statusData.put("reservations", slotReservations);
        statusData.put("selections", slotSelections);
        
        sendToSession(session, createMessage("slot_status", "status", 
            "Trạng thái slot hiện tại", statusData));
    }
    
    private void releaseUserSlots(String userId) {
        // Release all slots held by this user
        slotReservations.entrySet().removeIf(entry -> entry.getValue().userId.equals(userId));
        slotSelections.entrySet().removeIf(entry -> entry.getValue().userId.equals(userId));
    }
    
    private void scheduleSlotRelease(String slotId, UserInfo userInfo, long delayMs) {
        // In a real application, you would use a proper scheduler
        // For testing purposes, we'll use a simple thread
        new Thread(() -> {
            try {
                Thread.sleep(delayMs);
                
                // Check if slot is still selected by the same user
                UserInfo currentSelector = slotSelections.get(slotId);
                if (currentSelector != null && currentSelector.userId.equals(userInfo.userId)) {
                    slotSelections.remove(slotId);
                    
                    Map<String, Object> data = new HashMap<>();
                    data.put("slotId", slotId);
                    data.put("reason", "timeout");
                    
                    broadcastToAll(createMessage("slot_released", "timeout", 
                        "Slot " + slotId + " đã hết thời gian chọn", data));
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();
    }
    
    private Map<String, Object> createMessage(String action, String type, String message, Object data) {
        Map<String, Object> msg = new HashMap<>();
        msg.put("action", action);
        msg.put("type", type);
        msg.put("message", message);
        msg.put("timestamp", System.currentTimeMillis());
        if (data != null) {
            msg.put("data", data);
        }
        return msg;
    }
    
    private void sendToSession(Session session, Map<String, Object> message) {
        try {
            if (session.isOpen()) {
                session.getBasicRemote().sendText(gson.toJson(message));
            }
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error sending message to session: " + session.getId(), e);
        }
    }
    
    private void broadcastToAll(Map<String, Object> message) {
        String jsonMessage = gson.toJson(message);
        sessions.forEach(session -> {
            try {
                if (session.isOpen()) {
                    session.getBasicRemote().sendText(jsonMessage);
                }
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Error broadcasting message", e);
            }
        });
    }
    
    private void broadcastToOthers(Session excludeSession, Map<String, Object> message) {
        String jsonMessage = gson.toJson(message);
        sessions.stream()
                .filter(session -> !session.equals(excludeSession))
                .forEach(session -> {
                    try {
                        if (session.isOpen()) {
                            session.getBasicRemote().sendText(jsonMessage);
                        }
                    } catch (IOException e) {
                        LOGGER.log(Level.SEVERE, "Error broadcasting message", e);
                    }
                });
    }
    
    /**
     * User information class
     */
    private static class UserInfo {
        public final String userId;
        public final String userName;
        
        public UserInfo(String userId, String userName) {
            this.userId = userId;
            this.userName = userName;
        }
    }
}
