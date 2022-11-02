//
//  FilterViewModel.swift
//  SeatchDaumBlog
//
//  Created by DongKyu Kim on 2022/11/02.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    // filterView 외부에서 관찰했을 때 event를 발생할 publish
    let sortButtonTapped = PublishRelay<Void>()
}
