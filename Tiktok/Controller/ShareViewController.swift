//
//  ShareViewController.swift
//  Tiktok
//
//  Created by Yoshihiro Uda on 2020/11/14.
//

import UIKit
import AVKit
import Photos

class ShareViewController: UIViewController {
    
    var captionString = String()
    var passedURL = String()
    var player:AVPlayer?
    var playerController:AVPlayerViewController?
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notification = NotificationCenter.default
        
        notification.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //完成された動画URLの再生
        setUPVideoPlayer(url: URL(string: passedURL)!)
    }
    
    
    func setUPVideoPlayer(url:URL){
        
        self.view.backgroundColor = UIColor.black
        playerController?.removeFromParent()
        player = AVPlayer(url: url)
        self.player?.volume = 1
        
        playerController = AVPlayerViewController()
        playerController?.view.frame = CGRect(x: 0, y: view.frame.size.height * 0.13, width: view.frame.size.width, height: view.frame.size.height * 0.6)
//        playerController!.view.frame = CGRect(x: 29, y: 88, width: 317, height: 455)
        playerController?.videoGravity = .resizeAspectFill
        playerController!.showsPlaybackControls = false
        playerController!.player = player!
        self.addChild(playerController!)
        self.view.addSubview(playerController!.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        player?.play()
        
    }
    
    
    @objc func playerItemDidReachEnd(_ notification:Notification){
        
        //くり返し
        if self.player != nil{
            
            self.player?.seek(to: CMTime.zero)
            self.player?.volume = 1
            self.player?.play()
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    
    
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    
    //動画保存ボタン
    @IBAction func savePhotoLibrary(_ sender: Any) {
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:URL(string: self.passedURL)!)
            
        } completionHandler: { (result, error) in
            
            if error != nil{
                
                print(error.debugDescription)
                return
            }
            
            //trueの場合
            if result{
                
                print("動画保存しました。")
            }
        }

    }
    
    
    @IBAction func share(_ sender: Any) {
        
        //アクティビティViewにアイテムをのせる,share
        let activityItems = [URL(string: passedURL) as Any,"\(textView.text!)\n\(captionString)\n#TikTokApp"] as [Any]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.popoverPresentationController?.sourceRect = self.view.frame
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        player?.pause()
        player = nil
        //最初に戻る
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
}
