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

class EditFriendVC: UIViewController,BindableType {
      let disposeBag = DisposeBag()
    
    @IBOutlet weak var firstNameTextField: UITextField!

    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    var viewModel: EditFriendViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureAllTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureAllTextField(){
       
        
//        let valids = [firstNameTextField, lastNameTextField, phoneNumberTextField].map {field in
//            field?.rx.text.map({ _ in return (field?.text ?? "").count > 0 })
//        }
//
//       let everythingValid = Observable.combineLatest(valids)
//          { iterator ->Bool  in
//            iterator.reduce(true, { return $0 && $1 })
//
//        }
        
        let firstNameValid: Observable<Bool> = firstNameTextField.rx.text.orEmpty
            .map{ ($0).count > 0}
            .share(replay: 1)

        let secondNameValid: Observable<Bool> = lastNameTextField.rx.text.orEmpty
            .map{ $0.count > 0
        }.share(replay: 1)

        let phoneNumberValid: Observable<Bool> = phoneNumberTextField.rx.text.orEmpty
            .map{ $0.count > 0
        }.share(replay: 1)

        let everythingValid = Observable.combineLatest(firstNameValid, secondNameValid, phoneNumberValid) { $0 && $1 && $2}
            .share(replay: 1)
        

        everythingValid
            .bind(to: submitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
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
        
    }
}
