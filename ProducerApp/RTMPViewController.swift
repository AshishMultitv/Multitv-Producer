//
//  RTMPViewController.swift
//  ProducerApp
//
//  Created by Cybermac002 on 10/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import HaishinKit
import AVFoundation
import Photos
import VideoToolbox
import FTPopOverMenu_Swift
import MediaPlayer

let sampleRate: Double = 44_100

class ExampleRecorderDelegate: DefaultAVMixerRecorderDelegate {
    override func didFinishWriting(_ recorder: AVMixerRecorder) {
        guard let writer: AVAssetWriter = recorder.writer else { return }
        PHPhotoLibrary.shared().performChanges({() -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: writer.outputURL)
        }, completionHandler: { (_, error) -> Void in
            do {
               // try FileManager.default.removeItem(at: writer.outputURL)
            } catch let error {
                print(error)
            }
        })
    }
}


final class RTMPViewController: UIViewController {
    
    let recorderDelegate = ExampleRecorderDelegate()
    var rtmpConnection: RTMPConnection = RTMPConnection()
    var rtmpStream: RTMPStream!
    var sharedObject: RTMPSharedObject!
    var currentEffect: VisualEffect?
    var Issavelocal: Bool = false
    var selectedstenres:String = ""
    
    
    @IBOutlet weak var videoBitrateSlider: UISlider!
    @IBOutlet weak var actionviewbutton: UIButton!
    @IBOutlet weak var actionview: UIView!
    @IBOutlet var lfView: GLLFView?
      var currentPosition: AVCaptureDevice.Position = .back
    
    
    @IBOutlet weak var networkview: UIView!
    @IBOutlet weak var livesttuslabel: UILabel!
    @IBOutlet weak var networkname: UILabel!
    @IBOutlet weak var networkimageview: UIImageView!
    @IBOutlet weak var sppedlabel: UILabel!
    @IBOutlet weak var switchbutton: UISwitch!
    @IBOutlet weak var bitratenamelabel: UILabel!
    
    
    
