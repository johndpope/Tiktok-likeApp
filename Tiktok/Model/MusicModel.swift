//
//  MusicModel.swift
//  Tiktok
//
//  Created by Yoshihiro Uda on 2020/11/12.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol MusicProtocol {
    func catchData(count:Int)
}

class MusicModel{
    
    //    //アーティスト名
    //    var artistName:String?
    //    //曲名
    //    var trackCensoredName:String?
    //    //音源URL
    //    var preViewUrl:String?
    //    //ジャケット
    //    var artworkUrl100:String?
    
    var artistNameArray = [String]()
    var trackCensoredNameArray = [String]()
    var preViewUrlArray = [String]()
    var artworkUrl100Array = [String]()
    
    var musicDelegate:MusicProtocol?
    
    //JSON解析
    
    func setData(resultCount:Int, encodeUrlString:String){
        
        //通信
        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            //まず配列を空にする
            self.artistNameArray.removeAll()
            self.trackCensoredNameArray.removeAll()
            self.preViewUrlArray.removeAll()
            self.artworkUrl100Array.removeAll()
            
            switch response.result{
            
            case .success:
                
                do {
                    let json:JSON = try JSON(data: response.data!)
                    
                    for i in 0...resultCount - 1{
                        
                        //ヒットしないものが検索された場合
                        if json["results"][i]["artistName"].string == nil{
                            print("ヒットしませんでした。")
                            return
                        }
                        
                        self.artistNameArray.append(json["results"][i]["artistName"].string!)
                        self.trackCensoredNameArray.append(json["results"][i]["trackCensoredName"].string!)
                        self.preViewUrlArray.append(json["results"][i]["previewUrl"].string!)
                        self.artworkUrl100Array.append(json["results"][i]["artworkUrl100"].string!)
                        
                    }
                    //すべてのデータ取得完了している状態
                    //selectVCでrelodedataでは通信中に更新する可能性があるので、発動するのは完了確認後のココとなる
                    self.musicDelegate?.catchData(count: 1)
                    
                } catch {
                }
                break
                
            case .failure(_): break
                
            }
            
        }
    }
    
}
