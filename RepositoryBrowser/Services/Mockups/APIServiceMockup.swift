//
//  File.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 07/07/2021.
//

import Foundation
import Combine
@testable import RepositoryBrowser

///
/// Mockup of the APIServiceRepository protocol for test use
///
class APIServiceMockup1: RepositoryAPI {
    
    typealias Error = APIError
    
    var repositories: [RepositoryModel] = []
    var releases: [RepositoryReleaseModel] = []
    var error: Error?

    func repositories(withName name: String) -> AnyPublisher<[RepositoryModel],Error> {
        
        if let err = error {
            
            return Future<[RepositoryModel],Error> { promise in
                promise(.failure(err))
            }
            .receive(on:RunLoop.main)
            .eraseToAnyPublisher()
        }
        
        guard let _ = URL(string: APIService.endpoint_RepositoryName + name) else {
            return Fail<[RepositoryModel],Error>(error:.InvalidURL)
                .eraseToAnyPublisher()
        }

        return Future<[RepositoryModel],Error> { [self] promise in
            let repos = repositories.filter({ $0.name.contains(name) })
            promise(.success(repos))
        }
        .receive(on:RunLoop.main)
        .eraseToAnyPublisher()
    }
    

    func releases(url: String) -> AnyPublisher<[RepositoryReleaseModel],Error> {

        guard let _ = URL(string:url) else {
            return Fail<[RepositoryReleaseModel],Error>(error:.InvalidURL)
                .eraseToAnyPublisher()
        }

        return Future<[RepositoryReleaseModel],Error> { [self] promise in
            promise(.success(releases))
        }
        .receive(on:RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    init(error: Error) {
        
        self.error = error
    }
    
    init(repositoryCount: Int, releaseCount: Int) {
        
        repositories = [RepositoryModel]()
        
        for i in 0..<repositoryCount {
            
            let model = RepositoryModel(id:i, org: String("org\(i)"), name:String("name\(i)"), description:String("desc\(i)"))
                                        
            repositories.append(model)
        }
        
        releases = [RepositoryReleaseModel]()
        
        for i in 0..<releaseCount {
            
            let model = RepositoryReleaseModel(id: i, publishedAt: String("publishedAt\(i)"), tagName: String("tagName\(i)"))
                                        
            releases.append(model)
        }
    }
}
