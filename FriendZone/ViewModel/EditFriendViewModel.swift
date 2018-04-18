//
//  EditFriendViewModel.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import Foundation
import RxSwift
import Action
import SwiftyJSON


protocol FriendViewModel {
    
    var title: String { get }
    var firstname :  BehaviorSubject<String> {get set}
    var lastname :BehaviorSubject<String> {get set}
    var phonenumber : BehaviorSubject<String>{get set}
    var isRunning:Observable<Bool>{get}
    var inputParameter:Observable<[String:Any]>{get}
    var onShowError: Observable<SingleButtonAlert>{get}
    var onUpdate: Action<[String:Any], JSON>{get}
    var isValid:Observable<Bool>{get}
    
    
}
struct AddFriendViewModel:FriendViewModel{
    
    
    
    
    var firstname = BehaviorSubject<String>(value:"")
    var lastname = BehaviorSubject<String>(value:"")
    var phonenumber = BehaviorSubject<String>(value:"")
    var inputParameter: Observable<[String : Any]>
    var onShowError: Observable<SingleButtonAlert>
    
    var title: String {
        return "Add Friend"
    }
    var isValid: Observable<Bool>
    var isRunning: Observable<Bool>
    var onUpdate: Action<[String:Any], JSON>
    
    
    
    init( coordinator: SceneCoordinatorType, friendService:FriendService, navigate:CocoaAction) {
        let disposeBag = DisposeBag()
        
        let allInputs = Observable.combineLatest(self.firstname.asObservable(), self.lastname.asObservable(), self.phonenumber.asObservable())
        { (firstname, lastname,phonenumber) in return (firstname, lastname,phonenumber)}
        
        
        
        inputParameter = allInputs.map{ (firstname, lastname,phonenumber) in
            return ["firstname":firstname,
                    "lastname":lastname,
                    "phonenumber":phonenumber]
        }
        
        isValid =  allInputs.map{(firstname, lastname,phonenumber) in return firstname.count > 0
            && lastname.count > 0 && phonenumber.count > 0}
        
        
        let activityIndicator = ActivityIndicator()
        isRunning = activityIndicator.asObservable()
        
        let getError = PublishSubject<SingleButtonAlert>()
        onShowError = getError.asObservable()
        
        onUpdate = Action{ input in
            return friendService.createFriend(url: "https://friendservice.herokuapp.com/addFriend", params: input ).trackActivity(activityIndicator)
                .map{$0}.share()
        }
        
        
        
        onUpdate.executionObservables.map { items  in
            items.subscribe(onNext: {  josn in
                 print(josn)
                navigate.execute(())
                 coordinator.pop()
            }, onError: { err in
                let error = APIError(error: err)
                let alert = SingleButtonAlert(title: "Error", message: error.description, action: AlertAction(buttonTitle: "OK", handler: CocoaAction{ _ in return Observable.empty()
                }))
                getError.onNext(alert)
               
            }).disposed(by: disposeBag)
        }.subscribe().disposed(by: disposeBag)

    }
}
