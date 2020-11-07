//
//  LoadingResult.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 27.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import Foundation

/// When some data is requested first data retrieved from database is returned with `status == .loading`,  and later, when response from
/// network  is received`.success` or `.error` is returned.
enum LoadingStatus {
    /// Success when downloading data. There will be no further invocations of completion block associated with current request.
    case success
    /// Data is downloading from network. This status is returned along with data or error from persistence storage (database).
    /// Completion block will be invoked one more time later.
    case loading
    /// Error when downloading data. There will be no further invocations of completion block associated with current request.
    case error
}

struct LoadingResult<Success, Failure> where Failure: Error {
    var status: LoadingStatus
    var data: Success?
    var error: Failure?
    
    static func loading(_ data: Success?, _ error: Failure?) -> Self {
        Self(status: .loading, data: data, error: error)
    }
    
    static func success(_ data: Success) -> Self {
        Self(status: .success, data: data, error: nil)
    }
    
    static func failure(_ data: Success?, _ error: Failure?) -> Self {
        Self(status: .error, data: data, error: error)
    }
}
