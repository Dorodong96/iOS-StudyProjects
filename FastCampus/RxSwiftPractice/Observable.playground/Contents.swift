import Foundation
import RxSwift

print("---Just---")
Observable<Int>.just(1) // 하나의 element만 방출하는 연산자
    .subscribe(onNext: {
        print($0)
    })

print("---Of1---")
Observable<Int>.of(1, 2, 3, 4, 5) // 하나 이상의 element 넣을 수 있음, 각각의 element 방출

print("---Of2---")
Observable.of([1, 2, 3, 4, 5]) // 타입 추론을 통해서 Observable Sequence 생성, 하나의 Array를 방출

print("---From---")
Observable.from([1, 2, 3, 4, 5]) // Array 형태의 element만 받아서 자동적으로 하나의 element씩 방출
