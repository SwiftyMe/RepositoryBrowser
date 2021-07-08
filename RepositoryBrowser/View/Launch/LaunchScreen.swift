//
//  LaunchScreen.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import SwiftUI

///
/// Splash screen view that closes by itself after some seconds
///
struct LaunchScreen: View {
    
    @Binding var navigation: MainScreen.Screens
    
    var body: some View {
        
        VStack(spacing:4) {
            
            Image("LaunchImage")
            
            Text("GitExplorer")
                .font(.system(size:32, weight:Font.Weight.bold))
                .foregroundColor(Color("DarkBlue"))
            
            HStack {
                
                Spacer()
                
                Text("by SwiftyMe")
                    .font(.system(size:14, weight:Font.Weight.medium))
                    .foregroundColor(Color("Gray"))
            }
        }
        .fixedSize()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation() {
                    navigation = .search
                }
            }
        }
    }
}

///
/// Preview
///
struct LaunchScreen_Previews: PreviewProvider {
    static var screen = Binding<MainScreen.Screens>.constant(MainScreen.Screens.search)
    static var previews: some View {
        LaunchScreen(navigation:screen)
    }
}
