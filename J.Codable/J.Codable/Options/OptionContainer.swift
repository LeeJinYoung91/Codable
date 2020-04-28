//
//  OptionContainer.swift
//  J.Codable
//
//  Created by JinYoung Lee on 20/12/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import Alamofire

@objcMembers class OptionContainer: NSObject {
    static let instance:OptionContainer = OptionContainer()
    @objc class func getInstance() -> OptionContainer {
        return instance
    }
    private var networkKey:Network_Key?
    private var currentConnectNetwork: NetworkReachabilityManager.NetworkReachabilityStatus?
    
    override init() {
        super.init()
        networkKey = OptionSetting().getNetworkOption()
    }
    
    func setCurrentReachableStatus(status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        currentConnectNetwork = status
    }
    
    func setNetworkOption(key: Network_Key) {
        networkKey = key
    }
    
    func isAvailableToAutoPlay() -> Bool {
        guard let key = networkKey else {
            return false
        }
        
        guard let status = currentConnectNetwork else {
            return false
        }
        
        switch key {
        case .All:
            return (status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi) || status == .notReachable)
        case .WIFI:
                return (status == .reachable(.cellular) || status == .reachable(.ethernetOrWiFi))
        case .None:
            return false
        }
    }
}
