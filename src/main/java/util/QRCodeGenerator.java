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
    
    
    private static final String BASE_URL = "http://localhost:8080/";
    private static int QR_WIDTH = 300;
    private static int QR_HEIGHT = 300;

    /**
     * Generates a QR code image from the provided text and saves it to the specified file path.
     *
     * @param text     The text to encode in the QR code (e.g., URL, message).
     * @param width    The width of the QR code image in pixels.
     * @param height   The height of the QR code image in pixels.
     * @param filePath The file path where the QR code image will be saved (e.g., "qrcode.png").
     * @throws WriterException If there's an error encoding the QR code.
     * @throws IOException    If there's an error writing the image to the file.
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
     * Generates a QR code for a specific booking and saves it to a file.
     *
     * @param bookingId The unique booking ID.
     * @param baseUrl   The base URL for the check-in servlet (e.g., "http://your-spa.com/autocheckin").
     * @param filePath  The file path to save the QR code image.
     * @throws WriterException If there's an error encoding the QR code.
     * @throws IOException    If there's an error writing the image.
     */
    public static void generateBookingQRCode(String appointmentId, String baseUrl, String filePath)
            throws WriterException, IOException {
        String qrUrl = baseUrl + "?appointmentId=" + appointmentId;
        generateQRCode(qrUrl, QR_WIDTH, QR_HEIGHT, filePath);
    }

    // Example usage
    public static void main(String[] args) {
        try {
            // Generate QR code for a sample booking
            generateBookingQRCode("SPA12345", QRCodeGenerator.BASE_URL, "qr_SPA12345.png");
            System.out.println("Booking QR code generated successfully!");
        } catch (WriterException | IOException e) {
            System.err.println("Error generating QR code: " + e.getMessage());
        }
    }
}