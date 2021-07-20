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
        model.id
    }

    @Published var avatarImage: UIImage?
    
    let fullName: String
    let language: String
    
    @Published var infos: [Info]
    
    init(model: RepositoryModel, avatarImage: UIImage? = nil, api: RepositoryAPI) {

        self.api = api
        self.model = model
        
        fullName = model.fullName
        language = model.language ?? "N/A"
        
        infos = []
        
        infos.append(Info(name:"Forks", info:String(model.forksCount ?? 0)))
        infos.append(Info(name:"Issues", info:String(model.openIssuesCount ?? 0)))
        infos.append(Info(name:"Starred", info:String(model.stargazersCount ?? 0)))
        infos.append(Info(name:"Last release version", info:""))
        
        self.avatarImage = avatarImage
        
        updateImage()
        updateRelease()
    }
    
    private let model: RepositoryModel
    private let api: RepositoryAPI?
    private var cancellable: AnyCancellable?
}


struct Info: Identifiable {
    
    var id: String { name }
    
    let name: String
    let info: String
}


extension RepositoryInfoViewModel {
    
    func updateImage() {
        
        if let url = model.owner.avatarURL, avatarImage == nil {
            loadImageAsyncFromURL(url, setter: { [weak self] in self?.avatarImage = $0 })
        }
    }
    
    func updateRelease() {
        
        guard var url = model.releasesUrl else {
            return
        }
        
        if let i = url.firstIndex(of:"{") {
            url.removeSubrange(i ..< url.endIndex)
        }
        
        cancellable = api!.releases(url:url).sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                    case .failure(let error):
                        self.error = error.localizedDescription
                    case .finished:
                        self.error = nil
                }
            },
            receiveValue: { [weak self] value in
                guard let self = self else { return }
                if value.count > 0 {
                    if let last = value.max(by: { $0.releaseDate < $1.releaseDate }) {
                        self.infos.removeLast()
                        self.infos.append(Info(name:"Last release version", info:last.tagName))
                    }
                }
            })
    }
}


extension RepositoryReleaseModel {
    
    var releaseDate: Date {
        
        ISO8601DateFormatter().date(from:publishedAt) ?? Date(timeIntervalSince1970:TimeInterval(0))
    }
}
