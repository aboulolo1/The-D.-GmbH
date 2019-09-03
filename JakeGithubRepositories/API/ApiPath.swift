//
//  File.swift
//  Elmenus
//
//  Created by New  on 7/5/19.
//  Copyright © 2019 Elmenus. All rights reserved.
//

import Foundation

enum ApiPath {
    case repos
}
extension ApiPath{
    var path:String{
        switch self {
        case .repos:
            return "/users/JakeWharton/repos"
        }
        
    }
}
