//
//  AppCache.swift
//  U图床
//
//  Created by Pro.chen on 27/12/2016.
//  Copyright © 2016 chenxt. All rights reserved.
//

import Foundation
import TMCache

protocol DiskCache {

}
extension DiskCache where Self : NSCoding{
    func setInCache(_ key:String){
        let cacheDir = NSHomeDirectory() + "/Documents";
        TMCache(name: "picCache", rootPath: cacheDir).setObject(self, forKey: key);
    }
    static func getInCahce(_ key:String)->Self?{
         let cacheDir = NSHomeDirectory() + "/Documents";
        return  TMCache(name: "picCache", rootPath: cacheDir).object(forKey: key) as? Self;
    }
    func removeAllCatch() {
        let cacheDir = NSHomeDirectory() + "/Documents"
        TMCache(name: "picCache", rootPath: cacheDir).removeAllObjects()
        TMCache.shared().removeObject(forKey: "imageCache")
        AppCache.shared.resetAppCache()
    }
    func clearUploadImageCatch() {
        AppCache.shared.imagesCacheArr.removeAll()
        TMCache.shared().removeObject(forKey: "imageCache")
    }
}

class AppCache: NSObject{
    static let shared = AppCache()
    var imagesCacheArr: [[String: AnyObject]] = Array()
    var appConfig : AppConfig!
    var qnConfig : QNConfig!
    var ossConfig : AliOSSConfig!
    fileprivate override init() {
        super.init()
        if let ac =  AppConfig.getInCahce("appConfig") {
            appConfig = ac
        } else {
            appConfig = AppConfig()
        }
        
        ossConfig = AliOSSConfig.getInCahce("AliOSS_User_Config")
        qnConfig = QNConfig.getInCahce("QN_Use_Config")
    }
    func adduploadImageToCache(_ dic: [String: AnyObject]) {
        if imagesCacheArr.count < 5 {
            imagesCacheArr.append(dic)
            TMCache.shared().setObject(imagesCacheArr as NSCoding!, forKey: "imageCache")
        } else {
            imagesCacheArr.remove(at: 0)
            imagesCacheArr.append(dic)
            TMCache.shared().setObject(imagesCacheArr as NSCoding!, forKey: "imageCache")
        }
    }
    func resetAppCache() {
        appConfig = AppConfig()
        ossConfig = nil
        qnConfig = nil
        
        imagesCacheArr.removeAll()
    }
}
