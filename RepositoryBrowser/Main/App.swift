//
//  RepositoryBrowserApp.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import SwiftUI

@main
struct RepositoryBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
    }
}

private struct APIServiceKey: EnvironmentKey {
    static let defaultValue: RepositoryAPI = APIService()
}

extension EnvironmentValues {
  var repositoryAPI: RepositoryAPI {
    get { self[APIServiceKey.self] }
    set { self[APIServiceKey.self] = newValue }
  }
}
