//
//  Reachability.swift
//  Beneficio
//
//  Created by Jefferson Barbosa Puchalski on 05/08/19.
//  Copyright © 2019 Mainstream. All rights reserved.
//

import Foundation
import SystemConfiguration

/**
 Class for get the reachability of device.
*/
public class Reachability {
    /**
     Function to see if device has a valid and functional network.
     
     This method can be implemented as following code:
     ```
     if Reachability.isConnectedToNetwork(){
        print("Internet Connection Available!")
     }else{
        print("Internet Connection not Available!")
     }
     ```
     `print` method can be replaced with anything you wish to inform user, about his device reachability.
     - Returns: True if networks is valid and have functional state, false otherwise
    */
    static func isConnected() -> Bool{
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){ zeroSocketAddr in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSocketAddr)
                
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}
