//
//  RequestAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/7/2.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire

public protocol RequestAPI: BaseAPI {
    
    associatedtype ResultType
    
    func handle(data: Data) -> Result<ResultType>
}

@discardableResult
public func request<T: RequestAPI>(api: T, completion: @escaping (Result<T.ResultType>) -> Void) -> Alamofire.DataRequest {
    return request(api.url, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers).responseData { response in
        switch response.result {
        case let .failure(error):
            completion(.failure(error))
        case let .success(data):
            completion(api.handle(data: data))
        }
    }
}
