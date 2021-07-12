//
//  SearchViewModel.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import Foundation
import SwiftUI
import Combine

///
/// View-model class for the Repository Browser screen view
///
class RepositoryBrowserViewModel: ObservableObject {
    
    @Published var error: String?
    
    @Published var repositories: [RepositoryViewModel]?

    @Published var searchText: String = "" {
        didSet {
            if searchText.count >= minCharacters {
                search()
            }
            else {
                repositories = nil
            }
        }
    }
    
    /// Performs the search of GitHub repositories with a given name match
    ///
    /// 'searchText' property specifies the search pattern
    func search() {
        
        guard searchText.count > 0 else { return }
        
        if let api = api {
            
            cancellable = api.repositories(withName:searchText).sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.repositories = nil
                    case .finished:
                        self.error = nil
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self = self else { return }
                    self.repositories = value.map { RepositoryViewModel.init(model:$0) }
                })
        }
    }
    
    ///
    /// init used for preview
    ///
    init(n:Int) {
        
        api = nil
        
        repositories = []
        
        repositories!.append(RepositoryViewModel(model: RepositoryModel(id:0, org: "123", name:"ABC", description:"###")))
        repositories!.append(RepositoryViewModel(model: RepositoryModel(id:1, org: "456", name:"DEF", description:"€€€")))
        repositories!.append(RepositoryViewModel(model: RepositoryModel(id:2, org: "789", name:"HIJ", description:"$$$")))
    }
    
    init(api:APIServiceRepository) {
        
        self.api = api
    }
    
    private let api: APIServiceRepository?
    private var cancellable: AnyCancellable?
    
    private let minCharacters = Int(3)
}
