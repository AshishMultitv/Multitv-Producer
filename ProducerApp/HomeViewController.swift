//
//  HomeViewController.swift
//  ProducerApp
//
//  Created by Cybermac002 on 03/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import VGSegment
import AFNetworking
import PullToRefreshKit
import UILoadControl

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,VGSegmentDelegate,UIScrollViewDelegate {
    
   
    @IBOutlet weak var Mytableview: UITableView!
     @IBOutlet weak var nolabel: UILabel!
    var livedataarray = NSMutableArray()
    var upcomingdataarray = NSMutableArray()
    var completeddataarray = NSMutableArray()
    var maintabledata = NSMutableArray()
    var offset:Int = 30
    var selectedsegmentindex:Int = 0
    var slidermenu:[String] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        slidermenu = ["LIVE    ","UPCOMING","COMPLETED"]
        setmenu()
        getcategory()
        Common.startloder(view: self.view)
      
        self.gethomedata(islive: true, isupcoming: false, iscompleted: false)
  
        Mytableview.configRefreshHeader(container: self) {
         print("asdasd")
            let res = RefreshResult.success
            self.Mytableview.switchRefreshHeader(to: .normal(res, 1.0))
            self.removeallstaredata()
            self.offset = 30
            if(self.selectedsegmentindex == 0)
                           {
                self.gethomedata(islive: true, isupcoming: false, iscompleted: false)
                            }
            else if(self.selectedsegmentindex == 1) {
            self.gethomedata(islive: false, isupcoming: true, iscompleted: false)
            
            } else if(self.selectedsegmentindex == 2) {
            self.gethomedata(islive: false, isupcoming: false, iscompleted: true)
            
                            }
            
            
        }
        
        
        Mytableview.loadControl = UILoadControl(target: self, action: #selector(loadMore(sender:)))
        Mytableview.loadControl?.heightLimit = 100.0
 
//        Mytableview.configRefreshFooter(container: self) {
//
//            self.Mytableview.switchRefreshFooter(to: .normal)
//             self.offset = self.offset + 30
//
//
//            if(self.selectedsegmentindex == 0)
//            {
//                if(self.livedataarray.count<10)
//                {
//                   self.offset = 30
//                }
//                self.gethomedata(islive: true, isupcoming: false, iscompleted: false)
//            }
//            else if(self.selectedsegmentindex == 1) {
//                if(self.upcomingdataarray.count<10)
//                {
//                    self.offset = 30
//                }
//                self.gethomedata(islive: false, isupcoming: true, iscompleted: false)
//
//            } else if(self.selectedsegmentindex == 2) {
//
//                if(self.completeddataarray.count<10)
//                {
//                    self.offset = 30
//                }
//                self.gethomedata(islive: false, isupcoming: false, iscompleted: true)
//
//            }
//
//        }
        
       
        
     }
    
 
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
    
    //load more tableView data
    @objc func loadMore(sender: AnyObject?) {
        
        Mytableview.loadControl?.endLoading()
        self.offset = self.offset + 30
        if(self.selectedsegmentindex == 0)
        {
            
            self.gethomedata(islive: true, isupcoming: false, iscompleted: false)
        }
        else if(self.selectedsegmentindex == 1) {
           
            self.gethomedata(islive: false, isupcoming: true, iscompleted: false)
            
        } else if(self.selectedsegmentindex == 2) {
            
             self.gethomedata(islive: false, isupcoming: false, iscompleted: true)
            
        }
    }
    func removeallstaredata() {
        
        livedataarray.removeAllObjects()
        upcomingdataarray.removeAllObjects()
        completeddataarray.removeAllObjects()
        maintabledata.removeAllObjects()
        Mytableview.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func Taptoback(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Producer", message: "Are you sure want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: { (action) in
            AppData.Loginuserdata = NSDictionary()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
   
        
    }
    
    
    func getcategory() {
        
         let url = String(format: "%@/events/categories?token=%@", BaseUrl,Apptoken)
        let manager = AFHTTPSessionManager()
        manager.get(url, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                }
                else{
                   AppData.CategoryList = dict.value(forKey: "result") as! NSArray
                 }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            
        }
    }
    
    
    
    func gethomedata(islive:Bool,isupcoming:Bool,iscompleted:Bool) {
    
        print(BaseUrl)
        print(Apptoken)
        print(AppData.Userid)
        print(offset)
        let url1 = "\(BaseUrl)/events/list?token=\(Apptoken)&user_id=\(AppData.Userid)&access_control=&payment_type=&category_id=&start_offset=\(offset)&size=30"
        print(url1)
       //  let url = String(format: "%@/events/list?token=%@&user_id=%@&access_control=&payment_type=&category_id=&start_offset=%@&size=30", BaseUrl,Apptoken,AppData.Userid,offset)
        let manager = AFHTTPSessionManager()
        manager.get(url1, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
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
                else{

                  let data = (dict.value(forKey: "result") as! NSDictionary).value(forKey: "data") as! NSArray
                   for i in 0..<data.count {
                    let type = (data.object(at: i) as! NSDictionary).value(forKey: "publish") as! Int
                    if(type == 0) {
                        self.upcomingdataarray.add(data.object(at: i) as! NSDictionary)
                    }
                    else if(type == 1) {
                        self.livedataarray.add(data.object(at: i) as! NSDictionary)

                    }
                    else if(type == 2) {
                        self.completeddataarray.add(data.object(at: i) as! NSDictionary)

                    }
                    
                 
                      }
                    
                    if(islive == true) {
                  self.maintabledata = self.livedataarray
                        
                    }
                    else if(isupcoming == true) {
                       self.maintabledata = self.upcomingdataarray
                    }
                        
                    else if(iscompleted == true) {
                       self.maintabledata = self.completeddataarray
                    }
                    
            
                    if(self.maintabledata.count==0) {
                        Common.Showalert(view: self, text: "No result found")

                    }
                    else {
                    }
                
                    self.Mytableview.reloadData()
                    
                    
                    
                    
                    
                    
                    
                }
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.Showalert(view: self, text: error.localizedDescription)
            Common.stoploder(view: self.view)
            
        }
        
    }
    
    
    
   
    
    
    
    //MARK:- Init Slider menu
    func setmenu()
    {
        let rect = CGRect(x: 0, y: 65, width: view.frame.width, height: 45)
         let segment = VGSegment(frame: rect, titles: slidermenu)
        segment.delegate = self
        view.addSubview(segment)
        
        var configuration: VGSegmentConfiguration {
            let configura = VGSegmentConfiguration()
           configura.segmentBackgroundColor = UIColor.init(red: 40/255, green: 53/255, blue: 70/255, alpha: 1.0)
            configura.selectedTitleColor = UIColor.white
            configura.normalTitleColor = UIColor.white
            // TODO: configuration segment
            return configura
        }
         segment.configuration = configuration
     }
    
    
    
    func didSelectAtIndex(_ index: Int) {
        print(index)
        let seletedindex = index
        if(seletedindex == 0) {
            selectedsegmentindex = 0
           // self.maintabledata.removeAllObjects()
            print(livedataarray.count)
             self.maintabledata = self.livedataarray
            Mytableview.reloadData()
            if(self.maintabledata.count==0) {
                Common.Showalert(view: self, text: "No result found")

            }
            else {

            }
            return
        }
        else if(seletedindex == 1) {
                    selectedsegmentindex = 1
            //self.maintabledata.removeAllObjects()
            print(upcomingdataarray.count)
             self.maintabledata = self.upcomingdataarray
            Mytableview.reloadData()
            if(self.maintabledata.count==0) {

                Common.Showalert(view: self, text: "No result found")

            }
            else {

            }
            return
        }
        else if(seletedindex == 2) {
                selectedsegmentindex = 2
           // self.maintabledata.removeAllObjects()
            print(completeddataarray.count)
            self.maintabledata = self.completeddataarray
            Mytableview.reloadData()
            if(self.maintabledata.count==0) {

                Common.Showalert(view: self, text: "No result found")

            }
            else {

            }
            return
        }
        
    }
    
    
    
       //MARK:- Table View Delegate And  Datasouce
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(maintabledata.count)
        return maintabledata.count
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:CustomeTableViewCell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? CustomeTableViewCell
        cell = Bundle.main.loadNibNamed("CustomeTableViewCell", owner: self, options: nil)?[0] as! CustomeTableViewCell
        
        Common.setviewborderwithcolor(View: cell.mainview, borderwidth: 1.0, bordercolor: UIColor.gray)
        Common.setlabelborderwithcolor(label: cell.eventtimelabel, borderwidth: 1.0, bordercolor: UIColor.darkGray)
        Common.setRounduiview(view: cell.mainview, radius: 10.0)
        Common.setRounduiview(view: cell.timeview, radius: 5.0)
        cell.selectionStyle = .none
        
        
        
        ////// Set Title
        if let _ = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") {
            if(Common.isNotNull(object: (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as AnyObject)) {
           
                
                cell.titlelabel.text = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "title") as? String
             }
        }
    
        ////// Set description
        if let _ = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "description") {
            if(Common.isNotNull(object: (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as AnyObject)) {
                cell.subtitlelablel.text = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "description") as? String
            }
        }
        
     
        ////// Set status
        if let _ = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "type") {
            if(Common.isNotNull(object: (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "type") as AnyObject)) {
                cell.statuslabel.text = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "type") as? String
            }
        }
        

        ////// Set Location
        if let _ = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "location") {
            if(Common.isNotNull(object: (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "location") as AnyObject)) {
                
                cell.eventcountrynamelabel.text = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "location") as? String
                if(((maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "location") as! String) == "")
                {
                    cell.locationimageview.isHidden = true
                }
                else
                {
                   cell.locationimageview.isHidden = false
                }
                
            }
            else
            {
                cell.eventcountrynamelabel.text = ""
                cell.locationimageview.isHidden = true
            }
        }
        
        //// Set created date
        if let _ = (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") {
            if(Common.isNotNull(object: (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as AnyObject)) {
                
                cell.eventdatelablel.text = Common.convertstringdatetostringdate(mydate: (maintabledata.object(at: indexPath.row) as! NSDictionary).value(forKey: "created") as! String)

            }
        }
        
        
        
        
        
        return cell
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
    
    }

}


