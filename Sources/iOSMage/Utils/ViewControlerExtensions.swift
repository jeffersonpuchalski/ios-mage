//
//  File.swift
//  
//
//  Created by Jefferson Barbosa Puchalski on 10/11/20.
//

import UIKit

public extension UIViewController {
    
    /**
     Method responsible for instance and generate a UIViewController object.
     - Parameters:
        - T: A generic view controller who needs match a base UIViewController type.
     - Returns: A generic instance created on object.
     */
    private static func genericInstance<T: UIViewController>() -> T {
        return T.init(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    private static func genericInstance<T: UIViewController>(for nibName: String, inBundle: Bundle) -> T {
        return T.init(nibName: nibName, bundle: inBundle)
    }
    
    static func instance() -> Self {
        return genericInstance()
    }
    
    static func instance(nibName: String, bundle: Bundle) -> Self {
        return genericInstance(for: nibName, inBundle: bundle)
    }
    
    /**
     Method responsible for instance and generate a UIViewController object whiout any nib.
     - Parameters:
        - T: A generic view controller who needs match a base UIViewController type.
     - Returns: A generic instance created on object.
     */
    static func instanceWithoutNib<T: UIViewController>() -> T {
        return T.init()
    }
}
