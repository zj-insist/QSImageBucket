//
//  QSUtils.h
//  AliOSSTest
//
//  Created by ZJ-Jie on 2017/8/4.
//  Copyright © 2017年 Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSUtils : NSObject

+ (NSString *)calBase64Sha1WithData:(NSString *)data withSecret:(NSString *)key;

+ (NSString*)calBase64WithData:(uint8_t *)data;

@end
