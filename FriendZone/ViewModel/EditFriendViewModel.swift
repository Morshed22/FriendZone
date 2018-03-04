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
struct EditFriendViewModel:FriendViewModel{
    

    var firstname = Variable<String>("")
    var lastname = Variable<String>("")
    var phonenumber = Variable<String>("")
    var title: String {
        return "Add Friend"
    }
    
    let isValid: Observable<Bool>
    let onUpdate: Action<[String:Any], Void>
    
    let disposeBag = DisposeBag()
    
    init( coordinator: SceneCoordinatorType, updateAction: Action<[String:Any], Void>) {
        
        isValid = Observable.combineLatest(self.firstname.asObservable(), self.lastname.asObservable(), self.phonenumber.asObservable())
        { (firstname, lastname,phonenumber) in
            return firstname.count > 0
                && lastname.count > 0 && phonenumber.count > 0
        }
        
       onUpdate = updateAction
        
       onUpdate.executionObservables
        .take(1)
        .subscribe(onNext: { _ in
        coordinator.pop()
        })
        .disposed(by: disposeBag)

    }
    
   
    
    
    
    
}
