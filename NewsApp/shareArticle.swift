import UIKit

class ShareManager {
    static let shared = ShareManager()
    
    private init() {}
    
    func shareArticle(_ articleTitle: String, _ articleURL: String) {
        let activityViewController = UIActivityViewController(activityItems: [articleTitle, articleURL], applicationActivities: nil)
        
        // Bu, iOS 13 ve sonrası sürümler için bir kontrol eklenebilir
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = UIApplication.shared.windows.first?.rootViewController?.view
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}

