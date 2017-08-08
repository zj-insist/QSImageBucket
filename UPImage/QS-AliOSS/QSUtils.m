//
//  QSUtils.m
//  AliOSSTest
//
//  Created by ZJ-Jie on 2017/8/4.
//  Copyright © 2017年 Jie. All rights reserved.
//

#import "QSUtils.h"
//#import "CommonCrypto/CommonDigest.h"
#import "CommonCrypto/CommonHMAC.h"

@implementation QSUtils

+ (NSString *)calBase64Sha1WithData:(NSString *)data withSecret:(NSString *)key {
    NSData *secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [data dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t input[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], input);
    
    return [self calBase64WithData:input];
}

+ (NSString*)calBase64WithData:(uint8_t *)data {
    static char b[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSInteger a = 20;
    NSMutableData* c = [NSMutableData dataWithLength:((a + 2) / 3) * 4];
    uint8_t* d = (uint8_t*)c.mutableBytes;
    NSInteger i;
    for (i=0; i < a; i += 3) {
        NSInteger e = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            e <<= 8;
            if (j < a) {
                e |= (0xFF & data[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        d[index + 0] = b[(e >> 18) & 0x3F];
        d[index + 1] = b[(e >> 12) & 0x3F];
        if ((i + 1) < a) {
            d[index + 2] = b[(e >> 6) & 0x3F];
        } else {
            d[index + 2] = '=';
        }
        if ((i + 2) < a) {
            d[index + 3] = b[(e >> 0) & 0x3F];
        } else {
            d[index + 3] = '=';
        }
    }
    NSString *result = [[NSString alloc] initWithData:c encoding:NSASCIIStringEncoding];
    return result;
}

@end
