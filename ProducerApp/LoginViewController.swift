//
//  LoginViewController.swift
//  ProducerApp
//
//  Created by Cybermac002 on 03/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import AFNetworking

class LoginViewController: UIViewController {

    @IBOutlet weak var Password_tx: UITextField!
    @IBOutlet weak var Email_tx: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Taptotermoscondition(_ sender: UIButton) {
  
        if let url = NSURL(string: "http://belive.mobi/terms_condition.html"){
            UIApplication.shared.open(url as URL, options: [:])
        }
    }
    @IBAction func Taptoprivacypolicy(_ sender: UIButton) {
        
        if let url = NSURL(string: "http://belive.mobi/privacy_policy.html"){
            UIApplication.shared.open(url as URL, options: [:])
        }
    }
    
  
    @IBAction func tapTologin(_ sender: UIButton) {
        getloginapi()
    }
    
    
    func getloginapi() {
        
        if(!Common.isValidEmail(testStr: Email_tx.text!)) {
            Common.Showalert(view: self, text: "Please enter valid email id")
            return
        }
         if(Common.isEmptyOrWhitespace(testStr: Password_tx.text!))
        {
            Common.Showalert(view: self, text: "Password can't be empty")
            return
        }
         Common.startloder(view: self.view)
          let parameters = [
            "token":Apptoken,
            "email": Email_tx.text!,
            "password": Password_tx.text!
             ]
        let url = String(format: "%@/user/login", BaseUrl)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    Common.Showalert(view: self, text: dict.value(forKey: "result") as! String)
                    return
                }
                else
                {
                    let logindict = ["id":((dict.value(forKey: "result") as! NSDictionary).value(forKey: "id") as! NSNumber).stringValue,
                                     "rtmp":(dict.value(forKey: "result") as! NSDictionary).value(forKey: "RTMP") as! String]
                    
                    print(logindict as NSDictionary)
                    
                AppData.Loginuserdata = logindict as NSDictionary
                AppData.Stremname = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "stream_name") as! String
                let url = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "RTMP") as! String
                     self.gotohomeview()
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.Showalert(view: self, text: error.localizedDescription)
            Common.stoploder(view: self.view)

        }
        
    }
    
    func gotohomeview() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    

}
