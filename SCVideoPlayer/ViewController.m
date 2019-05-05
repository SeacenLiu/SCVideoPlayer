//
//  ViewController.m
//  SCVideoPlayer
//
//  Created by SeacenLiu on 2019/4/29.
//  Copyright © 2019 SeacenLiu. All rights reserved.
//

#import "ViewController.h"
#import "SCPlayerViewController.h"
#import "UIView+SCHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"本地文件" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setCenter:self.view.center];
    [btn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)testClick:(UIButton*)sender {
    SCPlayerViewController *pc = [SCPlayerViewController new];
    [self presentViewController:pc animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view showAutoDismissHUD:@"点击即可播放本地视频"];
}

@end
