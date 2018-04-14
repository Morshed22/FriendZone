//
//  VC+Extension.swift
//  FriendZone
//
//  Created by Morshed Alam on 7/4/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import Action

protocol SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert)
}

extension SingleButtonDialogPresenter where Self: UIViewController {
    
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        
        var  ok = UIAlertAction.Action(alert.action.buttonTitle, style: .default)
          ok.rx.action = alert.action.handler
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
}
