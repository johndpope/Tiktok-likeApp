//
//  SelectViewController.swift
//  Tiktok
//
//  Created by Yoshihiro Uda on 2020/11/11.
//

import UIKit
import SDWebImage
import AVFoundation
import SwiftVideoGenerator


class SelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var musicModel = MusicModel()
    var player:AVAudioPlayer?
    var videoPath = String()
    var passedURL:URL?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicModel.artistNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.isHighlighted = false
        
        let artWorkImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let musicNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let artistNameLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        artWorkImageView.sd_setImage(with: URL(string: musicModel.artworkUrl100Array[indexPath.row]), completed: nil)
        musicNameLabel.text = musicModel.trackCensoredNameArray[indexPath.row]
        artistNameLabel.text = musicModel.artistNameArray[indexPath.row]
        
        //プログラムでボタン作成(ラベルの横)
        let favButton = UIButton(frame: CGRect(x: 330, y: 39, width: 40, height: 33))
        favButton.setImage(UIImage(named: "fav"), for: .normal)
        favButton.addTarget(self, action: #selector(favButtonTap(_:)), for: .touchUpInside)
        favButton.tag = indexPath.row
        cell.contentView.addSubview(favButton)
        
        //プログラムでボタン作成(ImageViewの上)
        let playButton = UIButton(frame: CGRect(x: 20, y: 5, width: 100, height: 100))
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTap(_:)), for: .touchUpInside)
        playButton.tag = indexPath.row
        cell.contentView.addSubview(playButton)
        
        return cell
    }
    
    
    @objc func playButtonTap(_ sender:UIButton){
        
        //音楽を止める
        if player?.isPlaying == true{
            
            player?.stop()
        }
        
        let url = URL(string: musicModel.preViewUrlArray[sender.tag])
        
    }
    
    
    func downLoadMusicURL(url:URL){
        
        
        
        
    }
    
    
    
    func refleshData(){
        
        if searchTextField.text?.isEmpty != nil{
            
            let urlString = "http;//itunes.apple.com/search?term=\(String(describing:searchTextField.text))&entity=song&country=jp"
            
            let encordUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            musicModel.setData(resultCount: 50, encodeUrlString: encordUrlString)
            searchTextField.resignFirstResponder()
            
        }
        
    }

}
