//
//  DetailWriteFormCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by DongKyu Kim on 2022/11/03.
//

import RxSwift
import RxCocoa


struct DetailWriteFormCellViewModel {
    // View -> ViewModel
    let contentValue = PublishRelay<String?>()
}
