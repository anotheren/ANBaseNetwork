//
//  JSONUploadAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/12/27.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol JSONUploadAPI: BaseAPI {
    
    associatedtype ResultType
    
    var multipartFormData: ((Alamofire.MultipartFormData) -> Void) { get }
    
    func handle(json: JSON) -> Alamofire.Result<ResultType>
}

public func upload<T: JSONUploadAPI>(api: T, completion: @escaping (Alamofire.Result<T.ResultType>) -> Void) {
    Alamofire.upload(multipartFormData: api.multipartFormData, to: api.url, method: api.method, headers: api.headers, encodingCompletion: { encodingResult in
        switch encodingResult {
        case .failure(let error):
            completion(.failure(error))
        case .success(let request, _, _):
            request.responseJSON(completionHandler: { response in
                switch response.result {
                case let .failure(error):
                    completion(Result.failure(error))
                case let .success(object):
                    let json = JSON(object)
                    completion(api.handle(json: json))
                }
            })
        }
    })
}
