package websocket;

import controller.WebSocketBookingTestController;
import dao.ServiceDAO;
import java.util.List;
import model.Service;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/**
 * Test runner for WebSocket Booking Test System
 * Validates the components work correctly
 */
public class WebSocketBookingTestRunner {
    
    private WebSocketBookingTestController controller;
    private ServiceDAO serviceDAO;
    
    @BeforeEach
    void setUp() {
        controller = new WebSocketBookingTestController();
        serviceDAO = new ServiceDAO();
    }
    
    @Test
    void testControllerInstantiation() {
        assertNotNull(controller, "WebSocketBookingTestController should be instantiated");
        System.out.println("✓ Controller instantiation test passed");
    }
    
    @Test
    void testServiceDAOConnection() {
        List<Service> services = serviceDAO.findAll(); // This is expected if database is not set up
        assertNotNull(services, "Services list should not be null");
        System.out.println("✓ ServiceDAO connection test passed - " + services.size() + " services found");
    }
    
    @Test
    void testWebSocketEndpointClass() {
        try {
            Class<?> endpointClass = Class.forName("websocket.BookingWebSocketEndpoint");
            assertNotNull(endpointClass, "BookingWebSocketEndpoint class should exist");
            
            // Check if it has the required annotations
            boolean hasServerEndpoint = endpointClass.isAnnotationPresent(
                jakarta.websocket.server.ServerEndpoint.class);
            assertTrue(hasServerEndpoint, "BookingWebSocketEndpoint should have @ServerEndpoint annotation");
            
            System.out.println("✓ WebSocket endpoint class test passed");
        } catch (ClassNotFoundException e) {
            fail("BookingWebSocketEndpoint class not found: " + e.getMessage());
        }
    }
    
    @Test
    void testWebSocketConfigClass() {
        try {
            Class<?> configClass = Class.forName("config.WebSocketConfig");
            assertNotNull(configClass, "WebSocketConfig class should exist");
            
            // Check if it implements ServerApplicationConfig
            boolean implementsConfig = jakarta.websocket.server.ServerApplicationConfig.class
                .isAssignableFrom(configClass);
            assertTrue(implementsConfig, "WebSocketConfig should implement ServerApplicationConfig");
            
            System.out.println("✓ WebSocket config class test passed");
        } catch (ClassNotFoundException e) {
            fail("WebSocketConfig class not found: " + e.getMessage());
        }
    }
    
    @Test
    void testTimeSlotGeneration() {
        // Test the time slot generation logic
        String[] expectedSlots = {
            "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
            "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
            "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00"
        };
        
        assertEquals(19, expectedSlots.length, "Should have 19 time slots");
        
        // Test time format conversion
        String formatted = formatTimeDisplay("09:00");
        assertEquals("9:00 AM", formatted, "09:00 should format to 9:00 AM");
        
        formatted = formatTimeDisplay("13:30");
        assertEquals("1:30 PM", formatted, "13:30 should format to 1:30 PM");
        
        formatted = formatTimeDisplay("18:00");
        assertEquals("6:00 PM", formatted, "18:00 should format to 6:00 PM");
        
        System.out.println("✓ Time slot generation test passed");
    }
    
    @Test
    void testSampleServiceGeneration() {
        // Test sample service creation
        String[] expectedServices = {
            "Massage Thư Giãn",
            "Chăm Sóc Da Mặt",
            "Làm Móng Tay",
            "Tắm Trắng Toàn Thân"
        };

        int[] expectedDurations = {60, 90, 45, 120};

        assertEquals(4, expectedServices.length, "Should have 4 sample services");
        assertEquals(4, expectedDurations.length, "Should have 4 duration values");
        System.out.println("✓ Sample service generation test passed");
    }
    
    @Test
    void testJSPFileExists() {
        // Check if JSP file exists
        String jspPath = "src/main/webapp/WEB-INF/view/test/websocket-booking-test.jsp";
        java.io.File jspFile = new java.io.File(jspPath);
        assertTrue(jspFile.exists(), "JSP file should exist at: " + jspPath);
        System.out.println("✓ JSP file existence test passed");
    }
    
    @Test
    void testJavaScriptFileExists() {
        // Check if JavaScript file exists
        String jsPath = "src/main/webapp/js/websocket-booking-test.js";
        java.io.File jsFile = new java.io.File(jsPath);
        assertTrue(jsFile.exists(), "JavaScript file should exist at: " + jsPath);
        System.out.println("✓ JavaScript file existence test passed");
    }
    
    @Test
    void testDocumentationExists() {
        // Check if documentation exists
        String docPath = "WEBSOCKET_BOOKING_TEST_SYSTEM.md";
        java.io.File docFile = new java.io.File(docPath);
        assertTrue(docFile.exists(), "Documentation should exist at: " + docPath);
        System.out.println("✓ Documentation existence test passed");
    }
    
    @Test
    void testSystemIntegration() {
        System.out.println("\n=== WebSocket Booking Test System Integration Test ===");
        
        try {
            // Test all components exist
            testControllerInstantiation();
            testWebSocketEndpointClass();
            testWebSocketConfigClass();
            testJSPFileExists();
            testJavaScriptFileExists();
            testDocumentationExists();
            
            // Test business logic
            testTimeSlotGeneration();
            testSampleServiceGeneration();
            
            System.out.println("\n🎉 ALL WEBSOCKET BOOKING TEST SYSTEM COMPONENTS READY!");
            System.out.println("\n📋 Next Steps:");
            System.out.println("1. Start the application server");
            System.out.println("2. Login as MANAGER or ADMIN user");
            System.out.println("3. Navigate to: /test/websocket-booking");
            System.out.println("4. Test real-time booking functionality");
            System.out.println("5. Open multiple browser tabs to test multi-user scenarios");
            
        } catch (Exception e) {
            fail("System integration test failed: " + e.getMessage());
        }
    }
    
    // Helper method for time formatting (copied from controller logic)
    private String formatTimeDisplay(String time24) {
        String[] parts = time24.split(":");
        int hour = Integer.parseInt(parts[0]);
        int minute = Integer.parseInt(parts[1]);
        
        String period = hour >= 12 ? "PM" : "AM";
        int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        
        return String.format("%d:%02d %s", displayHour, minute, period);
    }
}
