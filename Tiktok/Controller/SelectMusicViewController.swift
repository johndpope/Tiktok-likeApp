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
    
    var player:AVAudioPlayer?
    var videoPath = String()
    var passedURL:URL?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        
        
    }
    

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    func refleshData(){
        
        if searchTextField.text?.isEmpty != nil{
            
            let urlString = "http;//itunes.apple.com/search?term=\(String(describing:searchTextField.text))&entity=song&country=jp"
            
            let encordUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        }
        
    }

}
