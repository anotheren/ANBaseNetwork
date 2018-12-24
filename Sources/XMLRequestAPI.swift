//
//  XMLRequestAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/12/20.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

public protocol XMLRequestAPI: BaseAPI {
    
    associatedtype ResultType
    
    func handle(xml: XMLIndexer) -> Result<ResultType>
}

@discardableResult
public func request<T: XMLRequestAPI>(api: T, completion: @escaping (Result<T.ResultType>) -> Void) -> Alamofire.DataRequest {
    return request(api.url, method: api.method, parameters: api.parameters, encoding: api.encoding, headers: api.headers).responseData { response in
        switch response.result {
        case let .failure(error):
            completion(.failure(error))
        case let .success(data):
            let xml = SWXMLHash.parse(data)
            completion(api.handle(xml: xml))
        }
    }
}
