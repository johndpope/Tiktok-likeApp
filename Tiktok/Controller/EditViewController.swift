//
//  EditViewController.swift
//  Tiktok
//
//  Created by Yoshihiro Uda on 2020/11/11.
//

import UIKit
import AVKit

class EditViewController: UIViewController {
    
    var url:URL?
    var playerController:AVPlayerViewController?
    var player:AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUPVideoPlayer(url: url!)
    }

   
    func setUPVideoPlayer(url:URL){
        
        //戻ってき場合などに重なりを防ぐため取り除く
        playerController?.removeFromParent()
        player = nil
        
        view.backgroundColor = .black
        
        playerController = AVPlayerViewController()
        playerController?.videoGravity = .resizeAspectFill
        playerController?.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 100)
        playerController?.showsPlaybackControls = false
        playerController?.player = player!
        self.addChild(playerController!)
        self.view.addSubview((playerController?.view)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        //キャンセルボタンを作成
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(named: "cancel"), for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        player?.play()
        
    }
    
    
    @objc func cancel(){
        
        //画面を戻る
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @objc func playerItemDidReachEnd(){
        
        //くり返し
        if self.player != nil{
            
            self.player?.seek(to: CMTime.zero)
            self.player?.volume = 1
            self.player?.play()
            
        }
    }
    
    

}
