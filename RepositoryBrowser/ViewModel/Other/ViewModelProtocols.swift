//
//  ViewModelProtocols.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 16/04/2021.
//

import Foundation

/// A protocol that provide access to underlying model object
protocol ModelObjectAccessor {
    associatedtype ModelType: Decodable
    var modelObject: ModelType { get }
}
