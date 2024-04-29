//
//  API.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 24.04.2024.
//

import Foundation


struct API {
    public func fetchNews(category: String, country: String, completion: @escaping ([Article]) -> Void) {
        let apiKey = "ad5b71c2807648f8b6a55db797b1d022"
        let urlString = "https://newsapi.org/v2/top-headlines?category=\(category)&apiKey=\(apiKey)"
        
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
