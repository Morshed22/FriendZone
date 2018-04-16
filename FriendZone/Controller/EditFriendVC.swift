//
//  EditFriendVC.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import PKHUD

class EditFriendVC: UIViewController,BindableType {
     // let disposeBag = DisposeBag()
    
    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var viewModel: EditFriendViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func bindViewModel() {
        firstNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.firstname)
            .disposed(by: rx.disposeBag)
        
        lastNameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.lastname)
            .disposed(by: rx.disposeBag)
        
        
        phoneNumberTextField.rx.text
            .orEmpty
            .bind(to: viewModel.phonenumber)
            .disposed(by: rx.disposeBag)
        
        viewModel.isRunning.subscribe(onNext: { status in
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            status ? PKHUD.sharedHUD.show() : PKHUD.sharedHUD.hide()
        }).disposed(by: rx.disposeBag)
        
        viewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        
        
      viewModel.isValid.bind(to: submitBtn.rx.isEnabled)
        .disposed(by: rx.disposeBag)

       submitBtn.rx.tap
        .throttle(0.3, latest: false, scheduler: MainScheduler.instance)
        .withLatestFrom(viewModel.params)
        .subscribe(viewModel.onUpdate.inputs)
        .disposed(by: rx.disposeBag)

    }
    
  
}
extension EditFriendVC: SingleButtonDialogPresenter { }
