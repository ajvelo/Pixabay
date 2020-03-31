//
//  APIManager.swift
//  CandySpace Pixabay
//
//  Created by Andreas Velounias on 26/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import Foundation

enum APIConstructor: String {
    case key = "13197033-03eec42c293d2323112b4cca6"
    case baseURL = "https://pixabay.com/api/"
    
    static var apiBaseURL : URL {
        guard let url = URL(string: self.baseURL.rawValue) else { preconditionFailure("Base URL couldn't be nil!")}
        return url
    }
}

enum QueryParamKeys: String {
    case key
    case perPage = "per_page"
    case query = "q"
}

final class APIManager {
    
    private let httpClient: HttpClient
    
    init(with httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func searchImages(with query: String, completion: @escaping APIResultCompletionHandler) {
        let urlParams = [
            QueryParamKeys.key.rawValue: APIConstructor.key.rawValue,
            QueryParamKeys.perPage.rawValue: "100",
            QueryParamKeys.query.rawValue : query
            
            ] as [String : Any]
        httpClient.get(url: APIConstructor.apiBaseURL, urlParams: urlParams, completion: completion)
    }
}
