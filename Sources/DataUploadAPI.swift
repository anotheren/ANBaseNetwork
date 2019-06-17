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

public func upload<T: DataUploadAPI>(api: T,
                                     requestHandle: ((UploadRequest) -> Void)? = nil,
                                     completion: @escaping (Alamofire.Result<T.ResultType>) -> Void) {
    NetworkManager.shared.upload(api: api, requestHandle: requestHandle, completion: completion)
}
