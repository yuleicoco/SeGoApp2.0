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
#define GRAY_COLOR RGB(236, 237, 241)
#define LIGHT_GRAYdcdc_COLOR RGB(220, 220, 220)
//分页请求个数
#define REQUEST_PAGE_SIZE           10
#define START_PAGE_INDEX            1
#define LIGHT_GRAY_COLOR RGB(239, 242, 243)
#define M_Wide 375
#define M_Higth 667
#define W_Wide_Zoom [UIScreen mainScreen].bounds.size.width/M_Wide
#define W_Hight_Zoom [UIScreen mainScreen].bounds.size.height/M_Higth

@interface AppUtil : NSObject

+ (UIViewController *)appTopViewController;
+ (NSString *)getServerSego3;
+ (BOOL) isBlankString:(NSString *)string;
+ (BOOL) isValidateMobile:(NSString *)mobile;
@end
