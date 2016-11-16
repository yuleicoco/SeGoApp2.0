//
//  AFHttpClient+Account.h
//  sego2.0
//
//  Created by czx on 16/11/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Account)
-(void)loginWithAccounynumber:(NSString *)accountnumber password:(NSString *)password complete:(void (^)(BaseModel * model))completeBlock;


@end
