//
//  OnBoardingView.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 29.04.2024.
//
import RiveRuntime
import SwiftUI

struct OnBoardingView: View {
    let button = RiveViewModel(fileName: "button")
    
    var body: some View {
        ZStack{
            background
            
            VStack{
                
                Text("News")
                    .font(.custom("Poppins Bold", size: 60, relativeTo: .largeTitle))
                    .frame(width: 260, alignment: .leading)
                button.view()
                    .frame(width: 236, height: 64)
                    .overlay(
                        Label("Start", systemImage: "arrow.forward")
                            .offset(x: 4, y: 4)
                            .font(.headline)
                    )
                    .background(
                        Color.black
                            .cornerRadius(30)
                            .blur(radius: 10)
                            .opacity(0.3)
                            .offset(y:10)
                        
                    )
                    .onTapGesture {
                        button.play(animationName: "active")
                    }
            }
        }
    }
    
    var background: some View{
        RiveViewModel(fileName: "shapes").view()
            .ignoresSafeArea()
            .blur(radius: 20)
            .background(
                Image("Spline")
                    .blur(radius: 50)
                    .offset(x:200, y: 100)
        )
        
    }
    
    struct OnBoardingView_Previews: PreviewProvider{
        static var previews: some View{
            OnBoardingView()
        }
    }
}
