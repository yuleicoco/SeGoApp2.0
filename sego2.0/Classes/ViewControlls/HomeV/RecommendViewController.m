//
//  RecommendViewController.m
//  sego2.0
//
//  Created by czx on 16/12/16.
//  Copyright © 2016年 yulei. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"推荐"];
    UIWebView * web = [[UIWebView alloc]initWithFrame:CGRectMake(0 * W_Wide_Zoom, 0 * W_Hight_Zoom, 375 * W_Wide_Zoom, 727 * W_Hight_Zoom)];
    NSString * str = BASE_URL_Test2;
    str = [str stringByAppendingString:@"clientAction.do?method=client&nextPage=/s/recommend/article.jsp&access=inside&aid="];
    str = [str stringByAppendingString:_aid];
    NSURL * url = [NSURL URLWithString:str];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];

    
    
    
    
    
}


@end
