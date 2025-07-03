package service.email;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class EmailTemplateUtil {

  private static final Logger LOGGER = Logger.getLogger(EmailTemplateUtil.class.getName());
  private static final String TEMPLATE_PATH_PREFIX = "/email-templates/";

  public static String loadAndPopulateTemplate(String templateName, Map<String, String> placeholders) {
    String template = loadTemplate(templateName);
    if (template == null) {
      return null;
    }

    for (Map.Entry<String, String> entry : placeholders.entrySet()) {
      template = template.replace("{{" + entry.getKey() + "}}", entry.getValue());
    }

    return template;
  }

  private static String loadTemplate(String templateName) {
    String resourcePath = TEMPLATE_PATH_PREFIX + templateName;
    try (InputStream is = EmailTemplateUtil.class.getResourceAsStream(resourcePath)) {
      if (is == null) {
        LOGGER.log(Level.SEVERE, "Cannot find email template: {0}", resourcePath);
        return null;
      }

      try (InputStreamReader isr = new InputStreamReader(is, StandardCharsets.UTF_8);
          BufferedReader reader = new BufferedReader(isr)) {
        return reader.lines().collect(Collectors.joining(System.lineSeparator()));
      }

    } catch (IOException e) {
      LOGGER.log(Level.SEVERE, "Failed to load email template: " + resourcePath, e);
      return null;
    }
  }
}