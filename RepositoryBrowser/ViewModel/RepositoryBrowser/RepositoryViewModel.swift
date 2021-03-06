//
//  SearchResultViewModel.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine

///
/// View-model class for a repository list item
///
class RepositoryViewModel: ObservableObject, Identifiable, ModelObjectAccessor {
    
    /// ModelObjectAccessor conformance
    var modelObject: RepositoryModel {
        model
    }

    /// Identifiable conformance
    var id: Int {
        model.id
    }

    @Published var name: String
    @Published var fullName: String
    @Published var description: String
    @Published var image: UIImage?
    
    func onAppear() {
        
        guard image == nil else { return }

        if let url = model.owner.avatarURL {
            loadImageAsyncFromURL(url, cached:true, setter: { [weak self] in self?.image = $0 })
        }
    }

    init(model: RepositoryModel) {
        
        self.model = model
        
        self.name = model.name
        self.fullName = model.fullName
        
        self.description = model.description ?? ""
    }
    
    private let model: RepositoryModel
}
