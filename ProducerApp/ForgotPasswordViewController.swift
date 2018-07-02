//
//  ForgotPasswordViewController.swift
//  ProducerApp
//
//  Created by Cybermac002 on 03/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import AFNetworking

class ForgotPasswordViewController: UIViewController {

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
    
    
    
    @IBAction func tapToForgotpassword(_ sender: UIButton) {
        getforgotpasswordapi()
    }
    
    func getforgotpasswordapi() {
        
        if(!Common.isValidEmail(testStr: Email_tx.text!)) {
            Common.Showalert(view: self, text: "Please enter valid email id")
            return
        }
       
        Common.startloder(view: self.view)
        let parameters = [
            "token":Apptoken,
            "email": Email_tx.text!,
         ]
        
         let url = String(format: "%@/send/email", BaseUrl)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    Common.Showalert(view: self, text: dict.value(forKey: "error") as! String)
                    return
                }
                else
                {
                    self.Email_tx.text = ""
                    Common.Showalert(view: self, text: dict.value(forKey: "result") as! String)
                    // self.navigationController?.popViewController(animated: true)

                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.Showalert(view: self, text: error.localizedDescription)
            Common.stoploder(view: self.view)
            
        }
        
    }
    
    
    
    @IBAction func Taptoback(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
