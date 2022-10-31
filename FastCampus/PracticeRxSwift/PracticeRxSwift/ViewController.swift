//
//  ViewController.swift
//  PracticeRxSwift
//
//  Created by DongKyu Kim on 2022/10/30.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    enum TraitsError: Error {
        case single
        case maybe
        case completable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
// MARK: Traits 알아보기
        print("----Single1----")
        Single<String>.just("Check")
            .subscribe(
                onSuccess: {
                    print($0)
                },
                onFailure: { // Error를 방출하고 종료
                    print("error: \($0.localizedDescription)")
                },
                onDisposed: {
                    print("disposed")
                }
            )
            .disposed(by: disposeBag)
        
        print("---Single2---")
        Observable<String>.create { observer -> Disposable in
            observer.onError(TraitsError.single)
            return Disposables.create()
        }
        .asSingle()
        .subscribe(
            onSuccess: {
                print($0)
            },
            onFailure: { // Error를 방출하고 종료
                print("error: \($0.localizedDescription)")
            },
            onDisposed: {
                print("disposed")
            }
        )
        .disposed(by: disposeBag)
        
        print("---Single3---")
        
        decode(json: json1)
            .subscribe {
                switch $0 {
                case .success(let json):
                    print(json.name)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        decode(json: json2)
            .subscribe {
                switch $0 {
                case .success(let json):
                    print(json.name)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        print("---Maybe1---")
        Maybe<String>.just("Check")
            .subscribe(onSuccess: {
                print($0)
            }, onError: {
                print($0)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        print("---Maybe2---")
        Observable<String>.create { observer -> Disposable in
            observer.onError(TraitsError.maybe)
            return Disposables.create()
        }
        .asMaybe()
        .subscribe(onSuccess: {
            print("성공 \($0)")
        }, onError: {
            print("에러 \($0)")
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        .disposed(by: disposeBag)
        
        print("---Completable1---")
        Completable.create { observer -> Disposable in
            observer(.error(TraitsError.completable))
            return Disposables.create()
        }
        .subscribe(onCompleted: {
            print("completed")
        }, onError: {
            print("error: \($0)")
        }, onDisposed: {
            print("disposed")
        })
        .disposed(by: disposeBag)
        
        print("---Completable2---")
        Completable.create { observer -> Disposable in
            observer(.completed)
            return Disposables.create()
        }
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        
// MARK: Subject 알아보기
        print("---publishSubject---")
        let publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("1. 여러분 안녕하세요!")
        
        let subscriber1 = publishSubject
            .subscribe(onNext: {
                print($0)
            }) // 자신이 구독을 시작한 이후에 생긴 event에 대해서만 결과 수용
        
        publishSubject.onNext("2. 들리세요?")
        publishSubject.on(.next("3. 안들리시나요?"))
        
        subscriber1.dispose()
        
        let subscriber2 = publishSubject
            .subscribe(onNext: {
                print($0)
            })
        
        publishSubject.onNext("4. 여보세요")
        publishSubject.onCompleted()
        
        publishSubject.onNext("5. 끝났나요")
        
        subscriber2.dispose()
        
        publishSubject
            .subscribe{
                print("세번째 구독:", $0.element ?? $0)
            }
            .disposed(by: disposeBag)
        
        publishSubject.onNext("6. 찍힐까요?") // 이미 completed 된 publish subject
        
        print("---behaviorSubject---")
        enum SubjectError: Error {
            case error1
        }
        
        let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")
        
        behaviorSubject.onNext("1. 첫번째 값")
        
        behaviorSubject.subscribe {
            print("첫번째 구독:", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
        
        behaviorSubject.onError(SubjectError.error1) // 에러를 발생시킴
        
        behaviorSubject.subscribe { // 직전에 발생한 이벤트 구독 (에러 포함)
            print("두번째 구독:", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
        
        // element의 값 뽑아내기
        let value = try? behaviorSubject.value() // 가장 최신의 값을 꺼내줌
        print(value)
        
        print("---replaySubject---")
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        
        replaySubject.onNext("1. 여러분")
        replaySubject.onNext("2. 힘내세요")
        replaySubject.onNext("3. 어렵지만") // bufferSize가 2라서 2.와 3.만 값을 받게 됨
        
        replaySubject.subscribe {
            print("첫번째 구독:", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
        
        replaySubject.subscribe {
            print("두번째 구독:", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
        
        replaySubject.onNext("4. 할 수 있어요")
        replaySubject.onError(SubjectError.error1)
        replaySubject.dispose()
        
        replaySubject.subscribe { // 이미 dispose된 observer를 구독하려 하므로 error
            print("세번째 구독:", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
        
// MARK: Filtering Operator
        print("---ignoreElements---")
        // conflict나 error 같은 정지 이벤트는 감지
        // next Event 무시!
        let sleepMode = PublishSubject<String>()
        
        sleepMode
            .ignoreElements()
            .subscribe { _ in
                print("Wake up")
            }
            .disposed(by: disposeBag)
        
        sleepMode.onNext("Alarm")
        sleepMode.onNext("Alarm")
        sleepMode.onNext("Alarm")
        sleepMode.onCompleted()
        
        
        print("---elementAt---")
        // element at에서 특정 인덱스의 on Next만 방출하겠다.
        let wakeUpPerson = PublishSubject<String>()
        
        wakeUpPerson
            .element(at: 2)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        wakeUpPerson.onNext("WAKE UP!")         // index 0
        wakeUpPerson.onNext("WAKE UP!")         // index 1
        wakeUpPerson.onNext("DID YOU WAKE UP?") // index 2
        wakeUpPerson.onNext("WAKE UP!")         // index 3
        
        
        print("---filter---")
        // 특정 조건에 맞는 onNext만 방출하겠다.
        Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
            .filter { $0 % 2 == 0}
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---skip---")
        // 처음부터 몇 개의 요소를 건너뛸 것인지.
        Observable.of(1, 2, 3, 4, 5, 6, 7)
            .skip(5)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---skipWhile---")
        // filter와 반대. 해당 요소가 조건에 false인 지점까지 skip하고 그 이후부터 방출
        Observable.of(1, 2, 3, 4, 5, 6, 7)
            .skip(while: {
                $0 != 5
            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---skipUntil---")
        // 현재 observable이 다른 observable의 onNext호출 전까지는 무시하는 것
        let customer = PublishSubject<String>()
        let openTime = PublishSubject<String>()
        
        customer // 현재 observable
            .skip(until: openTime) // 다른 observable
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        customer.onNext("Hi")
        customer.onNext("Hi")
        
        openTime.onNext("Open!!")
        customer.onNext("Hello!")
        
        print("---take---")
        // skip의 반대, 첫번째부터 지정한 갯수만큼의 요소 취함
        Observable.of(1, 2, 3, 4, 5)
            .take(3)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---takeWhile---")
        // 조건이 true인 동안의 결과값을 방출
        Observable.of(1, 2, 3, 4, 5)
            .take(while: {
                $0 != 3
            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        

        print("---enumerated---")
        // 인덱스와 값을 분리해서 처리할 수 있도록 한다. takeWhile 구문에서는 index, value 모두 받기 때문에 함게 활용가능
        Observable.of("one", "two", "three", "four", "five")
            .enumerated()
            .take(while: {
                $0.index < 3
            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---takeUntil---")
        // trigger가 되는 observable 이전까지의 결과를 방출
        let start = PublishSubject<String>()
        let end = PublishSubject<String>()
        
        start
            .take(until: end)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        start.onNext("1빠!")
        start.onNext("2빠!")
        
        end.onNext("끝!")
        start.onNext("3빠!")
        
        
        print("---distinctUntilChanged---")
        // 연달아 같은 값이 이어질 때 중복된 값은 무시하는 것. 연달아 반복되지 않은 항목에 대해서는 방출하도록 한다.
        Observable.of("저는", "저는", "앵무새", "앵무새", "입니다", "입니다", "입니다", "입니다", "저는", "앵무새", "일까요?", "일까요?")
            .distinctUntilChanged()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
// MARK: Transforming Operator
        print("---toArray---")
        // single 요소들을 배열로 만들어 줌
        Observable.of("A", "B", "C")
            .toArray()
            .subscribe(onSuccess: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---map---")
        // swift에서 사용하는 map과 동일
        Observable.of(Date())
            .map { date -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                return dateFormatter.string(from: date)
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---flatMap---")
        // 중첩된 Observable 처리, flatMap을 통해 각 요소를 꺼내볼 수 있다.
        
        let koreanArcher = Archer(score: BehaviorSubject<Int>(value: 10))
        let americanArcher = Archer(score: BehaviorSubject<Int>(value: 8))
        
        let olympic = PublishSubject<Athelete>() // 중첩된 Observable
        
        olympic
            .flatMap { athelete in
                athelete.score
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        olympic.onNext(koreanArcher)
        koreanArcher.score.onNext(10)
        
        olympic.onNext(americanArcher)
        koreanArcher.score.onNext(10)
        americanArcher.score.onNext(9)
        
        
        print("---flatMapLatest---")
        // Observable sequence 중 가장 최신의 값만을 반영
        // 사전에서 단어를 찾을 때, 찾는 과정에서 가장 최신의 문자열만큼의 검색을 수행할 때 (s->sw->swi->swit->switc...)
        let seoul = Runner(score: BehaviorSubject<Int>(value: 7))
        let busan = Runner(score: BehaviorSubject<Int>(value: 6))
        
        let competition = PublishSubject<Athelete>()
        
        competition
            .flatMapLatest { athelete in
                athelete.score
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        competition.onNext(seoul)
        seoul.score.onNext(9)
        
        competition.onNext(busan) // 새로운 시퀀스가 들어오면 앞의 시퀀스(서울)은 무시됨
        seoul.score.onNext(10) // 이미 최신의 값을 리턴했기 때문에 변경된 값은 무시
        busan.score.onNext(8)
        
        print("---materialize and dematerialize---")
        enum penalty: Error {
            case falseStart
        }
        
        let rabbit = Runner(score: BehaviorSubject<Int>(value: 0))
        let turtle = Runner(score: BehaviorSubject<Int>(value: 1))
        
        let running100m = BehaviorSubject<Athelete>(value: rabbit)
        
        running100m
            .flatMapLatest { athelete in
                athelete.score
                    .materialize() // 이벤트들을 함께 받을 수 있음
            }
            .filter {
                guard let error = $0.error else {
                    return true // error가 없을 때만 통과
                }
                print(error)
                return false
            }
            .dematerialize() // 이벤트가 함께 제시되는 상황에서 값만 표시되도록 함
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        rabbit.score.onNext(1)
        rabbit.score.onError(penalty.falseStart)
        rabbit.score.onNext(2)
        
        running100m.onNext(turtle)
    }
}

struct SomeJSON: Decodable {
    let name: String
}

enum JSONError: Error {
    case decodingError
}

let json1 = """
    {"name":"Kim"}
    """

let json2 = """
    {"my_name:"Young"}
    """

func decode(json: String) -> Single<SomeJSON> {
    Single<SomeJSON>.create { observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data)
        else {
            observer(.failure(JSONError.decodingError))
            return Disposables.create()
        }
        
        observer(.success(json))
        return Disposables.create()
    }
}


// flatMap protocol & struct

protocol Athelete {
    var score: BehaviorSubject<Int> { get }
}

struct Archer: Athelete {
    var score: BehaviorSubject<Int>
}

// flatMapLatest struct
struct Runner: Athelete {
    var score: BehaviorSubject<Int>
}
