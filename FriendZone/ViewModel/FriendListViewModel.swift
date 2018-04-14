//
//  FriendListViewModel.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//


import RxSwift
import RxDataSources
import Action


typealias FriendSectionModel = AnimatableSectionModel<Int, FriendTableViewCellType>

protocol FriendListModeling{
    var cellModel: Observable<[FriendSectionModel]> { get }
    var isRunning: Observable<Bool>{ get set }
}

enum FriendTableViewCellType{
    
    case normal(cellViewModel: FriendCellViewModel)
    case error(message: String)
    case empty
}


extension FriendTableViewCellType:IdentifiableType,Equatable{
    
    static func == (lhs: FriendTableViewCellType, rhs: FriendTableViewCellType) -> Bool {
          return lhs.identity == rhs.identity
    }
    
    
    
    var identity: Int {
        switch self {
        case .normal(let model):
            return model.friendItem.id
        case .error, .empty:
            return 0
        }
    }
    
    typealias Identity = Int

}


struct FriendListViewModel:FriendListModeling{
    var isRunning: Observable<Bool>
    var cellModel: Observable<[FriendSectionModel]>
    
    let coordinator: SceneCoordinatorType
    let friendService:FriendService
    
    init( coordinator: SceneCoordinatorType, friendService:FriendService) {
          self.coordinator = coordinator
          self.friendService = friendService
        
       
        
        let friendItems  = friendService.getFriendList(url:"http://friendservice.herokuapp.com/listFriends")
            .startWith(.success(payload: []))
            .observeOn(MainScheduler.instance)
            .share(replay: 1)

        let activityIndicator = ActivityIndicator()
        isRunning = activityIndicator.asObservable()
        
        cellModel = friendItems.map{ result in
            switch result{
            case .success(let friends):
                if friends.count > 0{
                    return friends.compactMap{FriendTableViewCellType.normal(cellViewModel: $0 as FriendCellViewModel)}
                }else {
                   return [.empty]
                }
                
            case .failure(let error):
                return [FriendTableViewCellType.error(message: error.description)]
            }
            }.flatMapLatest{ cell in return Observable.just([FriendSectionModel(model: 0, items: cell)])
                
            }.trackActivity(activityIndicator)
            
        
        
//        
//        cellModels2 = friendItems.filter{ frnd in
//            return frnd.count > 0
//        }.flatMapLatest{friends  in
//                                return Observable.just(
//                                    friends.compactMap{FriendTableViewCellType.normal(cellViewModel: $0 as FriendCellViewModel)})}
//        
//       
//        
//
//        cellModels2 = friendItems.catchErrorJustReturn([]).flatMapLatest{ _ in
//            return Observable.just([FriendTableViewCellType.error(message: "not connected")])
//        }
//        
//        cellModels2 =  friendItems.ifEmpty(default: [])
      //      .flatMapLatest{ _  in  return Observable.just([.empty])}
//        .flatMapLatest{friends  in
//                    return Observable.just(
//                        friends.compactMap{FriendTableViewCellType.normal(cellViewModel: $0 as FriendCellViewModel)})}
     //   .ifEmpty(switchTo: Observable.just([FriendTableViewCellType.empty]))
//        .catchError{ error in
//            return Observable.just([FriendTableViewCellType.error(message: error.localizedDescription)])
//        }
        
      
        
//                cellModels = friendItems.map{ friendArray  in
//                        friendArray.map{ $0 as FriendCellViewModel}
//                   }
        
    }


}
