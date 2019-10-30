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
    
    func handle(data: Data) -> Result<ResultType, Error>
}

@discardableResult
public func request<T: DataRequestAPI>(api: T, completion: @escaping (Result<T.ResultType, Error>) -> Void) -> DataRequest {
    return NetworkManager.shared.request(api: api, completion: completion)
}
