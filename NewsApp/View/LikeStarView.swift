import SwiftUI

struct LikeStarView: View {
    @State private var likedArticles: [Article] = []

    var body: some View {
        VStack {
            Text("Your Likes")
                .font(.custom("Poppins Bold", size: 40, relativeTo: .largeTitle))
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(likedArticles, id: \.self) { article in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(article.title ?? "No Title")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(article.description ?? "No Description")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .onAppear {
      
            DispatchQueue.main.async {
                likedArticles = loadLikedArticles()
            }
        }
    }
    
    func loadLikedArticles() -> [Article] {
     
        return []
    }
    
    struct Article: Identifiable, Hashable {
        let id = UUID()
        let title: String?
        let description: String?
      
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Article, rhs: Article) -> Bool {
            return lhs.id == rhs.id
        }
    }
}

struct LikeStar_Previews: PreviewProvider {
    static var previews: some View {
       LikeStarView()
    }
}

