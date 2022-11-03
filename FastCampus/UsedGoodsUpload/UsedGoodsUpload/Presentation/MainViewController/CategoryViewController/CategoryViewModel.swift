//
//  CategoryViewModel.swift
//  UsedGoodsUpload
//
//  Created by DongKyu Kim on 2022/11/03.
//

import RxSwift
import RxCocoa

struct CategoryViewModel {
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let cellData: Driver<[Category]> // 카테고리를 나타낼 cell data를 뷰에 전달
    let pop: Signal<Void> // Pop 이벤트를 읽어야 함
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>() // 선택된 카테고리 row 값
    
    // ViewModel -> ParentViewModel
    let selectedCategory = PublishSubject<Category>() // 다른 뷰가 받아서 해당 카테고리를 표현할 수 있도록 전달
    
    init() {
        let categories = [
            Category(id: 1, name: "디지털/가전"),
            Category(id: 2, name: "게임"),
            Category(id: 3, name: "스포츠/레저"),
            Category(id: 4, name: "유아/아동용품"),
            Category(id: 5, name: "여성패선/잡화"),
            Category(id: 6, name: "뷰티/미용"),
            Category(id: 7, name: "남성패션/잡화"),
            Category(id: 8, name: "생활/식품"),
            Category(id: 9, name: "가구"),
            Category(id: 10, name: "도서/티켓/취미"),
            Category(id: 11, name: "기타"),
        ]
        self.cellData = Driver.just(categories) // cell data의 driver로 전달
        
        self.itemSelected
            .map { categories[$0] } // 전달하고자 하는 카테고리 추출
            .bind(to: selectedCategory) // 해당 카테고리가 selectedCategory로 전달
            .disposed(by: disposeBag)
        
        self.pop = itemSelected // 아이템이 선택이 되었을 때
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty()) // pop이라는 signal을 뷰가 받아서 pop 액션을 취함
    }
}
