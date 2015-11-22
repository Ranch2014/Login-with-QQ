//
//  ViewController.m
//  Login With QQ
//
//  Created by air on 15/9/4.
//  Copyright (c) 2015年 jaxer. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>

@interface ViewController ()
@property (strong, nonatomic) UIButton *loginButton; // 登录按钮
@property (strong, nonatomic) UIImageView *imageView; // 头像
@property (strong, nonatomic) UILabel *nickname; // 昵称
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@end

@implementation ViewController

// 异步加载图片
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _operationQueue = [[NSOperationQueue alloc] init];
    
    // 初始化昵称显示
    _nickname = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 30)];
    _nickname.backgroundColor = [UIColor yellowColor]; // 设置背景色
    _nickname.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nickname];
    
    // 初始化头像显示
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 150, 100, 100)];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 50.0f;
    [self.imageView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.imageView];
    
    // 初始化登录按钮
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 300, 100, 30)];
    [_loginButton setTitle:@"QQ登录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 5.0f;
    _loginButton.backgroundColor = [UIColor blueColor];
    [_loginButton addTarget:self
                     action:@selector(display)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self
                                                                     selector:@selector(display)
                                                                       object:nil];
    [_operationQueue addOperation:op];
}

// 显示昵称和头像
- (void)display {
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSLog(@"uid = %@",[userInfo uid]); // 打印输出用户uid
                                   NSLog(@"name = %@",[userInfo nickname]); // 打印输出用户昵称
                                   NSLog(@"icon = %@",[userInfo profileImage]); // 打印输出用户头像（QQ空间头像）地址
                                   NSLog(@"%@", [[userInfo sourceData] objectForKey:@"figureurl_qq_2"]); // 获取QQ头像
                                   
                                   // 显示昵称
                                   [_nickname setText:[userInfo nickname]];
                                   [_nickname setFont:[UIFont systemFontOfSize:16]];
                                   [_nickname setTextColor:[UIColor redColor]];
                                   
                                   // 显示头像
                                   NSURL *imageUrl = [NSURL URLWithString:[[userInfo sourceData] objectForKey:@"figureurl_qq_2"]];
                                   UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
                                   self.imageView.image = image;
                                   
                               } else {
                                   NSLog(@"授权失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                               }
                           }
     ];
    
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace]; // 取消授权
}

@end

