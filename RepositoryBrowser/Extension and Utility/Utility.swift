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

///
/// Utility function to load an image (UIImage) async from a URL
///
func loadImageAsyncFromURL(_ url: String, cached: Bool, setter: @escaping (UIImage) -> Void) {
    
    DispatchQueue.global().async {
        
        if let url = URL(string:url), let image = UIImage(url:url, cached:cached) {
            
            DispatchQueue.main.async {
                setter(image)
            }
        }
    }
}

///
///
///
extension UIImage {
    
    convenience init?(url: URL, cached: Bool) {
        
        if let data = try? Data(contentsOf:url,options: cached ? [NSData.ReadingOptions.mappedIfSafe] : []) {

            self.init(data: data)
            
            return
        }

        return nil
    }
}




