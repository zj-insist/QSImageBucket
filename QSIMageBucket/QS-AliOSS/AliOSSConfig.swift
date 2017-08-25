//
//  AliOSSConfig.swift
//  PicU
//
//  Created by ZJ-Jie on 2017/8/8.
//  Copyright © 2017年 chenxt. All rights reserved.
//

import Cocoa
import TMCache

class AliOSSConfig: NSObject,NSCoding,DiskCache  {
    var accessKey: String!
    var bucket:String!
    var secretKey:String!
    var zone:Int!
    var zoneHost:String! {
        get {
            switch zone {
            case 1:
                return "oss-cn-hangzhou.aliyuncs.com"
            case 2:
                return "oss-cn-shanghai.aliyuncs.com"
            case 3:
                return "oss-cn-qingdao.aliyuncs.com"
            case 4:
                return "oss-cn-beijing.aliyuncs.com"
            case 5:
                return "oss-cn-zhangjiakou.aliyuncs.com"
            case 6:
                return "oss-cn-shenzhen.aliyuncs.com"
            case 7:
                return "oss-cn-hongkong.aliyuncs.com"
            default:
                return ""
            }
        }
    }
    
    var location:String! {
        get {
            switch zone {
            case 1:
                return "oss-cn-hangzhou"
            case 2:
                return "oss-cn-shanghai"
            case 3:
                return "oss-cn-qingdao"
            case 4:
                return "oss-cn-beijing"
            case 5:
                return "oss-cn-zhangjiakou"
            case 6:
                return "oss-cn-shenzhen"
            case 7:
                return "oss-cn-hongkong"
            default:
                return ""
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(accessKey, forKey: "accessKey")
        aCoder.encode(bucket, forKey: "bucket")
        aCoder.encode(secretKey, forKey: "secretKey")
        aCoder.encode(zone, forKey: "zone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        accessKey = aDecoder.decodeObject(forKey: "accessKey") as! String
        bucket = aDecoder.decodeObject(forKey: "bucket") as! String
        secretKey = aDecoder.decodeObject(forKey: "secretKey") as! String
        zone = aDecoder.decodeObject(forKey: "zone") as! Int
    }
    
    init(accessKey:String, bucket:String, secretKey:String, zone:Int) {
        self.accessKey = accessKey;
        self.bucket = bucket;
        self.secretKey = secretKey;
        self.zone = zone;
    }

}
