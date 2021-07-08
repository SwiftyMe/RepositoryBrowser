//
//  SearchResultView.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import SwiftUI

///
/// View to show a repository in a list
///
struct RepositoryView: View {
    
    @ObservedObject var viewModel: RepositoryViewModel
    
    var body: some View {
        
        HStack(spacing:5) {
            
            if let image = viewModel.image {
                
                Image(uiImage:image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
            }
            else {
                
                Image("DefaultRepository")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(9)
                    .background(Color("LightGreen"))
                    .cornerRadius(8)
            }

            VStack(alignment:.leading, spacing:2) {

                Text(viewModel.fullName)
                    .font(StyleFont.title)
                    .foregroundColor(StyleColor.textColor)
                
                Text(viewModel.description)
                    .font(StyleFont.dimmedNormal)
                    .foregroundColor(StyleColor.dimmedTextColor)
            }
            
            Spacer()
        }
        .frame(height:50)
        .padding(5)
    }
}

///
/// Preview
///
struct RepositoryView_Previews: PreviewProvider {
    static let viewModel = RepositoryViewModel(model: RepositoryModel(id:0, org:"123",name:"ABC", description:"%%%"))
    static var previews: some View {
        RepositoryView(viewModel:viewModel)
    }
}
