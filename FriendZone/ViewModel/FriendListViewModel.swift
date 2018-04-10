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

protocol FriendListModeling{
   // var cellModels: Observable<[FriendCellViewModel]> { get }
   // var cellModels2: Observable<[FriendCellViewModel]> { get }
}

enum FriendTableViewCellType {
//    var id :Int{
//        return 0
//    }
    case normal(cellViewModel: FriendCellViewModel)
    case error(message: String)
    case empty
}

//extension FriendTableViewCellType:IdentifiableType{
//    var identity: Int {
//        return self.id
//    }
//    typealias Identity = Int
//
//}
//func ==(lhs: FriendTableViewCellType, rhs: FriendTableViewCellType) -> Bool {
//    return lhs.id == rhs.id
//}


//typealias SectionModel =  AnimatableSectionModel<String, [FriendTableViewCellType]>

struct FriendListViewModel:FriendListModeling{
    
    
    
   // var cellModels: Observable<[FriendCellViewModel]>
    var cellModels2: Observable<[FriendTableViewCellType]>
    
    let coordinator: SceneCoordinatorType
    let friendService:FriendService
    
    init( coordinator: SceneCoordinatorType, friendService:FriendService) {
          self.coordinator = coordinator
          self.friendService = friendService
        
        let friendItems  = friendService.getFriendList(url:"http://friendservice.herokuapp.com/listFriends")
            .startWith([])
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
        
        
        cellModels2 = friendItems.filter{ frnd in
            return frnd.count > 0
        }.flatMapLatest{friends  in
                                return Observable.just(
                                    friends.compactMap{FriendTableViewCellType.normal(cellViewModel: $0 as FriendCellViewModel)})}
        
       
        

        cellModels2 = friendItems.catchErrorJustReturn([]).flatMapLatest{ _ in
            return Observable.just([FriendTableViewCellType.error(message: "not connected")])
        }
        
        cellModels2 =  friendItems.ifEmpty(default: [])
            .flatMapLatest{ _  in  return Observable.just([.empty])}
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
