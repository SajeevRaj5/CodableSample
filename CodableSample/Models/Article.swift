//
//  Article.swift
//  CodableSample
//
//  Created by sajeev Raj on 8/10/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation

class Article: Codable {
    var title = ""
    var author = ""
    var publishedDate = ""
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case author = "byline"
        case publishedDate = "published_date"
        case url = "url"
    }
}

extension Article {
    enum Router: Requestable {
        
        case list

        var path: String {
            switch self {
            case .list: return "svc/mostpopular/v2/viewed/7.json"
            }
        }

        var queryParameters: [(queryName: String, queryValue: String)]? {
            switch self {
            case .list: return [("api-key", "khv7rDY89ipce7GPtF3DGKL27Mi81c3h")]
            }
        }
        
        var method: HTTPMethod {
            return .get
        }
    }
}

extension Article {
    class ListResponse: Codable {
        var results = [Article]()
    }
}

extension Article {
    static func getList(completion: @escaping (ServiceResponse<[Article]>) -> ()) {
        Router.list.request { (response: ServiceResponse<ListResponse>) in
            switch response {
            case .success(let results):
                    completion(.success(data: results.results))
            case .failure(let error):
                completion(.failure(error: error))
            case .finally:
                completion(.finally)
            }
        }
    }
}
