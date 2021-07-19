//
//  SearchScreen.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import SwiftUI

///
/// Repository Browser view - to search for repositories on GitHub
///
struct RepositoryBrowserView: View {
    
    @ObservedObject var viewModel: RepositoryBrowserViewModel
    
    @Environment(\.repositoryAPI) private var api
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment:.leading, spacing:17) {
                
                Text("Repository library")
                    .font(StyleFont.largeTitle)
                    .foregroundColor(StyleColor.textColor)
                    .padding(.top,5)
                
                HStack  {
                    
                    Image(systemName:"magnifyingglass")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                        .padding(.leading, 12)
                    
                    TextField("Search for repository",text:$viewModel.searchText) { isEditing in
                    } onCommit: {
                        viewModel.search()
                    }
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.vertical)
                }
                .background(Color.init(.sRGB ,white:0.94))
                .cornerRadius(7)
                
                if let repositories = viewModel.repositories {
                    Text("\(repositories.count) results")
                        .font(StyleFont.mediumTitle)
                        .foregroundColor(StyleColor.dimmedTextColor)
                        .padding(.leading,5)
                }
                
                if let error = viewModel.error {
                    Text(error)
                        .font(StyleFont.mediumTitle)
                        .foregroundColor(Color.red)
                        .padding()
                }
                
                ScrollView {
                    
                    LazyVStack {
                        
                        ForEach(viewModel.repositories ?? []) { repository in
                            
                            NavigationLink(
                                destination:
                                    RepositoryInfoView(viewModel:
                                        RepositoryInfoViewModel(model: repository.modelObject,
                                                    avatarImage: repository.image, api: api))
                                ,label: {
                                    RepositoryView(viewModel:repository)
                                })
                        }
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Repository browser")
        }
    }
}

///
/// Preview
///
struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryBrowserView(viewModel: RepositoryBrowserViewModel(api: APIService()))
    }
}
