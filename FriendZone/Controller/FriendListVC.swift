//
//  ViewController.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Action
import NSObject_Rx
import PKHUD

class FriendListVC: UIViewController,BindableType {
   
    @IBOutlet weak var addFriendBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FriendListViewModel!
    var dataSource:RxTableViewSectionedAnimatedDataSource<FriendSectionModel>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   func configureCell(){
   
    dataSource = RxTableViewSectionedAnimatedDataSource<FriendSectionModel>(configureCell: {
        dataSource, tableView, indexPath, itemType in
        
        switch itemType {
            
        case .normal(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as? FriendCell else {
                return UITableViewCell()
            }
            cell.viewModel = viewModel
            return cell
        case .error(let message):
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = message
            return cell
        case .empty:
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = "No data available"
            return cell
        }
    })

}
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func bindViewModel(){
        
        addFriendBtn.rx.action = viewModel.onCreateFriend()
 
        guard let dataSource = dataSource else {
            return
        }
        
        viewModel.cellModel
            .bind(to: tableView.rx.items(dataSource: dataSource))
            
            .disposed(by: rx.disposeBag)
        
        
        viewModel.isRunning.subscribe(onNext: { [weak self] status in
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            status ? PKHUD.sharedHUD.show(onView: self?.view) : PKHUD.sharedHUD.hide()
            self?.addFriendBtn.isEnabled = !status
        }).disposed(by: rx.disposeBag)
        

}


}

