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
    
    func handle(fromData: MultipartFormData)
    func handle(data: Data) -> Result<ResultType, Error>
}

@discardableResult
public func upload<T: DataUploadAPI>(api: T, completion: @escaping (Result<T.ResultType, Error>) -> Void) -> UploadRequest {
    return NetworkManager.shared.upload(api: api, completion: completion)
}
