//
//  Definition.h
//  sego2.0
//
//  Created by yulei on 16/11/8.
//  Copyright © 2016年 yulei. All rights reserved.
//

// 存放各种宏定义 存放宏的时候标注每个宏的作用



#ifndef Definition_h
#define Definition_h

//-------------------封装NSLog打印日志-------------------------
#define DEBUG_MODE 1
#if DEBUG_MODE
#define FuckLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif


//-------------------前台后台-------------------------
#define BACK_GCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)


#define MAIN_GCD(block) dispatch_async(dispatch_get_main_queue(),block)



//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//获取当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]





#endif /* Definition_h */
