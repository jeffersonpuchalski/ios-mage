//
//  StorePropertiesManager.swift
//  Common
//
//  Created by Jefferson Barbosa Puchalski on 14/05/20.
//  Copyright © 2020 PagSeguro Credisim. All rights reserved.
//

import Foundation

/**
 Storage Wrapper responsible for save and load any object from user defaults.
 
 This property has a particular use case and is showed on exemples below:
 - Save a user name to User defaults.
 ```
 @Storage(key: "username_key", defaultValue: " ")
 static var username: String
 username = "Jhon Doe"
 ```
 - Load a object to user defaults.
 ```
 @Storage(key: "username_key", defaultValue: " ")
 static var username: String
 print(username)
 ```
 - Parameter key: String represeting a indentifier for Userdefault value stored.
 - Parameter T: Generic type  used to  save / load values from user defauts:
 */
@propertyWrapper
public struct Storage<T> {
    
    private var key: String
    private var defaultValue: T
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    /** Get current wrapped value and save in User defaults with current key.*/
    public var wrappedValue: T {
        get {
            // Read value from user defaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Save value to user defaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

/**
 Property Wrapper responsible for save and load any codable object from user defaults.
 
 This property has a particular use case and is showed on exemples below:
 - Save a codable object to User defaults.
 ```
 @Storage(key: "username_key", defaultValue: " ")
 static var username: String
 username = "Jhon Doe"
 ```
 - Load a object to user defaults.
 ```
 @Storage(key: "username_key", defaultValue: " ")
 static var username: String
 print(username)
 ```
 - Parameters:
    - T: Generic type  used to  save / load values from user defauts:
 */
@propertyWrapper
public struct StorageCodable<T: Codable> {
    
    private var key: String
    private var defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: T {
        get {
            // Read value from user defaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            // Try decode data to a Codable
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Try parse data to a Codable
            let data = try? JSONEncoder().encode(newValue)
            // Save value to user defaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
