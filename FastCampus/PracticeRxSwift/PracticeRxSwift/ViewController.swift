//
//  ViewController.swift
//  PracticeRxSwift
//
//  Created by DongKyu Kim on 2022/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    enum TraitsError: Error {
        case single
        case maybe
        case completable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // traitsExamples()
        // subjectExamples()
        // filteringExmaples()
        // transformingExamples()
        // combiningExamples()
        // timeBasedExamples()

    }
    
    private func traitsExamples() {
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
    
    private func subjectExamples() {
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
    }
    
    private func filteringExmaples() {
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
    }
    
    private func transformingExamples() {
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
    
    private func combiningExamples() {
        print("---startWith---")
        // 현재 상태와 함께 초기값이 제공되는 형태
        let classYellow = Observable.of("1", "2", "3")
        
        classYellow
            .enumerated()
            .map { index, element in
                return element + "번 어린이의 번호는 \(index + 1)번"
            }
            .startWith("선생님")
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---concat1---")
        let classYellowChilds = Observable<String>.of("1", "2", "3")
        let teacher = Observable<String>.of("선생님")
        
        let walkThroughLine = Observable
            .concat([teacher, classYellowChilds])
        
        walkThroughLine
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---concat2---")
        teacher
            .concat(classYellowChilds)
            .concat(teacher) // 연달아서 concat 사용도 가능
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---concatMap---") // flatMap
        // 각각의 sequence가 다음 sequence가 구독되기 전에 합쳐지는 것을 보장
        let kindergarden: [String: Observable<String>] = [
            "Yellow": Observable.of("1", "2", "3"),
            "Blue": Observable.of("5", "6")
        ]
        
        Observable.of("Yellow", "Blue")
            .concatMap { color in
                kindergarden[color] ?? .empty()
            }
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---merge1---")
        // 순서를 보장하지 않고 두 개의 Observable을 합쳐서 하나로 방출
        let gangbuk = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
        let gangnam = Observable.from(["강남구", "강동구", "영등포구", "양천구"])
        
        Observable.of(gangbuk, gangnam)
            .merge()
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---merge2---")
        Observable.of(gangbuk, gangnam)
            .merge(maxConcurrent: 1)
        // 한 번에 받아낼 Observable의 수, sequence가 완료될 때 까지 다른 sequence 받지 않음
        // 결과적으로 순서가 보장되는 것 처럼 보임
        // 사용성이 크게 높진 않지만, 네트워킹 등에서 요청 수를 제한할 경우 사용 가능
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---combineLatest1---")
        let firstName = PublishSubject<String>()
        let lastName = PublishSubject<String>()
        
        let name = Observable
            .combineLatest(firstName, lastName) { firstName, lastName in
                firstName + lastName
            }
        
        name
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        firstName.onNext("김")
        lastName.onNext("동규")
        lastName.onNext("우영")
        lastName.onNext("호정")
        firstName.onNext("정")
        firstName.onNext("전")
        // 여러 textfield를 결합하는 경우 사용
        // "최신"의 데이터들끼리 조합해서 결과 방출
        
        print("---combineLatest2---")
        // 여러개의 Sourece를 받을 수 있음. 한 번에 8개까지 가능
        let dateFormatter = Observable<DateFormatter.Style>.of(.short, .long)
        let currentDate = Observable<Date>.of(Date())
        
        let showCurrentDate = Observable
            .combineLatest(
                dateFormatter,currentDate, resultSelector: { format, date -> String in
                    let formatter = DateFormatter()
                    formatter.dateStyle = format
                    return formatter.string(from: date)
                }
            )
        
        showCurrentDate
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        
        print("---combineLatest3---")
        let startName = PublishSubject<String>()
        let endName = PublishSubject<String>()
        
        let fullName = Observable
            .combineLatest([startName, endName]) { name in
                name.joined(separator: " ")
            }
        
        fullName
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        startName.onNext("Kim")
        endName.onNext("Paul")
        endName.onNext("Stella")
        endName.onNext("Lily")
        startName.onNext("Jang")
        
        
        print("---zip---")
        // (다른 타입의) 대상을 묶어서 방출하는 연산자
        // 대상이 되는 Obsrevable 하나라도 완료되면 zip 전체가 완료됨
        enum resultType {
            case win
            case lose
        }
        let versus = Observable<resultType>.of(.win, .win, .lose, .win, .lose)
        let participant = Observable<String>.of("Korea", "Hongkong", "USA", "Brazil", "Japan", "China")
        
        let competitoinResult = Observable
            .zip(versus, participant) { result, respect in
                return respect + "선수" + " \(result)"
            }
        
        competitoinResult
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---withLatestFrom1---")
        let trigger = PublishSubject<Void>()
        let runAthelete = PublishSubject<String>()
        
        trigger
            .withLatestFrom(runAthelete)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        runAthelete.onNext("Runner1")
        runAthelete.onNext("Runner1 Runner2")
        runAthelete.onNext("Runner1 Runner2 Runner3")
        trigger.onNext(Void())
        trigger.onNext(Void())
        // runAthlete가 방출한 가장 최근의 onNext 값을 호출
        
        print("---sample---")
        // withLatestFrom과 거의 동일하지만, 한 번만 방출된다.
        let startFlag = PublishSubject<Void>()
        let F1car = PublishSubject<String>()
        
        F1car
            .sample(startFlag)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        F1car.onNext("Red Car")
        F1car.onNext("Red Car     Yellow Car")
        F1car.onNext("Red Car     Yellow Car      Blue Car")
        startFlag.onNext(Void())
        startFlag.onNext(Void())
        startFlag.onNext(Void())
        
        
        print("---amb---")
        // 두 가지 Sequence 중에서 어떤 것을 구독할 지 애매모호 할 때
        // 두 가지 Observable을 모두 구독하긴 하지만, 먼저 방출하는 것이 있다면 나머지는 구독하지 않음
        // ambiguous ~ 두 가지 Observable을 모두 일단 지켜보겠다.
        let bus1 = PublishSubject<String>()
        let bus2 = PublishSubject<String>()
        
        let busStop = bus1.amb(bus2)
        
        busStop
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        bus2.onNext("버스2-승객0: 👩‍💼") // 여기서는 bus2를 먼제 구독했기때문에 bus2만 보여지지만 원래는 순서 보장X
        bus1.onNext("버스1-승객0: 🧑🏻‍🔬")
        bus1.onNext("버스1-승객1: 👨‍🚀")
        bus2.onNext("버스2-승객1: 👩🏽‍💻")
        bus1.onNext("버스1-승객2: 🧝🏻‍♀️")
        bus2.onNext("버스2-승객2: 🧑🏿‍🔧")
        
        
        print("---switchLatest---")
        // 특정 프로프티의 마지막 sequence의 아이탬 제외하고는 무시
        let student1 = PublishSubject<String>()
        let student2 = PublishSubject<String>()
        let student3 = PublishSubject<String>()
        
        let raiseHand = PublishSubject<Observable<String>>()
        
        let classOnlyRaiseHand = raiseHand.switchLatest()
        
        classOnlyRaiseHand
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        raiseHand.onNext(student1)
        student1.onNext("저는 1번 학생입니다!")
        student2.onNext("저는 2번!")
        
        // 이 시점에서 최신 값이 student2로 바뀌고 나머지는 무시
        raiseHand.onNext(student2)
        student1.onNext("저는 1번 학생입니다!")
        student2.onNext("저는 2번 학생입니다!")
        student3.onNext("삼가 고인의 명복을 빕니다")
        
        
        print("---reduce---")
        // Swift의 Reduce와 동일한 형태로 적용
        // 첫번째 파라미터는 초깃값
        // observable의 element들을 결합
        Observable.from((1...10))
            .reduce(10, accumulator: { summary, newValue in
                return summary + newValue
            })
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---scan---")
        // Reduce와 동일하게 작용하긴 하지만 return 값이 Observabled이라서 계속 방출
        Observable.from((1...10))
            .scan(0, accumulator: +)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func timeBasedExamples() {
        print("---replay---")
        // 이미 지나간 결과에 대해서 확인할 수 있도록 해주는 연산자
        // 구독자가 buffer 크기만큼 최신 데이터를 받을 수 있음
        let sayHello = PublishSubject<String>()
        let parrot = sayHello.replay(2)
        parrot.connect() // 반드시 써줘야 함!
        
        sayHello.onNext("1. hello")
        sayHello.onNext("2. hello")
        sayHello.onNext("3. hello")
        
        parrot
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---replayAll---")
        // 지나간 이벤트 방출에 대해서 그 결과가 지나가더라도 모두 보여주는 연산자
        let doctorStrange = PublishSubject<String>()
        let timeStone = doctorStrange.replayAll()
        timeStone.connect()
        
        doctorStrange.onNext("도르마무")
        doctorStrange.onNext("거래를 하러 왔다")
        
        timeStone
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---buffer---")
        // 최대 갯수가 제한(최대갯수->count), 1초마다 Observable의 조합을 방출
        // source에서 받을 것이 없으면 빈 array를 반환할 수 있음
        let source = PublishSubject<String>()

        timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
        timer.setEventHandler {
            timeCount += 1
            source.onNext("\(timeCount)")
        }
        timer.resume()

        source
            .buffer(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---window---")
        // buffer와 유사하지만, buffer가 Array를 방출한다면 Window는 Observable을 방출
        let maxObservableCount = 1
        let makeTime = RxTimeInterval.seconds(2)

        let window = PublishSubject<String>()

        windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
        windowTimerSource.setEventHandler {
            windowCount += 1
            window.onNext("\(windowCount)")
        }
        windowTimerSource.resume()

        window
            .window(timeSpan: makeTime, count: maxObservableCount, scheduler: MainScheduler.instance)
            .flatMap { windowObservable -> Observable<(index: Int, element: String)> in
                return windowObservable.enumerated()
            }
            .subscribe(onNext: {
                print("\($0.index)번째 Observable의 요소 \($0.element)")
            })
            .disposed(by: disposeBag)
        
        print("---delaySubscription---")
        // 구독 지연을 해주도록 함
        delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
        delayTimeSource.setEventHandler {
            delayCount += 1
            delaySource.onNext("\(delayCount)")
        }
        delayTimeSource.resume()

        delaySource
            .delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            }, onError: {
                print($0.localizedDescription)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        print("---delay---")
        // 일정 시간 이후부터 시퀀스 자체 이벤트가 방출되도록 함
        let delaySubject = PublishSubject<Int>()

        delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
        delayTimeSource.setEventHandler {
            delayCount += 1
            delaySubject.onNext(delayCount)
        }
        delayTimeSource.resume()

        delaySubject
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---interval---")
        // 지금까지 임의로 만들었던 타이머를 rx로 나타내는 것으로, 일정 간격마다 수행
        // of, next 등의 생성자 없이도 타입 만으로 값을 방출하는 타이머를 만들 수 있음
        Observable<Int>
            .interval(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---timer---")
        // interval과 유사하지만, 구독과 첫 방출 사이에 마감시점을 설정할 수 있음
        // 첫 구독 이후 ~ 첫번째 구독한 값 사이의 시간 의미 (일종의 delay?)
        Observable<Int>
            .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        print("---timeout---")
        // 특정 시간 내에 어떠한 이벤트도 발생하지 않을 경우 timeout 에러를 발생시킴
        let button = UIButton(type: .system)
        button.setTitle("눌러주세요!", for: .normal)
        button.sizeToFit()
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        button.rx.tap
            .do(onNext: {
                print("tap")
            })
                .timeout(.seconds(5), scheduler: MainScheduler.instance)
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


// MARK: flatMap protocol & struct
protocol Athelete {
    var score: BehaviorSubject<Int> { get }
}

struct Archer: Athelete {
    var score: BehaviorSubject<Int>
}

// MARK: flatMapLatest struct
struct Runner: Athelete {
    var score: BehaviorSubject<Int>
}

// MARK: timeBased variables
let delaySource = PublishSubject<String>()

var timeCount = 0
var windowCount = 0
var delayCount = 0

let timer = DispatchSource.makeTimerSource()
let windowTimerSource = DispatchSource.makeTimerSource()
let delayTimeSource = DispatchSource.makeTimerSource()
