//
//  ResponseAPI.swift
//  NewsApp
//
//  Created by Yusuf Tarık Gün on 24.04.2024.
//
import Foundation

struct ResponseAPI: Decodable {
    
    let status: String
    let totalResults: Int
    let articles: [Article]?
    
    let code: String?
    let message: String?
    
}
