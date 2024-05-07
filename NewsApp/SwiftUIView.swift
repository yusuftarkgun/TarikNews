import SwiftUI
import RiveRuntime

struct SwiftUIView: View {
    
    let button = RiveViewModel(fileName: "button")
    let icon = RiveViewModel(fileName: "icons", stateMachineName: "CHAT_Interactivity", artboardName: "CHAT")
    
    var body: some View {
        HStack{
            Button{
                try? icon.setInput("active", value: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    try? icon.setInput("active", value: false)
                }
                } label: {
                    icon.view()
                }
                    }
                .background()
        ZStack{
            RiveViewModel(fileName: "shapes").view()
                .ignoresSafeArea()
                .blur(radius: 20)
                .background(
                    Image("Spline")
                        .blur(radius: 50)
                        .offset(x:200, y: 100)
                )
        
            VStack(alignment: .center, spacing: 600){
                
                Text("Profile")
                    .font(.custom("Poppins Bold", size: 60, relativeTo: .largeTitle))
                    .frame(width: 260, alignment: .leading)
                button.view()
                    .frame(width: 236, height: 64)
                    .overlay(
                        Label("Update", systemImage: "arrow.forward")
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
}

#Preview {
    SwiftUIView()
}
