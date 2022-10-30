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
        print(value!)
        
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