// MARK: - KRPullLoadView delegate -------------------

//extension HomeViewController: KRPullLoadViewDelegate {
//    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
//        if type == .loadMore {
//            switch state {
//            case let .loading(completionHandler):
//                offset = offset+30
//
//
//               if(selectedsegmentindex == 0)
//               {
//                self.gethomedata(islive: true, isupcoming: false, iscompleted: false)
//                }
//               else if(selectedsegmentindex == 1) {
//                 self.gethomedata(islive: false, isupcoming: true, iscompleted: false)
//
//               } else if(selectedsegmentindex == 2) {
//                 self.gethomedata(islive: false, isupcoming: false, iscompleted: true)
//
//                }
//
//
//
//
//
//               print("Load more")
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
//                    completionHandler()
//                }
//            default: break
//            }
//            return
//        }
//
//        switch state {
//        case .none:
//            pullLoadView.messageLabel.text = ""
//
//        case let .pulling(offset, threshould):
//              print("Load more 21 ")
//
//            if offset.y > threshould {
//                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
//            } else {
//                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
//            }
//
//        case let .loading(completionHandler):
//             print("refresh")
//             Common.startloder(view: self.view)
//             maintabledata = NSMutableArray()
//             Mytableview.reloadData()
//             offset = 0
//             if(selectedsegmentindex == 0)
//             {
//                livedataarray = NSMutableArray()
//                self.gethomedata(islive: true, isupcoming: false, iscompleted: false)
//             }
//             else if(selectedsegmentindex == 1) {
//                 upcomingdataarray = NSMutableArray()
//                self.gethomedata(islive: false, isupcoming: true, iscompleted: false)
//
//             } else if(selectedsegmentindex == 2) {
//                 completeddataarray = NSMutableArray()
//                self.gethomedata(islive: false, isupcoming: false, iscompleted: true)
//
//             }
//            pullLoadView.messageLabel.text = "Updating..."
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
//                completionHandler()
//            }
//        }
//    }
//}


