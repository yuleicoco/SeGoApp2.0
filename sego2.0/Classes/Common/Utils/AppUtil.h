//
//  AppUtil.h
//  sego2.0
//
//  Created by yulei on 16/11/9.
//  Copyright © 2016年 yulei. All rights reserved.
//

//  存放公用方法



#import <Foundation/Foundation.h>
#define GREEN_COLOR RGB(73, 195, 241)
#define GRAY_COLOR RGB(205, 205, 193)


@interface AppUtil : NSObject

+ (UIViewController *)appTopViewController;
+ (NSString *)getServerSego3;
+ (BOOL) isBlankString:(NSString *)string;
+ (BOOL) isValidateMobile:(NSString *)mobile;
@end
