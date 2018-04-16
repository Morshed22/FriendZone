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
    
    
   
    private let queue = DispatchQueue(label: "Friend.FriendService.Queue")
    
    init() {
        
    }
    
    func createFriend(url: String, params: [String : Any]) -> Observable<JSON> {
        return Observable.create() { observer in
            
          let request =   Alamofire.request(url, method:.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in
                
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    observer.onNext(json)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create(with: {
                request.cancel()
            })
            
        }
    }

    func getFriendList(url: String) -> Observable<Result<[Friend], APIError>> {
         return Observable.create() { observer in
        let request =  Alamofire.request(url)
            .validate(statusCode: 200 ..< 300)
            .responseJSON(queue: self.queue) { response in
                switch response.result {
                case .success(let value):
                    guard let jsonArray = JSON(value).array   else {
                        observer.onError(APIError.IncorrectDataReturned)
                        return
                    }
                    let friendArray = jsonArray.compactMap{Friend(json: $0)}
                    
                    observer.onNext(.success(payload: friendArray))
                    
                   // observer.onNext(friendArray)
                   // observer.onCompleted()
                case .failure(let error):
                  //observer.onError(APIError(error: error))
                   observer.onNext(.failure(APIError(error: error)))
                }
            observer.onCompleted()
            }
            return Disposables.create(with: {
                request.cancel()
            })
            
        }
            
            
    }
    
   
    func deleteFriend(id: Int) -> Observable<Result<Void, APIError>> {
        return Observable.create() { observer in
            
            let request = Alamofire
                .request("https://friendservice.herokuapp.com/editFriend/\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default)
                .validate(statusCode: 200 ..< 300)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        observer.onNext(.success(payload: ()))
                    case .failure(let error):
                        observer.onNext(.failure(APIError(error: error)))
                    }
                    observer.onCompleted()
            }
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
    
    
    
}

enum Result<T, U> where U: Error {
    case success(payload: T)
    case failure(U)
}
