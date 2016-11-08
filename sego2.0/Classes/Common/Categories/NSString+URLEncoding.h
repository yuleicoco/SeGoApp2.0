//
//  NSString+URLEncoding.h
//  MyPhoneGap
//
//
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)


-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;
-(BOOL)isEmptyString;

- (NSString *)md5Encrypt;

/**
 * 字符串转unicode编码
 */
-(NSString *)utf8ToUnicode;

/**
 * unicode转utf8字符串
 */
-(NSString*)replaceUnicode;

@end
