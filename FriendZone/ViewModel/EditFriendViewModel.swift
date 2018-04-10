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
    //    var showLoadingHud: Bindable<Bool> { get }
    //
    //    var updateSubmitButtonState: ((Bool) -> ())? { get set }
    //    var navigateBack: (() -> ())?  { get set }
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?  { get set }
    
    
}
class EditFriendViewModel:FriendViewModel{
    
    
    var firstname = BehaviorSubject<String>(value: "")
    var lastname = BehaviorSubject<String>(value: "")
    var phonenumber = BehaviorSubject<String>(value: "")
    
    var title: String {
        return "Add Friend"
    }
    
    var onShowError: ((SingleButtonAlert) -> Void)?
    var isRunning: Observable<Bool>
    let isValid: Observable<Bool>
    let params: Observable<[String:Any]>
    let onUpdate: Action<[String:Any], JSON>
    
    let disposeBag = DisposeBag()
    
    init( coordinator: SceneCoordinatorType, friendService:FriendService) {
        
        let allInputs = Observable.combineLatest(self.firstname.asObservable(), self.lastname.asObservable(), self.phonenumber.asObservable())
        { (firstname, lastname,phonenumber) in return (firstname, lastname,phonenumber)}
        
        
        
        params = allInputs.map{ (firstname, lastname,phonenumber) in
            return ["firstname":firstname,
                    "lastname":lastname,
                    "phonenumber":phonenumber]
        }
        
        isValid =  allInputs.map{(firstname, lastname,phonenumber) in return firstname.count > 0
            && lastname.count > 0 && phonenumber.count > 0}
        
        
        let activityIndicator = ActivityIndicator()
        isRunning = activityIndicator.asObservable()
        
        
        
        onUpdate = Action{ input in
            return friendService.createFriend(url: "https://friendservice.herokuapp.com/addFriend", params: input ).trackActivity(activityIndicator)
                .map{$0}.share()
        }
        
        
        
        
        onUpdate.executionObservables.map {  item in
            item.do(onNext: { json in
                print(json)
            }, onError: { err in
                print(err)
            })
            }.subscribe()
            .disposed(by: disposeBag)
        
        onUpdate.executionObservables.subscribe(onNext: { item in
            item.subscribe(onNext: { josn in
                // coordinator.pop()
                // print(josn)
            }, onError: { err in
                let alert = SingleButtonAlert(title: "Error", message: err.localizedDescription, action: AlertAction(buttonTitle: "OK", handler: CocoaAction{ _ in return Observable.empty()
                }))
                self.onShowError!(alert)
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
        //        onUpdate.executionObservables
        //       .take(1).debug()
        //            .subscribe(onNext: { json in json.subscribe(onNext: { value in
        //                print(value)
        //            }).disposed(by: self.disposeBag)
        //
        //         // coordinator.pop()
        //        })
        //        .disposed(by: disposeBag)
        
    }
    
    
    
}
