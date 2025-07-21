package util;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.PromotionDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Promotion Scheduler for automatic status updates
 * Runs every 5 minutes to check and update promotion status based on time
 */
@WebListener
public class PromotionScheduler implements ServletContextListener {
    
    private static final Logger logger = Logger.getLogger(PromotionScheduler.class.getName());
    private ScheduledExecutorService scheduler;
    private PromotionDAO promotionDAO;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Starting Promotion Scheduler...");
        
        promotionDAO = new PromotionDAO();
        scheduler = Executors.newScheduledThreadPool(1);
        
        // Schedule task to run every 5 minutes
        scheduler.scheduleAtFixedRate(
            this::updatePromotionStatus,
            0, // Initial delay: 0 minutes (start immediately)
            5, // Period: 5 minutes
            TimeUnit.MINUTES
        );
        
        logger.info("Promotion Scheduler started successfully. Running every 5 minutes.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Shutting down Promotion Scheduler...");
        
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                // Wait up to 30 seconds for termination
                if (!scheduler.awaitTermination(30, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
        
        logger.info("Promotion Scheduler shut down completed.");
    }

    /**
     * Update promotion status based on current time
     */
    private void updatePromotionStatus() {
        try {
            logger.info("Running promotion status update check...");
            
            // Get promotions that need status update
            var promotionsToUpdate = promotionDAO.getPromotionsNeedingStatusUpdate();
            
            if (!promotionsToUpdate.isEmpty()) {
                logger.info("Found " + promotionsToUpdate.size() + " promotions needing status update");
                
                // Perform the status update
                promotionDAO.updatePromotionStatusByTime();
                
                logger.info("Promotion status update completed successfully");
            } else {
                logger.info("No promotions need status update at this time");
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during promotion status update", e);
        }
    }

    /**
     * Manual trigger for promotion status update (for testing)
     */
    public static void triggerUpdate() {
        try {
            PromotionDAO dao = new PromotionDAO();
            dao.updatePromotionStatusByTime();
            logger.info("Manual promotion status update triggered");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during manual promotion status update", e);
        }
    }
} 
 
 