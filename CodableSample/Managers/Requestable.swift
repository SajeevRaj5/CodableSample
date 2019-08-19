//
//  Requestable.swift
//  CurrencyConverter
//
//  Created by sajeev Raj on 7/18/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation

enum ServiceResponse<T: Codable> {
    case success(data: T)
    case failure(error: Error)
    case finally
}

// protocol for parameters and path
protocol Requestable {
    
    // url path
    var path: String { get }
    
    // required parameters
    var parameters: [String: String] { get }
    
    // http method
    var method: HTTPMethod { get }
    
    // url query items
    var queryParameters: [(queryName: String, queryValue: String)]? { get }
    
    // request
    func request<T: Codable>(completion: ServiceResponseBlock<T>?)
}

extension Requestable {
    
    // setting GET by default
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: [(queryName: String, queryValue: String)]? {
        return nil
    }
    
    var parameters: [String: String] {
        return [:]
    }
}

extension Requestable {
    func request<T: Codable>(completion: ServiceResponseBlock<T>?) {
        guard var components = URLComponents(string: ServiceManager.API.baseUrl?.appendingPathComponent(path).absoluteString ?? "") else { return }
        
        // add query items if present
        if (queryParameters?.count ?? 0) > 0 {
            let urlQueryItems = queryParameters!.map{ return URLQueryItem(name: $0.0, value: $0.1) }
            components.queryItems = urlQueryItems
        }
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
    
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        // add parameters as body if service has paramters
        if parameters.count > 0 {
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
        }
        
        // if services are to be discarded, donot request
        if !ServiceManager.shared.shouldDiscardServices {
            ServiceManager.shared.request(request: request, completion: completion)
        }
        
    }
}


