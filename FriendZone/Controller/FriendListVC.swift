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

class FriendListVC: UIViewController,BindableType {
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: FriendListViewModel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func bindViewModel(){
        
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,FriendTableViewCellType>>.init(configureCell: { (Section, tableView, indexpath, celltype) -> UITableViewCell in
            
            switch celltype {
                
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
        
        
        
        viewModel.cellModels2.debug()
        .flatMapLatest {  cell in
            return Observable.just([SectionModel(model: "title", items: cell)])
        }.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: rx.disposeBag)
        //viewModel.cellModels2.bind(to: tableView.rx.items(dataSource: dataSource))
}
    
//    func bindViewModel() {
//
//
//
//
//
//        viewModel.cellModels
//            .bind(to: tableView.rx.items(cellIdentifier: "FriendCell", cellType: FriendCell.self)){ i, cellModel, cell in
//               cell.viewModel = cellModel
//        }.disposed(by: rx.disposeBag)
//    }

}

