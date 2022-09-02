//
//  Sample.swift
//  SeSacWeek9
//
//  Created by 신동희 on 2022/09/01.
//

import Foundation


class User<T> {
    
    // 값이 변경되었을 때, 실행시킬 클로저 (따로 변수로 저장함으로써, User클래스 외부에서 값이 변경되었을 때
    // 실행하고 싶은 기능을 넣어줄 수 있음
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            // didSet이 실행될 때마다 다른 함수를 실행시키려는 목적!
            listener?(value)
        }
    }
    
    
    init(_ value: T) {
        self.value = value
    }
    
    
    
    // 외부에서 이 메서드를 통해 listener에 클로저를 입력해줌 => 값이 변경되면 실행하고 싶은 구문을 여기 넣어주는 것
    func bind(completionHandler: @escaping (T) -> Void) {
        completionHandler(value)
        listener = completionHandler
    }
}
