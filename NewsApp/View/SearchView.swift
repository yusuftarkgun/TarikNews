import SwiftUI
import RiveRuntime

struct SearchView: View {
    @State private var articles: [Article] = []
    @State private var searchText: String = ""
    @State private var searchResults: [Article] = []
    @State private var recentSearches: [String] = ["Russia", "NBA", "Science", "Technology", "Health"]
    @State var image: UIImage?

    var body: some View {
        NavigationView {
            ZStack {
        
                RiveViewModel(fileName: "shapes").view()
                    .ignoresSafeArea()
                    .blur(radius: 20)
                    .background(
                        Image("Spline")
                            .blur(radius: 50)
                            .offset(x: 200, y: 100)
                    )
                
                VStack {
                    SearchBar(searchText: $searchText, onSearch: performSearch)
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)) { _ in
                            performSearch()
                        }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(recentSearches, id: \.self) { term in
                                Button(action: {
                                    searchText = term
                                    performSearch()
                                }) {
                                    Text(term)
                                        .foregroundColor(.blue)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color.white)
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    if !searchResults.isEmpty {
                        List {
                            ForEach(searchResults) { article in
                                ArticleCardd(article: article)
                            }
                        }
                        .cornerRadius(50)
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Search", displayMode: .inline)
        }
        .onAppear {
            fetchNews(category: "general", country: "us")
        }
    }

    private func fetchNews(category: String, country: String) {
        API().fetchNews(category: category, country: country) { articles in
                 DispatchQueue.main.async {
                     self.searchResults = articles
                 }
             }
    }

    private func performSearch() {
           let query = searchText.lowercased()
                        if query.isEmpty {
                            fetchNews(category: "general", country: "us")
                            searchResults = []
                        } else {
                            // Güncelleme: API'den gelen haberleri saklayın
                            self.articles = searchResults
                            searchResults = articles.filter { article in
                                let titleMatch = article.title.lowercased().contains(query)
                                let contentMatch = article.content?.lowercased().contains(query) ?? false
                                let descriptionMatch = article.description?.lowercased().contains(query) ?? false
                                return titleMatch || contentMatch || descriptionMatch
                            }
                            recentSearches.insert(searchText, at: 0)
                        }
                    }
       }

struct SearchBar: View {
    @Binding var searchText: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onCommit: onSearch)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            Button(action: {
                searchText = ""
                onSearch()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .padding(.horizontal, 20)
        .background(Color.clear)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

    struct ArticleCardd: View {
        let article: Article
        @State private var image: UIImage? = nil
        
        var body: some View {
            VStack(alignment: .leading) {
                if let urlString = article.urlToImage, let imageURL = URL(string: urlString) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 200)
                            .clipped()
                    }
                } else {
                    WaitingView()
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
            .onAppear {
                if let urlString = article.urlToImage, let imageURL = URL(string: urlString) {
                    fetchImage(from: imageURL.absoluteString) { fetchedImage in

                        DispatchQueue.main.async {
                            self.image = fetchedImage
                        }
                    }
                }
            }
        }
    }



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        let image = UIImage(data: data)
        completion(image)
    }.resume()
}
