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
    var firstname :  Variable<String> {get set}
    var lastname :Variable<String> {get set}
    var phonenumber : Variable<String>{get set}
//    var showLoadingHud: Bindable<Bool> { get }
//
//    var updateSubmitButtonState: ((Bool) -> ())? { get set }
//    var navigateBack: (() -> ())?  { get set }
//    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?  { get set }
    
   
}
class EditFriendViewModel:FriendViewModel{
    

    var firstname = Variable<String>("")
    var lastname = Variable<String>("")
    var phonenumber = Variable<String>("")
    var title: String {
        return "Add Friend"
    }
    
    let isValid: Observable<Bool>
    let params: Observable<[String:Any]>
    
    let onUpdate: Action<[String:Any], JSON>
    //let action :Action<Observable<(String,String, String)>, JSON>
    
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

//        onUpdate = Action(enabledIf: isValid, workFactory: {  input in
//
//            return friendService.postFriendRequest(url: "https://friendservice.herokuapp.com/addFriend", params: input ).map{$0}
//        })
//
        onUpdate = Action{ input in
            return friendService.postFriendRequest(url: "https://friendservice.herokuapp.com/addFriend", params: input ).map{$0}
        }


        onUpdate.elements
            .subscribe(onNext: { json in
                print("json")
            print(json.description)
        }).disposed(by: disposeBag)

        onUpdate.errors.subscribe({ err in
            print(err.debugDescription)
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
