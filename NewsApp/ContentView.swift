import SwiftUI

struct ContentView: View {
    @State private var articles: [Article] = []
    @State private var selectedCountry: String = "US"
    @State private var selectedCategory: String?
    @State private var backgroundColor: Color = Color(red: 240/255, green: 240/255, blue: 240/255)
    
    let countries = ["US", "GB", "TR"]
    let categories = ["science", "general", "sports"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Menu {
                        ForEach(countries, id: \.self) { country in
                            Button(action: {
                                selectedCountry = country
                                fetchNews(country: selectedCountry, category: selectedCategory ?? "general") { fetchedArticles in
                                    self.articles = fetchedArticles
                                }
                                withAnimation(.easeInOut(duration: 3)) {
                                    self.backgroundColor = Color(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1))
                                }
                            }) {
                                Text(country.uppercased())
                            }
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .padding()
                    }
                }
                
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            fetchNews(country: selectedCountry, category: category) { fetchedArticles in
                                self.articles = fetchedArticles
                            }
                        }) {
                            Text(category.capitalized)
                                .padding()
                                .foregroundColor(.white)
                                .background(selectedCategory == category ? Color.purple : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                .background(LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
                .cornerRadius(50)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(articles, id: \.url) { article in
                            NavigationLink(destination: Text(article.content ?? "No content")) {
                                ArticleCard(article: article)
                                    .frame(width: UIScreen.main.bounds.width - 64)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding()
            .background(LinearGradient(colors: [.purple, .blue], startPoint: .top, endPoint: .trailing))
            .onAppear {
                // Varsayılan olarak ABD'yi seç
                selectedCountry = "US"
                // Seçilen kategori yoksa "general" kategorisini kullan
                let category = selectedCategory ?? "general"
                fetchNews(country: selectedCountry, category: category) { fetchedArticles in
                    self.articles = fetchedArticles
                }
                self.backgroundColor = Color(red: 240/255, green: 240/255, blue: 240/255)
            }
        }
    }

    func fetchNews(country: String, category: String, completion: @escaping ([Article]) -> Void) {
        let apiKey = "ad5b71c2807648f8b6a55db797b1d022"
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(category)&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.articles)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ArticleCard: View {
    let article: Article
    
    @State private var image: UIImage?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .background(.ultraThinMaterial)
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
                                Rectangle()
                                    .fill(Color.gray)
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
                        if image == nil { // Resim daha önceden yüklenmediyse
                                                  loadImage(from: article.urlToImage)
                                              }
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
        }.resume()
    }
}
