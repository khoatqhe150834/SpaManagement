<%@ page import="model.FlashMessage" %>
<%
    FlashMessage flashMessage = (FlashMessage) session.getAttribute("flash_notification");
    if (flashMessage != null) {
%>
    <script>
        // This script is rendered only when a flash message is present in the session.
        document.addEventListener('DOMContentLoaded', function() {
            // Function to show notification
            function displayFlashMessage(message, type) {
                // Try to use global showNotification if available
                if (typeof window.showNotification === 'function') {
                    window.showNotification(message, type);
                    return;
                }
                
                // Fallback: Create our own simple notification
                const toast = document.createElement('div');
                const borderColor = type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6';
                const iconColor = type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6';
                const icon = type === 'success' ? '✓' : type === 'error' ? '✕' : 'ℹ';
                
                toast.style.cssText = 'position: fixed; top: 20px; right: 20px; max-width: 400px; background: white; border: 1px solid #ddd; border-radius: 8px; padding: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 10000; font-family: system-ui, -apple-system, sans-serif; border-left: 4px solid ' + borderColor + ';';
                
                toast.innerHTML = '<div style="display: flex; align-items: flex-start; gap: 12px;">' +
                    '<div style="color: ' + iconColor + '; font-size: 20px;">' + icon + '</div>' +
                    '<div style="flex: 1;">' +
                        '<div style="font-weight: 600; color: #111; margin-bottom: 4px;">Thông báo</div>' +
                        '<div style="color: #666; font-size: 14px;">' + message + '</div>' +
                    '</div>' +
                    '<button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; color: #999; cursor: pointer; font-size: 18px; padding: 0; margin: 0;">×</button>' +
                '</div>';
                
                document.body.appendChild(toast);
                
                // Auto-remove after 5 seconds
                setTimeout(() => {
                    if (document.body.contains(toast)) {
                        toast.remove();
                    }
                }, 5000);
            }
            
            // Wait for the global notifier to be ready, with fallback
            let attempts = 0;
            const maxAttempts = 30; // 3 seconds max wait
            
            const waitForNotifier = setInterval(() => {
                attempts++;
                
                if (typeof window.showNotification === 'function') {
                    clearInterval(waitForNotifier);
                    displayFlashMessage("<%= flashMessage.getMessage().replace("\"", "\\\"") %>", "<%= flashMessage.getType() %>");
                } else if (attempts >= maxAttempts) {
                    // Use fallback after 3 seconds
                    clearInterval(waitForNotifier);
                    displayFlashMessage("<%= flashMessage.getMessage().replace("\"", "\\\"") %>", "<%= flashMessage.getType() %>");
                }
            }, 100);
        });
    </script>
<%
        // IMPORTANT: Remove the attribute after displaying it so it doesn't show again.
        session.removeAttribute("flash_notification");
    }
%> 