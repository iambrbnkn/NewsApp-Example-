//
//  ResponseModel.swift
//  NewsApp
//
//  Created by Vitaliy on 12.01.2023.
//

import Foundation

struct ResponseModel:Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
