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
    var isRunning: Observable<Bool>{  get }
    var onShowError:PublishSubject<SingleButtonAlert>{ get}
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
    let disposeBag = DisposeBag()
    var onShowError =  PublishSubject<SingleButtonAlert>()
    var isRunning: Observable<Bool>{
       return activityIndicator.asObservable()
    }
    let activityIndicator = ActivityIndicator()
    let coordinator: SceneCoordinatorType
    let friendService:FriendService
    private let subject = BehaviorSubject<[FriendSectionModel]>(value:[FriendSectionModel(model: 0, items: [.empty])])
    
    var cellModel: Observable<[FriendSectionModel]>{
        return  self.getFriendList().flatMapLatest{ _  in
            self.subject.asObservable()
        }
    }

    init( coordinator: SceneCoordinatorType, friendService:FriendService) {
          self.coordinator = coordinator
          self.friendService = friendService
 
    }

   private func getFriendList() -> Observable<Void>{

      return friendService.getFriendList(url:"http://friendservice.herokuapp.com/listFriends").debug()
            .observeOn(MainScheduler.instance)
            .trackActivity(activityIndicator)
            .share(replay: 1)
            .map{ result in
        switch result{
             case .success(let friends):
                if friends.count > 0{
                    let element = friends.compactMap{FriendTableViewCellType.normal(cellViewModel: $0 as FriendCellViewModel)}
                    let sectionModel = [FriendSectionModel(model: 0, items: element)]
                    self.subject.onNext(sectionModel)

                }else {
                    self.subject.onNext([FriendSectionModel(model: 0, items: [.empty])])
                }

            case .failure(let error):
                let errorElement = [FriendTableViewCellType.error(message: error.description)]
                self.subject.onNext([FriendSectionModel(model: 0, items: errorElement)])

            }
            }


    }

  
    
lazy var deleteFriend:Action<Int, Void> = { (this) in
   
    return  Action{  index in
        
        let value = try! this.subject.value()
        let friensCells = value.flatMap{$0.items}

        switch friensCells[index] {
            case .normal(let cellViewModel):
               return this.friendService.deleteFriend(id:cellViewModel.friendItem.id)
                .observeOn(MainScheduler.instance)
                   .share(replay: 1).debug()
                  .map{ result in
                    switch result {
                    case .success:
                        this.getFriendList().subscribe().disposed(by: this.disposeBag)
                    case .failure(let error):
                        let alert = SingleButtonAlert(title: "Error", message: error.description, action: AlertAction(buttonTitle: "OK", handler: CocoaAction{ _ in return Observable.empty()}))
                        this.onShowError.onNext(alert)
                    }
            }
         case .error,.empty :
            return .empty()
        }
    }
}(self)


    
    
    
 func onCreateFriend() -> CocoaAction {
        return CocoaAction{ _ in
            let editModel = EditFriendViewModel(coordinator: self.coordinator, friendService: self.friendService, navigate: self.updateData())
            let editScene = Scene.editFriend(editModel)
            return  self.coordinator.transition(to: editScene, type: .push)
        }
    }
    
  private func updateData()->CocoaAction{
        return CocoaAction { _ in
            return self.getFriendList()
        }
    }
}
