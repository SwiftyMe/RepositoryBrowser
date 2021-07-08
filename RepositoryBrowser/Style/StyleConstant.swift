//
//  StyleConstant.swift
//  RepositoryBrowser
//
//  Created by Anders Lassen on 14/04/2021.
//

import Foundation
import SwiftUI

class StyleColor {
    
    static let textColor = Color.init(white:0.3)
    static let dimmedTextColor = Color.init(white:0.75)
}

class StyleFont {
    
    static let normalSize = CGFloat(14.0)
    
    static let titleSize = normalSize + CGFloat(1)
    static let mediumTitleSize = CGFloat(18)
    static let largeTitleSize = CGFloat(23)
    
    static let title = Font.system(size:StyleFont.titleSize, weight:.bold)
    static let largeTitle = Font.system(size:StyleFont.largeTitleSize, weight:.bold)
    static let mediumTitle = Font.system(size:StyleFont.mediumTitleSize, weight:.bold)
    
    static let normal = Font.system(size:StyleFont.normalSize, weight:.semibold)
    static let dimmedNormal = normal
}
