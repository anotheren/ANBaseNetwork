//
//  DataUploadAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/12/27.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire

public protocol DataUploadAPI: BaseAPI {
    
    associatedtype ResultType
    
    func handle(fromData: Alamofire.MultipartFormData)
    
    func handle(data: Data) -> Alamofire.Result<ResultType>
}

public func upload<T: DataUploadAPI>(api: T, completion: @escaping (Alamofire.Result<T.ResultType>) -> Void) {
    Alamofire.upload(multipartFormData: { fromData in
        api.handle(fromData: fromData)
    }, to: api.url, method: api.method, headers: api.headers) { encodingResult in
        switch encodingResult {
        case .failure(let error):
            completion(.failure(error))
        case .success(let request, _, _):
            request.responseData { response in
                switch response.result {
                case let .failure(error):
                    completion(Result.failure(error))
                case let .success(data):
                    completion(api.handle(data: data))
                }
            }
        }
    }
}