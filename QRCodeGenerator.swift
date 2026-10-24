import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator {
    private static let context = CIContext()
    private static let filter = CIFilter.qrCodeGenerator()

    static func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Scale up the CIImage to sharp 512x512 pixels
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)

            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
