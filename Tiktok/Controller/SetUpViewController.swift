//
//  SetUpViewController.swift
//  Tiktok
//
//  Created by Yoshihiro Uda on 2020/11/08.
//

import UIKit
import SwiftyCam
import AVFoundation
import MobileCoreServices

class SetUpViewController: SwiftyCamViewController,SwiftyCamViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var captureButton: SwiftyRecordButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SwiftyCamの設定
        shouldPrompToAppSettings = true
        cameraDelegate = self
        maximumVideoDuration = 20.0
        shouldUseDeviceOrientation = false
        allowAutoRotate = false
        audioEnabled = false
        captureButton.buttonEnabled = true
        captureButton.delegate = self
        swipeToZoomInverted = true
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
  
    
    @IBAction func openAlbum(_ sender: Any) {
    }
    
    
    

}
