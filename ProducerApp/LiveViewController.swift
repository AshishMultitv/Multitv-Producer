//
//  LiveViewController.swift
//  ProducerApp
//
//  Created by Cybermac002 on 03/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit
import LFLiveKit


class LiveViewController: UIViewController,LFLiveSessionDelegate {
    
    var selectedstenres:String = ""
    var actionview = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight])
          NotificationCenter.default.addObserver(self, selector: #selector(rotateddd), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
         // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
         session.delegate = self
        session.preView = self.view
        
        session.saveLocalVideo = true
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
          //print(session.streamInfo?.videoConfiguration.sessionPreset.hashValue)
       //on.streamInfo?.videoConfiguration.sessionPreset = .captureSessionPreset360x640
         self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        
    
 
       //  self.addcontainerview()
       //  containerView.addSubview(stateLabel)
      //   containerView.addSubview(beautyButton)
         containerView.addSubview(startLiveButton)
        containerView.addSubview(sundbutton)
        containerView.addSubview(settingbutton)
        containerView.addSubview(closebutton)
        containerView.addSubview(tourchButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(liveback)
        containerView.addSubview(savetocamerarool)
        containerView.addSubview(saveswitch)
        containerView.addSubview(videoresultionButton)
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        beautyButton.addTarget(self, action: #selector(didTappedBeautyButton(_:)), for: .touchUpInside)
        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
        closebutton.addTarget(self, action: #selector(didTappedCloseButton(_:)), for: .touchUpInside)
        liveback.addTarget(self, action: #selector(didTappedLiveback(_:)), for: .touchUpInside)
        tourchButton.addTarget(self, action: #selector(didTappedtorchButton(_:)), for: .touchUpInside)
        videoresultionButton.addTarget(self, action: #selector(didTappedresolutioButton(_:)), for: .touchUpInside)
       sundbutton.addTarget(self, action: #selector(didTappedsoundButton(_:)), for: .touchUpInside)
       saveswitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        
    }
    
    
    
    @objc func rotateddd()
    {
        
 
        if(session.running) {
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
         {
          
          
            
            session.streamInfo?.videoConfiguration.avSessionPreset
            
            //session.streamInfo?.videoConfiguration.outputImageOrientation = .landscapeLeft
           //  let videoConfiguration =   LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3, outputImageOrientation: .portraitUpsideDown)
            // session.streamInfo?.videoConfiguration = videoConfiguration
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        {
            
            session.streamInfo?.videoConfiguration.outputImageOrientation = .portrait

            
           // session.streamInfo?.videoConfiguration.outputImageOrientation = .portrait

          //  let videoConfiguration =   LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3, outputImageOrientation: .portrait)
         //   session.streamInfo?.videoConfiguration = videoConfiguration
            
        }
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation([.portrait])

    }
    
    
    //MARK: AccessAuth
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status  {
            
        // License dialogue does not appear, initiate licensing
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // Authorization has been turned on and can continue
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // User explicitly denies authorization, or camera device cannot access
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
         let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status  {
         //License dialogue does not appear, initiate licensing
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
             })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
 
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "not connected"
            break;
        case LFLiveState.pending:
            stateLabel.text = "connecting"
            break;
        case LFLiveState.start:
            stateLabel.text = "connected"
            break;
        case LFLiveState.error:
            stateLabel.text = "connection error"
            break;
        case LFLiveState.stop:
            stateLabel.text = "not connected"
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
   @objc func didTappedsoundButton(_ button: UIButton) -> Void {
    
    
     if(session.muted)
     {
       session.muted = false
    }
    else
     {
        session.muted = false

    }
    
    
    
    }
    
   @objc func didTappedresolutioButton(_ button: UIButton) -> Void {
        // Strings Picker
        let values = ["360x640", "540x960", "720x1280"]
        DPPickerManager.shared.showPicker(title: "Resolution", selected: self.selectedstenres, strings: values) { (value, index, cancel) in
            if !cancel {
                 let strem = (value as? String)!
                print(strem)
                self.selectedstenres = strem
                
                if(strem == "360x640") {
            self.session.streamInfo?.videoConfiguration.sessionPreset = .captureSessionPreset360x640
                    
                }
                else if(strem == "540x960") {
           self.session.streamInfo?.videoConfiguration.sessionPreset = .captureSessionPreset540x960

                }
                else if(strem == "720x1280") {
            self.session.streamInfo?.videoConfiguration.sessionPreset = .captureSessionPreset720x1280

                }

            }
        }
        
   
            
            
    }
    

    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            
           
            print("Switch is on ")
        }
        else {
            
            print("Switch is off ")
        }
        
        
    }
    
    @objc func didTappedtorchButton(_ button: UIButton) -> Void {
        
        if(session.torch) {
            session.torch = false
        }
        else
        {
            session.torch = true
        }
        
        
//          let avDevice = AVCaptureDevice.default(for: .video)
//         // check if the device has torch
//        if (avDevice?.hasTorch)! {
//            // lock your device for configuration
//            do {
//                let abv = try avDevice?.lockForConfiguration()
//            } catch {
//                print("aaaa")
//            }
//
//            // check if your torchMode is on or off. If on turns it off otherwise turns it on
//            if (avDevice?.isTorchActive)! {
//                avDevice?.torchMode = AVCaptureDevice.TorchMode.off
//            } else {
//                // sets the torch intensity to 100%
//                do {
//                    let abv = try avDevice?.setTorchModeOn(level: 1.0)
//                } catch {
//                    print("bbb")
//                }
//                //    avDevice.setTorchModeOnWithLevel(1.0, error: nil)
//            }
//            // unlock your device
//            avDevice?.unlockForConfiguration()
//        }
        
    }
    
    

    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        startLiveButton.isSelected = !startLiveButton.isSelected;
        if (startLiveButton.isSelected) {
            startLiveButton.setImage(#imageLiteral(resourceName: "Stoplive"), for: UIControlState())
           // startLiveButton.setTitle("End the broadcast", for: UIControlState())
            let stream = LFLiveStreamInfo()
            stream.url = AppData.RtmpUrl
            session.startLive(stream)
           // session.streamInfo?.videoConfiguration.autorotate = true
        } else {
            startLiveButton.setImage(#imageLiteral(resourceName: "Startlive"), for: UIControlState())
           // startLiveButton.setTitle("Start live", for: UIControlState())
            session.stopLive()
        }
    }
    
 
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
 
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
    }
    
   
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
        
        
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
    }
    
   
    @objc func didTappedCloseButton(_ button: UIButton) -> Void  {
 
        
        
        if(settingbutton.isHidden)
        {
            sundbutton.isHidden = false
            settingbutton.isHidden = false
            tourchButton.isHidden = false
            cameraButton.isHidden = false
            liveback.isHidden = false
            savetocamerarool.isHidden = false
            saveswitch.isHidden = false
            videoresultionButton.isHidden = false
             closebutton.setImage(#imageLiteral(resourceName: "Close"), for: UIControlState())

            
            
         }
        else
        {
        
             sundbutton.isHidden = true
            settingbutton.isHidden = true
             tourchButton.isHidden = true
            cameraButton.isHidden = true
             savetocamerarool.isHidden = true
            saveswitch.isHidden = true
            videoresultionButton.isHidden = true
            closebutton.setImage(#imageLiteral(resourceName: "Timer"), for: UIControlState())
 
            
            
        }
      
        
    }
    
    
    @objc func didTappedLiveback(_ button: UIButton) -> Void  {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is HomeViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
        // self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - Getters and Setters
    
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
       
         let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
         return session!
    }()
    

    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        return containerView
    }()
    

    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "not connected"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    
    
    
    
    var savetocamerarool: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 10, y: UIScreen.main.bounds.height - 100, width: 150, height: 40))
        stateLabel.text = "Save To Camera Rool"
        stateLabel.font = UIFont.init(name: "Lato", size: 14)
        stateLabel.textColor = UIColor.white
        //stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
  
    var saveswitch: UISwitch = {
        
        let saveswitch  = UISwitch.init(frame: CGRect(x:160, y:UIScreen.main.bounds.height - 95, width: 44, height: 44))
        saveswitch.isOn = false
         return saveswitch
    }()
    
    
    var videoresultionButton: UIButton = {
        let tourchButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 60, y: UIScreen.main.bounds.height - 100, width: 44, height: 44))
        tourchButton.setImage(#imageLiteral(resourceName: "Setting"), for: UIControlState())
        return tourchButton
    }()
    
    
    
    var sundbutton: UIButton = {
        let sundbutton = UIButton(frame: CGRect(x:10, y:UIScreen.main.bounds.height - 50, width: 44, height: 44))
        sundbutton.setImage(#imageLiteral(resourceName: "Soundunmute"), for: UIControlState())
        return sundbutton
    }()
    
    var settingbutton: UIButton = {
        let settingbutton = UIButton(frame: CGRect(x:(UIScreen.main.bounds.width/4), y:UIScreen.main.bounds.height - 50, width: 44, height: 44))
        settingbutton.setImage(#imageLiteral(resourceName: "Setting"), for: UIControlState())
        return settingbutton
    }()
    
    var closebutton: UIButton = {
        let closebutton = UIButton(frame: CGRect(x:(UIScreen.main.bounds.width/2)-22 , y: UIScreen.main.bounds.height - 50, width: 44, height: 44))
        closebutton.setImage(#imageLiteral(resourceName: "Close"), for: UIControlState())
        return closebutton
    }()
    
    
    
    var tourchButton: UIButton = {
        let tourchButton = UIButton(frame: CGRect(x:(3*UIScreen.main.bounds.width/4)-32, y: UIScreen.main.bounds.height - 50, width: 44, height: 44))
        tourchButton.setImage(#imageLiteral(resourceName: "Torchdisable"), for: UIControlState())
        return tourchButton
    }()
    
    
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54, y: UIScreen.main.bounds.height-50, width: 44, height: 44))
        cameraButton.setImage(#imageLiteral(resourceName: "Flipcamera"), for: UIControlState())
        return cameraButton
    }()
    
    var liveback: UIButton = {
        let liveback = UIButton(frame: CGRect(x: 20, y: 30, width: 44, height: 44))
        liveback.setImage(#imageLiteral(resourceName: "Liveback"), for: UIControlState())
        return liveback
    }()
    

    

    var beautyButton: UIButton = {
        let beautyButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 3, y: 20, width: 44, height: 44))
        beautyButton.setImage(UIImage(named: "camra_beauty"), for: UIControlState.selected)
        beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: UIControlState())
        return beautyButton
    }()

    var startLiveButton: UIButton = {
        let startLiveButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 25, y: UIScreen.main.bounds.height/2 - 25, width:100, height: 100))
      //  startLiveButton.layer.cornerRadius = 22
        startLiveButton.setTitleColor(UIColor.black, for:UIControlState())
        startLiveButton.setImage(#imageLiteral(resourceName: "Startlive"), for: UIControlState())
       // startLiveButton.setTitle("Start live", for: UIControlState())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
       // startLiveButton.backgroundColor = UIColor.init(red: 50/255, green: 32/255, blue: 245/255, alpha: 1.0)
          return startLiveButton
    }()
}


