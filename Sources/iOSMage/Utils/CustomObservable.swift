//
//  CustomObservable.swift
//  Beneficio
//
//  Created by Jefferson Puchalski on 04/02/20.
//  Copyright © 2020 ValeCard. All rights reserved.
//

import Foundation

protocol ObserverProtocol {
    var id: Int { get set}
}

class CustomObservable<T> {
    typealias CompletionHandler = ((T) -> Void)
    
    var value : T {
        didSet {
            self.notifyObserver(self.observers)
        }
    }
    
    var observers : [Int : CompletionHandler] = [:]
    
    init(value: T) {
        self.value = value
    }
    
    func addObserver(_ observer: ObserverProtocol, completion: @escaping CompletionHandler){
        self.observers[observer.id] = completion
    }
    
    func removeObserver(_ observer: ObserverProtocol) {
        self.observers.removeValue(forKey: observer.id)
    }
    
    func notifyObserver(_ oberserver: [Int : CompletionHandler]) {
        observers.forEach({ $0.value(value)})
    }
    
    deinit {
        observers.removeAll()
    }
}
