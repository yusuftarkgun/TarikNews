//
//  ActionViewController.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 25.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingSheet = false
    let sharedText = "Bu metni paylaşmak istiyorum!"
    let savedImage = UIImage(named: "sample_image") // Kaydedilecek örnek bir resim
    
    var body: some View {
        VStack {
            Button(action: {
                isShowingSheet.toggle()
            }) {
                Text("Paylaş")
            }
            .sheet(isPresented: $isShowingSheet, content: {
                ActivityViewController(activityItems: [sharedText, savedImage!])
            })
            
            Button(action: {
                UIImageWriteToSavedPhotosAlbum(savedImage!, nil, nil, nil)
            }) {
                Text("Kaydet")
            }
        }
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

struct ActionViewController_Previews: PreviewProvider {
    static var previews: some View {
        ActionViewController()
    }
}
