import SwiftUI
import SplineRuntime

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        }
        else {
            SplineViewWrapper(isActive: $isActive)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
                        self.isActive = true
                }
            }
        }
    }
}

struct SplineViewWrapper: View {
    @Binding var isActive: Bool

    var body: some View {
        if let url = URL(string: "https://build.spline.design/AIshc7wetkiauHl8hs5i/scene.splineswift") {
            do {
                let splineView = try SplineView(sceneFileURL: url)
                return AnyView(splineView.ignoresSafeArea(.all))
            } catch {
         
                print("Error: \(error)")
            }
        }
        return AnyView(EmptyView())
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
