import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
class DetourageViewModel: ObservableObject {
    
    // L’image brute fournie par l’utilisateur
    @Published var image: UIImage?
    
    // L’image traitée avec fond supprimé
    @Published var imageDetouree: UIImage?
    
    // Point d'entrée : lance la suppression du fond à partir d’une UIImage
    func removeBackground(from uiImage: UIImage) {
        // Corrige l’orientation de l’image (problème fréquent avec la caméra)
        let correctedImage = uiImage.fixedOrientation()

        // Conversion en CIImage (format utilisé par CoreImage et Vision)
        guard let ciImage = CIImage(image: correctedImage) else {
            print("Impossible de convertir UIImage en CIImage")
            return
        }

        // Traitement asynchrone
        Task {
            // Création du masque de détourage
            guard let maskImage = await createMask(from: ciImage) else {
                print("Échec de création du masque")
                return
            }

            // Application du masque pour obtenir le résultat final
            let outputImage = applyMask(mask: maskImage, to: ciImage)
            
            // Conversion en UIImage affichable dans SwiftUI
            self.imageDetouree = convertToUIImage(ciImage: outputImage)
        }
    }

    // Utilise Vision pour générer un masque de premier plan (foreground) à partir de l’image
    private func createMask(from inputImage: CIImage) async -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: inputImage)

        do {
            try handler.perform([request])
            if let result = request.results?.first {
                let mask = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                return CIImage(cvPixelBuffer: mask)
            }
        } catch {
            print("Erreur Vision : \(error)")
        }

        return nil
    }

    // Applique le masque sur l’image d’origine pour supprimer l’arrière-plan
    private func applyMask(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty() // fond transparent
        return filter.outputImage ?? image
    }

    // Convertit l’image CoreImage (CIImage) en format UIImage pour SwiftUI
    private func convertToUIImage(ciImage: CIImage) -> UIImage {
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Échec de création du CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
}

// Extension pour corriger l’orientation des UIImage (problème classique de caméra)
extension UIImage {
    func fixedOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? self
    }
}
