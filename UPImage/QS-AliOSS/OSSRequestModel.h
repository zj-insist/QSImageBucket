//
//  OSSRequestModel.h
//  AliOSSTest
//
//  Created by ZJ-Jie on 2017/8/4.
//  Copyright © 2017年 Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OSSClientErrorCODE) {
    OSSClientErrorCodeNetworkingFailWithResponseCode0,
    OSSClientErrorCodeSignFailed,
    OSSClientErrorCodeFileCantWrite,
    OSSClientErrorCodeInvalidArgument,
    OSSClientErrorCodeNilUploadid,
    OSSClientErrorCodeTaskCancelled,
    OSSClientErrorCodeNetworkError,
    OSSClientErrorCodeCannotResumeUpload,
    OSSClientErrorCodeExcpetionCatched,
    OSSClientErrorCodeNotKnown
};

/**
 扩展NSString
 */
@interface NSString (OSS)
- (NSString *)oss_stringByAppendingPathComponentForURL:(NSString *)aString;
- (NSString *)oss_trim;
@end

/**
 扩展NSDictionary
 */
@interface NSDictionary (OSS)
- (NSString *)base64JsonString;
@end

/**
 扩展NSDate
 */
@interface NSDate (OSS)
+ (void)oss_setStandardTimeIntervalSince1970:(NSTimeInterval)standardTime;
+ (void)oss_setClockSkew:(NSTimeInterval)clockSkew;
+ (NSDate *)oss_dateFromString:(NSString *)string;
+ (NSDate *)oss_clockSkewFixedDate;
- (NSString *)oss_asStringValue;
@end

/**
 请求头的基类
 */
@interface OSSRequest : NSObject
/**
 指明该请求是否需要鉴权，单次有效
 */
@property (nonatomic, assign) BOOL isAuthenticationRequired;

/**
 指明该请求是否已经被取消
 */
@property (nonatomic, assign) BOOL isCancelled;

/**
 取消这个请求
 */
- (void)cancel;
@end


/**
 请求结果的基类
 */
@interface OSSResult : NSObject

/**
 请求HTTP响应码
 */
@property (nonatomic, assign) NSInteger httpResponseCode;

/**
 请求HTTP响应头部，以KV形式放在字典中
 */
@property (nonatomic, strong) NSDictionary * httpResponseHeaderFields;

/**
 x-oss-request-id是由Aliyun OSS创建，并唯一标识这个response的UUID。如果在使用OSS服务时遇到问题，可以凭借该字段联系OSS工作人员，快速定位问题。
 */
@property (nonatomic, strong) NSString * requestId;
@end



/**
 CredentialProvider协议，要求实现加签接口
 */
@protocol OSSCredentialProvider <NSObject>
@optional
- (NSString *)sign:(NSString *)content error:(NSError **)error;
@end

/**
 用明文AK/SK实现的加签器，建议只在测试模式时使用
 */

@interface OSSPlainTextAKSKPairCredentialProvider : NSObject <OSSCredentialProvider>
@property (nonatomic, strong) NSString * accessKey;
@property (nonatomic, strong) NSString * secretKey;

- (instancetype)initWithPlainTextAccessKey:(NSString *)accessKey
                                 secretKey:(NSString *)secretKey;
@end

/**
 OSSClient可以设置的参数
 */
@interface OSSClientConfiguration : NSObject

/**
 最大重试次数
 */
@property (nonatomic, assign) uint32_t maxRetryCount;

/**
 最大并发请求数
 */
@property (nonatomic, assign) uint32_t maxConcurrentRequestCount;

/**
 是否开启后台传输服务
 注意：只在上传文件时有效
 */
@property (nonatomic, assign) BOOL enableBackgroundTransmitService;

/**
 是否使用Httpdns解析域名
 */
@property (nonatomic, assign) BOOL isHttpdnsEnable;

/**
 设置后台传输服务使用session的Id
 */
@property (nonatomic, strong) NSString * backgroundSesseionIdentifier;

/**
 请求超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForRequest;

/**
 单个Object下载的最长持续时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutIntervalForResource;

/**
 设置代理Host、端口
 */
@property (nonatomic, strong) NSString * proxyHost;
@property (nonatomic, strong) NSNumber * proxyPort;

/**
 设置Cname排除列表
 */
@property (nonatomic, strong, setter=setCnameExcludeList:) NSArray * cnameExcludeList;

@end

/**
 上传Object的请求头
 */
@interface OSSPutObjectRequest : OSSRequest

/**
 Bucket名称
 */
@property (nonatomic, strong) NSString * bucketName;

/**
 Object名称
 */
@property (nonatomic, strong) NSString * objectKey;

/**
 从内存中的NSData上传时，通过这个字段设置
 */
@property (nonatomic, strong) NSData * uploadingData;

/**
 从文件上传时，通过这个字段设置
 */
@property (nonatomic, strong) NSURL * uploadingFileURL;

/**
 server回调参数设置
 */
@property (nonatomic, strong) NSDictionary * callbackParam;

/**
 server回调变量设置
 */
@property (nonatomic, strong) NSDictionary * callbackVar;

/**
 设置文件类型
 */
@property (nonatomic, strong) NSString * contentType;

/**
 根据协议RFC 1864对消息内容（不包括头部）计算MD5值获得128比特位数字，对该数字进行base64编码为一个消息的Content-MD5值。
 该请求头可用于消息合法性的检查（消息内容是否与发送时一致）。虽然该请求头是可选项，OSS建议用户使用该请求头进行端到端检查。
 */
@property (nonatomic, strong) NSString * contentMd5;

/**
 指定该Object被下载时的名称；更详细描述请参照RFC2616。
 */
@property (nonatomic, strong) NSString * contentDisposition;

/**
 指定该Object被下载时的内容编码格式；更详细描述请参照RFC2616。
 */
@property (nonatomic, strong) NSString * contentEncoding;

/**
 指定该Object被下载时的网页的缓存行为；更详细描述请参照RFC2616。
 */
@property (nonatomic, strong) NSString * cacheControl;

/**
 过期时间（milliseconds）；更详细描述请参照RFC2616。
 */
@property (nonatomic, strong) NSString * expires;

/**
 可以在这个字段中携带以x-oss-meta-为前缀的参数，则视为user meta，比如x-oss-meta-location。一个Object可以有多个类似的参数，但所有的user meta总大小不能超过8k。
 如果上传时还需要指定其他HTTP请求头字段，也可以在这里设置
 */
@property (nonatomic, strong) NSDictionary * objectMeta;

/**
 上传进度回调，
 会在任务执行的后台线程被回调，而非UI线程
 */
//@property (nonatomic, copy) OSSNetworkingUploadProgressBlock uploadProgress;
@end

/**
 上传Object的请求结果
 */
@interface OSSPutObjectResult : OSSResult

/**
 ETag (entity tag) 在每个Object生成的时候被创建，用于标示一个Object的内容。
 对于Put Object请求创建的Object，ETag值是其内容的MD5值；对于其他方式创建的Object，ETag值是其内容的UUID。
 ETag值可以用于检查Object内容是否发生变化。
 */
@property (nonatomic, strong) NSString * eTag;

/**
 如果设置了server回调，回调的响应内容
 */
@property (nonatomic, strong) NSString * serverReturnJsonString;
@end

