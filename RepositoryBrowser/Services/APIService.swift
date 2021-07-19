//
//  APIService.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 15/04/2021.
//

import Foundation
import Combine

///
/// protocol Errors
///
enum APIError: Swift.Error {
    case InvalidParameter(String)
    case InvalidURL
    case Network(HTTPService.Error)
}

///
/// protocol RepositoryAPI
///
protocol RepositoryAPI {
    
    typealias Error = APIError
    
    func repositories(withName: String) -> AnyPublisher<[RepositoryModel],Error>
    
    func releases(url: String) -> AnyPublisher<[RepositoryReleaseModel],Error>
}

/// Implementation of high level Interface to the GitHub API
///
/// - Note: Intended only for demonstration purposes
///
class APIService: RepositoryAPI {
    
    typealias Error = APIError
    
    /// APIServiceRepository protocol function - repositories
    ///
    /// Returns a publisher outputting a number of GitHub repositories matching a name
    func repositories(withName name: String) -> AnyPublisher<[RepositoryModel],Error> {
        
        guard name.count > 0 else {
            return Fail<[RepositoryModel],Error>(error:.InvalidParameter("parameter 'name' is empty in function 'repositories'"))
                .eraseToAnyPublisher()
        }

        guard let url = URL(string: APIService.endpoint_RepositoryName + name) else {
            return Fail<[RepositoryModel],Error>(error:.InvalidURL)
                .eraseToAnyPublisher()
        }
        
        return HTTPService.getJSON(url:url)
            .map { (repos:RepositoriesModel) -> [RepositoryModel]  in  repos.items }
            .mapError { error -> Error in Error.Network(error) }
            .receive(on:RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// APIServiceRepository protocol function - releases
    ///
    ///
    func releases(url: String) -> AnyPublisher<[RepositoryReleaseModel],Error> {

        guard let url = URL(string:url) else {
            return Fail<[RepositoryReleaseModel],Error>(error:.InvalidURL)
                .eraseToAnyPublisher()
        }

        return HTTPService.getJSON(url:url)
            .mapError { error -> Error in Error.Network(error) }
            .receive(on:RunLoop.main)
            .eraseToAnyPublisher()
    }
}

///
/// GitHub API URLs
///
extension APIService {

    static let endpoint_RepositoryName = "https://api.github.com/search/repositories?q="
}

///
/// Error Text messages
///
extension APIService.Error: LocalizedError {
    
    var localizedDescription: String {
        switch self {
        
            case .InvalidParameter(let description):
                return "Invalid parameter - \(description)"
        
            case .InvalidURL:
                return "string contains characters that are illegal in a URL"
            
            // TODO: Add non-general error messages
        
            case let .Network(HTTPServiceError):
                if case HTTPService.Error.HTTPCode(let code) = HTTPServiceError {
                    if code == 403 {
                        return HTTPServiceError.localizedDescription + "\n\n TODO: Add message"
                    }
                }
                
                return HTTPServiceError.localizedDescription
        }
    }
}

