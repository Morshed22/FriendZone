//
//  FriendServiceType.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON


protocol FriendServiceType {
    
    @discardableResult
    func createFriend(url:String, params:[String:Any]) -> Observable<JSON>
    
    @discardableResult
    func getFriendList(url:String) -> Observable<Result<[Friend], APIError>>
    
    @discardableResult
    func deleteFriend(id:Int)-> Observable<Result<Void, APIError>>
    
//    
//    @discardableResult
//    func delete(task: Friend) -> Observable<Void>
//    
//    @discardableResult
//    func update(task: Friend) -> Observable<Friend>
    
}
