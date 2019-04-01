//
//  NetworkManager.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2019/4/1.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Alamofire

public typealias ParametersHandle = (Parameters) -> Parameters
public typealias HeaderHandle = (Parameters, HTTPHeaders) -> HTTPHeaders

public protocol NetworkManager {
    
    var headerHandle: HeaderHandle? { get set }
    var parametersHandle: ParametersHandle? { get set}
}

extension NetworkManager {
    
    public func request<T: DataRequestAPI>(api: T, completion: @escaping (Result<T.ResultType>) -> Void) -> Alamofire.DataRequest {
        let fullParameters: Parameters = parametersHandle?(api.parameters) ?? api.parameters
        let fullHeaders: HTTPHeaders = headerHandle?(fullParameters, api.headers) ?? api.headers
        
        return Alamofire.request(api.url, method: api.method, parameters: fullParameters, encoding: api.encoding, headers: fullHeaders).responseData { response in
            switch response.result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                completion(api.handle(data: data))
            }
        }
    }
}

extension NetworkManager {
    
    public func upload<T: DataUploadAPI>(api: T, completion: @escaping (Alamofire.Result<T.ResultType>) -> Void) {
        let fullParameters: Parameters = parametersHandle?(api.parameters) ?? api.parameters
        let fullHeaders: HTTPHeaders = headerHandle?(fullParameters, api.headers) ?? api.headers
        
        Alamofire.upload(multipartFormData: { fromData in
            api.handle(fromData: fromData)
        }, to: api.url, method: api.method, headers: fullHeaders) { encodingResult in
            switch encodingResult {
            case .failure(let error):
                completion(.failure(error))
            case .success(let request, _, _):
                request.responseData { response in
                    switch response.result {
                    case let .failure(error):
                        completion(.failure(error))
                    case let .success(data):
                        completion(api.handle(data: data))
                    }
                }
            }
        }
    }
}
