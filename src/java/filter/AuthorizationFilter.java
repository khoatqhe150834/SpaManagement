package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.RoleConstants;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/admin/*", "/manager/*", "/therapist/*", "/receptionist/*"})
public class AuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Get the requested URL path
        String requestPath = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Check if user is authenticated
        boolean isAuthenticated = (session != null && session.getAttribute("authenticated") != null 
                && (Boolean) session.getAttribute("authenticated"));
        
        if (!isAuthenticated) {
            // Redirect to login page if not authenticated
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Get user type from session
        String userType = (String) session.getAttribute("userType");
        if (userType == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Check authorization based on URL path and user type
        if (!isAuthorized(requestPath, userType)) {
            // Redirect to unauthorized page or show error
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        // Continue with the request if authorized
        chain.doFilter(request, response);
    }

    private boolean isAuthorized(String requestPath, String userType) {
        // Admin has access to everything
        if ("admin".equals(userType)) {
            return true;
        }

        // Check access based on URL path and user type
        if (requestPath.startsWith("/admin")) {
            return "admin".equals(userType);
        } else if (requestPath.startsWith("/manager")) {
            return "manager".equals(userType) || "admin".equals(userType);
        } else if (requestPath.startsWith("/therapist")) {
            return "therapist".equals(userType) || "admin".equals(userType) || "manager".equals(userType);
        } else if (requestPath.startsWith("/receptionist")) {
            return "receptionist".equals(userType) || "admin".equals(userType) || "manager".equals(userType);
        }

        // Default to denying access
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
} 