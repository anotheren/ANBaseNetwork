//
//  BaseNetworkManager.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2019/4/1.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Foundation

open class BaseNetworkManager: NetworkManager {
    
    public static let shared = BaseNetworkManager()
    
    private init() { }
    
    public var headerHandle: HeaderHandle?
    public var parametersHandle: ParametersHandle?
}
