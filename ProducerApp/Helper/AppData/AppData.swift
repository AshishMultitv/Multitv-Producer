//
//  AppData.swift
//  ProducerApp
//
//  Created by Cybermac002 on 08/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit

class AppData: NSObject {

    
    static var CategoryList: NSArray {
        get {
            
            if let categoryList = UserDefaults.standard.object(forKey: "categoryList") as? NSArray {
                return categoryList
            }
            return NSArray()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "categoryList")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    
    
    
    
    static var Loginuserdata: NSDictionary {
        get {
            
            if let loginuserdatanew = UserDefaults.standard.object(forKey: "loginuserdatanew") as? NSDictionary {
                return loginuserdatanew
            }
            return NSDictionary()
        }
        set {
            
             UserDefaults.standard.set(newValue, forKey: "loginuserdatanew")
             UserDefaults.standard.synchronize()
        }
    }
    
    
    
    static var Userid: String {
         get {
            let id = Loginuserdata.value(forKey: "id") as! String
            return id
         }
   
    }
   
    static var RtmpUrl: String {
        get {
            let rtmp = Loginuserdata.value(forKey: "rtmp") as! String
            return rtmp
        }
        
    }
    
    static var RtmpUri: String {
        get {
            
            if let rtmpUri = UserDefaults.standard.object(forKey: "rtmpUri") as? String {
                return rtmpUri
            }
            return String()
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: "rtmpUri")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    static var Stremname: String {
        get {
            
            if let stremname = UserDefaults.standard.object(forKey: "stremname") as? String {
                return stremname
            }
            return String()
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: "stremname")
            UserDefaults.standard.synchronize()
        }
    }
    
}
