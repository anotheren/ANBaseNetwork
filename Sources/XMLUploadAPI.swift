//
//  XMLUploadAPI.swift
//  ANBaseNetwork
//
//  Created by 刘栋 on 2018/12/27.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

public protocol XMLUploadAPI: BaseAPI {
    
    associatedtype ResultType
    
    var multipartFormData: ((Alamofire.MultipartFormData) -> Void) { get }
    
    func handle(xml: XMLIndexer) -> Alamofire.Result<ResultType>
}

public func upload<T: XMLUploadAPI>(api: T, completion: @escaping (Alamofire.Result<T.ResultType>) -> Void) {
    Alamofire.upload(multipartFormData: api.multipartFormData, to: api.url, method: api.method, headers: api.headers, encodingCompletion: { encodingResult in
        switch encodingResult {
        case .failure(let error):
            completion(.failure(error))
        case .success(let request, _, _):
            request.responseData(completionHandler: { response in
                switch response.result {
                case let .failure(error):
                    completion(Result.failure(error))
                case let .success(data):
                    let xml = SWXMLHash.parse(data)
                    completion(api.handle(xml: xml))
                }
            })
        }
    })
}
