//
//  ServiceManager.swift
//  CurrencyConverter
//
//  Created by sajeev Raj on 7/18/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation

typealias ServiceResponseBlock<T: Codable> = (ServiceResponse<T>) -> ()

class ServiceManager {
    
    static let shared = ServiceManager()
    var dataTask: URLSessionDataTask?
    var shouldDiscardServices: Bool = false

    private init() {}
    
    func request<T>(request: URLRequest, completion: ServiceResponseBlock<T>?) where T: Codable {
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion?(.finally)

            if let error = error {
                completion?(.failure(error: error))
                return
            }
            guard let _ = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                completion?(.failure(error: error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                completion?(.success(data: responseData))
                
            } catch let err {
                print("Err", err)
                completion?(.failure(error: err))
            }
        }.resume()
        
    }
    
    func cancelAllRequests() {
        shouldDiscardServices = true
    }
    
    func resume() {
        shouldDiscardServices = false
    }
}

extension ServiceManager {
    struct API {
        static var baseUrl: URL? {
            return URL(string: "https://api.nytimes.com")
        }
    }
}

enum HTTPMethod: String {
    case get
    case post
    case update
    case delete
}
