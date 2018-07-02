//
//  Common.swift
//  ProducerApp
//
//  Created by Cybermac002 on 04/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SystemConfiguration
import MBProgressHUD
import CoreTelephony


var BaseUrl =  "http://belive.multitvsolution.com/beliveapi/v2"
var Apptoken = "58b698f76ce2e"
let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();


class Common: NSObject {
    

    
    static func Islogin() -> Bool
    {
     
        if (AppData.Loginuserdata.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    static func setviewborderwithcolor(View: UIView, borderwidth:CGFloat,bordercolor:UIColor) {
        View.layer.borderColor=bordercolor.cgColor
        View.layer.borderWidth=borderwidth
        View.clipsToBounds=true
    }
    
    static func setimageviewborderwithcolor(imageview: UIImageView, borderwidth:CGFloat,bordercolor:UIColor) {
        imageview.layer.borderColor=bordercolor.cgColor
        imageview.layer.borderWidth=borderwidth
        imageview.clipsToBounds=true
    }
    
    static func setlabelborderwithcolor(label: UILabel, borderwidth:CGFloat,bordercolor:UIColor) {
        label.layer.borderColor=bordercolor.cgColor
        label.layer.borderWidth=borderwidth
        label.clipsToBounds=true
    }
    
    static func setRounduiview(view: UIView, radius:CGFloat)
    {
        view.layer.cornerRadius = radius;
        view.clipsToBounds=true
    }
    
    static func setRoundbutton(button: UIButton, radius:CGFloat)
    {
        button.layer.cornerRadius = radius;
        button.clipsToBounds=true
    }
    static func setRoundlabel(label: UILabel, radius:CGFloat)
    {
        label.layer.cornerRadius = radius;
        label.clipsToBounds=true
    }
    static func setRoundimageview(imageview: UIImageView, radius:CGFloat)
    {
        imageview.layer.cornerRadius = radius;
        imageview.clipsToBounds=true
    }
    
    
    
    static func convertdatetostring(date:NSDate) -> String {
         let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let myStringafd = formatter.string(from: date as Date)
        return myStringafd
        
    }
    
    static func convertstringdatetostringdate(mydate:String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MMM-yyyy"
        
        if let date = dateFormatterGet.date(from: mydate){
            print(dateFormatterPrint.string(from: date))
              return dateFormatterPrint.string(from: date)
        }
        else {
            print("There was an error decoding the string")
              return ""
        }
      
     }
    
    static func startloder(view:UIView)
    {
        
        
          MBProgressHUD.showAdded(to:view, animated: true)
//        activityIndicator.center = view.center;
//        activityIndicator.hidesWhenStopped = true;
//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white;
//        view.addSubview(activityIndicator);
//        activityIndicator.startAnimating();
//        UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    static func stoploder(view:UIView)
    {
        
        MBProgressHUD.hide(for: view, animated: true)
      //  activityIndicator.stopAnimating();
      //  UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    static func isEmptyOrWhitespace(testStr:String) -> Bool
    {
        let str = testStr.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if(testStr.isEmpty || str.isEmpty)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    static func Showalert(view:UIViewController,text:String)
    {
        let alert = UIAlertController(title: "Producer", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
         view.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    static func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    
    
    static func isNotNull(object:AnyObject?) -> Bool
    {
        guard let object = object else {
            return false
        }
        return (isNotNSNull(object: object) && isNotStringNull(object: object))
    }
    
    static func isNotNSNull(object:AnyObject) -> Bool
    {
        return object.classForCoder != NSNull.classForCoder()
    }
    
    static func isNotStringNull(object:AnyObject) -> Bool
    {
        if let object = object as? String, object.uppercased() == "NULL" {
            return false
        }
        return true
    }
    
    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
      static func convertimagetobase64(image:UIImage) -> String {
        let imagedata: NSData? = image.jpeg(.lowest) as NSData?
        let imagebase64str = (imagedata?.base64EncodedString(options: .lineLength64Characters))!
        return imagebase64str
        
    }
    
    
    static func getnetworktype()->String
        
    {
        let reachability = Reachability()!
        print(reachability.description)
        if(!reachability.isReachable)
        {
            return ""
        }
        if(reachability.isReachableViaWiFi)
        {
            return "WiFi"
        }
        else
        {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.currentRadioAccessTechnology
            switch carrierType{
            case CTRadioAccessTechnologyGPRS?,CTRadioAccessTechnologyEdge?,CTRadioAccessTechnologyCDMA1x?:
                return "2G"
            case CTRadioAccessTechnologyWCDMA?,CTRadioAccessTechnologyHSDPA?,CTRadioAccessTechnologyHSUPA?,CTRadioAccessTechnologyCDMAEVDORev0?,CTRadioAccessTechnologyCDMAEVDORevA?,CTRadioAccessTechnologyCDMAEVDORevB?,CTRadioAccessTechnologyeHRPD?:
                return "3G"
            case CTRadioAccessTechnologyLTE?:
                return "4G"
            default: return ""
            }
        }
        return ""
    }
    
}
