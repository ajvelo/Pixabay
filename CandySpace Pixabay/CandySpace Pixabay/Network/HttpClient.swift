//
//  HttpClient.swift
//  CandySpace Pixabay
//
//  Created by Andreas Velounias on 26/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import Foundation

enum PixabayError: Error {
    case badURL
    case cannotConnectToInternet
    case networkError(message: String)
    case apiResponseError(message: String)
}

typealias APIResultCompletionHandler = (Result<[String: Any], PixabayError>) -> Void

// Protocol used by both Mock and Real objects
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

public protocol URLSessionDataTaskProtocol {
    func resume()
}

final class HttpClient {
    private let urlSession: URLSessionProtocol
    
    init(with urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func get(url: URL, urlParams: [String: Any], completion: @escaping APIResultCompletionHandler) {
        let request = createRequestHeader(with: url, urlParams: urlParams, method: "GET")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    func createRequestHeader(with url: URL, urlParams: [String: Any]? = nil, bodyContentType: String? = "application/json", method: String) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode any URL parameter query items
        if let urlParams = urlParams {
            var queryItems = [URLQueryItem]()

            for p in urlParams {
                queryItems.append(URLQueryItem(name: p.key, value: p.value as? String))
            }

            let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)

            if let urlComponents = urlComponents {
                urlComponents.queryItems = queryItems
                request = URLRequest(url: (urlComponents.url)!)
            }
        }
        
        request.httpMethod = method
        return request
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping APIResultCompletionHandler) {
        if let error = error as NSError?, error.domain == NSURLErrorDomain {
            switch error.code {
            case NSURLErrorNotConnectedToInternet:
                completion(.failure(.cannotConnectToInternet))
                
            default:
                completion(.failure(.networkError(message: error.localizedDescription)))
            }
            return
        }
        
        guard let data = data else {
            completion(.failure(.apiResponseError(message: "API Error: \(String(describing: error))")))
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(.success(json))
            }
        } catch let error as NSError {
            completion(.failure(.apiResponseError(message: "Parsing API response Error: \(String(describing: error))")))
        }
    }
}

// MARK: - Conforming to Protocols
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
