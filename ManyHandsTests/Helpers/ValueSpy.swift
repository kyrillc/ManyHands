//
//  ValueSpy.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 21/07/2022.
//

import Foundation
import RxSwift

public class ValueSpy<T> {
    
    private(set) var values = [T]()
    private(set) var error:Error?
    private let disposeBag = DisposeBag()
    
    init(_ observable:Observable<T>) {
        observable.subscribe { [weak self] newBoolValue in
            print("ValueSpy.newValue:\(newBoolValue)")
            self?.values.append(newBoolValue)
        } onError: { [weak self] err in
            print("ValueSpy.error:\(err)")
            self?.error = err
        } onCompleted: {
            //
        } onDisposed: {
            //
        }.disposed(by: disposeBag)

    }
    
}
