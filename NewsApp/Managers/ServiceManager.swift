import Foundation

struct API {
    public func fetchNews(category: String, country: String, completion: @escaping ([Article]) -> Void) {
        let apiKey = "2c7f4e3ab76a474b8f4f1c4f476c4cfc"
        let urlString = "https://newsapi.org/v2/top-headlines?country=\(country)&category=\(category)&apiKey=\(apiKey)"

        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                        DispatchQueue.main.async {
                            completion(response.articles ?? [])
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
