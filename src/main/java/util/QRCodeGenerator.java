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
import java.nio.file.Path;

public class QRCodeGenerator {

    public static void generateQRCode(String text, int width, int height, String filePath) throws WriterException, IOException {
        QRCodeWriter qRCodeWriter = new QRCodeWriter();

        BitMatrix bitMatrix = qRCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);

//        Define path for output image 
        Path path = FileSystems.getDefault().getPath(filePath);

        // write qr code to file as png
        MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);

    }
    
    public static void main(String[] args) {
        try {
            generateQRCode("https://google.com", 300, 300, "qrcode.png");
            System.out.println("QR code generated succesfully");
        } catch (Exception e) {
            System.out.println("Error generating QR code" + e.getMessage());
            
        }
    }
}
