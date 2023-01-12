//
//  ApiCaller.swift
//  NewsApp
//
//  Created by Vitaliy on 12.01.2023.
//

import Foundation

final class ApiCaller {
    static let shared = ApiCaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2023-01-11&to=2023-01-11&sortBy=popularity&apiKey=b767daf23b5b4e8ea6bbc86bbd9b7740")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ResponseModel.self, from: data)
                    print(result.articles.count)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
