//
//  YHViewController.m
//  YMPlayer
//
//  Created by HaryStep on 08/08/2023.
//  Copyright (c) 2023 HaryStep. All rights reserved.
//

#import "YHViewController.h"
#import <PPGameConfig.h>
#import <PPNetworkConfig.h>
#import <PPGameConfig.h>
#import <PPUserInfoService.h>

#import <SDGameModule.h>

@interface YHViewController ()

@end

@implementation YHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPPGameSDK];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:btn];
    [btn setTitle:@"Push coin" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    btn.tag = 0;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *click = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 50)];
    [self.view addSubview:click];
    [click setTitle:@"Arcade" forState:UIControlStateNormal];
    [click setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    click.tag = 1;
    [click addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClick:(UIButton *)sender {
        
    if(sender.tag == 0) {
        //8cfca025a66f  8cfca0212870  8cfca021289b                           3
        [SDGameModule presentViewController:@"8cfca025a66f" roomId:@"" machineType:3 inRootController:self];
    } else {
        //8cfca025a67c  8cfca02592c3  8cfca025a661  8cfca025a67f             4
        [SDGameModule presentViewController:@"8cfca02592c3" roomId:@"" machineType:4 inRootController:self];
    }
}

#pragma mark -
#pragma mark -- initPPGameSDK
- (void)initPPGameSDK{
    [[PPGameConfig sharedInstance] configGame];
    /// 需要更换请求地址
    [PPNetworkConfig sharedInstance].base_request_url = @"https://hyjjq-api.5iwanquan.com/api/";
    /// 更换 tcp请求的地址
    [PPNetworkConfig sharedInstance].base_my_host = @"123.60.149.177";
    /// 更换 tcp 请求的 port
    [PPNetworkConfig sharedInstance].base_my_port = 56792;
    //添加渠道参数
    [PPNetworkConfig sharedInstance].channelKey = @"huanyingjiejiquan";
    //8be27b1a0eb41b52687fd23aa7c34632  ad274f8a6faf17c0d814d23b2b3f0d31
    [[PPUserInfoService get_Instance] setAccess_token:@"e575b956e3e5fdc4dc3285825a7f6dd0"];
           
    
}

@end
