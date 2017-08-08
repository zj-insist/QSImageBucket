//
//  OSSBucketModelParser.swift
//  AliOSSTest
//
//  Created by ZJ-Jie on 2017/8/8.
//  Copyright © 2017年 Jie. All rights reserved.
//

import Cocoa

class OSSBucketModelParser: NSObject,XMLParserDelegate {

    var bucketList:[OSSBucketModel] = []// 用于存放 Person.xml 文件中 person 的列表
    var isBucket:Bool = false // 判断是否解析到开始标签 <Bucket>
    var currentElementValue:String! // 当前解析的标签的值
    var currentCreationDate:String=""// 用于存放当前 <CreationDate> 的值
    var currentExtranetEndpoint:String=""// 用于存放当前 <ExtranetEndpoint> 的值
    var currentIntranetEndpoint:String=""// 用于存放当前 <IntranetEndpoint> 的值
    var currentLocation:String=""// 用于存放当前 <Location> 的值
    var currentName:String=""// 用于存放当前 <Name> 的值
    override init() {}
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        if(elementName == "Bucket"){ // 开始解析一个 Bucket
            isBucket = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)// 移除空格和空行
        self.currentElementValue = str
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(isBucket == true){ // 解析 Bucket 里面的标签
            if(elementName == "CreationDate") {
                currentCreationDate = self.currentElementValue
            } else if(elementName == "ExtranetEndpoint") {
                currentExtranetEndpoint = self.currentElementValue
            } else if(elementName == "IntranetEndpoint") {
                currentIntranetEndpoint = self.currentElementValue
            } else if(elementName == "Location") {
                currentLocation = self.currentElementValue
            } else if(elementName == "Name") {
                currentName = self.currentElementValue
            }
        }
        if(isBucket == true){
            if elementName == "Bucket" { // 表示当前的一个 Bucket 已经解析完毕，构造对象并存储
                let bucket:OSSBucketModel = OSSBucketModel(creationDate: currentCreationDate, extranetEndpoint: currentExtranetEndpoint, intranetEndpoint: currentIntranetEndpoint, location: currentLocation, name: currentName)
                bucketList.append(bucket)
                isBucket = false
            }
        }
    }
    // 如果 xml 文件格式不对或者其他原因解析不了就会执行这个函数
    private func parser(parser: XMLParser, parseErrorOccurred parseError: NSError) {
        print(" 解析错误 ")
        
    }
}
