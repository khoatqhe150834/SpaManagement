# Google reCAPTCHA Implementation Guide for SPA Management Login System

## Overview

This guide provides step-by-step instructions to integrate Google reCAPTCHA v2 into your Jakarta EE spa management application's login system to prevent automated attacks and spam login attempts.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Register with Google reCAPTCHA](#register-with-google-recaptcha)
3. [Backend Implementation](#backend-implementation)
4. [Frontend Integration](#frontend-integration)
5. [Configuration](#configuration)
6. [Testing](#testing)
7. [Security Considerations](#security-considerations)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

- Jakarta EE servlet application (your current spa management system)
- Java 8 or higher
- Maven dependency management
- Internet access for Google reCAPTCHA service
- Valid domain name (localhost works for testing)

## 1. Register with Google reCAPTCHA

### Step 1.1: Create reCAPTCHA Account

1. Visit [Google reCAPTCHA Admin Console](https://www.google.com/recaptcha/admin)
2. Sign in with your Google account
3. Click "+" to create a new site

### Step 1.2: Configure Site Settings

- **Label**: Enter a descriptive name (e.g., "SPA Management System")
- **reCAPTCHA type**: Select "reCAPTCHA v2" → "I'm not a robot" Checkbox
- **Domains**: Add your domains:
  - `localhost` (for development)
  - Your production domain
- **Accept reCAPTCHA Terms of Service**
- Click "Submit"

### Step 1.3: Save Keys

After registration, you'll receive:

- **Site Key** (public): Used in frontend HTML
- **Secret Key** (private): Used in backend verification

**Example Keys (for reference only):**

```
Site Key: 6LdMAgMTAAAAAGYY5PEQeW7b3L3tqACmUcU6alQf
Secret Key: 6LdMAgMTAAAAAJOAqKgjWe9DUujd2iyTmzjXilM7
```

## 2. Backend Implementation

### Step 2.1: Add Maven Dependencies

Add JSON processing dependency to your `pom.xml`:

```xml
<!-- JSON Processing for reCAPTCHA response -->
<dependency>
    <groupId>org.glassfish</groupId>
    <artifactId>javax.json</artifactId>
    <version>1.0.4</version>
</dependency>
```

### Step 2.2: Create Configuration Class

Create `src/main/java/config/RecaptchaConfig.java`:

```java
package config;

public class RecaptchaConfig {
    // Replace with your actual keys
    public static final String SITE_KEY = "YOUR_SITE_KEY_HERE";
    public static final String SECRET_KEY = "YOUR_SECRET_KEY_HERE";
    public static final String VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";
}
```

### Step 2.3: Create Verification Utility

Create `src/main/java/util/RecaptchaVerifier.java`:

```java
package util;

import java.io.*;
import java.net.URL;
import java.net.URLEncoder;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.net.ssl.HttpsURLConnection;
import config.RecaptchaConfig;

public class RecaptchaVerifier {
    private static final String USER_AGENT = "Mozilla/5.0";

    public static boolean verify(String gRecaptchaResponse, String clientIP) {
        if (gRecaptchaResponse == null || gRecaptchaResponse.trim().isEmpty()) {
            return false;
        }

        try {
            URL url = new URL(RecaptchaConfig.VERIFY_URL);
            HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();

            // Configure connection
            connection.setRequestMethod("POST");
            connection.setRequestProperty("User-Agent", USER_AGENT);
            connection.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
            connection.setDoOutput(true);

            // Prepare POST parameters
            String postParams = "secret=" + URLEncoder.encode(RecaptchaConfig.SECRET_KEY, "UTF-8") +
                              "&response=" + URLEncoder.encode(gRecaptchaResponse, "UTF-8") +
                              "&remoteip=" + URLEncoder.encode(clientIP, "UTF-8");

            // Send POST request
            try (DataOutputStream wr = new DataOutputStream(connection.getOutputStream())) {
                wr.writeBytes(postParams);
                wr.flush();
            }

            // Get response
            int responseCode = connection.getResponseCode();
            System.out.println("reCAPTCHA verification response code: " + responseCode);

            // Read response
            StringBuilder response = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(connection.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
            }

            // Parse JSON response
            try (JsonReader jsonReader = Json.createReader(new StringReader(response.toString()))) {
                JsonObject jsonObject = jsonReader.readObject();
                boolean success = jsonObject.getBoolean("success", false);

                System.out.println("reCAPTCHA verification result: " + success);
                if (!success && jsonObject.containsKey("error-codes")) {
                    System.out.println("reCAPTCHA errors: " + jsonObject.getJsonArray("error-codes"));
                }

                return success;
            }

        } catch (Exception e) {
            System.err.println("Error verifying reCAPTCHA: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
```

### Step 2.4: Update LoginController

Modify your existing `LoginController.java` to include reCAPTCHA verification:

```java
// Add to imports
import util.RecaptchaVerifier;

// In your doPost method, add reCAPTCHA verification before login validation:
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String rememberMe = request.getParameter("rememberMe");

    // Get reCAPTCHA response
    String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
    String clientIP = request.getRemoteAddr();

    // Verify reCAPTCHA first
    boolean captchaValid = RecaptchaVerifier.verify(gRecaptchaResponse, clientIP);

    if (!captchaValid) {
        request.setAttribute("error", "Vui lòng xác thực reCAPTCHA để tiếp tục.");
        request.setAttribute("attemptedEmail", email);
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
        return;
    }

    // Continue with existing login validation logic...
    // Your existing authentication code here
}
```

## 3. Frontend Integration

### Step 3.1: Update login.jsp

Add reCAPTCHA to your existing `login.jsp` file:

```jsp
<!-- Add reCAPTCHA script to head section -->
<head>
    <!-- Existing head content -->

    <!-- Google reCAPTCHA v2 -->
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>

<!-- In your form, add reCAPTCHA widget before submit button -->
<form id="loginForm" method="post" action="login">
    <!-- Existing form fields -->

    <div class="form-group">
        <label class="font-weight-700">E-MAIL *</label>
        <input name="email" id="emailInput" required="true" class="form-control"
               placeholder="example@gmail.com" type="email"
               value="${attemptedEmail != null ? attemptedEmail : (prefillEmail != null ? prefillEmail : (rememberedEmail != null ? rememberedEmail : ''))}" />
        <div id="emailError" class="field-error-message" style="display: none;"></div>
    </div>

    <div class="form-group">
        <label class="font-weight-700">MẬT KHẨU *</label>
        <input name="password" id="passwordInput" required="true" class="form-control"
               placeholder="******" type="password"
               value="${attemptedPassword != null ? attemptedPassword : (prefillPassword != null ? prefillPassword : (rememberedPassword != null ? rememberedPassword : ''))}" />
        <div id="passwordError" class="field-error-message" style="display: none;"></div>
    </div>

    <!-- Remember Me checkbox -->
    <div class="form-group">
        <div class="form-check">
            <input type="checkbox" name="rememberMe" id="rememberMe" class="form-check-input"
                   style="margin-right: 8px;" value="true" ${rememberMeChecked ? 'checked="checked"' : ''} />
            <label for="rememberMe" class="form-check-label font-weight-600">Ghi nhớ tôi</label>
        </div>
    </div>

    <!-- reCAPTCHA Widget -->
    <div class="form-group">
        <div class="g-recaptcha" data-sitekey="YOUR_SITE_KEY_HERE"
             data-theme="light" data-size="normal"></div>
        <div id="recaptchaError" class="field-error-message" style="display: none;"></div>
    </div>

    <div class="text-left">
        <button type="submit" class="site-button m-r5 button-lg radius-no">ĐĂNG NHẬP</button>
        <a href="${pageContext.request.contextPath}/reset-password" class="m-l5">
            <i class="fa fa-unlock-alt"></i> Quên mật khẩu
        </a>
    </div>
</form>
```

### Step 3.2: Add Client-side Validation

Update the JavaScript validation in `login.jsp`:

```javascript
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Existing validation code...

    const loginForm = document.getElementById('loginForm');
    const recaptchaError = document.getElementById('recaptchaError');

    function showRecaptchaError(message) {
        recaptchaError.textContent = message;
        recaptchaError.style.display = 'block';
    }

    function hideRecaptchaError() {
        recaptchaError.style.display = 'none';
        recaptchaError.textContent = '';
    }

    // Form submission validation
    loginForm.addEventListener('submit', function(e) {
        // Get reCAPTCHA response
        const recaptchaResponse = grecaptcha.getResponse();

        // Validate reCAPTCHA
        if (!recaptchaResponse || recaptchaResponse.length === 0) {
            showRecaptchaError('Vui lòng xác thực reCAPTCHA trước khi đăng nhập.');
            e.preventDefault();
            return false;
        } else {
            hideRecaptchaError();
        }

        // Continue with existing email and password validation...
        const emailResult = emailValidator.validate();
        const passwordValidation = validatePassword(passwordInput.value);

        let hasErrors = false;

        if (!emailResult.isValid) {
            hasErrors = true;
        }

        if (passwordValidation) {
            showPasswordError(passwordValidation);
            hasErrors = true;
        } else {
            hidePasswordError();
        }

        if (hasErrors) {
            e.preventDefault();

            // Focus on first error field
            if (!emailResult.isValid) {
                emailValidator.focus();
            } else if (passwordValidation) {
                passwordInput.focus();
            }
        }
    });

    // Existing code...
});
</script>
```

## 4. Configuration

### Step 4.1: Environment-specific Configuration

Create different configuration files for different environments:

**For Development (`src/main/resources/recaptcha-dev.properties`):**

```properties
recaptcha.site.key=YOUR_DEV_SITE_KEY
recaptcha.secret.key=YOUR_DEV_SECRET_KEY
recaptcha.verify.url=https://www.google.com/recaptcha/api/siteverify
```

**For Production (`src/main/resources/recaptcha-prod.properties`):**

```properties
recaptcha.site.key=YOUR_PROD_SITE_KEY
recaptcha.secret.key=YOUR_PROD_SECRET_KEY
recaptcha.verify.url=https://www.google.com/recaptcha/api/siteverify
```

### Step 4.2: Update Configuration Class

Modify `RecaptchaConfig.java` to load from properties:

```java
package config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class RecaptchaConfig {
    private static Properties properties = new Properties();

    static {
        loadProperties();
    }

    private static void loadProperties() {
        String profile = System.getProperty("spring.profiles.active", "dev");
        String filename = "recaptcha-" + profile + ".properties";

        try (InputStream input = RecaptchaConfig.class.getClassLoader()
                .getResourceAsStream(filename)) {
            if (input != null) {
                properties.load(input);
            } else {
                System.err.println("Unable to find " + filename);
            }
        } catch (IOException e) {
            System.err.println("Error loading reCAPTCHA configuration: " + e.getMessage());
        }
    }

    public static String getSiteKey() {
        return properties.getProperty("recaptcha.site.key");
    }

    public static String getSecretKey() {
        return properties.getProperty("recaptcha.secret.key");
    }

    public static String getVerifyUrl() {
        return properties.getProperty("recaptcha.verify.url",
            "https://www.google.com/recaptcha/api/siteverify");
    }
}
```

### Step 4.3: Dynamic Site Key in JSP

Create a servlet or use application scope to make the site key available to JSP:

```java
// In a servlet or application listener
@Override
public void contextInitialized(ServletContextEvent sce) {
    ServletContext context = sce.getServletContext();
    context.setAttribute("recaptchaSiteKey", RecaptchaConfig.getSiteKey());
}
```

**Update login.jsp to use dynamic site key:**

```jsp
<div class="g-recaptcha" data-sitekey="${applicationScope.recaptchaSiteKey}"
     data-theme="light" data-size="normal"></div>
```

## 5. Testing

### Step 5.1: Test Scenarios

1. **Valid Login with reCAPTCHA**: Enter correct credentials and complete reCAPTCHA
2. **Valid Credentials without reCAPTCHA**: Should fail with error message
3. **Invalid Credentials with reCAPTCHA**: Should fail with authentication error
4. **Network Issues**: Test behavior when Google services are unreachable

### Step 5.2: Testing URLs

- Development: `http://localhost:8080/your-app/login`
- Production: `https://yourdomain.com/your-app/login`

### Step 5.3: Debugging

Enable debug logging by adding to your verification utility:

```java
public static boolean verify(String gRecaptchaResponse, String clientIP) {
    System.out.println("DEBUG: Verifying reCAPTCHA");
    System.out.println("DEBUG: Response token length: " +
        (gRecaptchaResponse != null ? gRecaptchaResponse.length() : "null"));
    System.out.println("DEBUG: Client IP: " + clientIP);

    // ... rest of verification code
}
```

## 6. Security Considerations

### Step 6.1: Key Management

- **Never expose secret keys in client-side code**
- Store secret keys in environment variables or secure configuration
- Use different keys for development and production
- Rotate keys periodically

### Step 6.2: Rate Limiting

Implement additional rate limiting for login attempts:

```java
// Add to LoginController
private static final Map<String, Integer> attemptCounts = new ConcurrentHashMap<>();
private static final Map<String, Long> lastAttemptTime = new ConcurrentHashMap<>();
private static final int MAX_ATTEMPTS = 5;
private static final long LOCKOUT_TIME = 15 * 60 * 1000; // 15 minutes

private boolean isRateLimited(String clientIP) {
    long currentTime = System.currentTimeMillis();
    Integer attempts = attemptCounts.get(clientIP);
    Long lastAttempt = lastAttemptTime.get(clientIP);

    if (attempts != null && attempts >= MAX_ATTEMPTS) {
        if (lastAttempt != null && (currentTime - lastAttempt) < LOCKOUT_TIME) {
            return true;
        } else {
            // Reset counter after lockout period
            attemptCounts.remove(clientIP);
            lastAttemptTime.remove(clientIP);
        }
    }

    return false;
}

private void recordFailedAttempt(String clientIP) {
    attemptCounts.merge(clientIP, 1, Integer::sum);
    lastAttemptTime.put(clientIP, System.currentTimeMillis());
}
```

### Step 6.3: HTTPS Requirement

Ensure reCAPTCHA is only used over HTTPS in production:

```java
// Add to your filter or servlet
if (request.isSecure() || "localhost".equals(request.getServerName())) {
    // Allow reCAPTCHA verification
} else {
    // Redirect to HTTPS or show error
    response.sendRedirect("https://" + request.getServerName() +
                         request.getRequestURI());
    return;
}
```

## 7. Troubleshooting

### Common Issues and Solutions

#### Issue 1: "ERROR for site owner: Invalid site key"

**Solution**: Verify site key matches the one from Google reCAPTCHA console

#### Issue 2: "ERROR for site owner: Invalid domain for site key"

**Solution**: Add your domain to the reCAPTCHA site configuration

#### Issue 3: reCAPTCHA not loading

**Solutions**:

- Check internet connectivity
- Verify script tag is correct
- Check browser console for JavaScript errors
- Ensure site is not blocked by firewall

#### Issue 4: Server-side verification fails

**Solutions**:

- Check secret key is correct
- Verify server can reach Google's servers
- Check for proxy/firewall restrictions
- Implement proper error handling

#### Issue 5: DNS Caching Issues (Java-specific)

**Solution**: Add JVM parameter to reduce DNS cache time:

```bash
-Dsun.net.inetaddr.ttl=30
```

### Debug Checklist

- [ ] Site key is correctly configured in frontend
- [ ] Secret key is correctly configured in backend
- [ ] Domain is registered in reCAPTCHA console
- [ ] HTTPS is used in production
- [ ] Server can reach Google reCAPTCHA services
- [ ] No JavaScript errors in browser console
- [ ] Form properly submits reCAPTCHA response parameter

## 8. Advanced Configuration

### Step 8.1: Customize reCAPTCHA Appearance

```jsp
<!-- Light theme, normal size -->
<div class="g-recaptcha"
     data-sitekey="${applicationScope.recaptchaSiteKey}"
     data-theme="light"
     data-size="normal"
     data-tabindex="0"></div>

<!-- Dark theme, compact size -->
<div class="g-recaptcha"
     data-sitekey="${applicationScope.recaptchaSiteKey}"
     data-theme="dark"
     data-size="compact"></div>
```

### Step 8.2: Programmatic reCAPTCHA

For dynamic forms or SPA applications:

```javascript
// Render reCAPTCHA programmatically
var recaptchaWidget = grecaptcha.render("recaptcha-container", {
  sitekey: "YOUR_SITE_KEY",
  theme: "light",
  size: "normal",
  callback: function (response) {
    // Handle successful verification
    console.log("reCAPTCHA verified");
  },
  "expired-callback": function () {
    // Handle expiration
    console.log("reCAPTCHA expired");
  },
});
```

### Step 8.3: Multiple reCAPTCHAs per Page

If you need multiple reCAPTCHAs on the same page:

```javascript
// Get response for specific widget
var response = grecaptcha.getResponse(recaptchaWidget);
```

## Conclusion

This implementation provides robust protection against automated login attempts while maintaining a good user experience. The reCAPTCHA v2 checkbox is user-friendly and provides strong protection against bots.

**Key Benefits:**

- Prevents automated login attacks
- Minimal impact on user experience
- Industry-standard security solution
- Free to use with reasonable limits

**Next Steps:**

1. Implement the solution step by step
2. Test thoroughly in development environment
3. Monitor reCAPTCHA analytics in Google console
4. Consider upgrading to reCAPTCHA v3 for invisible protection

For production deployment, ensure you:

- Use environment-specific configuration
- Monitor error rates and success metrics
- Have fallback mechanisms for service outages
- Keep your dependencies updated
