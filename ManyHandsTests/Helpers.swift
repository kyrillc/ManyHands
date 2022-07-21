//
//  Helpers.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 21/07/2022.
//

import Foundation
import RxSwift

public class ValueSpy<T> {
    
    var values = [T]()
    let disposeBag = DisposeBag()
    
    init(_ observable:Observable<T>) {
        observable.subscribe { [weak self] newBoolValue in
            print("ValueSpy.newValue:\(newBoolValue)")
            self?.values.append(newBoolValue)
        } onError: { error in
            //
        } onCompleted: {
            //
        } onDisposed: {
            //
        }.disposed(by: disposeBag)

    }
    
}
