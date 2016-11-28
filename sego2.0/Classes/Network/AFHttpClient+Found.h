//
//  AFHttpClient+Found.h
//  sego2.0
//
//  Created by czx on 16/11/28.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "AFHttpClient.h"

@interface AFHttpClient (Found)
-(void)searchPlaycodeWithPlaycode:(NSString *)playcode complete:(void (^)(BaseModel * model))completeBlock;




@end
