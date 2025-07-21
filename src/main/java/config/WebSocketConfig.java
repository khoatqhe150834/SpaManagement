package config;

import java.util.Set;
import jakarta.websocket.Endpoint;
import jakarta.websocket.server.ServerApplicationConfig;
import jakarta.websocket.server.ServerEndpointConfig;

/**
 * WebSocket Configuration for the Spa Management System
 * Enables WebSocket support for real-time booking functionality
 * 
 * @author SpaManagement
 */
public class WebSocketConfig implements ServerApplicationConfig {
    
    @Override
    public Set<ServerEndpointConfig> getEndpointConfigs(Set<Class<? extends Endpoint>> endpointClasses) {
        // Return empty set as we're using annotation-based endpoints
        return Set.of();
    }
    
    @Override
    public Set<Class<?>> getAnnotatedEndpointClasses(Set<Class<?>> scanned) {
        // Return all scanned WebSocket endpoint classes
        return scanned;
    }
}
