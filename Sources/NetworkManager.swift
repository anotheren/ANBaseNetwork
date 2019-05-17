//
//  NetworkManager.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2019/4/1.
//  Copyright © 2019 anotheren.com. All rights reserved.
//

import Alamofire

public typealias ParametersHandle = (BaseAPI, Parameters) -> Parameters
public typealias HeadersHandle = (BaseAPI, Parameters, HTTPHeaders) -> HTTPHeaders

public final class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private init() { }
    
    public var timeoutIntervalForRequest: TimeInterval = 10
    public var timeoutIntervalForResource: TimeInterval = 10
    
    public private(set) lazy var manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = timeoutIntervalForResource
        return SessionManager(configuration: configuration)
    }()
    
    public var headersHandle: HeadersHandle = { (api, params, headers) in
        return headers
    }
    
    public var parametersHandle: ParametersHandle = { api, params -> Parameters in
        return params
    }
}

extension NetworkManager {
    
    public func request<T: DataRequestAPI>(api: T, completion: @escaping (Result<T.ResultType>) -> Void) -> Alamofire.DataRequest {
        let fullParameters: Parameters = parametersHandle(api, api.parameters)
        let fullHeaders: HTTPHeaders = headersHandle(api, fullParameters, api.headers)
        
        return manager.request(api.url, method: api.method, parameters: fullParameters, encoding: api.encoding, headers: fullHeaders).responseData { response in
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
        let fullParameters: Parameters = parametersHandle(api, api.parameters)
        let fullHeaders: HTTPHeaders = headersHandle(api, fullParameters, api.headers)
        
        manager.upload(multipartFormData: { fromData in
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
