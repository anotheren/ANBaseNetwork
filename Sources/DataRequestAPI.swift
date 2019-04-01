//
//  DataRequestAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/7/2.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire

public protocol DataRequestAPI: BaseAPI {
    
    associatedtype ResultType
    
    func handle(data: Data) -> Result<ResultType>
}

@discardableResult
public func request<T: DataRequestAPI>(api: T,
                                       manager: NetworkManager = BaseNetworkManager.shared,
                                       completion: @escaping (Result<T.ResultType>) -> Void) -> Alamofire.DataRequest {
    return manager.request(api: api, completion: completion)
}
