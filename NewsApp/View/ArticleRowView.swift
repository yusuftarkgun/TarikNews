/*import SwiftUI

struct ArticleRowView: View {
    let article: Article
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 220)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 200)
            }
                
            Text(article.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let description = article.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let sourceName = article.source.name {
                Text(sourceName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
              
            HStack {
                Text(article.description ?? "")
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Image(systemName: "bookmark")
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .padding([.horizontal, .bottom])
            .background(Color.clear)
            Spacer()
            
            if let publishedAt = article.publishedAt {
                Text(publishedAt)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .onAppear {
            loadImage()
             
        }
        .background(Color.clear)
    }
    
    func loadImage() {
        guard let imageURL = article.urlToImage, let url = URL(string: imageURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyArticle = Article(source: Source(id: "dummy", name: "Dummy Source"), author: "Dummy Author", title: "Dummy Title", description: "Dummy Description", url: "https://dummy.com", urlToImage: "https://dummy.com/image.jpg", publishedAt: "2024-04-24T12:00:00Z", content: "Dummy Content")
        ArticleRowView(article: dummyArticle)
    }
}
*/
