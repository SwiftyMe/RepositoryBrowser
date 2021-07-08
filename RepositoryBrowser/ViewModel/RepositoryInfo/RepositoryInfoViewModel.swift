//
//  RepositoryDetailViewModel.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine

///
/// View-model class for the repository list item view
///
class RepositoryInfoViewModel: ObservableObject, Identifiable {
    
    @Published var error: String?

    var id: Int {
        return model.id
    }
    
    @Published var image: UIImage?
    
    let fullName: String
    var language: String = ""
    
    @Published var infos: [Info]
    
    init(model: RepositoryModel, api:APIServiceRepository) {
        
        self.api = api
        self.model = model
        
        fullName = model.fullName
        language = model.language ?? "N/A"

        infos = []
        
        infos.append(Info(name:"Forks", info:String(model.forksCount ?? 0)))
        infos.append(Info(name:"Issues", info:String(model.openIssuesCount ?? 0)))
        infos.append(Info(name:"Starred", info:String(model.stargazersCount ?? 0)))
        infos.append(Info(name:"Last release version", info:""))
        
        if let url = model.owner.avatarURL {
            loadImageAsyncFromURL(url, setter: { [weak self] in self?.image = $0 })
        }
        
        if var url = model.releasesUrl {
            
            if let i = url.firstIndex(of:"{") {
                url.removeSubrange(i ..< url.endIndex)
            }
            
            cancellable = api.releases(url:url).sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.error = error.localizedDescription
                    case .finished:
                        self?.error = nil
                    }
                },
                receiveValue: { [weak self] value in
                    
                    if value.count > 0 {
                        
                        if let last = value.max(by: { $0.releaseDate < $1.releaseDate }) {
                            
                            self?.infos.removeLast()
                            self?.infos.append(Info(name:"Last release version", info:last.tagName))
                        }
                    }
                })
        }
    }
    
    private let model: RepositoryModel
    private let api: APIServiceRepository?
    private var cancellable: AnyCancellable?
}


struct Info: Identifiable {
    
    var id: String { name }
    
    let name: String
    let info: String
}


extension RepositoryReleaseModel {
    
    var releaseDate: Date {
        
        ISO8601DateFormatter().date(from:publishedAt) ?? Date(timeIntervalSince1970:TimeInterval(0))
    }
}
