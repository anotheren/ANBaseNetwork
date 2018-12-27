//
//  JSONRequestAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/7/2.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol JSONRequestAPI: BaseAPI {
    
    associatedtype ResultType
    
    func handle(json: JSON) -> Result<ResultType>
}

@discardableResult
public func request<T: JSONRequestAPI>(api: T, completion: @escaping (Result<T.ResultType>) -> Void) -> Alamofire.DataRequest {
    return request(api.url, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers).responseJSON { response in
        switch response.result {
        case let .failure(error):
            completion(.failure(error))
        case let .success(object):
            let json = JSON(object)
            completion(api.handle(json: json))
        }
    }
}
