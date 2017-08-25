//
//  OSSBucketModel.swift
//  AliOSSTest
//
//  Created by ZJ-Jie on 2017/8/8.
//  Copyright © 2017年 Jie. All rights reserved.
//

import Cocoa

class OSSBucketModel: NSObject {
    
    var creationDate:String = ""
    var extranetEndpoint:String = ""
    var intranetEndpoint:String = ""
    var location:String = ""
    var name:String = ""
    
    init(creationDate:String, extranetEndpoint:String, intranetEndpoint:String, location:String, name:String) {
        self.creationDate = creationDate
        self.extranetEndpoint = extranetEndpoint
        self.intranetEndpoint = intranetEndpoint
        self.location = location
        self.name = name
    }
    
    override init() {}
    
    override var description: String {
        return "creationDate:" + creationDate + "\nextranetEndpoint:" + extranetEndpoint + "\nintranetEndpoint:" + intranetEndpoint + "\nlocation:" + location + "\nname:" + name
    }
}
