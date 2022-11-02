//
//  SearchBarViewModel.swift
//  SeatchDaumBlog
//
//  Created by DongKyu Kim on 2022/11/02.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    let queryText = PublishRelay<String?>()
    // SearchBar 버튼 탭 이벤트, onNext만 가지고 에러를 반환하지 않음
    let searchButtonTapped = PublishRelay<Void>()
    // SearchBar 외부로 내보낼 이벤트
    let shouldLoadResult: Observable<String>
    
    init() {
        // 2. search bar에 입력되어 있는 텍스트를 외부에 연결해줘야 함
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" } // 해당 텍스트가 없다면 빈 값을 보냄
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
    }
}
