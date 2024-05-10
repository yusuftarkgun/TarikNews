import SwiftUI

struct LikedArticlesView: View {
    @State private var likedArticles: [Article] = []
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(likedArticles) { article in
                    ArticleCard(article: article)
                }
                .padding()
            }
        }
        .navigationTitle("Liked Articles")
        .onAppear {
            likedArticles = loadLikedArticles()
        }
    }
    
    func loadLikedArticles() -> [Article] {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "LikedArticles") {
            do {
                let decodedArticles = try JSONDecoder().decode([Article].self, from: data)
                return decodedArticles
            } catch {
                print("Error decoding liked articles: \(error)")
            }
        }
        return []
    }
}


struct LikedArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        LikedArticlesView()
    }
}

