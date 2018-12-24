//
//  BaseAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/7/2.
//  Copyright © 2018年 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire

public protocol BaseAPI {
    
    var baseURL: String { get }
    var path: String { get }
    var url: String { get }
    var method: Alamofire.HTTPMethod { get }
    var parameters: Alamofire.Parameters { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var headers: Alamofire.HTTPHeaders { get }
}

extension BaseAPI {
    
    public var url: String {
        return baseURL + path
    }
    
    public var parameters: Alamofire.Parameters {
        return [:]
    }
    
    public var encoding: Alamofire.ParameterEncoding {
        return URLEncoding()
    }
    
    public var headers: Alamofire.HTTPHeaders {
        return [:]
    }
}
