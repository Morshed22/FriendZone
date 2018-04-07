//
//  FriendService.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

struct FriendService:FriendServiceType {
   
    
    init() {
        
    }
    
    func postFriendRequest(url:String,params:[String:Any]?)->Observable<JSON> {
        
      return Observable.create() { observer in
          
            Alamofire.request(url, method:.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                
                switch response.result{
                case .success(let value):
                   let json = JSON(value)
                       observer.onNext(json)
                       observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            })
        return Disposables.create()
            
    }
    }
    
    @discardableResult
    func createFriend(url:String, params:[String:Any]) -> Observable<Friend?> {
     return postFriendRequest(url:url, params:params ).map{
            Friend(json: $0)
        }.catchError{ error in
             Observable.just(nil)
        }
        
    }
//    @discardableResult
//    func delete(task: Friend) -> Observable<Void> {
//        
//    }
//    
//    @discardableResult
//    func update(task: Friend) -> Observable<Friend> {
//        
//    }
    
    
    
}
