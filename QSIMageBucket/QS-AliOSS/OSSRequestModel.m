//
//  OSSRequestModel.m
//  AliOSSTest
//
//  Created by ZJ-Jie on 2017/8/4.
//  Copyright © 2017年 Jie. All rights reserved.
//

#import "OSSRequestModel.h"
#import "QSUtils.h"
#import "OSSDefine.h"

@implementation NSString (OSS)

- (NSString *)oss_stringByAppendingPathComponentForURL:(NSString *)aString {
    if ([self hasSuffix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@", self, aString];
    } else {
        return [NSString stringWithFormat:@"%@/%@", self, aString];
    }
}

- (NSString *)oss_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

@implementation NSDictionary (OSS)

- (NSString *)base64JsonString {
    NSError * error;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                        options:0
                                                          error:&error];
    
    if (!jsonData) {
        return @"e30="; // base64("{}");
    } else {
        NSString * jsonStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        NSLog(@"callback json - %@", jsonStr);
        return [[jsonStr dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    }
}

@end

@implementation NSDate (OSS)

NSString * const serverReturnDateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";

static NSTimeInterval _clockSkew = 0.0;

+ (void)oss_setStandardTimeIntervalSince1970:(NSTimeInterval)standardTime {
    NSTimeInterval deviceTime = [[NSDate date] timeIntervalSince1970];
    @synchronized (self) {
        _clockSkew = deviceTime - standardTime;
    }
}

+ (void)oss_setClockSkew:(NSTimeInterval)clockSkew {
    @synchronized(self) {
        _clockSkew = clockSkew;
    }
}

+ (NSDate *)oss_clockSkewFixedDate {
    NSTimeInterval skew = 0.0;
    @synchronized(self) {
        skew = _clockSkew;
    }
    return [[NSDate date] dateByAddingTimeInterval:(-1 * skew)];
}

+ (NSDate *)oss_dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = serverReturnDateFormat;
    
    return [dateFormatter dateFromString:string];
}

- (NSString *)oss_asStringValue {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = serverReturnDateFormat;
    
    return [dateFormatter stringFromDate:self];
}

@end


@implementation OSSPlainTextAKSKPairCredentialProvider

- (instancetype)initWithPlainTextAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey {
    if (self = [super init]) {
        self.accessKey = [accessKey oss_trim];
        self.secretKey = [secretKey oss_trim];
    }
    return self;
}

- (NSString *)sign:(NSString *)content error:(NSError **)error {
    if (!self.accessKey || !self.secretKey) {
        *error = [NSError errorWithDomain:OSSClientErrorDomain
                                     code:OSSClientErrorCodeSignFailed
                                 userInfo:@{OSSErrorMessageTOKEN: @"accessKey or secretKey can't be null"}];
        return nil;
    }
    NSString * sign = [QSUtils calBase64Sha1WithData:content withSecret:self.secretKey];
    return [NSString stringWithFormat:@"OSS %@:%@", self.accessKey, sign];
}

@end

NSString * const BACKGROUND_SESSION_IDENTIFIER = @"com.aliyun.oss.backgroundsession";

@implementation OSSClientConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.maxRetryCount = OSSDefaultRetryCount;
        self.maxConcurrentRequestCount = OSSDefaultMaxConcurrentNum;
        self.enableBackgroundTransmitService = NO;
        self.isHttpdnsEnable = YES;
        self.backgroundSesseionIdentifier = BACKGROUND_SESSION_IDENTIFIER;
        self.timeoutIntervalForRequest = OSSDefaultTimeoutForRequestInSecond;
        self.timeoutIntervalForResource = OSSDefaultTimeoutForResourceInSecond;
    }
    return self;
}

- (void)setCnameExcludeList:(NSArray *)cnameExcludeList {
    NSMutableArray * array = [NSMutableArray new];
    [cnameExcludeList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * host = [(NSString *)obj lowercaseString];
        if ([host containsString:@"://"]) {
            NSString * trimHost = [host substringFromIndex:[host rangeOfString:@"://"].location + 3];
            [array addObject:trimHost];
        } else {
            [array addObject:host];
        }
    }];
    _cnameExcludeList = array.copy;
}

@end

#pragma mark request and result objects

@interface OSSRequest ()
//@property (nonatomic, strong) OSSNetworkingRequestDelegate * requestDelegate;
@end

@implementation OSSRequest

- (instancetype)init {
    if (self = [super init]) {
//        self.requestDelegate = [OSSNetworkingRequestDelegate new];
        self.isAuthenticationRequired = YES;
    }
    return self;
}

- (void)cancel {
    _isCancelled = YES;
    
//    if (self.requestDelegate) {
//        [self.requestDelegate cancel];
//    }
}

@end

@implementation OSSResult
@end

@implementation OSSPutObjectRequest

- (instancetype)init {
    if (self = [super init]) {
        self.objectMeta = [NSDictionary new];
    }
    return self;
}

@end

@implementation OSSPutObjectResult
@end


