//
//  Result.swift
//  FriendZone
//
//  Created by Morshed Alam on 7/4/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U> where U: Error {
    case success
    case failure(U?)
}
