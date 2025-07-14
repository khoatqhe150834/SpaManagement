package listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.CloudinaryConfig;

/**
 * Servlet context listener to initialize Cloudinary configuration on application startup
 */
@WebListener
public class CloudinaryInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        
        // Initialize Cloudinary with parameters from web.xml
        CloudinaryConfig.init(context);
        
        context.log("Cloudinary initialized successfully");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to clean up
    }
}
