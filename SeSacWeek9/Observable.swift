//
//  Observable.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/08/31.
//

import Foundation


// 양방향 바인딩을 잘 구성되어 있는 라이브러리가 RxSwift (반응형)
class Observable<T> {   // 양방향 바인딩
    
    // 필요한 값을 캡처해서 저장
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("didSet", value)
            listener?(value)
        }
    }
    
    
    init(_ value: T) {
        self.value = value
    }
    
    
    func bind(_ closure: @escaping (T) -> Void) {
        print(#function)
        closure(value)       // 최초 1회 실행
        listener = closure   // listener에 저장하고 value가 변할 때마다 호출
    }
}



class User {
    
    private var listener: ((String) -> Void)?
    
    var value: String {
        didSet {
            print("데이터 바뀌었어!")
            listener?(value)
        }
    }
    
    
    init(_ value: String) {
        self.value = value
    }
}
