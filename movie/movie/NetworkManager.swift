//
//  NetworkManager.swift
//  movie
//
//  Created by May Shi on 9/10/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkManager: NSObject {
    
    func isConnected() -> Bool {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &address, { pointer in
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable: Bool = flags.contains(.reachable)
        let needsConnection: Bool = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection) ? true : false
    }
}
