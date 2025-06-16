package util;

import com.google.gson.Gson;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

/**
 * Utility class for Google reCAPTCHA verification
 */
public class RecaptchaVerifier {

  private static final String SECRET_KEY = "6LcD4GIrAAAAAIT7dN2AXmYUKUYXiXLgL_ONifEP";
  private static final String VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";

  /**
   * Verifies reCAPTCHA response with Google's verification API
   * 
   * @param gRecaptchaResponse The reCAPTCHA response token from the form
   * @return true if verification is successful, false otherwise
   */
  public static boolean verify(String gRecaptchaResponse) {
    if (gRecaptchaResponse == null || gRecaptchaResponse.isEmpty()) {
      return false;
    }

    try {
      // Prepare the HTTP post request to Google verification API
      HttpClient client = HttpClientBuilder.create().build();
      HttpPost post = new HttpPost(VERIFY_URL);

      List<NameValuePair> params = new ArrayList<>();
      params.add(new BasicNameValuePair("secret", SECRET_KEY));
      params.add(new BasicNameValuePair("response", gRecaptchaResponse));

      post.setEntity(new UrlEncodedFormEntity(params));

      // Execute the request and get the JSON response
      HttpResponse httpResponse = client.execute(post);
      HttpEntity entity = httpResponse.getEntity();
      String jsonResponse = EntityUtils.toString(entity);

      // Parse the JSON response
      Gson gson = new Gson();
      Map<String, Object> responseMap = gson.fromJson(jsonResponse, Map.class);

      // Check the "success" field in the response
      boolean success = (boolean) responseMap.get("success");

      if (!success) {
        // Log error codes for debugging
        List<String> errorCodes = (List<String>) responseMap.get("error-codes");
        System.err.println("reCAPTCHA verification failed. Error codes: " + errorCodes);
      }

      return success;

    } catch (IOException e) {
      System.err.println("Error verifying reCAPTCHA: " + e.getMessage());
      e.printStackTrace();
      return false;
    }
  }
}