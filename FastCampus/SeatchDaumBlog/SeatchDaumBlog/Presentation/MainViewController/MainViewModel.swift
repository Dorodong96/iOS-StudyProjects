//
//  MainViewModel.swift
//  SeatchDaumBlog
//
//  Created by DongKyu Kim on 2022/11/02.
//

import RxSwift
import RxCocoa
import Foundation

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog) // 메소드의 파라미터와 클로저 파라미터 동일 -> 바로 축약해서 사용 가능
            .share() // 공유데이터
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult // Error를 뱉긴 뱉지만 String을 뱉겠다
            .compactMap(model.getBlogError)

        
        // 네트워크를 통해 가져온 값을 cellData로 전환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        // FilterView를 선택했을 때 나오는 alertsheet를 선택했을 때의 type
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false // sorting type에 따라 tableview 데이터를 다르게 주기
                }
            }
            .startWith(.title)
        
        // MainViewController -> ListView로 데이터 전달
        Observable
            .combineLatest(sortedType, cellData, resultSelector: model.sort)
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil , message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (title: "앗!", message: "예상치 못한 오류가 발생했습니다. 잠시후 다시 시도해주세요. \(message)", actions: [.confirm], style: .alert)
            }
        
        self.shouldPresentAlert = Observable
            .merge(alertSheetForSorting, alertForErrorMessage)
            .asSignal(onErrorSignalWith: .empty())
    }
}
