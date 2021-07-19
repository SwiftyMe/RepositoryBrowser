//
//  MainView.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import SwiftUI

///
/// Top level view having some logic to facilitate simple navigation to other views
///
struct MainScreen: View {
    
    enum Screens { case launch, search }
    
    @State private var navigation: Screens = Screens.launch
    
    @Environment(\.repositoryAPI) private var api
    
    var body: some View {
        
        switch navigation {
            case Screens.launch:  LaunchScreen(navigation:$navigation)
            case Screens.search:  RepositoryBrowserView(viewModel: RepositoryBrowserViewModel(api: api))
        }
    }
}

///
/// Preview
///
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

