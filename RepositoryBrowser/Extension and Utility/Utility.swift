//
//  Utility.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 16/04/2021.
//

import Foundation
import UIKit

///
/// Utility function to load an image (UIImage) async from a URL
///
func loadImageAsyncFromURL(_ url: String, setter: @escaping (UIImage) -> Void) {
    
    DispatchQueue.global().async {
        
        if let url = URL(string:url), let data = try? Data(contentsOf:url), let image = UIImage(data:data) {
            
            DispatchQueue.main.async {
                setter(image)
            }
        }
    }
}
