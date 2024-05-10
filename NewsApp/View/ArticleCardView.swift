import SwiftUI
import RiveRuntime

struct ArticleCard: View {
    
    let article: Article
    @State private var image: UIImage?
    @State private var isBookmarked: Bool = false
    

    
    var body: some View {
        
        ScrollView(.horizontal) {
            LazyHStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 1.0)))
                    .background((Color(UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 1.0))))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .containerRelativeFrame(.horizontal)
                    .containerRelativeFrame(.horizontal)
                    .transition(.scale)
                    .overlay(
                        VStack(alignment: .leading, spacing: 6) {
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                    .clipped()
                            } else {
                                WaitingView()
                                    .frame(height: 200)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(article.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.leading)
                                
                                if let description = article.description {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.leading)
                                }
                                
                                if let sourceName = article.source.name {
                                    Text(sourceName)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.leading)
                                        .padding(.horizontal)
                                }
                            }
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    toggleBookmark()
                                    isBookmarked.toggle()
                                }) {
                                    Image(systemName: isBookmarked ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                                .buttonStyle(.bordered)
                                
                                Button(action: {
                                    
                                    let activityViewController = UIActivityViewController(activityItems: [article.url, article.title, article.description ?? ""], applicationActivities: nil)
                                    UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding(.horizontal)
                            .background(Color.clear)
                            
                            Text(article.publishedAt ?? "")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.leading)
                                .padding([.leading, .bottom])
                        }
                        .contentMargins(20)
                        .scrollIndicators(.hidden)
                        .background(Color.clear)
                        .cornerRadius(12)
                        .shadow(radius: 20)
                    )
                    .onAppear {
                        if image == nil { loadImage(from: article.urlToImage) }
                    }
            }
        }
    }
    
    private func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }
        .resume()
    }
    
    private func toggleBookmark() {
        let userDefaults = UserDefaults.standard
        var likedArticles = userDefaults.array(forKey: "LikedArticles") as? [String] ?? []

        if isBookmarked {
          
            if let index = likedArticles.firstIndex(of: article.id.uuidString) {
                likedArticles.remove(at: index)
                userDefaults.set(likedArticles, forKey: "LikedArticles")
                print("Bookmark removed for article: \(article.id)")
            }
        } else {
           
            likedArticles.append(article.id.uuidString)
            userDefaults.set(likedArticles, forKey: "LikedArticles")
            print("Bookmark added for article: \(article.id)")
        }
    }


    
    private func isArticleBookmarked(_ article: Article) -> Bool {
        let userDefaults = UserDefaults.standard
        let likedArticles = userDefaults.array(forKey: "LikedArticles") as? [String] ?? []
        return likedArticles.contains(article.id.uuidString)
    }
    
}
