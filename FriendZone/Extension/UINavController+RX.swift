//
//  UINavController+RX.swift
//  FriendZone
//
//  Created by Morshed Alam on 14/4/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxNavigationControllerDelegateProxy: DelegateProxy<AnyObject, Any>, DelegateProxyType, UINavigationControllerDelegate {
    
    static func registerKnownImplementations() {
        
    }
    
    static func currentDelegate(for object: AnyObject) -> Any? {
        guard let navigationController = object as? UINavigationController else {
            fatalError()
        }
        return navigationController.delegate
    }
    
    static func setCurrentDelegate(_ delegate: Any?, to object: AnyObject) {
 
        guard let navigationController = object as? UINavigationController else {
            fatalError()
        }
        if delegate == nil {
            navigationController.delegate = nil
        } else {
            guard let delegate = delegate as? UINavigationControllerDelegate else {
                fatalError()
            }
            navigationController.delegate = delegate
        }
    }
}

extension Reactive where Base: UINavigationController {
    /**
     Reactive wrapper for `delegate`.
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var delegate: DelegateProxy<AnyObject, Any> {
        return RxNavigationControllerDelegateProxy.proxy(for: base)
    }
}

