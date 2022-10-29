import Foundation
import RxSwift

print("---Just---")
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("---Of1---")
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })

print("---Of2---")
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

print("---From---")
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext:  {
        print($0)
    })
