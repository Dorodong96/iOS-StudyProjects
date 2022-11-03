//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by DongKyu Kim on 2022/11/03.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel {
    // ViewModel -> View
    let showFreeShareButton: Signal<Bool>
    let resetPrice: Signal<Void>
    
    // View -> ViewModel
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init() {
        self.showFreeShareButton = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0" }, // 가격 입력이 없거나 0인 경우
                freeShareButtonTapped.map { _ in false } // 버튼이 눌렸을 때 -> 버튼이 더이상 보이게 X
            )
            .asSignal(onErrorJustReturn: false)
        
        // 무료 나눔이 선택 되면 그냥 price 리셋
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}
