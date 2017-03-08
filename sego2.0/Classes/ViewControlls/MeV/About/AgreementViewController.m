//
//  AgreementViewController.m
//  petegg
//
//  Created by czx on 16/5/4.
//  Copyright © 2016年 sego. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"注册协议"];
}
-(void)setupView{
    [super setupView];
    self.view.backgroundColor = LIGHT_GRAY_COLOR;
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 727 * W_Hight_Zoom)];
    NSString * str =  @"http://180.97.80.227:15102/clientAction.do?method=client&nextPage=/";
    
    
    str = [str stringByAppendingString:@"s/agreement/article.jsp"];
    NSURL * url = [NSURL URLWithString:str];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
}



@end
