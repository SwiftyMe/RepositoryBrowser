//
//  RepositoryScreenView.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import SwiftUI

///
/// Repository detail view being presented in a navigation view context
///
struct RepositoryInfoView: View {

    @ObservedObject var viewModel: RepositoryInfoViewModel
    
    /// Private
    
    @Environment(\.presentationMode) private var presentationMode
    
    private let imageSize = CGFloat(150)
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Button(action:{ close() }) {
                    Image(systemName:"arrow.left")
                }
                .buttonStyle(HeaderButtonStyle())
                
                Spacer()
            }

            HStack(spacing:5) {
                
                Spacer()
                
                VStack(spacing:5) {
                    
                    if let image = viewModel.avatarImage {
                        
                        Image(uiImage:image)
                            .resizable()
                            .aspectRatio(contentMode:.fit)
                            .padding(5)
                            .frame(height: imageSize)
                    }
                    else {
                        
                        Image("DefaultRepository")
                            .resizable()
                            .aspectRatio(contentMode:.fit)
                            .padding(9)
                            .background(Color("LightGreen"))
                            .cornerRadius(8)
                            .frame(height: imageSize)
                    }
                    
                    Text(viewModel.fullName)
                        .font(StyleFont.title)
                        .foregroundColor(StyleColor.textColor)
                        .lineLimit(1)
                    
                    Text(viewModel.language)
                        .font(StyleFont.normal)
                        .foregroundColor(StyleColor.dimmedTextColor)
                }
                
                Spacer()
            }
            .padding(.bottom,20)
            .padding(5)
            
            VStack {
                
                ForEach(viewModel.infos) { info in
                    
                    VStack(spacing:10) {
                        
                        HStack {
                            Text(info.name)
                            Spacer()
                            Text(info.info)
                        }
                        .font(StyleFont.normal)
                        .foregroundColor(StyleColor.textColor)
                        .padding(.horizontal,2)
                        
                        if info.id != viewModel.infos.last!.id {
                            Divider().padding(.vertical,10)
                        }
                    }
                }
            }
            .padding(.vertical,5)
            .padding()
            .overlay(RoundedRectangle(cornerRadius:CGFloat(8))
                        .stroke(Color.init(white:0.94), lineWidth:1))
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .onAppear(perform:onAppear)
    }

    private func close() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func onAppear() {
        viewModel.onAppear()
    }
}

fileprivate struct HeaderButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width:33,height:33)
            .foregroundColor(configuration.isPressed ? Color.blue : Color.gray)
    }
}

///
/// Preview
///
struct InfoScreenView_Previews: PreviewProvider {
    static let viewModel = RepositoryInfoViewModel(model:RepositoryModel(id:0, org:"123", name:"ABC", description:"$$$"), api:APIService())
    static var previews: some View {
        RepositoryInfoView(viewModel:viewModel)
    }
}
