import SwiftUI
import RiveRuntime

struct SideMenu: View {
    
    var onSelection: (String, String?) -> Void
    @State private var selectedCountry: String = "US"
    @State private var selectedCategory: String?
    @State  var articles: [Article] = []
    
    let icon = RiveViewModel(fileName: "icons")
    let countries = ["US", "GB", "TR"]
    let categories = ["Science", "General", "Sports"]
    let button = RiveViewModel(fileName: "button")
    
    
    var body: some View {
        ZStack{
            
            RiveViewModel(fileName: "shapes").view()
                .ignoresSafeArea()
                .blur(radius: 20)
                .background(
                    Image("Spline")
                        .blur(radius: 50)
                        .offset(x:200, y: 100)
                )

            VStack(alignment: .leading, spacing: 5) {
                
                HStack {
                    Image(systemName: "flag")
                        .padding(12)
                        .mask(Circle())
                        .background(.blue.opacity(0.2))
                        .cornerRadius(30)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Choose a country")
                            .font(.custom("Poppins Bold", size: 20, relativeTo: .largeTitle))
                        Text("Tarık News")
                            .font(.subheadline)
                            .opacity(0.7)
                    }
                    .padding(.leading)
                }
                .padding()
       
                ForEach(countries, id: \.self) { country in
                    Button(action: {
                        onSelection(selectedCountry, selectedCategory)
                        selectedCountry = country
                        fetchNews(country: selectedCountry, category: selectedCategory ?? "") { fetchedArticles in
                            self.articles = fetchedArticles
                        }
                    })
                    {
                        HStack {
                            Image(systemName: "flag")
                            Text(country)
                                .background(
                                    Color.white
                                        .cornerRadius(5)
                                        .blur(radius: 10)
                                        .opacity(0.9)
                                        .offset(y:10)
                                    
                                )
                        }
                        .padding()
                        
                    }
                    .foregroundColor(.black)
                }
                HStack{
                    Image(systemName: "book")
                        .padding(12)
                        .mask(Circle())
                        .background(.blue.opacity(0.2))
                        .cornerRadius(30)
                    Text("Choose a category")
                        .font(.custom("Poppins Bold", size: 20, relativeTo: .largeTitle))
                }
                .padding()
            
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        onSelection(selectedCountry, selectedCategory)
                        selectedCategory = category
                        
                        fetchNews(country: selectedCountry, category: category) { fetchedArticles in
                            self.articles = fetchedArticles
                        }
                    }
                    ){
                        Image(systemName: "book")
                        Text(category.capitalized)
                            .padding()
                            .background(selectedCategory == category ? Color.accentColor : Color.clear)
                            .cornerRadius(30)
                    }
                    .background(
                        Color.white
                            .cornerRadius(20)
                            .blur(radius: 10)
                            .opacity(0.7)
                            .offset(y:10)
                        
                    )
                            .padding(.leading)
                }
                Spacer()
            }
            .foregroundColor(.black)
            .frame(maxWidth: 288, maxHeight: .infinity)
            .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

func fetchNews(country: String, category: String, completion: @escaping ([Article]) -> Void) {
    let apiKey = "8931b960e2cc41b9911a55ba01e1059e"
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
             
                completion(response.articles!) 
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    task.resume()
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu { country, category in
            print("Selected Country: \(country)")
            print("Selected Category: \(category ?? "None")")
        }
    }
}