    @IBOutlet weak var bitratelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight])
         NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationDidBecomeActive, object: nil)
        rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.syncOrientation = true
        rtmpStream.captureSettings = [
            "sessionPreset": AVCaptureSession.Preset.hd1280x720.rawValue,
            "continuousAutofocus": true,
            "continuousExposure": true
        ]
        rtmpStream.videoSettings = [
            "width": 720,
            "height": 1280
        ]
        rtmpStream.audioSettings = [
            "sampleRate": sampleRate
        ]
       //  rtmpStream.mixer.recorder.delegate = ExampleRecorderDelegate()
        
         rtmpStream.mixer.recorder.delegate = recorderDelegate
        self.cofigarmenu()
     
     
        // Do any additional setup after loading the view.
    }
    
   
    
    func cofigarmenu() {
        let configuration = FTConfiguration.shared
        configuration.menuRowHeight = 50
        configuration.menuWidth = 100
        configuration.textColor = UIColor.black
        configuration.borderColor = UIColor.white
        configuration.backgoundTintColor = UIColor.white
        configuration.borderWidth = 2.0
        configuration.textAlignment = .center
    }
    
    
    @objc func willResignActive(_ notification: Notification) {
         let state: UIApplicationState = UIApplication.shared.applicationState
         if state == .background {
            rtmpStream.pause()
            // background
        }
        else if state == .active {
            rtmpStream.resume()
             // foreground
        }
    }
    
    
    fileprivate func intialLoadingRMTP() {
        rtmpStream.mixer.recorder.delegate = recorderDelegate
    }
    
  
    
    func setnetworkdata() {
       Common.setRoundlabel(label: self.livesttuslabel, radius: 10.0)
       Common.setimageviewborderwithcolor(imageview: networkimageview, borderwidth: 1.0, bordercolor: UIColor.white)
        Common.setRoundimageview(imageview: networkimageview, radius: 5.0)
       let networktype = Common.getnetworktype()
        networkname.text = networktype
         if(networktype == "WiFi")
        {
        networkimageview.image = #imageLiteral(resourceName: "wifi")
            
        }
        else
        {
            networkimageview.image =  #imageLiteral(resourceName: "celluar")

        }
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        logger.info("viewWillAppear")
        super.viewWillAppear(animated)
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio)) { error in
            logger.warn(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
            logger.warn(error.description)
        }
        rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: .new, context: nil)
        lfView?.attachStream(rtmpStream)
    }
    

    @objc func rotateddd()
    {
        
   
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
            {
                
                
                rtmpStream.videoSettings = [
                    "width": UIScreen.main.bounds.size.width,
                    "height": UIScreen.main.bounds.size.height
                ]
                
                
               // rtmpStream.orientation = .landscapeLeft
//                rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
//                    logger.warn(error.description)
//
//            }
        }
            
            if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
            {
                rtmpStream.videoSettings = [
                    "width": UIScreen.main.bounds.size.width,
                    "height": UIScreen.main.bounds.size.height
                ]
                //rtmpStream.orientation = .portrait
//             rtmpStream.attachCamera(DeviceUtil.device(withPosition: currentPosition)) { error in
//                    logger.warn(error.description)
//            }
        }
        
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
         logger.info("viewWillDisappear")
        super.viewWillDisappear(animated)
        rtmpStream.removeObserver(self, forKeyPath: "currentFPS")
        rtmpStream.close()
        rtmpStream.dispose()
        AppUtility.lockOrientation([.portrait])
    }
    
    @IBAction func taptoshowactionview(_ sender: UIButton) {
        actionview.isHidden = false
        actionviewbutton.isHidden = true
    }
    @IBAction func taptobitrate(_ sender: UISlider) {
        
        bitratelabel?.text = "video \(Int(sender.value))/kbps"
        rtmpStream.videoSettings["bitrate"] = sender.value * 1024
        
    }
    
    @IBAction func Taptoback(_ sender: UIButton) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
        
    }
    @IBAction func Taptozoom(_ sender: UISlider) {
    rtmpStream.setZoomFactor(CGFloat(sender.value), ramping: true, withRate: 5.0)
        
    }
    @IBAction func taptoResolution(_ sender: UIButton) {
    
 
         let values = ["1080p", "720p", "480p"]
          FTPopOverMenu.showForSender(sender: sender,
                                    with: values,
                                    done: { (selectedIndex) -> () in
                                        print(selectedIndex)
                 
                                        
               let strem = (values[selectedIndex] as? String)!
               self.selectedstenres = strem
              self.setstreen(strem: strem)
                                        
                                        
                                        
        }) {
            
        }
        
        
        

//
//        DPPickerManager.shared.showPicker(title: "Resolution", selected: self.selectedstenres, strings: values) { (value, index, cancel) in
//            if !cancel {
//                let strem = (value as? String)!
//                print(strem)
//                self.selectedstenres = strem
//
//                if(strem == "1080p") {
//
//                    self.rtmpStream.videoSettings = [
//                        "width": 1920, // video output width
//                        "height": 1080, // video output height
//                    ]
//                    self.rtmpStream.videoSettings["bitrate"] = 3000 * 1024
//                    self.rtmpStream.audioSettings["bitrate"] = 320 * 1024
//                    // Update the ui
//                    self.videoBitrateSlider?.value = 3000
//                    self.bitratelabel?.text = "Video Bitrate 3000kbps"
//
//                }
//                else if(strem == "720p") {
//                    self.rtmpStream.videoSettings = [
//                        "width": 1280, // video output width
//                        "height": 720, // video output height
//                    ]
//                    self.rtmpStream.videoSettings["bitrate"] = 1500 * 1024
//                    self.rtmpStream.audioSettings["bitrate"] = 160 * 1024
//
//                    // Update the ui
//                    self.videoBitrateSlider?.value = 1500
//                    self.bitratelabel?.text = "Video Bitrate 1500kbps"
//
//
//                }
//                else if(strem == "480p") {
//                    self.rtmpStream.videoSettings = [
//                        "width": 854, // video output width
//                        "height": 480, // video output height
//                    ]
//                    self.rtmpStream.videoSettings["bitrate"] = 500 * 1024
//                    self.rtmpStream.audioSettings["bitrate"] = 160 * 1024
//
//                    // Update the ui
//                    self.videoBitrateSlider?.value = 500
//                    self.bitratelabel?.text = "Video Bitrate 500kbps"
//
//
//                }
//
//            }
//        }
//
//
        
        
        
    }
    
    
    func setstreen(strem:String) {
        if(strem == "1080p") {
            
            self.rtmpStream.videoSettings = [
                "width": UIScreen.main.bounds.size.width, // video output width
                "height": UIScreen.main.bounds.size.height, // video output height
            ]
            self.rtmpStream.videoSettings["bitrate"] = 3000 * 1024
            self.rtmpStream.audioSettings["bitrate"] = 320 * 1024
            // Update the ui
            self.videoBitrateSlider?.value = 3000
            self.bitratelabel?.text = "Video Bitrate 3000kbps"
            
        }
        else if(strem == "720p") {
            self.rtmpStream.videoSettings = [
                "width": UIScreen.main.bounds.size.width, // video output width
                "height": UIScreen.main.bounds.size.height, // video output height
            ]
            self.rtmpStream.videoSettings["bitrate"] = 1500 * 1024
            self.rtmpStream.audioSettings["bitrate"] = 160 * 1024
            
            // Update the ui
            self.videoBitrateSlider?.value = 1500
            self.bitratelabel?.text = "Video Bitrate 1500kbps"
            
            
        }
        else if(strem == "480p") {
            self.rtmpStream.videoSettings = [
                "width": UIScreen.main.bounds.size.width, // video output width
                "height": UIScreen.main.bounds.size.height, // video output height
            ]
            self.rtmpStream.videoSettings["bitrate"] = 500 * 1024
            self.rtmpStream.audioSettings["bitrate"] = 160 * 1024
            
            // Update the ui
            self.videoBitrateSlider?.value = 500
            self.bitratelabel?.text = "Video Bitrate 500kbps"
            
            
        }
    }
    
    @IBAction func tapToSavecamerarool(_ sender: UISwitch) {
        
       if(rtmpConnection.connected)
       {
        Common.Showalert(view: self, text: "Can't change setting because Strem is conneted, want change setting please disconnect this session and change.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("do some work")
            if(self.switchbutton.isOn)
            {
                self.switchbutton.isOn = false
                
            }
            else {
                self.switchbutton.isOn = true
            }
        }
        
        return
        }
 
       if(sender.isOn)
       {
        Issavelocal = true
        }
        else
       {
         Issavelocal = false
        }
        
        
    }
    
    
   
    
    @IBAction func TaptoFlipcarema(_ sender: UIButton) {
        
        logger.info("rotateCamera")
        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { error in
            logger.warn(error.description)
        }
        currentPosition = position
        
        
    }
    @IBAction func tapTotourch(_ sender: UIButton) {
        
       let avDevice = AVCaptureDevice.default(for: .video)
                 // check if the device has torch
                if (avDevice?.hasTorch)! {
          if sender.isSelected {
            sender.setImage(#imageLiteral(resourceName: "Torchdisable"), for: UIControlState())
 
        }
          else{
            sender.setImage(#imageLiteral(resourceName: "Torchenable"), for: UIControlState())
        }
         sender.isSelected = !sender.isSelected
         rtmpStream.torch = !rtmpStream.torch
        }
        else
                {
                Common.Showalert(view: self, text: "Torch not avilable")
        }
    }
    @IBAction func tapTohideaction(_ sender: UIButton) {
        
      actionview.isHidden = true
      actionviewbutton.isHidden = false
        
        
    }
    
    @IBAction func tapTobrodcasting(_ sender: UIButton) {
        
        
        
       if(!Common.isInternetAvailable())
       {
        Common.Showalert(view: self, text: "Please check your internet connection")
        return
        }
        
      
        
        if sender.isSelected {
              UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector: #selector(rtmpStatusHandler), observer: self)
              networkview.isHidden = true
              sender.setImage(#imageLiteral(resourceName: "Startlive"), for: UIControlState())
            if(Issavelocal)
            {
             Common.Showalert(view: self, text: "Recording saved to  local memory")
            }
           
            
        } else {
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(Event.RTMP_STATUS, selector: #selector(rtmpStatusHandler), observer: self)
            rtmpConnection.connect(Preference.defaultInstance.uri!)
               sender.setImage(#imageLiteral(resourceName: "Stoplive"), for: UIControlState())
            networkview.isHidden = false
            self.setnetworkdata()
            
        }
        sender.isSelected = !sender.isSelected
        
    }
   
 
   
    
    @objc func rtmpStatusHandler(_ notification: Notification) {
        let e: Event = Event.from(notification)
        if let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                if(Issavelocal)
                {
                  rtmpStream.publish(Preference.defaultInstance.streamName!, type: .localRecord)
                }
                else
                {
                  rtmpStream!.publish(Preference.defaultInstance.streamName!)
                }
             //rtmpStream!.publish(Preference.defaultInstance.streamName!)
             // sharedObject!.connect(rtmpConnection)
           // rtmpStream.publish(Preference.defaultInstance.streamName!, type: .localRecord)
           
                
                
            default:
                break
            }
        }
    }
    
    @IBAction func TaptoMenu(_ sender: UIButton) {
        
       if(bitratenamelabel.isHidden)
       {
        bitratenamelabel.isHidden = false
        videoBitrateSlider.isHidden = false
        bitratelabel.isHidden = false
        
        }
        else
       {
        bitratenamelabel.isHidden = true
        videoBitrateSlider.isHidden = true
        bitratelabel.isHidden = true
        }

    }
    @IBAction func Taptosound(_ sender: UIButton) {
      
        if sender.isSelected {
             sender.setImage(#imageLiteral(resourceName: "Soundunmute"), for: UIControlState())
             rtmpStream.audioSettings = [
                "muted": false, // mute audio
             ]
            
            
                   }
        else{
              sender.setImage(#imageLiteral(resourceName: "Sondmute"), for: UIControlState())
            rtmpStream.audioSettings = [
                "muted": true, // unmute audio
            ]
 
        }
        sender.isSelected = !sender.isSelected
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getuploadingspped(bynerpersec:Int32) -> String {
        

        var uploadingspped:Float = Float(bynerpersec/100)
        if(uploadingspped < 990)
        {
            let retunsrt = "\(uploadingspped) Kbps"
            return retunsrt
        }
        else {
            
            uploadingspped = uploadingspped/1000
            let retunsrt = "\(uploadingspped) mbps"
             return retunsrt
            
        }
        
        
    }
  
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if Thread.isMainThread {
           
            
       
          print(" currentBytesPerSecond ======== \(rtmpStream.info.currentBytesPerSecond)")
            
           sppedlabel.text = self.getuploadingspped(bynerpersec: rtmpStream.info.currentBytesPerSecond)
          
            
       //     print(" RTMP FPS ======== \(rtmpStream.currentFPS)")
         }
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
