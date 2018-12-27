//
//  UploadAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/12/27.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire

public protocol UploadAPI: BaseAPI {
    
    associatedtype ResultType
    
    var multipartFormData: ((Alamofire.MultipartFormData) -> Void) { get }
    
    var uploadProcess: ((Progress) -> Void)? { get }
    
    func handle(data: Data) -> Alamofire.Result<ResultType>
}

extension UploadAPI {
    
    public var uploadProcess: ((Progress) -> Void)? {
        return nil
    }
}

public func upload<T: UploadAPI>(api: T, completion: @escaping (Alamofire.Result<T.ResultType>) -> Void) {
    Alamofire.upload(multipartFormData: api.multipartFormData, to: api.url, method: api.method, headers: api.headers, encodingCompletion: { encodingResult in
        switch encodingResult {
        case .failure(let error):
            completion(.failure(error))
        case .success(let request, _, _):
            request.uploadProgress(closure: { process in
                api.uploadProcess?(process)
            })
            request.responseData(completionHandler: { response in
                switch response.result {
                case .failure(let error):
                    completion(Result.failure(error))
                case .success(let data):
                    completion(api.handle(data: data))
                }
            })
        }
    })
}
