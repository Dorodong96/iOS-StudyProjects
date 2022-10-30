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
