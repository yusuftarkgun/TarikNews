import SwiftUI

struct CardItem: Identifiable {
        let id: Int
}

struct ScrollTransitionView: View {
    
    let articles: [Article]
    @State private var selectedCountry: String = "US"
    @State private var selectedCategory: String?
    @State private var images: [UIImage?] = Array(repeating: nil, count: 3)
    
    let countries = ["US", "GB", "TR"]
    let categories = ["science", "general", "sports"]
    let cards = [CardItem(id: 0), CardItem(id: 1), CardItem(id: 2)]
    
    var body: some View {
        ScrollView(.horizontal){
            HStack() {
                ForEach(cards.indices) { index in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.clear)
                        .background(.ultraThinMaterial)
                     
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .containerRelativeFrame(.horizontal)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition(axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(x: phase.isIdentity ? 1 : 0.8, y: phase.isIdentity ? 1 : 0.8)
                        }
                        .overlay(
                            VStack(alignment: .leading, spacing: 6) {
                                
                                
                                if let image = images[index] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                        .clipped()
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(height: 200)
                                }
                                
                                Text(articles[index].title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                if let description = articles[index].description {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                
                                if let sourceName = articles[index].source.name {
                                    Text(sourceName)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                HStack {
                                    Text(articles[index].description ?? "")
                                        .lineLimit(2)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // Bookmark action
                                    }) {
                                        Image(systemName: "bookmark")
                                    }
                                    .buttonStyle(.bordered)
                                    
                                    Button(action: {
                                        // Share action
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                    .buttonStyle(.bordered)
                                }
                                .padding([.horizontal, .bottom])
                                .background(Color.clear)
                                
                                if let publishedAt = articles[index].publishedAt {
                                    Text(publishedAt)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding()
                        )
                        .onAppear {
                            loadImage(forIndex: index)
                        }
                }
            }
        }
        .contentMargins(20)
        .scrollIndicators(.hidden)
        .background(LinearGradient(colors: [.purple, .black], startPoint: .top, endPoint: .bottom))
    }
    
    func loadImage(forIndex index: Int) {
        guard let imageURL = articles[index].urlToImage, let url = URL(string: imageURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.images[index] = loadedImage
                }
            }
        }.resume()
    }
}

struct ScrollTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleArticles: [Article] = [
            Article(source: Source(id: "1", name: "Sample Source"), author: "Sample Author", title: "Sample Title", description: "Sample Description", url: "https://example.com", urlToImage: nil, publishedAt: "2024-04-25T12:00:00Z", content: "Sample Content"),
            Article(source: Source(id: "2", name: "Sample Source"), author: "Sample Author", title: "Sample Title", description: "Sample Description", url: "https://example.com", urlToImage: nil, publishedAt: "2024-04-25T12:00:00Z", content: "Sample Content"),
            Article(source: Source(id: "3", name: "Sample Source"), author: "Sample Author", title: "Sample Title", description: "Sample Description", url: "https://example.com", urlToImage: nil, publishedAt: "2024-04-25T12:00:00Z", content: "Sample Content")
        ]
        
        return ScrollTransitionView(articles: sampleArticles)
    }
}

