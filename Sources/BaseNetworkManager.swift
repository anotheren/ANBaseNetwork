//
//  BaseNetworkManager.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2019/4/1.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Alamofire

open class BaseNetworkManager: NetworkManager {
    
    public static let shared = BaseNetworkManager()
    
    private init() { }
    
    public var headerHandle: HeaderHandle = { (params, headers) in
        return headers
    }
    
    public var parametersHandle: ParametersHandle = { params -> Parameters in 
        return params
    }
}
