/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author quang
 */
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;

public class QRCodeGenerator {

    private static final String BASE_URL = "http://localhost:8080/spa/autocheckin";
    private static int QR_WIDTH = 300;
    private static int QR_HEIGHT = 300;

    /**
     * Generates a QR code image from the provided text and saves it to the
     * specified file path.
     *
     * @param text     The text to encode in the QR code (e.g., URL, message).
     * @param width    The width of the QR code image in pixels.
     * @param height   The height of the QR code image in pixels.
     * @param filePath The file path where the QR code image will be saved (e.g.,
     *                 "qrcode.png").
     * @throws WriterException If there's an error encoding the QR code.
     * @throws IOException     If there's an error writing the image to the file.
     */
    public static void generateQRCode(String text, int width, int height, String filePath)
            throws WriterException, IOException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);
        Path path = FileSystems.getDefault().getPath(filePath);

        // Create parent directories if they don't exist
        if (path.getParent() != null) {
            Files.createDirectories(path.getParent());
        }

        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);
    }

    /**
     * Generates a QR code for a specific appointment and saves it to a file.
     *
     * @param appointmentId The unique appointment ID.
     * @param baseUrl       The base URL for the check-in servlet (e.g.,
     *                      "http://your-spa.com/autocheckin").
     * @param filePath      The file path to save the QR code image.
     * @throws WriterException If there's an error encoding the QR code.
     * @throws IOException     If there's an error writing the image.
     */
    public static void generateAppointmentQRCode(String appointmentId, String baseUrl, String filePath)
            throws WriterException, IOException {
        String qrUrl = baseUrl + "?appointmentId=" + appointmentId;
        generateQRCode(qrUrl, QR_WIDTH, QR_HEIGHT, filePath);
    }

    /**
     * Generates a QR code for appointment check-in using the default base URL
     * 
     * @param appointmentId The appointment ID
     * @param filePath      Path to save the QR code image
     * @throws WriterException
     * @throws IOException
     */
    public static void generateAppointmentQRCode(Integer appointmentId, String filePath)
            throws WriterException, IOException {
        generateAppointmentQRCode(appointmentId.toString(), BASE_URL, filePath);
    }

    /**
     * Generates the check-in URL for an appointment
     * 
     * @param appointmentId The appointment ID
     * @return The full URL for check-in
     */
    public static String generateCheckInUrl(Integer appointmentId) {
        return BASE_URL + "?appointmentId=" + appointmentId;
    }

    /**
     * Generates the check-in URL with custom base URL
     * 
     * @param appointmentId The appointment ID
     * @param baseUrl       Custom base URL
     * @return The full URL for check-in
     */
    public static String generateCheckInUrl(Integer appointmentId, String baseUrl) {
        return baseUrl + "?appointmentId=" + appointmentId;
    }

    /**
     * Generates QR code and returns the file path where it's saved
     * Files are saved in webapp/assets/qr/ directory
     * 
     * @param appointmentId The appointment ID
     * @return The relative path to the QR code image
     * @throws WriterException
     * @throws IOException
     */
    public static String generateAndSaveAppointmentQR(Integer appointmentId)
            throws WriterException, IOException {
        String fileName = "appointment_" + appointmentId + "_qr.png";
        String relativePath = "assets/qr/" + fileName;
        String fullPath = "src/main/webapp/" + relativePath;

        generateAppointmentQRCode(appointmentId, fullPath);

        return relativePath;
    }

    /**
     * Get the default QR code dimensions
     * 
     * @return Array containing [width, height]
     */
    public static int[] getDefaultDimensions() {
        return new int[] { QR_WIDTH, QR_HEIGHT };
    }

    /**
     * Set custom QR code dimensions
     * 
     * @param width  QR code width
     * @param height QR code height
     */
    public static void setDimensions(int width, int height) {
        QR_WIDTH = width;
        QR_HEIGHT = height;
    }

    // Example usage
    public static void main(String[] args) {
        try {
            // Generate QR code for a sample appointment
            generateAppointmentQRCode("5", QRCodeGenerator.BASE_URL, "qr_appointment_5.png");
            System.out.println("Appointment QR code generated successfully!");

            // Generate using simplified method
            String qrPath = generateAndSaveAppointmentQR(5);
            System.out.println("QR code saved at: " + qrPath);

            // Get the check-in URL
            String checkInUrl = generateCheckInUrl(5);
            System.out.println("Check-in URL: " + checkInUrl);

        } catch (WriterException | IOException e) {
            System.err.println("Error generating QR code: " + e.getMessage());
        }
    }
}