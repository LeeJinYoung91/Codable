//
//  OptionSetting.swift
//  J.Codable
//
//  Created by JinYoung Lee on 20/12/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class OptionSetting: NSObject {
    enum SETTING_TYPE: String, Codable {
        case NETWORK
        case PUSH
    }
    
    private let KEY_SETTING = "settings"
    private typealias SETTING = [SETTING_TYPE:String]
    private var settings:SETTING?
    
    override init() {
        super.init()
        createSettingDictionary()
        getAllSettings()
    }
    
    private func createSettingDictionary() {
        settings = SETTING()
    }
    
    private func getAllSettings() {
        if let settingsJson = UserDefaults.standard.string(forKey: KEY_SETTING) {
            if let dat = settingsJson.data(using: .utf8) {
                if let setting = try? JSONDecoder().decode(SETTING.self, from: dat) {
                    self.settings = setting
                }
            }
        }
    }
    
    func setNetworkOption(type:Network_Key, doneListener:(()->Void)?) {
        let networkSetting = NetworkSetting(selectedType: type)
        let jsonData = try? JSONEncoder().encode(networkSetting)
        if let jsonString = String(data: jsonData!, encoding: .utf8) {
            settings?[SETTING_TYPE.NETWORK] = jsonString
        }
        
        let data = try? JSONEncoder().encode(settings)
        if let json = String(data: data!, encoding: .utf8) {
            OptionContainer.getInstance().setNetworkOption(key: type)
            UserDefaults.standard.set(json, forKey: KEY_SETTING)
            UserDefaults.standard.synchronize()
            if doneListener != nil {
                doneListener!()
            }
        }
    }
    
    func getNetworkOption() -> Network_Key {
        if let settingValue = settings?[SETTING_TYPE.NETWORK] {
            if let network = settingValue.data(using: .utf8) {
                if let networkSetting = try? JSONDecoder().decode(NetworkSetting.self, from: network) {
                    return networkSetting.selectedType
                }
            }
        }
        return Network_Key.All
    }
}

enum Network_Key: String, Codable {
    case All
    case WIFI
    case None
}

struct NetworkSetting: Codable {
    var selectedType:Network_Key
}
