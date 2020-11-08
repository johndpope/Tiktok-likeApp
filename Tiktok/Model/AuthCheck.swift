//
//  AuthCheck.swift
//  Swift6TikTok
//
//  Created by Yuta Fujii on 2020/07/25.
//

import Foundation
import Photos

class AuthCheck {
    
    func cameraCheck(){
        
        // ユーザーに許可を促す.
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch(status){
            case .authorized:
                print("Authorized")
                
            case .denied:
                print("Denied")
                
            case .notDetermined:
                print("NotDetermined")
                
            case .restricted:
                print("Restricted")
            @unknown default:
                return
            }
            
        }
        
    }
    
}
