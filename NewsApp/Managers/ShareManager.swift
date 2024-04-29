//
//  ShareManager.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 25.04.2024.
//
/*
import Foundation
import SwiftUI
import UIKit

struct ShareManager {
    static func share(url: String) {
        guard let url = URL(string: url) else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
struct ShareSheetView: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update logic here
    }
}

struct SaveToGalleryView: View {
    let image: UIImage
    
    var body: some View {
        Button(action: saveToGallery) {
            Text("Save to Gallery")
        }
    }
    
    private func saveToGallery() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}


struct ShareSheetExample: View {
    @State private var isShowingSheet = false
    let sharedText = "Bu metni paylaşmak istiyorum!"
    
    var body: some View {
        Button(action: {
            isShowingSheet.toggle()
        }) {
            Text("Paylaş")
        }
        .sheet(isPresented: $isShowingSheet, content: {
            ActivityViewController(activityItems: [sharedText])
        })
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to do here
    }
}
*/
