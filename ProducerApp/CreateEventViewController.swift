//
//  CreateEventViewController.swift
//  ProducerApp
//
//  Created by Cybermac002 on 07/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import AFNetworking
import CoreLocation
import FTPopOverMenu_Swift


class CreateEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var Mytableview: UITableView!
    var locationManager = CLLocationManager()

     var location :String = "Event Location"
     var startdate :String = "Start date *"
     var enddate :String = "End date *"
     var category :String = ""
    var addresh:String = ""
    var latitude:Double = 0.0
    var lognitude:Double = 0.0
    var city:String = ""
    var state:String = ""
    var country:String = ""
    var postalcode:String = ""
    var catid:String = ""
    var publicorprivate:String = "public"

    @IBOutlet weak var Title_tx: UITextField!
    @IBOutlet weak var Description_tx: UITextField!
    @IBOutlet weak var backgroundimageview: UIImageView!
    
    
    
      var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func taptoGolive(_ sender: UIButton) {
         self.addeventapi()
    }
    
    
    
    func getlocation() {
        if(Common.isInternetAvailable())
        {
            // For use in foreground
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
        else
        {

         }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse  || status == .authorizedAlways {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            self.setUsersClosestCity()
        }
        else
        {
            showlocationalert()
          }
       
    }
    func showlocationalert() {
        
        let alert = UIAlertController(title: "", message: "Location not found!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: { (action) in
            self.getlocation()
           }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            self.latitude = (self.locationManager.location?.coordinate.latitude)!
            self.lognitude =  (self.locationManager.location?.coordinate.longitude)!

            print(self.latitude)
            print(self.lognitude)
            print(addressDict)
            // Print each key-value pair in a new row
            // addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
                 self.location = formattedAddress.joined(separator: ", ")
                 self.Mytableview.reloadData()
                
            }
            // Access each element manually
            if let locationName = addressDict["Name"] as? String {
                print(locationName)
            }
            if let street = addressDict["Thoroughfare"] as? String {
                print(street)
            }
            if let city = addressDict["City"] as? String {
                print(city)
                self.city = city
            }
            
            if let state = addressDict["State"] as? String {
                print(state)
                self.state = state
            }
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
                self.postalcode = zip
            }
            if let country = addressDict["Country"] as? String {
                print(country)
                self.country = country
             }
            
            
        })
    }
    
    
    func addeventapi() {
        
        if(Common.isEmptyOrWhitespace(testStr: Title_tx.text!))
        {
            Common.Showalert(view: self, text: "Please enter Title")
            return
        }
        else if(Common.isEmptyOrWhitespace(testStr: Description_tx.text!))
        {
            Common.Showalert(view: self, text: "Please enter Description")
            return
        }
        else if(startdate == "Start date *")
        {
            Common.Showalert(view: self, text: "Please select start date")
            return
        }
        else if(enddate == "End date *")
        {
            Common.Showalert(view: self, text: "Please select end date")
            return
        }
        else if(Common.isEmptyOrWhitespace(testStr: category))
        {
            Common.Showalert(view: self, text: "Please select category")
            return
        }
            
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let Sdate = dateFormatter.date(from: startdate)
        let Edate = dateFormatter.date(from: enddate)
     
        if (Sdate?.compare(Edate!) == .orderedSame)  || (Sdate?.compare(Edate!) == .orderedDescending)  {
            Common.Showalert(view: self, text: "End date always greater to start date")
            return
        }
        
      Common.startloder(view: self.view)
       
        let tag = [Title_tx.text!,category]
      
        let parameters = [
            "token":Apptoken,
            "name": Title_tx.text!,
            "customer_id": AppData.Userid,
            "category_id": self.catid,
            "start_date_time": startdate,
            "end_date_time": enddate,
            "access_control": publicorprivate,
            "image": Common.convertimagetobase64(image: backgroundimageview.image!),
            "description": Description_tx.text!,
            "latitude": latitude,
            "longitude": lognitude,
            "city": city,
            "state": state,
            "country": country,
            "postal_code": postalcode,
            "image_type": "png",
            "tags":tag
            ] as [String : Any]
       
        let url = String(format: "%@/events/add", BaseUrl)
        let manager = AFHTTPSessionManager()
        manager.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject: Any?) in
            if (responseObject as? [String: AnyObject]) != nil {
                Common.stoploder(view: self.view)
                let dict = responseObject as! NSDictionary
                print(dict)
                Common.stoploder(view: self.view)
                 let number = dict.value(forKey: "code") as! NSNumber
                if(number == 0)
                {
                    
                    Common.Showalert(view: self, text: dict.value(forKey: "error") as! String)
                    return
                }
                else
                {
                    
                    let alert = UIAlertController(title: "Producer", message: dict.value(forKey: "message") as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let rTMPViewController = storyboard.instantiateViewController(withIdentifier: "RTMPViewController") as! RTMPViewController
                        self.navigationController?.pushViewController(rTMPViewController, animated: true)
                    }))
                     self.present(alert, animated: true, completion: nil)
                  }
             }
        }) { (task: URLSessionDataTask?, error: Error) in
            print("POST fails with error \(error)")
            Common.Showalert(view: self, text: error.localizedDescription)
            Common.stoploder(view: self.view)
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Taptoback(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- Table View Delegate And  Datasouce
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    // cell height
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let SimpleTableIdentifier:NSString = "cell"
        var cell:CustomeTableViewCell! = tableView.dequeueReusableCell(withIdentifier: SimpleTableIdentifier as String) as? CustomeTableViewCell
        
        if indexPath.row == 4 {
          cell = Bundle.main.loadNibNamed("CustomeTableViewCell", owner: self, options: nil)?[2] as! CustomeTableViewCell
        cell.publicprivateswitchbutton.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        }
        else {
           cell = Bundle.main.loadNibNamed("CustomeTableViewCell", owner: self, options: nil)?[1] as! CustomeTableViewCell
        }
       
         cell.selectionStyle = .none
         switch indexPath.row {
        case 0:
           cell.eventtitlelabel.text = "Location"
           cell.eventsubtitlelabel.text = location
           cell.createeventimageview.image = #imageLiteral(resourceName: "create_event_location")
        case 1:
            cell.eventtitlelabel.text = "Start Date *"
            cell.eventsubtitlelabel.text = startdate
            cell.createeventimageview.image = #imageLiteral(resourceName: "Timer")
        case 2:
            cell.eventtitlelabel.text = "End Date *"
            cell.eventsubtitlelabel.text = enddate
            cell.createeventimageview.image = #imageLiteral(resourceName: "Timer")
         case 3:
            cell.eventtitlelabel.text = "Category *"
            cell.eventsubtitlelabel.text = category
            cell.createeventimageview.image = #imageLiteral(resourceName: "Category")

        default:
            break
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
             getlocation()
          break
        case 1:
            opendatepicker(index: indexPath.row, title: "Start date")
            break
         case 2:
            opendatepicker(index: indexPath.row, title: "End date")
            break
        case 3:
            opencategorudialog()
            break
            
        default:
            break
        }
    }
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
           
            publicorprivate = "private"
            print("Switch is on ")
        }
        else {
            publicorprivate = "public"
             print("Switch is off ")
        }
        
        
     }
    func opendatepicker(index:Int,title:String) {
        // Date Picker
        DPPickerManager.shared.showPicker(title: title, picker: { (picker) in
            picker.date = Date()
            picker.minimumDate = Date()
            picker.datePickerMode = .dateAndTime
        }) { (date, cancel) in
            if !cancel {
                // TODO: you code here
                debugPrint(date as Any)
                  if(index == 1) {
                  self.startdate = Common.convertdatetostring(date: date! as NSDate)
                  self.Mytableview.reloadData()
                   return
                         }
                     else {
                   self.enddate = Common.convertdatetostring(date: date! as NSDate)
                   self.Mytableview.reloadData()
                   return
                 }
                
            }
        }
 

    }
    
    func opencategorudialog()
    {
      
        // Strings Picker
        
        
         DPPickerManager.shared.showPicker(title: "Select Category", selected: category, strings: AppData.CategoryList.value(forKey: "category") as! [String]) { (value, index, cancel) in
            if !cancel {
                // TODO: you code here
                print(AppData.CategoryList)
                self.category = (value as? String)!
                self.catid = ((AppData.CategoryList.object(at: index) as! NSDictionary).value(forKey: "id") as! NSNumber).stringValue
                print(self.catid)
                self.Mytableview.reloadData()
                return
                
            }
        }
        
    }
    
    
    @IBAction func TAptoimage(_ sender: UIButton) {
        
        imagePicker.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
            
        })
        
        let deleteAction = UIAlertAction(title: "Gallery", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    func openCamera()
    {
        
        
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //PickerView Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
             backgroundimageview.image = pickedImage
             backgroundimageview.image =  backgroundimageview.image?.fixOrientation()
          }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
 
    }
    
    
}
