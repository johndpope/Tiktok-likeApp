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
    
    var videoURL:URL?
    
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
        
        //動画のみ閲覧できるアルバム起動
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.mediaTypes = ["public.movie"]
        imagePickerController.allowsEditing = false
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    //キャンセルの場合、閉じる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //選択された後
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaURL = info[.mediaURL] as? URL
        videoURL = mediaURL
        
        //閉じる
        picker.dismiss(animated: true, completion: nil)
        
        //値を渡しながら画面遷移
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard?.instantiateViewController(identifier: "EditVC") as! EditViewController
        editVC.url = videoURL
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureButton.delegate = self
    }
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did start running")
        captureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: SwiftyCamViewController) {
        print("Session did stop running")
        captureButton.buttonEnabled = false
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        hideButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        showButtons()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        
        //ここで撮影後生成されたURLが入っていくる
        print(url.debugDescription)
        
        //値を渡しながら画面遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        videoURL = url
        editVC.url = videoURL
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print("Did focus at point: \(point)")
        focusAnimationAt(point)
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: SwiftyCamViewController) {
        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
        let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print("Zoom level did change. Level: \(zoom)")
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print("Camera did change to \(camera.rawValue)")
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        switchCamera()
    }
    
    
    func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flipCameraButton.alpha = 0.0
        }
    }
    func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flipCameraButton.alpha = 1.0
        }
    }
    
    
    func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    
}
