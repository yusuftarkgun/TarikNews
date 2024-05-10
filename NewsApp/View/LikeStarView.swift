import SwiftUI
import SwiftUI

struct LikeStarView: View {
    @State private var likedArticles: [Article] = []
    @State private var isRefreshing = false // Yenileme durumunu izlemek için bir state
    @State private var fetchedImages: [String: UIImage] = [:] // Yüklenen resimleri saklamak için bir dictionary

    var body: some View {
        NavigationView {
            ZStack {
                // Arka plan görüntüsü
                Image("Spline")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 50)
                
                // Ana içerik
                VStack {
                    Text("Your Likes")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    // Beğenilen makaleler listesi veya uygun metin
                    if likedArticles.isEmpty {
                        if isRefreshing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                                .padding()
                        } else {
                            Text("You haven't liked any articles yet.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(likedArticles) { article in
                                    VStack(alignment: .leading) {
                                        if let urlString = article.urlToImage, let imageURL = URL(string: urlString) {
                                            if let image = fetchedImages[urlString] {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                                                    .clipped()
                                            } else {
                                                Rectangle()
                                                    .fill(Color.gray)
                                                    .frame(height: 200)
                                                    .onAppear {
                                                        fetchImage(from: urlString) { fetchedImage in
                                                            fetchedImages[urlString] = fetchedImage
                                                        }
                                                    }
                                            }
                                        } else {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(height: 200)
                                        }
                                        Text(article.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .padding(.horizontal)
                                        Text(article.description ?? "")
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .onAppear {
                fetchLikedArticles()
            }
            .toolbar {
                // Yenileme düğmesi
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        refreshLikedArticles()
                    }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // Beğenilen makaleleri yeniden yükle
    func fetchLikedArticles() {
        let savedArticleIDs = UserDefaults.standard.array(forKey: "LikedArticles") as? [String] ?? []
        
        guard !savedArticleIDs.isEmpty else {
            return
        }
        
        let group = DispatchGroup()
        
        for articleID in savedArticleIDs {
            group.enter()
            
            // API'den makaleyi alma
            fetchArticle(withID: articleID) { article in
                if let article = article {
                    DispatchQueue.main.async {
                        self.likedArticles.append(article)
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("All API calls completed")
        }
    }
    
    // Yenileme işlevi
    func refreshLikedArticles() {
        isRefreshing = true
        
        likedArticles.removeAll()
        
        fetchLikedArticles()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isRefreshing = false
        }
    }
    
    // Makaleyi API'den al
    func fetchArticle(withID articleID: String, completion: @escaping (Article?) -> Void) {
        let apiKey = "ad5b71c2807648f8b6a55db797b1d022"
        let urlString = "https://newsapi.org/v2/everything?q=\(articleID)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching article: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
                if let article = decodedResponse.articles?.first {
                    DispatchQueue.main.async {
                        completion(article)
                    }
                } else {
                    print("No articles found for ID: \(articleID)")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}

struct LikeStarView_Previews: PreviewProvider {
    static var previews: some View {
        LikeStarView()
    }
}
