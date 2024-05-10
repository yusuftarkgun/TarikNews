//
//  WaitingView.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 9.05.2024.

import SwiftUI
import RiveRuntime

struct WaitingView: View {
    

    
    var body: some View {
        VStack{
            RiveViewModel(fileName: "new_file-5").view()
        }
    }
}

#Preview {
    WaitingView()
}


