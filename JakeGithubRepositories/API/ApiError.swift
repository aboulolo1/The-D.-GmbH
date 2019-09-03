//
//  Error.swift
//  Elmenus
//
//  Created by New  on 7/5/19.
//  Copyright © 2019 Elmenus. All rights reserved.
//

import Foundation

enum ApiError:Error {
    case noData
    case invalidData
    case noConnetion
    case noDataCached
    case error(String)
}
extension ApiError
{
    var localizedDescritpion:String{
        switch self {
        case .noData:
            return "No Data Found"
        case .invalidData:
            return "Invaild Data"
        case .noConnetion:
            return "No Internet Connection"
        case .error(let err):
            return err
        case .noDataCached:
            return "No Data Cached"

        }
    }
}
